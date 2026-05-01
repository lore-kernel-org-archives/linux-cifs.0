Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9083A6B83
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634436; cv=none; b=jLj1PUS0sEUMz5fKc0rNyqX77OGtEd3+e9ovhO+bFrwJQn7qQz28JIZdG9aOa5kDYDDOGAfnNbi4Ml7Fho9iNhzI4U5fuWZCVY3RKq8fJjcjpQ1jMA4RD4Go/V1uGh2FPddel6ynpnipNkN5Y6dnfasoKFDqmPt2LfPFPsDIMnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634436; c=relaxed/simple;
	bh=LwvNSAXXnSWzoHT3Wi0kz3QpPPutFGXNvtJ3F3liFfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PckPYoy0fM51+TxUObGA8QvW7gr+unlPaG1/JFZyOaTUlJPj8mGl9eR0UvY4HzyCbcEGiu+niDPm23nPHC2uJ3bh9njal3HPBCFut0K2j+U5nX5XIJXP3DT5FbuY2ZYhT0mkfMSWw0a139WHzzt1PfkLP8EKa9Q4BAwUhRYuIpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sQWFvU2p; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sQWFvU2p"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82f8b60e54dso1302867b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634433; x=1778239233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZRWgA5OmDOPPbc7jmvxeovxvP/jnc1UOCkDIWNmHkgQ=;
        b=sQWFvU2psz4r2lMyz69t4CeGPFUyCjKlSTMq4Int0RN//syyy3lw4JwO2RnvVjW4Wl
         +5mJSF7d2AgRgy+HV6EmsNaeaJP7nmC3tam20fRTTk0/08G3lHjyWq0/pCKSmHQ4Hf9k
         +WUBabu0SUFXTFVMdrp7ejYcdI763Ce9aCRyuAFo9/L2acF04NhbwtF7h4zHc9egItf0
         ZiVCum/2Af1rpdHgHfSubEcAq5Ac8p+nD8F40ZZfeey/p1yEMOFga2sl3GYLreISLnTI
         pjSDR1Eclsw12Tuw64xCao7oGGiiWWu/7f9O9GgsL+YHXv7v2Z36VerczQuQwNppL2na
         96nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634433; x=1778239233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZRWgA5OmDOPPbc7jmvxeovxvP/jnc1UOCkDIWNmHkgQ=;
        b=JG2Z5I1le38l8xDQMyEr8WG91BAnJKC6jYu0fCClP0Wt0e63Fmd/ot/sOhOTn/rE19
         pL/JnVs5RFdytjI5hSWwxF97cFWQE0WTcevrbxdQHMLoBhCFXHU3LXc5C7rtKmrBXLFm
         9rNk4BQ9L9Z70LTl+NRXFx4bq9UZR0+FPV0unNPmpT0g8Cn5Ag7AKlY31XZ4+SyTLWjU
         ywUAOo99Iuq3IBT9ELN9CpQgfWxTXQcQjizptDpOadXpDeF7Glwd8sk5l3TaWnd6+gty
         EYIBZSxBpc0Hc8iLp0p0mFWLpwfQ5j9RpJXaBeSP2qYD4SSsaEHF6cMgW9/UBqRcllJu
         xoqw==
X-Gm-Message-State: AOJu0Yw7kl8Yf1ih0LnpjiSwOYO7YghU5Dz8VZZsPBQjsMcMIF2q228Q
	Ekme2V0hl8GLTY/nmznjQ1eeX0IwF3y13G4A0P6TQ5gq5hVR4QB7kOqGlXJ3M0fsnC8=
X-Gm-Gg: AeBDieviw6sZt0ndG7l2KpErQaQSOAussE9Nhu1IaMiKM4WCfrfpDG0vhvfKX57fK1A
	Pepm/it0yayNCf0Cq+4Bm8HE/d9hXApuhafJKxHGK/GsThY/r52arjuzn9Jwov7rvJ3471QnV3J
	i6SI1L0IxbAep7LBM0erG2gF4VMbzeDnoB7tEMgD3roQxvBQ21KmctMIemRxR2UYY14d70kOzxd
	FDYnP8a85GUdK0Yovq18R9giDUtZxulZ2OzTcU/1Rp8wljcKWJITssdKcsltmglDiDM5wSp4Ch8
	gYAP/BwNYDRepLIgoO2HbkhrORdOf14rRn8W5TehapYBGKJ40Iw6eL1LcZ7bAAzMarPbwTZGams
	kWp9QmtWEz7yGAmbi5prOBA3g8xd2670DwBTRZy0QM+s7C+8GrR/yibyI9JxH2bzBUMm3RSrjuL
	9oMxRLtzJDMuQXuteYKFVx89AMToVj74djfdx1Sv20TUgk0fROz3342OOMqNXwc+oc
X-Received: by 2002:a05:6a00:1794:b0:823:1c5f:1c43 with SMTP id d2e1a72fcca58-8351a570ea0mr2916454b3a.36.1777634433437;
        Fri, 01 May 2026 04:20:33 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:32 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 03/19] cifs: invalidate cfid on unlink/rename/rmdir
Date: Fri,  1 May 2026 16:50:06 +0530
Message-ID: <20260501112023.338005-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501112023.338005-1-sprasad@microsoft.com>
References: <20260501112023.338005-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today we do not invalidate the cached_dirent or the entire
parent cfid when a dentry in a dir has been removed/moved.

This change invalidates the parent cfid so that we don't serve
directory contents from the cache.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/inode.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 888f9e35f14b8..f0b76670b0921 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -28,6 +28,23 @@
 #include "cached_dir.h"
 #include "reparse.h"
 
+static void cifs_invalidate_cached_dir(struct cifs_tcon *tcon,
+				       struct dentry *parent)
+{
+	struct cached_fid *parent_cfid = NULL;
+
+	if (!tcon || !parent)
+		return;
+
+	if (!open_cached_dir_by_dentry(tcon, parent, &parent_cfid)) {
+		mutex_lock(&parent_cfid->dirents.de_mutex);
+		parent_cfid->dirents.is_valid = false;
+		parent_cfid->dirents.is_failed = true;
+		mutex_unlock(&parent_cfid->dirents.de_mutex);
+		close_cached_dir(parent_cfid);
+	}
+}
+
 /*
  * Set parameters for the netfs library
  */
@@ -2067,6 +2084,9 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 		cifs_set_file_info(inode, attrs, xid, full_path, origattr);
 
 out_reval:
+	if (!rc && dentry->d_parent)
+		cifs_invalidate_cached_dir(tcon, dentry->d_parent);
+
 	if (inode) {
 		cifs_inode = CIFS_I(inode);
 		cifs_inode->time = 0;	/* will force revalidate to get info
@@ -2378,7 +2398,6 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 	}
 
 	rc = server->ops->rmdir(xid, tcon, full_path, cifs_sb);
-	cifs_put_tlink(tlink);
 
 	cifsInode = CIFS_I(d_inode(direntry));
 
@@ -2388,6 +2407,8 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 		i_size_write(d_inode(direntry), 0);
 		clear_nlink(d_inode(direntry));
 		spin_unlock(&d_inode(direntry)->i_lock);
+		if (direntry->d_parent)
+			cifs_invalidate_cached_dir(tcon, direntry->d_parent);
 	}
 
 	/* force revalidate to go get info when needed */
@@ -2402,6 +2423,7 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 
 	inode_set_ctime_current(d_inode(direntry));
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	cifs_put_tlink(tlink);
 
 rmdir_exit:
 	free_dentry_path(page);
@@ -2668,6 +2690,12 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	}
 
 	/* force revalidate to go get info when needed */
+	if (!rc) {
+		cifs_invalidate_cached_dir(tcon, source_dentry->d_parent);
+		if (target_dentry->d_parent != source_dentry->d_parent)
+			cifs_invalidate_cached_dir(tcon, target_dentry->d_parent);
+	}
+
 	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
 
 cifs_rename_exit:
-- 
2.43.0

