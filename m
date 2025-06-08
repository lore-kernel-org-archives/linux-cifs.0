Received: from neil.brown.name (neil.brown.name [103.29.64.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D464266EE6;
	Sun,  8 Jun 2025 23:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.29.64.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426530; cv=none; b=LxUK5CTFV7J2Mfwq/urlgIumy2YhaXXs+TKFO6mTVUsi/UfpmUULHDz97UtgOnL7qqfpCUV4yHL1u9/bRz9Vo7RDsn1VERgwlp2+JgBGnbttXcUjlzycrvFDGo/MSvcBpUdS7xGhJBtMVPGlYc/BtPyfCAHDBj51lxPDa2ujFj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426530; c=relaxed/simple;
	bh=3YBoOnsttTwfK6d2mEgMl66pTUTeYKILYQXcOnY05wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X16IeF3mnW4muxNhCZIf3hXqUAS3hHXJ8+s11DxRxpTXdvP5cpe1Tgjzx9q3+02dCKbfaClzQibXT500IjToe/RGbBZxut7BCub+IPCJQDmk2GeXq6LmVjILrClX6v/n107rnZ/3bwhQH9B+dNv1lrTjsPwpIggVWbvu5ZE/93o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brown.name; spf=pass smtp.mailfrom=neil.brown.name; arc=none smtp.client-ip=103.29.64.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=neil.brown.name
Received: from 196.186.233.220.static.exetel.com.au ([220.233.186.196] helo=home.neil.brown.name)
	by neil.brown.name with esmtp (Exim 4.95)
	(envelope-from <mr@neil.brown.name>)
	id 1uOPko-005xqq-Vj;
	Sun, 08 Jun 2025 23:48:43 +0000
From: NeilBrown <neil@brown.name>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] smb/server: use lookup_one_unlocked()
Date: Mon,  9 Jun 2025 09:35:07 +1000
Message-ID: <20250608234108.30250-2-neil@brown.name>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250608234108.30250-1-neil@brown.name>
References: <20250608234108.30250-1-neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In process_query_dir_entries(), instead of locking the directory,
performing a lookup, then unlocking, we can simply call
lookup_one_unlocked().  That takes locks the directory only when needed.

This removes the only users of lock_dir() and unlock_dir() so they can
be removed.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/server/smb2pdu.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1a308171b599..0013052f5d98 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4107,20 +4107,6 @@ struct smb2_query_dir_private {
 	int			info_level;
 };
 
-static void lock_dir(struct ksmbd_file *dir_fp)
-{
-	struct dentry *dir = dir_fp->filp->f_path.dentry;
-
-	inode_lock_nested(d_inode(dir), I_MUTEX_PARENT);
-}
-
-static void unlock_dir(struct ksmbd_file *dir_fp)
-{
-	struct dentry *dir = dir_fp->filp->f_path.dentry;
-
-	inode_unlock(d_inode(dir));
-}
-
 static int process_query_dir_entries(struct smb2_query_dir_private *priv)
 {
 	struct mnt_idmap	*idmap = file_mnt_idmap(priv->dir_fp->filp);
@@ -4135,12 +4121,10 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
 		if (dentry_name(priv->d_info, priv->info_level))
 			return -EINVAL;
 
-		lock_dir(priv->dir_fp);
-		dent = lookup_one(idmap,
-				  &QSTR_LEN(priv->d_info->name,
-					    priv->d_info->name_len),
-				  priv->dir_fp->filp->f_path.dentry);
-		unlock_dir(priv->dir_fp);
+		dent = lookup_one_unlocked(idmap,
+					   &QSTR_LEN(priv->d_info->name,
+						     priv->d_info->name_len),
+					   priv->dir_fp->filp->f_path.dentry);
 
 		if (IS_ERR(dent)) {
 			ksmbd_debug(SMB, "Cannot lookup `%s' [%ld]\n",
-- 
2.49.0

