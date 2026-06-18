Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7C32D738F
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 17:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781802188; cv=none; b=DruO0B7o08Jke5hLF8HZ2SysSDd2G/tIFErbERpYA45VJffgcMyfLk/g7G6vkHAe6zM539Zadg75xJzRYkcEDw5lEJZ0bAvj37mLsj5oyg/xXGRc04T/jwLpDf3PzNrZnhf+Q53Eoh++beqiAu9ALbVP8pJLSOXQMXmZIYOXaj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781802188; c=relaxed/simple;
	bh=d46mM8jv7QdxAzH3t6lWgaQWjhLFT5efV5kE8L5HdoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PU9Bf/IEO7rqELyha7hnEwhOE0ROGpN0LMEtcKkvfs/N0PoC1i0zjqrHKsRm7yRnLNMhpuBVUbIbA3CtG1wUlaRxTkSjX7jZVlEkrsJZTtRC/9nnXhdRudG+g0kSbJC80GObTQSkegs7fYUwweSwOF99IqB5h0hizdl+Yjmbujg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=D3ek8xWE; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="D3ek8xWE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1781802183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Oe2qpOdtMUsjX6L40Ow0AZW2jBHWKVqS4bHIyPz1mg=;
	b=D3ek8xWE0Frm08dga8XYbRE2oTVg+agiVRVIqFlh3MoK2NDSbn7xYWdBEhyxCR4m6HwY3y
	WIhuzwDP9KEBSwWombn3Qoqduo87N9www4i4CTRGHnaqlhmg03VXNfAdNCs5p5zmhx9Dyb
	wprPXPnacVjDI4H1QsMkJ91pkw5wADxwu1cnqNWk2hHs/+CWdJc/K/QAZlhNQG0tnrWb4F
	BMoc2qjYBT81WgnmIMUkVjtuFamc1GyWv1Vk2klhk01tgdPKQk7HLEf407/17I8bN4pIFN
	lQr7ehx7PLDdGEtYVaEBtFvfajLK4niAwBmwc/A0itaHajmBV/lsC0mfgU2C3Q==
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
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH 1/2] smb/client: introduce smb3_notify_open()
Date: Thu, 18 Jun 2026 17:02:01 +0000
Message-ID: <20260618170202.244402-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260618170202.244402-1-chenxiaosong@chenxiaosong.com>
References: <20260618170202.244402-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Introduce this helper function to reduce the diff in the next patch and
make the actual changes easier to review. No functional changes.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 71 ++++++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 26 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a8f8feeeccb5..b50d3b8a9252 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2364,7 +2364,50 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static int
+smb3_notify_open(const unsigned int xid, struct dentry *dentry,
+		 struct cifs_sb_info *cifs_sb, void *page,
+		 struct cifs_fid *fid, const unsigned char **pathp,
+		 __le16 **utf16_pathp, struct cifs_tcon **tconp)
+{
+	struct cifs_tcon *tcon;
+	const unsigned char *path;
+	__le16 *utf16_path = NULL;
+	struct cifs_open_parms oparms;
+	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+	int rc;
+
+	path = build_path_from_dentry(dentry, page);
+	if (IS_ERR(path)) {
+		rc = PTR_ERR(path);
+		goto out;
+	}
+	*pathp = path;
+
+	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+	if (utf16_path == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	*utf16_pathp = utf16_path;
+
+	tcon = cifs_sb_master_tcon(cifs_sb);
+	*tconp = tcon;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.path = path,
+		.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = fid,
+	};
+
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL, NULL,
+		       NULL);
 
+out:
+	return rc;
+}
 
 static int
 smb3_notify(const unsigned int xid, struct file *pfile,
@@ -2375,29 +2418,15 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 	struct dentry *dentry = pfile->f_path.dentry;
 	struct inode *inode = file_inode(pfile);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 	struct cifs_tcon *tcon;
 	const unsigned char *path;
 	char *returned_ioctl_info = NULL;
 	void *page = alloc_dentry_path();
 	__le16 *utf16_path = NULL;
-	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
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
@@ -2411,18 +2440,8 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 		notify.data_len = 0;
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
-
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL, NULL,
-		       NULL);
+	rc = smb3_notify_open(xid, dentry, cifs_sb, page, &fid,
+			      &path, &utf16_path, &tcon);
 	if (rc)
 		goto notify_exit;
 
-- 
2.54.0

