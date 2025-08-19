Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA0730BF62;
	Tue, 19 Aug 2025 17:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755624927; cv=none; b=bEZCKUr1bDarXr2qrgbhxbyz1/VpdWujE2O4Wl/hA8kuBilf8iEf45+t7ZG0BO8pxAfgjePaiZM8/sS2vyHZAgqb6+OkNdmu9RPnLukb2WdgFoUrtNLyLIxT/Onk2oXIytkfpl98gTRRJBE32gYe59M857tayezYChVlFlqoMLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755624927; c=relaxed/simple;
	bh=OIjUFkldfey3RlDuEv++agzGskvG+owAtlq4r57xWNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9QzBhQuPwNXxOEHC5Xmz+gr8NCkLszliLHMfESFGyklXY8WPss8OO4qVH2D4aM5s7iIOJdXWUW3GAne/Q45MhTT2vzwqw1vDAQdX+ViiQ1h/lNRNpRr+Tz8F+fTO+uwVlP0qulxQbIfGzJlKg/BOs7HBZxLHK/lpiN9mZOLLCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EvyEz+c7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EvyEz+c7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A9EC4CEF4;
	Tue, 19 Aug 2025 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755624926;
	bh=OIjUFkldfey3RlDuEv++agzGskvG+owAtlq4r57xWNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvyEz+c7VKzdSv5RmGcWBzGeLSMrwItleD6X79DU4+Ts1vUCIEvqKfF70ufGuxXZk
	 MSDk/KPNG1PIlIA2mBu+4eKYnPC4+VLtOL2YrqTuC/j8UBM8FR7Fkxa/pAAlqxxODR
	 AOXOb/KB1w/5wrBnBPjSVDF9JOjDl1Yz71tANKSVg2vyQNoqCLW4p+A/9CipEIJBbl
	 mzHbuoE65OLz0GQB0KZoZ6DKypqt4IjtnVuhCutDSfJdnkzypl5uiT9hqpvdujtUCP
	 Zr9d6Eskr8cICLmqyvCt72uPC0c+A3zWrg2ZFr196imn4tkOFAMzyqaQcTghtXX4R/
	 p0PcwhiMhnnjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Jay Shin <jaeshin@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.16-6.1] smb: client: fix race with concurrent opens in unlink(2)
Date: Tue, 19 Aug 2025 13:35:14 -0400
Message-ID: <20250819173521.1079913-4-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250819173521.1079913-1-sashal@kernel.org>
References: <20250819173521.1079913-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.1
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 0af1561b2d60bab2a2b00720a5c7b292ecc549ec ]

According to some logs reported by customers, CIFS client might end up
reporting unlinked files as existing in stat(2) due to concurrent
opens racing with unlink(2).

Besides sending the removal request to the server, the unlink process
could involve closing any deferred close as well as marking all
existing open handles as deleted to prevent them from deferring
closes, which increases the race window for potential concurrent
opens.

Fix this by unhashing the dentry in cifs_unlink() to prevent any
subsequent opens.  Any open attempts, while we're still unlinking,
will block on parent's i_rwsem.

Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Fix Analysis

This commit fixes a **real-world race condition** reported by customers
where unlinked files incorrectly appear as existing in stat(2). The race
occurs between:
1. **unlink(2)** - which involves multiple steps including server
   requests, closing deferred handles, and marking handles as deleted
2. **Concurrent open()** operations that can slip through during the
   extended unlink window

## Code Changes Analysis

The fix is **minimal and surgical**, adding only 14 lines of code:

1. **Early dentry unhashing** (lines 1956-1962):
  ```c
  /* Unhash dentry in advance to prevent any concurrent opens */
  spin_lock(&dentry->d_lock);
  if (!d_unhashed(dentry)) {
  __d_drop(dentry);
  rehash = true;
  }
  spin_unlock(&dentry->d_lock);
  ```
  This prevents new opens from finding the dentry during unlink
  processing.

2. **Conditional rehashing on error** (lines at end):
  ```c
  if (rehash)
  d_rehash(dentry);
  ```
  This ensures the dentry is restored if unlink fails, maintaining
  correct VFS semantics.

3. **Minor cleanup**: The d_drop() call is replaced with d_delete() for
   positive dentries when ENOENT is returned.

## Stable Tree Criteria Met

1. **Fixes a real bug**: Customer-reported race condition causing
   incorrect filesystem behavior
2. **Small and contained**: Only 14 lines added, changes confined to
   single function
3. **No architectural changes**: Uses existing VFS primitives
   (d_drop/d_rehash)
4. **Low regression risk**:
   - Protected by proper locking (dentry->d_lock)
   - Follows established VFS patterns
   - Has proper error recovery path
5. **Similar fix already accepted**: Commit d84291fc7453 shows the same
   pattern was successfully applied to rename(2)

## Additional Context

- The fix follows standard VFS practices for preventing races during
  filesystem operations
- The pattern of unhashing dentries early is used elsewhere in the
  kernel
- The commit has been reviewed by David Howells, a respected VFS
  maintainer
- The issue affects data consistency from userspace perspective (stat
  showing deleted files)

This is a textbook example of a stable-worthy commit: it fixes a real
bug with minimal, safe changes that don't introduce new features or
architectural modifications.

 fs/smb/client/inode.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 75be4b46bc6f..cf9060f0fc08 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1943,15 +1943,24 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
+	__u32 dosattr = 0, origattr = 0;
 	struct TCP_Server_Info *server;
 	struct iattr *attrs = NULL;
-	__u32 dosattr = 0, origattr = 0;
+	bool rehash = false;
 
 	cifs_dbg(FYI, "cifs_unlink, dir=0x%p, dentry=0x%p\n", dir, dentry);
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return -EIO;
 
+	/* Unhash dentry in advance to prevent any concurrent opens */
+	spin_lock(&dentry->d_lock);
+	if (!d_unhashed(dentry)) {
+		__d_drop(dentry);
+		rehash = true;
+	}
+	spin_unlock(&dentry->d_lock);
+
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
@@ -2003,7 +2012,8 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 			cifs_drop_nlink(inode);
 		}
 	} else if (rc == -ENOENT) {
-		d_drop(dentry);
+		if (simple_positive(dentry))
+			d_delete(dentry);
 	} else if (rc == -EBUSY) {
 		if (server->ops->rename_pending_delete) {
 			rc = server->ops->rename_pending_delete(full_path,
@@ -2056,6 +2066,8 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	kfree(attrs);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
+	if (rehash)
+		d_rehash(dentry);
 	return rc;
 }
 
-- 
2.50.1

