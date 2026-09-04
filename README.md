# SA-MP / open.mp TextDraw Memory Grid Mini-Game

Sistem minigame berbasis **TextDraw Interaktif** untuk SA-MP dan open.mp. Minigame ini menguji ingatan dan kecepatan pemain dalam menemukan angka target yang disembunyikan di dalam papan angka yang diacak secara otomatis.

---

## 👨‍💻 Author & Credits

* **Developer:** Billy Simonee (ANX)
* **Language:** Pawn
* **Platform:** SA-MP / open.mp

---

## 🎮 Cara Kerja Sistem (Mechanics)

1. **Inisialisasi Target:**
   * Saat minigame dimulai (`ShowPlayerMiniGame`), sistem memilih **6 angka acak unik** sebagai target utama.
   * Tiga dari 6 angka target tersebut dipilih secara acak menggunakan algoritma **Fisher-Yates Shuffle** untuk dijadikan **Hidden Target**.

2. **Mekanisme Transisi & Timer:**
   * Pada 3 detik pertama, seluruh angka target diperlihatkan kepada pemain agar dapat dihafalkan.
   * Setelah 3 detik (`DelayHiddenNumberMiniGame`), 3 angka target pilihan akan disembunyikan dan diubah tampilannya menjadi `"??"` dengan warna indikator merah.
   * Tombol interaktif (grid) baru diaktifkan setelah angka disembunyikan.

3. **Papan Pilihan Dinamis (Dynamic Grid Shuffle):**
   * Papan pilihan berisi grid angka (ID 73–132) yang **diacak nilainya setiap 2 detik** via timer `MiniGameRandomSelect`.
   * Sistem secara otomatis menyuntikkan (*inject*) 3 angka target yang disembunyikan ke dalam slot acak papan grid, menjamin bahwa **selalu ada opsi jawaban yang benar** di setiap siklus pengacakan.

4. **Deteksi Klik & Penalti:**
   * **Jawaban Benar:** Jika pemain berhasil mengklik angka target yang tersembunyi, teks asli akan kembali dimunculkan dan warna kotak target berubah menjadi **Hijau** (`0x00FF00FF`).
   * **Jawaban Salah:** Mengklik angka yang salah memicu suara *error* (Sound ID `5206`), memberikan efek kilat merah pada *progress bar*, serta memberi penalti berupa **pemotongan waktu** (*progress bar* langsung bertambah `5%`).

5. **Waktu & Auto-Cleanup:**
   * *Progress bar* akan berjalan hingga batas waktu selesai.
   * Ketika waktu habis atau pemain terputus (*disconnect*), seluruh timer (`LoadingProgressBar`, `MiniGameNumberSelectRandTimer`) otomatis dimatikan (*KillTimer*) dan variabel data dibersihkan untuk mencegah *memory leak*.

---

## 🛠️ Dependencies (Library yang Dibutuhkan)

* [a_samp](https://github.com/pawn-lang/YSI-Includes) (Standard SA-MP Library)
* [Pawn.CMD](https://github.com/katembor/Pawn.CMD) (Fast Command Processor)
* [textdraw-streamer](https://github.com/SreeT/textdraw-streamer) (Player TextDraw Management)

---

## 📌 Indeks TextDraw & Struktur Data

| Rentang Indeks TD | Fungsi / Penggunaan |
| :--- | :--- |
| **`1` - `60`** | Layer Tombol Transparan (*Selectable*) |
| **`61` - `66`** | Box Indikator Warna Target Merah/Hijau (`Target Index - 6`) |
| **`67` - `72`** | TextDraw Angka Target Utama |
| **`73` - `132`** | Grid Papan Angka Pilihan (`Button Index + 72`) |
| **`134`** | TextDraw Progress Bar Loading |

---

## 🚀 Cara Penggunaan (Usage)

1. Pasang *include* yang dibutuhkan ke dalam projek server kamu.
2. Salin kode sistem minigame ke dalam *gamemode* atau *filterscript*.
3. Panggil fungsi berikut untuk menampilkan minigame ke pemain:

```pawn
// Menampilkan minigame dengan durasi default (60 detik)
ShowPlayerMiniGame(playerid, 60);

// Atau panggil lewat command player
CMD:minigame(playerid, params[])
{
    ShowPlayerMiniGame(playerid);
    return 1;
}
