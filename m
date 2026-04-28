Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFBB44CF54
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392513; cv=none; b=Ty/S27PkznqJ933M+n4o66xYmLF0R04HgWDTeG4j348hOYMpgVGdWInzpomLdXo76WUKG4nOOskGq2xtWKiAOugLL7remTebTob2tJ2Qs35MgkhClU+2UPeftO45QyaVWGkgqOifeR4eCGt/yKG8/nQEdbrxEkIQ8YUvhh7wC3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392513; c=relaxed/simple;
	bh=dqM+OIMm/FolEhXWiZwlX21e6UtqoaVlDP5evwvYHl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITahQfaJGy5/XLcEM7qXdTsc5ywnaswe0d7RKbAnnVY2JmkUQsUKJzp2FHeiKCh85yaTdp5fdyY3ZvylxahjTahenhYzplqQXdgYEQBnj86y/nxZ0VvATWhwEgPwrtT7QyjtE2s1aSDpHkLFyzg/IMYzEF2Dg0aWWsdisxlb5js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rWqqXbxr; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rWqqXbxr"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b7adb38d65so52854995ad.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392511; x=1777997311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WzzvatsWQlTBCszh4aTpD+tIu471HTtNRSO4+Bzjhio=;
        b=rWqqXbxrvjbe5AfR/jkbLhm5Yiw+ufmyKYbOUzZDcqiXvpsD2gxYL4YJgREzc9sGs7
         BJfKFPldga2dZR1U1mREmsygKw7+4JIX8FQbG0dHAyGc+C0YhBUY0ZkaXeaojuiwi227
         9x0X3i6Qpt+q7XH/7HIjIXHNYtBiPMIJhIGIIKmlT6oYxu8NGlnoxZb6Ou+yxQTdtot1
         RmgFc5Bb3pqQQqe9MoDqp6hWvcfp58rtQYIsr89abSLkxO6yWFSo3KYC9x3KIEj+aDrx
         s/mXNfOzQpy9vzcqJkOvQlCrksEP2GYW++Vd4Z7fKaaX0GyefAFB50bE1E8+EZGqSvmT
         X0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392511; x=1777997311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WzzvatsWQlTBCszh4aTpD+tIu471HTtNRSO4+Bzjhio=;
        b=Jn/+0v7jUqA0ql/4Eyz+VCPs2JuIR1JOdea9LvNqGRBk9lmvya1e2cLsPKqBzujiO1
         nC8JiImFEeBzfvlOdsM9eiANcVejI/tLYbUv/Eft1eNC12l0SaOmQR+weJJfcXcX6JJQ
         Jfw/DOQfiWPHmIFhPNY7hYUPWH8obe6vNo0wI213yJbOw3/n/YnbF7xqEhPVeZuor843
         gpGf9MvVcy6q7qJ6ALguuLeg0fuVPFvWRKSxrB/qMgOvZGqK6FA7zKE+R1H5oSSNPfWJ
         oUnvr+7IN/EyOxOwG42FCb1ZJq8SdMTDVritr9K1EFFeI7D3QYIwzqDrsV/YExHkc9ci
         /RDQ==
X-Gm-Message-State: AOJu0YyjY68IsJEmvswREWBzMP9aSUH6H4iH9Bp6maxMZP4cP6Dlt9zc
	KIU5aw/WbF6xDBThgO6OqllcDxTv4Vxf8Ki8S5iv5nGx1ZDPQiyfGGLpkrTBpd/StDM=
X-Gm-Gg: AeBDietT/Vv/AlIFhuY7719bWSd5wq0mLTXSSTuU/HC9VSqygN2rJB2zLmkmQ8K3fmg
	Gsvi6xkAi7PbcYABdbHPCb0cCKN+HaXqiU+1elgafJmFczXoPxuncoOagF5ln3uX/qxQmSCyL/9
	qyAm0WzR5iUUzZ9F09vyvuiHeqB0mwaco2RdhktSVXdGROUqF7kiA7jPml1x1PS6o0btLhzhWeP
	0YlYupX353eAIvWzkMy55vzRxvZzl2y7H9lhOuhae7JGzHdp28ljapJzn3opR4wCXRtlfCCOCp8
	qLP1Z0+teXGjBsfDrdWtiNQHBsAmv+ijz/P/xsyka5ewnlQ2p8wQRPWdlXRW4j3BLixD+l2ODtE
	f6/9lktWdlwC0IR7iAykx3gc/KJr3023fbuGZACo0S634EEX0Hmw5inh0jL1s74Su8046npbK9/
	ElgZ7SKGHASPVQRd0Kz1gyRcnE+nVOqvc/OgdsO3DCr00eq785FzRmoiK8gAsPbk3kLnfGPvcR0
	10=
X-Received: by 2002:a17:903:1205:b0:2b2:4f43:b48c with SMTP id d9443c01a7336-2b97c400b5amr37328515ad.14.1777392510463;
        Tue, 28 Apr 2026 09:08:30 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac7894csm30864465ad.50.2026.04.28.09.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:08:29 -0700 (PDT)
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
Subject: [PATCH v3 12/19] cifs: register a shrinker to manage cached_dirents
Date: Tue, 28 Apr 2026 21:37:57 +0530
Message-ID: <20260428160804.281745-12-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428160804.281745-1-sprasad@microsoft.com>
References: <20260428160804.281745-1-sprasad@microsoft.com>
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

