

CREATE TABLE student(
 `学号` VARCHAR(32) NOT NULL PRIMARY KEY,
 `姓名` VARCHAR(32) NOT NULL,
 `出生日期` DATE NOT NULL,
 `性别` VARCHAR(32) NOT NULL); 
 
 CREATE TABLE score(
 `学号` VARCHAR(32) NOT NULL,
 `课程号` VARCHAR(32) NOT NULL,
 `成绩` FLOAT NOT NULL,
 PRIMARY KEY(`学号`,`课程号`)); 
 
 CREATE TABLE course(
 `课程号` VARCHAR(32) NOT NULL PRIMARY KEY,
 `课程名称` VARCHAR(32) NOT NULL,
 `教师号` FLOAT NOT NULL ); 
 
 CREATE TABLE teacher(
 `教师号` VARCHAR(32) NOT NULL PRIMARY KEY,
 `教师姓名` VARCHAR(32)); 
 
 -- 添加测试数据 student 表
 INSERT INTO student VALUES('0001','猴子','1989-01-01','男'),('0002','猴子','1990-12-21','女'),
                           ('0003','马云','1991-12-21','男'),('0004','王思聪','1990-5-20','男');
 SELECT * FROM student;
 
 -- 往score表添加数据
  INSERT INTO score VALUES('0001','0001','80'),('0001','0002','90'),
                          ('0001','0003','99'),('0002','0002','60'),
                          ('0002','0003','80'),('0003','0001','80'),
                          ('0003','0002','80'),('0003','0003','80');
                          SELECT * FROM score
  -- 往course表添加数据
  INSERT INTO course VALUES('0001','语文','0002'),('0002','数学','0001'),
                          ('0003','英语','0003');
                          
  -- 往teacher 表添加数据
   INSERT INTO teacher VALUES('0001','梦渣渣'),('0002','马化腾'),
                             ('0003', NULL),('0004', '');
     SELECT * FROM teacher;
     
  -- 1.姓猴
  SELECT * FROM student WHERE `姓名` LIKE '猴%';
  
  -- 2.名猴
  SELECT * FROM student WHERE `姓名` LIKE '%猴'; -- 0个
  
  -- 3.带猴
  SELECT * FROM student WHERE `姓名` LIKE '%猴%';
  
  -- 4.姓孟的老师个数
  SELECT COUNT(*) FROM teacher WHERE `教师姓名` LIKE '孟%';
  
  -- 5.课程编号0002的总成绩
  SELECT SUM(`成绩`) FROM score WHERE 课程号= 0002; 
  
  -- 6.查询选了课程的学生人数
   SELECT COUNT(DISTINCT 学号) FROM score;
   
  -- 7.各科成绩最高和最低的分
  SELECT  a.课程号,课程名称, MAX(成绩),MIN(成绩) FROM score a JOIN course b ON a.课程号=b.课程号 GROUP BY a.课程号;
  
  -- 8.查询每门课程被选修的学生数
  SELECT 课程号,COUNT(学号) FROM score GROUP BY 课程号;
  
  -- 9 男，女人数
  SELECT 性别,COUNT(*) FROM student GROUP BY 性别;
  
  -- 10.平均成绩大于60分学生学号和平均成绩
  SELECT 学号,FORMAT(AVG(成绩),0) AS 平均成绩 FROM score GROUP BY 学号 HAVING AVG(成绩)>60;
  
  -- 11.查询至少选修两门课程的学生学号
  SELECT 学号 FROM score GROUP BY 学号 HAVING COUNT(课程号)> = 2;
   
  -- 12.查询同名同姓学生名单并统计同名人数
  SELECT 姓名,COUNT(*) AS 同名人数 FROM student GROUP BY 姓名 HAVING COUNT(*) >=2;
   
  -- 13.查询不及格的课程并按课程号从大到小排列
  SELECT 课程号 FROM score WHERE 成绩< 60 GROUP BY 课程号 ORDER BY 课程号 DESC; 
  
  -- 14.查询每门课程的平均成绩，结果按平均成绩升序排序，平均成绩相同时，按课程号降序排序（重要，排序相同时，再加一个排序对象即可）
  SELECT 课程号,AVG(成绩) FROM score GROUP BY 课程号 ORDER BY AVG(成绩),课程号 DESC; 
  
  -- 15.检索课程编号为0004且分数小于60的学生学号，结果按分数降序排列(重要，课程编号是字符串类型，记得加单引号括起来)
  SELECT 学号,成绩 FROM score WHERE 课程号 = '0004' AND 成绩< 60 ORDER BY 成绩 DESC;
   
  -- 16.要求输出课程号和选修人数，查询结果按人数降序排序，若人数相同，按课程号升序排序(超过2人的课程才统计)
  SELECT 课程号,COUNT(*) AS 人数 FROM score GROUP BY 课程号 HAVING COUNT(*)>2 ORDER BY COUNT(*) DESC,课程号;
  
  -- 17.查询两门以上不及格课程的同学的学号及其平均成绩
  SELECT 学号,AVG(成绩) FROM score WHERE 成绩< 60 GROUP BY 学号 HAVING COUNT(*)>2 
  
  -- 18.查询学生的总成绩并进行排名
  SELECT 学号,SUM(成绩) FROM score GROUP BY 学号 ORDER BY SUM(成绩);
  
  -- 19.查询平均成绩大于60分的学生的学号和平均成绩
  SELECT 学号,AVG(成绩) AS 平均成绩 FROM score GROUP BY 学号 HAVING AVG(成绩)>60
  
  -- 20.查询所有课程成绩小于60分学生的学号，姓名
  SELECT a.学号,姓名 FROM student a JOIN score b ON a.学号=b.学号 WHERE 成绩 <= 60 
  -- 或
  SELECT 学号,姓名 FROM student WHERE 学号 IN (SELECT 学号 FROM score WHERE 成绩 <= 60);
  
  -- 21.查询没有学全所有课程的学生的学号，姓名
  SELECT 学号,姓名 FROM student WHERE 学号 IN (SELECT 学号 FROM score GROUP BY 学号 HAVING COUNT(课程号) < (SELECT COUNT(课程号) FROM course)) 
 
 -- 22.查询只选修两门课程的全部学生的学号和姓名
   SELECT 学号,姓名 FROM student WHERE  学号 IN (SELECT 学号 FROM score GROUP BY 学号 HAVING COUNT(课程号)=2);
   
 -- 23.查询各学生的年龄 (精确到月份)
 SELECT 学号, DATEDIFF(出生日期,NOW())/30/12 FROM student 
 SELECT 学号, TIMESTAMPDIFF(DAY,出生日期,CURRENT_DATE())/12 FROM student;
 
 -- 24.查询本月过生日的学生
 SELECT 学号,姓名,出生日期 FROM student WHERE MONTH(出生日期)= MONTH(NOW());
 
 -- 25查询所有学生的学号，姓名，选课数，总成绩
 SELECT a.学号, 姓名,COUNT(课程号),SUM(成绩) FROM student a LEFT JOIN score b ON a.学号=b.学号 GROUP BY b.学号 
 
 -- 26.查询平均成绩大于85的所有学生的学号，姓名和平均成绩
 SELECT a.学号, 姓名,FORMAT(AVG(成绩),0) AS 平均成绩  FROM student a LEFT JOIN score b ON a.学号=b.学号 GROUP BY b.学号 HAVING AVG(成绩)>85; 
   
 -- 27.查询学生的选课情况：学号，姓名，课程号，课程名称
 SELECT a.学号,姓名,b.课程号,课程名称 FROM student a LEFT JOIN score b ON a.学号=b.学号 JOIN course c ON b.课程号 = c.课程号 
 
 -- （重点看）28.查询出每门课程及格人数和不及格人数
 SELECT 课程号,SUM(CASE WHEN 成绩>= 60 THEN 1 ELSE 0 END) AS 及格人数,
               SUM(CASE WHEN 成绩< 60 THEN 1 ELSE 0 END) AS 不及格人数
 FROM score GROUP BY 课程号
 
 -- （重点看）29.使用分段[100-85][85-70],[70-60],[<60]来统计各科成绩，分别统计：各分数段人数，课程号和课程名称
 SELECT a.课程号,b.课程名称,
         SUM(CASE WHEN 成绩 BETWEEN 85 AND 100 THEN 1 ELSE 0 END) AS '[100-85]',
         SUM(CASE WHEN 成绩>=70 AND 成绩<85 THEN 1 ELSE 0 END) AS '[85-70]',
         SUM(CASE WHEN 成绩>=60 AND 成绩<70 THEN 1 ELSE 0 END) AS '[85-70]',
         SUM(CASE WHEN 成绩<60 THEN 1 ELSE 0 END) AS '[<60]'
  FROM score a RIGHT JOIN course b ON a.课程号=b.课程号 GROUP BY a.课程号,b.课程名称
  
  -- 30.查询编号为0003且课程成绩在80分以上的学生的学号和姓名
  SELECT a.学号,a.姓名 FROM student a JOIN score b ON a.学号=b.学号 WHERE a.学号 = '0003' AND 成绩> 80
 
  -- 31.检索'0001'课程分数小于60，按分数降序排列的学生信息
  SELECT a.*,成绩 FROM student a JOIN score b ON a.学号=b.学号 WHERE 成绩< 60 AND 课程号 ='0002' ORDER BY 成绩 DESC  
  
  -- 32.查询不同老师所教不同课程平均分从高到低显示
  SELECT c.教师号,c.教师姓名,ROUND(AVG(a.成绩),0) AS 平均成绩
         FROM score a JOIN course b ON a.课程号=b.课程号 
         JOIN teacher c ON b.教师号=c.教师号 
         GROUP BY c.教师号,c.教师姓名
         ORDER BY AVG(a.成绩) DESC 
         
  -- 33.查询课程名称为‘数学’，且分数低于60的学生姓名和分数
  SELECT a.姓名,b.成绩 FROM student a JOIN score b ON a.学号=b.学号 
         JOIN course c ON b.课程号= c.课程号
        WHERE c.课程名称='数学' AND b.成绩< 60  
        
  -- 34.查询任何一门课程成绩在70分以上的姓名，课程名称和分数
         SELECT b.学号,a.姓名,c.课程名称,b.成绩
             FROM student a JOIN score b ON a.学号=b.学号 
             JOIN course c ON b.课程号= c.课程号
             WHERE b.成绩>70
          
        -- 或
             SELECT b.学号,a.姓名,c.课程名称,MIN(成绩)
             FROM student a JOIN score b ON a.学号=b.学号 
             JOIN course c ON b.课程号= c.课程号
             GROUP BY b.学号,c.课程名称
             HAVING MIN(成绩)>70 
             
      -- 35.查询两门及其以上及格课程的同学的学号，姓名和平均成绩
            SELECT a.学号,a.姓名,COUNT(*)
              FROM student a JOIN score b ON a.学号=b.学号
             WHERE 成绩>=60
             GROUP BY b.学号
             HAVING COUNT(*)>=2;
             
      -- (重点看)36.查询不同课程成绩相同的学生的学生编号，课程编号，学生成绩（表的自我复制）
           SELECT DISTINCT a.* FROM score a INNER JOIN score b ON a.学号= b.学号 WHERE  a.成绩 = b.成绩 AND a.课程号!= b.课程号       
                          
       -- 37.查询课程编号为0001的课程比0002的课程成绩高的所有学生的学号
            SELECT a.学号 FROM
             ( SELECT 学号,成绩  FROM score WHERE 课程号='0001') AS a
             INNER JOIN 
               ( SELECT 学号,成绩  FROM score WHERE 课程号='0002') AS b
               ON a.学号=b.学号
               INNER JOIN student c ON c.学号 = a.学号
               WHERE a.成绩>=b.成绩
               
        -- 38.查询学过"梦渣渣"老师所教的所有课的同学的学号，姓名
        SELECT a.学号,a.姓名,b.课程号,c.教师号,d.教师姓名
                 FROM student a  JOIN score b ON a.学号=b.学号 
                 JOIN course c ON b.课程号=c.课程号 JOIN teacher d ON c.教师号=d.教师号 
                 WHERE d.教师姓名='梦渣渣';
                 
        -- 39.查询没有学过‘梦渣渣’老师所授的任一门课程的学生姓名  任一门课 就可以找到学过梦老师教的，然后not in 即可
        SELECT 学号 FROM student WHERE 学号 NOT IN (SELECT a.学号 FROM student a  JOIN score b ON a.学号=b.学号 
                 JOIN course c ON b.课程号=c.课程号 JOIN teacher d ON c.教师号=d.教师号 
                 WHERE d.教师姓名='梦渣渣');
                 
         -- 40.查询选修‘梦渣渣’老师所授课程的学生中成绩最高的学生姓名及其成绩
           SELECT a.学号,a.姓名,b.成绩
                 FROM student a  JOIN score b ON a.学号=b.学号 
                 JOIN course c ON b.课程号=c.课程号 JOIN teacher d ON c.教师号=d.教师号 
                 WHERE d.教师姓名='梦渣渣'
                 ORDER BY b.成绩 DESC
                 LIMIT 1
                 
        -- 41.查询至少有一门课与学号‘0001’的学生所学课程相同的学生的学号和姓名
         SELECT DISTINCT a.学号,a.姓名 FROM student a JOIN score b ON a.学号 = b.学号 WHERE 课程号 IN(SELECT 课程号 FROM score WHERE 学号 = '0001')
             AND a.学号 !='0001'
             
         -- 42.按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
             SELECT a.学号,a.姓名,FORMAT(AVG(b.成绩),0) AS 平均成绩,SUM(b.成绩) AS 总成绩
             FROM student a JOIN score b ON a.学号 = b.学号 
             GROUP BY b.学号
             ORDER BY AVG(b.成绩) DESC
             
          -- （没看懂）
           SELECT a.学号,ROUND(AVG(a.成绩),0) AS 平均成绩,
           MAX(CASE WHEN b.课程名称 = '数学' THEN a.成绩 ELSE NULL END) AS '数学',
           MAX(CASE WHEN b.课程名称 = '语文' THEN a.成绩 ELSE NULL END) AS '语文',
           MAX(CASE WHEN b.课程名称 = '英语' THEN a.成绩 ELSE NULL END) AS '英语'
           FROM score a JOIN course b ON a.课程号=b.课程号
           GROUP BY a.学号;
           
      -- 43.查询学生平均成绩及其名次(使用专用窗口函数row_number 增加’排名‘一列)
          SELECT 学号,AVG(成绩),ROW_NUMBER() OVER(ORDER BY AVG(成绩) DESC)
          FROM score 
          GROUP BY 学号
          
      -- 44.查询学生平均成绩 及其名次（使用了row_number() over(order by )）
      SELECT 学号, FORMAT(AVG(成绩),0) AS 平均成绩,ROW_NUMBER() OVER(ORDER BY AVG(成绩) DESC) AS 名次 FROM score GROUP BY 学号;
      
      -- 45.按各科成绩进行排序，并显示排名（使用了row_number() over(partition by )）
      SELECT 课程号,成绩,ROW_NUMBER() OVER(PARTITION BY 课程号 ORDER BY 成绩)
      FROM score;
      
      -- 46.(重点看)查询每门功课成绩最好的前两名学生姓名
      SELECT a.课程号,b.姓名,a.成绩,a.ranking FROM (SELECT 课程号, 学号, 成绩, ROW_NUMBER() OVER(PARTITION BY 课程号 ORDER BY 成绩 DESC) 
       AS ranking FROM score) a
       JOIN student b ON a.学号 = b.学号
       WHERE a.ranking < 3; 
       
      -- 47.查询所有课程的成绩在第2名到第3名的学生信息以及该课程信息 
       SELECT a.课程号,b.姓名,a.成绩,a.ranking FROM (SELECT 课程号, 学号, 成绩, ROW_NUMBER() OVER(PARTITION BY 课程号 ORDER BY 成绩 DESC) 
       AS ranking FROM score) a
       JOIN student b ON a.学号 = b.学号
       WHERE a.ranking IN(2,3);
       
       -- 48.查询各科成绩前三名的记录
         SELECT a.课程号,b.姓名,a.成绩,a.ranking FROM (SELECT 课程号, 学号, 成绩, ROW_NUMBER() OVER(PARTITION BY 课程号 ORDER BY 成绩 DESC) 
       AS ranking FROM score) a
       JOIN student b ON a.学号 = b.学号
       WHERE a.ranking <=3
  
     
       

    
       SELECT TIMESTAMPDIFF(MONTH,'2013-06-01 09:00:00','2018-07-04 12:00:00');
       
         
            
               
                 
       
       --       
             