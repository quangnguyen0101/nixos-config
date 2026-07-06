# Git workflow cho nvim config

## Lần đầu setup

**1. Tạo repo trên GitHub**
- Vào https://github.com/new
- Đặt tên repo, chọn Public/Private
- Bấm **Create repository**

**2. Tạo Personal Access Token**
- Vào https://github.com/settings/tokens/new
- Điền tên, chọn thời hạn, tick **repo**
- Bấm **Generate token**, copy lại ngay

**3. Init và push lần đầu**
```bash
cd ~/.config/nvim
git init
git add .
git commit -m "init: nvim config"
git remote add origin https://USERNAME:TOKEN@github.com/USERNAME/nvim-config.git
git branch -M main
git pull origin main --rebase   # nếu repo đã có file như README
git push -u origin main
```

---

## Hàng ngày

```bash
cd ~/.config/nvim
git add .
git commit -m "mô tả thay đổi"
git push
```

---

## Khi dùng máy mới

```bash
git clone https://USERNAME:TOKEN@github.com/USERNAME/nvim-config.git ~/.config/nvim
```

Mở nvim, Lazy tự động cài tất cả plugin.
