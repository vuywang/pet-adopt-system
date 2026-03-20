package com.kmbeast.pojo.vo;

import lombok.Data;

/**
 * 宠物经验帖子内容推荐候选项
 */
@Data
public class PetPostRecommendCandidateVO {
    /**
     * 帖子ID
     */
    private Integer id;
    /**
     * 宠物类别ID
     */
    private Integer petTypeId;
    /**
     * 宠物类别名
     */
    private String petTypeName;
    /**
     * 标题
     */
    private String title;
    /**
     * 摘要
     */
    private String summary;
    /**
     * 正文
     */
    private String content;
    /**
     * 审核状态
     */
    private Boolean isAudit;
}
