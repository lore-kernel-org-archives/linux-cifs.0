From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 5/8] CIFS: Move creating lease buffer to ops struct
Date: Fri,  6 Sep 2013 00:15:00 +0400
Message-ID: <1378412103-29047-6-git-send-email-pshilovsky@samba.org>
References: <1378412103-29047-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378412103-29047-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to make adding new types of lease buffers easier.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    8 +++++---
 fs/cifs/smb2ops.c  |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c  |   52 ++++++++++------------------------------------------
 3 files changed, 56 insertions(+), 45 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6eef2e1..222a524 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -364,11 +364,11 @@ struct smb_version_operations {
 	/* push brlocks from the cache to the server */
 	int (*push_mand_locks)(struct cifsFileInfo *);
 	/* get lease key of the inode */
-	void (*get_lease_key)(struct inode *, struct cifs_fid *fid);
+	void (*get_lease_key)(struct inode *, struct cifs_fid *);
 	/* set lease key of the inode */
-	void (*set_lease_key)(struct inode *, struct cifs_fid *fid);
+	void (*set_lease_key)(struct inode *, struct cifs_fid *);
 	/* generate new lease key */
-	void (*new_lease_key)(struct cifs_fid *fid);
+	void (*new_lease_key)(struct cifs_fid *);
 	/* The next two functions will need to be changed to per smb session */
 	void (*generate_signingkey)(struct TCP_Server_Info *);
 	int (*calc_signature)(struct smb_rqst *, struct TCP_Server_Info *);
@@ -376,6 +376,7 @@ struct smb_version_operations {
 				struct cifs_sb_info *, unsigned int);
 	bool (*is_read_op)(__u32);
 	void (*set_oplock_level)(struct cifsInodeInfo *, __u32);
+	char * (*create_lease_buf)(u8 *, u8);
 };
 
 struct smb_version_values {
@@ -395,6 +396,7 @@ struct smb_version_values {
 	unsigned int	cap_large_files;
 	__u16		signing_enabled;
 	__u16		signing_required;
+	size_t		create_lease_size;
 };
 
 #define HEADER_SIZE(server) (server->vals->header_size)
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4656656..ecff4d6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -714,6 +714,40 @@ smb21_is_read_op(__u32 oplock)
 	       !(oplock & SMB2_LEASE_WRITE_CACHING_HE);
 }
 
+static char *
+smb2_create_lease_buf(u8 *lease_key, u8 oplock)
+{
+	struct create_lease *buf;
+
+	buf = kzalloc(sizeof(struct create_lease), GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->lcontext.LeaseKeyLow = cpu_to_le64(*((u64 *)lease_key));
+	buf->lcontext.LeaseKeyHigh = cpu_to_le64(*((u64 *)(lease_key + 8)));
+	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
+		buf->lcontext.LeaseState = SMB2_LEASE_WRITE_CACHING |
+					   SMB2_LEASE_READ_CACHING;
+	else if (oplock == SMB2_OPLOCK_LEVEL_II)
+		buf->lcontext.LeaseState = SMB2_LEASE_READ_CACHING;
+	else if (oplock == SMB2_OPLOCK_LEVEL_BATCH)
+		buf->lcontext.LeaseState = SMB2_LEASE_HANDLE_CACHING |
+					   SMB2_LEASE_READ_CACHING |
+					   SMB2_LEASE_WRITE_CACHING;
+
+	buf->ccontext.DataOffset = cpu_to_le16(offsetof
+					(struct create_lease, lcontext));
+	buf->ccontext.DataLength = cpu_to_le32(sizeof(struct lease_context));
+	buf->ccontext.NameOffset = cpu_to_le16(offsetof
+				(struct create_lease, Name));
+	buf->ccontext.NameLength = cpu_to_le16(4);
+	buf->Name[0] = 'R';
+	buf->Name[1] = 'q';
+	buf->Name[2] = 'L';
+	buf->Name[3] = 's';
+	return (char *)buf;
+}
+
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -781,6 +815,7 @@ struct smb_version_operations smb20_operations = {
 	.calc_signature = smb2_calc_signature,
 	.is_read_op = smb2_is_read_op,
 	.set_oplock_level = smb2_set_oplock_level,
+	.create_lease_buf = smb2_create_lease_buf,
 };
 
 struct smb_version_operations smb21_operations = {
@@ -850,6 +885,7 @@ struct smb_version_operations smb21_operations = {
 	.calc_signature = smb2_calc_signature,
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb21_set_oplock_level,
+	.create_lease_buf = smb2_create_lease_buf,
 };
 
 struct smb_version_operations smb30_operations = {
@@ -921,6 +957,7 @@ struct smb_version_operations smb30_operations = {
 	.calc_signature = smb3_calc_signature,
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb21_set_oplock_level,
+	.create_lease_buf = smb2_create_lease_buf,
 };
 
 struct smb_version_values smb20_values = {
@@ -940,6 +977,7 @@ struct smb_version_values smb20_values = {
 	.cap_large_files = SMB2_LARGE_FILES,
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
+	.create_lease_size = sizeof(struct create_lease),
 };
 
 struct smb_version_values smb21_values = {
@@ -959,6 +997,7 @@ struct smb_version_values smb21_values = {
 	.cap_large_files = SMB2_LARGE_FILES,
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
+	.create_lease_size = sizeof(struct create_lease),
 };
 
 struct smb_version_values smb30_values = {
@@ -978,6 +1017,7 @@ struct smb_version_values smb30_values = {
 	.cap_large_files = SMB2_LARGE_FILES,
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
+	.create_lease_size = sizeof(struct create_lease),
 };
 
 struct smb_version_values smb302_values = {
@@ -997,4 +1037,5 @@ struct smb_version_values smb302_values = {
 	.cap_large_files = SMB2_LARGE_FILES,
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
+	.create_lease_size = sizeof(struct create_lease),
 };
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 17862fe..c47b476 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -813,39 +813,6 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	return rc;
 }
 
-static struct create_lease *
-create_lease_buf(u8 *lease_key, u8 oplock)
-{
-	struct create_lease *buf;
-
-	buf = kzalloc(sizeof(struct create_lease), GFP_KERNEL);
-	if (!buf)
-		return NULL;
-
-	buf->lcontext.LeaseKeyLow = cpu_to_le64(*((u64 *)lease_key));
-	buf->lcontext.LeaseKeyHigh = cpu_to_le64(*((u64 *)(lease_key + 8)));
-	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
-		buf->lcontext.LeaseState = SMB2_LEASE_WRITE_CACHING |
-					   SMB2_LEASE_READ_CACHING;
-	else if (oplock == SMB2_OPLOCK_LEVEL_II)
-		buf->lcontext.LeaseState = SMB2_LEASE_READ_CACHING;
-	else if (oplock == SMB2_OPLOCK_LEVEL_BATCH)
-		buf->lcontext.LeaseState = SMB2_LEASE_HANDLE_CACHING |
-					   SMB2_LEASE_READ_CACHING |
-					   SMB2_LEASE_WRITE_CACHING;
-
-	buf->ccontext.DataOffset = cpu_to_le16(offsetof
-					(struct create_lease, lcontext));
-	buf->ccontext.DataLength = cpu_to_le32(sizeof(struct lease_context));
-	buf->ccontext.NameOffset = cpu_to_le16(offsetof
-				(struct create_lease, Name));
-	buf->ccontext.NameLength = cpu_to_le16(4);
-	buf->Name[0] = 'R';
-	buf->Name[1] = 'q';
-	buf->Name[2] = 'L';
-	buf->Name[3] = 's';
-	return buf;
-}
 
 static struct create_durable *
 create_durable_buf(void)
@@ -925,15 +892,16 @@ parse_lease_state(struct smb2_create_rsp *rsp)
 }
 
 static int
-add_lease_context(struct kvec *iov, unsigned int *num_iovec, __u8 *oplock)
+add_lease_context(struct TCP_Server_Info *server, struct kvec *iov,
+		  unsigned int *num_iovec, __u8 *oplock)
 {
 	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
-	iov[num].iov_base = create_lease_buf(oplock+1, *oplock);
+	iov[num].iov_base = server->ops->create_lease_buf(oplock+1, *oplock);
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
-	iov[num].iov_len = sizeof(struct create_lease);
+	iov[num].iov_len = server->vals->create_lease_size;
 	req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_LEASE;
 	if (!req->CreateContextsOffset)
 		req->CreateContextsOffset = cpu_to_le32(
@@ -941,8 +909,8 @@ add_lease_context(struct kvec *iov, unsigned int *num_iovec, __u8 *oplock)
 				iov[num - 1].iov_len);
 	req->CreateContextsLength = cpu_to_le32(
 				le32_to_cpu(req->CreateContextsLength) +
-				sizeof(struct create_lease));
-	inc_rfc1001_len(&req->hdr, sizeof(struct create_lease));
+				server->vals->create_lease_size);
+	inc_rfc1001_len(&req->hdr, server->vals->create_lease_size);
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -1049,11 +1017,11 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	if (!server->oplocks)
 		*oplock = SMB2_OPLOCK_LEVEL_NONE;
 
-	if (!(tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING) ||
+	if (!(server->capabilities & SMB2_GLOBAL_CAP_LEASING) ||
 	    *oplock == SMB2_OPLOCK_LEVEL_NONE)
 		req->RequestedOplockLevel = *oplock;
 	else {
-		rc = add_lease_context(iov, &num_iovecs, oplock);
+		rc = add_lease_context(server, iov, &num_iovecs, oplock);
 		if (rc) {
 			cifs_small_buf_release(req);
 			kfree(copy_path);
@@ -1063,11 +1031,11 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	if (*oplock == SMB2_OPLOCK_LEVEL_BATCH) {
 		/* need to set Next field of lease context if we request it */
-		if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING) {
+		if (server->capabilities & SMB2_GLOBAL_CAP_LEASING) {
 			struct create_context *ccontext =
 			    (struct create_context *)iov[num_iovecs-1].iov_base;
 			ccontext->Next =
-				cpu_to_le32(sizeof(struct create_lease));
+				cpu_to_le32(server->vals->create_lease_size);
 		}
 		rc = add_durable_context(iov, &num_iovecs, oparms);
 		if (rc) {
-- 
1.7.10.4
