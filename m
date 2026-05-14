Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7EF325704
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 18:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778782128; cv=none; b=TV2UtS9Xs6jfq4dl0RjLRm7gqlDySrrQXtTfDRpKfYqc3iglSS9QrBXldjtothn8mZ19qxAIHt2bpNpwqtdrcAg7arm6c28pa4AzvQbBuD3qUPlI2va2eGbEgXA/i1yfZyzxFVGTtMD5GuU5iM9HvvPg+M2GgD2B3du4u4oDPbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778782128; c=relaxed/simple;
	bh=fEvzWYtNR2VW819ocfB5FQh+/vGVIcCc+oe408Wcjn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lrm9zjOXQ15B+Njuewtf6levno/sFl16hTBpjovYvz9vUv4qvi9Y0s3wG4yo4wheCs82PnfChJsl1vqkNRJPFa5Kyn1mAhH1N8Db4OWLsT6a4uUfZGOt6mPdweKGpZ+mGdPZIeVanIJScIxFB3sSA4EuD6QrShfgLNiFMC5TsVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cEMuZZhD; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cEMuZZhD"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c8095d7d75bso3554883a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 11:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778782126; x=1779386926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nNLyoygP01o7n1GyVBV5p+FvXywd2FnnNH07C01ValI=;
        b=cEMuZZhD1QdlFuNDE3mMDcr/8e0VsX18nImJ/694CslCrQbojIFa10z+vpFw+vsyu+
         VwR/6Khh3kqdEnBjEzuvPwjj1U7roZW8OKO1i6vPYcftUYwYA6z19rP/ivNdj8Y01RuL
         +zDQPRrhMC8hClb573hGUpMEHg5IIrRVyG8imqCn/bt3a5EekBGc2F6/FsR4KTjuZiei
         Hwqnx9ijwH4f4KfYSJcMvI1AuuRC8s/UeddSBIG6/jhUnnkNs+V9ImtrW6fmGdNzBIsw
         6JrJURNgd9gkv/VpfCoH77Zx7RshSjQnj6LiOIWREgLOY5GuFJz2zgkvRiYdu9tD+XJj
         nYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778782126; x=1779386926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nNLyoygP01o7n1GyVBV5p+FvXywd2FnnNH07C01ValI=;
        b=hdp1ZQi5WA5z+mXq8WWQI8VBUP2uLv2r+OhFm28EXofvVp0OWvTUiQOVtMzm9w37Op
         nguuiREoizDhUk88OiyRWwqlFt3ib9dd8JLweF9nwKQKWquZjmr0o8S2LU9uAkFD+FbO
         faWcp4X/da/4yfFn4doppFgVZmFhengrLdQYoXXhNlHRdTe45SijF+ARKgmcTZRnw2Ow
         jxdGgL6MS94KTFQe83r9+MVWgF/0KCIYI4R4mMO59lU8Se27ZUaWoiXrf9wXBDK4+2e6
         4obDpCqQkob0c6mUlPgBCWR849qa31XeCsqACu3rj96srjhNTS7PbdaFghEavD3p7r24
         1DHg==
X-Gm-Message-State: AOJu0YwEAOheaJKvG2v/BiDzLACfb3Tt3iL+vSvClNodNE/TRRY0K7bL
	AJjGRBX1XUmgQhzYR7qgKqdVOKagp9y7r2SRLO1PWWT9AygxADqd7GH0HRRy57u5hhk=
X-Gm-Gg: Acq92OGrNwg5EUF9Q2V89CA7XuScGYxEunuuEOe1TtQewGkuMmOBamO+WPgQxlv7ZiU
	hl1qE4WQXDcqKA2uPtQORx3ENwlkF1J5jNLUwYwjSALthZa0tSg5AG0FWP6Z3aGVSpfsSCnsdjs
	h07ZIpki3csdCV8fjEObTYW96Ic32A3xBH6TznlHSShrZqOuxqgG6OyEI/JVmjt2UbS3aR+2CAA
	5H/7ZOmv36cLFYGg8gG/AikX8n0lsd4AzO+upxLqxdO4r2/Ur97eH5H5cNYkmvIGPPpWLlbhbma
	GPjh7R8WJa5dnHhndwYVoNiU1BqLIY0PsS/WhB4cCpnh0+1XTGRP7XjhtXoF2QVELONC85wNQ63
	dAgDwTxLL9AuNAoHlVA+S2VlXq0psZ7SqyufZ2gSY8zF52tYLJsfOgWcbooCc9wmEbD7AewAaEE
	TiVe3lVM7BgvxStANAA9ffaAIU/X3h8JIYdeK9Nv7dJAOo3HaCSu4uEa8N2Uw3A6Qg
X-Received: by 2002:a05:6a20:e293:b0:3a2:d989:2b3a with SMTP id adf61e73a8af0-3b22eba1aaemr336135637.20.1778782125624;
        Thu, 14 May 2026 11:08:45 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb121cd6sm3134589a12.30.2026.05.14.11.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 11:08:45 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v5 13/17] cifs: allow dcache population to happen asynchronously
Date: Thu, 14 May 2026 23:38:19 +0530
Message-ID: <20260514180823.497293-13-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260514180823.497293-1-sprasad@microsoft.com>
References: <20260514180823.497293-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today cifs_readdir populates the dcache inline whenever it
emits dentries. This introduces a perf bottleneck in
readdir performance.

This change attempts to make dcache population asynchronous
and parallel by doing this inside workers. It introduces a new
flag that lets reval and lookup wait for dentry population instead.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifs_fs_sb.h |  1 +
 fs/smb/client/cifsfs.c     | 22 +++++++++-
 fs/smb/client/cifsglob.h   |  2 +
 fs/smb/client/readdir.c    | 88 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifs_fs_sb.h b/fs/smb/client/cifs_fs_sb.h
index 84e7e366b0ff4..0efc1483f3ab4 100644
--- a/fs/smb/client/cifs_fs_sb.h
+++ b/fs/smb/client/cifs_fs_sb.h
@@ -71,5 +71,6 @@ struct cifs_sb_info {
 	 * Available once the mount has completed.
 	 */
 	struct dentry *root;
+	bool sb_dying:1;  /* superblock is being destroyed, skip dcache ops */
 };
 #endif				/* _CIFS_FS_SB_H */
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index f6dff13d9906d..a8f452423e401 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -69,6 +69,7 @@ bool disable_legacy_dialects; /* false by default */
 bool enable_gcm_256 = true;
 bool require_gcm_256; /* false by default */
 bool enable_negotiate_signing; /* false by default */
+bool dcache_populate_async; /* false by default */
 unsigned int global_secflags = CIFSSEC_DEF;
 /* unsigned int ntlmv2_support = 0; */
 
@@ -233,6 +234,9 @@ MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. D
 module_param(enable_negotiate_signing, bool, 0644);
 MODULE_PARM_DESC(enable_negotiate_signing, "Enable negotiating packet signing algorithm with server. Default: n/N/0");
 
+module_param(dcache_populate_async, bool, 0644);
+MODULE_PARM_DESC(dcache_populate_async, "Enable asynchronous dcache population during readdir to improve performance on large directories. Default: n/N/0");
+
 module_param(disable_legacy_dialects, bool, 0644);
 MODULE_PARM_DESC(disable_legacy_dialects, "To improve security it may be "
 				  "helpful to restrict the ability to "
@@ -387,6 +391,11 @@ static void cifs_kill_sb(struct super_block *sb)
 	 * and close all deferred file handles before we kill the sb.
 	 */
 	if (cifs_sb->root) {
+		/* Mark superblock as dying to skip expensive dcache ops in flight */
+		cifs_sb->sb_dying = true;
+		/* Wait for dcache work to complete and clean up */
+		flush_workqueue(cifs_dcache_wq);
+
 		close_all_cached_dirs(cifs_sb);
 		cifs_close_all_deferred_files_sb(cifs_sb);
 
@@ -2081,9 +2090,17 @@ init_cifs(void)
 		goto out_destroy_serverclose_wq;
 	}
 
+	/* WQ_UNBOUND allows dcache work to run on any CPU for parallelism */
+	cifs_dcache_wq = alloc_workqueue("cifs_dcache",
+					 WQ_UNBOUND | WQ_FREEZABLE, 0);
+	if (!cifs_dcache_wq) {
+		rc = -ENOMEM;
+		goto out_destroy_cfid_put_wq;
+	}
+
 	rc = cifs_init_inodecache();
 	if (rc)
-		goto out_destroy_cfid_put_wq;
+		goto out_destroy_dcache_wq;
 
 	rc = cifs_init_netfs();
 	if (rc)
@@ -2163,6 +2180,8 @@ init_cifs(void)
 	cifs_destroy_netfs();
 out_destroy_inodecache:
 	cifs_destroy_inodecache();
+out_destroy_dcache_wq:
+	destroy_workqueue(cifs_dcache_wq);
 out_destroy_cfid_put_wq:
 	destroy_workqueue(cfid_put_wq);
 out_destroy_serverclose_wq:
@@ -2211,6 +2230,7 @@ exit_cifs(void)
 	destroy_workqueue(fileinfo_put_wq);
 	destroy_workqueue(serverclose_wq);
 	destroy_workqueue(cfid_put_wq);
+	destroy_workqueue(cifs_dcache_wq);
 	destroy_workqueue(cifsiod_wq);
 	cifs_proc_clean();
 }
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index ecd9ca611a7f8..0d3d2fcf7d9a4 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2141,6 +2141,7 @@ extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
 extern bool enable_gcm_256; /* allow optional negotiate of strongest signing (aes-gcm-256) */
 extern bool require_gcm_256; /* require use of strongest signing (aes-gcm-256) */
 extern bool enable_negotiate_signing; /* request use of faster (GMAC) signing if available */
+extern bool dcache_populate_async; /* enable async dcache population during readdir */
 extern bool linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
 extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
 extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
@@ -2162,6 +2163,7 @@ extern struct workqueue_struct *cifsoplockd_wq;
 extern struct workqueue_struct *deferredclose_wq;
 extern struct workqueue_struct *serverclose_wq;
 extern struct workqueue_struct *cfid_put_wq;
+extern struct workqueue_struct *cifs_dcache_wq;
 extern __u32 cifs_lock_secret;
 
 extern mempool_t *cifs_sm_req_poolp;
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index ef81fdb503c0a..a1202a82be4e8 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
+#include <linux/workqueue.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_unicode.h"
@@ -24,6 +25,19 @@
 #include "cached_dir.h"
 #include "reparse.h"
 
+/* Workqueue for async dcache population */
+struct workqueue_struct *cifs_dcache_wq;
+
+/* Work item for async dcache population */
+struct cifs_dcache_work {
+	struct work_struct work;
+	struct dentry *parent;		/* dget() reference to parent dir */
+	char *name;			/* kstrdup() copy of filename */
+	unsigned int namelen;
+	struct cifs_fattr fattr;	/* Copy of attributes */
+	struct cached_fid *cfid;	/* ref-counted cfid for cifs_complete_pending_dcache */
+};
+
 /*
  * To be safe - for UCS to UTF-8 with strings loaded with the rare long
  * characters alloc more to account for such multibyte target UTF-8
@@ -171,6 +185,65 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 	dput(dentry);
 }
 
+/*
+ * Async dcache population work handler.
+ * Delegates to cifs_prime_dcache then signals completion to unblock waiters.
+ */
+static void cifs_dcache_work_handler(struct work_struct *work)
+{
+	struct cifs_dcache_work *dcache_work =
+		container_of(work, struct cifs_dcache_work, work);
+	struct qstr name = QSTR_INIT(dcache_work->name, dcache_work->namelen);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dcache_work->parent->d_sb);
+
+	cifs_dbg(FYI, "%s: async dcache for %s\n", __func__, name.name);
+
+	/* Skip expensive dcache operations if superblock is being torn down */
+	if (!cifs_sb->sb_dying) {
+		cifs_prime_dcache(dcache_work->parent, &name, &dcache_work->fattr);
+		cifs_complete_pending_dcache(dcache_work->cfid, dcache_work->name,
+					     dcache_work->namelen);
+	}
+	close_cached_dir(dcache_work->cfid);
+	dput(dcache_work->parent);
+	kfree(dcache_work->name);
+	kfree(dcache_work);
+}
+
+/*
+ * Queue async dcache population work.
+ * Returns true if work was queued, false if sync fallback needed.
+ */
+static bool cifs_queue_dcache_work(struct dentry *parent, const char *name,
+				    unsigned int namelen, struct cifs_fattr *fattr,
+				    struct cached_fid *cfid)
+{
+	struct cifs_dcache_work *work;
+
+	if (!cfid)
+		return false;
+
+	work = kzalloc(sizeof(*work), GFP_KERNEL);
+	if (!work)
+		return false;
+
+	work->name = kstrndup(name, namelen, GFP_KERNEL);
+	if (!work->name) {
+		kfree(work);
+		return false;
+	}
+
+	work->parent = dget(parent);
+	work->namelen = namelen;
+	memcpy(&work->fattr, fattr, sizeof(work->fattr));
+	kref_get(&cfid->refcount);
+	work->cfid = cfid;
+
+	INIT_WORK(&work->work, cifs_dcache_work_handler);
+	queue_work(cifs_dcache_wq, &work->work);
+	return true;
+}
+
 static void
 cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 {
@@ -923,8 +996,19 @@ static int cifs_filldir(char *find_entry, struct file *file,
 		 */
 		fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
 
-	add_to_cached_dir(cfid, ctx, name.name, name.len, &fattr, file);
-	cifs_prime_dcache(file_dentry(file), &name, &fattr);
+	/* queue async dcache population if enabled; fallback to sync if disabled or queueing fails */
+	bool cached = add_to_cached_dir(cfid, ctx, name.name, name.len, &fattr, file);
+
+	if (dcache_populate_async && cached &&
+	    cifs_queue_dcache_work(file_dentry(file), name.name, name.len,
+				  &fattr, cfid)) {
+		/* Async: handler will call cifs_prime_dcache + cifs_complete_pending_dcache */
+		cifs_dbg(FYI, "Queued async dcache population for %.*s\n", name.len, name.name);
+	} else {
+		cifs_prime_dcache(file_dentry(file), &name, &fattr);
+		if (cached)
+			cifs_complete_pending_dcache(cfid, name.name, name.len);
+	}
 
 	return !cifs_dir_emit(ctx, name.name, name.len, &fattr);
 }
-- 
2.43.0

