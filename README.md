# 📱 Company_System

Şirket içi iş süreçlerini dijital ortama taşıyan, yönetici, departman şefi ve personel rollerine sahip **mobil uygulama**.

---

## 🧠 Proje Tanımı

Company_System, şirket içindeki departman, personel, duyuru, toplantı ve iş takibi süreçlerini merkezi ve kolay yönetilebilir hale getirmek amacıyla geliştirilmiştir.

### 🔐 Sistem İşleyişi

1. Yönetici sisteme kayıt olur ve giriş yapar.
2. Yönetici, şirketine ait departmanları sisteme ekler.
3. Yönetici, eklediği departmanlara **Departman Şefleri** atar.
4. Departman şefleri, kendilerine verilen e-posta ve şifre ile sisteme giriş yapar.
5. Departman şefleri kendi departmanlarına bağlı personelleri sisteme ekler.
6. Tüm kullanıcılar profil sayfası üzerinden **şifre değişikliği** yapabilir.

---

## 👥 Kullanıcı Rolleri

### 👑 Yönetici
- Departman ekleme / silme / güncelleme
- Departman şefi atama
- Tüm duyuruları görme ve ekleme
- Tüm toplantı odalarını ve rezervasyonları görme
- İş atama ve genel iş takibi
- Raporları tarih ve saate göre görüntüleme

### 🧑‍💼 Departman Şefi
- Kendi departmanına personel ekleme
- Departman bazlı duyuru ekleme
- Toplantı odası ekleme ve rezervasyon yapma
- Yöneticiden gelen işleri alt parçalara bölerek personellere atama
- Departman içi iş takibi ve raporlama

### 👷 Personel
- Kendisine atanan işleri görüntüleme
- İşlerin ilerleme durumunu güncelleme
- Duyuruları görüntüleme

---

## 📢 Duyuru Sistemi

- **Yönetici duyuruları** → Tüm personeller tarafından görülür
- **Departman şefi duyuruları** →  
  - Yalnızca yönetici  
  - İlgili departmanın personelleri tarafından görülür

---

## 🏢 Toplantı Odası Yönetimi

- Yönetici ve departman şefleri:
  - Kendi yetki alanlarındaki toplantı odalarını sisteme ekler
  - Toplantı saatlerine göre rezervasyon oluşturur
- Çakışma kontrolü ile zaman yönetimi sağlanır

---

## 🗂️ İş Atama ve Takip Sistemi

- Yönetici:
  - Şirkete gelen işleri ilgili departman şefine atar
- Departman şefi:
  - Gelen işi alt görevlere böler
  - Personellerin yeteneklerine göre iş dağılımı yapar
- Personeller:
  - Kendilerine atanan işlerin ilerleme durumunu sisteme girer:
    - %25
    - %50
    - %75
    - %100

---

## 📊 Raporlama

- Yönetici ve departman şefleri:
  - İşlerin ilerleme durumunu
  - Tarih ve saat bazlı olarak
  - Raporlar sekmesinden takip edebilir

---

## 🖼️ Ekran Görüntüleri

### 1️⃣ Giriş Ekranı
![Login](./screenshots/1_login.png)

### 2️⃣ Kayıt Ekranı
![Register](./screenshots/2_admin_dashboard.png)

### 3️⃣ Departman Yönetimi
![Department](./screenshots/3_departments.png)

### 4️⃣ Personel Yönetimi
![Personnel](./screenshots/4_personnel.png)

### 5️⃣ Duyuru Ekranı
![Announcements](./screenshots/5_announcements.png)

### 6️⃣ Toplantı Odası & Rezervasyon
![Meeting Room](./screenshots/6_meeting_room.png)

### 7️⃣ İş Atama & Takip
![Task Management](./screenshots/7_tasks.png)

### 8️⃣ Raporlama Ekranı
![Reports](./screenshots/8_reports.png)

---

## 🛠️ Kullanılan Teknolojiler

- **Flutter** – Mobil uygulama geliştirme
- **Dart** – Uygulama dili
- **MongoDB Cloud** – Veritabanı
- **RESTful API** – Backend iletişimi
