Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AA02848A1;
	Tue,  2 Sep 2025 13:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820238; cv=none; b=maMFFD4cGvhhHONFy1eN8CkuYl7eIQzJium9dLWeCLVQNboZTTLe8CUcCNBVBUfIWP6JxhLd3RdkBRQQ2gTCRjcNj3R2X+SOjcmZZ6uPFRlZFPrW2esTK7J3Sq3nwjdTvHnChW/N/aF40FgCvqMDRBPoXa9K/+VRj2oiuKqGVrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820238; c=relaxed/simple;
	bh=+vdstVZ4juHqCo3Vna11yyYBcSTfZZvBpFZUGL+22oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0Q3ljFavc+lP3fa5YZJOiqMLxJmOACwBbhjPGmMgslUbDfOIrGBE7Sbc8TAMcSX6nd/RWVSutBMzs/bNX64RABS0qDf6wXmsMqRtAAZLMIJrfLLe11x4K/sFuEdGauWsmB1GdV55k9do/NsGIoyIlVK0BGTyOJLPY/Qdl7EVoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uPa9Wr44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uPa9Wr44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37980C4CEED;
	Tue,  2 Sep 2025 13:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820234;
	bh=+vdstVZ4juHqCo3Vna11yyYBcSTfZZvBpFZUGL+22oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPa9Wr44olchefg65PLeLWkRrjkoqXD4B4exVozpUVSp0BJKaI/cwBJ8iODB2pC8Q
	 0cmR3xvtHotN8hUd8iXmwD3S8LMKqa35I2cOIVreoZ4phUVLImzfd9WwqbgqeXGWZK
	 k9K7HobUdhPUNaLesrQyVmN1gk+Cnjk7pUijtBeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 09/75] smb: client: fix race with concurrent opens in unlink(2)
Date: Tue,  2 Sep 2025 15:20:21 +0200
Message-ID: <20250902131935.482135582@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
User-Agent: quilt/0.68
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
 fs/smb/client/inode.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index d93ebd58ecae1..df01029918fd4 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1856,15 +1856,24 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
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
@@ -1915,7 +1924,8 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 			cifs_drop_nlink(inode);
 		}
 	} else if (rc == -ENOENT) {
-		d_drop(dentry);
+		if (simple_positive(dentry))
+			d_delete(dentry);
 	} else if (rc == -EBUSY) {
 		if (server->ops->rename_pending_delete) {
 			rc = server->ops->rename_pending_delete(full_path,
@@ -1968,6 +1978,8 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	kfree(attrs);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
+	if (rehash)
+		d_rehash(dentry);
 	return rc;
 }
 
-- 
2.50.1



