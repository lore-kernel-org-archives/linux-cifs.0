Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB54A30DEA6
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782232178; cv=none; b=oBmlw+wLyc2tm2PnJcsjS1AVnC2EF467IPABBoYJ8tNpYMGT1E6IAaPHbkorrBlxGF69+NZi9yOIjhTcM/QBW2f+U8JQYvVuYDH5r0MxT05qi61kWsYAiZdoWgZGpibtje5ADrfaz1eOJVbu7wDCzdB4hEFD+kt99+i/07Vkznw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782232178; c=relaxed/simple;
	bh=PwnLq2EpOCnXU/Tpz72ReKmaftBIcZqiOxXXUrmnbFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzjlsbxU7mVoTQZ5Li4+8lH4AY8ETU+lc2s80Rs+UHHkOcoGrHbJkSeadGtD7pOkfBvIG4Cua6BnWBkQsTd5I1Jglf6t0s6J66PS+7gvQhp4bZM+OE2ROwYg4SaiGRRLYKLSCyxk2+1zpwRrfktEmhounLAm/PImmrDiQDP9kiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HkNSy7HK; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkNSy7HK"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c85c531d4a9so2488562a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 09:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782232176; x=1782836976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RMsKZzQxrYAeb/WSXPEb2bQvTd2kg7OWo710MUQYm6A=;
        b=HkNSy7HKkZuDycXmDOkWIRilOn3yRdlQckJkkC/ZPVCx5HSKquVChhQiS6Vu2Gkrsa
         kPBqwmPImoFX5ylR0bZGMOKEYpnTTXuX9h7pGHlsoMV6KO2DhjncPunSpE8V4GqUDMZx
         P7HeYvDnvZkJuPTrPMwfubLj9HepNmwflnxqe3OQs0G7yHggoK4UCy3DfSWXazaKtLoo
         qL5hBC33/VWSiOfNNyouAZDw+LVKo2VVLXhRgGZ5NFuN8wFai9sS6MfhK/S1EIRQSTxI
         zMTaYqfaNa/Q5IuZ2cQjHZO26Cus1OBa+wYjRN4dM9NSphlzbUHMPkWCVr2Kk7M4g8D9
         xUIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782232176; x=1782836976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RMsKZzQxrYAeb/WSXPEb2bQvTd2kg7OWo710MUQYm6A=;
        b=iq00l2fHxQmxz4KWSujc5oq4e+8rkKXIDwyKwsPD9CvcKDMljwbUfTg8KK+FXNYPBP
         i7X6LIEpVbSAUY+lCfk2n/KF/XvqMGCxfiVPg9lMWYHLufIZin9749nxWbzCfdd7V/5g
         QJ0+5WN5ufeRlxfm5IjIhfcLXQd5VndebVo/Nj4U7uIf7Ph2iI6UsPAYYNd+uUICXabK
         5g7AG+s5vKjEhJcHXxGjTNZjdav9yEMZ22Jf5jpi894ziUwEUytOHwx1gJhQKM4I4nln
         vUBVm7l7kr55ZcbtjanfH/y1ktt6P/eaTMSkqszOAFUHsL34LzI08Dk4fhs1pygPanSH
         C7oQ==
X-Gm-Message-State: AOJu0YzgxEsRmd3AvqdVs14DQ7NlDVBm859VzI/7Uxbp3dnaEnwQeq9T
	kTLfJnmeYAkq0pC7GB6sRJtJJbg1mV3aG2fnEZdAVb1TQ+snGH82RhTDBMRPVW1obKU=
X-Gm-Gg: AfdE7cmA17mDso0GWzimgXwpYENNV//GhLCGYdG/TQhOAUJrllk0WGFeDC9cIWB716W
	n29bsJoaLVcVYwzdmnDBZwFdJQgm3gSd4XXwBwIqyLq0PHsGvCfL8bOG+AiTJrFcXu4aBoqAgpP
	N15n3KiSgmzXFYOkRWminZY2YjJkGIhxEaYmL/ZRJL9kolXRjais7ePmBRs6yPJpjA8pMSu4pXR
	N8Bu6gKcr+EJryczec2nWdj320RF/Sd+DjNDWw2Clx1nSi2gjZV21CWLLSQlUSQNo5hF1opfxnG
	txy6n//cLuh0Rl4Xv2NBr4eLkUwY4qaBPDJbI0tGoxY+IOcuQUqMUhC17oNNTgyMqlD5RsxwOgJ
	iSAA++2acC3yVMOpfcEyZUxds9+HNq5MrVxP4YKB+loLGvOuRxFtaJxdjv3yqiAKJxFFDFZ1S8Y
	tkS3kLgyud2B9btpYWe9ELpWrd8i3PgRVxqG28Rn9zFYE=
X-Received: by 2002:a17:903:acc:b0:2be:fda1:42d9 with SMTP id d9443c01a7336-2c7c97e5f71mr33684975ad.0.1782232176019;
        Tue, 23 Jun 2026 09:29:36 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743bfdc97sm135185485ad.65.2026.06.23.09.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:29:35 -0700 (PDT)
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
Subject: [PATCH v6 13/17] cifs: allow dcache population to happen asynchronously
Date: Tue, 23 Jun 2026 21:59:06 +0530
Message-ID: <20260623162910.343930-13-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623162910.343930-1-sprasad@microsoft.com>
References: <20260623162910.343930-1-sprasad@microsoft.com>
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
index deebe5d440de5..43386cb329a06 100644
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
index aa87421c75c05..8fca761aa69fc 100644
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
index cbebb6f980e96..babe3bde55f2e 100644
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

