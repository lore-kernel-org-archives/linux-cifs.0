From: Mikko Rasa <tdb-nLh9gj8vv8Q@public.gmane.org>
Subject: Troubles with CIFS and suspend
Date: Fri, 16 Dec 2016 14:45:01 +0200
Message-ID: <f86aec8c-f34f-73eb-cd53-ec0da24b6df2@tdb.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------431ABB24D6DFF7ECD3EA60AA"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------431ABB24D6DFF7ECD3EA60AA
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've been using CIFS for my home directory in my local network for a 
while now.  The performance is good but there are some issues with 
suspend which require me to do a full reboot more often than I'd like.

My setup is samba 4.5.2 on the server and Linux 4.7.2 on the client. 
Kerberos 5 is used for authentication.  The filesystem is mounted with 
multiuser,sec=krb5,username=nobody,iocharset=utf8,soft.

Typical use cases for suspend are putting the computer to sleep for the 
night and hibernating before booting to Windows to play games.


I've observed at least the following symptoms, in order from least to 
most severe:

1. When starting a new terminal, this text appears before the command 
prompt:

shell-init: error retrieving current directory: getcwd: cannot access 
parent directories: No such file or directory

The message repeats if I try to do things like tab completion. 
Inspecting /proc shows this:

$ ls -l /proc/2055/cwd
lrwxrwxrwx 1 tdb users 0 joulu 16 13:46 /proc/2055/cwd -> /home/tdb 
(deleted)

Apparently the FS gets remounted at some point and existing processes 
lose their cwd?  A simple cd fixes the issue for that shell so this is 
fairly benign.

2. Long delays after resume before xscreensaver presents the password 
prompt.  Sometimes it takes in excess of 10 minutes.  This hasn't 
happened for a while though, so perhaps some update or another fixed it.

3. User processes getting stuck after resume.  Some programs are more 
vulnerable than others.  Most common are evince and icedove; I suspect 
this has something to do with gvfs.  I've seen it affect opera, blender 
and steam as well, but much less often.

4. User processes becoming unkillable after resume.  A more severe case 
of the above, sometimes the process gets stuck so hard it can't be 
killed even with SIGKILL.  I try to close the common culprits before 
suspending the system but sometimes I forget.

Just now I have one process which claims to be in running state and eats 
100% CPU time but it's still not possible to kill it.  Attaching to it 
with strace to see what it's doing doesn't work either; strace gets 
stuck as well (but can be killed).

When I've inspected /proc/<pid>/syscall for such processes common 
results are futex and getdents.

See the attached traces.txt for typical dmesg output when attempting to 
suspend the system in such a case.

5. kswapd getting stuck after resume.  This spells imminent trouble and 
the computer is likely to become unstable in various ways unless I 
reboot immediately.  A clean reboot does not even go all the way, 
hanging at a late stage and requiring the use of the physical reset button.


I suspected the problems might have something to do with the kerberos 
tickets expiring while the computer was suspended, but increasing ticket 
lifetime to a week did not help.

I tried adding a hook to /etc/pm/sleep.d to dump process states to a log 
file in an effort to find out if they are in the stuck state immediately 
after resume.  They aren't.  The suspend cycle leaves the filesystem in 
a state in which processes get stuck when they try to perform particular 
operations on it.

I get this message from the kernel on boot when the filesystem is mounted:

Dec 12 10:13:11 muskrat kernel: CIFS VFS: Autodisabling the use of 
server inode numbers on \x5c\x5ccapybara.tdb.fi\x5chome. This server 
doesn't seem to support them properly. Hardlinks will not be recognized 
on this mount. Consider mounting with the "noserverino" option to 
silence this message.

Could it be related?  I can see how the lack of persistent inodes could 
lead to the cwd disappearing at least.

What could I do to resolve the issues or at least gain further insight 
of what's causing them?  I could live with having to occasionally 
restart single programs if an unrecoverable error occurs, but having to 
close down everything for a reboot is annoying.

-- 
Mikko

--------------431ABB24D6DFF7ECD3EA60AA
Content-Type: text/plain; charset=UTF-8;
 name="traces.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="traces.txt"

RGVjICA4IDAzOjIxOjQ1IG11c2tyYXQga2VybmVsOiBGcmVlemluZyBvZiB0YXNrcyBmYWls
ZWQgYWZ0ZXIgMjAuMDAxIHNlY29uZHMgKDEgdGFza3MgcmVmdXNpbmcgdG8gZnJlZXplLCB3
cV9idXN5PTApOgpEZWMgIDggMDM6MjE6NDUgbXVza3JhdCBrZXJuZWw6IFNpbXBsZUNhY2hl
V29yayBEIGZmZmY4ODA0NDE3NDNjMDggICAgIDAgIDI0MTEgICAgICAxIDB4MDAwMDAwMDQK
RGVjICA4IDAzOjIxOjQ1IG11c2tyYXQga2VybmVsOiAgZmZmZjg4MDQ0MTc0M2MwOCAwMDAw
MDg2MjVjOWNlNjAwIGZmZmY4ODA0NWE0NzA4MDAgZmZmZjg4MDQ0MTc0NDAwMApEZWMgIDgg
MDM6MjE6NDUgbXVza3JhdCBrZXJuZWw6ICBmZmZmODgwNDZlY2QzZjgwIDdmZmZmZmZmZmZm
ZmZmZmYgZmZmZmZmZmY4MTM2YmZmMCBmZmZmODgwNDQxNzQzZDI4CkRlYyAgOCAwMzoyMTo0
NSBtdXNrcmF0IGtlcm5lbDogIGZmZmY4ODA0NDE3NDNjMjAgZmZmZmZmZmY4MTM2YjlkMCAw
MDAwMDAwMDAwMDAwMDAwIGZmZmY4ODA0NDE3NDNjOTAKRGVjICA4IDAzOjIxOjQ1IG11c2ty
YXQga2VybmVsOiBDYWxsIFRyYWNlOgpEZWMgIDggMDM6MjE6NDUgbXVza3JhdCBrZXJuZWw6
ICBbPGZmZmZmZmZmODEzNmJmZjA+XSA/IGJpdF93YWl0KzB4NjAvMHg2MApEZWMgIDggMDM6
MjE6NDUgbXVza3JhdCBrZXJuZWw6ICBbPGZmZmZmZmZmODEzNmI5ZDA+XSBzY2hlZHVsZSsw
eDMwLzB4ODAKRGVjICA4IDAzOjIxOjQ1IG11c2tyYXQga2VybmVsOiAgWzxmZmZmZmZmZjgx
MzZkZjc5Pl0gc2NoZWR1bGVfdGltZW91dCsweDE1OS8weDFhMApEZWMgIDggMDM6MjE6NDUg
bXVza3JhdCBrZXJuZWw6ICBbPGZmZmZmZmZmODEwYTJkNmM+XSA/IGt0aW1lX2dldCsweDNj
LzB4YjAKRGVjICA4IDAzOjIxOjQ1IG11c2tyYXQga2VybmVsOiAgWzxmZmZmZmZmZjgxMzZi
ZmYwPl0gPyBiaXRfd2FpdCsweDYwLzB4NjAKRGVjICA4IDAzOjIxOjQ1IG11c2tyYXQga2Vy
bmVsOiAgWzxmZmZmZmZmZjgxMzZiMzhmPl0gaW9fc2NoZWR1bGVfdGltZW91dCsweDlmLzB4
MTEwCkRlYyAgOCAwMzoyMTo0NSBtdXNrcmF0IGtlcm5lbDogIFs8ZmZmZmZmZmY4MTM2YzAw
Nj5dIGJpdF93YWl0X2lvKzB4MTYvMHg2MApEZWMgIDggMDM6MjE6NDUgbXVza3JhdCBrZXJu
ZWw6ICBbPGZmZmZmZmZmODEzNmJjZjY+XSBfX3dhaXRfb25fYml0KzB4NTYvMHg4MApEZWMg
IDggMDM6MjE6NDUgbXVza3JhdCBrZXJuZWw6ICBbPGZmZmZmZmZmODEwZGNmY2I+XSB3YWl0
X29uX3BhZ2VfYml0X2tpbGxhYmxlKzB4YWIvMHhiMApEZWMgIDggMDM6MjE6NDUgbXVza3Jh
dCBrZXJuZWw6ICBbPGZmZmZmZmZmODEwN2YzZTA+XSA/IGF1dG9yZW1vdmVfd2FrZV9mdW5j
dGlvbisweDMwLzB4MzAKRGVjICA4IDAzOjIxOjQ1IG11c2tyYXQga2VybmVsOiAgWzxmZmZm
ZmZmZjgxMGRkMGVmPl0gZ2VuZXJpY19maWxlX3JlYWRfaXRlcisweDExZi8weDc0MApEZWMg
IDggMDM6MjE6NDUgbXVza3JhdCBrZXJuZWw6ICBbPGZmZmZmZmZmODEwNmM4Y2U+XSA/IHRy
eV90b193YWtlX3VwKzB4MWFlLzB4MmIwCkRlYyAgOCAwMzoyMTo0NSBtdXNrcmF0IGtlcm5l
bDogIFs8ZmZmZmZmZmY4MTA2Y2ExZD5dID8gd2FrZV91cF9xKzB4MmQvMHg3MApEZWMgIDgg
MDM6MjE6NDUgbXVza3JhdCBrZXJuZWw6ICBbPGZmZmZmZmZmYTJiNzBjNjk+XSBjaWZzX3N0
cmljdF9yZWFkdisweGM5LzB4MTAwIFtjaWZzXQpEZWMgIDggMDM6MjE6NDUgbXVza3JhdCBr
ZXJuZWw6ICBbPGZmZmZmZmZmODExMjUyY2E+XSBfX3Zmc19yZWFkKzB4YmEvMHgxMTAKRGVj
ICA4IDAzOjIxOjQ1IG11c2tyYXQga2VybmVsOiAgWzxmZmZmZmZmZjgxMTI1NWI4Pl0gdmZz
X3JlYWQrMHg4OC8weDE1MApEZWMgIDggMDM6MjE6NDUgbXVza3JhdCBrZXJuZWw6ICBbPGZm
ZmZmZmZmODExMjc1ODE+XSBTeVNfcHJlYWQ2NCsweDcxLzB4OTAKRGVjICA4IDAzOjIxOjQ1
IG11c2tyYXQga2VybmVsOiAgWzxmZmZmZmZmZjgxMzZlYWRiPl0gZW50cnlfU1lTQ0FMTF82
NF9mYXN0cGF0aCsweDEzLzB4OGYKCkRlYyAxNiAxNDowODo1MyBtdXNrcmF0IGtlcm5lbDog
RnJlZXppbmcgb2YgdGFza3MgZmFpbGVkIGFmdGVyIDIwLjAwNSBzZWNvbmRzICgyIHRhc2tz
IHJlZnVzaW5nIHRvIGZyZWV6ZSwgd3FfYnVzeT0wKToKRGVjIDE2IDE0OjA4OjUzIG11c2ty
YXQga2VybmVsOiBQYXRoT2ZFeGlsZS5leGUgUiAgcnVubmluZyB0YXNrICAgICAgICAwIDI2
MDIxICAgICAgMSAweDIwMDIwMDA0CkRlYyAxNiAxNDowODo1MyBtdXNrcmF0IGtlcm5lbDog
IGZmZmZmZmZmODExMzlkYTQgMDAwMDAwMDAwMDAwMDAwMCAwMTAwMDAwMDAwMDAwMDAwIGZm
ZmY4ODAxMzM1MTkyOTgKRGVjIDE2IDE0OjA4OjUzIG11c2tyYXQga2VybmVsOiAgMDAwMDAw
MDAwMDAyMzg5NiBmZmZmODgwMTMzNTE5MjQwIGZmZmZmZmZmODExM2I0YjAgZmZmZjg4MDE4
MGQ0YmU0OApEZWMgMTYgMTQ6MDg6NTMgbXVza3JhdCBrZXJuZWw6ICBmZmZmODgwMTMzNTE5
MjQwIGZmZmY4ODAxODBkNGJlNTAgZmZmZjg4MDE4MGQ0YmU1MCAwMDAwMDAwMDAwMzNiY2Jj
CkRlYyAxNiAxNDowODo1MyBtdXNrcmF0IGtlcm5lbDogQ2FsbCBUcmFjZToKRGVjIDE2IDE0
OjA4OjUzIG11c2tyYXQga2VybmVsOiAgWzxmZmZmZmZmZjgxMTM5ZGE0Pl0gPyBkX3dhbGsr
MHhiNC8weDI1MApEZWMgMTYgMTQ6MDg6NTMgbXVza3JhdCBrZXJuZWw6ICBbPGZmZmZmZmZm
ODExM2I0YjA+XSA/IGRfbHJ1X2RlbCsweDkwLzB4OTAKRGVjIDE2IDE0OjA4OjUzIG11c2ty
YXQga2VybmVsOiAgWzxmZmZmZmZmZjgxMTNiZjQyPl0gPyBzaHJpbmtfZGNhY2hlX3BhcmVu
dCsweDUyLzB4NzAKRGVjIDE2IDE0OjA4OjUzIG11c2tyYXQga2VybmVsOiAgWzxmZmZmZmZm
ZjgxMTMzZjNkPl0gPyB2ZnNfcm1kaXIrMHg1ZC8weDEyMApEZWMgMTYgMTQ6MDg6NTMgbXVz
a3JhdCBrZXJuZWw6ICBbPGZmZmZmZmZmODExMzQ5YWI+XSA/IGRvX3JtZGlyKzB4MThiLzB4
MjAwCkRlYyAxNiAxNDowODo1MyBtdXNrcmF0IGtlcm5lbDogIFs8ZmZmZmZmZmY4MTEzNTNm
MT5dID8gU3lTX3JtZGlyKzB4MTEvMHgyMApEZWMgMTYgMTQ6MDg6NTMgbXVza3JhdCBrZXJu
ZWw6ICBbPGZmZmZmZmZmODEwMDI2MTE+XSA/IGRvX2Zhc3Rfc3lzY2FsbF8zMisweDkxLzB4
MTUwCkRlYyAxNiAxNDowODo1MyBtdXNrcmF0IGtlcm5lbDogIFs8ZmZmZmZmZmY4MTM3MDQ2
Yz5dID8gZW50cnlfU1lTRU5URVJfY29tcGF0KzB4NGMvMHg1YgpEZWMgMTYgMTQ6MDg6NTMg
bXVza3JhdCBrZXJuZWw6IHN0ZWFtICAgICAgICAgICBEIGZmZmY4ODA0MmQ1MzNkOTggICAg
IDAgMjY1NjYgICAgICAxIDB4MjAwMjAwMDQKRGVjIDE2IDE0OjA4OjUzIG11c2tyYXQga2Vy
bmVsOiAgZmZmZjg4MDQyZDUzM2Q5OCBmZmZmODgwNDVjMzBiMDIwIGZmZmY4ODAxMzUwZGM5
MDAgZmZmZjg4MDQyZDUzNDAwMApEZWMgMTYgMTQ6MDg6NTMgbXVza3JhdCBrZXJuZWw6ICBm
ZmZmODgwMDA0N2E3MmMwIGZmZmY4ODAwMDQ3YTcyYzAgMDAwMDAwMDBmZmZmZmZmZSBmZmZm
ODgwNDJkNTMzZWMwCkRlYyAxNiAxNDowODo1MyBtdXNrcmF0IGtlcm5lbDogIGZmZmY4ODA0
MmQ1MzNkYjAgZmZmZmZmZmY4MTM2YjlkMCBmZmZmODgwM2RmZTJiMjgwIGZmZmY4ODA0MmQ1
MzNlMDgKRGVjIDE2IDE0OjA4OjUzIG11c2tyYXQga2VybmVsOiBDYWxsIFRyYWNlOgpEZWMg
MTYgMTQ6MDg6NTMgbXVza3JhdCBrZXJuZWw6ICBbPGZmZmZmZmZmODEzNmI5ZDA+XSBzY2hl
ZHVsZSsweDMwLzB4ODAKRGVjIDE2IDE0OjA4OjUzIG11c2tyYXQga2VybmVsOiAgWzxmZmZm
ZmZmZjgxMzZkODhlPl0gcndzZW1fZG93bl9yZWFkX2ZhaWxlZCsweGJlLzB4MTAwCkRlYyAx
NiAxNDowODo1MyBtdXNrcmF0IGtlcm5lbDogIFs8ZmZmZmZmZmZhMmMxZGUyMj5dID8gY2lm
c19yZXZhbGlkYXRlX2RlbnRyeV9hdHRyKzB4MzIvMHhmMCBbY2lmc10KRGVjIDE2IDE0OjA4
OjUzIG11c2tyYXQga2VybmVsOiAgWzxmZmZmZmZmZjgxMWRjMmY4Pl0gY2FsbF9yd3NlbV9k
b3duX3JlYWRfZmFpbGVkKzB4MTgvMHgzMApEZWMgMTYgMTQ6MDg6NTMgbXVza3JhdCBrZXJu
ZWw6ICBbPGZmZmZmZmZmODEzNmQxYmI+XSBkb3duX3JlYWQrMHgxYi8weDIwCkRlYyAxNiAx
NDowODo1MyBtdXNrcmF0IGtlcm5lbDogIFs8ZmZmZmZmZmY4MTEzNzZlMD5dIGl0ZXJhdGVf
ZGlyKzB4NDAvMHgxODAKRGVjIDE2IDE0OjA4OjUzIG11c2tyYXQga2VybmVsOiAgWzxmZmZm
ZmZmZjgxMTZjZmEzPl0gY29tcGF0X1N5U19nZXRkZW50cysweDgzLzB4MTAwCkRlYyAxNiAx
NDowODo1MyBtdXNrcmF0IGtlcm5lbDogIFs8ZmZmZmZmZmY4MTE2Yjc5MD5dID8gY29tcGF0
X3NldF9mZF9zZXQrMHg4MC8weDgwCkRlYyAxNiAxNDowODo1MyBtdXNrcmF0IGtlcm5lbDog
IFs8ZmZmZmZmZmY4MTAwMjYxMT5dIGRvX2Zhc3Rfc3lzY2FsbF8zMisweDkxLzB4MTUwCkRl
YyAxNiAxNDowODo1MyBtdXNrcmF0IGtlcm5lbDogIFs8ZmZmZmZmZmY4MTM3MDQ2Yz5dIGVu
dHJ5X1NZU0VOVEVSX2NvbXBhdCsweDRjLzB4NWIKCg==
--------------431ABB24D6DFF7ECD3EA60AA--
