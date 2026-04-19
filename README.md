# 🏨 HỆ THỐNG ĐẶT PHÒNG TRỰC TUYẾN NOWAYHOME.
---

**Tổ chức:** NoWayHomee
**Tài liệu:** Thiết kế Kiến trúc, Logic xử lý và Cơ sở dữ liệu

Tài liệu này cung cấp cái nhìn tổng thể về thiết kế của hệ thống NoWayHome, bao gồm mô hình dữ liệu, phân rã chức năng và luồng xử lý nghiệp vụ cho ba phân hệ chính: **Khách hàng**, **Đối tác** và **Quản trị viên (Admin)**.

---

- 📅 **[NHẬT KÝ ĐỒ ÁN (PROJECT LOG)](https://drive.google.com/drive/folders/1pZyBHOuhf49qzH8Vw7Kwgocv-muJhbqq)**

---

## 🌐 1. Sơ Đồ Tổng Quan Hệ Thống (System Overview)

Sơ đồ Use Case tổng quan thể hiện các **tác nhân (Actors)** và những **chức năng mức cao nhất** mà hệ thống cung cấp.

<p align="center">
  <img src="diagrams/UseCase%20tổng%20quan%20Toàn%20Hệ%20Thống.png" width="75%" alt="UC Tổng quan">
  <br>
  <i>Hình 1: Sơ đồ Use Case tổng quan toàn bộ hệ thống</i>
</p>

> 🔗 [Mở UC Tổng quan trên draw.io](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=0&page=6&title=NoWayHome.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1E2XdDDvcfCm3aD3TmFTymMHeSQF2c1DT%26export%3Ddownload)

---

## 👤 2. Phân Hệ Khách Hàng (Customer Module)

Phân hệ dành cho **người dùng cuối (End-user)** thực hiện các thao tác **tìm kiếm**, **đặt phòng** và **quản lý tài khoản**.


### 2.1. Use Case Tổng Quan Khách Hàng
<br>

<p align="center">
  <img src="diagrams/UseCase%20tổng%20quan%20phân%20hệ%20Khách%20Hàng.png" width="80%" alt="UC Khách hàng">
  <br>
  <i>Hình 2.1: Sơ đồ Use Case phân hệ Khách hàng</i>
</p>

> 🔗 [Mở UC Khách hàng trên draw.io](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=0&page=7&title=NoWayHome.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1E2XdDDvcfCm3aD3TmFTymMHeSQF2c1DT%26export%3Ddownload)

### 2.2. Phân Rã Chức Năng (WBS) Khách Hàng
<br>

<p align="center">
  <img src="diagrams/Biểu%20đồ%20phân%20rã%20chức%20năng%20Khách%20hàng.png" width="85%" alt="Phân rã chức năng Khách hàng">
  <br>
  <i>Hình 2.2: Biểu đồ phân rã chức năng (WBS) phân hệ Khách hàng</i>
</p>

> 🔗 [Mở PRCN Khách hàng trên draw.io](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=0&page=0&title=NoWayHome.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1E2XdDDvcfCm3aD3TmFTymMHeSQF2c1DT%26export%3Ddownload)

### 2.3. Luồng Xử Lý Tuần Tự (Sequence Diagram) Khách Hàng
<br>

<p align="center">
  <img src="diagrams/Luồng%20Khách%20Hàng.png" width="90%" alt="Luồng tuần tự Khách hàng">
  <br>
  <i>Hình 2.3: Luồng xử lý tuần tự (Sequence Diagram) phân hệ Khách hàng</i>
</p>

> 🔗 [Mở Luồng Khách Hàng trên draw.io](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=0&page=3&title=NoWayHome.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1E2XdDDvcfCm3aD3TmFTymMHeSQF2c1DT%26export%3Ddownload)

---

## 🏢 3. Phân Hệ Đối Tác (Partner/Host Module)

Phân hệ dành cho **chủ khách sạn/chỗ nghỉ (Host)** để **quản lý phòng**, **giá cả** và theo dõi **đơn đặt phòng**.

### 3.1. Use Case Tổng Quan Đối Tác

<p align="center">
  <img src="diagrams/UseCase%20tổng%20quan%20phân%20hệ%20Đối%20Tác.png" width="80%" alt="UC Đối tác">
  <br>
  <i>Hình 3.1: Sơ đồ Use Case phân hệ Đối tác</i>
</p>

> 🔗 [Mở UC Đối tác trên draw.io](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=0&page=4&title=NoWayHome.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1E2XdDDvcfCm3aD3TmFTymMHeSQF2c1DT%26export%3Ddownload)

### 3.2. Phân Rã Chức Năng (WBS) Đối Tác

<p align="center">
  <img src="diagrams/Biểu%20đồ%20phân%20rã%20chức%20năng%20Đối%20tác.png" width="85%" alt="Phân rã chức năng Đối tác">
  <br>
  <i>Hình 3.2: Biểu đồ phân rã chức năng (WBS) phân hệ Đối tác</i>
</p>

> 🔗 [Mở PRCN Đối tác trên draw.io](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=0&page=1&title=NoWayHome.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1E2XdDDvcfCm3aD3TmFTymMHeSQF2c1DT%26export%3Ddownload)

### 3.3. Luồng Xử Lý Tuần Tự (Sequence Diagram) Đối Tác

<p align="center">
  <img src="diagrams/Luồng%20Đối%20tác.png" width="90%" alt="Luồng tuần tự Đối tác">
  <br>
  <i>Hình 3.3: Luồng xử lý tuần tự (Sequence Diagram) phân hệ Đối tác</i>
</p>

> 🔗 [Mở Luồng Đối tác trên draw.io](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=0&page=4&title=NoWayHome.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1E2XdDDvcfCm3aD3TmFTymMHeSQF2c1DT%26export%3Ddownload)

---

## 🛡️ 4. Phân Hệ Quản Trị Viên (Admin Module)

Phân hệ dành cho **ban quản trị hệ thống** NoWayHome để **kiểm duyệt đối tác**, **quản lý người dùng** và **thống kê doanh thu**.

### 4.1. Use Case Tổng Quan Admin

<p align="center">
  <img src="diagrams/UseCase%20tổng%20quan%20phân%20hệ%20Admin.png" width="80%" alt="UC Admin">
  <br>
  <i>Hình 4.1: Sơ đồ Use Case phân hệ Admin</i>
</p>

> 🔗 [Mở UC Admin trên draw.io](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=0&page=9&title=NoWayHome.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1E2XdDDvcfCm3aD3TmFTymMHeSQF2c1DT%26export%3Ddownload)

### 4.2. Phân Rã Chức Năng (WBS) Admin

<p align="center">
  <img src="diagrams/Biểu%20đồ%20phân%20rã%20chức%20năng%20Admin.png" width="85%" alt="Phân rã chức năng Admin">
  <br>
  <i>Hình 4.2: Biểu đồ phân rã chức năng (WBS) phân hệ Admin</i>
</p>

> 🔗 [Mở PRCN Admin trên draw.io](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=0&page=2&title=NoWayHome.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1E2XdDDvcfCm3aD3TmFTymMHeSQF2c1DT%26export%3Ddownload)

### 4.3. Luồng Xử Lý Tuần Tự (Sequence Diagram) Admin

<p align="center">
  <img src="diagrams/Luồng%20Admin.png" width="90%" alt="Luồng tuần tự Admin">
  <br>
  <i>Hình 4.3: Luồng xử lý tuần tự (Sequence Diagram) phân hệ Admin</i>
</p>

> 🔗 [Mở Luồng Admin trên draw.io](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=0&page=5&title=NoWayHome.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1E2XdDDvcfCm3aD3TmFTymMHeSQF2c1DT%26export%3Ddownload)

---

## 🔗 5. Tài liệu kỹ thuật trực tuyến (Interactive Documentation)

Để hỗ trợ việc **tra cứu nhanh cấu trúc bảng** và các **ràng buộc dữ liệu** mà không cần truy cập vào hệ quản trị CSDL, nhóm đã triển khai **giao diện tra cứu trực tuyến (Read-only)**:

> ### 🖥️ **[Xem Database web](https://nowayhomedb.tiiny.site/)**
>
> _(Giao diện hỗ trợ tra cứu nhanh định nghĩa các bảng, kiểu dữ liệu và mối quan hệ thực thể)_

---

<p align="center">
  <b>NoWayHome Project</b> • <i>Senior Technical Consultant Verified</i>
</p>