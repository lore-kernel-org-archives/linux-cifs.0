From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS][PATCH] Clarify SMB2/SMB3 create context and add missing ones
Date: Wed, 14 May 2014 14:38:35 +0200
Message-ID: <CAH2r5msf8eC=a3RDNb9DRwPaCj56K0bZw2rUjOctM=3HNb+0dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>From 0042cf22e164f9f38934e994a2811c35251e88c0 Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Wed, 14 May 2014 05:29:40 -0700
Subject: [PATCH] [CIFS] Clarify SMB2/SMB3 create context and add missing ones

Clarify comments for create contexts which we do send,
and fix typo in one create context definition and add
newer SMB3 create contexts to the list.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2ops.c |    2 ++
 fs/cifs/smb2pdu.c |    2 ++
 fs/cifs/smb2pdu.h |    6 +++++-
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 35ddc3e..787844b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1047,6 +1047,7 @@ smb2_create_lease_buf(u8 *lease_key, u8 oplock)
  buf->ccontext.NameOffset = cpu_to_le16(offsetof
  (struct create_lease, Name));
  buf->ccontext.NameLength = cpu_to_le16(4);
+ /* SMB2_CREATE_REQUEST_LEASE is "RqLs" */
  buf->Name[0] = 'R';
  buf->Name[1] = 'q';
  buf->Name[2] = 'L';
@@ -1073,6 +1074,7 @@ smb3_create_lease_buf(u8 *lease_key, u8 oplock)
  buf->ccontext.NameOffset = cpu_to_le16(offsetof
  (struct create_lease_v2, Name));
  buf->ccontext.NameLength = cpu_to_le16(4);
+ /* SMB2_CREATE_REQUEST_LEASE is "RqLs" */
  buf->Name[0] = 'R';
  buf->Name[1] = 'q';
  buf->Name[2] = 'L';
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0feb743..b0037b6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -972,6 +972,7 @@ create_durable_buf(void)
  buf->ccontext.NameOffset = cpu_to_le16(offsetof
  (struct create_durable, Name));
  buf->ccontext.NameLength = cpu_to_le16(4);
+ /* SMB2_CREATE_DURABLE_HANDLE_REQUEST is "DHnQ" */
  buf->Name[0] = 'D';
  buf->Name[1] = 'H';
  buf->Name[2] = 'n';
@@ -996,6 +997,7 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
  buf->ccontext.NameLength = cpu_to_le16(4);
  buf->Data.Fid.PersistentFileId = fid->persistent_fid;
  buf->Data.Fid.VolatileFileId = fid->volatile_fid;
+ /* SMB2_CREATE_DURABLE_HANDLE_RECONNECT is "DHnC" */
  buf->Name[0] = 'D';
  buf->Name[1] = 'H';
  buf->Name[2] = 'n';
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 743e11e..69f3595 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -435,11 +435,15 @@ struct smb2_tree_disconnect_rsp {
 #define SMB2_CREATE_SD_BUFFER "SecD" /* security descriptor */
 #define SMB2_CREATE_DURABLE_HANDLE_REQUEST "DHnQ"
 #define SMB2_CREATE_DURABLE_HANDLE_RECONNECT "DHnC"
-#define SMB2_CREATE_ALLOCATION_SIZE "AlSi"
+#define SMB2_CREATE_ALLOCATION_SIZE "AISi"
 #define SMB2_CREATE_QUERY_MAXIMAL_ACCESS_REQUEST "MxAc"
 #define SMB2_CREATE_TIMEWARP_REQUEST "TWrp"
 #define SMB2_CREATE_QUERY_ON_DISK_ID "QFid"
 #define SMB2_CREATE_REQUEST_LEASE "RqLs"
+#define SMB2_CREATE_DURABLE_HANDLE_REQUEST_V2 "DH2Q"
+#define SMB2_CREATE_DURABLE_HANDLE_RECONNECT_V2 "DH2C"
+#define SMB2_CREATE_APP_INSTANCE_ID 0x45BCA66AEFA7F74A9008FA462E144D74
+#define SVHDX_OPEN_DEVICE_CONTEXT 0x83CE6F1AD851E0986E34401CC9BCFCE9

 struct smb2_create_req {
  struct smb2_hdr hdr;
-- 
1.7.0.4



-- 
Thanks,

Steve
