# singleTree

LiDAR Point Cloud Single Tree Stem Classification

 Bu çalışma, el lidarı ile elde edilen veriler kullanarak tek ağaç özelliklerinden biri olan gövdenin nokta bulutlarından çıkarımı için yapılmıştır.
 
Çalışma, Artvin Çoruh Üniversitesi Orman Fakültesi ve Mühendislik Fakültesi Harita Mühendisliği Bölümü tarafından yürütülmektedir.

Çalışmada kullanılan nokta bulutları Doğu Karadeniz ormanlarında sürdürülmektedir.

Buradaki R kodları doğrudan veya değiştirilerek kullanıma açıktır.

Yalnızca refere edilmesi yeterlidir.

Tek ağaç gövdesinin çıkarımı, göğüs çap değeri (DBH), ağaç boyu tespiti vb. pek çok işlem öncesinde önemli bir çalışmayı barındırır.

## How to use
You can use this code for single tree stem extraction from handheld LiDAR point cloud or other derived point clouds with run in the any R software.

Çalışmada kullanılabilecek kodlar R kodlarıdır. Farklı kütüphanelerden yararlanılarak yazılmıştır. Bu kütüphaneler kodların üst kısımlarında, library(..) şeklinde verilmektedir.

Tek ağaç çıkarımı öncesinde Voxelizasyon ile seyreltme, DTM bazlı normalizasyon ve kesitlerin çıkarımı yapılabilmektedir.
Kesitlerdeki özelliklerin çıkarımı kovaryans matrisleri ile yapılmaktadır. Bunun için her bir noktaya ait yakın komşu noktalar belirlenerek kovaryans matrisleri hesaplanır. Kovaryans matrislerinden özdeğer ve özvektörler yardımıyla da noktalara ait geometrik özellikler hesaplanır.

Farklı sınıflandırma yöntemleri uygulanabilmektedir. Bunun için makine öğrenme teknikleri uygulanmaktadır. Manuel sınıflandırılmış verilerle makine sınıflandırıcıları eğitilerek modeller elde edilir. Bu modeller yardımıyla test - doğruluk değerleri elde edilir. Bu sayede modelemizin doğruluğu sınanır.

Modelimiz elde edildikten sonra artık yeni nokta bulutlarının bu model ile sınıflandırılması tahminleme (prediction) aşamasında yapılmaktadır.

Daha sonra modelin sınıflandırılması iyileştirilebilmektedir. Bu da Gauss karışım modeliyle yapılmaktadır (optimizasyon).
Sınıflar elde edildikten sonra ayrı sınıf alanlarında veya dosyalarda çıktısı alınabilir.

Not: Bu kodların kullanımı için orta seviye ve üzeri R programlama bilmeniz tavsiye edilir (https://www.r-project.org/).

### Referanslar:
VATANDAŞLAR, Can, and Mustafa ZEYBEK. "Application of handheld laser scanning technology for forest inventory purposes in the NE Turkey." Turkish Journal of Agriculture and Forestry (2020): 44, doi:10.3906/tar-1903-40.

![Artvin-Kent-Ormanı6-812x566](https://user-images.githubusercontent.com/16136052/75098302-620a9380-55c5-11ea-97a1-cd47a2e2b485.jpg)

![timthumb](https://user-images.githubusercontent.com/16136052/75098407-de51a680-55c6-11ea-9612-68dfefc1033c.jpeg)
images/Artvin-Kent-Ormanı6-812x566.jpg

