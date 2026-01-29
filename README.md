# 📱 Company System

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

### 1️ Giriş Ekranı
<img src="./Company_System_2/app/assets/login.jpeg" width="300" />

### 2️ Kayıt Ekranı
<img src="./Company_System_2/app/assets/register.jpeg" width="300" />

### 3️ Ana Ekran
<img src="./Company_System_2/app/assets/home.jpeg" width="300" />

### 4️ Menü
<img src="./Company_System_2/app/assets/menu.jpeg" width="300" />

### 5 Departman 
<img src="./Company_System_2/app/assets/department.jpeg" width="300" />

### 6 Personel
<img src="./Company_System_2/app/assets/personel.jpeg" width="300" />

### 7 Toplantı Odası & Rezervasyon
<img src="./Company_System_2/app/assets/meet.jpeg" width="300" />

### 8 İş Atama & Takip
<img src="./Company_System_2/app/assets/job.jpeg" width="300" />

### 9 Raporlama Ekranı
<img src="./Company_System_2/app/assets/rapor.jpeg" width="300" />

### 10 Profil
<img src="./Company_System_2/app/assets/profile.jpeg" width="300" />

---

## 🛠️ Kullanılan Teknolojiler

- **Flutter** – Mobil uygulama geliştirme
- **Dart** – Uygulama dili
- **MongoDB Cloud** – Veritabanı
- **RESTful API** – Backend iletişimi
