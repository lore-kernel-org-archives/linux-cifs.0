Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E683346E6C
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 14:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781189891; cv=none; b=DILLsB3QtqpN/Sb1XzgWjCJXn8XXroM6P1GpWV0YrsaD/PxbpmB2ohUSw/6UYuFjU4zu0KugCZcfRpboGrSreA2Hxe3qnhXKYafX1ZpNk7K0S0Ipijb6HPEvli1OM1xbn3ehWfUUCi5boxBa0OLJkwRKEzApb2Qpm9GmHbonnNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781189891; c=relaxed/simple;
	bh=J//cfuwjgVmswzklLtbxmhMCaZFCWapU0OSLMdbod9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdpTe4cW49svYFBIyadm/VVm5iPpQLyGP5ktJtJub8+VxQExxpitktVcNGlLk+sTO1+x3jGlqEab6vz9ZrUeMf3zvsmsC5I5wUOE3Iatkp2yRjnoGnoR4jR+5A98YHk3HCoJLLJSV9y4W7dJxFw9/Qe7IqinMCddukonqUkKsUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=VPFt7NcI; arc=none smtp.client-ip=195.121.94.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="VPFt7NcI"
X-KPN-MessageId: f192a272-65a5-11f1-afe5-005056994fde
Received: from smtp.kpnmail.nl (unknown [10.31.155.8])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id f192a272-65a5-11f1-afe5-005056994fde;
	Thu, 11 Jun 2026 16:58:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=41+hHt7nxuGx4uU4TyawFgwl5WNYYdDIdH8OhPB0rGM=;
	b=VPFt7NcI52Y0K6MsSlWW6SogdM0e8lhEt3WWa8aAtK07VEaxVzCpT8jwrBVjB9ItV1y3ciqiCgHqp
	 aj8Bp5e7/QgZcJ4iLv8hEd15U5Xacu3iTX5Vr2/HA5g3YL980zvMH9xqLy9TzQ3EsbQQ/1Xj5lbF/5
	 yd+Rv8V+3HqDq31INapSrz4CMUmJmvn/yLL0n51En342EuZp/GeW5eZgG1jHVJ4p/+2tPIl3HpQYcF
	 S/QFLCaonbS7nlRW2dQ+Vfx4LkPekc3MvXgt+HC5U61ghaqs0CQeRcBOuGRc8Rd4Zb/dO+qR2XX5rO
	 74Vsep90Fyigb9FT5rr/9FgFAsSVg5g==
X-KPN-MID: 33|vlosg6brkS0ix2jU8xprXm48u015xMw/9wLNgGvk3HNnyonaVgJtdT/pAvH8QRE
 ANqwLss7EISP2rRIH90Klsv5OV1ZMXtdmE3kxo6ttfNU=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|hs2jL7pbTQv2vXaOXW2og73j9kALNVnOnj0o0sNQTCnltvxV1LbI6WXkZ1S1NUj
 fk0qgkJXsHxRdDGzjXgqIZg==
Received: from lt-jori.home (unknown [178.226.150.234])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id f139306e-65a5-11f1-9c0d-00505699d6e5;
	Thu, 11 Jun 2026 16:58:02 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Steve French <sfrench@samba.org>,
	Steve French <smfrench@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jkoolstra@xs4all.nl
Subject: [RFC PATCH 1/1] vfs: pass S_IFDIR mode to vfs_prepare_mode()
Date: Thu, 11 Jun 2026 16:57:07 +0200
Message-ID: <20260611145733.43776-2-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611145733.43776-1-jkoolstra@xs4all.nl>
References: <20260611145733.43776-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a comment in vfs_prepare_mode() that says:

  Note that it's currently valid for @type to be 0 if a directory is
  created. Filesystems raise that flag individually and we need to check
  whether each filesystem can deal with receiving S_IFDIR from the vfs
  before we enforce a non-zero type.

This is a bit challenging since there are many filesystems. Claude Opus
4.8 was used to generate the context for each mkdir implementation from
which it can be judged whether passing S_IFDIR is safe. The result was
then verified by hand by looking at how the mode argument is used in
each case. To check whether all mkdir implementations are covered,
'rg "\.mkdir" ' was used and checked against the list of uses the AI
assistent found.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Assisted-by: Claude:Opus 4.8
---
 fs/namei.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4787244ca4a7..5ae466100fb4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4142,11 +4142,6 @@ EXPORT_SYMBOL(end_renaming);
  * after setgid stripping allows the same ordering for both non-POSIX ACL and
  * POSIX ACL supporting filesystems.
  *
- * Note that it's currently valid for @type to be 0 if a directory is created.
- * Filesystems raise that flag individually and we need to check whether each
- * filesystem can deal with receiving S_IFDIR from the vfs before we enforce a
- * non-zero type.
- *
  * Returns: mode to be passed to the filesystem
  */
 static inline umode_t vfs_prepare_mode(struct mnt_idmap *idmap,
@@ -5255,7 +5250,7 @@ struct dentry *vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	if (!dir->i_op->mkdir)
 		goto err;
 
-	mode = vfs_prepare_mode(idmap, dir, mode, S_IRWXUGO | S_ISVTX, 0);
+	mode = vfs_prepare_mode(idmap, dir, mode, S_IRWXUGO | S_ISVTX, S_IFDIR);
 	error = security_inode_mkdir(dir, dentry, mode);
 	if (error)
 		goto err;
-- 
2.54.0

