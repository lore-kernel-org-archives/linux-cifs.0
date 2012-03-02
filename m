From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SMB2.2 Negotiation and typical operations work to Windows 8 from
 Pavel's current patch set
Date: Thu, 1 Mar 2012 19:06:01 -0600
Message-ID: <CAH2r5msVkD_2zdpmb5+DRtxASYThitJ3=-t80G-sZx08H=wwWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

=46orgot to include subject line

=46unctional testing went pretty well this week.  I did get a test
failure on one of the connectathon lock tests and one of the "special"
tests, and I didn't turn on cifsacl support, but nothing critical.


---------- Forwarded message ----------
=46rom: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Thu, Mar 1, 2012 at 7:03 PM
Subject:
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Shilovsky
<piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Turns out it is easy to negotiate SMB2.2 against Windows 8 (rather
than just 2.1 or 2.0 as Pavel's current git tree does). =A0Basic
operations worked fine. =A0SMB2.2 is a very cool protocol, but since
most features are optional, upgrading to SMB2.2 is not bad. =A0For
example this change to Pavel's git tree is trivial:

diff -U 4 fs/smb2/smb2pdu.c fs/cifs/smb2pdu.c
--- fs/smb2/smb2pdu.c =A0 2012-03-01 18:30:24.986486510 -0600
+++ fs/cifs/smb2pdu.c =A0 2012-03-01 18:33:35.066765305 -0600
@@ -357,20 +357,22 @@
=A0 =A0 =A0 =A0else if (resp_buftype =3D=3D CIFS_LARGE_BUFFER)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_buf_release(pSMB2r);
=A0}

-#define SMB2_NUM_PROT 2
+#define SMB2_NUM_PROT 3

=A0#define SMB2_PROT =A0 0
=A0#define SMB21_PROT =A01
+#define SMB22_PROT =A02
=A0#define BAD_PROT 0xFFFF

=A0static struct {
=A0 =A0 =A0 =A0int index;
=A0 =A0 =A0 =A0__le16 name;
=A0} smb2protocols[] =3D {
=A0 =A0 =A0 =A0{SMB2_PROT, =A0cpu_to_le16(SMB2_PROT_ID)},
=A0 =A0 =A0 =A0{SMB21_PROT, cpu_to_le16(SMB21_PROT_ID)},
+ =A0 =A0 =A0 {SMB22_PROT, cpu_to_le16(SMB22_PROT_ID)},
=A0 =A0 =A0 =A0{BAD_PROT, =A0 cpu_to_le16(BAD_PROT_ID)}
=A0};

=A0/*
@@ -464,9 +466,11 @@
=A0 =A0 =A0 =A0}

=A0 =A0 =A0 =A0cFYI(1, "mode 0x%x", pSMB2r->SecurityMode);

- =A0 =A0 =A0 if (pSMB2r->DialectRevision =3D=3D smb2protocols[SMB21_PR=
OT].name)
+ =A0 =A0 =A0 if (pSMB2r->DialectRevision =3D=3D smb2protocols[SMB22_PR=
OT].name)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "negotiated smb2.2 dialect");
+ =A0 =A0 =A0 else if (pSMB2r->DialectRevision =3D=3D smb2protocols[SMB=
21_PROT].name)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "negotiated smb2.1 dialect");
=A0 =A0 =A0 =A0else if (pSMB2r->DialectRevision =3D=3D smb2protocols[SM=
B2_PROT].name)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "negotiated smb2 dialect");
=A0 =A0 =A0 =A0else {
diff -U 4 fs/smb2/smb2pdu.h fs/cifs/smb2pdu.h
--- fs/smb2/smb2pdu.h =A0 2012-03-01 18:30:24.986486510 -0600
+++ fs/cifs/smb2pdu.h =A0 2012-03-01 18:32:11.896643315 -0600
@@ -38,8 +38,10 @@
=A0*/

=A0#define SMB2_PROT_ID =A00x0202
=A0#define SMB21_PROT_ID 0x0210
+#define SMB22_PROT_ID 0x0224
+
=A0#define BAD_PROT_ID =A0 0xFFFF

=A0/* List is sent on wire as little endian */
=A0#define SMB2_NEGOTIATE =A0 =A0 =A0 =A0 cpu_to_le16(0x0000)

--
Thanks,

Steve


--=20
Thanks,

Steve
