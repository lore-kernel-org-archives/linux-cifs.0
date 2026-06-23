Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A5A13790B
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246048; cv=none; b=rbfsVw0aQPRQw67Q/+QwTBpZh9uwf5sMQekyotyR7tXfRRrciYV2AogWyfoHMasqxch58ORYqb8z4B1c9KuvBb53PflrcFnZpZUD2NJXn1LMTfAt6hzv9XIsZrHRPmJsvp5qQbCLlso2ho1SwCtQb889vfwvJ2G8S4sVTaLCljQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246048; c=relaxed/simple;
	bh=fLFCoDbxzUCs0Q8szBSbuNk2PEV0H6OqssiLRXV3B0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K04MgLGatme6BvwVKsFmlu6hsleAwOWXufwDv1BMnCwf6DvoTsI0nen7tL5iesIDUHIDdNXBGnSDcdYB8ybHkW2qNh8S1c7Zrl3IuV5bPAHNkh8GBNr/JrNpCiu3PPekejk2Xv7c3hH4p6f8ebuqocR9TEp8J/dzNHHgIwWQNzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qnDVzkVH; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qnDVzkVH"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6a0de515e54so881898eaf.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246046; x=1782850846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6bbnJKD4cabtzxq10iy1cmg+zePx1wF21q8W2KxVTwQ=;
        b=qnDVzkVHV+clNg8gcfKO7ru6vrAuFc/zeAL/yMnWOuz7us5VbveQgZInEGEv3Qlw2/
         BBCgiSznNNlsUvP6Sk/fNER6wqOZD5PfxezaiTLIL7T4b6gzmmcjHRxqN2DcW/777w0I
         tbPA2i8dfoQxLA1eVTHRJbLtyxMDFGK4Gakdwzggvr/CGPlis9IaFzbgUQ1iLwOd3rmM
         W9TAtP6zXBiDu0CqeRarbpLNxmfkMNEtaV2vWgUI5ZBpzToBDPfIOgTUzcWds0etVaYz
         gbwBiHyibAS0N3iPQom2teFZhxnJnm5LaGh4mH+LvSPYzF3RNpUzdOSByHzpsMZggXDt
         VCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246046; x=1782850846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6bbnJKD4cabtzxq10iy1cmg+zePx1wF21q8W2KxVTwQ=;
        b=HP+CCHgcJ96SJuHTXQcl5taqaREpgBpdp5KDohuKAx8Prth7oYwdrwtRuyJs2ZNFFM
         1BGwP1EEqVnRcyhezVBgDYa8kdzgYljFWSWiDeRRgmbqw+PZKBQ/pgHwF4HDKqkVJA65
         FVg2w7m1T7gy9JE2/D6h08JvpxetF1HjmPl4N4L3JydxPMV08ihBFevzPyP8cfqTfGwF
         HRdr/a0b7D1p2+pX3pqIdHQvnTCKJi2xlXIT/RqtJg3vzcp/495vvP7DhnuQVbOUZdJU
         edYh8u8lmsdSuj+UrNcqZYI4GE+YZe3A6qex/76uY5ZtzcLdjzpedjwM4NDkRLTm3r4E
         embA==
X-Gm-Message-State: AOJu0YzMZZygYX6HLu/Nndt5IUVDypdBz0pu0Hv11URQhryeYqC1HawH
	oMJ+auuOL+ipJuILC1Tx6abSFhrJ4C/g0XrmVC4yyB7t1CKI7vTvqYwC8xjTIZ3f
X-Gm-Gg: AfdE7cl5/5ZqkcrXuFltx3GTdcq3DbMW2lanQycW7JYpbf9MKOUg2+r01+jCQOPwFNl
	qzFyNNBKPzWHtBRhnpdPuMT1UPrnpP9TC9QYaGQkqS+4++FHQyEzG8xXQyir/8Uj0ZfLVoXACNv
	8txbBuqMbqC9v5AbO7cpU8usRF2FKlGtLz7gXFY/t53sef2YLeIAbrZDQxQUJiY7/1GKcXHK7j6
	aoM3b7eh4SRCXUeuQjVTGcXtNHWxNaXlIv/sodZukcI3m8EpzSmlnO5ZcpRucIzB2n+OpQ8l8gK
	atgt6Gx3coEbq3PXXtxBn9XX5NupQoOdukH/QgmPksmQK12o4LAa8L87U5aJbQbuGTBsc8st2XH
	bwSsHJhlI8N34SPE79506POMxK4CuCWAJgmTo10gG4ikrK5SYcg2PDUSboOLRjmmpHMiSnIvjhe
	IHhtztZa8Nl9doeNU+LiesL3gwvniIu9j2JbovzpLwaiZQ6HxSHkQVNNxWTgzqQqqWz3bzod4aC
	9gtldscDxoQBeCAWyuhb0m4UWh786u7UWLs3QGOjUHhHR3Y/lolhQfu2DOCNV+drBAX6v/rf6Bn
	WK0w7fvZQZqhxVYH7j0f62hzXp4=
X-Received: by 2002:a05:6820:80e:b0:69e:f950:294b with SMTP id 006d021491bc7-6a1127a33a3mr2526357eaf.24.1782246045977;
        Tue, 23 Jun 2026 13:20:45 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:45 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 13/16] cifs: trace points for cached_dir operations
Date: Tue, 23 Jun 2026 15:13:40 -0500
Message-ID: <20260623201344.2043841-13-stfrench@microsoft.com>
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

This change introduces ftrace tracepoints for cached_dir operations.
Intended to be used for debugging cached_dir.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 21 ++++++++++-
 fs/smb/client/inode.c      | 13 +++++++
 fs/smb/client/trace.h      | 73 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index ecdc6907cf6d..389695b20324 100644
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
index 631f5fae813b..a139af232bf0 100644
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
index 9e120d6fe51c..145d537ed17d 100644
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
2.53.0

