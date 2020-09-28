--������ ����İ� 2018011798 5.13
--�������ݿ�
--create database test
--ʹ�����ݿ�
--use test
--����������
--student��
create table student
(
	sno char(6) primary key,
	sname varchar(50) not null,
	sex char(2) check(sex in ('��','Ů')),
	dept varchar(20) check(dept in('��Ϣϵ','�������ѧϵ','��ѧϵ','����ϵ','����ϵ','����ϵ','��ѧϵ')),
	birth datetime,
	age smallint check(age between 0 and 100)
);
--course�γ̱�
create table course
(
	cno int primary key,
	cname varchar(20) not null
);
--cs�ɼ���
create table cs
(
	sno char(6),
	cno int,
	cj int check(cj between 0 and 100),
	primary key(sno,cno),
	foreign key (sno) references student(sno),
	foreign key (cno) references course(cno)
);
--���ѧ���γ����ݿ�Ĳ�ѯ
--(1)��ѯȫ��ѧ����������ѧ�š�����ϵ�����ñ�����ʾ�������
select sname ����,sno ѧ��,dept ����ϵ
from student;
--(2)��ѯ��Ϣϵ����ѧϵ�ͼ������ѧϵѧ�����������Ա�
select sname,sex
from student
where dept in ('��Ϣϵ','��ѧϵ','�������ѧϵ');
--(3)��ѯ��������ѧ����������ѧ�ź��Ա�
select sname,sno,sex
from student
where sname like '��%';
--(4)��ѯ��"DB_"��ͷ���ҵ�����3���ַ�Ϊ i�Ŀγ̵���ϸ�����
select *
from course
where cname like 'DB\_%i__' escape '\';
--(5)��ѯÿ��ѧ��ѡ�޿γ̵���ѧ�֡�
select sum(cj)
from cs
group by sno;
--(6)��ѯÿ��ѧ����ѧ�š�������ѡ�޵Ŀγ������ɼ���
select student.sno,sname,cname,cj
from student,cs,course
where student.sno = cs.sno and
	course.cno = cs.cno;
--(7)��ѯ����ѡ����1�ſγ̵�ѧ�����������ֱ���Ƕ�ײ�ѯ������ѯ��
--Ƕ�ײ�ѯ
select sname
from student
where sno in
(
	select sno
	from cs
	where cno = '2'
);
--����ѯ
select sname
from student,cs
where student.sno = cs.sno
and cno = '2';

--(8)����һ����ͼView_s��ͨ�������ͼ�ҵ���ѡ���˿γ�1��ѡ���˿γ�2��ѧ������Ϣ��
go
create view View_s
as
select student.sno,sname,sex,dept,birth,age,cno,cj
from student,cs
where student.sno = cs.sno
and cno = '1' and cno = '2'
go;
--(9)��ѯƽ���ɼ�����85��ѧ��ѧ�ż�ƽ���ɼ���
select sno,avg(cj)
from cs
group by sno
having avg(cj) > 85;
--(10)Ҫ���Ѱѧ����������Ϣ�����Ҳ�ѯ����Ϣ���������ɸߵ����������������ȣ�����ѧ�Ŵӵ͵�������
select *
from student
order by age desc,sno asc;
--(11)��student(ѧ����)�в���һ�����ݣ����������ѧ��955008���Ա�Ϊ�У�ϵ��Ϊ����ϵ����������Ϊ1990/5/5������Ϊ30��
insert into student(sname,sno,sex,dept,birth,age) values('������','955008','��','����ϵ','1990/5/5','30');
--(12)ɾ��cs���гɼ�Ϊ�յ���Ϣ��
delete from cs
where cj is null;
--(13)�½�һ����¼��dll��������һ���û�dll������student��Ĳ�ѯ�������ɾ����Ȩ������dll��
create login dll with password = '123';
create user dll for login dll;
grant select,insert,delete on student to dll;
--(14)����dll��student��ɾ��Ȩ�ޡ�
revoke delete on student
from dll;
--(15)��course���е�credit�ֶ�����һ��constraintԼ����Լ������ΪC_credit,Ҫ��credit�ֶε�ȡֵΪ1-5֮���������
ALTER TABLE course
ADD CONSTRAINT C_credit CHECK (credit between 1 and 5);


--С��2
----����ֲ�����
--declare @coure_name varchar(20);
--declare @a int,@b int,@c int,@d int;
--select @a = 0,@b = 0,@c = 0,@d = 0;
----�����α�
--declare course_cursor cursor for 
--select cname
--from student,score,course
--where student.sno = score.sno and
--	course.cno = score.cno
--for read only;
----���α�
--open course_cursor;
----���α���ȡ����һ��
--fetch next from course_cursor
--into @coure_name;
----ѭ������
--while @@FETCH_STATUS = 0
--begin
--if @coure_name = '���������'
--set @a = @a +1;
--else if @coure_name = '����ϵͳ'
--set @b = @b +1;
--else if @coure_name = '���ֵ�·'
--set @c = @c +1;
--else 
--set @d = @d +1;
----���α���ȡ����һ��
--fetch next from course_cursor
--into @coure_name;
--end
----�ر��α�
--close course_cursor;
----�ͷ���Դ
--deallocate course_cursor;
--select @a ���������ѡ������,@b ����ϵͳѡ������,@c ���ֵ�·ѡ������,@d �ߵ���ѧѡ������;


--ʵ�ִ���༶�Ϳγ̣��õ�����༶���ſγ̵�ƽ���ֲ���ӡ--go--create proc proc_avergrade--	@class_no char(5),@course_name varchar(5),--	@average int out--as--begin--	select @average = avg(degree)--	from student,score,course--	where student.sno = score.sno and
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
