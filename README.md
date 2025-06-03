# Snake-Game-with-FPGA

## 📌 Proje Tanımı
Digilent Basys 3 (Artix-7) FPGA kartı için geliştirilmiş klasik Snake oyununu. VGA çıkışı, PS/2 klavye kontrolü ve gerçek zamanlı skor takibi içerir.

## 🌟 Temel Özellikler
- **640x480 VGA Çıkışı** @ 60Hz
- **PS/2 Klavye Kontrolü** (WASD tuşları)
- **7-segment ekranda skor gösterimi**
- **Çarpışma algılama** (duvar ve kendine çarpma)
- **LFSR algoritmasıyla rastgele yem üretimi**
- **Oyun bitiş algılama** ile görsel geri bildirim

## 🛠 Donanım Gereksinimleri
| Bileşen | Özellikler |
|-----------|---------------|
| FPGA Kartı | Digilent Basys 3 (Artix-7 XC7A35T) |
| Görüntü | VGA Monitör (640x480 destekli) |
| Giriş | Standart PS/2 Klavye |
| Saat | 100MHz dahili osilatör |

## 📂 Proje Dizini
```markdown
fpga-snake-game/
├── src/
│ ├── snake_game.v (Ana oyun mantığı)
│ ├── vga_controller.v (VGA zamanlama üreteci)
│ ├── ps2_keyboard.v (PS/2 arayüzü)
│ ├── random_generator.v (Yem yerleşimi)
│ ├── clock_divider.v (Saat yönetimi)
│ └── seven_seg.v (Skor göstergesi)
├── constraints/
│ └── basys3.xdc (Pin bağlantıları)
├── sim/
│ └── tb_snake_game.v (Doğrulama testbench'i)
└── README.md
```

## 🔧 Kurulum
### Önkoşullar
- Vivado Design Suite (2020.1 veya üzeri)
- Digilent Kart Desteği Dosyaları

### Programlama Adımları
1. Depoyu klonlayın:
   ```bash
   git clone https://github.com/kullaniciadiniz/fpga-snake-game.git
2. Kaynak dosyaları ve kısıtlamaları ekleyin
3. Bitstream oluşturup FPGA'ye yükleyin

   

### 2. **Oyun Kontrolleri**:  
```markdown
## 🎮 Oyun Kontrolleri

| Tuş        | Aksiyon           |
|------------|-------------------|
| W          | Yukarı Hareket    |
| A          | Sola Hareket      |
| S          | Aşağı Hareket     |
| D          | Sağa Hareket      |
| Orta Buton | Oyunu Sıfırla     |

