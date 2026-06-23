Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C7313790B
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246042; cv=none; b=gwRe2JDjnGMkf2NRZLWHx7MUAcxVWkWVeElGcNOiZMJ+zweUKS5NVezyNaIY0H7kCOM6CVOPzaW7gsiV1DeES4g7IIBLcLgq3oofuv8+mKbqlVN7/vfxCth8WigMqArJPhAEQZCsbjV39Dnj8j5UAC5/DhSoyWdvcKRpww2TKRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246042; c=relaxed/simple;
	bh=VDCGCiFPMWiCVN9h67YDUZUioofZG7YUMSC803gA6cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kz1bpsSgypyQKKUWJLrVnv8iG4lO9shRrF8nFcY63H0162SokhwExuUCTZJ+dbW5GTnQO5LzFBK7jbvEt83r+HkpXBkc4MLpe8DZeS5QsEKgAXa7LwIKa68DqEq0eCmKplJx6u27tgUiO04e1ohQhOu75mXzcYA1RSqQFyOUvuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SW6jFUqC; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SW6jFUqC"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6a0c7c4f55fso229402eaf.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246040; x=1782850840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkMiNKmrWw4q/acrkpUn6Ed0K+b5KG3IXJWqC8lxC4Y=;
        b=SW6jFUqCpsL5+n5cFWv07Q5PJW9cLpOyOxyEkkU9I2AvUajimwCjCEZtjOZ2nH3X0C
         ndyeilqXz2jRzO9alo1hyMYJeVCZKof7DS+2zFH4+LmbaxCmIQ5adDhAm2IH3aSKYVwR
         WmfvQ1QCEgPFa1W6CYYpEryXnF8rZ5rVNfGtMBgrbpwv1ReSH5YOD5WC2fCa9aflKtYi
         +AMeoReDbTGqjyOC7ifFB3eGLHd9F0xzajusk4JA1ku8xVw93o1MDaoAhImpv+VAAsfT
         Pu4+s91K570uaDoKFJ4epcC1AT33VsMLP/OTr7bq2qLh7XA5N5N09Mqz0phGuzqNYket
         0TiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246040; x=1782850840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rkMiNKmrWw4q/acrkpUn6Ed0K+b5KG3IXJWqC8lxC4Y=;
        b=F8un98SW5m0WmLB47Q6IikMSifkLEGHaS0g6ICCcUEdOLDxvHIkM9Xe44DFldKBbZv
         RpT2pHHFhFRmjax4oIqyozTwifQVsU0ILuZ2uyPziz6lHARj15fgMlK9TP0to9lwy/Gr
         TM+G4g97Z9yVuiGzRcE2ZJeIycVWhmobYoUVUuOLyyOvLFnqghWW8fe4jlA8R7uzDAoU
         gIGB8gOk9/dToCqBHLh7Orr+npVJa9J0XrUUrbVxsAAqen3FEZGMR9a+0QVJCa1u3U9h
         Vtwdj9RCUb1G372GNUnoUSu000ChHiLPYjVlmj0BV9bqUbMbamkGfGbFRk3kcI2aMg/I
         cOOA==
X-Gm-Message-State: AOJu0YxWGSsyKbAl94mV9oqzrRNRK2Uw+IvfN5hMtsPQ3xLGHv4nlrM3
	IiSozSyD8Dv8RMn5p9Af89gaxz5wjug4NZle0310lzaIJfEQ4/MhFz5sHaUu3v+f
X-Gm-Gg: AfdE7cn+g6CeYNTQAvyOkvBYVkUkXKivlx2I8wiknBwgI6n//EpJeXoUCQHKleobA72
	9P018vVjCcyehq0ffhse0PgX7YFy2vSmbMa4lZhMmoZPA+WjNKmte3qVcvpbRMA6OAfYLF2WTtT
	Czw2mBc4d3C7C0xTDh007y0ZrrBCIgvsQczyp/hALdjrFx3SAQwU01vVOW4vcx7Ga6S+ofmbLjI
	6sm55vpmyH8sjp/uzFpGn15/gGgeoy6kQMh67xCs3JfxJQA6/ClCRMbaiUzdQHQqFcTyDirDRII
	cN+T76mJes5WYuBcYKJCuNuEn0DdoRTZTrIuKM5aThkG4hXsooU4jEECn4S78DA8Df/uvoo1gWb
	qPYk46vgMQ0dHHDdCxH1EQdI2nXvkocxQMGqU3buwURBsoGKj2KAmVE2VOFVaDOXWpmFA213dPs
	uQARWQye95iqKemLBXxYUn7r9aUPC6PNSOLquM1Kk6wOQYYA5EWeMkx+vsnCsmGI1EYSz3WZQZf
	5wN5kaG5fqNA2hkkINNFvYbKgJUdXEo8KlvW0d9M3R/7A8XzD8iN1L7EarleJNSGvNxgXx8UYqd
	wcnd71sjE5pRv5CKQmYIKzA0PHI=
X-Received: by 2002:a05:6820:168c:b0:6a0:fbc5:d63c with SMTP id 006d021491bc7-6a122e91b96mr237221eaf.11.1782246039916;
        Tue, 23 Jun 2026 13:20:39 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:39 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 09/16] cifs: register a shrinker to manage cached_dirents
Date: Tue, 23 Jun 2026 15:13:36 -0500
Message-ID: <20260623201344.2043841-9-stfrench@microsoft.com>
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

Since the cached_dirents are now backed by folioq, we do not need
a timed cleanup of these cfids anymore. This change registers a
shrinker with the mm layer for the dircache. If mm needs to free up
memory or flush the cache, it can inform cifs about this using the
shrinker interface.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifs_debug.c |  18 +------
 fs/smb/client/cifsfs.c     | 104 ++++++++++++++++++++++++++++++++++++-
 fs/smb/client/cifsfs.h     |   4 ++
 3 files changed, 108 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index b35863eb2a66..131af7333fc5 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -375,22 +375,8 @@ static ssize_t cifs_debug_dirs_proc_write(struct file *file, const char __user *
 	if (rc)
 		return rc;
 
-	if (v == 0) {
-		struct TCP_Server_Info *server;
-		struct cifs_ses *ses;
-		struct cifs_tcon *tcon;
-
-		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-			list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-				if (cifs_ses_exiting(ses))
-					continue;
-				list_for_each_entry(tcon, &ses->tcon_list, tcon_list)
-					invalidate_all_cached_dirs(tcon, false);
-			}
-		}
-		spin_unlock(&cifs_tcp_ses_lock);
-	}
+	if (v == 0)
+		cifs_shrink_dir_caches(false, ULONG_MAX);
 
 	return count;
 }
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 834859fbd527..fd725ee4293b 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -30,6 +30,7 @@
 #include <linux/uuid.h>
 #include <linux/xattr.h>
 #include <linux/mm.h>
+#include <linux/shrinker.h>
 #include <linux/key-type.h>
 #include <linux/fileattr.h>
 #include <uapi/linux/magic.h>
@@ -125,10 +126,95 @@ MODULE_PARM_DESC(dir_cache_timeout, "Number of seconds to cache directory conten
 				 "Range: 1 to 65000 seconds, 0 to disable caching dir contents");
 /* Module-wide total cached dirents (in bytes) across all tcons */
 atomic64_t cifs_dircache_bytes_used = ATOMIC64_INIT(0);
+static struct shrinker *cifs_dircache_shrinker;
 
 atomic_t cifs_sillycounter;
 atomic_t cifs_tmpcounter;
 
+/**
+ * cifs_shrink_dir_caches - shrink dir caches by a specific size
+ * @wait: wait for server responses to close
+ * @nr_to_free: number of pages to shrink the dir cache by (pass ULONG_MAX to
+ * free everything)
+ *
+ * Shrinks dir caches by a specific target size.
+ */
+unsigned long cifs_shrink_dir_caches(bool wait, unsigned long nr_to_free)
+{
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+	u64 before, after, freed_bytes = 0;
+	u64 target_bytes;
+
+	before = atomic64_read(&cifs_dircache_bytes_used);
+	if (nr_to_free == ULONG_MAX)
+		target_bytes = U64_MAX;
+	else
+		target_bytes = (u64)nr_to_free * PAGE_SIZE;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			if (cifs_ses_exiting(ses))
+				continue;
+			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+				invalidate_all_cached_dirs(tcon, false);
+				after = atomic64_read(&cifs_dircache_bytes_used);
+				if (after < before)
+					freed_bytes = before - after;
+				if (freed_bytes >= target_bytes)
+					goto out_unlock;
+			}
+		}
+	}
+out_unlock:
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	if (wait)
+		flush_workqueue(cfid_put_wq);
+
+	after = atomic64_read(&cifs_dircache_bytes_used);
+	if (after >= before)
+		return 0;
+	return (unsigned long)(before - after);
+}
+
+static unsigned long cifs_dircache_shrinker_count(struct shrinker *shrink,
+						   struct shrink_control *sc)
+{
+	u64 bytes = atomic64_read(&cifs_dircache_bytes_used);
+
+	(void)shrink;
+	(void)sc;
+
+	return DIV_ROUND_UP_ULL(bytes, PAGE_SIZE);
+}
+
+static unsigned long cifs_dircache_shrinker_scan(struct shrinker *shrink,
+						  struct shrink_control *sc)
+{
+	unsigned long freed_bytes;
+
+	(void)shrink;
+
+	if (!sc->nr_to_scan)
+		return 0;
+
+	if (!atomic64_read(&cifs_dircache_bytes_used))
+		return SHRINK_STOP;
+
+	/*
+	 * Shrinker scan can run from reclaim context, so avoid synchronously
+	 * flushing worker queues here to prevent long stalls/deadlocks.
+	 */
+	freed_bytes = cifs_shrink_dir_caches(false, max_t(unsigned long, 1, sc->nr_to_scan));
+	if (!freed_bytes)
+		return SHRINK_STOP;
+
+	return DIV_ROUND_UP_ULL(freed_bytes, PAGE_SIZE);
+}
+
 #ifdef CONFIG_CIFS_STATS2
 unsigned int slow_rsp_threshold = 1;
 module_param(slow_rsp_threshold, uint, 0644);
@@ -2087,10 +2173,19 @@ init_cifs(void)
 	if (rc)
 		goto out_destroy_mids;
 
+	cifs_dircache_shrinker = shrinker_alloc(0, "cifs-dircache");
+	if (!cifs_dircache_shrinker) {
+		rc = -ENOMEM;
+		goto out_destroy_request_bufs;
+	}
+	cifs_dircache_shrinker->count_objects = cifs_dircache_shrinker_count;
+	cifs_dircache_shrinker->scan_objects = cifs_dircache_shrinker_scan;
+	shrinker_register(cifs_dircache_shrinker);
+
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	rc = dfs_cache_init();
 	if (rc)
-		goto out_destroy_request_bufs;
+		goto out_free_dircache_shrinker;
 #endif /* CONFIG_CIFS_DFS_UPCALL */
 #ifdef CONFIG_CIFS_UPCALL
 	rc = init_cifs_spnego();
@@ -2132,8 +2227,11 @@ init_cifs(void)
 #endif
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	dfs_cache_destroy();
-out_destroy_request_bufs:
+out_free_dircache_shrinker:
 #endif
+	shrinker_free(cifs_dircache_shrinker);
+	cifs_dircache_shrinker = NULL;
+out_destroy_request_bufs:
 	cifs_destroy_request_bufs();
 out_destroy_mids:
 	destroy_mids();
@@ -2166,6 +2264,8 @@ exit_cifs(void)
 	cifs_dbg(NOISY, "exit_smb3\n");
 	unregister_filesystem(&cifs_fs_type);
 	unregister_filesystem(&smb3_fs_type);
+	shrinker_free(cifs_dircache_shrinker);
+	cifs_dircache_shrinker = NULL;
 	cifs_release_automount_timer();
 	exit_cifs_idmap();
 #ifdef CONFIG_CIFS_SWN_UPCALL
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 008b1d373245..a5bf711e4de7 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -125,6 +125,10 @@ extern const struct dentry_operations cifs_ci_dentry_ops;
 
 struct vfsmount *cifs_d_automount(struct path *path);
 
+/* Functions related to dir cache */
+unsigned long cifs_shrink_dir_caches(bool wait,
+				     unsigned long nr_to_free);
+
 /* Functions related to symlinks */
 const char *cifs_get_link(struct dentry *dentry, struct inode *inode,
 			  struct delayed_call *done);
-- 
2.53.0

