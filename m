Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C5C30F533;
	Tue,  2 Sep 2025 13:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820136; cv=none; b=l95B39TVSLY5fVGLrfPLopb0cvxnohh4sRio0Y/PBPaCgLsx6TPLzF1ngAZiGh2Gn0sDYZvtPLoXezmnYv+y7323KJDY/E4x6sGcMC7VhxI2Mt1NNPR9zA7tXX2QVEkoEP/xFeiI8rvCBHoV4xJejilmzLnePtDmfen9HiwU4pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820136; c=relaxed/simple;
	bh=ibRPVFXtxV12eMzYwOJTp18qbMLcnVNcvmSNgdLLPBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiqw6tbvJmtboVGQXUoTm3qROyeIasSN8OPQH/1MYmnopB8ivbCObic+iZvRok6w5B2OgCcxYIEkwZBsCfFrwFGCWR/zKY7/7n4RBpT6zYREaN8D9rVbxXOZ+RFPjvt6hItcjcNBvHK966aLiEJzrt2+we4mNTXxm33XbcqOtQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+ADRmoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+ADRmoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D9BC4CEED;
	Tue,  2 Sep 2025 13:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820136;
	bh=ibRPVFXtxV12eMzYwOJTp18qbMLcnVNcvmSNgdLLPBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+ADRmoG2SC4REv+blKDWdQjCBJZrw+rEFq6NaUqdF7Rwyo3yiDdYDG3rVPYwuQXT
	 5m83G9XNN7Y1W4mLw1cd7sHJCGelkqGTf9GS24A+D0HSvgEyzxg6uTAfawEiBtt9HJ
	 H7aWwsa3+QAsa3U1IB+i7XM8rITKOymd6sNaN1iE=
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
Subject: [PATCH 6.6 10/75] smb: client: fix race with concurrent opens in rename(2)
Date: Tue,  2 Sep 2025 15:20:22 +0200
Message-ID: <20250902131935.520307071@linuxfoundation.org>
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
index df01029918fd4..6c16c4f34d882 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2379,6 +2379,7 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
+	bool rehash = false;
 	unsigned int xid;
 	int rc, tmprc;
 	int retry_count = 0;
@@ -2394,6 +2395,17 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
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
@@ -2433,6 +2445,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 		}
 	}
 
+	if (!rc)
+		rehash = false;
 	/*
 	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
 	 */
@@ -2491,12 +2505,16 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
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



