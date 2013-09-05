From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 7/8] CIFS: Add create lease v2 context for SMB3
Date: Fri,  6 Sep 2013 00:15:02 +0400
Message-ID: <1378412103-29047-8-git-send-email-pshilovsky@samba.org>
References: <1378412103-29047-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378412103-29047-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2ops.c |   67 ++++++++++++++++++++++++++++++++++++++++++-----------
 fs/cifs/smb2pdu.h |   19 +++++++++++++++
 2 files changed, 73 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0215e60..a9256bd 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -714,6 +714,19 @@ smb21_is_read_op(__u32 oplock)
 	       !(oplock & SMB2_LEASE_WRITE_CACHING_HE);
 }
 
+static __le32
+map_oplock_to_lease(u8 oplock)
+{
+	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
+		return SMB2_LEASE_WRITE_CACHING | SMB2_LEASE_READ_CACHING;
+	else if (oplock == SMB2_OPLOCK_LEVEL_II)
+		return SMB2_LEASE_READ_CACHING;
+	else if (oplock == SMB2_OPLOCK_LEVEL_BATCH)
+		return SMB2_LEASE_HANDLE_CACHING | SMB2_LEASE_READ_CACHING |
+		       SMB2_LEASE_WRITE_CACHING;
+	return 0;
+}
+
 static char *
 smb2_create_lease_buf(u8 *lease_key, u8 oplock)
 {
@@ -725,15 +738,7 @@ smb2_create_lease_buf(u8 *lease_key, u8 oplock)
 
 	buf->lcontext.LeaseKeyLow = cpu_to_le64(*((u64 *)lease_key));
 	buf->lcontext.LeaseKeyHigh = cpu_to_le64(*((u64 *)(lease_key + 8)));
-	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
-		buf->lcontext.LeaseState = SMB2_LEASE_WRITE_CACHING |
-					   SMB2_LEASE_READ_CACHING;
-	else if (oplock == SMB2_OPLOCK_LEVEL_II)
-		buf->lcontext.LeaseState = SMB2_LEASE_READ_CACHING;
-	else if (oplock == SMB2_OPLOCK_LEVEL_BATCH)
-		buf->lcontext.LeaseState = SMB2_LEASE_HANDLE_CACHING |
-					   SMB2_LEASE_READ_CACHING |
-					   SMB2_LEASE_WRITE_CACHING;
+	buf->lcontext.LeaseState = map_oplock_to_lease(oplock);
 
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof
 					(struct create_lease, lcontext));
@@ -748,6 +753,32 @@ smb2_create_lease_buf(u8 *lease_key, u8 oplock)
 	return (char *)buf;
 }
 
+static char *
+smb3_create_lease_buf(u8 *lease_key, u8 oplock)
+{
+	struct create_lease_v2 *buf;
+
+	buf = kzalloc(sizeof(struct create_lease_v2), GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->lcontext.LeaseKeyLow = cpu_to_le64(*((u64 *)lease_key));
+	buf->lcontext.LeaseKeyHigh = cpu_to_le64(*((u64 *)(lease_key + 8)));
+	buf->lcontext.LeaseState = map_oplock_to_lease(oplock);
+
+	buf->ccontext.DataOffset = cpu_to_le16(offsetof
+					(struct create_lease_v2, lcontext));
+	buf->ccontext.DataLength = cpu_to_le32(sizeof(struct lease_context_v2));
+	buf->ccontext.NameOffset = cpu_to_le16(offsetof
+				(struct create_lease_v2, Name));
+	buf->ccontext.NameLength = cpu_to_le16(4);
+	buf->Name[0] = 'R';
+	buf->Name[1] = 'q';
+	buf->Name[2] = 'L';
+	buf->Name[3] = 's';
+	return (char *)buf;
+}
+
 static __u8
 smb2_parse_lease_buf(void *buf)
 {
@@ -758,6 +789,16 @@ smb2_parse_lease_buf(void *buf)
 	return le32_to_cpu(lc->lcontext.LeaseState);
 }
 
+static __u8
+smb3_parse_lease_buf(void *buf)
+{
+	struct create_lease_v2 *lc = (struct create_lease_v2 *)buf;
+
+	if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS)
+		return SMB2_OPLOCK_LEVEL_NOCHANGE;
+	return le32_to_cpu(lc->lcontext.LeaseState);
+}
+
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -969,8 +1010,8 @@ struct smb_version_operations smb30_operations = {
 	.calc_signature = smb3_calc_signature,
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb21_set_oplock_level,
-	.create_lease_buf = smb2_create_lease_buf,
-	.parse_lease_buf = smb2_parse_lease_buf,
+	.create_lease_buf = smb3_create_lease_buf,
+	.parse_lease_buf = smb3_parse_lease_buf,
 };
 
 struct smb_version_values smb20_values = {
@@ -1030,7 +1071,7 @@ struct smb_version_values smb30_values = {
 	.cap_large_files = SMB2_LARGE_FILES,
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
-	.create_lease_size = sizeof(struct create_lease),
+	.create_lease_size = sizeof(struct create_lease_v2),
 };
 
 struct smb_version_values smb302_values = {
@@ -1050,5 +1091,5 @@ struct smb_version_values smb302_values = {
 	.cap_large_files = SMB2_LARGE_FILES,
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
-	.create_lease_size = sizeof(struct create_lease),
+	.create_lease_size = sizeof(struct create_lease_v2),
 };
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index a2ec65a..b83d011 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -497,12 +497,31 @@ struct lease_context {
 	__le64 LeaseDuration;
 } __packed;
 
+struct lease_context_v2 {
+	__le64 LeaseKeyLow;
+	__le64 LeaseKeyHigh;
+	__le32 LeaseState;
+	__le32 LeaseFlags;
+	__le64 LeaseDuration;
+	__le64 ParentLeaseKeyLow;
+	__le64 ParentLeaseKeyHigh;
+	__le16 Epoch;
+	__le16 Reserved;
+} __packed;
+
 struct create_lease {
 	struct create_context ccontext;
 	__u8   Name[8];
 	struct lease_context lcontext;
 } __packed;
 
+struct create_lease_v2 {
+	struct create_context ccontext;
+	__u8   Name[8];
+	struct lease_context_v2 lcontext;
+	__u8   Pad[4];
+} __packed;
+
 struct create_durable {
 	struct create_context ccontext;
 	__u8   Name[8];
-- 
1.7.10.4
