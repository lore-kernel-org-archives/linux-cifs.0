Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A3334404F
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 18:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778782129; cv=none; b=FUuh/3Ce2qVZKIHy+YLaQgSVFbYd9CF1gjpN9B1PNHd/o+56qaZdOsF/3+7IJ+5J5o9U+h/izqE4BWtOT/pYFLZsc/k9eern4jn6o0S/17SM17u9cvEi22QZ1DNgT7Yo2OO5NpxediSGsQjgPazg9MVhbJj4vY0BJCMMuvYObS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778782129; c=relaxed/simple;
	bh=7h0bmankPdCp9AZmwTtaoVTn/nCqVRn6gPHaeuNb/jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNGKbFaHrQJdxBYZEM8a6/zLtphGKJWLxf04Jls/kD8Oc95F5PowgHrEssSRtmqQR4KE9UUpUAtVFBbhD/rr/kiGVVqFrNx32QP1WFcQZWqX0AwEx3YcK08fAEIfTsTUXo2g9Z0jI/qC65mJ4gZLpcZDpaNQsFa2wojnVUCw+ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Efy9MfJg; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Efy9MfJg"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c8025aecc40so85427a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 11:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778782127; x=1779386927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2P3BpTaZSbH5t7w8JymIZlzrUXvfBO1b8FzWwuofVUY=;
        b=Efy9MfJgvjphrlBj55fxwtA6/pz2g8/9Ig1NK4YSHuLGBloIRz7XjAL5GLmkii3SW4
         Q5EIgCazzsKb+yGzdndMeHoYCFYPJcxDn47WCE/m1ttjCh0yFtgYyIkJzpIvVs5B67dt
         XY2t+mCn0H6frkwU/Gc3htf7TgHDVwUAqa2gIPhkRh7fLAv8Cx3KlIeDrraFOP05jAjI
         1baxBQnaDWMLMIPDl4hQos5gYzRnQF5kjCAwRrvp3anZieCw7Vhum/eCrooi8VqyFmVc
         YHrhWRPSQTxsKpav/XU+zj/X+OAirU8FfJMEvwsVqkKCm8J3TkyolY+nrVlAxIYkiG2D
         AeWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778782127; x=1779386927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2P3BpTaZSbH5t7w8JymIZlzrUXvfBO1b8FzWwuofVUY=;
        b=O8oCNTp+t5S1vGW3e3F6XamFfL39QGEauC0MUGVPtj9mfhmSFkFpYdusEjffkNcMwa
         O1TsiqTcsYAE8vZf/GGT/WuHJl7NGOmRR1aaBSYWkeC0z8Ds+4cSNC1j4GY2p8uO+trg
         D2DHILpikO+MU1M3Eodd99MkIIRCVBofCJmzILxora64wXE9M4Swk8KyP+hJyo1jXeT9
         kt7WT1z9qP8laZf6CFEmpvftmAXjaWCgTRcCc/pXgJdcCbAkVmQFeRvnUChrlc2lNefy
         7E0Tt8whmLTKXHTmb8p/ZJgsKSP8cwfHv+8d34BDl+EAEMzcIT2ljVb5/yyIRDFJeCTJ
         C3Hw==
X-Gm-Message-State: AOJu0YwQMWqcgZ9I4ZM1NqEknT6XVw/A2ZGpkhkT1CP90xqHFgjt5Okd
	QwQZz8SmKzThTElXDbcurudd4oLJMWkaM+4vD4YXDs1pIZKS9t/I1G39mDs0O5Rlj/0=
X-Gm-Gg: Acq92OHT2tsX1h9U511YgQsIxW181RSAIXIGOzDJoSdx/UvWQAnZtkO6Anhz/rrm0a3
	hiz7AK3naNTlNrADc+B7sZLlf4+I8/7OgK0XyaXGGYukgfU0ww/9Kapu2HEFq/KxaTM/zVSH+DW
	QDtBRey9qe4n4BBQ5N/Jd7Z4ZLUR9IHZeb1YGEvE4n6h8W8F51YnK8QCzxClT/2NGhDB+c7mEtT
	BkVz/PhfrNFy7E7wZ7fjzKgGq8MIzBWxn+3P5o3UZQDOOx5NesEdM25mSsRCVjm6C97Yb9/pYou
	t1YR51A29hmdlzCd8ogPYXBwwgg33SaFAfyVDGVHZbk2patcpI8iSS/Enu1Yf9uTU0zWSWs4SrZ
	eQPFxRPq4BeWfErBANFusXyz1uEvRgUIIVTSvsUkonqY/+/nx5lwuEBa45GMEHPhidVb6Kv0SQo
	KxO0CmYs7/kL4vPKPJ3bhHjdOhlNfGIDB0Wyjp+EVOhvPI18NB3Z81Sg==
X-Received: by 2002:a05:6a20:7f9e:b0:3aa:f9e0:7a29 with SMTP id adf61e73a8af0-3b0c15ad1admr5009484637.37.1778782126693;
        Thu, 14 May 2026 11:08:46 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb121cd6sm3134589a12.30.2026.05.14.11.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 11:08:46 -0700 (PDT)
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
Subject: [PATCH v5 14/17] cifs: trace points for cached_dir operations
Date: Thu, 14 May 2026 23:38:20 +0530
Message-ID: <20260514180823.497293-14-sprasad@microsoft.com>
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
index 88c9566e280f0..f7356499636cb 100644
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

