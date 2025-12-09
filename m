Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00E22FE07B;
	Tue,  9 Dec 2025 00:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239502; cv=none; b=ZjykluCb68Ja4v289XrnPniLDsFkqRWFgyMLwK2Z/NlsEWrfIPngzdPYa+khOIUDkt/pcmgHv08VAoNztiaDAJatGbIlNh6xWNRHBg0NkyTTF8fYlREGh2MUKGrRhYHSDoEY4YFixVF5yttRVwtlIVA4SN2bhAv7l9NYm59r8C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239502; c=relaxed/simple;
	bh=19TLGicltIHZdV3evklZ7BqhPkkNRx+ucqkSBoq51Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SyehOHzXqi2fYQC1Syp4QfRC+VMR6bRdRedofOz0q/wH4slf5yhUfrsc8FTgz1Hx8snLruIEX0hlJEXzpaXZpdMtPAjrYsQmuSbCP6IIRbKvYUe9SRge/uYQx3LCHk6xw8vs5srFh5zgP+Wbc9DC/rvfyd1S6nNrF1BZV+5NYr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tFMsJS3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tFMsJS3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11162C4CEF1;
	Tue,  9 Dec 2025 00:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239502;
	bh=19TLGicltIHZdV3evklZ7BqhPkkNRx+ucqkSBoq51Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFMsJS3XoGR9rWM5NkulMmn6SxIHTyxgu5/JhFyfEJ8jxbmWAuIhnDAKFa9wE/k29
	 Hadck4UrIp1KYfEcm0fq+YQVwxWZgB53E8X4d7LLqZJeROvYDW1/Oh2hZxCtZH21Tq
	 kf89qL6acwfI61bkTSEZAK8kYoKoxnFF0xJI6qOz5wMUVECI1iGPYrXD6DP9dlYTv+
	 dBRtLB0PgPoBW7uTbZZ30h4sQJx94wDKPCSzhd5RXeF0LUHJWBuZlB4zYfivMU+7f1
	 20kdDEp4++Br+wiQRqV2Y/MD1tsqErnrICZEQsbXYc+GtQXvndcLlET2PGA8IDin7I
	 3p1muxASQAVmA==
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
Date: Mon,  8 Dec 2025 19:15:35 -0500
Message-ID: <20251209001610.611575-43-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
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

## Analysis: ksmbd: vfs: fix race on m_flags in vfs_cache

### 1. Commit Message Analysis

**Bug Description**: The commit fixes a data race on `m_flags` field in
ksmbd's VFS cache. Multiple functions access/modify this field with
inconsistent locking - some use `ci->m_lock`, others don't.

**Keywords**: "race", "data race", "fix" - clear bug fix language

**Impact described**: "Delete-on-close and pending-delete bits can be
lost or observed in an inconsistent state, leading to confusing delete
semantics (files that stay on disk after delete-on-close, or files that
disappear while still in use)"

**Tags present**:
- Two `Reported-by:` tags (Qianchang Zhao, Zhitong Liu) - indicates real
  users hit this bug
- `Acked-by:` from Namjae Jeon (ksmbd maintainer)
- `Signed-off-by:` from Steve French (SMB maintainer)

**Tags missing**: No `Cc: stable@vger.kernel.org`, no `Fixes:` tag

### 2. Code Change Analysis

The fix is straightforward and mechanical - it adds proper locking
around all `m_flags` accesses:

| Function | Change |
|----------|--------|
| `ksmbd_query_inode_status()` | Moved m_flags check outside
inode_hash_lock, added `down_read(&ci->m_lock)` |
| `ksmbd_inode_pending_delete()` | Added read lock around flag check |
| `ksmbd_set_inode_pending_delete()` | Added write lock around flag
modification |
| `ksmbd_clear_inode_pending_delete()` | Added write lock around flag
modification |
| `ksmbd_fd_set_delete_on_close()` | Added write lock around flag
modification |
| `__ksmbd_inode_close()` | Restructured to hold lock only during flag
check/modify, moves I/O (unlink, xattr removal) outside the lock |

The pattern is consistent: acquire lock → read/modify flags → release
lock → perform any I/O operations outside lock.

### 3. Classification

**Bug type**: Concurrency bug (data race)
- NOT a feature addition
- NOT adding new APIs
- NOT a cleanup or optimization
- This is a correctness fix for a real race condition

### 4. Scope and Risk Assessment

**Scope**:
- Single file changed: `fs/smb/server/vfs_cache.c`
- ~60 lines of changes
- All changes are adding locking around existing operations

**Risk**: LOW
- Uses existing `ci->m_lock` rwsem that's already in the structure
- No new locking primitives introduced
- The restructuring in `__ksmbd_inode_close()` to move I/O outside the
  lock is actually safer (avoids holding lock during I/O)
- Pattern is well-understood: protect shared data with locks

### 5. User Impact

**Who is affected**: Users running ksmbd (in-kernel SMB3 server) with
concurrent file access/deletion

**Severity**: MEDIUM-HIGH
- File deletion semantics are broken (files may not be deleted when they
  should be, or disappear unexpectedly)
- This affects data integrity expectations
- Any ksmbd deployment with multiple concurrent clients could hit this

### 6. Stability Indicators

- Maintainer acks from both ksmbd maintainer (Namjae Jeon) and SMB
  maintainer (Steve French)
- Two independent reporters suggest this is a known/reproducible issue

### 7. Dependencies Check

The fix is self-contained:
- Uses existing `ci->m_lock` (already present in `ksmbd_inode`
  structure)
- Uses standard kernel locking APIs (`down_read/up_read`,
  `down_write/up_write`)
- No dependency on other patches

### 8. Stable Tree Applicability

ksmbd was added in Linux 5.15, so this applies to 5.15.y, 6.1.y, 6.6.y,
and later stable trees. The code structure appears stable enough that
this should apply cleanly.

---

## Summary

**Should this be backported?**

**YES** - This commit should be backported because:

1. **Fixes a real bug**: Data race causing incorrect file deletion
   behavior that users can actually hit
2. **User-visible impact**: Files not deleted when they should be
   (delete-on-close failing) or files disappearing unexpectedly
3. **Has real bug reports**: Two Reported-by tags indicate real users
   encountered this
4. **Small and contained**: Single file, straightforward addition of
   missing locking
5. **Low regression risk**: Adds locking around existing operations
   using existing infrastructure
6. **Maintainer approved**: Acked by ksmbd maintainer, signed off by SMB
   maintainer
7. **Correct fix**: The approach (unify locking around m_flags) is
   obviously correct

The lack of explicit `Cc: stable` tag is not disqualifying - the nature
of the bug (concurrency issue with data integrity implications) and the
quality of the fix (mechanical addition of proper locking) make this
appropriate stable material.

**YES**

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

