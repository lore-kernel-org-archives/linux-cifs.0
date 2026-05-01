Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7223A169B
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634450; cv=none; b=ZyDdbCKKcDZ/8VgzVW0LQ/R8YVLjYIZHb84vUKtIPq/Nz8/YPM24Cpmlj1NYXAbsxw020fu47x4rrNYlBs6N5QApv91YnPp85PA4Lrv/7PFok+7onWZIO9gyCBiuV5elPvq+qM7aUKO94VKU9nqrfHSbYUVgeE7M8/gFj1Y0tdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634450; c=relaxed/simple;
	bh=VmiNOu92qfOGpbgQdQKaaiAu4d2/LjywJv3/ynylAQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7TXVe7U5CQqROzmLIkA/qc20lLmcGaTtJazda1jWs5t4k2Zbr9LNkPD40j92MW+46u5ghMkMrr2HsJjAbCgEAZRlGLzEysG43tP3+SM70gZkQQS34spgl4bRllZrvgUjoi6TRGyJiVQr8A+WPfq8IxujEw+maUwJCI3k8Ydqrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pFrnLPzD; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pFrnLPzD"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-834f1075805so1345750b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634448; x=1778239248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rJkHCqu0LYxbJNwm6CzO2YLvdSwFs9MG3Pzkk5d76uk=;
        b=pFrnLPzDyQR5fiOOje3oPuEXkzvRIpUn4Cct3wv0IL28fQlM3ZpOv8K1RH6ASKoNkU
         PwBkTFD6S2Wm+ztug4Ivsnv0NUapp8L7IfZVgDkRrPuIWKhTQ4Incr4VGx5XP/T0OurR
         wU/+r6UTwyDAEMo2hYp2Cofw5OcQSvlU4tJCyVSdnX0VvTyCA6+Abp0PAIzme7UXVoz7
         VC18UMS3e1udt+hICPUKeSeQAVZKrUVHqGH/otCcYQCzRRhq/guJWYB8Zjq9tNuZFO5P
         6pcZEtQPJK7uENezz9QI1YiguKVQIJFkuxLl6y2IrT3HCpF2e2ypW3YWIM1rikMgYhGm
         IW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634448; x=1778239248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rJkHCqu0LYxbJNwm6CzO2YLvdSwFs9MG3Pzkk5d76uk=;
        b=IgfcdMLuP+U+j0POtUChjS14XUwU/xgRN7JWW+SydYHsaHgMZJb8jQHrzVrYgQUtIL
         tYSOtiWQfJ8ddl1d7lnGGksdSxDWv5KoUXB2RivXOCzAH0xRjm3Vsh4qTbJbtaiSnlcz
         guayZjvTk01FthtCYpl3T9pz38Pn9UO/5bJ3jue3Nu8S7KHx393B1YKr9h4Jf3QdG4KM
         LsaIEVAS7OTI7ZQcYHqYZc7PLoohsgh+HpficvROFB3iQO4mihlnHziRa+fsCqiYFeid
         tuK2hkkKtAnro7RScCCo6wAssuM3ZcBO/vkw2YxAO4EKGrCi92uDJriVxGM//1W4TLhe
         WrLg==
X-Gm-Message-State: AOJu0YwbmGtH0TOrTWSO2TiM9LjRQ2ltK8KA3wKXp44hfS/TozzaGfHj
	E6WKy2mhY5xpo+txitDjRb+JQgbAAsERv+YXbNN2ZWT5m3XKw5zSU6pFtgD67Wz9CjM=
X-Gm-Gg: AeBDiessHWx30NOCFYkJD3p98OMwFSffvJaftzUraKzCwyeFPhoima/nl/SEe53FPzy
	XRPqtjVpKwZasksTfGZaXUqF72XFzkWCprsRIazGkK4MF7aoWmiYQwAGG/Wp2TvXt3ZdewkDuo3
	KWvKoz3ixm3KaT/4dHkhQut9Ye9Z5AmrgW6rghdEvvx9U1Dug5+8aRjQsADAe/Xwy7iM86ctvsL
	aUbFakfc0bFf+uQNomb2AZU/HJl28QAB9oG7tgtNJXgu0WWAF2ciek4WVzUHtBA1JT56Az0fr5N
	r0+L3umNuA6ZF0RoqjdSCnNvwmN62nFUNTPNXQjdDLzcT5o6HMFT9tSEcfmN3knOEeU8Lmc5SRw
	rTOUUgiTIhNhOl/oZA2VIo/ba3mqnkDx0Z9Lm8pfFC3kHpZ/F3uTKqYfkEWx1x6KnFgnTLj0JdI
	HzEUshxdB5uvBfp/09KXQYzUIcz77rvRUlWSH4wnKgQSk95z6kDzDGX+gktqm0jGKH
X-Received: by 2002:aa7:88c8:0:b0:82f:2243:e445 with SMTP id d2e1a72fcca58-834fdbe6804mr7975576b3a.32.1777634448042;
        Fri, 01 May 2026 04:20:48 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:47 -0700 (PDT)
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
Subject: [PATCH v4 15/19] cifs: allow dcache population to happen asynchronously
Date: Fri,  1 May 2026 16:50:18 +0530
Message-ID: <20260501112023.338005-15-sprasad@microsoft.com>
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
index 79a6a4c297ee3..f8f3b27ba60bc 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -69,6 +69,7 @@ bool disable_legacy_dialects; /* false by default */
 bool enable_gcm_256 = true;
 bool require_gcm_256; /* false by default */
 bool enable_negotiate_signing; /* false by default */
+bool dcache_populate_async; /* false by default */
 unsigned int global_secflags = CIFSSEC_DEF;
 /* unsigned int ntlmv2_support = 0; */
 
@@ -241,6 +242,9 @@ MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. D
 module_param(enable_negotiate_signing, bool, 0644);
 MODULE_PARM_DESC(enable_negotiate_signing, "Enable negotiating packet signing algorithm with server. Default: n/N/0");
 
+module_param(dcache_populate_async, bool, 0644);
+MODULE_PARM_DESC(dcache_populate_async, "Enable asynchronous dcache population during readdir to improve performance on large directories. Default: n/N/0");
+
 module_param(disable_legacy_dialects, bool, 0644);
 MODULE_PARM_DESC(disable_legacy_dialects, "To improve security it may be "
 				  "helpful to restrict the ability to "
@@ -395,6 +399,11 @@ static void cifs_kill_sb(struct super_block *sb)
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
 
@@ -2082,9 +2091,17 @@ init_cifs(void)
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
@@ -2164,6 +2181,8 @@ init_cifs(void)
 	cifs_destroy_netfs();
 out_destroy_inodecache:
 	cifs_destroy_inodecache();
+out_destroy_dcache_wq:
+	destroy_workqueue(cifs_dcache_wq);
 out_destroy_cfid_put_wq:
 	destroy_workqueue(cfid_put_wq);
 out_destroy_serverclose_wq:
@@ -2212,6 +2231,7 @@ exit_cifs(void)
 	destroy_workqueue(fileinfo_put_wq);
 	destroy_workqueue(serverclose_wq);
 	destroy_workqueue(cfid_put_wq);
+	destroy_workqueue(cifs_dcache_wq);
 	destroy_workqueue(cifsiod_wq);
 	cifs_proc_clean();
 }
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 2a3fad071564a..278bf2bf11e97 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2144,6 +2144,7 @@ extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
 extern bool enable_gcm_256; /* allow optional negotiate of strongest signing (aes-gcm-256) */
 extern bool require_gcm_256; /* require use of strongest signing (aes-gcm-256) */
 extern bool enable_negotiate_signing; /* request use of faster (GMAC) signing if available */
+extern bool dcache_populate_async; /* enable async dcache population during readdir */
 extern bool linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
 extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
 extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
@@ -2165,6 +2166,7 @@ extern struct workqueue_struct *cifsoplockd_wq;
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

