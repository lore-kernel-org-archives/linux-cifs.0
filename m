Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B365B3939C2;
	Mon,  6 Jul 2026 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783362588; cv=none; b=lBr5vyIeJK1zXEphKW/M+c+A2blCeE4kA/zdL9Zc5URbY0+n1jpJ3fSRejWKI78dCQlLlQvxRZqXupwvodyRRGNjPNsxXYHNc45T7kaphsjS5o+GDVJW26CoyOyMG6o3qSUoMvZnb2aq5c2kxbdze8epsMWoPkUKw/0qTEGM0ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783362588; c=relaxed/simple;
	bh=EmDdn2KAYYuR37emLIipJlkGxk2+wU5QU2cGpIZaWX4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=prkAZTW6pZY8S6LIBjdE64yjhEpmYkaeFLbfWMdGnqh7PSKL8kV3JCKj3RqJIcnpU5z+El8rnc0+5Yan2ON03J1mVFrW9iSAEwidgua5dTilzT2n9+UicHZFP0bMtXlDls2NaQSba5ZUzx7oOUW/owl2bgM3/5EqWYzd2XS/LGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RvTXZT2z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RvTXZT2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA361F000E9;
	Mon,  6 Jul 2026 18:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783362586;
	bh=t9nxbseiNl9MH4OMgUG1rvdz+HmPZviDrRsCrBWz4QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvTXZT2zBLlslzk8ziQYlzPX06cbJVUlGrDZzMI5BdG/awS2CD3znmSJnNSQJvN7l
	 Me4B2otcNl47HpR/7yq3kTVIBt64zgOvRtikz2CfZtKefsp1SsMpvLFMBB/EuZDYYw
	 VmB3VXicEFu5GeSX/kh9xsKqFTLcqCbGsjNkI0OOYTQ20uPxFj9zgrjkmmxq96lxLh
	 HSPiEcvosrTlXbCTCrkxFwatK1skUgWckm9UH0N03xyj1e8AFgYt/DqSspcBHaNNzJ
	 1fcbVfmkxSyo5bbk2gx7KcaeAgh0asvKn8r9aRSfihb17imaaXM3fIwW+OlBeX9OYx
	 vPCciNFAWJiMw==
Received: by pali.im (Postfix)
	id 5D0E45D7; Mon,  6 Jul 2026 20:29:43 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] cifs: Show reason why autodisabling serverino support
Date: Mon,  6 Jul 2026 20:29:36 +0200
Message-Id: <20260706182936.22007-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <6dd60d4365ed96f472c9b59dc8fca6bf@manguebit.org>
References: <6dd60d4365ed96f472c9b59dc8fca6bf@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Extend cifs_autodisable_serverino() function to print also text message why
the function was called.

The text message is printed just once for mount then autodisabling
serverino support. Once the serverino support is disabled for mount it will
not be re-enabled. So those text messages do not cause flooding logs.

This change allows to debug issues why cifs.ko decide to turn off server
inode number support and hence disable support for detection of hardlinks.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsproto.h | 2 +-
 fs/smb/client/connect.c   | 2 +-
 fs/smb/client/dfs_cache.c | 2 +-
 fs/smb/client/inode.c     | 7 ++++---
 fs/smb/client/misc.c      | 6 +++++-
 fs/smb/client/readdir.c   | 4 ++--
 6 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 1ed97957038f..1202934d7b94 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -317,7 +317,7 @@ int generate_smb311signingkey(struct cifs_ses *ses,
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
+void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb, const char *reason, int rc);
 bool couldbe_mf_symlink(const struct cifs_fattr *fattr);
 int check_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 		     struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 85aec302c89e..522c2abd930c 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3875,7 +3875,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	 * After reconnecting to a different server, unique ids won't match anymore, so we disable
 	 * serverino. This prevents dentry revalidation to think the dentry are stale (ESTALE).
 	 */
-	cifs_autodisable_serverino(cifs_sb);
+	cifs_autodisable_serverino(cifs_sb, "DFS failover may potentially connect to a different server, inode numbers won't match anymore", 0);
 	/*
 	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
 	 * that have different prefix paths.
diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 83f8cf2f8d2b..42eee0de8895 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1328,7 +1328,7 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 	 * After reconnecting to a different server, unique ids won't match anymore, so we disable
 	 * serverino. This prevents dentry revalidation to think the dentry are stale (ESTALE).
 	 */
-	cifs_autodisable_serverino(cifs_sb);
+	cifs_autodisable_serverino(cifs_sb, "DFS failover may potentially connect to a different server, inode numbers won't match anymore", 0);
 	/*
 	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
 	 * that have different prefix paths.
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 002a2ec85db5..945a34f3d830 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1090,7 +1090,7 @@ static void cifs_set_fattr_ino(int xid, struct cifs_tcon *tcon, struct super_blo
 			fattr->cf_uniqueid = CIFS_I(*inode)->uniqueid;
 		else {
 			fattr->cf_uniqueid = iunique(sb, ROOT_I);
-			cifs_autodisable_serverino(cifs_sb);
+			cifs_autodisable_serverino(cifs_sb, "Cannot retrieve inode number via get_srv_inum", rc);
 		}
 		return;
 	}
@@ -1546,7 +1546,7 @@ cifs_iget(struct super_block *sb, struct cifs_fattr *fattr)
 			fattr->cf_flags &= ~CIFS_FATTR_INO_COLLISION;
 
 			if (inode_has_hashed_dentries(inode)) {
-				cifs_autodisable_serverino(CIFS_SB(sb));
+				cifs_autodisable_serverino(CIFS_SB(sb), "Inode number collision detected", 0);
 				iput(inode);
 				fattr->cf_uniqueid = iunique(sb, ROOT_I);
 				goto retry_iget5_locked;
@@ -1612,8 +1612,9 @@ struct inode *cifs_root_iget(struct super_block *sb)
 iget_root:
 	if (!rc) {
 		if (fattr.cf_flags & CIFS_FATTR_JUNCTION) {
+			cifs_dbg(VFS, "Removing junction mark and disabling 'serverino' to prevent inode collisions\n");
 			fattr.cf_flags &= ~CIFS_FATTR_JUNCTION;
-			cifs_autodisable_serverino(cifs_sb);
+			cifs_autodisable_serverino(cifs_sb, "Cannot retrieve attributes for junction point", rc);
 		}
 		inode = cifs_iget(sb, &fattr);
 	}
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 0c54b9b79a2c..f47874734248 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -278,7 +278,7 @@ dump_smb(void *buf, int smb_buf_length)
 }
 
 void
-cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
+cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb, const char *reason, int rc)
 {
 	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 
@@ -290,6 +290,10 @@ cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
 
 		atomic_andnot(CIFS_MOUNT_SERVER_INUM, &cifs_sb->mnt_cifs_flags);
 		cifs_sb->mnt_cifs_serverino_autodisabled = true;
+		if (rc)
+			cifs_dbg(VFS, "%s: %d\n", reason, rc);
+		else
+			cifs_dbg(VFS, "%s\n", reason);
 		cifs_dbg(VFS, "Autodisabling the use of server inode numbers on %s\n",
 			 tcon ? tcon->tree_name : "new server");
 		cifs_dbg(VFS, "The server doesn't seem to support them properly or the files might be on different servers (DFS)\n");
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index a50c86bbe60f..ee5996e6d7d8 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -415,7 +415,7 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 	if (rc == 0) {
 		cifsFile->invalidHandle = false;
 	} else if (rc == -EOPNOTSUPP && (sbflags & CIFS_MOUNT_SERVER_INUM)) {
-		cifs_autodisable_serverino(cifs_sb);
+		cifs_autodisable_serverino(cifs_sb, "Cannot retrieve inode number via query_dir_first", rc);
 		goto ffirst_retry;
 	}
 error_exit:
@@ -1029,7 +1029,7 @@ static int cifs_filldir(char *find_entry, struct file *file,
 		fattr.cf_uniqueid = de.ino;
 	} else {
 		fattr.cf_uniqueid = iunique(sb, ROOT_I);
-		cifs_autodisable_serverino(cifs_sb);
+		cifs_autodisable_serverino(cifs_sb, "Cannot retrieve inode number from readdir", 0);
 	}
 
 	if ((sbflags & CIFS_MOUNT_MF_SYMLINKS) && couldbe_mf_symlink(&fattr))
-- 
2.20.1

