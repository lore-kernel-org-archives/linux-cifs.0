Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB1A13790B
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246046; cv=none; b=GRzq/oxRItsGWw2a+nRIpPtcaSxzMENtwg4NiOWBNqXSer4NWmZ+3PKq0snnBFzdneJcQKDvwkQcrzOnxxHUocsgMUjVppLYr37r1rw/1n6xD+C11pItygAit6JXV2yi1xYHXrahDv6910A4UKubC0PIzEJ2/gOkjZYsBH7rhXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246046; c=relaxed/simple;
	bh=JmuSBCiRcnxaJ3QlkYYgBsigT+mZou0+2jfXXueknB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWFC2QQLL0sZsn5wYE1isNmAL+agToTNXJIGtBnNae0Uzy6UIIbyfuuA4afmqe1M1QsyO5/8VjOSY3V8eHAmOiDgFGvHhQi+rzURYvqzIFf3oVriTQBEKJ+8AN0QN/nGODTBUT4b7XU4PUa5s+9ob3Vy/AOZhRwJXrUBYIVTSYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jtoc4ca1; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jtoc4ca1"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6a11ee16af6so154665eaf.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246044; x=1782850844; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xIwECiD2bMv/9W+w3gMIvn2IWknU/JTiFX8CyKm/Byw=;
        b=Jtoc4ca1Sb8Q/qD5JoXDa0pTu+cu0T7bvAM63gPM6Kx97evY3AkdHFJMlaOgeBNhVR
         sOxhOF+zk52Rmk1Ywnou9pYjPZBTuRycCt0JMVTP3IgCHR30QrPPwUiAT738bsE0QRRQ
         gfscMkJK4yuuNn/sXJm7atrWIE2djxj7r5PRB23NwjeM88ZKKuzQEBTiXBgRPCuZh9Gk
         1m6Zwr6h0M+qWCO6U1LTroijJ+WsSK0546nBQ76YEiBjdXk0mD0pp2TfpI8ZQQdr0kQl
         /1acbw8u9fze012U9KpkEr5SoUtpFJR/voaxyeEAHD2jb7JdJLm+W8K58Kmyt38F4Z4h
         enAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246044; x=1782850844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xIwECiD2bMv/9W+w3gMIvn2IWknU/JTiFX8CyKm/Byw=;
        b=HOBUKRzC1/CrHmYGALI1bJwsg8weIDyit8D99n0Ih4d5iop/xwSD4BiYPxMK396xV3
         0Lgvn1WOcs/BFipQSoT5oKALf47UpSRGuXnj/c+lenhe81g9GcWd+0Q8DGDFcwFLV0OW
         mY+MImj9RNZ0mXIIuHR78AbUfA4rlQ3d2rRCgopV4yKpGNvYnb+zeWb40fFEc3xVdOrp
         EOwFGZ4xBw3BRlxNYwShmix8m9ebNdKe0eI/L9aq6YLDZcaa9UScchy5rxJKe0FGqJ9p
         RGd4DlYCphgLcKWN0pld19PBlOhpgDa0ghFfCuSR7PtBI2Fvvrex0j9jMREVUY0NLsWA
         zB1g==
X-Gm-Message-State: AOJu0Ywat8LEDnB3mSj/QbVRMs/5jB8SRM4Em8c+kfXKwoTDNySHlNaZ
	XzkLEiIVLfW1WaVkIBJv/CR1sCHzDmDFfYB2iFoC9BBmo+CWIMM8hzMs84lYAqyd
X-Gm-Gg: AfdE7ck81aaVpUshA4qJe8zcUgFWRpQQo7Kkv5Wq0IKznOIC4vobeDHV/PNsv6E997H
	GHx+NesmQsM6rPE7+3juQ+xbQJLM0sK0cxW/4qziVj3MkW7nK6t+pDjieTwld5pFlZ+xu1l8Ik9
	yi/KuTqvYRdSrD6I/4PVe2cReGMtc1ffd7fiYHy96q/qwLxE0tKs+MtiSy7Ofv9MahVd6Jfg9JS
	foqjtY0oZyqC1Wc2VbICON0y4KFNFGPMifMMxcWRxBtLZunS8zEk6EJNBqJeWlpoh+epeJU0V9s
	17podP0pWQkEYzFK0AddyaFoeYFm6HiZrFqzbYg/gUljQPge/sPyUku9JCJjJlWIDZhwL13gX4Y
	X4TmeMcyOYMNEvJQZQHbwGSVwduERxQ8Aw08gZToDdnAA5SXRoE4RwGQcCsoayNqmyxx04UMbS1
	VTpzqOzIqbEMzK5rRB9C9CD/PFqgrtUFyQyeyubtcJ8GVvONpHr5ilLSkCYsB40UXK0zNo0IncG
	c1hvfIjPulken10ZB2AR+pE2/DDK+1XDIWdI1ApWRIA30vcOlAfdMW3WZ1QppVBXuMYqDRdjYz1
	kO0icJC/9G+lPncTEczGb756Kzw=
X-Received: by 2002:a05:6820:f00e:b0:69d:f0e8:3226 with SMTP id 006d021491bc7-6a114af8110mr3265600eaf.10.1782246043993;
        Tue, 23 Jun 2026 13:20:43 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:43 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 12/16] cifs: allow dcache population to happen asynchronously
Date: Tue, 23 Jun 2026 15:13:39 -0500
Message-ID: <20260623201344.2043841-12-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623201344.2043841-1-stfrench@microsoft.com>
References: <20260623201344.2043841-1-stfrench@microsoft.com>
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
index 84e7e366b0ff..0efc1483f3ab 100644
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
index deebe5d440de..43386cb329a0 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -71,6 +71,7 @@ bool disable_legacy_dialects; /* false by default */
 bool enable_gcm_256 = true;
 bool require_gcm_256; /* false by default */
 bool enable_negotiate_signing; /* false by default */
+bool dcache_populate_async; /* false by default */
 unsigned int global_secflags = CIFSSEC_DEF;
 /* unsigned int ntlmv2_support = 0; */
 
@@ -235,6 +236,9 @@ MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. D
 module_param(enable_negotiate_signing, bool, 0644);
 MODULE_PARM_DESC(enable_negotiate_signing, "Enable negotiating packet signing algorithm with server. Default: n/N/0");
 
+module_param(dcache_populate_async, bool, 0644);
+MODULE_PARM_DESC(dcache_populate_async, "Enable asynchronous dcache population during readdir to improve performance on large directories. Default: n/N/0");
+
 module_param(disable_legacy_dialects, bool, 0644);
 MODULE_PARM_DESC(disable_legacy_dialects, "To improve security it may be "
 				  "helpful to restrict the ability to "
@@ -389,6 +393,11 @@ static void cifs_kill_sb(struct super_block *sb)
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
 
@@ -2157,9 +2166,17 @@ init_cifs(void)
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
@@ -2239,6 +2256,8 @@ init_cifs(void)
 	cifs_destroy_netfs();
 out_destroy_inodecache:
 	cifs_destroy_inodecache();
+out_destroy_dcache_wq:
+	destroy_workqueue(cifs_dcache_wq);
 out_destroy_cfid_put_wq:
 	destroy_workqueue(cfid_put_wq);
 out_destroy_serverclose_wq:
@@ -2287,6 +2306,7 @@ exit_cifs(void)
 	destroy_workqueue(fileinfo_put_wq);
 	destroy_workqueue(serverclose_wq);
 	destroy_workqueue(cfid_put_wq);
+	destroy_workqueue(cifs_dcache_wq);
 	destroy_workqueue(cifsiod_wq);
 	cifs_proc_clean();
 }
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index aa87421c75c0..8fca761aa69f 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2142,6 +2142,7 @@ extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
 extern bool enable_gcm_256; /* allow optional negotiate of strongest signing (aes-gcm-256) */
 extern bool require_gcm_256; /* require use of strongest signing (aes-gcm-256) */
 extern bool enable_negotiate_signing; /* request use of faster (GMAC) signing if available */
+extern bool dcache_populate_async; /* enable async dcache population during readdir */
 extern bool linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
 extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
 extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
@@ -2163,6 +2164,7 @@ extern struct workqueue_struct *cifsoplockd_wq;
 extern struct workqueue_struct *deferredclose_wq;
 extern struct workqueue_struct *serverclose_wq;
 extern struct workqueue_struct *cfid_put_wq;
+extern struct workqueue_struct *cifs_dcache_wq;
 extern __u32 cifs_lock_secret;
 
 extern mempool_t *cifs_sm_req_poolp;
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index cbebb6f980e9..babe3bde55f2 100644
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
2.53.0

