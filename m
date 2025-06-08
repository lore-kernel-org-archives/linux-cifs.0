Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8552629C;
	Sun,  8 Jun 2025 16:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749401136; cv=none; b=sbKF1KnXVTFjUf4MZ8BexT1Z1Hqxwyug5LflzuQLcbMGHWImpuFVWvxVu+r9+J/RRvZRZuvD/cwBasYJlUGnpZfqPXIzwChA3uCYpXwRaL+9JLCZ0sTXf42tP7eh0/oW42w2KVDBgU9/sgd9KQJU8iU1K+CG6HnF9gE7mvhjkkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749401136; c=relaxed/simple;
	bh=DPipyBuXhIpIRDJR0fuQ/48mDMw26l2N7liiCYvvMTw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=bPww1YoDNCalbv2OxAcrfovSoDAeaZ/nR4HF+XSErV8vduHHiIVwLw2SLIKcsL/PYEhU9ci+aMOJwQUS2093zkQuXeAPsOM5ily1SMZcIXKrX8VnhMi+b7bqt1w54EjYrj0GzLMLyatMBcFdI/XJNU9ExTsiwZ+Tqf0B++5hlJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Awyc7Jwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Awyc7Jwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14918C4CEEE;
	Sun,  8 Jun 2025 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749401136;
	bh=DPipyBuXhIpIRDJR0fuQ/48mDMw26l2N7liiCYvvMTw=;
	h=From:To:Cc:Subject:Date:From;
	b=Awyc7JwlGkDFsMa96I/hWugqkSE/jBe9p1St16pzRZodLPAupKDMXES3ooJVj88kS
	 XEAsCZ2glmFPBMzYxAJYQiMKrrIFmULHJpCbojbYAnBJfAJbBzCw5crDRqVoDsWGN/
	 Aqx1xwougmOnB0dy1C7qWrZTtVEDcM0rHlMOzyEEZXJaM4oqwO8SmMD03nm0IB8TNg
	 3sDlrjCCrG3thNUcc1v+7PFGk66KfDCO6oDeAPqv+lLvYArY/N++8HY/o7t4SnPaz4
	 na0YUdyVAc+DENK7PxtEjvOJp+pcmM+RZiJNypB1NJonlrZHM5rxINJroFiSQXj7TK
	 l6G5kEVCaKf2A==
Received: by pali.im (Postfix)
	id 83C2055E; Sun,  8 Jun 2025 18:45:33 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Show reason why autodisabling serverino support
Date: Sun,  8 Jun 2025 18:44:53 +0200
Message-Id: <20250608164453.6699-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Before calling cifs_autodisable_serverino() function, show reason why it
has to be called.

This change allows to debug issues why cifs.ko decide to turn off server
inode number support and hence disable support for detection of hardlinks.

Signed-off-by: Pali Rohár <pali@kernel.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/connect.c   | 2 ++
 fs/smb/client/dfs_cache.c | 2 ++
 fs/smb/client/inode.c     | 3 +++
 fs/smb/client/readdir.c   | 3 +++
 4 files changed, 10 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 6bf04d9a5491..e2dbf7eaf32a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3908,6 +3908,8 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	 * After reconnecting to a different server, unique ids won't match anymore, so we disable
 	 * serverino. This prevents dentry revalidation to think the dentry are stale (ESTALE).
 	 */
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+		cifs_dbg(VFS, "Reconnecting to different server, inode numbers won't match anymore\n");
 	cifs_autodisable_serverino(cifs_sb);
 	/*
 	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 4dada26d56b5..bb5bf9f45557 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1289,6 +1289,8 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 	 * After reconnecting to a different server, unique ids won't match anymore, so we disable
 	 * serverino. This prevents dentry revalidation to think the dentry are stale (ESTALE).
 	 */
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+		cifs_dbg(VFS, "Reconnecting to different server, inode numbers won't match anymore\n");
 	cifs_autodisable_serverino(cifs_sb);
 	/*
 	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index cd06598eacbd..c6da25520f29 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1077,6 +1077,7 @@ static void cifs_set_fattr_ino(int xid, struct cifs_tcon *tcon, struct super_blo
 			fattr->cf_uniqueid = CIFS_I(*inode)->uniqueid;
 		else {
 			fattr->cf_uniqueid = iunique(sb, ROOT_I);
+			cifs_dbg(VFS, "Cannot retrieve inode number for %s: %d\n", full_path, rc);
 			cifs_autodisable_serverino(cifs_sb);
 		}
 		return;
@@ -1530,6 +1531,7 @@ cifs_iget(struct super_block *sb, struct cifs_fattr *fattr)
 			fattr->cf_flags &= ~CIFS_FATTR_INO_COLLISION;
 
 			if (inode_has_hashed_dentries(inode)) {
+				cifs_dbg(VFS, "Inode number collision detected\n");
 				cifs_autodisable_serverino(CIFS_SB(sb));
 				iput(inode);
 				fattr->cf_uniqueid = iunique(sb, ROOT_I);
@@ -1597,6 +1599,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	if (!rc) {
 		if (fattr.cf_flags & CIFS_FATTR_JUNCTION) {
 			fattr.cf_flags &= ~CIFS_FATTR_JUNCTION;
+			cifs_dbg(VFS, "Cannot retrieve attributes for junction point %s: %d\n", path, rc);
 			cifs_autodisable_serverino(cifs_sb);
 		}
 		inode = cifs_iget(sb, &fattr);
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 787d6bcb5d1d..1235b5bf9814 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -413,6 +413,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 		cifsFile->invalidHandle = false;
 	} else if ((rc == -EOPNOTSUPP) &&
 		   (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+		cifs_dbg(VFS, "Cannot retrieve inode number for entries in dir %s: %d\n", full_path, rc);
 		cifs_autodisable_serverino(cifs_sb);
 		goto ffirst_retry;
 	}
@@ -1007,6 +1008,8 @@ static int cifs_filldir(char *find_entry, struct file *file,
 		fattr.cf_uniqueid = de.ino;
 	} else {
 		fattr.cf_uniqueid = iunique(sb, ROOT_I);
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
+			cifs_dbg(VFS, "Cannot retrieve inode number for dir entry %.*s\n", name.len, name.name);
 		cifs_autodisable_serverino(cifs_sb);
 	}
 
-- 
2.20.1

