Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00D3126C03
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 08:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894374; cv=none; b=Pgrc2rc0dQWGkb4C6bBZ0aTjnr42bPN7QwsZjP+urUesJOQk4cT6vuTUSLWQL1UdwfzW/aV1RYuhklITWM/tWSTt6S3eb/3j6G6kQQiFhXu5yD1aLxdY0pCtNghGjgpqE+8z1bfRBk/xyuPwBsopg7L5vqtTizB+7uyiBp52M9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894374; c=relaxed/simple;
	bh=Mw93psn+gTc7si0ZS0IXT24Rts7EugAk1xR+hkymSqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUG8N/M27aZVudiVfmlQtElwI5I+MhKOW5n35v6AXgHWcYJZie5y46PfjAO3UePcN6b5E1+7dcY4nEA2k7HKiBRWvGRGJjfYsBt41LvbVMsCDEc99SgrsNHpAs70MTq4Qz0XcEoTJTZqP0GfdEMwKrpFkKLMBOe2btMMZDbM4Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=G2KdqOqG; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="G2KdqOqG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782894369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M577sGPCPTBiJBpbJOVSv8tpv8svpJEp0RWDB3K32XA=;
	b=G2KdqOqGtQ/Vc3P4jZd89jpIh1pvuC4QeK7aG9T+OEK6lQELeFn+H+NTef8qDAjmNIgFDb
	oQNcwG8PL/ecTSneEL5h4dEwKd37G0gtSBwdU0HN4gxzMkORUMbsO3X2CSV/iWc+/fcPj+
	plIDCNeJ7H9vsEJHdE1+gRSpetQtp0aPtrNficwxhaoqytE/sZQqZCWvU6MqzeoAN6g5wN
	OAz+QZgmr9kmHT7l1ogmnu285e2DT2eyNuarB3ITf5j1vAEznhnyJj9j3UiJPtQxOUjL2w
	8sQzbeSRW/tTGGsWO0r1abG/9/0mXAy3LxMZTbGTFTju8uIpKRARlPxCXSPiQw==
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
Subject: [PATCH 5/9] smb/client: retry change notify after invalid cached handle
Date: Wed,  1 Jul 2026 08:25:03 +0000
Message-ID: <20260701082507.786487-6-chenxiaosong@chenxiaosong.com>
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

The notify ioctl caches a separate FID in cifsFileInfo. That
handle is not reopened by cifs_reopen_file(), so it can become
stale across reconnects. If the server returns STATUS_INVALID_HANDLE
for the cached FID, SMB2_change_notify() maps it to -EBADF, but
smb3_notify() kept reusing the bad handle.

Invalidate the cached notify FID on -EBADF and retry once so the
next attempt opens a fresh handle. Clear only if the cached FID
still matches the failed one to avoid racing with another thread
that reopened it.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d6a33acc62ff..9c2455b5fb03 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2365,7 +2365,21 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-
+static void
+smb3_notify_invalidate_fid(struct cifsFileInfo *cfile,
+			   const struct cifs_fid *fid)
+{
+	mutex_lock(&cfile->notify_fid_mutex);
+	if (cfile->has_notify_fid &&
+	    cfile->notify_fid.persistent_fid == fid->persistent_fid &&
+	    cfile->notify_fid.volatile_fid == fid->volatile_fid) {
+		cfile->has_notify_fid = false;
+		memset(&cfile->notify_fid, 0, sizeof(cfile->notify_fid));
+		cifs_put_tlink(cfile->notify_tlink);
+		cfile->notify_tlink = NULL;
+	}
+	mutex_unlock(&cfile->notify_fid_mutex);
+}
 
 static int
 smb3_notify(const unsigned int xid, struct file *pfile,
@@ -2388,6 +2402,7 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	int rc = 0;
 	__u32 ret_len = 0;
+	bool retry = false;
 
 	if (return_changes) {
 		if (copy_from_user(&notify, ioc_buf, sizeof(struct smb3_notify_info))) {
@@ -2418,6 +2433,7 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 		cfile = pfile->private_data;
 	}
 
+retry_notify:
 	mutex_lock(&cfile->notify_fid_mutex);
 	if (!cfile->has_notify_fid) {
 		page = alloc_dentry_path();
@@ -2468,7 +2484,23 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 	rc = SMB2_change_notify(xid, tcon, fid.persistent_fid, fid.volatile_fid,
 				notify.watch_tree, notify.completion_filter,
 				notify.data_len, &returned_ioctl_info, &ret_len);
-
+	if (rc == -EBADF) {
+		smb3_notify_invalidate_fid(cfile, &fid);
+		if (retry)
+			goto notify_done;
+
+		kfree(returned_ioctl_info);
+		returned_ioctl_info = NULL;
+		free_dentry_path(page);
+		page = NULL;
+		kfree(utf16_path);
+		utf16_path = NULL;
+		ret_len = 0;
+		retry = true;
+		goto retry_notify;
+	}
+
+notify_done:
 	cifs_dbg(FYI, "change notify for %pd rc %d\n", dentry, rc);
 	if (return_changes && (ret_len > 0) && (notify.data_len > 0)) {
 		if (ret_len > notify.data_len)
-- 
2.54.0

