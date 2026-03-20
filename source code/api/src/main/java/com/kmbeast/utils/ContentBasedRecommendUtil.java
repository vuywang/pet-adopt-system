package com.kmbeast.utils;

import org.jsoup.Jsoup;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 基于内容的推荐工具类
 */
public final class ContentBasedRecommendUtil {

    private ContentBasedRecommendUtil() {
    }

    /**
     * 聚合用户历史内容，构建兴趣画像
     *
     * @param itemVectors         物品特征向量
     * @param interactionWeights  用户对物品的兴趣强度
     * @return 用户兴趣画像
     */
    public static Map<String, Double> buildUserProfile(Map<Integer, Map<String, Double>> itemVectors,
                                                       Map<Integer, Double> interactionWeights) {
        Map<String, Double> profile = new HashMap<>();
        interactionWeights.forEach((itemId, weight) -> {
            Map<String, Double> itemVector = itemVectors.get(itemId);
            if (itemVector == null) {
                return;
            }
            itemVector.forEach((feature, featureWeight) ->
                    profile.merge(feature, featureWeight * weight, Double::sum));
        });
        return profile;
    }

    /**
     * 计算候选内容与用户画像的相似度，并按得分降序返回
     *
     * @param itemVectors  物品特征向量
     * @param userProfile  用户画像
     * @param excludeIds   需要排除的物品ID
     * @param count        期望条数
     * @return 推荐内容ID列表
     */
    public static List<Integer> rankItems(Map<Integer, Map<String, Double>> itemVectors,
                                          Map<String, Double> userProfile,
                                          Set<Integer> excludeIds,
                                          Integer count) {
        if (userProfile.isEmpty()) {
            return new ArrayList<>();
        }
        int limit = count == null || count <= 0 ? 10 : count;
        // 只对候选集合排序，已经交互过的内容不再重复推荐。
        return itemVectors.entrySet().stream()
                .filter(entry -> !excludeIds.contains(entry.getKey()))
                .map(entry -> new RankedItem(entry.getKey(), cosineSimilarity(userProfile, entry.getValue())))
                .filter(item -> item.score > 0)
                .sorted(Comparator.comparing(RankedItem::getScore).reversed())
                .limit(limit)
                .map(RankedItem::getItemId)
                .collect(Collectors.toList());
    }

    /**
     * 计算两个向量的余弦相似度
     *
     * @param left  向量1
     * @param right 向量2
     * @return 相似度
     */
    public static double cosineSimilarity(Map<String, Double> left, Map<String, Double> right) {
        double dotProduct = 0D;
        double leftNorm = 0D;
        double rightNorm = 0D;
        for (Map.Entry<String, Double> entry : left.entrySet()) {
            double value = entry.getValue();
            leftNorm += value * value;
            Double rightValue = right.get(entry.getKey());
            if (rightValue != null) {
                dotProduct += value * rightValue;
            }
        }
        for (double value : right.values()) {
            rightNorm += value * value;
        }
        if (leftNorm == 0D || rightNorm == 0D) {
            return 0D;
        }
        return dotProduct / (Math.sqrt(leftNorm) * Math.sqrt(rightNorm));
    }

    /**
     * 分类特征编码
     */
    public static void addCategoricalFeature(Map<String, Double> vector, String prefix, Object value, double weight) {
        if (value == null) {
            return;
        }
        vector.merge(prefix + ":" + value, weight, Double::sum);
    }

    /**
     * 数值分桶后编码，避免年龄等连续值过于离散
     */
    public static void addBucketFeature(Map<String, Double> vector, String prefix, Integer value, double weight) {
        if (value == null) {
            return;
        }
        String bucket;
        if (value <= 6) {
            bucket = "baby";
        } else if (value <= 24) {
            bucket = "young";
        } else if (value <= 72) {
            bucket = "adult";
        } else {
            bucket = "senior";
        }
        vector.merge(prefix + ":" + bucket, weight, Double::sum);
    }

    /**
     * 文本特征编码
     */
    public static void addTextFeatures(Map<String, Double> vector, String prefix, String text, double weight) {
        tokenize(text).forEach(token -> vector.merge(prefix + ":" + token, weight, Double::sum));
    }

    /**
     * 将用户行为强度转成画像权重
     */
    public static double behaviorWeight(Integer type) {
        if (type == null) {
            return 0D;
        }
        switch (type) {
            case 1:
                return 1D;
            case 2:
                return 2D;
            case 3:
                return 3D;
            default:
                return 0D;
        }
    }

    /**
     * 简单分词：英文按词切分，中文按单字和双字切分
     */
    private static List<String> tokenize(String text) {
        String plainText = Jsoup.parse(text == null ? "" : text).text().toLowerCase(Locale.ROOT).trim();
        if (plainText.isEmpty()) {
            return Collections.emptyList();
        }
        List<String> tokens = new ArrayList<>();
        StringBuilder latinBuffer = new StringBuilder();
        StringBuilder cjkBuffer = new StringBuilder();
        for (int i = 0; i < plainText.length(); i++) {
            char ch = plainText.charAt(i);
            if (isCjk(ch)) {
                // 中文内容连续累积，统一在 flush 时拆成单字和双字特征。
                flushLatin(latinBuffer, tokens);
                cjkBuffer.append(ch);
                continue;
            }
            if (Character.isLetterOrDigit(ch)) {
                // 英文和数字保留为连续词，适合标题、地名、品牌名等场景。
                flushCjk(cjkBuffer, tokens);
                latinBuffer.append(ch);
                continue;
            }
            flushLatin(latinBuffer, tokens);
            flushCjk(cjkBuffer, tokens);
        }
        flushLatin(latinBuffer, tokens);
        flushCjk(cjkBuffer, tokens);
        return tokens;
    }

    private static void flushLatin(StringBuilder buffer, List<String> tokens) {
        if (buffer.length() < 2) {
            buffer.setLength(0);
            return;
        }
        tokens.add(buffer.toString());
        buffer.setLength(0);
    }

    private static void flushCjk(StringBuilder buffer, List<String> tokens) {
        if (buffer.length() == 0) {
            return;
        }
        // 中文同时保留单字和双字特征，避免没有分词依赖时完全失去语义信息。
        for (int i = 0; i < buffer.length(); i++) {
            tokens.add(String.valueOf(buffer.charAt(i)));
            if (i < buffer.length() - 1) {
                tokens.add(buffer.substring(i, i + 2));
            }
        }
        buffer.setLength(0);
    }

    private static boolean isCjk(char ch) {
        Character.UnicodeBlock unicodeBlock = Character.UnicodeBlock.of(ch);
        return unicodeBlock == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS
                || unicodeBlock == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
                || unicodeBlock == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_B
                || unicodeBlock == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS;
    }

    private static class RankedItem {
        private final Integer itemId;
        private final double score;

        private RankedItem(Integer itemId, double score) {
            this.itemId = itemId;
            this.score = score;
        }

        public Integer getItemId() {
            return itemId;
        }

        public double getScore() {
            return score;
        }
    }
}
