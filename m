Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B5236EA80
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 07:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783926733; cv=none; b=Ma/OzC0cRdUUsMpm/9oM0FaC3qSQVC2QWCVXJ4LRDrUy1xtU1MKONDGLJxK1//3WZ8DNKufkRj/soEC60rV2HlOKNPSp8AMDwoTnNTU7+9HSn1XOZzLLqpot4x8iXWiXA0UfAquHULHghjkbkWjdM/6CzjinlVm1LnS4kgcoab8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783926733; c=relaxed/simple;
	bh=db3JFSG7OjLdGI3YCvK0PZnnUeX5Sn2l6rYLl0OdV7k=;
	h=Message-Id:Mime-Version:To:Cc:Date:Subject:In-Reply-To:
	 Content-Type:From:References; b=Ket10c26bBWmMdBnbXAX7NNJVBct/59KxpZvqv9E62hrR2k4pJZdLue6PPsLhChEF6iXdKaEdv3z4QnSP8GPSr0QwKNV51j2ilw+cS/gfCOS8qHqZNH3yfArvGkAcR7RLHTk+4Zz5EanJJGK7dSfoDOuNjBpNDGdnA5dZ5mlSSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=XCSyEf+v; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="XCSyEf+v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783926726;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=0rEphVK5/6ke2PIYY6Uc03BOGm7dYzNeTT3fi75D3ak=;
 b=XCSyEf+vb5+a/09RQc5I48Odg0xTaWBKMNTm95meYIjnS1mdg2PXDPeVhOnum9PxYUrOAa
 QA1SpWNhNlMyz8U1X1iRupXU/zyG1Ma9NbqXryoEfKFevIXYQOPcxDMjtTW0UGaot+pKWr
 zMg/jFklEUgT+hVWoPo/vCIcJ8GOmLECmTIelwfOcIrx5jUStq33SVUFUbseHtFanK+aFk
 91GtI0ekuYkc/welm3acoikwMXUu8x6pt5auQMNL5Rw2CntxEirzQHB0Wt7gugaUr45xQ+
 gFkgEMB1RwXMYrn6bkQwXOWy0Eb5ASgOvLYnBRwPar4/Jx57LHAAc1nN+ZXlGw==
Message-Id: <20260713071141.3909087-3-wangzhaolong@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a548fc4+b0bf8f+vger.kernel.org+wangzhaolong@fnnas.com>
X-Mailer: git-send-email 2.47.3
To: <linux-cifs@vger.kernel.org>
Cc: <linkinjeon@kernel.org>, <smfrench@gmail.com>, 
	<senozhatsky@chromium.org>, <tom@talpey.com>, 
	<linux-kernel@vger.kernel.org>, "Wang Zhaolong" <wangzhaolong@fnnas.com>
Date: Mon, 13 Jul 2026 15:11:39 +0800
X-Original-From: wang zhaolong <wangzhaolong@fnnas.com>
Received: from localhost.localdomain ([183.34.174.151]) by smtp.feishu.cn with ESMTPS; Mon, 13 Jul 2026 15:12:03 +0800
Subject: [RFC 2/3] ksmbd: add splice-based read payload helper
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260713071141.3909087-1-wangzhaolong@fnnas.com>
Content-Type: text/plain; charset=UTF-8
From: "wang zhaolong" <wangzhaolong@fnnas.com>
References: <20260713071141.3909087-1-wangzhaolong@fnnas.com>

From: Wang Zhaolong <wangzhaolong@fnnas.com>

Add ksmbd_vfs_read_payload() to collect page-cache backed splice buffers
into a bio_vec payload. The actor takes a reference to every page so the
payload remains valid after the internal splice pipe is drained.

Preserve the buffered READ path's directory, zero-length, access and
byte-range lock semantics. Streams, non-regular files, O_DIRECT, DAX and
files without splice_read support return -EOPNOTSUPP with the offset
unchanged, allowing the caller to retry through kernel_read(). A short read
before EOF is handled the same way to preserve the existing READ data path.

Signed-off-by: Wang Zhaolong <wangzhaolong@fnnas.com>
---
 fs/smb/server/vfs.c | 195 ++++++++++++++++++++++++++++++++++++++------
 fs/smb/server/vfs.h |   4 +
 2 files changed, 176 insertions(+), 23 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index d0a0ad15d803..3a3f1b8e2d33 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -17,10 +17,13 @@
 #include <linux/dcache.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/xacct.h>
 #include <linux/crc32c.h>
+#include <linux/net.h>
+#include <linux/overflow.h>
+#include <linux/pipe_fs_i.h>
 #include <linux/splice.h>
 #include <linux/fileattr.h>
 
 #include "glob.h"
 #include "oplock.h"
@@ -326,10 +329,33 @@ static int check_lock_range(struct file *filp, loff_t start, loff_t end,
 out:
 	spin_unlock(&ctx->flc_lock);
 	return error;
 }
 
+static int ksmbd_vfs_check_read_access(struct ksmbd_work *work,
+				       struct ksmbd_file *fp)
+{
+	if (work->conn->connection_type &&
+	    !(fp->daccess & (FILE_READ_DATA_LE | FILE_EXECUTE_LE))) {
+		pr_err("no right to read(%pD)\n", fp->filp);
+		return -EACCES;
+	}
+	return 0;
+}
+
+static int ksmbd_vfs_check_read_range(struct ksmbd_work *work,
+				      struct ksmbd_file *fp, loff_t pos,
+				      size_t count)
+{
+	if (!work->tcon->posix_extensions &&
+	    check_lock_range(fp->filp, pos, pos + count - 1, READ)) {
+		pr_err("unable to read due to lock\n");
+		return -EAGAIN;
+	}
+	return 0;
+}
+
 /**
  * ksmbd_vfs_read() - vfs helper for smb file read
  * @work:	smb work
  * @fp:		ksmbd file pointer
  * @count:	read byte count
@@ -340,47 +366,170 @@ static int check_lock_range(struct file *filp, loff_t start, loff_t end,
  */
 int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 		   loff_t *pos, char *rbuf)
 {
 	struct file *filp = fp->filp;
-	ssize_t nbytes = 0;
-	struct inode *inode = file_inode(filp);
+	ssize_t nbytes;
+	int ret;
 
-	if (S_ISDIR(inode->i_mode))
+	if (S_ISDIR(file_inode(filp)->i_mode))
 		return -EISDIR;
-
 	if (unlikely(count == 0))
 		return 0;
-
-	if (work->conn->connection_type) {
-		if (!(fp->daccess & (FILE_READ_DATA_LE | FILE_EXECUTE_LE))) {
-			pr_err("no right to read(%pD)\n", fp->filp);
-			return -EACCES;
-		}
-	}
-
+	ret = ksmbd_vfs_check_read_access(work, fp);
+	if (ret)
+		return ret;
 	if (ksmbd_stream_fd(fp))
 		return ksmbd_vfs_stream_read(fp, rbuf, pos, count);
-
-	if (!work->tcon->posix_extensions) {
-		int ret;
-
-		ret = check_lock_range(filp, *pos, *pos + count - 1, READ);
-		if (ret) {
-			pr_err("unable to read due to lock\n");
-			return -EAGAIN;
-		}
-	}
+	ret = ksmbd_vfs_check_read_range(work, fp, *pos, count);
+	if (ret)
+		return ret;
 
 	nbytes = kernel_read(filp, rbuf, count, pos);
 	if (nbytes < 0) {
 		pr_err("smb read failed, err = %zd\n", nbytes);
 		return nbytes;
 	}
+	filp->f_pos = *pos;
+	ksmbd_counter_add(KSMBD_COUNTER_READ_BYTES, nbytes);
+	return nbytes;
+}
+
+static int ksmbd_read_payload_reserve(struct ksmbd_read_payload *payload,
+				      unsigned int nr_bvecs)
+{
+	struct bio_vec *bvec;
+	unsigned int needed, nr_alloc;
 
+	if (check_add_overflow(payload->nr_bvecs, nr_bvecs, &needed))
+		return -EOVERFLOW;
+	if (payload->nr_alloc >= needed)
+		return 0;
+	nr_alloc = payload->nr_alloc ?: 16;
+	while (nr_alloc < needed) {
+		if (nr_alloc > UINT_MAX / 2) {
+			nr_alloc = needed;
+			break;
+		}
+		nr_alloc *= 2;
+	}
+	bvec = kvrealloc(payload->bvec,
+			 array_size(nr_alloc, sizeof(*payload->bvec)),
+			 KSMBD_DEFAULT_GFP | __GFP_ZERO);
+	if (!bvec)
+		return -ENOMEM;
+	payload->bvec = bvec;
+	payload->nr_alloc = nr_alloc;
+	return 0;
+}
+
+static int ksmbd_read_payload_actor(struct pipe_inode_info *pipe,
+				    struct pipe_buffer *buf,
+				    struct splice_desc *sd)
+{
+	struct ksmbd_read_payload *payload = sd->u.data;
+	unsigned int offset = buf->offset, len = sd->len;
+	size_t payload_len;
+	unsigned int nr_bvecs;
+	int ret;
+
+	nr_bvecs = DIV_ROUND_UP(offset_in_page(offset) + len, PAGE_SIZE);
+	ret = ksmbd_read_payload_reserve(payload, nr_bvecs);
+	if (ret)
+		return ret;
+	if (check_add_overflow(payload->len, (size_t)len, &payload_len))
+		return -EOVERFLOW;
+	while (len) {
+		struct page *page = buf->page + offset / PAGE_SIZE;
+		unsigned int page_offset = offset_in_page(offset);
+		unsigned int bytes = min_t(unsigned int, len,
+						   PAGE_SIZE - page_offset);
+
+		if (!sendpage_ok(page))
+			return -EOPNOTSUPP;
+		get_page(page);
+		bvec_set_page(&payload->bvec[payload->nr_bvecs++], page,
+			      bytes, page_offset);
+		offset += bytes;
+		len -= bytes;
+	}
+	payload->len = payload_len;
+	return sd->len;
+}
+
+static int ksmbd_direct_splice_actor(struct pipe_inode_info *pipe,
+				     struct splice_desc *sd)
+{
+	return __splice_from_pipe(pipe, sd, ksmbd_read_payload_actor);
+}
+
+/**
+ * ksmbd_vfs_read_payload() - collect file pages for an SMB READ response
+ * @work: smb work
+ * @fp: ksmbd file pointer
+ * @count: read byte count
+ * @pos: file position, advanced only on success
+ * @payload: payload returned on success, otherwise set to NULL
+ *
+ * Return: number of bytes read, or -EOPNOTSUPP with @pos unchanged when the
+ * caller may safely retry through ksmbd_vfs_read().
+ */
+int ksmbd_vfs_read_payload(struct ksmbd_work *work, struct ksmbd_file *fp,
+			   size_t count, loff_t *pos,
+			   struct ksmbd_read_payload **payload)
+{
+	struct file *filp = fp->filp;
+	struct ksmbd_read_payload *read_payload;
+	loff_t start = *pos;
+	struct splice_desc sd;
+	ssize_t nbytes;
+	int ret;
+
+	*payload = NULL;
+	if (S_ISDIR(file_inode(filp)->i_mode))
+		return -EISDIR;
+	if (unlikely(count == 0))
+		return 0;
+	ret = ksmbd_vfs_check_read_access(work, fp);
+	if (ret)
+		return ret;
+	if (ksmbd_stream_fd(fp) || !S_ISREG(file_inode(filp)->i_mode) ||
+	    (filp->f_flags & O_DIRECT) || IS_DAX(file_inode(filp)) ||
+	    !(filp->f_mode & FMODE_LSEEK) || !filp->f_op->splice_read)
+		return -EOPNOTSUPP;
+	ret = ksmbd_vfs_check_read_range(work, fp, start, count);
+	if (ret)
+		return ret;
+
+	read_payload = kzalloc_obj(struct ksmbd_read_payload,
+				   KSMBD_DEFAULT_GFP);
+	if (!read_payload)
+		return -ENOMEM;
+	nbytes = rw_verify_area(READ, filp, pos, count);
+	if (nbytes)
+		goto out_free;
+	sd = (struct splice_desc) {
+		.total_len = count,
+		.pos = start,
+		.u.data = read_payload,
+	};
+	nbytes = splice_direct_to_actor(filp, &sd, ksmbd_direct_splice_actor);
+	if (nbytes <= 0)
+		goto out_free;
+	if (nbytes < count && start + nbytes < i_size_read(file_inode(filp))) {
+		nbytes = -EOPNOTSUPP;
+		goto out_free;
+	}
+	*pos = start + nbytes;
 	filp->f_pos = *pos;
-	ksmbd_counter_add(KSMBD_COUNTER_READ_BYTES, (s64)nbytes);
+	ksmbd_counter_add(KSMBD_COUNTER_READ_BYTES, nbytes);
+	*payload = read_payload;
+	return nbytes;
+
+out_free:
+	*pos = start;
+	ksmbd_read_payload_release(read_payload);
 	return nbytes;
 }
 
 static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				  size_t count)
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 7b3d2f4fd985..5afee75c4a3b 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -34,10 +34,11 @@ enum {
 #define CREATE_OPTION_SPECIAL			0x20000000
 
 struct ksmbd_work;
 struct ksmbd_file;
 struct ksmbd_conn;
+struct ksmbd_read_payload;
 
 struct ksmbd_dir_info {
 	const char	*name;
 	char		*wptr;
 	char		*rptr;
@@ -77,10 +78,13 @@ void ksmbd_vfs_query_maximal_access(struct mnt_idmap *idmap,
 				   struct dentry *dentry, __le32 *daccess);
 int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode);
 int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode);
 int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 		   loff_t *pos, char *rbuf);
+int ksmbd_vfs_read_payload(struct ksmbd_work *work, struct ksmbd_file *fp,
+			   size_t count, loff_t *pos,
+			   struct ksmbd_read_payload **payload);
 int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 		    char *buf, size_t count, loff_t *pos, bool sync,
 		    ssize_t *written);
 int ksmbd_vfs_fsync(struct ksmbd_work *work, u64 fid, u64 p_id);
 int ksmbd_vfs_remove_file(struct ksmbd_work *work, const struct path *path);
-- 
2.47.3
