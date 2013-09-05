From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 6/8] CIFS: Move parsing lease buffer to ops struct
Date: Fri,  6 Sep 2013 00:15:01 +0400
Message-ID: <1378412103-29047-7-git-send-email-pshilovsky@samba.org>
References: <1378412103-29047-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378412103-29047-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/smb2ops.c  |   13 +++++++++++++
 fs/cifs/smb2pdu.c  |   27 ++++++++++-----------------
 3 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 222a524..471d8f9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -377,6 +377,7 @@ struct smb_version_operations {
 	bool (*is_read_op)(__u32);
 	void (*set_oplock_level)(struct cifsInodeInfo *, __u32);
 	char * (*create_lease_buf)(u8 *, u8);
+	__u8 (*parse_lease_buf)(void *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ecff4d6..0215e60 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -748,6 +748,16 @@ smb2_create_lease_buf(u8 *lease_key, u8 oplock)
 	return (char *)buf;
 }
 
+static __u8
+smb2_parse_lease_buf(void *buf)
+{
+	struct create_lease *lc = (struct create_lease *)buf;
+
+	if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS)
+		return SMB2_OPLOCK_LEVEL_NOCHANGE;
+	return le32_to_cpu(lc->lcontext.LeaseState);
+}
+
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -816,6 +826,7 @@ struct smb_version_operations smb20_operations = {
 	.is_read_op = smb2_is_read_op,
 	.set_oplock_level = smb2_set_oplock_level,
 	.create_lease_buf = smb2_create_lease_buf,
+	.parse_lease_buf = smb2_parse_lease_buf,
 };
 
 struct smb_version_operations smb21_operations = {
@@ -886,6 +897,7 @@ struct smb_version_operations smb21_operations = {
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb21_set_oplock_level,
 	.create_lease_buf = smb2_create_lease_buf,
+	.parse_lease_buf = smb2_parse_lease_buf,
 };
 
 struct smb_version_operations smb30_operations = {
@@ -958,6 +970,7 @@ struct smb_version_operations smb30_operations = {
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb21_set_oplock_level,
 	.create_lease_buf = smb2_create_lease_buf,
+	.parse_lease_buf = smb2_parse_lease_buf,
 };
 
 struct smb_version_values smb20_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c47b476..603d311 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -861,34 +861,27 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
 }
 
 static __u8
-parse_lease_state(struct smb2_create_rsp *rsp)
+parse_lease_state(struct TCP_Server_Info *server, struct smb2_create_rsp *rsp)
 {
 	char *data_offset;
-	struct create_lease *lc;
-	bool found = false;
+	struct create_context *cc;
 	unsigned int next = 0;
 	char *name;
 
 	data_offset = (char *)rsp + 4 + le32_to_cpu(rsp->CreateContextsOffset);
-	lc = (struct create_lease *)data_offset;
+	cc = (struct create_context *)data_offset;
 	do {
-		lc = (struct create_lease *)((char *)lc + next);
-		name = le16_to_cpu(lc->ccontext.NameOffset) + (char *)lc;
-		if (le16_to_cpu(lc->ccontext.NameLength) != 4 ||
+		cc = (struct create_context *)((char *)cc + next);
+		name = le16_to_cpu(cc->NameOffset) + (char *)cc;
+		if (le16_to_cpu(cc->NameLength) != 4 ||
 		    strncmp(name, "RqLs", 4)) {
-			next = le32_to_cpu(lc->ccontext.Next);
+			next = le32_to_cpu(cc->Next);
 			continue;
 		}
-		if (lc->lcontext.LeaseFlags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS)
-			return SMB2_OPLOCK_LEVEL_NOCHANGE;
-		found = true;
-		break;
+		return server->ops->parse_lease_buf(cc);
 	} while (next != 0);
 
-	if (!found)
-		return 0;
-
-	return le32_to_cpu(lc->lcontext.LeaseState);
+	return 0;
 }
 
 static int
@@ -1070,7 +1063,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	}
 
 	if (rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE)
-		*oplock = parse_lease_state(rsp);
+		*oplock = parse_lease_state(server, rsp);
 	else
 		*oplock = rsp->OplockLevel;
 creat_exit:
-- 
1.7.10.4
