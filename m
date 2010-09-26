From: Poyo VL <poyo_vl-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] /fs/cifs/cifssmb.c (2.6.35.5): Simple pointer initialization
Date: Sun, 26 Sep 2010 04:05:35 -0700 (PDT)
Message-ID: <945403.85622.qm@web45802.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1897494142-1285499135=:85622"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--0-1897494142-1285499135=:85622
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

When I tried to compile the kernel (make allyesconfig) I got the following =
ugly =0Awarning:=0Afs/cifs/cifssmb.c: In function =E2=80=98CIFSSMBGetCIFSAC=
L=E2=80=99:=0Afs/cifs/cifssmb.c:3082: warning: =E2=80=98pdata=E2=80=99 may =
be used uninitialized in this =0Afunction=0AThe pdata pointer is prctically=
 initialized in line 3086 and it is used in line =0A3122, but the compiler =
can't be sure that pdata will be used initialized so it =0Athrows that ugly=
 warning. Just initializing *pdata with NULL will get rid off =0Athat warni=
ng.=0APatch downer. I also attached it because someone told me that there a=
re problems =0Awith Yahoo! Mail, it trims spaces or tabs...=0A=0ASigned-off=
-by: Ionut Gabriel Popescu <poyo_vl-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>=0A---=0A=0A--- a/fs/cifs/cif=
ssmb.c    2010-09-20 23:59:09.000000000 +0300=0A+++ b/fs/cifs/cifssmb.c    =
2010-09-26 13:05:45.281241095 +0300=0A@@ -3079,7 +3079,7 @@ CIFSSMBGetCIFSA=
CL(const int xid, struct=0A         __u32 parm_len;=0A         __u32 acl_le=
n;=0A         struct smb_com_ntransact_rsp *pSMBr;=0A-        char *pdata;=
=0A+        char *pdata =3D NULL;=0A =0A /* validate_nttransact */=0A      =
   rc =3D validate_ntransact(iov[0].iov_base, (char **)&parm,=0A=0A=0A     =
 
--0-1897494142-1285499135=:85622
Content-Type: application/octet-stream; name="patch.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch.diff"

LS0tIGEvZnMvY2lmcy9jaWZzc21iLmMJMjAxMC0wOS0yMCAyMzo1OTowOS4w
MDAwMDAwMDAgKzAzMDAKKysrIGIvZnMvY2lmcy9jaWZzc21iLmMJMjAxMC0w
OS0yNiAxMzowNTo0NS4yODEyNDEwOTUgKzAzMDAKQEAgLTMwNzksNyArMzA3
OSw3IEBAIENJRlNTTUJHZXRDSUZTQUNMKGNvbnN0IGludCB4aWQsIHN0cnVj
dAogCQlfX3UzMiBwYXJtX2xlbjsKIAkJX191MzIgYWNsX2xlbjsKIAkJc3Ry
dWN0IHNtYl9jb21fbnRyYW5zYWN0X3JzcCAqcFNNQnI7Ci0JCWNoYXIgKnBk
YXRhOworCQljaGFyICpwZGF0YSA9IE5VTEw7CiAKIC8qIHZhbGlkYXRlX250
dHJhbnNhY3QgKi8KIAkJcmMgPSB2YWxpZGF0ZV9udHJhbnNhY3QoaW92WzBd
Lmlvdl9iYXNlLCAoY2hhciAqKikmcGFybSwK

--0-1897494142-1285499135=:85622--
