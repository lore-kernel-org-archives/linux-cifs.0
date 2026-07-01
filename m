Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056453E638E
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 08:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894361; cv=none; b=nVHwKodIEhopM+DTSrPrUz8x3jBXPtW+CHE5E6xhmq8UUPinCytd61ygil43/m+F7ofvEn39JN+j4slal21A9aLZxYr5a0ovjiiaoMjuUJdefQDc7jyh4gSmGMsodU96ArKY5bPJQTYoU2sQcxnu74laqOuxDsPS3XjIPBNRxBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894361; c=relaxed/simple;
	bh=crNKmDdI34a1+d5rIX5mRdO2DNcG/t9bVLDbclmtBiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ga+4MlQ+p9RiCZGo2J4hyuJp6xUT3+YBA88+rUoIyvMe4yrmHV2GdDJ3ccFV7UPM78dWoY6oncyLpgb2ud1CPJLGYskb4Y+ZtzoDjSqbp3dYk52TI7zVYjT/CHrYcFSG/BdB+GKrFMacr70hAWjNDW1aKqJz5kAUpDlIMC/iIXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=MQba/pTB; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="MQba/pTB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782894355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WAQ77xbANCtMHYB3w+lYPo4DBzUx5LOGgdRCl1EasLY=;
	b=MQba/pTB9sKMNWRrjdkg/KlfLAIcJIB6VYBag+AmysDyCGFv+LeJaRA6GpD5MsRD+jLQlL
	LXl2iKgWqEd2KfMpzayu2GmPc/pCCRO2aN21KlJzgWhW3IIvrPOlnOHdb682WsKuh61j0W
	sCNHJPt+YXgye1e8DN7sqYLjovaDW85xjPis8/iCpI/wyps2pBSojU6dex4k8tkNkg4F4H
	yiSxrc+rWSREU5CCoXpm3eUg/AnSXS1rHCzXKdF+vu3+cvP4uqtpNse7sGWrXgMLl7CZN9
	4diN94XhmvElL1Q8Yj6WPtRB4pwyGCFgjRQwfmWA4qZ+on0d7+mbmoHIwmcL/g==
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
Subject: [PATCH 3/9] smb/client: prepare notify ioctl per-open state
Date: Wed,  1 Jul 2026 08:25:01 +0000
Message-ID: <20260701082507.786487-4-chenxiaosong@chenxiaosong.com>
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

This patch was split out to make it easier to review.

Ensure smb3_notify() has directory private data before requests.
This gives later changes a per-open state container while preserving
the existing per-notify SMB2_open/SMB2_close behavior.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 06e9322a762a..349126deb22e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2376,9 +2376,11 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 	struct dentry *dentry = pfile->f_path.dentry;
 	struct inode *inode = file_inode(pfile);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifsFileInfo *cfile;
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 	struct cifs_tcon *tcon;
+	struct tcon_link *tlink;
 	const unsigned char *path;
 	char *returned_ioctl_info = NULL;
 	void *page = alloc_dentry_path();
@@ -2412,6 +2414,20 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 		notify.data_len = 0;
 	}
 
+	if (!pfile->private_data) {
+		tlink = cifs_sb_tlink(cifs_sb);
+		if (IS_ERR(tlink)) {
+			rc = PTR_ERR(tlink);
+			goto notify_exit;
+		}
+		cfile = cifs_new_dir_fileinfo(pfile, tlink);
+		cifs_put_tlink(tlink);
+		if (!cfile) {
+			rc = -ENOMEM;
+			goto notify_exit;
+		}
+	}
+
 	tcon = cifs_sb_master_tcon(cifs_sb);
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
-- 
2.54.0

