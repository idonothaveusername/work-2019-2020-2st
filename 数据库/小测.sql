--刘琳琳 软件四班 2018011798 5.13
--创建数据库
--create database test
--使用数据库
--use test
--创建基本表
--student表
create table student
(
	sno char(6) primary key,
	sname varchar(50) not null,
	sex char(2) check(sex in ('男','女')),
	dept varchar(20) check(dept in('信息系','计算机科学系','数学系','管理系','中文系','外语系','法学系')),
	birth datetime,
	age smallint check(age between 0 and 100)
);
--course课程表
create table course
(
	cno int primary key,
	cname varchar(20) not null
);
--cs成绩表
create table cs
(
	sno char(6),
	cno int,
	cj int check(cj between 0 and 100),
	primary key(sno,cno),
	foreign key (sno) references student(sno),
	foreign key (cno) references course(cno)
);
--针对学生课程数据库的查询
--(1)查询全体学生的姓名、学号、所在系，并用别名显示出结果。
select sname 姓名,sno 学号,dept 所在系
from student;
--(2)查询信息系、数学系和计算机科学系学生的姓名和性别。
select sname,sex
from student
where dept in ('信息系','数学系','计算机科学系');
--(3)查询所有姓刘学生的姓名、学号和性别。
select sname,sno,sex
from student
where sname like '刘%';
--(4)查询以"DB_"开头，且倒数第3个字符为 i的课程的详细情况。
select *
from course
where cname like 'DB\_%i__' escape '\';
--(5)查询每个学生选修课程的总学分。
select sum(cj)
from cs
group by sno;
--(6)查询每个学生的学号、姓名、选修的课程名及成绩。
select student.sno,sname,cname,cj
from student,cs,course
where student.sno = cs.sno and
	course.cno = cs.cno;
--(7)查询所有选修了1号课程的学生姓名。（分别用嵌套查询和连查询）
--嵌套查询
select sname
from student
where sno in
(
	select sno
	from cs
	where cno = '2'
);
--连查询
select sname
from student,cs
where student.sno = cs.sno
and cno = '2';

--(8)创建一个视图View_s，通过这个视图找到既选修了课程1又选修了课程2的学生的信息。
go
create view View_s
as
select student.sno,sname,sex,dept,birth,age,cno,cj
from student,cs
where student.sno = cs.sno
and cno = '1' and cno = '2'
go;
--(9)查询平均成绩大于85的学生学号及平均成绩。
select sno,avg(cj)
from cs
group by sno
having avg(cj) > 85;
--(10)要求查寻学生的所有信息，并且查询的信息按照年龄由高到低排序，如果年龄相等，则按照学号从低到高排序
select *
from student
order by age desc,sno asc;
--(11)向student(学生表)中插入一条数据：姓名华晨宇，学号955008，性别为男，系别为管理系，出生日期为1990/5/5，年龄为30。
insert into student(sname,sno,sex,dept,birth,age) values('华晨宇','955008','男','管理系','1990/5/5','30');
--(12)删除cs表中成绩为空的信息。
delete from cs
where cj is null;
--(13)新建一个登录名dll，并创建一个用户dll，并将student表的查询、插入和删除的权限授予dll。
create login dll with password = '123';
create user dll for login dll;
grant select,insert,delete on student to dll;
--(14)回收dll的student的删除权限。
revoke delete on student
from dll;
--(15)在course表中的credit字段增加一个constraint约束，约束名字为C_credit,要求credit字段的取值为1-5之间的整数。
ALTER TABLE course
ADD CONSTRAINT C_credit CHECK (credit between 1 and 5);


--小测2
----定义局部变量
--declare @coure_name varchar(20);
--declare @a int,@b int,@c int,@d int;
--select @a = 0,@b = 0,@c = 0,@d = 0;
----定义游标
--declare course_cursor cursor for 
--select cname
--from student,score,course
--where student.sno = score.sno and
--	course.cno = score.cno
--for read only;
----打开游标
--open course_cursor;
----从游标中取出第一行
--fetch next from course_cursor
--into @coure_name;
----循环处理
--while @@FETCH_STATUS = 0
--begin
--if @coure_name = '计算机导论'
--set @a = @a +1;
--else if @coure_name = '操作系统'
--set @b = @b +1;
--else if @coure_name = '数字电路'
--set @c = @c +1;
--else 
--set @d = @d +1;
----从游标中取出下一行
--fetch next from course_cursor
--into @coure_name;
--end
----关闭游标
--close course_cursor;
----释放资源
--deallocate course_cursor;
--select @a 计算机导论选课人数,@b 操作系统选课人数,@c 数字电路选课人数,@d 高等数学选课人数;


--实现传入班级和课程，得到这个班级这门课程的平均分并打印--go--create proc proc_avergrade--	@class_no char(5),@course_name varchar(5),--	@average int out--as--begin--	select @average = avg(degree)--	from student,score,course--	where student.sno = score.sno and
--		course.cno = score.cno and class = @class_no and--		cname = @course_name--end--go
--create function sc(@stu_no char(3))
--returns table
--as 
--return (
--	select student.sno,sname,cname,degree
--	from student,score,course
--	where student.sno = score.sno and
--		course.cno = score.cno and student.sno = @stu_no
--)
