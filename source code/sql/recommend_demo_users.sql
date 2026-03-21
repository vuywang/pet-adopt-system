USE pet_adopt_system;

-- 推荐算法演示用户与行为数据
-- 说明：
-- 1. 本脚本会创建两个测试用户：一个偏猫、一个偏狗。
-- 2. 密码字段直接使用双 MD5 值：14e1b600b1fd579f47433b88e8d85291
-- 3. 脚本假设目标库中已经存在以下内容 ID：
--    宠物：9, 10, 11, 12, 15, 16
--    帖子：10, 11, 12, 13, 14, 15

-- 清理旧演示数据
DELETE FROM active_net
WHERE user_id IN (
    SELECT id
    FROM (
        SELECT id
        FROM `user`
        WHERE account IN ('codex_cat_demo', 'codex_dog_demo')
    ) t
);

DELETE FROM `user`
WHERE account IN ('codex_cat_demo', 'codex_dog_demo');

-- 新建两个演示用户
INSERT INTO `user` (
    account, username, password, avatar, email,
    role, gender, birthday, phone, create_time
) VALUES
(
    'codex_cat_demo',
    'codex_cat_demo',
    '14e1b600b1fd579f47433b88e8d85291',
    NULL,
    'codex_cat_demo@test.com',
    2,
    NULL,
    NULL,
    NULL,
    NOW()
),
(
    'codex_dog_demo',
    'codex_dog_demo',
    '14e1b600b1fd579f47433b88e8d85291',
    NULL,
    'codex_dog_demo@test.com',
    2,
    NULL,
    NULL,
    NULL,
    NOW()
);

-- 偏猫用户：宠物收藏行为
INSERT INTO active_net (user_id, content_id, content_type, type, create_time)
SELECT u.id, x.content_id, 'PET', 3, NOW()
FROM `user` u
JOIN (
    SELECT 9 AS content_id
    UNION ALL SELECT 10
    UNION ALL SELECT 15
) x
WHERE u.account = 'codex_cat_demo';

-- 偏狗用户：宠物收藏行为
INSERT INTO active_net (user_id, content_id, content_type, type, create_time)
SELECT u.id, x.content_id, 'PET', 3, NOW()
FROM `user` u
JOIN (
    SELECT 11 AS content_id
    UNION ALL SELECT 12
    UNION ALL SELECT 16
) x
WHERE u.account = 'codex_dog_demo';

-- 偏猫用户：帖子收藏行为
INSERT INTO active_net (user_id, content_id, content_type, type, create_time)
SELECT u.id, x.content_id, 'PET-POST', 3, NOW()
FROM `user` u
JOIN (
    SELECT 10 AS content_id
    UNION ALL SELECT 11
    UNION ALL SELECT 12
) x
WHERE u.account = 'codex_cat_demo';

-- 偏狗用户：帖子收藏行为
INSERT INTO active_net (user_id, content_id, content_type, type, create_time)
SELECT u.id, x.content_id, 'PET-POST', 3, NOW()
FROM `user` u
JOIN (
    SELECT 13 AS content_id
    UNION ALL SELECT 14
    UNION ALL SELECT 15
) x
WHERE u.account = 'codex_dog_demo';

-- 校验查询：查看两个用户
SELECT id, account, username, role, create_time
FROM `user`
WHERE account IN ('codex_cat_demo', 'codex_dog_demo');

-- 校验查询：查看行为写入结果
SELECT an.id, u.account, an.content_id, an.content_type, an.type, an.create_time
FROM active_net an
JOIN `user` u ON u.id = an.user_id
WHERE u.account IN ('codex_cat_demo', 'codex_dog_demo')
ORDER BY u.account, an.content_type, an.id;
