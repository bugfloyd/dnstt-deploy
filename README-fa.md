<div dir="rtl">

# dnstt-deploy

**زبان‌ها:** [English](README.md) | [فارسی](README-fa.md)

🚀 **راه‌اندازی و مدیریت سرور dnstt با یک کلیک**

اسکریپت جامع اتوماسیون برای راه‌اندازی و مدیریت سرورهای تونل DNS [dnstt](https://www.bamsoftware.com/software/dnstt) روی سیستم‌های لینوکس. این اسکریپت همه چیز از نصب تا پیکربندی را انجام می‌دهد و راه‌اندازی تونل DNS را بدون دردسر می‌کند.

## راه‌اندازی دامنه DNS

قبل از استفاده از این اسکریپت، باید رکوردهای DNS دامنه خود را به درستی پیکربندی کنید. در اینجا راه‌اندازی مورد نیاز آمده است:

### پیکربندی نمونه
- **نام دامنه شما**: `example.com`
- **آدرس IPv4 سرور شما**: `203.0.113.2`
- **آدرس IPv6 سرور شما**: `2001:db8::2` (اختیاری)
- **زیردامنه تونل**: `t.example.com`
- **نام سرور**: `tns.example.com`

### راه‌اندازی رکوردهای DNS
وارد پنل پیکربندی ثبت‌کننده دامنه خود شوید و این رکوردها را اضافه کنید:

| نوع | نام | اشاره به |
|------|------|-----------|
| A | `tns.example.com` | `203.0.113.2` |
| AAAA | `tns.example.com` | `2001:db8::2` (اگر IPv6 در دسترس باشد) |
| NS | `t.example.com` | `tns.example.com` |

**مهم**: منتظر انتشار DNS بمانید (ممکن است تا 24 ساعت طول بکشد) قبل از تست تونل خود.

## ویژگی‌ها

- **پشتیبانی از چندین توزیع**: Fedora، Rocky Linux، CentOS، Debian، Ubuntu
- **تشخیص خودکار**: تشخیص OS، معماری و پورت SSH
- **امنیت تقویت شده**: اجرای سرویس غیر root با ویژگی‌های امنیتی systemd
- **پیکربندی هوشمند**: تنظیمات پایدار و استفاده مجدد خودکار از کلیدها
- **تونل انعطاف‌پذیر**: حالت SSH یا حالت پروکسی SOCKS
- **آماده شبکه**: پیکربندی خودکار firewall و iptables
- **تأیید باینری**: اعتبارسنجی checksum های MD5، SHA1 و SHA256
- **باینری‌های رسمی**: دانلود از [dnstt.network](https://dnstt.network)

## شروع سریع

### پیش‌نیازها
- سرور لینوکس (Fedora، Rocky، CentOS، Debian یا Ubuntu)
- دسترسی root یا مجوزهای sudo
- اتصال اینترنت برای دانلود بسته‌ها
- **نام دامنه با پیکربندی مناسب DNS** (بخش راه‌اندازی دامنه DNS بالا را ببینید)

### نصب

1. **دانلود اسکریپت:**
   ```bash
   wget https://raw.githubusercontent.com/bugfloyd/dnstt-deploy/main/dnstt-deploy.sh
   chmod +x dnstt-deploy.sh
   ```

2. **اجرای راه‌اندازی:**
   ```bash
   sudo ./dnstt-deploy.sh
   ```

3. **دنبال کردن راهنمای تعاملی:**
    - زیردامنه nameserver خود را وارد کنید (مثل `t.example.com`)
    - مقدار MTU را تنظیم کنید (پیش‌فرض: 1232)
    - حالت تونل را انتخاب کنید (SSH یا SOCKS)

## پیکربندی

### حالت‌های تونل

**حالت SSH (گزینه 2)**
- ترافیک DNS را به سرویس SSH شما تونل می‌کند
- پورت SSH را به طور خودکار تشخیص می‌دهد (پیش‌فرض: 22)
- عالی برای دسترسی shell امن از طریق DNS
- سازگار با اپلیکیشن‌های موبایل

**حالت SOCKS (گزینه 1)**
- پروکسی SOCKS5 یکپارچه Dante را راه‌اندازی می‌کند
- روی `127.0.0.1:1080` گوش می‌دهد
- قابلیت‌های پروکسی اینترنت کامل فراهم می‌کند

### تنظیمات MTU
- **پیش‌فرض**: 1232 بایت
- **محدوده**: 512-1400 بایت
- **مقادیر توصیه شده**:
    - شبکه‌های پایدار/سریع: 1400
    - شبکه‌های استاندارد: 1232
    - شبکه‌های ناپایدار/کند: 1200
    - شبکه‌های موبایل محدود: 512

### تغییر تنظیمات
برای تغییر MTU یا سایر تنظیمات، به سادگی اسکریپت را مجدداً اجرا کنید و مقادیر جدید را وارد کنید. اسکریپت به طور خودکار پیکربندی را بروزرسانی کرده و سرویس‌ها را مجدداً راه‌اندازی می‌کند.

## استفاده از کلاینت

### دانلود باینری کلاینت

باینری مناسب کلاینت dnstt را برای پلتفرم خود از [dnstt.network](https://dnstt.network) دانلود کنید:

**پلتفرم‌های رایج:**
- **Linux x64**: `dnstt-client-linux-amd64`
- **Windows x64**: `dnstt-client-windows-amd64.exe`
- **macOS Intel**: `dnstt-client-darwin-amd64`
- **macOS Apple Silicon**: `dnstt-client-darwin-arm64`

### دستور اتصال

بعد از راه‌اندازی سرور، کلید عمومی دریافت خواهید کرد. از آن برای اتصال استفاده کنید:

```bash
dnstt-client -udp DNS_SERVER_IP:53 -pubkey-file server.pub t.example.com 127.0.0.1:7000
```

#### DNS_SERVER_IP

IP سرور DNS بستگی به سیستم شما دارد:

**Linux**:
```bash
systemd-resolve --status | grep "DNS Servers"
```
گزینه‌های رایج: `127.0.0.53:53`، `127.0.0.1:53` یا IP روتر شما

**Windows**:
```cmd
ipconfig /all | findstr /C:"DNS Servers"
```

**macOS**:
```bash
scutil --dns | grep nameserver
```

همچنین می‌توانید از موارد زیر استفاده کنید:
- IP داخلی روتر/مودم شما (مثل `192.168.1.1:53`)
- IP سرور DNS ارائه‌دهنده اینترنت شما
- سرورهای DNS عمومی مثل `8.8.8.8:53` یا `1.1.1.1:53` (در صورت در دسترس بودن)

### اپلیکیشن‌های موبایل (حالت SSH)

برای تونل‌های SSH، می‌توانید از این اپلیکیشن‌های Android/iOS بدون نیاز به کامپیوتر استفاده کنید:

**Android**:
- [HTTP Injector](https://play.google.com/store/apps/details?id=com.evozi.injector)
- [HTTP Custom](https://play.google.com/store/apps/details?id=xyz.easypro.httpcustom)
- [DarkTunnel](https://play.google.com/store/apps/details?id=net.darktunnel.app)

**iOS**:
- [HTTP Injector](https://apps.apple.com/us/app/http-injector/id1659992827)

## مدیریت

### محل فایل‌ها

```
/usr/local/bin/dnstt-server          # باینری اصلی
/etc/dnstt/                          # دایرکتوری پیکربندی
├── dnstt-server.conf               # پیکربندی اصلی
├── {domain}_server.key             # کلید خصوصی (برای هر دامنه)
└── {domain}_server.pub             # کلید عمومی (برای هر دامنه)
/etc/systemd/system/dnstt-server.service  # سرویس systemd
```

### دستورات سرویس

**سرویس dnstt-server**:
```bash
sudo systemctl status dnstt-server    # بررسی وضعیت
sudo systemctl start dnstt-server     # شروع سرویس
sudo systemctl stop dnstt-server      # توقف سرویس
sudo systemctl restart dnstt-server   # راه‌اندازی مجدد سرویس
sudo journalctl -u dnstt-server -f    # مشاهده لاگ‌ها
```

**سرویس Dante SOCKS (فقط حالت SOCKS)**:
```bash
sudo systemctl status danted          # بررسی وضعیت
sudo systemctl start danted           # شروع سرویس
sudo systemctl stop danted            # توقف سرویس
sudo systemctl restart danted         # راه‌اندازی مجدد سرویس
sudo journalctl -u danted -f          # مشاهده لاگ‌ها
```

## عیب‌یابی

### خطاهای اندازه MTU

اگر خطاهایی مثل این می‌بینید:
```
FORMERR: requester payload size 512 is too small (minimum 1232)
```

MTU را به عدد ذکر شده کاهش دهید با اجرای مجدد اسکریپت و وارد کردن مقدار MTU پیشنهادی. مبادلات عملکرد را هنگام استفاده از مقادیر MTU بسیار پایین در نظر بگیرید.

### مشکلات رایج

**سرویس شروع نمی‌شود**:
```bash
sudo systemctl status dnstt-server    # بررسی وضعیت سرویس
sudo journalctl -u dnstt-server -n 50 # بررسی لاگ‌ها برای خطاها
ls -la /usr/local/bin/dnstt-server    # تأیید مجوزهای باینری
```

**مشکلات پیکربندی DNS**:
```bash
dig @YOUR_SERVER_IP t.mydomain.com           # تست تونل DNS (از کلاینت)
sudo iptables -t nat -L PREROUTING -n -v     # بررسی قوانین iptables
```

**مشکلات پروکسی SOCKS**:
```bash
curl --socks5 127.0.0.1:1080 http://httpbin.org/ip  # تست محلی پروکسی SOCKS
sudo cat /etc/danted.conf                           # بررسی پیکربندی Dante
```

**بررسی پورت**:
```bash
sudo ss -tulnp | grep 5300  # بررسی پورت dnstt-server
sudo ss -tulnp | grep 1080  # بررسی پورت پروکسی SOCKS (در صورت فعال بودن)
```

## ویژگی‌های پیشرفته

### پشتیبانی از چندین دامنه

اسکریپت از چندین دامنه با ایجاد جفت کلیدهای جداگانه برای هر دامنه پشتیبانی می‌کند. با این حال، تنها یک پیکربندی دامنه می‌تواند در یک زمان فعال باشد زیرا همه پیکربندی‌ها از پورت 53 برای ترافیک DNS استفاده می‌کنند. برای تغییر بین دامنه‌ها، به سادگی اسکریپت را با زیردامنه متفاوت مجدداً اجرا کنید.

### پشتیبانی از DoH و DoT

برای پیکربندی‌های DNS-over-HTTPS (DoH) یا DNS-over-TLS (DoT)، به [مستندات رسمی dnstt](https://dnstt.network) برای دستورالعمل‌های راه‌اندازی دقیق مراجعه کنید.

### نظارت بر عملکرد

```bash
sudo ss -tulnp | grep -E "(5300|1080)"        # نظارت بر تعداد اتصالات
sudo systemctl status dnstt-server            # بررسی منابع سرویس
sudo journalctl -u dnstt-server -f --no-pager # نظارت بر لاگ‌ها برای خطاها
```

## مشارکت

مشارکت‌ها خوش‌آمد هستند! لطفاً برای ارسال Pull Request احساس راحتی کنید. برای تغییرات بزرگ، لطفاً ابتدا یک issue باز کنید تا در مورد آنچه می‌خواهید تغییر دهید بحث کنیم.

## قدردانی

- [dnstt](https://dnstt.network) توسط David Fifield
- [Dante SOCKS server](https://www.inet.no/dante/) برای قابلیت پروکسی SOCKS

## پشتیبانی

- **مشکلات**: [GitHub Issues](https://github.com/bugfloyd/dnstt-deploy/issues)
- **بحث‌ها**: [GitHub Discussions](https://github.com/bugfloyd/dnstt-deploy/discussions)
- **وب‌سایت رسمی پروژه**: [dnstt.network](https://dnstt.network)

---

**ساخته شده با ❤️ برای حریم خصوصی و امنیت**
</div>