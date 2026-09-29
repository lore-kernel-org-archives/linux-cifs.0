Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545ED547066;
	Tue, 29 Sep 2026 02:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790649868; cv=none; b=f9vGDFkzPrFqeAwobHRovsTay0B6z2G87SZG3QdIrmKN7mN9h2JKl1B+lRLZ5093irOFFGkolRKu5qL2sy2iqxC1FtwNwSy+gt99DGLYpvqc7TQ26oTR5ZRwvs/KnuPU/0774J2xE/dcAEh3HcFNU5AHwX5FeHxXTcHFG/FZNgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790649868; c=relaxed/simple;
	bh=FCoNfaukmx1UmUsfsLxo2ghDObqIVLN+kHOKDaq//+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swB0Cdgcwzn1fm5ZosqZbfHw/70SGtwE6gTUTjWjj1JED8W9pikgIP1T52R2AHyAsg7RJfSAxWPlR3J/chFqATJ9Bomf9edkKvi3A2s08VLu8NSYA6KTjvkBBHo60KjC9izAqPTnq0bJ0ofqe92IIvt9PMLxAwdnQY9/rJxP6Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=YhCBh29K; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WbUiiWc0; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="YhCBh29K";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WbUiiWc0"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4F46C7A008A;
	Mon, 28 Sep 2026 22:44:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 28 Sep 2026 22:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790649866;
	 x=1790736266; bh=ruLOsgXU5wdr8mH4euwYN2IlyWVXx7+7GVQ+aQDDmEk=; b=
	YhCBh29KyhkVkat8Eu3ihOLAyt0QbX8AkNyexrNojluQCL0/0kxWi11QPiLW7tHD
	gfvf09WTK3xQTZ5Wd9ChVz9F+DCm5T8z3Ta1WY4+AZhVeLvAQIf55U0rXwjk8eoT
	Uz8bcs3z1FnwTu+8iDw+GIdQ+9hIL3K+lDwei7teRgcUp7yMh/BMC76Ku6FSBD+f
	YxF0sp5DCF0j0qiDCb/PfK2RcxTV8czTFJRNxVwJRQqIkg3JUVXmc6NfvykGzYK+
	netN8fa4SFs4clFl7hMyAqYfSxRP6JRqgJd7ozMGMbXJspx/Hw7GPWbS0Z4tLRFY
	EvIgX89aZgz1f3SEhu65nA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790649866; x=1790736266; bh=r
	uLOsgXU5wdr8mH4euwYN2IlyWVXx7+7GVQ+aQDDmEk=; b=WbUiiWc0RGh1bwEUn
	eof8ouunTDx0zKhq7oujX8pUrwbRTolhRvIhH0/J4akoJwgVwEcIMYXEtnye4JZ6
	+FAQtcE3UOiWJLzanEXANZvmcPGE/aa9kJyQkxLViZix7Z76E+tvy1cYtTF5U5Jf
	0v6iyhf+DWXHARwDgGe+c09DBau3kfG4qM65E5JlUg2qrD4B+b5ZrhX5R8HQQgae
	L6a953FijtrA9PEaL2c3DEVzk6NN2qmvU3w7PlxbJjbLxTXRGfbDJe/x9pKwV+aC
	WzFyglLasqwQjhA9sx0HuC368Ct4PThx2AI9G9QeKfowiZBmVXLtl4WFVYCyIN+d
	BXsXw==
X-ME-Sender: <xms:Cia7avfe3otdiWqP0YWBEK-n-wwkhxazviVvXZIguwDHRgBK2nAtZw>
    <xme:Cia7aoTaX7iVQwOQGcFBCTNS5zsKry0JMGVwJJF98VKo1untizQ_bmpA4vQT3NEvM
    2vQpw20CHhwo1V5dE4jMbgCH5IhytB7LDqXzd0uZhk0T7LInPA>
X-ME-Received: <xmr:Cia7ajJ68OQV-mVvMttHmRNXn7u5CFn5hcFiw0Luq_RjzV3QL4G2nJRP_lSGVkRwU7LgvMvTbG5avuCrbOeNOa08XeV6XA8>
X-ME-Proxy-Cause: dmFkZTGAETtLDaRhdK6zWwmD1skNo8oznbv/e2xQZSM2ujkSFd8PU+upR8wF9a9fwoqrPi
    faFoaFPojV/QsMDEtCK+pCBky2JCKDOeWUD5950YGVNewPYv1IqWWG2tHJT/nOvQXrcJ2C
    /dpBuqeOPU2uOmbufh4kWWa+l7OFQMxu6h0qLmDFlSzqkcbyXgnWtP7/5Hlg9k5TDoNx7W
    Lnhj8TKJndVGVDvl1jI4nKhIHo66v/mWkc8wAAFi0DtOQRMaKIvR3BY7zTw13iHmHBEtzh
    xF5p/hKrSHHFxZfSHEj+9lI/7B/SyYuQzS+5bRvoY3OjIJ4y7CH2qWNNwosk4t5FaLNCX2
    GuzMWgMK5E0h4O/Uz03xGbjYpYCk65XSpkU68bpTaIpdCcxbPPN0pnzvQIrSYpZZDi9lb9
    5rhydiVWKXUr78kDTsMGbtPkSj7uLZXB0pmr9gg/FLEp47lsj3xuO/J/aS7bK3wTD30wYW
    hSIa/M2kiR7RnB5qOUyPUkeqI4XC68BVT2GrUPTquYMyj8t7MXih4FnwJCVNfcSfhyqxhm
    /YizgYsX749Hs3W1RkfsJzE8jTiz6vZmcalKaBa/aI79Vfqs2JKpFNFYcGTyTOzr1iQBFE
    tY2r4yYMdfjAMB42yDoy6c6QbsM0EIdrFVhM2LycxR6pUdsHqm6kY+EulBoQ
X-ME-Proxy: <xmx:Cia7atJqR2OHZ77xnHyHjvXOm1C6zAJA9p7-tlOEa8DrXptTbt-wHw>
    <xmx:Cia7amiQuZiItu3qHUELWXor9YInHBwyfzwB9hjslF_PlU63e-FSbw>
    <xmx:Cia7avP8EdEJCrnYdFFDxQ6D-Ct013er9ZHNH-vl5vV5aR8rot1p2A>
    <xmx:Cia7aprHaaEyms-UZddKBOK_pPCPcTJFpo36HYhE6NZdQ2KjMYdBdQ>
    <xmx:Cia7av8p_NShL6q3kIS6DJN3_odbK-gzyOuCsSemeSq7Pjtcf9-XmaeH>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 22:44:23 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] smb/client: don't unhash and rehash to prevent new opens.
Date: Tue, 29 Sep 2026 12:40:01 +1000
Message-ID: <20260929024352.1433257-2-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260929024352.1433257-1-neilb@ownmail.net>
References: <20260929024352.1433257-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

smb/client needs to block new opens of the target of unlink and rename
while the operation is progressing.  This stablises d_count() and allows
a determination of whether a "silly-rename" is required.

It currently unhashes the dentry which will cause lookup to block on
the parent directory i_rwsem.  Proposed changes to locking will cause
this approach to stop working as the exclusivity will be provided for
the dentry only, and only while it is hashed.

So we introduce a new machanism similar to that used by nfs.
DCACHE_PRIVATE (given the name DCACHE_BLOCKED) is set when lookups need
to be blocked.  ->d_revalidate checks for this and blocks.  This might
still allow d_count() to increment, but once it has been tested as 1,
there can be no new opens completed.

Unlike unhash which does not need to be reverted on error, and which
must not be reverted on a successful d_move, blocking of opens must
always be reverted.  So we don't block the open until after the last
early "return", and we always unblock on the final "return".

Strictly speaking it is only necessary to block opens before the value
of d_count() is tested under ->d_lock. But we block as early as possible
to discourage new opens from starting.  As open is path-based in cifs a
concurrent rename can be confused a rename of one other the paths.  Once
cifs_open() has generated the full_path it doesn't hold any locks to
prevent a rename from making that path invalid.

The important details of the interlock between __cifs_unlink (which both
unlink and rename use) and "open" are that __cifs_unlink() sets
DCACHE_BLOCKED  *before* testing d_count() which is
in a d_lock locked region,  and cifs_d_revalidate() tests the bit *after*
->d_lock is taken by e.g. __d_lookup() to increment d_count().
Thus ->d_lock provide serialization between the set and the test
even though the test isn't in a locked region.
(The fact that cifs_d_revalidate() always returned -ECHILD when
 LOOKUP_RCU is important for this sequencing to work as it ensures
 d_revalidate() is called *after* d_count() is incremented).

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/client/cifsfs.h |  8 +++++
 fs/smb/client/dir.c    |  3 ++
 fs/smb/client/inode.c  | 68 ++++++++++++++++++++++++------------------
 3 files changed, 50 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 0c85daa8386e..bcc0fb5c2c9b 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -42,6 +42,14 @@ static inline unsigned long cifs_get_time(struct dentry *dentry)
 	return (unsigned long) dentry->d_fsdata;
 }
 
+/*
+ * This is set to block d_revalidate on a dentry that is being removed -
+ * the target of unlink or rename.  This causes any open attempt to
+ * block.  There may be existing opens but they can be detected by
+ * checking d_count() under ->d_lock.
+ */
+#define DCACHE_BLOCKED DCACHE_PRIVATE
+
 extern struct file_system_type cifs_fs_type, smb3_fs_type;
 extern const struct address_space_operations cifs_addr_ops;
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 6fa6d48fdfd3..88fff65320f5 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -872,6 +872,9 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
+	/* Wait for pending rename/unlink */
+	wait_var_event(&direntry->d_flags, !(direntry->d_flags & DCACHE_BLOCKED));
+
 	if (d_really_is_positive(direntry)) {
 		int rc;
 		struct inode *inode = d_inode(direntry);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 12ed8db10e00..4d34c5622cd4 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1967,24 +1967,31 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 	__u32 dosattr = 0, origattr = 0;
 	struct TCP_Server_Info *server;
 	struct iattr *attrs = NULL;
-	bool rehash = false;
+	bool unblock = false;
 
 	cifs_dbg(FYI, "cifs_unlink, dir=0x%p, dentry=0x%p\n", dir, dentry);
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return smb_EIO(smb_eio_trace_forced_shutdown);
 
-	/* Unhash dentry in advance to prevent any concurrent opens */
-	spin_lock(&dentry->d_lock);
-	if (!d_unhashed(dentry)) {
-		__d_drop(dentry);
-		rehash = true;
-	}
-	spin_unlock(&dentry->d_lock);
-
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
+
+	/* opens might already be blocked by rename */
+	if (!(dentry->d_flags & DCACHE_BLOCKED)) {
+		/*
+		 * Block opens - and all lookups that involve d_revalidate.
+		 * This guarantees that if another thread tries to open(), it
+		 * will either block, or will increment d_count()
+		 * before we test it below.
+		 */
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags |= DCACHE_BLOCKED;
+		spin_unlock(&dentry->d_lock);
+		unblock = true;
+	}
+
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
@@ -2107,8 +2114,13 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 	kfree(attrs);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
-	if (rehash)
-		d_rehash(dentry);
+	/* Allow lookups/opens */
+	if (unblock) {
+		spin_lock(&dentry->d_lock);
+		store_release_wake_up(&dentry->d_flags,
+				      dentry->d_flags &~ DCACHE_BLOCKED);
+		spin_unlock(&dentry->d_lock);
+	}
 	return rc;
 }
 
@@ -2536,7 +2548,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
-	bool rehash = false;
 	unsigned int xid;
 	int rc, tmprc;
 	int retry_count = 0;
@@ -2552,20 +2563,20 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return smb_EIO(smb_eio_trace_forced_shutdown);
 
-	/*
-	 * Prevent any concurrent opens on the target by unhashing the dentry.
-	 * VFS already unhashes the target when renaming directories.
-	 */
-	if (d_is_positive(target_dentry) && !d_is_dir(target_dentry)) {
-		if (!d_unhashed(target_dentry)) {
-			d_drop(target_dentry);
-			rehash = true;
-		}
-	}
-
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
+
+	/*
+	 * Block opens - and all lookups that involve d_revalidate.
+	 * This guarantees that if another thread tries to open(), it
+	 * will either block, or will increment d_count()
+	 * before we test it in __cifs_unlink().
+	 */
+	spin_lock(&target_dentry->d_lock);
+	target_dentry->d_flags |= DCACHE_BLOCKED;
+	spin_unlock(&target_dentry->d_lock);
+
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
@@ -2605,8 +2616,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 		}
 	}
 
-	if (!rc)
-		rehash = false;
 	/*
 	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
 	 */
@@ -2698,8 +2707,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 			}
 			rc = cifs_do_rename(xid, source_dentry, from_name,
 					    target_dentry, to_name);
-			if (!rc)
-				rehash = false;
 		}
 	}
 
@@ -2713,8 +2720,11 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
 
 cifs_rename_exit:
-	if (rehash)
-		d_rehash(target_dentry);
+	/* Allow lookups/opens */
+	spin_lock(&target_dentry->d_lock);
+	store_release_wake_up(&target_dentry->d_flags,
+			      target_dentry->d_flags &~ DCACHE_BLOCKED);
+	spin_unlock(&target_dentry->d_lock);
 	kfree(info_buf_source);
 	free_dentry_path(page2);
 	free_dentry_path(page1);

base-commit: 3879f51857325da9bf3cfb073280257cd16ae067
-- 
2.50.0.107.gf914562f5916.dirty

