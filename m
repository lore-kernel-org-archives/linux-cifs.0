Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7633A0E84
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634446; cv=none; b=JmNMYiYSGkWzo5S5jc7Mwa/3M0XFkCKwZCES6M+vg+xNFhXOLKumeNt3YlNYyLDPn8RNwF+C/hgcoNcKNEuhEWUJmvEpikxA4LTuW86U78+ovTh5Im5ShKYy+dn/8wGt9eJEy7LTmhAYiYsmGMRwLDtB6jQ1AK663n6Ud6wiQ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634446; c=relaxed/simple;
	bh=dqM+OIMm/FolEhXWiZwlX21e6UtqoaVlDP5evwvYHl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFP/sYzDNJlV34UGVAOmI1shk4ChctquE4hhmUVULqmmczmhmdft6XsxM8wlBDOarAVb3eqEYuDIREy27xxhfMH13Xvd+3ykHM5Li9TyvriDKMUpAZy6tJHc57/H2X9thfJUWIjC2matN8apHTki6BCdDLFAU6FAbdsj6SPUkjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KwqsABLc; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KwqsABLc"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82f8893bff3so904222b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634444; x=1778239244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WzzvatsWQlTBCszh4aTpD+tIu471HTtNRSO4+Bzjhio=;
        b=KwqsABLcYAq6anZeOdt+gxViMaZGPNBhOFSsf4MPHzzlF2/CQgXaKwcqbchdNgUkqS
         A2yjQqpNoyiSmrdHJHCNBBok2IZfsahEuvGP5VzAGshW+gD9I1bP0oVESuriI3lSN9gB
         +ALP1MVLd2I7uPokPIspTsBmwigLv9u2gbh8Ka5EmezX0NJjlh1Yycce1nl30Kmf2ylV
         T6ZOmMrpkxGvqOv/dzqiagj9cZ+To8nRznfD6obPY3NsFfgBQaAW4hZVJoD7juYhyENN
         xENTP/PwfaIpsE8RCG8NdKsCCJ5L69EA83jWHeVeGA9hFkhU7vgmpIsGk+vcVBrBudSd
         2BsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634444; x=1778239244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WzzvatsWQlTBCszh4aTpD+tIu471HTtNRSO4+Bzjhio=;
        b=mBcalkCVGGq0vYtBrEG9JqHTJURx1CccGGCAPgjbDJM1tt6fPpoEAKZ0ADeLAdTwVJ
         Jdyiqh9dOmMXPlT+vb/A0jiiBTUFfW6YurR+LqNst7++A3r5yX/mhoIukqxqT8dS8w6k
         uLuXXqx/1de7sNmWMCM86vI3bGlB0tgvwd6m52UDWBErHSHKGtv5RpDthdLpBnM/CbvV
         u3SuhO/iFG52JkJu8ciJvLL62Dvb9H2hohxehIGbdKFCM6VxFHpdARJ/jVIoyQMg47Fj
         PraUwtE75PHsevd9Fty5+YropjYUzvRgD2d1MGpYTnPmqy8CBwV8JJbMW6AqjaX1cdxI
         7XSg==
X-Gm-Message-State: AOJu0YxetaIgaaWZnU5euIzfp4s8QJsCor+kMA1bD+v7qQbYpL+Rbqo9
	6wPsaa6i/d8wfdQcPqLjFkUQNiJthlt4CcNCvYGC3ts+vr7quDTpl5NpKwl7JCroG88=
X-Gm-Gg: AeBDietek4kVaVAppeX5FVemuMHtYUn/JEvGvCpXHVO4YmUfEZTTxU7+UbC7wG5DOZH
	MEx/L122MSTUcSzPAGqMl7NRrUD4nLygjVDgZQZyYhvw49BJDJxShuj1Ru7gc5Go0nzpo6oC92O
	8VlhVrh9yLNgzyUV8KmTZen1qEFDN/Gll2UmDhbMMXbX6MXbZEiI8ta7TRB2J6z82gM3sy49ffj
	56C//xkV6D/fHOyhsu/kkFbXp5VUCzRyRQPJA9MbdwsH+mDqUvsR/aHMq1KDSgPiQQ6F6IlQQzV
	SRACJ2YO5H2/M+BJ4ssS7yV9PkS0NPdJSFiCMAIETn3VuJ5p2gTwJuCP/WMZGFfRen1lUdeqvrJ
	8scaPBswQv35u47R/Zu6c1izTydzCUvobOXeu+yQHtcvEe+l1YTLstcGEaBfCrO4sNk0Fg29wsO
	uA5ROccLo9vgwghAqe7aP6ovpZRo6SGcu1aDT9O6Y444NBmzwI/zYl9xvnzA+PGuiY
X-Received: by 2002:a05:6a00:14cc:b0:82f:120:fd6f with SMTP id d2e1a72fcca58-83519e75592mr2826383b3a.0.1777634444507;
        Fri, 01 May 2026 04:20:44 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:43 -0700 (PDT)
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
Subject: [PATCH v4 12/19] cifs: register a shrinker to manage cached_dirents
Date: Fri,  1 May 2026 16:50:15 +0530
Message-ID: <20260501112023.338005-12-sprasad@microsoft.com>
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

Since the cached_dirents are now backed by folioq, we do not need
a timed cleanup of these cfids anymore. This change registers a
shrinker with the mm layer for the dircache. If mm needs to free up
memory or flush the cache, it can inform cifs about this using the
shrinker interface.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsfs.c | 86 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 80 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 32d0305a1239a..ee5de358e27f8 100644
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
@@ -123,27 +124,86 @@ MODULE_PARM_DESC(dir_cache_timeout, "Number of seconds to cache directory conten
 				 "Range: 1 to 65000 seconds, 0 to disable caching dir contents");
 /* Module-wide total cached dirents (in bytes) across all tcons */
 atomic64_t cifs_dircache_bytes_used = ATOMIC64_INIT(0);
+static struct shrinker *cifs_dircache_shrinker;
 
 /*
  * Write-only module parameter to drop all cached directory entries across
  * all CIFS mounts. Echo a non-zero value to trigger.
  */
-static void cifs_drop_all_dir_caches(void)
+static unsigned long cifs_drop_all_dir_caches(bool wait, unsigned long nr_to_free)
 {
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
+	u64 before, after, freed_bytes = 0;
+	u64 target_bytes;
+
+	before = atomic64_read(&cifs_dircache_bytes_used);
+	if (nr_to_free == ULONG_MAX)
+		target_bytes = U64_MAX;
+	else
+		target_bytes = (u64)nr_to_free * PAGE_SIZE;
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 			if (cifs_ses_exiting(ses))
 				continue;
-			list_for_each_entry(tcon, &ses->tcon_list, tcon_list)
-				invalidate_all_cached_dirs(tcon);
+			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+				invalidate_all_cached_dirs_nowait(tcon);
+				after = atomic64_read(&cifs_dircache_bytes_used);
+				if (after < before)
+					freed_bytes = before - after;
+				if (freed_bytes >= target_bytes)
+					goto out_unlock;
+			}
 		}
 	}
+out_unlock:
 	spin_unlock(&cifs_tcp_ses_lock);
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
+	freed_bytes = cifs_drop_all_dir_caches(false, max_t(unsigned long, 1, sc->nr_to_scan));
+	if (!freed_bytes)
+		return SHRINK_STOP;
+
+	return DIV_ROUND_UP_ULL(freed_bytes, PAGE_SIZE);
 }
 
 static int cifs_param_set_drop_dir_cache(const char *val, const struct kernel_param *kp)
@@ -154,7 +214,7 @@ static int cifs_param_set_drop_dir_cache(const char *val, const struct kernel_pa
 	if (rc)
 		return rc;
 	if (bv)
-		cifs_drop_all_dir_caches();
+		cifs_drop_all_dir_caches(true, ULONG_MAX);
 	return 0;
 }
 
@@ -2038,10 +2098,19 @@ init_cifs(void)
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
@@ -2083,8 +2152,11 @@ init_cifs(void)
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
@@ -2117,6 +2189,8 @@ exit_cifs(void)
 	cifs_dbg(NOISY, "exit_smb3\n");
 	unregister_filesystem(&cifs_fs_type);
 	unregister_filesystem(&smb3_fs_type);
+	shrinker_free(cifs_dircache_shrinker);
+	cifs_dircache_shrinker = NULL;
 	cifs_release_automount_timer();
 	exit_cifs_idmap();
 #ifdef CONFIG_CIFS_SWN_UPCALL
-- 
2.43.0

