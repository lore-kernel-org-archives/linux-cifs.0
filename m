Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513852FE58C;
	Sat,  6 Dec 2025 14:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765029834; cv=none; b=oYoff0I2Dty98+hZF5bxymi4zZBioqV8ohOTkxuaTeOgK1RPvUHVd9hn5bSoMv+rx1c6vu0grZjugsKHaoW2CRRvz7Nlfc0UxIdJ7OZv4+lHyC1mY8jVopxB5fKS6O5VnzlAOMzMPlBOPjbSIYGov1lLl7C/vYf5i/YKBp6MuUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765029834; c=relaxed/simple;
	bh=X0iKf/mzWfXeAmjBbHV4DqH7woOS//wu71pCfbmSVjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIVp8e6XQp1zKv1jTajsjaHj3fQ34NwM2f0oCBRCjteR3JE+o+4ABP4/f1ffXBG4hs3p9Y89OLqRgnN4MZYMdFIxbCg0RNjLTiTfdq5c7RBWORLkIKLKgdTTBO0GQkbwqzn62KhzUW3kXQiGQdfr8vIVZICwj5Oh9NFIjszO3nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XbDKM5qs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XbDKM5qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49E7C113D0;
	Sat,  6 Dec 2025 14:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765029834;
	bh=X0iKf/mzWfXeAmjBbHV4DqH7woOS//wu71pCfbmSVjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbDKM5qsWGPeCQHtpBM3rxzCPiSJqo6dOlbMfIBYHlld1s0milSVnRO9ELTwge2W0
	 /mzAs+v3e4V+x3mTM5SLuNLfr9SyKsxgCilkU3Cy1gnHhWphE4+X0+ZUZOyeRmSpAP
	 +0YilCWUQ0dVTxY2FMS8nlSg8fkM60BtEA+auPcZaVfgnv2Q2vW+iB5i/vPg1jGv88
	 etrGoJGK9JyLvbVaFtbqG1Wbtdr6Ap5VuJUhpvPUku7GhpVRkRaV7xWCVCI/Un52t7
	 fiTz4nd3FsQDbBLFz5j5C8+iCwHW1Z4tei2ZXSM7B8NPzpzgN7yOqQR6XEbERZg40c
	 hBYdw9NB3kXcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ksmbd: vfs: fix race on m_flags in vfs_cache
Date: Sat,  6 Dec 2025 09:02:32 -0500
Message-ID: <20251206140252.645973-27-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251206140252.645973-1-sashal@kernel.org>
References: <20251206140252.645973-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Qianchang Zhao <pioooooooooip@gmail.com>

[ Upstream commit 991f8a79db99b14c48d20d2052c82d65b9186cad ]

ksmbd maintains delete-on-close and pending-delete state in
ksmbd_inode->m_flags. In vfs_cache.c this field is accessed under
inconsistent locking: some paths read and modify m_flags under
ci->m_lock while others do so without taking the lock at all.

Examples:

 - ksmbd_query_inode_status() and __ksmbd_inode_close() use
   ci->m_lock when checking or updating m_flags.
 - ksmbd_inode_pending_delete(), ksmbd_set_inode_pending_delete(),
   ksmbd_clear_inode_pending_delete() and ksmbd_fd_set_delete_on_close()
   used to read and modify m_flags without ci->m_lock.

This creates a potential data race on m_flags when multiple threads
open, close and delete the same file concurrently. In the worst case
delete-on-close and pending-delete bits can be lost or observed in an
inconsistent state, leading to confusing delete semantics (files that
stay on disk after delete-on-close, or files that disappear while still
in use).

Fix it by:

 - Making ksmbd_query_inode_status() look at m_flags under ci->m_lock
   after dropping inode_hash_lock.
 - Adding ci->m_lock protection to all helpers that read or modify
   m_flags (ksmbd_inode_pending_delete(), ksmbd_set_inode_pending_delete(),
   ksmbd_clear_inode_pending_delete(), ksmbd_fd_set_delete_on_close()).
 - Keeping the existing ci->m_lock protection in __ksmbd_inode_close(),
   and moving the actual unlink/xattr removal outside the lock.

This unifies the locking around m_flags and removes the data race while
preserving the existing delete-on-close behaviour.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:



 fs/smb/server/vfs_cache.c | 88 +++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index dfed6fce89049..6ef116585af64 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -112,40 +112,62 @@ int ksmbd_query_inode_status(struct dentry *dentry)
 
 	read_lock(&inode_hash_lock);
 	ci = __ksmbd_inode_lookup(dentry);
-	if (ci) {
-		ret = KSMBD_INODE_STATUS_OK;
-		if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
-			ret = KSMBD_INODE_STATUS_PENDING_DELETE;
-		atomic_dec(&ci->m_count);
-	}
 	read_unlock(&inode_hash_lock);
+	if (!ci)
+		return ret;
+
+	down_read(&ci->m_lock);
+	if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
+		ret = KSMBD_INODE_STATUS_PENDING_DELETE;
+	else
+		ret = KSMBD_INODE_STATUS_OK;
+	up_read(&ci->m_lock);
+
+	atomic_dec(&ci->m_count);
 	return ret;
 }
 
 bool ksmbd_inode_pending_delete(struct ksmbd_file *fp)
 {
-	return (fp->f_ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
+	struct ksmbd_inode *ci = fp->f_ci;
+	int ret;
+
+	down_read(&ci->m_lock);
+	ret = (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
+	up_read(&ci->m_lock);
+
+	return ret;
 }
 
 void ksmbd_set_inode_pending_delete(struct ksmbd_file *fp)
 {
-	fp->f_ci->m_flags |= S_DEL_PENDING;
+	struct ksmbd_inode *ci = fp->f_ci;
+
+	down_write(&ci->m_lock);
+	ci->m_flags |= S_DEL_PENDING;
+	up_write(&ci->m_lock);
 }
 
 void ksmbd_clear_inode_pending_delete(struct ksmbd_file *fp)
 {
-	fp->f_ci->m_flags &= ~S_DEL_PENDING;
+	struct ksmbd_inode *ci = fp->f_ci;
+
+	down_write(&ci->m_lock);
+	ci->m_flags &= ~S_DEL_PENDING;
+	up_write(&ci->m_lock);
 }
 
 void ksmbd_fd_set_delete_on_close(struct ksmbd_file *fp,
 				  int file_info)
 {
-	if (ksmbd_stream_fd(fp)) {
-		fp->f_ci->m_flags |= S_DEL_ON_CLS_STREAM;
-		return;
-	}
+	struct ksmbd_inode *ci = fp->f_ci;
 
-	fp->f_ci->m_flags |= S_DEL_ON_CLS;
+	down_write(&ci->m_lock);
+	if (ksmbd_stream_fd(fp))
+		ci->m_flags |= S_DEL_ON_CLS_STREAM;
+	else
+		ci->m_flags |= S_DEL_ON_CLS;
+	up_write(&ci->m_lock);
 }
 
 static void ksmbd_inode_hash(struct ksmbd_inode *ci)
@@ -257,27 +279,41 @@ static void __ksmbd_inode_close(struct ksmbd_file *fp)
 	struct file *filp;
 
 	filp = fp->filp;
-	if (ksmbd_stream_fd(fp) && (ci->m_flags & S_DEL_ON_CLS_STREAM)) {
-		ci->m_flags &= ~S_DEL_ON_CLS_STREAM;
-		err = ksmbd_vfs_remove_xattr(file_mnt_idmap(filp),
-					     &filp->f_path,
-					     fp->stream.name,
-					     true);
-		if (err)
-			pr_err("remove xattr failed : %s\n",
-			       fp->stream.name);
+
+	if (ksmbd_stream_fd(fp)) {
+		bool remove_stream_xattr = false;
+
+		down_write(&ci->m_lock);
+		if (ci->m_flags & S_DEL_ON_CLS_STREAM) {
+			ci->m_flags &= ~S_DEL_ON_CLS_STREAM;
+			remove_stream_xattr = true;
+		}
+		up_write(&ci->m_lock);
+
+		if (remove_stream_xattr) {
+			err = ksmbd_vfs_remove_xattr(file_mnt_idmap(filp),
+						     &filp->f_path,
+						     fp->stream.name,
+						     true);
+			if (err)
+				pr_err("remove xattr failed : %s\n",
+				       fp->stream.name);
+		}
 	}
 
 	if (atomic_dec_and_test(&ci->m_count)) {
+		bool do_unlink = false;
+
 		down_write(&ci->m_lock);
 		if (ci->m_flags & (S_DEL_ON_CLS | S_DEL_PENDING)) {
 			ci->m_flags &= ~(S_DEL_ON_CLS | S_DEL_PENDING);
-			up_write(&ci->m_lock);
-			ksmbd_vfs_unlink(filp);
-			down_write(&ci->m_lock);
+			do_unlink = true;
 		}
 		up_write(&ci->m_lock);
 
+		if (do_unlink)
+			ksmbd_vfs_unlink(filp);
+
 		ksmbd_inode_free(ci);
 	}
 }
-- 
2.51.0

