DROP DATABASE IF EXISTS session07;
CREATE DATABASE session07;
USE session07;

-- Khóa học
CREATE TABLE Course (
    co_id INT PRIMARY KEY AUTO_INCREMENT,
    co_name VARCHAR(255) NOT NULL,
    co_time DATE,
    co_status ENUM('Hoạt động', 'Không hoạt động')
);

-- Môn học
CREATE TABLE Subjects (
    sub_id VARCHAR(5) PRIMARY KEY,
    sub_name VARCHAR(255) NOT NULL,
    sub_credit INT,
    sub_status ENUM('Hoạt động', 'Không hoạt động'),
    co_id INT,
    FOREIGN KEY (co_id) REFERENCES Course(co_id)
);

-- Sinh viên
CREATE TABLE Students (
    stu_id VARCHAR(5) PRIMARY KEY,
    stu_name VARCHAR(255) NOT NULL,
    stu_birth DATE,
    stu_sex ENUM('Nam', 'Nữ'),
    stu_number VARCHAR(10) UNIQUE,
    stu_email VARCHAR(250),
    stu_address VARCHAR(255),
    stu_status ENUM('Đang học', 'Bảo lưu', 'Đình chỉ', 'Tốt nghiệp')
);

-- CCCD
CREATE TABLE Card (
    ca_id INT PRIMARY KEY AUTO_INCREMENT,
    ca_num VARCHAR(12) NOT NULL UNIQUE,
    ca_date DATE,
    ca_placed VARCHAR(255),
    stu_id VARCHAR(5) UNIQUE,
    FOREIGN KEY (stu_id) REFERENCES Students(stu_id)
);

-- Đăng ký
CREATE TABLE Enrollment (
    en_id INT PRIMARY KEY AUTO_INCREMENT,
    sub_id VARCHAR(5),
    stu_id VARCHAR(5),
    en_points FLOAT,
    en_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (sub_id) REFERENCES Subjects(sub_id),
    FOREIGN KEY (stu_id) REFERENCES Students(stu_id)
);

INSERT INTO Course (co_name, co_time, co_status) VALUES 
('Công nghệ thông tin', '2023-09-01', 'Hoạt động'),
('Kế toán', '2023-08-02', 'Hoạt động'),
('Ngôn ngữ Anh', '2023-07-03', 'Hoạt động'),
('Quản trị kinh doanh', '2023-06-04', 'Không hoạt động'),
('Thiết kế đồ họa', '2023-01-05', 'Hoạt động');

INSERT INTO Subjects VALUES 
('MH01', 'Cấu trúc dữ liệu', 4, 'Hoạt động', 1),
('MH02', 'Kinh tế vĩ mô', 3, 'Hoạt động', 2),
('MH03', 'Tiếng Anh giao tiếp', 2, 'Không hoạt động', 3),
('MH04', 'Marketing căn bản', 3, 'Hoạt động', 4),
('MH05', 'Photoshop', 2, 'Hoạt động', 5);

INSERT INTO Students VALUES 
('SV001', 'Nguyễn Văn A', '2004-05-10', 'Nam', '0912345671', 'a@gmail.com', 'Hà Nội', 'Đang học'),
('SV002', 'Trần Thị B', '2004-08-20', 'Nữ', '0912345672', 'b@gmail.com', 'Đà Nẵng', 'Đang học'),
('SV003', 'Lê Văn C', '2003-01-15', 'Nam', '0912345673', 'c@gmail.com', 'HCM', 'Bảo lưu'),
('SV004', 'Phạm Minh D', '2004-12-30', 'Nam', '0912345674', 'd@gmail.com', 'Cần Thơ', 'Đang học'),
('SV005', 'Hoàng Thị E', '2002-03-05', 'Nữ', '0912345675', 'e@gmail.com', 'Hải Phòng', 'Tốt nghiệp');

INSERT INTO Card (ca_num, ca_date, ca_placed, stu_id) VALUES 
('123456789001', '2020-01-02', 'Cục CS QLHC', 'SV001'),
('123456789002', '2020-02-03', 'Cục CS QLHC', 'SV002'),
('123456789003', '2020-03-04', 'Cục CS QLHC', 'SV003'),
('123456789004', '2020-04-05', 'Cục CS QLHC', 'SV004'),
('123456789005', '2020-05-06', 'Cục CS QLHC', 'SV005');

INSERT INTO Enrollment (sub_id, stu_id, en_points) VALUES 
('MH01', 'SV001', 8.5),
('MH02', 'SV002', 7.0),
('MH03', 'SV003', 4.0),
('MH01', 'SV004', 9.0),
('MH05', 'SV005', 10.0);

-- Cập nhật môn học
UPDATE Subjects SET sub_name = 'Toán cao cấp', sub_credit = 3 
WHERE sub_id = 'MH01';

-- Xóa môn học
DELETE FROM Subjects WHERE sub_status = 'Không hoạt động';
/* Phân tích 
- Khi nào không xóa được:
+ Khi mã môn học đó (sub_id) có sinh viên đã đăng ký môn này
+ Nên nếu xóa thì bảng đăng ký sẽ không đọc được dữ liệu

- Khi nào xóa được: 
+ Khi môn học đó chưa có bất kỳ sinh viên nào đăng ký qua bảng đăng ký
*/

-- 3. Truy vấn cơ bản
-- a. Lấy thông tin các sinh viên gồm: mã sinh viên, tên sinh viên, số điện thoại, địa chỉ
SELECT stu_id, stu_name, stu_number, stu_address FROM Students;

-- b. Lấy thông tin các môn học chưa thuộc khóa học gồm: mã khóa học, tên khóa học, số tín chỉ
SELECT sub_id, sub_name, sub_credit FROM Subjects 
WHERE co_id IS NULL;

-- c. Lấy các mã khóa học đã có môn học
SELECT co_id FROM Subjects 
WHERE co_id IS NOT NULL;

-- d. Lấy thông tin các đăng ký gồm: mã sinh viên, tên sinh viên, ngày đăng ký, tên môn học đăng ký, điểm môn học, số căn cước công dân sắp xếp theo năm sinh giảm dần
SELECT s.stu_id, s.stu_name, e.en_date, sub.sub_name, e.en_points, c.ca_num
FROM Enrollment e
JOIN Students s ON e.stu_id = s.stu_id
JOIN Subjects sub ON e.sub_id = sub.sub_id
JOIN Card c ON s.stu_id = c.stu_id
ORDER BY s.stu_birth DESC;

-- 4. Truy vấn nâng cao sau:
-- a. Tính tổng số lần đăng ký của từng môn học
SELECT sub_id, COUNT(en_id) AS total_enrollments
 FROM Enrollment
GROUP BY sub_id;

-- b. Thống kê số môn học của từng khóa học
SELECT co.co_id, co.co_name, COUNT(sub.sub_id) AS total_subjects
FROM Course co
LEFT JOIN Subjects sub ON co.co_id = sub.co_id
GROUP BY co.co_id, co.co_name;

-- c. Tính điểm trung bình của sinh viên (điểm trung bình của tất cả các đăng ký)
SELECT s.stu_id, s.stu_name, 
AVG(e.en_points) AS average_score
FROM Students s
JOIN Enrollment e ON s.stu_id = e.stu_id
GROUP BY s.stu_id, s.stu_name;

-- d. Lấy thông tin các môn học có điểm trung bình lớn hơn 5 gồm: mã môn học, tên môn học, tên khóa học
SELECT sub.sub_id, sub.sub_name, co.co_name, 
AVG(e.en_points) as avg_score
FROM Subjects sub
JOIN Enrollment e ON sub.sub_id = e.sub_id
LEFT JOIN Course co ON sub.co_id = co.co_id
GROUP BY sub.sub_id, sub.sub_name, co.co_name
HAVING avg_score > 5;

-- e. Lấy thông tin các đăng ký có điểm lớn nhất gồm: mã sinh viên, tên sinh viên, tên môn học, điểm môn học
SELECT s.stu_id, s.stu_name, sub.sub_name, e.en_points
FROM Enrollment e
JOIN Students s ON e.stu_id = s.stu_id
JOIN Subjects sub ON e.sub_id = sub.sub_id
WHERE e.en_points = (SELECT MAX(en_points) FROM Enrollment);

-- f. Lấy thông tin sinh viên đã đăng ký môn học có điểm trung bình lớn nhất gồm: mã sinh viên, tên sinh viên, tuổi, tên môn học, tên khóa học
SELECT s.stu_id, s.stu_name, sub.sub_name, co.co_name
FROM Enrollment e