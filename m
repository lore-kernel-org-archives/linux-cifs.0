Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CE731AF17;
	Tue,  2 Sep 2025 13:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820457; cv=none; b=V7NNjb+VaEV9v4tSVqx/7AFGEFkP34DUIdtXRv/o7u9VrNhLwbsQvpzp1wfkWAuDdGk+6NCvjDrfYfm65odRaGRvCRb2LTe3s7jCrCWWtlsnGOtrBX0NWakiQYbvp8CymuWZh1Tdy39hvwmLNJK/by+DK9mZklIvPRu9fpV7Q4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820457; c=relaxed/simple;
	bh=tucydh6EBTEde6NuQSp6ACBXqPS3uIYqwnSapHBqS+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHAB7cDTLLCOUCgN/8HT30PkQ98EsFbmflASHPBGpeJZAX044oMoxi9rtI2CzCLIGRnvIgnIVyRuNTcXgSFcrx77I0jdzuRgdZhsTAzdpTNNP1RbUaReioYgA1jublRdLCV5BuGMKDBZqVgDfhpZDVbFxWvAs3Vtp4bLWXbRVCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEMFoFYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEMFoFYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FDAC4CEF5;
	Tue,  2 Sep 2025 13:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820457;
	bh=tucydh6EBTEde6NuQSp6ACBXqPS3uIYqwnSapHBqS+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEMFoFYaa2jJuQbwnNlRfPQ3JKwVhFsf4u30u996xm0AOSAm1iolGao5eA4XJD/76
	 0jMCiLQp/yT1MJX97GU/7O47xi2feDEoEaxKMUoM4/GZLFp8wZOpm8kzUSgvQG8d8I
	 A7148Bnq5AHmp6/KphQLID+L5TO3xl6iAEpxzL+E=
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
Subject: [PATCH 6.1 07/50] smb: client: fix race with concurrent opens in rename(2)
Date: Tue,  2 Sep 2025 15:20:58 +0200
Message-ID: <20250902131930.803959712@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ffc05ebc92f43..f3ed5134ecfa9 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2165,6 +2165,7 @@ cifs_rename2(struct user_namespace *mnt_userns, struct inode *source_dir,
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
+	bool rehash = false;
 	unsigned int xid;
 	int rc, tmprc;
 	int retry_count = 0;
@@ -2180,6 +2181,17 @@ cifs_rename2(struct user_namespace *mnt_userns, struct inode *source_dir,
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
@@ -2219,6 +2231,8 @@ cifs_rename2(struct user_namespace *mnt_userns, struct inode *source_dir,
 		}
 	}
 
+	if (!rc)
+		rehash = false;
 	/*
 	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
 	 */
@@ -2277,6 +2291,8 @@ cifs_rename2(struct user_namespace *mnt_userns, struct inode *source_dir,
 			goto cifs_rename_exit;
 		rc = cifs_do_rename(xid, source_dentry, from_name,
 				    target_dentry, to_name);
+		if (!rc)
+			rehash = false;
 	}
 
 	/* force revalidate to go get info when needed */
@@ -2286,6 +2302,8 @@ cifs_rename2(struct user_namespace *mnt_userns, struct inode *source_dir,
 		target_dir->i_mtime = current_time(source_dir);
 
 cifs_rename_exit:
+	if (rehash)
+		d_rehash(target_dentry);
 	kfree(info_buf_source);
 	free_dentry_path(page2);
 	free_dentry_path(page1);
-- 
2.50.1



