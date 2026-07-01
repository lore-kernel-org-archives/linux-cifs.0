Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2619338E5D4
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 08:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894365; cv=none; b=g764Kwv/DgpLRr7Z0a/JPWddKrczk/xhmux2DNYotgJvuxhgCZ5RXXQ0rCXRNHXifPimwfdcJAsCLt3tSP0C6UVNwcc/ZI/8LhWTuBiJUKxcRZuSuN6Aua6qJftIvhaxpez/RxIlcueeMq+pZG7cMqRJCzADfvylI6j9xcLXDX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894365; c=relaxed/simple;
	bh=jMBdXY3nk7zLQtFWpj9gHKFS/ByA/ewKbcZv6SrfFww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0ItKkYkMQP/pmofEYki1bBxot2lhZ8fgHdEjStZuwk/Pgg7zwcbZ/3DUzy3kFNP1i6CgnpuvM3gm1//wD8Os/L+Xuc/KwTqm8TUknem5lqpN7hejfHM8foncqxuucY+TKT0NHF4JYqUgPb4ZbuCWD+kZmhI2G+fQc3MYdRZkzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=ast1KRRk; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="ast1KRRk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782894361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AD2ag3LzZ1qgZr2R2SXsvGxqXq5J6AmPPmJjX2RH9bE=;
	b=ast1KRRkh1pvr1Aimoefxy8Rna9u+Cd4bkvG2Gy9qmJhCdEwVgZLVCfFmH44hFgvdLcRsF
	kq6SR/KSOB/BUdQrByhcCCeb4zQD8fYc3mQkkzrSDZeBOo5MyKf6x+b3n+SO2JVXIo73XI
	Eo/5mdSULTLXJqhcy6/+1h5P+2+moyGrd7o9obS2w2+PUpCq7gw+7Rxefv83KYPbm7/Nmd
	Yds65Zamr2vpV/H/dJvtvsAPzjZ/xUlf7binHbEvU7jM1+wI5Nxuvrh9BZxZ5u4MG4f8i/
	aHTho+VB3LGnN3PkpaQp/BbdDUPEWJWhtDQBOOv8a+g2KRiOFWRRL/MXYhg70Q==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 4/9] smb/client: cache SMB3 change notify handles
Date: Wed,  1 Jul 2026 08:25:02 +0000
Message-ID: <20260701082507.786487-5-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
References: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Keep the SMB3 change-notify FID in the per-open cifsFileInfo state.
Subsequent notify calls reuse the saved FID and the handle is closed
later from the directory release path.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 82 +++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 31 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 349126deb22e..d6a33acc62ff 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2378,29 +2378,17 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsFileInfo *cfile;
 	struct cifs_open_parms oparms;
-	struct cifs_fid fid;
-	struct cifs_tcon *tcon;
-	struct tcon_link *tlink;
+	struct cifs_fid fid = {};
+	struct cifs_tcon *tcon = NULL;
+	struct tcon_link *tlink = NULL;
 	const unsigned char *path;
 	char *returned_ioctl_info = NULL;
-	void *page = alloc_dentry_path();
+	void *page = NULL;
 	__le16 *utf16_path = NULL;
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	int rc = 0;
 	__u32 ret_len = 0;
 
-	path = build_path_from_dentry(dentry, page);
-	if (IS_ERR(path)) {
-		rc = PTR_ERR(path);
-		goto notify_exit;
-	}
-
-	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
-	if (utf16_path == NULL) {
-		rc = -ENOMEM;
-		goto notify_exit;
-	}
-
 	if (return_changes) {
 		if (copy_from_user(&notify, ioc_buf, sizeof(struct smb3_notify_info))) {
 			rc = -EFAULT;
@@ -2426,20 +2414,54 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 			rc = -ENOMEM;
 			goto notify_exit;
 		}
+	} else {
+		cfile = pfile->private_data;
 	}
 
-	tcon = cifs_sb_master_tcon(cifs_sb);
-	oparms = (struct cifs_open_parms) {
-		.tcon = tcon,
-		.path = path,
-		.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA,
-		.disposition = FILE_OPEN,
-		.create_options = cifs_create_options(cifs_sb, 0),
-		.fid = &fid,
-	};
+	mutex_lock(&cfile->notify_fid_mutex);
+	if (!cfile->has_notify_fid) {
+		page = alloc_dentry_path();
+		path = build_path_from_dentry(dentry, page);
+		if (IS_ERR(path)) {
+			rc = PTR_ERR(path);
+			goto notify_unlock;
+		}
 
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL, NULL,
-		       NULL);
+		utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+		if (!utf16_path) {
+			rc = -ENOMEM;
+			goto notify_unlock;
+		}
+
+		cfile->notify_tlink = cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
+		if (IS_ERR_OR_NULL(cfile->notify_tlink)) {
+			rc = cfile->notify_tlink ? PTR_ERR(cfile->notify_tlink) : -EIO;
+			cfile->notify_tlink = NULL;
+			goto notify_unlock;
+		}
+		tcon = tlink_tcon(cfile->notify_tlink);
+		oparms = (struct cifs_open_parms) {
+			.tcon = tcon,
+			.path = path,
+			.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA,
+			.disposition = FILE_OPEN,
+			.create_options = cifs_create_options(cifs_sb, 0),
+			.fid = &cfile->notify_fid,
+		};
+
+		rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL, NULL,
+			       NULL);
+		if (rc) {
+			cifs_put_tlink(cfile->notify_tlink);
+			cfile->notify_tlink = NULL;
+			goto notify_unlock;
+		}
+		cfile->has_notify_fid = true;
+	}
+	fid = cfile->notify_fid;
+	tcon = tlink_tcon(cfile->notify_tlink);
+notify_unlock:
+	mutex_unlock(&cfile->notify_fid_mutex);
 	if (rc)
 		goto notify_exit;
 
@@ -2447,9 +2469,7 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 				notify.watch_tree, notify.completion_filter,
 				notify.data_len, &returned_ioctl_info, &ret_len);
 
-	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
-
-	cifs_dbg(FYI, "change notify for path %s rc %d\n", path, rc);
+	cifs_dbg(FYI, "change notify for %pd rc %d\n", dentry, rc);
 	if (return_changes && (ret_len > 0) && (notify.data_len > 0)) {
 		if (ret_len > notify.data_len)
 			ret_len = notify.data_len;
@@ -2459,8 +2479,8 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 		else if (copy_to_user(&pnotify_buf->data_len, &ret_len, sizeof(ret_len)))
 			rc = -EFAULT;
 	}
-	kfree(returned_ioctl_info);
 notify_exit:
+	kfree(returned_ioctl_info);
 	free_dentry_path(page);
 	kfree(utf16_path);
 	return rc;
-- 
2.54.0

