Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA570325704
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 18:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778782115; cv=none; b=L8yH0i2X6PqHvLCDhtOzm6o15REJnJR2OkLKDZVwat0Po9QOTyAs15fACGf24BwTaxvuxUtv0yKd8dovDNfXn/B+Vqbq4hHHr8c8NXDRAh0lS1YeTGv9+LL/tOmfAIOwdSwGKfwwiOi/O0OQIriC+fvrTEoV3szMS47OTSZY3Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778782115; c=relaxed/simple;
	bh=h960HNNe+V92ZvI6gP4RcHkyEzNtTuItTy+rZhYvONw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r9Yc8htX1vdxTq2FXG+bruhcg16tJ5Hk0/ESOV52bq8zORZM7IX/CxwWgSewlL+Xlyjq/h1KRznDHvDsKp7rtgvvsDp+kp9RUrxzbFOpvg4Df4gl3mk/DYOumW+RqZFzdCbrW2FXqXtSc7eY2ECgXXc7wVXBzpgeIp+mYvpB+Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i1B+JfYZ; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i1B+JfYZ"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-366070f71adso7636162a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 11:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778782113; x=1779386913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VfK6dWNOnCHbnZz/I7gFF8NkM/beIlUpgruzfOvGbLA=;
        b=i1B+JfYZPFT6jhx1TBIEHA00RotfcPsHOmW9w5moILxFkl8+vpe8IzUaFYMVIGY5Lw
         6Q+2PqxRuZEN0+T4mMVWg2d+en30wMMGuTzBQAsh/Z7Te9ZJCxnqaWZev4O/c5EUCG3g
         3Yb3fIfUeNi+/olQXjLyAl8g84fhMXB0zPf94pUtuB5iaOyI5bkOP5NHUhR3SJVkJCvb
         MiFelLwFZB19n4IXJjT8hGFSyZ+9Ua3hpnaW8nx6Rx5GXwP1KAwUqdfDic1JcgaC8Etq
         3z59zQuxazqcmcpWsvmG0FzWyqIy8pK16Hlpzz6aqmHdVCveG9SDNJdatF66Kb1J/PI+
         OA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778782113; x=1779386913;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VfK6dWNOnCHbnZz/I7gFF8NkM/beIlUpgruzfOvGbLA=;
        b=hiY9n13vTKXQOleUkGfd14//gAiAeut8giCWeYPnpKet0ksRdAQodpLZmtLPs58UrT
         k4DUmFMhzpQZwLs7uZQgpqIUjdvfArww5/PXMC/ukg+9hw9ZgmNowJ7k7KI5SA+hcln6
         Ec4ZnwFlYwhF5Uh4xxjImuMgWvaRFDDyrcyD5k7uGwnbbXxWfPxo+JdHLGAMf2/3LqFm
         TCjdu09XAD8wGYhPRAwyi/WWj63G60XnizPm12z6Q5xMu91+mAzIZT/7PLYb8V9Gr8W8
         GLrANNA/D24wC0UsVHzZKTGNRfxMl0J7+9MHeykshoC+biGpRmA1SI+ytRMEgJRu7KEE
         JI1Q==
X-Gm-Message-State: AOJu0YzSJp03W8BuqDuZfQdUFoaswXqKv7Wzf52/cFhbdPIAtJmFoR9a
	DywEdZm0TkwyH75cS9FzN8fAYpUXP4JlTCt7kmxeG4sJrAauPQKVTHV2Zc8FUvfC
X-Gm-Gg: Acq92OHQAih/Rnmj8xStBtCFonjlCls9BTWsV170I3bR7RkAWSf6jLJGws67rptC9Xb
	q3rPHWi5pFBqa0chvCo4wMFUy1QeRh+2k76fzV4F8MgNdSfSJQdt2xWEEz5D0Nwlx0gxLrpIWeI
	v2LAQYLoaEa0OUZqDl+LZ/WYd6eyWXcbh3LJ7YJS/eE3oCs6wr+S/zg3HnEmGSJByN1shG6N+8/
	evtTF57JTkPxn/df/VT0tNMdKEy8l3ost1XyJOHvad4lW+2qsyp3KyK3teTrmXluj72NqRGiC2w
	pA27LPXQD888Ia8v7TsYhq644WcotWGl3yp3H2Pl7CYPI/yzTF4A+8MJCgkawiqgy64dP8XiWyv
	f2cInOASIV+bdGE89vFHXYN2cp+cnLQOMJk/N25HomhWO5tp6mWMZWtkEXTX04CcUrVJi5cV8HD
	Ygm94ADjb+i9UTm4pkPP2FDlpj958uFflmumsLfb+oQzLCxrub8GMTPdhbIjAcuW+m
X-Received: by 2002:a17:90b:3dc4:b0:365:fca2:8bdd with SMTP id 98e67ed59e1d1-36951778509mr545563a91.0.1778782112950;
        Thu, 14 May 2026 11:08:32 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb121cd6sm3134589a12.30.2026.05.14.11.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 11:08:32 -0700 (PDT)
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
Subject: [PATCH v5 01/17] cifs: invalidate cfid on unlink/rename/rmdir
Date: Thu, 14 May 2026 23:38:07 +0530
Message-ID: <20260514180823.497293-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
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
index 16a5310155d5a..61f4b9ba2bd25 100644
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

