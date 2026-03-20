package com.kmbeast.pojo.vo;

import lombok.Data;

/**
 * 宠物内容推荐候选项
 */
@Data
public class PetRecommendCandidateVO {
    /**
     * 宠物ID
     */
    private Integer id;
    /**
     * 宠物名
     */
    private String name;
    /**
     * 宠物描述
     */
    private String detail;
    /**
     * 宠物所在地
     */
    private String address;
    /**
     * 宠物年龄
     */
    private Integer age;
    /**
     * 宠物性别
     */
    private Integer gender;
    /**
     * 宠物类别ID
     */
    private Integer petTypeId;
    /**
     * 宠物类别名
     */
    private String petTypeName;
    /**
     * 是否接种疫苗
     */
    private Boolean isVaccine;
    /**
     * 是否已领养
     */
    private Boolean isAdopt;
}
