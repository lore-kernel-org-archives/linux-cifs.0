From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: (unknown)
Date: Thu, 1 Mar 2012 19:03:31 -0600
Message-ID: <CAH2r5muLpNMSa3qgPswa6P4A_HtmZ9FnR9wPs=BFHVGonh=q_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Subject: 
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Turns out it is easy to negotiate SMB2.2 against Windows 8 (rather
than just 2.1 or 2.0 as Pavel's current git tree does).  Basic
operations worked fine.  SMB2.2 is a very cool protocol, but since
most features are optional, upgrading to SMB2.2 is not bad.  For
example this change to Pavel's git tree is trivial:

diff -U 4 fs/smb2/smb2pdu.c fs/cifs/smb2pdu.c
--- fs/smb2/smb2pdu.c	2012-03-01 18:30:24.986486510 -0600
+++ fs/cifs/smb2pdu.c	2012-03-01 18:33:35.066765305 -0600
@@ -357,20 +357,22 @@
 	else if (resp_buftype == CIFS_LARGE_BUFFER)
 		cifs_buf_release(pSMB2r);
 }

-#define SMB2_NUM_PROT 2
+#define SMB2_NUM_PROT 3

 #define SMB2_PROT   0
 #define SMB21_PROT  1
+#define SMB22_PROT  2
 #define BAD_PROT 0xFFFF

 static struct {
 	int index;
 	__le16 name;
 } smb2protocols[] = {
 	{SMB2_PROT,  cpu_to_le16(SMB2_PROT_ID)},
 	{SMB21_PROT, cpu_to_le16(SMB21_PROT_ID)},
+	{SMB22_PROT, cpu_to_le16(SMB22_PROT_ID)},
 	{BAD_PROT,   cpu_to_le16(BAD_PROT_ID)}
 };

 /*
@@ -464,9 +466,11 @@
 	}

 	cFYI(1, "mode 0x%x", pSMB2r->SecurityMode);

-	if (pSMB2r->DialectRevision == smb2protocols[SMB21_PROT].name)
+	if (pSMB2r->DialectRevision == smb2protocols[SMB22_PROT].name)
+		cFYI(1, "negotiated smb2.2 dialect");
+	else if (pSMB2r->DialectRevision == smb2protocols[SMB21_PROT].name)
 		cFYI(1, "negotiated smb2.1 dialect");
 	else if (pSMB2r->DialectRevision == smb2protocols[SMB2_PROT].name)
 		cFYI(1, "negotiated smb2 dialect");
 	else {
diff -U 4 fs/smb2/smb2pdu.h fs/cifs/smb2pdu.h
--- fs/smb2/smb2pdu.h	2012-03-01 18:30:24.986486510 -0600
+++ fs/cifs/smb2pdu.h	2012-03-01 18:32:11.896643315 -0600
@@ -38,8 +38,10 @@
  */

 #define SMB2_PROT_ID  0x0202
 #define SMB21_PROT_ID 0x0210
+#define SMB22_PROT_ID 0x0224
+
 #define BAD_PROT_ID   0xFFFF

 /* List is sent on wire as little endian */
 #define SMB2_NEGOTIATE		cpu_to_le16(0x0000)

-- 
Thanks,

Steve
