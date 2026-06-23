Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77D3306757
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 16:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782232179; cv=none; b=CwLoC1bWb/FT5tGBQZ721zKIEidLPuii96KI5zauu/1FACQmXLE1E9PZ9FFCiC9iJG5GAt+1U0YgufCXRqgaXMjCO+MVSC7jU2xIHkcKYwRrbBiAz/VShnij8DsNwo3huXpB2OP9mOZ9YgU1VNHwUC2n4xfVA8utzMEX2oViEek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782232179; c=relaxed/simple;
	bh=JQCaQ1XdyfgUr2uMXcDc+nhN5xmm8lKQJ165H+1+oCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUmxffM6SogsiEiPRoAURZlF8ACluz/K9+30reLf/TSEWES6qjAae7JQERB/JRbxgLAvbqIIJnwWHbJYHWFaV5AeyJdGQ/Ywksri+ZKZKLohem49AuZEQYLjEdsuDmM5819bJDXAmtD7gmxcvUZQlhJ5Xg3Gd4BHLvNvtCXXYL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FKNZme5F; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKNZme5F"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-37c5b9d42efso758176a91.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 09:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782232177; x=1782836977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/7jmGVL/sMRgY/DJaG90IzYGNZg1L8WRe/kLftly94=;
        b=FKNZme5Fj5svcWTuKl7L8ndjzmuZ3scCrRrjznwKh7TBvVxqQNMPfxq+oLPOriEpf0
         qFbm8AWFUxNCKkMM+XwyZynumjB2caPtKFkrXnJUopuUoJAbQpgeF87eKodEUlr/mw2o
         j4y0amA45bFfog4nX3miKFZHcggZBRHB4h++AEkuNFSG9L86tF7MFW4dKSsCbn114O7Z
         pD29LwvJoc4EV/Caqvu1iInXPmj9mFxVlJxkRUBeyk/kUu/6lRlYjEb8AHtV1bxIBiRQ
         GkbKE7w2HuaDE0+PjkgiqWKn/s5BnE2Ii95pGaLLh8A4OKYDn8JnALg6pahy+DEGdUFN
         DvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782232177; x=1782836977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u/7jmGVL/sMRgY/DJaG90IzYGNZg1L8WRe/kLftly94=;
        b=jKO3VUXzUfC6bTj59tZpphwx0hjT062DOo8rtOA9Ln+6QrDbdo/MeF5es0ilBsJxuM
         cyXZw+D1e4RPP/lUcwKks3lMPR5QycWcvVAApOorKdLqR1vkT9BBSrURFeqU3kKH+SHK
         nC9ZOds2ocufRWuR92wHrp8Xd7K1yU0Myv0PxzweMSgl73rSq6MDHPz2eTfdzf3EHOMi
         5RKiGpm4HmVaejh3NzAH7U2HMzhqx5baF3ggHUiOkMDcYm5aDWogwQjL9ZItdeKeX2a5
         6pMcTIHsTVhb4lDgy9GaxQ9JsamFFsz5wHL0y+Gf/1xJQUJ+NhumFJE0H1pxdyV2aBFi
         rEXQ==
X-Gm-Message-State: AOJu0Yw2/vioZCUWMQhMzCmSaz+MM7Hb3Ikm4X3Y081w4/IyAypdOElN
	CTv/31r66RXyB2E6tqV5zU7bhgxxl0v/C8b6fwh+Lnz/GzVtiqOhNy8WGb+j3E00zsk=
X-Gm-Gg: AfdE7cnvL0QeeC5Z0L3fx+JN0kLAxq/A02+NxxEVkEze8u5TeTRFJ1KqGGZ1zpIjO7k
	rHMx5mBcDCUAIjz5Mc1cxRbw8ziODcyOj2Nj/FgyhpvjVnJxpAxqv313EXPEZUJkIrOKMkHchFX
	Itx8pAG72Twd0+VCP3kmnjRy9qiHQUd4NzYUXbft0GpRLmc6cmyd6IujeIbkWl65sS17+wKMwJ8
	DXAsvQ6mrIn1w4msgi4gKHV7dM2RA2lq9R9b0E0ZxRiGUzlGvVHzobOIoY4Y2svDTf8v1EBn6WY
	PQYcIh1HD5nUca23tz2fDg28Y9htkQQ0iu0VKeghUIoU4NTeNFxCOKOMu6Rf7u/kCYM8sYWW3bs
	cZg9w39EHCq3tun+QMkISDjlncizwnFSFIFR3iAvOZv+kpbi28ah6SEzX3M4U19L2rKmZx/2elV
	TqZI1o6KjfN3d0HT/0gANG30iY2mXp8Fb5ejFwhuVNEaE=
X-Received: by 2002:a17:903:946:b0:2c7:c385:c5a7 with SMTP id d9443c01a7336-2c7c400fd16mr34504485ad.26.1782232177063;
        Tue, 23 Jun 2026 09:29:37 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743bfdc97sm135185485ad.65.2026.06.23.09.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:29:36 -0700 (PDT)
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
Subject: [PATCH v6 14/17] cifs: trace points for cached_dir operations
Date: Tue, 23 Jun 2026 21:59:07 +0530
Message-ID: <20260623162910.343930-14-sprasad@microsoft.com>
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

This change introduces ftrace tracepoints for cached_dir operations.
Intended to be used for debugging cached_dir.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 21 ++++++++++-
 fs/smb/client/inode.c      | 13 +++++++
 fs/smb/client/trace.h      | 73 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index ecdc6907cf6d1..389695b203247 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -1010,6 +1010,7 @@ bool add_to_cached_dir(struct cached_fid *cfid,
 		atomic64_sub(-bytes_diff, &cfid->cfids->total_dirents_bytes);
 		atomic64_sub(-bytes_diff, &cifs_dircache_bytes_used);
 	}
+	trace_smb3_add_to_cached_dir(cfid, name, namelen, added ? 0 : -1);
 
 
 	return added;
@@ -1040,6 +1041,9 @@ void complete_cached_dir(struct cached_fid *cfid,
 	cde = &cfid->dirents;
 	mutex_lock(&cfid->dirents.de_mutex);
 	finished_cached_dirents_count(cde, ctx, file);
+	trace_smb3_complete_cached_dir(cfid, ctx->pos, cde->pos,
+					 cde->is_valid,
+					 cde->is_failed);
 	mutex_unlock(&cfid->dirents.de_mutex);
 }
 
@@ -1075,12 +1079,14 @@ int lookup_cached_dir(struct cached_fid *cfid,
 	entry = lookup_cached_dirent_entry_locked(&cfid->dirents, name, namelen);
 	if (!entry || !entry->dirent) {
 		mutex_unlock(&cfid->dirents.de_mutex);
+		trace_smb3_lookup_cached_dir(cfid, name, namelen, -ENOENT);
 		return -ENOENT;
 	}
 
 	dirent = entry->dirent;
 	if (dirent->tombstone) {
 		mutex_unlock(&cfid->dirents.de_mutex);
+		trace_smb3_lookup_cached_dir(cfid, name, namelen, -ENOENT);
 		return -ENOENT;
 	}
 
@@ -1088,6 +1094,7 @@ int lookup_cached_dir(struct cached_fid *cfid,
 	memcpy(&result->fattr, &dirent->fattr, sizeof(result->fattr));
 
 	mutex_unlock(&cfid->dirents.de_mutex);
+	trace_smb3_lookup_cached_dir(cfid, name, namelen, 0);
 	return 0;
 }
 
@@ -1125,6 +1132,8 @@ bool update_dirent_in_cached_dir(struct cached_fid *cfid,
 	updated = update_cached_dirent_locked(&cfid->dirents, name,
 						      namelen, fattr);
 	mutex_unlock(&cfid->dirents.de_mutex);
+	trace_smb3_update_dirent_in_cached_dir(cfid, name, namelen,
+					      updated ? 0 : -ENOENT);
 	return updated;
 }
 
@@ -1184,6 +1193,7 @@ void cifs_complete_pending_dcache(struct cached_fid *cfid,
 	mutex_unlock(&cfid->dirents.de_mutex);
 	cifs_dbg(FYI, "Dcache population of %.*s. status: %d\n",
 					namelen, name, ret);
+	trace_smb3_dcache_complete(cfid, name, namelen, ret);
 }
 
 /*
@@ -1225,6 +1235,7 @@ int cifs_wait_for_pending_dcache(struct cached_fid *cfid,
 		}
 	}
 
+	trace_smb3_dcache_wait(cfid, name, namelen, ret);
 	return ret;
 }
 
@@ -1399,6 +1410,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (cfid == NULL) {
 		spin_unlock(&cfids->cfid_list_lock);
 		kfree(utf16_path);
+		trace_smb3_open_cached_dir(NULL, path, strlen(path), -ENOENT);
 		return -ENOENT;
 	}
 	spin_unlock(&cfids->cfid_list_lock);
@@ -1637,6 +1649,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
 	}
+	trace_smb3_open_cached_dir(cfid, path, strlen(path), rc);
 	kfree(utf16_path);
 
 	if (is_replayable_error(rc) &&
@@ -1651,7 +1664,6 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 			      struct cached_fid **ret_cfid)
 {
 	struct cached_fid *cfid;
-	struct cached_fid *trace_cfid = NULL;
 	struct cached_fids *cfids = tcon->cfids;
 	int rc = -ENOENT;
 
@@ -1667,6 +1679,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 			spin_lock(&cfid->cfid_lock);
 			if (!is_valid_cached_dir(cfid)) {
 				spin_unlock(&cfid->cfid_lock);
+				rc = -ENOENT;
 				break;
 			}
 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
@@ -1677,10 +1690,15 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 			trace_cfid = cfid;
 			spin_unlock(&cfid->cfid_lock);
 			spin_unlock(&cfids->cfid_list_lock);
+			trace_smb3_open_cached_dir_by_dentry(cfid, dentry->d_name.name,
+							 dentry->d_name.len, 0);
 			return rc;
 		}
 	}
 	spin_unlock(&cfids->cfid_list_lock);
+	trace_smb3_open_cached_dir_by_dentry(NULL, dentry->d_name.name,
+					     dentry->d_name.len, rc);
+
 	return rc;
 }
 
@@ -1969,6 +1987,7 @@ static void free_cached_dir(struct cached_fid *cfid)
 
 	WARN_ON(work_pending(&cfid->close_work));
 	WARN_ON(work_pending(&cfid->put_work));
+	trace_smb3_free_cached_dir(cfid, cfid->path, strlen(cfid->path), 0);
 
 
 	dput(cfid->dentry);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 631f5fae813b7..a139af232bf00 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2860,20 +2860,31 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 			if (!rc && lookup.found && lookup.under_active_lease) {
 				if (cifs_inode_has_writable_handle(inode)) {
 					cifs_set_time(dentry, jiffies);
+					trace_smb3_dcache_revalidate(cfid,
+							 dentry->d_name.name,
+							     dentry->d_name.len, 0);
 					cifs_put_tlink(tlink);
 					return false;
 				}
 				rc = cifs_fattr_to_inode(inode, &lookup.fattr, false);
 				if (!rc) {
 					cifs_set_time(dentry, jiffies);
+					trace_smb3_dcache_revalidate(cfid,
+							 dentry->d_name.name,
+							     dentry->d_name.len, 0);
 					cifs_put_tlink(tlink);
 					return false;
 				}
 				if (rc != -ESTALE) {
+					trace_smb3_dcache_revalidate(cfid,
+							 dentry->d_name.name,
+							     dentry->d_name.len, rc);
 					cifs_put_tlink(tlink);
 					return true;
 				}
 			}
+			trace_smb3_dcache_revalidate(cfid, dentry->d_name.name,
+						     dentry->d_name.len, rc);
 		}
 	}
 
@@ -2883,6 +2894,8 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	 * cache lookup/update did not satisfy this dentry.
 	 */
 	if (force_reval) {
+		trace_smb3_dcache_revalidate(cfid, dentry->d_name.name,
+					     dentry->d_name.len, -1);
 		cifs_put_tlink(tlink);
 		return true;
 	}
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 9e120d6fe51cf..145d537ed17d5 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -1959,6 +1959,79 @@ TRACE_EVENT(smb3_eio,
 		      __entry->info, __entry->info2)
 	    );
 
+/*
+ * Trace events for async directory cache population work
+ */
+DECLARE_EVENT_CLASS(smb3_dcache,
+	TP_PROTO(const void *cfid,
+		const char *name,
+		int namelen,
+		int result),
+	TP_ARGS(cfid, name, namelen, result),
+	TP_STRUCT__entry(
+		__field(const void *, cfid)
+		__string(name, name)
+		__field(int, namelen)
+		__field(int, result)
+	),
+	TP_fast_assign(
+		__entry->cfid = cfid;
+		__assign_str(name);
+		__entry->namelen = namelen;
+		__entry->result = result;
+	),
+	TP_printk("cfid=%p name=%.*s result=%d",
+		__entry->cfid,
+		__entry->namelen, __get_str(name), __entry->result)
+);
+
+#define DEFINE_SMB3_DCACHE_EVENT(name)          \
+DEFINE_EVENT(smb3_dcache, smb3_##name,    \
+	TP_PROTO(const void *cfid,		\
+		const char *name,		\
+		int namelen,			\
+		int result),			\
+	TP_ARGS(cfid, name, namelen, result))
+
+DEFINE_SMB3_DCACHE_EVENT(dcache_complete);
+DEFINE_SMB3_DCACHE_EVENT(dcache_wait);
+DEFINE_SMB3_DCACHE_EVENT(dcache_revalidate);
+DEFINE_SMB3_DCACHE_EVENT(open_cached_dir);
+DEFINE_SMB3_DCACHE_EVENT(open_cached_dir_by_dentry);
+DEFINE_SMB3_DCACHE_EVENT(free_cached_dir);
+DEFINE_SMB3_DCACHE_EVENT(add_to_cached_dir);
+DEFINE_SMB3_DCACHE_EVENT(lookup_cached_dir);
+DEFINE_SMB3_DCACHE_EVENT(update_dirent_in_cached_dir);
+
+TRACE_EVENT(smb3_complete_cached_dir,
+	TP_PROTO(const void *cfid,
+		 loff_t ctx_pos,
+		 loff_t cached_pos,
+		 int is_valid,
+		 int is_failed),
+	TP_ARGS(cfid, ctx_pos, cached_pos, is_valid, is_failed),
+	TP_STRUCT__entry(
+		__field(const void *, cfid)
+		__field(loff_t, ctx_pos)
+		__field(loff_t, cached_pos)
+		__field(int, is_valid)
+		__field(int, is_failed)
+	),
+	TP_fast_assign(
+		__entry->cfid = cfid;
+		__entry->ctx_pos = ctx_pos;
+		__entry->cached_pos = cached_pos;
+		__entry->is_valid = is_valid;
+		__entry->is_failed = is_failed;
+	),
+	TP_printk("cfid=%p ctx_pos=%lld cached_pos=%lld is_valid=%d is_failed=%d",
+		__entry->cfid,
+		(long long)__entry->ctx_pos,
+		(long long)__entry->cached_pos,
+		__entry->is_valid,
+		__entry->is_failed)
+);
+
 #undef EM
 #undef E_
 #endif /* _CIFS_TRACE_H */
-- 
2.43.0

