Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6431E306757
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 16:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782232175; cv=none; b=UDEEfOqnjC/0PuYi2nubZXOiPoWbsSn9+cRADUtTgNrYxugV5B/4KfojvULkCLUGrgaVtawacUsvg2qQE6ZBOiN7fPn6jCYr99s0t+TSn3HqkvWrLHSDBgpf04ToP2gV2kxQK0k0/IGiz9jPOJDK6ni6wTeryHXU8j+65Q1RBvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782232175; c=relaxed/simple;
	bh=cwaW2wLtdEJbuUutfaVAqrXSzxH1GC8eWPJo+Z8UZ1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnSIYl3H6RzzY6YS2m/a25vPEmQipSQftQ3hyDLy150SFyvXdsVuT4YXZjbDAD4HzfuIk6Qalsf2O4wFS53nuCgU2JWXTODKYiaVmwi4eoYH/0U3WxPegagXST11bd3fjJ06JxJ2CEDsiX8uIHTF3VxKPBfo99fvo4y1+AqLKIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OsJaVskL; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OsJaVskL"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c6dadfbaafso242825ad.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 09:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782232174; x=1782836974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rq8TlDnSWcHD5P8cu8KUinfp8vhYwgWMLpEycYOKJ5M=;
        b=OsJaVskLPj+swVDfRjTYu9xwstE9Giwm2YaML/PvKr2g11ghPaaWlqZEdoBD22YX9W
         vPRIdmOOYrJx2djwqm4Sz9T/U2+bO/UGbV8YoKEIilfH+19qECft9pVBxJFrTxZcy5Us
         1Fd47KTpUKcIIlZV9wHlILcH2vBCNeG/E+K0DPhkOR+ZqW0FQ7TYK6SWecuOLnR3NAH4
         VovfWalN61vIlLKn8iN2lZ3di/7XQBGhRx9jIfTkOZeAFh1yUkoOUyDKS7L0m9v6banY
         A4W0c0BlVZJxF+U+nrlYVOtrQXJxjoHhwlpO9o4QxTB9ZlgoqxhuyUEgXYspI8dXPGpF
         zE6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782232174; x=1782836974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rq8TlDnSWcHD5P8cu8KUinfp8vhYwgWMLpEycYOKJ5M=;
        b=RH2gUKy5wp74F3qqrM045yFdvUSLEhvPlqnDyaQu6z7cu1EsBI5dTj4HCrevChCVH+
         99ucqgJJAPK81u4TXztZZzBLZzazcRGrOtf2TxOtQEhe5HNsFedIlRdHgfzfm1W8nMyA
         ZwC4nDp3Di5dSaGsRVLyVqqCk+xby9Aetsyo/WgAkXUsTvvY+KuEKL+olVCS4lXZUtWk
         y5fAPmjwt6Q4rC50CNxcOD+wLHrR1vYGpoY9t4dXqOGtiOTFcOpQ2b7ezxQq8MKKVV1d
         G1WyKMpwHWB6LR/2iP7cGn2vmN3+2UDTXu8L40du/ruS8ujGj2mrJ/8XSqO3aC6GQLL6
         RsYQ==
X-Gm-Message-State: AOJu0Yz086mjeLLop46xU6QMSUKfKJQjAlgrVpWsG7lFBxI1oPvXVzA6
	A1nUzkDRCm/Hj0ILzewOI2ScnGpMBh8XxRJSrNvJntTzEbIqcYZA5EF2DEw97xjRFT0=
X-Gm-Gg: AfdE7clT/iQzcYzLpgY1VX33PuTyYXKUADWdtwfs9uC1Ab4wuz2o4JF43AsxBybA6pr
	GwTRjQRuR58Pzu5WYv+5JZ1bZCQFRBbKISbX5IkIb3nzcio3JyZTSckBj9MlqJsjNNh4ZnZKJJw
	5gvanACR2woMZw6QBCyD+s4QBx4I62alUG/rDrGIgMvGmM4+WmQGo073av2DPCFgxwX7KmrWhlk
	zOgimABIQDuLN7L6nKt4Cdzv0444/mELBYLKIT7mURV4igpZSdSCehiTsbGQ6srv5GqFqLs9Yzm
	mdIONSH5za1n4ZCExt9c0BU9QlIyrsI3nkqLG2MAOc1qhW5lA1wWPBR6C3vhoFcnEDk9BsF95wU
	47Wfr2EnqN0I+/TOshaGknyTuNQbP8oeL3Cx0vsTvzPedL8jH3qJ99hhGwiEJxg8HYjVcfXVhVf
	FGtLvPlIhvXy1llhjaEABaM07c3yVulSVfesCbhVhkVZ4=
X-Received: by 2002:a17:903:2281:b0:2c7:c5b2:3d81 with SMTP id d9443c01a7336-2c7c9a831b3mr33165335ad.31.1782232173557;
        Tue, 23 Jun 2026 09:29:33 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743bfdc97sm135185485ad.65.2026.06.23.09.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:29:33 -0700 (PDT)
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
Subject: [PATCH v6 10/17] cifs: register a shrinker to manage cached_dirents
Date: Tue, 23 Jun 2026 21:59:03 +0530
Message-ID: <20260623162910.343930-10-sprasad@microsoft.com>
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
index 834859fbd527d..fd725ee4293b6 100644
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
index 008b1d3732458..a5bf711e4de7a 100644
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
2.43.0

