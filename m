Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DBF283FD6
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754666438; cv=none; b=WcStgoAXYHYuV1HD6ct7eV2qL+39kM0bVlWaa+jgIlNAF/l7C/W2+1wVRnMfNKeRvqgacwkOmEHBxcTF0A/p5LF3CoONCBDU9drTLxXGrLal5S+5tanL7R/qx2Pa+xELfbugHnW1yEIgn5xAYYp/uQru9BJryFaeV0iZ/AfxGAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754666438; c=relaxed/simple;
	bh=XfXv1tR/5t8ejBtpUTmimmjV3sayXm97uMax8FNH/Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jB+RHDDz44dPt2s2085/KfeZ7w4C1ryoh+uTKqOjmg4ObWf8sODF9kJH1TiBCs8O9vlxBzPohrMPaXbpilAH0kNGsq69qlHdzcwkjJQ2P7B5bcVMBCnOOgKI/JfyrNRTL/l2SFU6cYSoe2qlLY3AbpeAJmSDKSn0YF7Xe+Yv6TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=LjxOQl/G; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="LjxOQl/G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=G2Xz47ylwN0VqTFt/8E7w7YF26KZKkNtumndvYUr88g=; b=LjxOQl/GNibDCYRlKTY6UaqtDS
	nHUJ+z2Q2pK302fLyKUX9JdwRhcpQOLu11yHRk2n7HOMxrexBDse2FLrzs7KQeb/Y8RzecxD8zfHY
	s68BbhGnbdX4lJ5QmgDzjxZkywiINTcUBJc6qi6J021xpUOIbP0+ng+hblcjr3vkl1sDQtiP0rFJm
	GEp89jSMei06z7xyqJQTunAl+0IiuwjLk4MDkvjhlGdr3zIoqHvH9eqOdlGEje5Oy6Z27dhz/apmC
	Z8ZUDh7NasruZnlDzssA7tshXOHwr022DCBVoyAFgca3le7bkJvfbuW1QE/T0HFaWw9FgAb+Xgwi3
	UC4gb2CQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1ukOtW-00000000FaW-2cOF;
	Fri, 08 Aug 2025 12:20:34 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 2/2] smb: client: fix race with concurrent opens in rename(2)
Date: Fri,  8 Aug 2025 12:20:18 -0300
Message-ID: <20250808152018.527103-2-pc@manguebit.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250808152018.527103-1-pc@manguebit.org>
References: <20250808152018.527103-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 fs/smb/client/inode.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index cf9060f0fc08..0364b8882289 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2469,11 +2469,13 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	     struct dentry *source_dentry, struct inode *target_dir,
 	     struct dentry *target_dentry, unsigned int flags)
 {
+	struct inode *target_inode = d_inode(target_dentry);
 	const char *from_name, *to_name;
 	void *page1, *page2;
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
+	bool rehash = false;
 	unsigned int xid;
 	int rc, tmprc;
 	int retry_count = 0;
@@ -2489,6 +2491,19 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return -EIO;
 
+	/*
+	 * Prevent any concurrent opens on the target by unhashing the dentry.
+	 * VFS already unhashes the target when renaming directories.
+	 */
+	if (target_inode && !S_ISDIR(target_inode->i_mode)) {
+		spin_lock(&target_dentry->d_lock);
+		if (!d_unhashed(target_dentry)) {
+			__d_drop(target_dentry);
+			rehash = true;
+		}
+		spin_unlock(&target_dentry->d_lock);
+	}
+
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
@@ -2599,6 +2614,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	free_dentry_path(page1);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
+	if (rehash)
+		d_rehash(target_dentry);
 	return rc;
 }
 
-- 
2.50.1

