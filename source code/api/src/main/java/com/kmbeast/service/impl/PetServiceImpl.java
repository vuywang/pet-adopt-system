package com.kmbeast.service.impl;

import com.kmbeast.context.LocalThreadHolder;
import com.kmbeast.mapper.ActiveNetMapper;
import com.kmbeast.mapper.PetMapper;
import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.ActiveNetQueryDto;
import com.kmbeast.pojo.dto.PetQueryDto;
import com.kmbeast.pojo.em.ActiveNetType;
import com.kmbeast.pojo.em.IsAdoptEnum;
import com.kmbeast.pojo.em.IsRecommendEnum;
import com.kmbeast.pojo.entity.ActiveNet;
import com.kmbeast.pojo.entity.Pet;
import com.kmbeast.pojo.vo.PetListItemVO;
import com.kmbeast.pojo.vo.PetRecommendCandidateVO;
import com.kmbeast.pojo.vo.PetVO;
import com.kmbeast.pojo.vo.ScoreVO;
import com.kmbeast.service.PetService;
import com.kmbeast.utils.AssertUtils;
import com.kmbeast.utils.ContentBasedRecommendUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 宠物信息业务逻辑实现类
 *
 * @author B站「程序员辰星」原创出品
 */
@Service
public class PetServiceImpl implements PetService {

    @Resource
    private PetMapper petMapper;
    @Resource
    private ActiveNetMapper activeNetMapper;

    /**
     * 宠物信息新增
     *
     * @param pet 实体信息
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> save(Pet pet) {
        petParamCheck(pet);
        pet.setIsAdopt(IsAdoptEnum.NO_ADOPT.getStatus()); // 初始状态未领养
        pet.setCreateTime(LocalDateTime.now());
        petMapper.save(pet);
        return ApiResult.success("宠物信息新增成功");
    }

    /**
     * 宠物信息校验
     *
     * @param pet 宠物信息
     */
    private void petParamCheck(Pet pet) {
        AssertUtils.hasText(pet.getName(), "宠物名不能为空");
        AssertUtils.hasText(pet.getCover(), "请上传一张封面");
        AssertUtils.hasText(pet.getAddress(), "请补充宠物所在地");
        AssertUtils.hasText(pet.getDetail(), "请补充宠物描述");
        AssertUtils.notNull(pet.getPetTypeId(), "请选择宠物类型");
        AssertUtils.notNull(pet.getAge(), "请填写宠物年龄");
        AssertUtils.notNull(pet.getIsVaccine(), "请选择宠物是否已经接种疫苗");
        AssertUtils.notNull(pet.getIsRecommend(), "请选择是否推荐");
    }

    /**
     * 宠物信息修改
     *
     * @param pet 实体信息
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> update(Pet pet) {
        petParamCheck(pet);
        petMapper.update(pet);
        return ApiResult.success("宠物信息修改成功");
    }

    /**
     * 通过ID删除宠物
     *
     * @param id 主键ID
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> deleteById(Integer id) {
        petMapper.deleteById(id);
        return ApiResult.success("宠物信息删除成功");
    }

    /**
     * 通过宠物ID查询宠物信息
     *
     * @param id 主键ID
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<PetVO> getById(Integer id) {
        PetVO petVO = petMapper.getById(id);
        // 浏览逻辑实现
        ActiveNetQueryDto activeNetQueryDto = new ActiveNetQueryDto();
        activeNetQueryDto.setUserId(LocalThreadHolder.getUserId()); // 设置上用户ID
        activeNetQueryDto.setContentId(id); // 设置内容ID
        activeNetQueryDto.setContentType("PET"); // 标识查的是宠物模块类型
        activeNetQueryDto.setType(ActiveNetType.VIEW.getStatus()); // 声明为浏览类型
        Integer count = activeNetMapper.queryCount(activeNetQueryDto);
        if (count == 0) { // 证明用户没有针对宠物模块下面的宠物信息浏览过
            ActiveNet activeNet = new ActiveNet();
            activeNet.setUserId(LocalThreadHolder.getUserId());
            activeNet.setContentId(id);
            activeNet.setContentType("PET");
            activeNet.setType(ActiveNetType.VIEW.getStatus());
            activeNet.setCreateTime(LocalDateTime.now());
            activeNetMapper.insert(activeNet); // 浏览记录新增
        }
        return ApiResult.success(petVO);
    }

    /**
     * 游客通过宠物ID查询宠物信息
     *
     * @param id 主键ID
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<PetVO> viewById(Integer id) {
        return ApiResult.success(petMapper.getById(id));
    }

    /**
     * 查询宠物列表
     *
     * @param petQueryDto 查询条件类
     * @return Result<List < PetListItemVO>>  后台通用返回封装类
     */
    @Override
    public Result<List<PetListItemVO>> list(PetQueryDto petQueryDto) {
        List<PetListItemVO> petListItemVOS = petMapper.queryListItem(petQueryDto);
        Integer count = petMapper.queryCount(petQueryDto);
        return ApiResult.success(petListItemVOS, count);
    }

    /**
     * 查询手动推荐的宠物数据，类似于banner效果
     *
     * @return Result<List < PetListItemVO>>
     */
    @Override
    public Result<List<PetListItemVO>> recommend() {
        PetQueryDto petQueryDto = new PetQueryDto();
        petQueryDto.setIsRecommend(IsRecommendEnum.RECOMMEND.getStatus());
        List<PetListItemVO> petListItemVOS = petMapper.queryListItem(petQueryDto);
        if (!petListItemVOS.isEmpty()) {
            return ApiResult.success(petListItemVOS);
        }
        // 如果系统没有推荐，怎么办?
        PetQueryDto defaultPetQueryDto = new PetQueryDto();
        defaultPetQueryDto.setCurrent(0);
        defaultPetQueryDto.setSize(3);
        List<PetListItemVO> defaultPetListItemVOS = petMapper.queryListItem(defaultPetQueryDto);
        return ApiResult.success(defaultPetListItemVOS);
    }

    /**
     * 智能推荐宠物信息
     *
     * @param count 期望拿到的条数
     * @return Result<List < PetListItemVO>> 通用返回封装类
     * @author B站「程序员辰星」原创出品
     */
    @Override
    public Result<List<PetListItemVO>> autoRecommend(Integer count) {
        // 内容推荐依赖用户已有行为来构建兴趣画像，这里直接复用现有行为表。
        ActiveNetQueryDto activeNetQueryDto = new ActiveNetQueryDto();
        activeNetQueryDto.setUserId(LocalThreadHolder.getUserId());
        activeNetQueryDto.setContentType("PET");
        List<ActiveNet> activeNetList = activeNetMapper.query(activeNetQueryDto);
        List<Integer> recommendItems = buildPetContentRecommendations(activeNetList, count);
        System.out.println("为用户「" + LocalThreadHolder.getUserId() + "」推荐的宠物ID列表: " + recommendItems);
        // 内容推荐算不出结果时，保留现有热门浏览兜底逻辑。
        if (recommendItems.isEmpty()) {
            List<ScoreVO> scoreVOList = activeNetMapper.queryAllIds(
                    "PET",
                    ActiveNetType.VIEW.getStatus(),
                    count
            );
            if (scoreVOList.isEmpty()) {
                return ApiResult.success(new ArrayList<>());
            }
            List<Integer> petNetIds = scoreVOList.stream()
                    .map(ScoreVO::getContentId)
                    .collect(Collectors.toList());
            List<PetListItemVO> petListItemVOS = filterAvailablePets(petMapper.queryListItemByIds(petNetIds), count);
            return ApiResult.success(petListItemVOS);
        }
        List<PetListItemVO> petListItemVOS = filterAvailablePets(petMapper.queryListItemByIds(recommendItems), count);
        return ApiResult.success(petListItemVOS);
    }

    /**
     * 查询用户收藏的宠物信息
     *
     * @return Result<List < PetListItemVO>> 通用返回封装类
     */
    @Override
    public Result<List<PetListItemVO>> saveList() {
        // 先去查收藏了哪些？
        ActiveNetQueryDto activeNetQueryDto = new ActiveNetQueryDto();
        activeNetQueryDto.setUserId(LocalThreadHolder.getUserId()); // 设置用户的ID
        activeNetQueryDto.setContentType("PET"); // 设置查询的模块 - PET - 宠物模块
        activeNetQueryDto.setType(ActiveNetType.SAVE.getStatus()); // 查询宠物模块下面的是收藏的类型
        List<ActiveNet> activeNetList = activeNetMapper.query(activeNetQueryDto);
        if (activeNetList.isEmpty()) {
            return ApiResult.success(new ArrayList<>());
        }
        List<Integer> petIds = activeNetList.stream()
                .map(ActiveNet::getContentId)
                .collect(Collectors.toList());
        List<PetListItemVO> petListItemVOS = petMapper.queryListItemByIds(petIds);
        return ApiResult.success(petListItemVOS);
    }

    /**
     * 基于内容特征推荐宠物
     */
    private List<Integer> buildPetContentRecommendations(List<ActiveNet> activeNetList, Integer count) {
        if (activeNetList == null || activeNetList.isEmpty()) {
            return new ArrayList<>();
        }
        // 先把全部候选宠物转成特征向量，后续会和用户画像做相似度计算。
        Map<Integer, PetRecommendCandidateVO> candidateMap = petMapper.queryRecommendCandidates().stream()
                .filter(item -> !Boolean.TRUE.equals(item.getIsAdopt()))
                .collect(Collectors.toMap(PetRecommendCandidateVO::getId, item -> item));
        Map<Integer, Map<String, Double>> itemVectors = new HashMap<>();
        candidateMap.forEach((itemId, candidate) -> itemVectors.put(itemId, buildPetFeatureVector(candidate)));
        // 用户画像由历史交互过的宠物特征累加得到，收藏和点赞会比浏览权重更高。
        Map<Integer, Double> interactionWeights = aggregateInteractionWeights(activeNetList);
        Map<String, Double> userProfile = ContentBasedRecommendUtil.buildUserProfile(itemVectors, interactionWeights);
        Set<Integer> excludeIds = new HashSet<>(interactionWeights.keySet());
        return ContentBasedRecommendUtil.rankItems(itemVectors, userProfile, excludeIds, count);
    }

    /**
     * 构建单只宠物的内容特征
     */
    private Map<String, Double> buildPetFeatureVector(PetRecommendCandidateVO candidate) {
        Map<String, Double> vector = new HashMap<>();
        // 结构化字段权重更高，用来稳定推荐方向。
        ContentBasedRecommendUtil.addCategoricalFeature(vector, "petType", candidate.getPetTypeId(), 3D);
        ContentBasedRecommendUtil.addCategoricalFeature(vector, "petTypeName", candidate.getPetTypeName(), 2D);
        ContentBasedRecommendUtil.addCategoricalFeature(vector, "gender", candidate.getGender(), 1.5D);
        ContentBasedRecommendUtil.addCategoricalFeature(vector, "vaccine", candidate.getIsVaccine(), 1.5D);
        ContentBasedRecommendUtil.addBucketFeature(vector, "age", candidate.getAge(), 1.5D);
        // 文本字段负责补充细粒度语义，例如地区、标题词和描述词。
        ContentBasedRecommendUtil.addTextFeatures(vector, "name", candidate.getName(), 2D);
        ContentBasedRecommendUtil.addTextFeatures(vector, "address", candidate.getAddress(), 1.5D);
        ContentBasedRecommendUtil.addTextFeatures(vector, "detail", candidate.getDetail(), 1D);
        return vector;
    }

    /**
     * 聚合用户对宠物的行为强度
     */
    private Map<Integer, Double> aggregateInteractionWeights(List<ActiveNet> activeNetList) {
        Map<Integer, Double> weights = new HashMap<>();
        for (ActiveNet activeNet : activeNetList) {
            double behaviorWeight = ContentBasedRecommendUtil.behaviorWeight(activeNet.getType());
            if (behaviorWeight <= 0) {
                continue;
            }
            weights.merge(activeNet.getContentId(), behaviorWeight, Double::sum);
        }
        return weights;
    }

    /**
     * 过滤掉已经领养的宠物，避免兜底阶段把无效内容继续推荐给用户
     */
    private List<PetListItemVO> filterAvailablePets(List<PetListItemVO> pets, Integer count) {
        int limit = count == null || count <= 0 ? pets.size() : count;
        return pets.stream()
                .filter(pet -> !Boolean.TRUE.equals(pet.getIsAdopt()))
                .limit(limit)
                .collect(Collectors.toList());
    }
}
