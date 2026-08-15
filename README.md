# ชุดติดตั้งสไตล์ macOS บน Windows 11 (macos-style-windows-setup)

สรุป
- ไฟล์ในสาขานี้ช่วยดาวน์โหลดและเตรียมตัวติดตั้งเครื่องมือที่ทำให้ Windows 11 ดู/ใช้งานเหมือน macOS มากขึ้น
- วิธีการที่สคริปต์ทำได้: ดาวน์โหลดตัวติดตั้งยอดนิยม (PowerToys, ExplorerPatcher, RoundedTB, Rainmeter, ฯลฯ) ลงโฟลเดอร์ และ (ถ้าสั่ง) รันตัวติดตั้งแบบทีละตัว

ข้อควรระวังก่อนเริ่ม
1. สำรองข้อมูลสำคัญ และสร้าง System Restore Point ก่อนทำการเปลี่ยนแปลงระบบใหญ่
2. สคริปต์นี้ดาวน์โหลดตัวติดตั้งจากหน้า release อย่างเป็นทางการของโปรเจคบน GitHub หรือผู้ให้บริการต้นทาง และจะไม่ติดตั้งเปลี่ยนไฟล์ระบบโดยไม่มีสิทธิ์ admin
3. ถ้าต้องการใช้ transformation pack แบบ “one‑click” (all-in-one) ผมไม่แนะนำเพราะเสี่ยงต่อความไม่เสถียร — วิธีที่นี่เป็น modular และปลอดภัยกว่า

ไฟล์ที่มีในสาขานี้
- setup-windows-macos.ps1 — สคริปต์ PowerShell (อ่านโค้ดก่อนรัน)
- CHECKLIST.md — รายการขั้นตอนหลังดาวน์โหลดและการตั้งค่าที่ต้องทำด้วยมือ
- README.md — (ไฟล์นี้)

วิธีใช้ (โดยย่อ)
1. ดาวน์โหลดหรือ clone สาขา `macos-style-windows-setup`
2. เปิด PowerShell ด้วยสิทธิ์ปกติ (หรือ Admin ถ้าต้องการให้สคริปต์รันติดตั้งอัตโนมัติ)
3. รัน:
   - แค่ดาวน์โหลด: .\setup-windows-macos.ps1
   - ดาวน์โหลดและติดตั้งอัตโนมัติ (จะขอสิทธิ์ UAC): .\setup-windows-macos.ps1 -Install
4. อ่าน CHECKLIST.md เพื่อทำการตั้งค่าต่อ (เปลี่ยนไอคอน, ติดตั้ง Rainmeter skins, ฟอนต์ ฯลฯ)

ลิงก์สำคัญ (ต้นทาง)
- PowerToys: https://github.com/microsoft/PowerToys/releases
- ExplorerPatcher: https://github.com/valinet/ExplorerPatcher/releases
- RoundedTB: https://github.com/Team84/RoundedTB/releases
- Rainmeter: https://github.com/rainmeter/rainmeter/releases
- Winstep Nexus (Dock): https://www.winstep.net/nexus.asp
- Apple San Francisco fonts: https://developer.apple.com/fonts/

ถ้าต้องการให้ผมเพิ่ม: icon pack links, Rainmeter skin ตัวอย่าง, หรือ config ตัวอย่างของ ExplorerPatcher บอกได้เลย
