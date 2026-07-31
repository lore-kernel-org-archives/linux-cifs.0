Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486F23DC4D8
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 11:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498671; cv=none; b=i86sSB06Dfg/m/Eb6PRjr8WbXQyOP+SyH7frTtDrrAw9bFIy+3JwVKz7UhSD9nLTM0b2d3iIxeOn9AbMJal7QC3H4AGt5kOQjAB0V4Anu8X7gHm4q9jvef9+c6z/kR0Og7jkKOmVuPdJe4Cool1TFw97kabuULPApNIIq2J0sXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498671; c=relaxed/simple;
	bh=IZ2GY8cMjnonc+q7/BR+ifMDQj9y7aknakfmtJkDOXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMCFqBAoqOwO3GIA5W4KzimK+0aICNaP9Fn1+nWCcG4GOeXfvTdzsasCdEmjAP0DvFBpQRGgpIZlnZ7rkhrL+2/a+RJmFVd6+J8jGODR/yQankTsSZIKYEXahuj7rcuwvKoHAzbTMi+S31VAGguqtOwJZypQ1X+0WBE5l0rHO24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T9qK7JHq; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T9qK7JHq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785498667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lEvu20osSNVC/HUonndrfi9Z97OYKtV2tLowT4byPwE=;
	b=T9qK7JHquoZRSH+rMnHJFpwxZvbDRnSw4m68hoW33agBM0RJ0YAYHjTRg9DuKpfRmJWNwT
	6/VWeqyn1yMaGiBDlZmeNqUNTtQ75mx7z6eOWaC/76d+S4kuNwdjg3seoQ+1wgewSVOCTW
	PoFEWdK7ZfeX7Fe2dy4lWP4LE6D79mU=
From: ZhangGuoDong <zhang.guodong@linux.dev>
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
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 2/6] smb/server: fix memory leak in ksmbd_vfs_set_durable_owner()
Date: Fri, 31 Jul 2026 11:50:04 +0000
Message-ID: <20260731115008.111211-3-zhang.guodong@linux.dev>
In-Reply-To: <20260731115008.111211-1-zhang.guodong@linux.dev>
References: <20260731115008.111211-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

See the procedure below:

  smb2_open
    ksmbd_vfs_set_durable_owner
      fp->owner.name = name

  // When the connection goes away
  ksmbd_sessions_deregister
    ksmbd_session_destroy
      ksmbd_destroy_file_table
        __close_file_table_ids
          session_fd_check // skip()
            ksmbd_vfs_set_durable_owner
              fp->owner.name = name // memory leak

Fixes: 0726814421c2 ("ksmbd: add SMB3 request replay support")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/vfs_cache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index c28e3d65d64b..5acd06020d42 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1655,7 +1655,7 @@ void ksmbd_stop_durable_scavenger(void)
 int ksmbd_vfs_set_durable_owner(struct ksmbd_file *fp,
 				struct ksmbd_user *user)
 {
-	char *name;
+	char *name, *old_name;
 
 	if (!user)
 		return -EINVAL;
@@ -1666,10 +1666,12 @@ int ksmbd_vfs_set_durable_owner(struct ksmbd_file *fp,
 		return -ENOMEM;
 
 	spin_lock(&fp->f_lock);
+	old_name = fp->owner.name;
 	fp->owner.uid = user->uid;
 	fp->owner.gid = user->gid;
 	fp->owner.name = name;
 	spin_unlock(&fp->f_lock);
+	kfree(old_name);
 
 	return 0;
 }
-- 
2.54.0

