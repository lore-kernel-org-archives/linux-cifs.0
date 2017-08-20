From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 2/8] CIFS: Improve 27 size determinations
Date: Sun, 20 Aug 2017 18:35:28 +0200
Message-ID: <1d8389c3-c216-b434-5f17-e6dfd05d1a80@users.sourceforge.net>
References: <826310e5-e01c-38af-90df-c5630f761a4d@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <826310e5-e01c-38af-90df-c5630f761a4d-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-GB
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Sun, 20 Aug 2017 15:40:55 +0200

Replace the specification of data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 fs/cifs/cifsacl.c  |  8 ++++----
 fs/cifs/cifsfs.c   |  2 +-
 fs/cifs/cifssmb.c  |  4 +---
 fs/cifs/dir.c      |  4 ++--
 fs/cifs/ioctl.c    |  2 +-
 fs/cifs/readdir.c  |  2 +-
 fs/cifs/sess.c     |  2 +-
 fs/cifs/smb1ops.c  |  2 +-
 fs/cifs/smb2file.c |  4 ++--
 fs/cifs/smb2misc.c |  2 +-
 fs/cifs/smb2ops.c  | 20 +++++++++-----------
 fs/cifs/smb2pdu.c  | 11 +++++------
 12 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index b98436f5c7c7..e92a2e70fdea 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -945,8 +945,8 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 			uid_t id;
 			owner_sid_ptr = (struct cifs_sid *)((char *)pnntsd +
 					le32_to_cpu(pnntsd->osidoffset));
-			nowner_sid_ptr = kmalloc(sizeof(struct cifs_sid),
-								GFP_KERNEL);
+			nowner_sid_ptr = kmalloc(sizeof(*nowner_sid_ptr),
+						 GFP_KERNEL);
 			if (!nowner_sid_ptr)
 				return -ENOMEM;
 			id = from_kuid(&init_user_ns, uid);
@@ -965,8 +965,8 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 			gid_t id;
 			group_sid_ptr = (struct cifs_sid *)((char *)pnntsd +
 					le32_to_cpu(pnntsd->gsidoffset));
-			ngroup_sid_ptr = kmalloc(sizeof(struct cifs_sid),
-								GFP_KERNEL);
+			ngroup_sid_ptr = kmalloc(sizeof(*ngroup_sid_ptr),
+						 GFP_KERNEL);
 			if (!ngroup_sid_ptr)
 				return -ENOMEM;
 			id = from_kgid(&init_user_ns, gid);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 180b3356ff86..b5694ac68ef5 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -686,7 +686,7 @@ cifs_do_mount(struct file_system_type *fs_type,
 	if (IS_ERR(volume_info))
 		return ERR_CAST(volume_info);
 
-	cifs_sb = kzalloc(sizeof(struct cifs_sb_info), GFP_KERNEL);
+	cifs_sb = kzalloc(sizeof(*cifs_sb), GFP_KERNEL);
 	if (cifs_sb == NULL) {
 		root = ERR_PTR(-ENOMEM);
 		goto out_nls;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 118a63e7e221..8c61a1fd2bf8 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -6432,9 +6432,7 @@ int CIFSSMBNotify(const unsigned int xid, struct cifs_tcon *tcon,
 	} else {
 		/* Add file to outstanding requests */
 		/* BB change to kmem cache alloc */
-		dnotify_req = kmalloc(
-						sizeof(struct dir_notify_req),
-						 GFP_KERNEL);
+		dnotify_req = kmalloc(sizeof(*dnotify_req), GFP_KERNEL);
 		if (dnotify_req) {
 			dnotify_req->Pid = pSMB->hdr.Pid;
 			dnotify_req->PidHigh = pSMB->hdr.PidHigh;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 56366e984076..7dd7ca1afe0b 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -339,7 +339,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 		goto out;
 	}
 
-	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -683,7 +683,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 
 	cifs_dbg(FYI, "sfu compat create special file\n");
 
-	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
 	if (buf == NULL) {
 		kfree(full_path);
 		rc = -ENOMEM;
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 54f32f9143a9..140c49c128b3 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -89,7 +89,7 @@ static long smb_mnt_get_fsinfo(unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	struct smb_mnt_fs_info *fsinf;
 
-	fsinf = kzalloc(sizeof(struct smb_mnt_fs_info), GFP_KERNEL);
+	fsinf = kzalloc(sizeof(*fsinf), GFP_KERNEL);
 	if (fsinf == NULL)
 		return -ENOMEM;
 
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index a27fc8791551..a3cfb2e1cfcd 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -280,7 +280,7 @@ initiate_cifs_search(const unsigned int xid, struct file *file)
 		if (IS_ERR(tlink))
 			return PTR_ERR(tlink);
 
-		cifsFile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
+		cifsFile = kzalloc(sizeof(*cifsFile), GFP_KERNEL);
 		if (cifsFile == NULL) {
 			rc = -ENOMEM;
 			goto error_exit;
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 2fb36bbaf5b0..382f868279f6 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1446,7 +1446,7 @@ int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 		return -EINVAL;
 	}
 
-	sess_data = kzalloc(sizeof(struct sess_data), GFP_KERNEL);
+	sess_data = kzalloc(sizeof(*sess_data), GFP_KERNEL);
 	if (!sess_data)
 		return -ENOMEM;
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index a723df3e0197..aad345a91ac9 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -525,7 +525,7 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	FILE_ALL_INFO *file_info;
 
-	file_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
+	file_info = kmalloc(sizeof(*file_info), GFP_KERNEL);
 	if (file_info == NULL)
 		return -ENOMEM;
 
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index b4b1f0305f29..21bff61cf818 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -131,7 +131,7 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 		return -EINVAL;
 
 	max_num = max_buf / sizeof(struct smb2_lock_element);
-	buf = kcalloc(max_num, sizeof(struct smb2_lock_element), GFP_KERNEL);
+	buf = kcalloc(max_num, sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -267,7 +267,7 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	}
 
 	max_num = max_buf / sizeof(struct smb2_lock_element);
-	buf = kcalloc(max_num, sizeof(struct smb2_lock_element), GFP_KERNEL);
+	buf = kcalloc(max_num, sizeof(*buf), GFP_KERNEL);
 	if (!buf) {
 		free_xid(xid);
 		return -ENOMEM;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 7b08a1446a7f..6f0997a25ea8 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -537,7 +537,7 @@ smb2_is_valid_lease_break(char *buffer)
 	struct cifs_tcon *tcon;
 	struct smb2_lease_break_work *lw;
 
-	lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
+	lw = kmalloc(sizeof(*lw), GFP_KERNEL);
 	if (!lw)
 		return false;
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 783b5d263704..fc3e598ac1c6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -608,8 +608,7 @@ smb2_copychunk_range(const unsigned int xid,
 	bool chunk_sizes_updated = false;
 	ssize_t bytes_written, total_bytes_written = 0;
 
-	pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
-
+	pcchunk = kmalloc(sizeof(*pcchunk), GFP_KERNEL);
 	if (pcchunk == NULL)
 		return -ENOMEM;
 
@@ -1750,7 +1749,7 @@ smb2_create_lease_buf(u8 *lease_key, u8 oplock)
 {
 	struct create_lease *buf;
 
-	buf = kzalloc(sizeof(struct create_lease), GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
@@ -1777,7 +1776,7 @@ smb3_create_lease_buf(u8 *lease_key, u8 oplock)
 {
 	struct create_lease_v2 *buf;
 
-	buf = kzalloc(sizeof(struct create_lease_v2), GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
@@ -1860,7 +1859,7 @@ init_sg(struct smb_rqst *rqst, u8 *sign)
 	unsigned int i;
 	unsigned int j;
 
-	sg = kmalloc_array(sg_len, sizeof(struct scatterlist), GFP_KERNEL);
+	sg = kmalloc_array(sg_len, sizeof(*sg), GFP_KERNEL);
 	if (!sg)
 		return NULL;
 
@@ -2029,7 +2028,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 	int i;
 	int rc = -ENOMEM;
 
-	pages = kmalloc_array(npages, sizeof(struct page *), GFP_KERNEL);
+	pages = kmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
 	if (!pages)
 		return rc;
 
@@ -2044,7 +2043,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 			goto err_free_pages;
 	}
 
-	iov = kmalloc_array(old_rq->rq_nvec, sizeof(struct kvec), GFP_KERNEL);
+	iov = kmalloc_array(old_rq->rq_nvec, sizeof(*iov), GFP_KERNEL);
 	if (!iov)
 		goto err_free_pages;
 
@@ -2054,7 +2053,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 	new_rq->rq_iov = iov;
 	new_rq->rq_nvec = old_rq->rq_nvec;
 
-	tr_hdr = kmalloc(sizeof(struct smb2_transform_hdr), GFP_KERNEL);
+	tr_hdr = kmalloc(sizeof(*tr_hdr), GFP_KERNEL);
 	if (!tr_hdr)
 		goto err_free_iov;
 
@@ -2185,7 +2184,7 @@ init_read_bvec(struct page **pages, unsigned int npages, unsigned int data_size,
 	struct bio_vec *bvec;
 	int i;
 
-	bvec = kcalloc(npages, sizeof(struct bio_vec), GFP_KERNEL);
+	bvec = kcalloc(npages, sizeof(*bvec), GFP_KERNEL);
 	if (!bvec)
 		return -ENOMEM;
 
@@ -2355,8 +2354,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid)
 	len = le32_to_cpu(tr_hdr->OriginalMessageSize) + 4 -
 						server->vals->read_rsp_size;
 	npages = DIV_ROUND_UP(len, PAGE_SIZE);
-
-	pages = kmalloc_array(npages, sizeof(struct page *), GFP_KERNEL);
+	pages = kmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
 	if (!pages) {
 		rc = -ENOMEM;
 		goto discard_data;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 668732e6f80f..328fefeaf924 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1075,7 +1075,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 		return -EIO;
 	}
 
-	sess_data = kzalloc(sizeof(struct SMB2_sess_data), GFP_KERNEL);
+	sess_data = kzalloc(sizeof(*sess_data), GFP_KERNEL);
 	if (!sess_data)
 		return -ENOMEM;
 
@@ -1320,7 +1320,7 @@ create_durable_buf(void)
 {
 	struct create_durable *buf;
 
-	buf = kzalloc(sizeof(struct create_durable), GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
@@ -1343,7 +1343,7 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
 {
 	struct create_durable *buf;
 
-	buf = kzalloc(sizeof(struct create_durable), GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
@@ -1420,7 +1420,7 @@ create_durable_v2_buf(struct cifs_fid *pfid)
 {
 	struct create_durable_v2 *buf;
 
-	buf = kzalloc(sizeof(struct create_durable_v2), GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
@@ -1449,8 +1449,7 @@ create_reconnect_durable_v2_buf(struct cifs_fid *fid)
 {
 	struct create_durable_handle_reconnect_v2 *buf;
 
-	buf = kzalloc(sizeof(struct create_durable_handle_reconnect_v2),
-			GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
-- 
2.14.0
