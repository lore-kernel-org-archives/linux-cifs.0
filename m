Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6240135DA4C;
	Mon, 28 Sep 2026 01:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790558915; cv=none; b=RLZuoJYYSH0J7iqlRsUnFVI4vSsnKECEbqvKf35v8F48SAnMhgZEs5h5pYx+XCQeHZOEfKWMaYgHhGjkEEDx6dw/hBjJXMaXhwdWEFeDMJV4caZcsvpKv1rr9rvJPtzsXV5oLbPhCVXYRZbnoZ05u1ucqxpx+DcLB+LjmL3RI4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790558915; c=relaxed/simple;
	bh=FCoNfaukmx1UmUsfsLxo2ghDObqIVLN+kHOKDaq//+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbrDH5MJkQ2d1rYZYa0VekOc/IpeNN7eIh5rUoVfpUipjUxLEjoaXhmx66fvFbg8Bi656qgPSg0HyOA4s6ikiPBxH54LJSphMgezbXgR0e/aTEyuJdbm4GkncEUomcWi+rrswN5uofZ3sE8kk+QXZrIofY9f3bGZBTqvLWIgARM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=JSVu/gXK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=rUOpHqoy; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="JSVu/gXK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rUOpHqoy"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.stl.internal (Postfix) with ESMTP id 608BB1D00046;
	Sun, 27 Sep 2026 21:28:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Sun, 27 Sep 2026 21:28:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790558912;
	 x=1790645312; bh=ruLOsgXU5wdr8mH4euwYN2IlyWVXx7+7GVQ+aQDDmEk=; b=
	JSVu/gXKxXX5jOfdQe1nBbBAjqS5ZWNkWMqB1UDcYxSIk8lE3uDoTkDcAz7dJGzD
	sanfTKTYTjvimshXjbsc5gk3P/TFN2t15DiEzIaPMDNN8jyR2G6czBEc8UVRhYVV
	a6H9kPNDk98l90sc3oZ01gZR1GFVgVvAdHN1ZzpOsJGypfTc3C/gUG/M9S5YkpJt
	UOa6oPVSYPuBSA8V7h066eDKumoZD2DJtI1O4naEzVmQutI1dl2v34ODUhdKT0w7
	DgO1N9fXWVZ/DniDUt3sabqr8JiD+ua2Is7jZDJFEYchptPz+U0PDait2ofZwjPk
	jT+tJfZoe8OIZYL+GcNkIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790558912; x=1790645312; bh=r
	uLOsgXU5wdr8mH4euwYN2IlyWVXx7+7GVQ+aQDDmEk=; b=rUOpHqoyiBOq0iM4v
	4PbdWO6CY4OBIcFY121jQncZvqnvyKOxIlAeA56jg4rQODR/etlhk+Z3G5AyUgbA
	ZFbVZOPgDXCX8VbnfON/FyOueCNYrA0gQqD72f4KzhNLVK71fiiR7vEr3TMaDFO1
	ZTEHG5qUJB5e05kSq9MnVqoTAh3QzrSpXI92mRrliMTf4tqWDclUaVUFqxeeGEZW
	NFpYmCvAA/XpZWOznWKSdCkwlc8OeDSJ4Z9mTefFwLlLewCVHRT+bUKSzJhJwx2+
	5wIUCwxwgyT8qPmwZYTaV8jN7DGSxBdUU/VD9ecmI5o92XH6NPcUK6iJ3RkwWQI9
	hSwgQ==
X-ME-Sender: <xms:v8K5auuQyf_oiscD2NJT_otgp5Nyjp78RpSi0OzF6-byDd74AHpMGw>
    <xme:v8K5amjXHpT_Ks0q7_aH-EctJcRbDhHmVtFSZU-VcB4cBNxzOrdlf6l8hIPCJosyj
    gL_IvrIvbqi0gTKvcf2Pb7rMD5AcM_Hz_sPJ3YIhr8H3wu9Dmc>
X-ME-Received: <xmr:v8K5akb_puYg78vQtWToALgHUmyM2UHmDEcxH2Q0JoF-aOSbcFPGUUYSmoYsaCGaPKFTT7PFxJ3kcN0PuJ9w4bfE8PM0UHo>
X-ME-Proxy-Cause: dmFkZTEo5XpDuYcFbgku1MpxLrtlAwn9oABQiqTHUUsYGNkTkpjNR1FoAv+g+LSQLaDYOj
    FwGH3NvRNteiumxt1F6Cp/2rGUKUvMZuLPGG0GnGBjAOs/QgYPZC/bBdtw9Zv0Ksy2JF90
    tuPjd78+GZH8BIhKu53k5StZKk1mRgGOhpyEXB3DuVVMf4LwggW9Ea8/JevZ7QwaWWJV6o
    SiS5wQHhkj0btG9M0UWaWiU6MPJn3I037+6FShebRcIBMY/3oesNf2QiHKI9HbGig861FF
    EAdciql9mo1y6FQjW/1ajz0TvW9Xg4e9YuQA1XOaiJlH/3OXtturskljpXM2Qfspbb2St8
    Kd7iNIR4p/kEt5cZ2ztEU1zoReeWcwHTWVI95GbodwCM/UFxQWJBUNsrf0DbsxnAki9gLg
    9r3a4ck4iH6HnjU622EHoh5qqm4MEWZWl65nMeBFSjDEF3z6vNysS96kLulCHWoYEyDV7i
    xDDNf2DvtKUwYH9PUHA+e0fjYMk4zdUHB30Byqmptt/jmLWbMaxvOyPqXOBoIMGZ61UZFp
    Q+VRH/n7kz75iRrfoMWXwXjSnbmF2hpFFlQZ3QnUpFcDw1xgjGi16LVy/3RuypCa5PFrdJ
    9Y48CLQv81l7FLDkNngBvIm3lVrUiJLzu25uwmr/jSvpxjYkC5Z8n8sSioPg
X-ME-Proxy: <xmx:v8K5alYM_h_8B30ckg3qC4VXNl_9ozlCCs_zTP9ULTSpG0Rjh9kAUA>
    <xmx:v8K5apztSGVed53SEJ3w0k5XGKkmr-vSQLZBwhzWt-53xlP0JGx5cA>
    <xmx:v8K5ahdkybsDvF-JVX09YqSArc5qWUNh729n_CEs0QJ5ebL9GF_aRw>
    <xmx:v8K5au4JW6UAvBoZ0S27tr0f3v6iQD0SWIMRbwec9Jv3BpAY4uuMQA>
    <xmx:wMK5asNDwvL8y11aJciehthvZ4LvFsURzmWd4ZQhWAgxABfThgyGeA2w>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Sep 2026 21:28:29 -0400 (EDT)
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
Subject: [PATCH 1/3] smb/client: don't unhash and rehash to prevent new opens.
Date: Mon, 28 Sep 2026 11:25:02 +1000
Message-ID: <20260928012812.2890035-2-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260928012812.2890035-1-neilb@ownmail.net>
References: <20260928012812.2890035-1-neilb@ownmail.net>
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

