Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43D233689B
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 18:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778782125; cv=none; b=oQGoTC9guqJdtHmszR9p6gf+tzVY1zbYACF1blalFvn3LVhENySEJrnmlt8gKrr74uqlqO2keEAn3LYjOzslQ3gnOnpsrZh+mauGBXxLgbZFXtYXDkCob8rhEfMO4oMPG2rj4gBLLOIYFaqUN3AyOSFXAxQZLDHRLyQO5DCeou4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778782125; c=relaxed/simple;
	bh=y3XDBWgjGLvdKOqqdEXi1CCc3iEadE4/auoj285CRQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpDGAEMvh3wfjgDqDQD2Tyo+et8/NhllAERv3QUzCXpyhuMCIvPGiVQJIqpPrQtXUFOy9yQDufFiLnidic3CCI6m8PI3C7p4q5zB7/CYgJEzfFru4MXbMmZvZe/Euk/9MPtb8cPkIXIjmO4jBml8bieAvywZKWwX9zygGZRTWJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VdXkuYob; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VdXkuYob"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c801912c903so4002689a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 11:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778782123; x=1779386923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0e6j/npVv80kBiW+5yEwB1xvrblGuYXSB2qdyI4D/60=;
        b=VdXkuYobr3l1+ZpwBbmR5yzEzx2xHsbKcQocBf5CAEhmkNd0y7nHMLheVIB/btPJgh
         gTTuw/KqzYIBQ1FlHXt9c+t88QdbGmCvjOyRgzH3kvDh077kGi68Wcix9rQUyfvo8c0g
         aFvbgKcQtpKzOFpv2tdrlgs8wN0GDGsyM88Wnvca+J5bo/OjlIEylpixWQLb22JXjyON
         F1Ya61UVveDoRKuvBU59qNQc/+VZ80gHiiT7E2nKhH+rQQ710LI91TEOFEwBWR/h5E05
         ZRqgihRmBc4rRbUB1S2wEq3yj7PAp3mOi9apRQR7urh2k6n1yLxFawiCtVhgDWMM7UKE
         ZrPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778782123; x=1779386923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0e6j/npVv80kBiW+5yEwB1xvrblGuYXSB2qdyI4D/60=;
        b=YmR4VYz//qdiOC/K+PvT29xfs8jJ1tPbML5WwYqpNgvAVYXzelsA1SSuBflhIMDyBo
         xM/iTFE4wrsAZFo6xDJWLAQXFYIjovoQcLBQ49mChh+I2h4YpSrE8fJEtCg8pzSLaPZa
         1FEsCfQM1wnNWwK/ImN2HFuYxwM9gKCdA8BWI9Woofp432JDmvCli0DzS5k3P++f8I8+
         GjMAXbXypHfWGajCuoIUQaopEfpEJMBD8C55SoLYV0TVXxp15eKarYQ635Cj6m2tdgfG
         sCRU5ae1m95RQS3ZCn52c/3cIFIPtU0wBWzSWWvJtuBjpBzDUCuKCNV0o3Qo2mRP6quF
         kcpQ==
X-Gm-Message-State: AOJu0YwcM7qG6LIPrV4JpAb6omZSFLpmMjsfgFlo1Szt5sNyQPsrZNiB
	u5TcBj3KVtP5t2MpOeZKlc+8kiTQo7lfWt9X6fZ4BL1CtP88Af/KNHRB9SO47O+iPCY=
X-Gm-Gg: Acq92OGxxLTzqWAzxNdUnFFqUoswUU0wZEEXk/RicfhU/0OgvegmWB0+ax7zcG6ckT9
	lD/Zb2V7fbm9DiSfo6Bj3GGJgeiBGh1GWVXjencFHenpnqyxFHR4KmPinMTKcd7mQ47LYHrXlHl
	e+Fdkyioencqwj9NyRLbydklrfffzTphYwTZ41m9uGOTuZeedBenNawfXe0hmB/k/dO5htmgdux
	8dSRd+fy4jJKAD8RzxyRR8LQZVus1d6JPvRRMsEKnAoD6/yBSLcgIzHgom88Q4E9ZMncC8eQb3A
	J4OdwcaGfpXan1tk6wxA9aLAsCaocJ15lQXv+AivYAwBx3C9J2nhYKq1aaZK6Q4vCXu5mFG5u9s
	XFAoaBh5+nFOIhjc5liOhaVFy6avYvFtZAwv+O/BpqZwFxabmdMSLX1wExxE0LfwNT2XkFnTIte
	6pa1eYBwN3osgc1BalH6bOrICJ8fvTRC3GjA4UbmH5WalMzoo3XHNNq5IQwRl0qoo3
X-Received: by 2002:a05:6a20:6a0e:b0:39f:91e9:cada with SMTP id adf61e73a8af0-3b22e816ab4mr337132637.9.1778782122622;
        Thu, 14 May 2026 11:08:42 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb121cd6sm3134589a12.30.2026.05.14.11.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 11:08:42 -0700 (PDT)
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
Subject: [PATCH v5 10/17] cifs: register a shrinker to manage cached_dirents
Date: Thu, 14 May 2026 23:38:16 +0530
Message-ID: <20260514180823.497293-10-sprasad@microsoft.com>
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
index b35863eb2a660..131af7333fc58 100644
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
index 9f76b0347fa9d..14cb3d37a8607 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -29,6 +29,7 @@
 #include <linux/uuid.h>
 #include <linux/xattr.h>
 #include <linux/mm.h>
+#include <linux/shrinker.h>
 #include <linux/key-type.h>
 #include <uapi/linux/magic.h>
 #include <net/ipv6.h>
@@ -123,10 +124,95 @@ MODULE_PARM_DESC(dir_cache_timeout, "Number of seconds to cache directory conten
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
@@ -2011,10 +2097,19 @@ init_cifs(void)
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
@@ -2056,8 +2151,11 @@ init_cifs(void)
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
@@ -2090,6 +2188,8 @@ exit_cifs(void)
 	cifs_dbg(NOISY, "exit_smb3\n");
 	unregister_filesystem(&cifs_fs_type);
 	unregister_filesystem(&smb3_fs_type);
+	shrinker_free(cifs_dircache_shrinker);
+	cifs_dircache_shrinker = NULL;
 	cifs_release_automount_timer();
 	exit_cifs_idmap();
 #ifdef CONFIG_CIFS_SWN_UPCALL
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index c455b15f27782..d08394a3c5ce5 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -122,6 +122,10 @@ extern const struct dentry_operations cifs_ci_dentry_ops;
 
 struct vfsmount *cifs_d_automount(struct path *path);
 
+/* Functions related to dir cache */
+unsigned long cifs_shrink_dir_caches(bool wait,
+				     unsigned long nr_to_free);
+
 /* Functions related to symlinks */
 const char *cifs_get_link(struct dentry *dentry, struct inode *inode,
 			  struct delayed_call *done);
-- 
2.43.0

