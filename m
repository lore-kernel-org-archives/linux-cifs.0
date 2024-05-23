Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C0114AD3A;
	Thu, 23 May 2024 13:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470605; cv=none; b=u6frf2w0+hdtnrny/OaCadtyj7XTactNgxPW5bVxgYaatHUYco2gIuhb9asc/5VaO1T6x+Oe5xu9AifC5mf1E4XFl647NVkknm0bCw0kdjk5tHHkuE60oHU0h/C0b/7fYqXu37rhiZjWZrVl0CmNPbrhxxKeTBVfjDJ5hIORAJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470605; c=relaxed/simple;
	bh=ADaCEAKHRdQ5zahjQduwuXUvIU4tJBquPeor8htHjYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phTfFvblzK4U4axJ1ihcK9+KkytaRRDgfMc/PAfRDBdf9Bq1I9b2yPQzPYIXtZZ5Rfz1Tw76hkyvfJg0AxUIND5VHhOS/09ZV64d8+yCphMdLxi04BSC/6zOFjxaraBOGrq8Jm+NU27zuojpeyRwaUh+i/GjJwpmkHIkgVQUSOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laG+V2bY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laG+V2bY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D2FC32781;
	Thu, 23 May 2024 13:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470604;
	bh=ADaCEAKHRdQ5zahjQduwuXUvIU4tJBquPeor8htHjYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=laG+V2bYjpbXtNRGLDguTdGR5w7704/c4FDB0awaSGYkbYTUSbCI3/CXaG9VLKl/C
	 HVXFZPKwxPSGNjtQh8g9fQflGb9qG6XJvVk30DHjHL48A9dTmx8vs4pGcmbxUkYLz7
	 L4TdbjcbEhesefOq5+E3DYkXfDG9RhWr9Liz/5/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/102] ksmbd: vfs: fix all kernel-doc warnings
Date: Thu, 23 May 2024 15:12:50 +0200
Message-ID: <20240523130343.412475327@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 8d99c1131d9d03053b7b1e1245b8f6e6846d9c69 ]

Fix all kernel-doc warnings in vfs.c:

vfs.c:54: warning: Function parameter or member 'parent' not described in 'ksmbd_vfs_lock_parent'
vfs.c:54: warning: Function parameter or member 'child' not described in 'ksmbd_vfs_lock_parent'
vfs.c:54: warning: No description found for return value of 'ksmbd_vfs_lock_parent'
vfs.c:372: warning: Function parameter or member 'fp' not described in 'ksmbd_vfs_read'
vfs.c:372: warning: Excess function parameter 'fid' description in 'ksmbd_vfs_read'
vfs.c:489: warning: Function parameter or member 'fp' not described in 'ksmbd_vfs_write'
vfs.c:489: warning: Excess function parameter 'fid' description in 'ksmbd_vfs_write'
vfs.c:555: warning: Function parameter or member 'path' not described in 'ksmbd_vfs_getattr'
vfs.c:555: warning: Function parameter or member 'stat' not described in 'ksmbd_vfs_getattr'
vfs.c:555: warning: Excess function parameter 'work' description in 'ksmbd_vfs_getattr'
vfs.c:555: warning: Excess function parameter 'fid' description in 'ksmbd_vfs_getattr'
vfs.c:555: warning: Excess function parameter 'attrs' description in 'ksmbd_vfs_getattr'
vfs.c:572: warning: Function parameter or member 'p_id' not described in 'ksmbd_vfs_fsync'
vfs.c:595: warning: Function parameter or member 'work' not described in 'ksmbd_vfs_remove_file'
vfs.c:595: warning: Function parameter or member 'path' not described in 'ksmbd_vfs_remove_file'
vfs.c:595: warning: Excess function parameter 'name' description in 'ksmbd_vfs_remove_file'
vfs.c:633: warning: Function parameter or member 'work' not described in 'ksmbd_vfs_link'
vfs.c:805: warning: Function parameter or member 'fp' not described in 'ksmbd_vfs_truncate'
vfs.c:805: warning: Excess function parameter 'fid' description in 'ksmbd_vfs_truncate'
vfs.c:846: warning: Excess function parameter 'size' description in 'ksmbd_vfs_listxattr'
vfs.c:953: warning: Function parameter or member 'option' not described in 'ksmbd_vfs_set_fadvise'
vfs.c:953: warning: Excess function parameter 'options' description in 'ksmbd_vfs_set_fadvise'
vfs.c:1167: warning: Function parameter or member 'um' not described in 'ksmbd_vfs_lookup_in_dir'
vfs.c:1203: warning: Function parameter or member 'work' not described in 'ksmbd_vfs_kern_path_locked'
vfs.c:1641: warning: No description found for return value of 'ksmbd_vfs_init_kstat'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <sfrench@samba.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 626406b0cf4ac..2558119969359 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -49,6 +49,10 @@ static void ksmbd_vfs_inherit_owner(struct ksmbd_work *work,
 
 /**
  * ksmbd_vfs_lock_parent() - lock parent dentry if it is stable
+ * @parent: parent dentry
+ * @child: child dentry
+ *
+ * Returns: %0 on success, %-ENOENT if the parent dentry is not stable
  */
 int ksmbd_vfs_lock_parent(struct dentry *parent, struct dentry *child)
 {
@@ -360,7 +364,7 @@ static int check_lock_range(struct file *filp, loff_t start, loff_t end,
 /**
  * ksmbd_vfs_read() - vfs helper for smb file read
  * @work:	smb work
- * @fid:	file id of open file
+ * @fp:		ksmbd file pointer
  * @count:	read byte count
  * @pos:	file pos
  * @rbuf:	read data buffer
@@ -474,7 +478,7 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 /**
  * ksmbd_vfs_write() - vfs helper for smb file write
  * @work:	work
- * @fid:	file id of open file
+ * @fp:		ksmbd file pointer
  * @buf:	buf containing data for writing
  * @count:	read byte count
  * @pos:	file pos
@@ -545,10 +549,8 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 
 /**
  * ksmbd_vfs_getattr() - vfs helper for smb getattr
- * @work:	work
- * @fid:	file id of open file
- * @attrs:	inode attributes
- *
+ * @path:	path of dentry
+ * @stat:	pointer to returned kernel stat structure
  * Return:	0 on success, otherwise error
  */
 int ksmbd_vfs_getattr(const struct path *path, struct kstat *stat)
@@ -565,6 +567,7 @@ int ksmbd_vfs_getattr(const struct path *path, struct kstat *stat)
  * ksmbd_vfs_fsync() - vfs helper for smb fsync
  * @work:	work
  * @fid:	file id of open file
+ * @p_id:	persistent file id
  *
  * Return:	0 on success, otherwise error
  */
@@ -587,7 +590,8 @@ int ksmbd_vfs_fsync(struct ksmbd_work *work, u64 fid, u64 p_id)
 
 /**
  * ksmbd_vfs_remove_file() - vfs helper for smb rmdir or unlink
- * @name:	directory or file name that is relative to share
+ * @work:	work
+ * @path:	path of dentry
  *
  * Return:	0 on success, otherwise error
  */
@@ -623,6 +627,7 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, const struct path *path)
 
 /**
  * ksmbd_vfs_link() - vfs helper for creating smb hardlink
+ * @work:	work
  * @oldname:	source file name
  * @newname:	hardlink name that is relative to share
  *
@@ -800,7 +805,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 /**
  * ksmbd_vfs_truncate() - vfs helper for smb file truncate
  * @work:	work
- * @fid:	file id of old file
+ * @fp:		ksmbd file pointer
  * @size:	truncate to given size
  *
  * Return:	0 on success, otherwise error
@@ -843,7 +848,6 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work,
  * ksmbd_vfs_listxattr() - vfs helper for smb list extended attributes
  * @dentry:	dentry of file for listing xattrs
  * @list:	destination buffer
- * @size:	destination buffer length
  *
  * Return:	xattr list length on success, otherwise error
  */
@@ -952,7 +956,7 @@ int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
 /**
  * ksmbd_vfs_set_fadvise() - convert smb IO caching options to linux options
  * @filp:	file pointer for IO
- * @options:	smb IO options
+ * @option:	smb IO options
  */
 void ksmbd_vfs_set_fadvise(struct file *filp, __le32 option)
 {
@@ -1164,6 +1168,7 @@ static bool __caseless_lookup(struct dir_context *ctx, const char *name,
  * @dir:	path info
  * @name:	filename to lookup
  * @namelen:	filename length
+ * @um:		&struct unicode_map to use
  *
  * Return:	0 on success, otherwise error
  */
@@ -1194,6 +1199,7 @@ static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name,
 
 /**
  * ksmbd_vfs_kern_path_locked() - lookup a file and get path info
+ * @work:	work
  * @name:		file path that is relative to share
  * @flags:		lookup flags
  * @parent_path:	if lookup succeed, return parent_path info
@@ -1641,6 +1647,8 @@ int ksmbd_vfs_get_dos_attrib_xattr(struct mnt_idmap *idmap,
  * ksmbd_vfs_init_kstat() - convert unix stat information to smb stat format
  * @p:          destination buffer
  * @ksmbd_kstat:      ksmbd kstat wrapper
+ *
+ * Returns: pointer to the converted &struct file_directory_info
  */
 void *ksmbd_vfs_init_kstat(char **p, struct ksmbd_kstat *ksmbd_kstat)
 {
-- 
2.43.0



