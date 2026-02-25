# ST Scoreboard (QBCore) — v1.2.1

> **وصف سريع:** سكربت Scoreboard احترافي لـ **QBCore** يعرض معلومات السيرفر واللاعبين + إحصائيات الوظائف + حالة الأنشطة/السرقات/الخطف (متاح/غير متاح/مشغول) مع إظهار IDs فوق اللاعبين عند فتح اللوحة.

---

## 🇸🇦 عربي

### ✅ المميزات
- **Scoreboard UI** أنيق (NUI) مع:
  - عدد اللاعبين Online + الحد الأقصى.
  - **Ping** اللاعب.
  - **Uptime** السيرفر.
  - ساعة محلية داخل الـ UI.
  - شريط تقدم يوضح نسبة امتلاء السيرفر.
- **إحصائيات وظائف On-Duty** (قابل للتعديل من الكونفج).
- **حالة الأنشطة** (سرقات/خطف…):
  - ✅ متاح (عدد الشرطة كافي)
  - ❌ غير متاح (عدد الشرطة غير كافي)
  - ⏳ مشغول (busy)
- **إظهار ID فوق اللاعبين** القريبين عند فتح الـ scoreboard (مع Opt-in اختياري من QBCore).
- نظام **Toggle أو Hold** لفتح/إغلاق اللوحة حسب إعداداتك.

---

### 📌 المتطلبات (Dependencies)
- **QBCore** (`qb-core`)
- مورد UI داخل نفس الريسورس (موجود تلقائياً ضمن الملفات)

> ملاحظة: يعتمد عرض الـ Opt-in على نظام opt-in داخل QBCore (`QBCore.Functions.IsOptin`).

---

### 🧩 التركيب (Installation)
1. ضع المجلد داخل:
   `resources/[qb]/st-scoreboard` (أو أي مسار تفضله)
2. تأكد أن اسم الريسورس مطابق لمجلدك.
3. أضف في `server.cfg`:
   ```
   ensure st-scoreboard
   ```
4. أعد تشغيل السيرفر / الريسورس.

---

### ⌨️ طريقة الاستخدام
- المفتاح الافتراضي: **HOME**
- يوجد Key Mapping باسم: **Open Scoreboard**
- كذلك يوجد أمر:
  - `/scoreboard`

> إذا `Config.Toggle = true` → ضغط مرة يفتح/مرة يسكر.  
> إذا `Config.Toggle = false` → (Hold) باستخدام `+scoreboard` و `-scoreboard` عبر نفس الـ Key Mapping.

---

### ⚙️ الإعدادات (config.lua)

#### فتح اللوحة
```lua
Config.OpenKey = 'HOME'
Config.Toggle = true
Config.MaxPlayers = GetConvarInt('sv_maxclients', 48)
```

#### الوظائف المتابعة (On-Duty)
```lua
Config.TrackedJobs = {
  ['police']     = { label = 'Police', icon = 'fa-solid fa-handcuffs' },
  ['ambulance']  = { label = 'EMS', icon = 'fas fa-ambulance' },
  ['mechanic']   = { label = 'Mechanic', icon = 'fas fa-wrench' },
  ['realestate'] = { label = 'Real Estate', icon = 'fas fa-building' },
  ['taxi']       = { label = 'Taxi', icon = 'fas fa-taxi' },
}
```

#### إعدادات الخطف + الأنشطة الإجرامية
كل عنصر فيه:
- `minimumPolice`: أقل عدد شرطة (On-Duty) لازم يكون موجود
- `busy`: هل النشاط مشغول حالياً
- `label`: اسم يظهر بالواجهة

```lua
Config.KidnapSettings = {
  civilian = { minimumPolice = 2, busy = false, label = 'Kidnap Civilian', icon = 'fa-user' },
  police   = { minimumPolice = 4, busy = false, label = 'Kidnap Police',   icon = 'fa-shield-halved' }
}

Config.IllegalActions = {
  ['storerobbery'] = { minimumPolice = 2, busy = false, label = 'Store Robbery' },
  ['bankrobbery']  = { minimumPolice = 3, busy = false, label = 'Bank Robbery' },
  ['jewellery']    = { minimumPolice = 2, busy = false, label = 'Jewellery' },
  ['pacific']      = { minimumPolice = 5, busy = false, label = 'Pacific Bank' },
  ['paleto']       = { minimumPolice = 4, busy = false, label = 'Paleto Bay Bank' }
}
```

#### إظهار الـ ID
```lua
Config.ShowIDforALL = true
```
- `true`: يظهر ID للكل عند فتح الـ scoreboard.
- `false`: يعتمد على Opt-in من QBCore (فقط اللي عامل opt-in يظهر ID تبعه).

---

### 🔌 ربط السكربتات الأخرى (Busy / Available)

عشان تخلي نشاط معيّن يظهر **مشغول/غير مشغول** داخل الـ scoreboard:

#### من السيرفر (Server Side)
```lua
-- activity مثال: 'bankrobbery' أو 'civilian' أو أي key موجود بالـ config
TriggerEvent('qb-scoreboard:server:SetActivityBusy', 'bankrobbery', true)  -- busy
TriggerEvent('qb-scoreboard:server:SetActivityBusy', 'bankrobbery', false) -- not busy
```

> لازم يكون `activity` موجود كـ key داخل `Config.IllegalActions` أو `Config.KidnapSettings`.

---

### 🛠️ تعديل الواجهة (UI)
الملفات:
- `html/ui.html`
- `html/style.css`
- `html/reset.css`
- `html/app.js`

ملاحظات سريعة:
- الأيقونات: **Font Awesome 7** (مستورد من CDN داخل `ui.html`)
- الخط: **Inter** (Google Fonts)
- تحديث البيانات يتم كل **5 ثواني** طالما اللوحة مفتوحة.

---

## 🇺🇸 English

### Features
- Clean NUI scoreboard UI:
  - Online players + max slots
  - Player ping
  - Server uptime
  - Local clock in UI
  - Server fill progress bar
- On-duty job counters (configurable)
- Activity status system (robberies/kidnap, etc.):
  - ✅ Available (enough cops)
  - ❌ Not available (not enough cops)
  - ⏳ Busy (in progress)
- 3D Player IDs displayed while scoreboard is open (optional QBCore opt-in support)
- Toggle mode or Hold mode for opening.

### Requirements
- QBCore (`qb-core`)

### Install
1. Put the resource folder in your resources.
2. Add to `server.cfg`:
   ```
   ensure st-scoreboard
   ```

### Usage
- Default key: **HOME**
- Command: `/scoreboard`
- `Config.Toggle = true` → press to open/close  
- `Config.Toggle = false` → hold key using `+scoreboard` / `-scoreboard`

### Set activity busy (from other scripts)
```lua
TriggerEvent('qb-scoreboard:server:SetActivityBusy', 'bankrobbery', true)
TriggerEvent('qb-scoreboard:server:SetActivityBusy', 'bankrobbery', false)
```

---

## 📄 License / Credits
- Author: `ii_abual3bed | stdev`
- Resource: `st-scoreboard`
