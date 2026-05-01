Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D5839FCB4
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634452; cv=none; b=XyX7Nje0SDpgg6F4bPPOYlKUg4wRxbbX68J8jYfWFoiimLQQWad8lzNVLLZW+r46cjuB2ile+hL9erZyKNZcaST70dMGHpYTviOGVYC7U+HKNrB+AR2NHpifBX7+98LbV/Xew5VT80vrovY9RrCeBSNscltsTFRPN9UcBfSy/SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634452; c=relaxed/simple;
	bh=MdJ8m3r5V6Rvr2rTIpFa9hpgg2l/LBzYWlBo+7IApZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6STzxtbybjUpu91gfotQlB3MYcHNmoYbKmCQ3GJ5zMV55bPz6J0w6LKgTRArTe1jlydpTGzZvPnZIHOnmxh+wfIB75iuzlLetnMbIVmFZ8p2vr1dw3pCiglHcPKRTbpe779JH7s6EodncBPdymspLHrJqBv7EJqrmHSkSEAmnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CPct0nfy; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPct0nfy"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c7b9f54d3deso1124035a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634450; x=1778239250; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nEBzsKVOccaRuqwJVltSCg/NMccRGqheY7hvQNJsWpw=;
        b=CPct0nfyIIMdaUeNHL2eSb+xD+MRrPEPN8L3M+mmAiDXkUqAZI5b0UV06AAUvYlmAU
         iyiP47Uc105CQGzIhJdFccJB9tU8NF53tN+uadCpbUI+7FqEs4PJGmPMlp5FF76XrKxs
         RAo0Ci0+HABlNfXoyCuETgeoBky0rRzWMAJNhaU2p73hn6hR2y5qzQsdSNmS6afYbzj0
         JCPU+QcWqupFwIc4vBoQanrEAUbwLHRcKJ+1M2K8nvkKCIpBgRL+5dJak74icK0cSIlC
         RuMLOVfFK57TlwJf6d4rTUZicgQrkrRjh6Hdq0ENRoVdobvSGVHe21MVFj7s9hjt5NJ7
         5sFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634450; x=1778239250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nEBzsKVOccaRuqwJVltSCg/NMccRGqheY7hvQNJsWpw=;
        b=GFPBRJl4liFBxI9W2FyL8BsAaGQkU89fJ2UL46Ol0IEBLFd9MnUwWUTzBCka9DJplb
         mm0CYQ9Ap56ZAa2Y8pLBICOnQUSHt6QWCfLF7wP9KikoUzAlvVuqV6l4wpKZ/MjjpNVf
         VcsDZmf39VT10oQ3AzhWczRNeQkRak4al5vBkkJ9hZeHbynRA2lerNus++gwoVfz4nQX
         8Li/mSxpXYafv5P+8rY2yBNmJFhNvwIqcWmesmOLzHUFKHb4iqC7EI9Hpx0BPUqn98W5
         reMAEueZnypCnz+E3ERhLJaXgplBW1R3YXk1J0QzyILkSzJe6ofaKZB/HP0LplUt1j88
         mwkw==
X-Gm-Message-State: AOJu0YxDSh9uTpGoDOnPPXk4msGDXBHX4cp//cfjRustBN7ExZCOu2tV
	lQe6XcfbLrjKqKjX1VDBhRvzo9YTK0CQtVd+RRsvyiUUdsiQnqjNMRQlBOGoh4wZLEY=
X-Gm-Gg: AeBDiet7DJqdRJkv/Rn+H5M61jNvz/12odcNxILWpwJV2YZ4KprZs4d/bzn4Oo5Tmqo
	d8eCQe05kqQ5fvk3GllK+hA2HjFEGwIzR/VY8V4Kn4DSOa49104JIHqDRtRpp0iGXqq91czlkUI
	TUFvia+n1v8nEkbKDQMELYEWpRhh9D03X/JpBgNW090pQkPezXxpsS6iMccTzjXQe041GPh1J1r
	6ELl7CB/DbCNNijrv4zT/tQ4EL9EwTeiWSoL1O5wMVYPELaoyW3jaRyoLMuT+oxrmIw34f54B3a
	1y/RzJ/dO8NgV6Snwo5Qe2ow14ue/KxZ3buuuIgcNG9v6k/+rv1HvaB7s/RrIQqwlLx/+lkKi9G
	BTfrEWGbO8uPMPADFScDG9LriX2FnK52cYfWAsck7Ats/SdSk0PsVFx1MVULACZbnAMoEWhBUda
	5lNXGNTjNWO09yjbvkzhHkNZWdd2alK8bb5MgSk38N9va2k2/COgKpB1f/BzZ3zgrK
X-Received: by 2002:a05:6a00:f0a:b0:82f:5051:f022 with SMTP id d2e1a72fcca58-834fdbd3eddmr7678466b3a.32.1777634449377;
        Fri, 01 May 2026 04:20:49 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:48 -0700 (PDT)
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
Subject: [PATCH v4 16/19] cifs: trace points for cached_dir operations
Date: Fri,  1 May 2026 16:50:19 +0530
Message-ID: <20260501112023.338005-16-sprasad@microsoft.com>
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

This change introduces ftrace tracepoints for cached_dir operations.
Intended to be used for debugging cached_dir.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 21 ++++++++++-
 fs/smb/client/inode.c      | 13 +++++++
 fs/smb/client/trace.h      | 73 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 863b8d666ea95..6fb88c4c97dc1 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -1011,6 +1011,7 @@ bool add_to_cached_dir(struct cached_fid *cfid,
 		atomic64_sub(-bytes_diff, &cfid->cfids->total_dirents_bytes);
 		atomic64_sub(-bytes_diff, &cifs_dircache_bytes_used);
 	}
+	trace_smb3_add_to_cached_dir(cfid, name, namelen, added ? 0 : -1);
 
 
 	return added;
@@ -1041,6 +1042,9 @@ void complete_cached_dir(struct cached_fid *cfid,
 	cde = &cfid->dirents;
 	mutex_lock(&cfid->dirents.de_mutex);
 	finished_cached_dirents_count(cde, ctx, file);
+	trace_smb3_complete_cached_dir(cfid, ctx->pos, cde->pos,
+					 cde->is_valid,
+					 cde->is_failed);
 	mutex_unlock(&cfid->dirents.de_mutex);
 }
 
@@ -1076,12 +1080,14 @@ int lookup_cached_dir(struct cached_fid *cfid,
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
 
@@ -1089,6 +1095,7 @@ int lookup_cached_dir(struct cached_fid *cfid,
 	memcpy(&result->fattr, &dirent->fattr, sizeof(result->fattr));
 
 	mutex_unlock(&cfid->dirents.de_mutex);
+	trace_smb3_lookup_cached_dir(cfid, name, namelen, 0);
 	return 0;
 }
 
@@ -1126,6 +1133,8 @@ bool update_dirent_in_cached_dir(struct cached_fid *cfid,
 	updated = update_cached_dirent_locked(&cfid->dirents, name,
 						      namelen, fattr);
 	mutex_unlock(&cfid->dirents.de_mutex);
+	trace_smb3_update_dirent_in_cached_dir(cfid, name, namelen,
+					      updated ? 0 : -ENOENT);
 	return updated;
 }
 
@@ -1185,6 +1194,7 @@ void cifs_complete_pending_dcache(struct cached_fid *cfid,
 	mutex_unlock(&cfid->dirents.de_mutex);
 	cifs_dbg(FYI, "Dcache population of %.*s. status: %d\n",
 					namelen, name, ret);
+	trace_smb3_dcache_complete(cfid, name, namelen, ret);
 }
 
 /*
@@ -1226,6 +1236,7 @@ int cifs_wait_for_pending_dcache(struct cached_fid *cfid,
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
 
@@ -1982,6 +2000,7 @@ static void free_cached_dir(struct cached_fid *cfid)
 
 	WARN_ON(work_pending(&cfid->close_work));
 	WARN_ON(work_pending(&cfid->put_work));
+	trace_smb3_free_cached_dir(cfid, cfid->path, strlen(cfid->path), 0);
 
 
 	dput(cfid->dentry);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index ecc92e5c7f7b6..08cf0cfcda89b 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2859,20 +2859,31 @@ cifs_dentry_needs_reval(struct dentry *dentry)
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
 
@@ -2882,6 +2893,8 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	 * cache lookup/update did not satisfy this dentry.
 	 */
 	if (force_reval) {
+		trace_smb3_dcache_revalidate(cfid, dentry->d_name.name,
+					     dentry->d_name.len, -1);
 		cifs_put_tlink(tlink);
 		return true;
 	}
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 54ee1317c5b12..9907a89ee4001 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -1813,6 +1813,79 @@ TRACE_EVENT(smb3_eio,
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

