From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS][PATCH] Warn if per-share encryption requested
Date: Fri, 15 Nov 2013 23:52:40 -0600
Message-ID: <CAH2r5msR4B_GB0kkxTj_nwRCE5pA5pcg+Mg9b=ueou6irXY3Cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>From 0cbaa53cdd33080c1e2d67ad9295b83c7954f2b3 Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, 15 Nov 2013 23:50:24 -0600
Subject: [PATCH] [CIFS] Warn if SMB3 encryption required by server

We do not support SMB3 encryption yet, warn if server responds
that SMB3 encryption is mandatory.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2pdu.c |  2 ++
 fs/cifs/smb2pdu.h | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ca7f307..d65270c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -630,6 +630,8 @@ ssetup_ntlmssp_authenticate:
         goto ssetup_exit;

     ses->session_flags = le16_to_cpu(rsp->SessionFlags);
+    if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
+        cifs_dbg(VFS, "SMB3 encryption not supported yet\n");
 ssetup_exit:
     free_rsp_buf(resp_buftype, rsp);

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index b50a129..f88320b 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -122,6 +122,23 @@ struct smb2_pdu {
     __le16 StructureSize2; /* size of wct area (varies, request specific) */
 } __packed;

+struct smb2_transform_hdr {
+    __be32 smb2_buf_length;    /* big endian on wire */
+                /* length is only two or three bytes - with
+                 one or two byte type preceding it that MBZ */
+    __u8   ProtocolId[4];    /* 0xFD 'S' 'M' 'B' */
+    __u8   Signature[16];
+    __u8   Nonce[11];
+    __u8   Reserved[5];
+    __le32 OriginalMessageSize;
+    __u16  Reserved1;
+    __le16 EncryptionAlgorithm;
+    __u64  SessionId;
+} __packed;
+
+/* Encryption Algorithms */
+#define SMB2_ENCRYPTION_AES128_CCM    __constant_cpu_to_le16(0x0001)
+
 /*
  *    SMB2 flag definitions
  */
@@ -237,6 +254,7 @@ struct smb2_sess_setup_req {
 /* Currently defined SessionFlags */
 #define SMB2_SESSION_FLAG_IS_GUEST    0x0001
 #define SMB2_SESSION_FLAG_IS_NULL    0x0002
+#define SMB2_SESSION_FLAG_ENCRYPT_DATA    0x0004
 struct smb2_sess_setup_rsp {
     struct smb2_hdr hdr;
     __le16 StructureSize; /* Must be 9 */
-- 
1.8.3.1


-- 
Thanks,

Steve
