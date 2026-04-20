USE pet_adopt_system;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Recommendation demo dataset
-- 20 pets + 20 pet posts + 2 demo users
-- Covers:
--   codex_pet_cover_901.png  ~ codex_pet_cover_920.png
--   codex_post_cover_901.png ~ codex_post_cover_920.png
-- Demo accounts:
--   recommend_cat_demo
--   recommend_dog_demo
-- Password field value:
--   14e1b600b1fd579f47433b88e8d85291

DELETE FROM active_net
WHERE (content_type = 'PET' AND content_id BETWEEN 901 AND 920)
   OR (content_type = 'PET-POST' AND content_id BETWEEN 901 AND 920)
   OR user_id BETWEEN 901 AND 906;

DELETE FROM pet_post WHERE id BETWEEN 901 AND 920;
DELETE FROM pet WHERE id BETWEEN 901 AND 920;
DELETE FROM `user` WHERE id BETWEEN 901 AND 906;

INSERT INTO `user` (
    id, account, username, password, avatar, email,
    role, gender, birthday, phone, create_time
) VALUES
(905, 'recommend_cat_demo', '偏猫推荐演示用户', '14e1b600b1fd579f47433b88e8d85291', '/api/v1.0/pet-adopt-api/file/getFile?fileName=17488801328625.png', 'recommend_cat_demo@example.com', 2, 1, '1998-04-15', '13810009005', '2026-04-01 09:04:00'),
(906, 'recommend_dog_demo', '偏狗推荐演示用户', '14e1b600b1fd579f47433b88e8d85291', '/api/v1.0/pet-adopt-api/file/getFile?fileName=17488801204072.png', 'recommend_dog_demo@example.com', 2, 0, '1997-07-28', '13810009006', '2026-04-01 09:05:00');

INSERT INTO pet (
    id, name, cover, detail, address, age, gender,
    pet_type_id, is_vaccine, is_recommend, is_adopt, create_time
) VALUES
(901, 'British Shorthair Luna', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_901.png', 'Calm indoor cat, likes a fixed routine, brushing, and quiet evenings. Good fit for a first cat owner.', 'Shanghai Pudong', 24, 0, 1, 1, 0, 0, '2026-04-01 10:00:00'),
(902, 'Ragdoll Mochi', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_902.png', 'Soft and gentle cat, friendly with people, adapts quickly to apartment life, and enjoys sunny windows.', 'Hangzhou Binjiang', 14, 1, 1, 1, 0, 0, '2026-04-01 10:05:00'),
(903, 'Tabby Pixel', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_903.png', 'Playful tabby cat with strong curiosity. Loves teaser toys, climbing shelves, and daily interaction.', 'Chengdu Gaoxin', 10, 0, 1, 1, 0, 0, '2026-04-01 10:10:00'),
(904, 'Silver Shaded Nori', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_904.png', 'Slow-warm cat who becomes affectionate after trust is built. Prefers a stable and peaceful home.', 'Beijing Chaoyang', 18, 1, 1, 1, 0, 0, '2026-04-01 10:15:00'),
(905, 'Blue White Snow', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_905.png', 'Elegant indoor cat with neat habits. Great for apartment living and a clean, quiet environment.', 'Wuhan Hongshan', 8, 0, 1, 0, 0, 0, '2026-04-01 10:20:00'),
(906, 'Orange Cat Mango', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_906.png', 'Food-motivated and very social cat. Best for families who enjoy frequent play and active interaction.', 'Guangzhou Tianhe', 12, 1, 1, 1, 0, 0, '2026-04-01 10:25:00'),
(907, 'Calico Berry', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_907.png', 'Easy-going calico cat, not picky with food, friendly with people, and suitable for beginners.', 'Nanjing Gulou', 9, 1, 1, 0, 0, 0, '2026-04-01 10:30:00'),
(908, 'Maine Coon Atlas', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_908.png', 'Large cat with a gentle personality. Needs strong cat furniture and a wider indoor activity area.', 'Suzhou SIP', 20, 0, 1, 1, 0, 0, '2026-04-01 10:35:00'),
(909, 'American Shorthair Cocoa', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_909.png', 'Steady cat for office workers. Likes a predictable feeding time and a quiet resting corner.', 'Shanghai Pudong', 16, 1, 1, 1, 0, 0, '2026-04-01 10:40:00'),
(910, 'Persian Cloud', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_910.png', 'Long-hair cat with a soft temperament. Better for calm homes that can handle regular grooming.', 'Hangzhou Xihu', 22, 1, 1, 1, 0, 0, '2026-04-01 10:45:00'),
(911, 'Border Collie Bolt', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_911.png', 'High-energy dog that needs exercise, recall training, and mental games every day.', 'Shenzhen Nanshan', 18, 0, 2, 1, 0, 0, '2026-04-01 11:00:00'),
(912, 'Golden Retriever Cola', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_912.png', 'Warm family dog, friendly with children, good outside on leash, and easy to bond with.', 'Suzhou SIP', 24, 0, 2, 1, 0, 0, '2026-04-01 11:05:00'),
(913, 'Labrador Biscuit', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_913.png', 'Stable companion dog that loves routines, fixed walks, and regular simple training.', 'Changsha Yuelu', 20, 1, 2, 1, 0, 0, '2026-04-01 11:10:00'),
(914, 'Corgi Bean', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_914.png', 'Short-leg dog with a cheerful personality. Great for beginners who can provide daily walks.', 'Chongqing Yubei', 14, 0, 2, 1, 0, 0, '2026-04-01 11:15:00'),
(915, 'Shiba Wheat', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_915.png', 'Independent dog with a healing smile. Better for owners who respect boundaries and patience.', 'Xiamen Siming', 12, 0, 2, 0, 0, 0, '2026-04-01 11:20:00'),
(916, 'Mini Schnauzer Dodo', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_916.png', 'Responsive small dog that does well with indoor training and short but regular outdoor walks.', 'Tianjin Hexi', 10, 1, 2, 1, 0, 0, '2026-04-01 11:25:00'),
(917, 'Village Dog Abo', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_917.png', 'Loyal mixed-breed dog, alert to the environment, and better for homes with a bit more space.', 'Zhengzhou Jinshui', 28, 0, 2, 1, 0, 0, '2026-04-01 11:30:00'),
(918, 'Samoyed Snowball', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_918.png', 'Friendly fluffy dog who loves outdoor play, social interaction, and regular coat care.', 'Wuhan Jiangxia', 16, 1, 2, 1, 0, 0, '2026-04-01 11:35:00'),
(919, 'Husky Windmill', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_919.png', 'Curious active dog that needs strong exercise and consistent training to stay balanced.', 'Chengdu Wuhou', 22, 0, 2, 1, 0, 0, '2026-04-01 11:40:00'),
(920, 'Beagle Chips', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_pet_cover_920.png', 'Companion dog with a strong nose drive. Suitable for families with regular outdoor time.', 'Guangzhou Haizhu', 15, 1, 2, 1, 0, 0, '2026-04-01 11:45:00');

INSERT INTO pet_post (
    id, user_id, pet_type_id, title, cover, content, summary, is_audit, create_time
) VALUES
(901, 905, 1, 'British Shorthair First Week', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_901.png', '<p>For a calm cat like a British Shorthair, the key is a fixed feeding schedule, a quiet room, and low-pressure interaction. Let the cat explore before forcing contact.</p>', 'A practical first-week cat settling guide for British Shorthair adopters.', 1, '2026-04-01 12:00:00'),
(902, 905, 1, 'Why Ragdolls Fit Beginners', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_902.png', '<p>Ragdoll cats are usually soft-tempered, social, and comfortable in apartments. Stable grooming and a quiet routine make a huge difference.</p>', 'A beginner-friendly cat post focused on Ragdoll temperament and home fit.', 1, '2026-04-01 12:05:00'),
(903, 905, 1, 'Tabby Cats Need Daily Play', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_903.png', '<p>For an active tabby cat, teaser toys, climbing spots, and daily play sessions matter more than extra treats. Good play can reduce stress fast.</p>', 'Daily play ideas for active tabby cat owners.', 1, '2026-04-01 12:10:00'),
(904, 905, 1, 'Trust Tips for Shy Cats', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_904.png', '<p>A slow-warm cat needs consistency: the same litter area, the same food corner, and the same light interaction times. Trust grows from routine.</p>', 'A low-pressure trust-building guide for shy indoor cats.', 1, '2026-04-01 12:15:00'),
(905, 905, 1, 'Cat Apartments Need Vertical Space', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_905.png', '<p>Vertical space matters. Window perches, cat trees, and calm sleeping corners help indoor cats feel safe and active at the same time.</p>', 'Why indoor cats need vertical space in small apartments.', 1, '2026-04-01 12:20:00'),
(906, 905, 1, 'Stress-Free Feeding for Orange Cats', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_906.png', '<p>Use fixed meal times, slower feeders, and short play before food. This works especially well for food-driven social cats.</p>', 'A feeding routine post for active orange cat households.', 1, '2026-04-01 12:25:00'),
(907, 905, 1, 'Calico Cats Need Calm Homes', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_907.png', '<p>Stable light, less noise, and a familiar litter area matter more than buying too many toys on day one.</p>', 'Simple home setup advice for first-time cat adopters.', 1, '2026-04-01 12:30:00'),
(908, 905, 1, 'Maine Coon Home Setup', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_908.png', '<p>A large cat needs durable cat trees, wider resting shelves, and stronger climbing furniture. Space planning changes the whole experience.</p>', 'Home layout advice for families adopting a large indoor cat.', 1, '2026-04-01 12:35:00'),
(909, 905, 1, 'Cats for Office Workers', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_909.png', '<p>Predictable meal times, clean litter, and fixed evening play are usually enough to keep a steady cat balanced and content.</p>', 'A cat routine post designed for office workers.', 1, '2026-04-01 12:40:00'),
(910, 905, 1, 'Persian Cat Grooming Rhythm', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_910.png', '<p>Regular brushing, eye cleaning, and a calm pace make Persian cat care much easier than most new owners expect.</p>', 'Daily care notes for long-hair cat homes.', 1, '2026-04-01 12:45:00'),
(911, 906, 2, 'Border Collie Training Plan', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_911.png', '<p>For a high-energy dog like a Border Collie, body exercise alone is not enough. Recall practice and short command training are just as important.</p>', 'Exercise and training ideas for a high-energy working dog.', 1, '2026-04-01 13:00:00'),
(912, 906, 2, 'Golden Retriever Family Rules', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_912.png', '<p>Golden Retrievers are warm dogs, but family life works best when leash rules, feeding, and play boundaries are consistent.</p>', 'A family-oriented dog care post for Golden Retriever homes.', 1, '2026-04-01 13:05:00'),
(913, 906, 2, 'Labradors Need Stable Routines', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_913.png', '<p>A Labrador becomes a better companion when walks, meals, and training stay predictable. Chaos usually leads to overexcitement.</p>', 'A companion dog routine guide built around Labrador habits.', 1, '2026-04-01 13:10:00'),
(914, 906, 2, 'Corgi Activity for Office Workers', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_914.png', '<p>Short but high-quality walks, indoor games, and simple obedience work can fit a Corgi well into an office-worker schedule.</p>', 'A practical exercise plan for a cheerful small dog.', 1, '2026-04-01 13:15:00'),
(915, 906, 2, 'Understanding Shiba Boundaries', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_915.png', '<p>A Shiba is not cold; it is independent. Trust grows through patience, lower pressure, and consistent expectations.</p>', 'A realistic expectation guide for independent dog breeds.', 1, '2026-04-01 13:20:00'),
(916, 906, 2, 'Mini Schnauzer Indoor Training', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_916.png', '<p>Responsive small dogs can learn indoor toilet spots, short commands, and calm leash behavior quickly when rewards stay consistent.</p>', 'Indoor training notes for a responsive small companion dog.', 1, '2026-04-01 13:25:00'),
(917, 906, 2, 'Mixed-Breed Dog Boundaries', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_917.png', '<p>For alert dogs, clear routes, fixed rest areas, and stable household rules reduce anxiety and make city life easier.</p>', 'Adaptation advice for alert mixed-breed dog homes.', 1, '2026-04-01 13:30:00'),
(918, 906, 2, 'Samoyed Care and Outdoor Time', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_918.png', '<p>Samoyeds are wonderful family dogs when owners accept the grooming rhythm and the need for frequent outdoor interaction.</p>', 'A realistic post about fluffy dog grooming and exercise needs.', 1, '2026-04-01 13:35:00'),
(919, 906, 2, 'Husky Behavior and Exercise', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_919.png', '<p>High-energy dogs often look destructive when exercise and rules are not enough. Better walks and structured games change a lot.</p>', 'Behavior management ideas for a very active dog.', 1, '2026-04-01 13:40:00'),
(920, 906, 2, 'Beagles and Scent Drive', '/api/v1.0/pet-adopt-api/file/getFile?fileName=codex_post_cover_920.png', '<p>Beagles are friendly, but leash guidance and attention management matter because scent can pull their focus away fast.</p>', 'A family companion dog post centered on Beagle behavior.', 1, '2026-04-01 13:45:00');

INSERT INTO active_net (user_id, content_id, content_type, type, create_time) VALUES
(905, 901, 'PET', 3, '2026-04-01 14:00:00'),
(905, 902, 'PET', 3, '2026-04-01 14:01:00'),
(905, 904, 'PET', 2, '2026-04-01 14:02:00'),
(905, 909, 'PET', 1, '2026-04-01 14:03:00'),
(905, 901, 'PET-POST', 3, '2026-04-01 14:04:00'),
(905, 902, 'PET-POST', 2, '2026-04-01 14:05:00'),
(905, 904, 'PET-POST', 3, '2026-04-01 14:06:00'),
(905, 909, 'PET-POST', 1, '2026-04-01 14:07:00');

INSERT INTO active_net (user_id, content_id, content_type, type, create_time) VALUES
(906, 911, 'PET', 3, '2026-04-01 14:10:00'),
(906, 912, 'PET', 3, '2026-04-01 14:11:00'),
(906, 914, 'PET', 2, '2026-04-01 14:12:00'),
(906, 918, 'PET', 1, '2026-04-01 14:13:00'),
(906, 911, 'PET-POST', 3, '2026-04-01 14:14:00'),
(906, 913, 'PET-POST', 2, '2026-04-01 14:15:00'),
(906, 915, 'PET-POST', 3, '2026-04-01 14:16:00'),
(906, 918, 'PET-POST', 1, '2026-04-01 14:17:00');

SELECT id, account, username, role, create_time
FROM `user`
WHERE id IN (905, 906)
ORDER BY id;

SELECT id, name, pet_type_id, cover, address, age, is_vaccine
FROM pet
WHERE id BETWEEN 901 AND 920
ORDER BY id;

SELECT id, title, pet_type_id, user_id, cover, is_audit
FROM pet_post
WHERE id BETWEEN 901 AND 920
ORDER BY id;

SELECT id, user_id, content_id, content_type, type, create_time
FROM active_net
WHERE user_id IN (905, 906)
ORDER BY user_id, content_type, create_time;

SET FOREIGN_KEY_CHECKS = 1;
