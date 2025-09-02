Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AD22D9ECA;
	Tue,  2 Sep 2025 13:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819845; cv=none; b=EP6uYl60b8J/2da3nCwTIQBvUFb3ijLf6rSRZidGAKnPmFAltmqEsYTmC7DsiDVVzVLgmz2N5BUwxOFz//b+GOIMW3FPeqvYFzXkYBhCu0Vy/DGoWiN2ci8/Bn6QUUA3MVy4b4vX9v0c9y2nSe/D1SULmlNeaGVvi6Y/M9MwgF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819845; c=relaxed/simple;
	bh=+NtwQ/LZkk1iLSgyjFL55ZNokLbRqql1uStoQH3lXwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIcdf0LzS4p5PnmST5X65PZReLG4xHxE4SO7m1z9n/MslvC6zY8krF3iXu3+3e1RI7rB9fg7OK6z/Q+8IzSCVfdeu4XYEbxd3l/yNYAwpFr7EWf364hemYq2CuDY48fRW7B4T9uVTu3cMqdJPK6rVWoBUwVPVS9u6CoFYMU2P0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P52YZbqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P52YZbqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34977C4CEED;
	Tue,  2 Sep 2025 13:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819844;
	bh=+NtwQ/LZkk1iLSgyjFL55ZNokLbRqql1uStoQH3lXwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P52YZbqNhwZ6ZRmDsEcVI+iOWN49yOrAj3KW/lF/EyY/u7iQNU1aFRZtEkRR3rgg/
	 ZWHNytnoBy7YlYcRpin7c0tbSdjX1fbbHpB935nsD/Mbo+/qr8VEGRz8u5U3X7WD8S
	 QXbFo9RU+ZqNWnNAtGuq6vMuEE4CEXqd54Gmr0qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 14/95] smb: client: fix race with concurrent opens in rename(2)
Date: Tue,  2 Sep 2025 15:19:50 +0200
Message-ID: <20250902131940.160939436@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit d84291fc7453df7881a970716f8256273aca5747 ]

Besides sending the rename request to the server, the rename process
also involves closing any deferred close, waiting for outstanding I/O
to complete as well as marking all existing open handles as deleted to
prevent them from deferring closes, which increases the race window
for potential concurrent opens on the target file.

Fix this by unhashing the dentry in advance to prevent any concurrent
opens on the target.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 02f78e58e11d0..c0df2c1841243 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2441,6 +2441,7 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
+	bool rehash = false;
 	unsigned int xid;
 	int rc, tmprc;
 	int retry_count = 0;
@@ -2456,6 +2457,17 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return -EIO;
 
+	/*
+	 * Prevent any concurrent opens on the target by unhashing the dentry.
+	 * VFS already unhashes the target when renaming directories.
+	 */
+	if (d_is_positive(target_dentry) && !d_is_dir(target_dentry)) {
+		if (!d_unhashed(target_dentry)) {
+			d_drop(target_dentry);
+			rehash = true;
+		}
+	}
+
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
@@ -2497,6 +2509,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 		}
 	}
 
+	if (!rc)
+		rehash = false;
 	/*
 	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
 	 */
@@ -2555,12 +2569,16 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 			goto cifs_rename_exit;
 		rc = cifs_do_rename(xid, source_dentry, from_name,
 				    target_dentry, to_name);
+		if (!rc)
+			rehash = false;
 	}
 
 	/* force revalidate to go get info when needed */
 	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
 
 cifs_rename_exit:
+	if (rehash)
+		d_rehash(target_dentry);
 	kfree(info_buf_source);
 	free_dentry_path(page2);
 	free_dentry_path(page1);
-- 
2.50.1



