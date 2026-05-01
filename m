Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2D53A9DBA
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634444; cv=none; b=UIZxLp0ia77YmCdTjU01sMzAiX95ppDmulbMgtMKdRFWGsW+W++MUcwjm5sYDUSew424xIO//XZq32wNxBr7NkwWTAPuEI0ZBWeSIOweQ1+Ct9qOfK80+y0I/7BOcPo65WW/H67B9A3vPBewMtM+tmkRtrHkMmkx5fM82T2EUvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634444; c=relaxed/simple;
	bh=u+MpqVgdB0XSJ4fjpKzAuMq3OK7F1knU2Vg6hZjp8T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOjbBQMSHaYnqMWGh3sT1YR+k0dF27qbMB2WC1q+t8hIxYPFvt4NHmVi51J/VrOBeGUtWdXHIqgDJQB1mcnZ9qEuu2hVTQa3cU7HI2xuydI5kOS8+k+iUb7xEPkYRpnjTry+YiWpSTHKKpNgEgutZs3n93qEBygexlgomypeguo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HI+vAdO6; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HI+vAdO6"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-824c9da9928so888256b3a.3
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634439; x=1778239239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r5/qzlozqLXx32LaLMX29vWWxo1OoGpelKukRnnwjFU=;
        b=HI+vAdO6Amt56n+7xfCT+gRHWVW4mxnlfYFg0Lf1377b0uOnmCC4bXR+F+NroKuhtO
         WTyT4V1MbHAqPGuMDhx4hwr28n8hhU7jNAQIdpQAwnOKOA+yEJGUOodRlW0PS2y/g14Y
         VLitKJs7d+bYFkQmI5y9oSafOhi2rU4sBkmeuhAVynDPyalP2+1WK4KiWLdAxKEmAB/+
         etPdw8KYMLJY2FMXheehHD+ZN5w94Sym0qJlaHjvh59RXuXDh/8fOGBP4EBoBQaAeNGk
         CxAYBkWXUWN7CRLYNXte1hboC+t34znrA5TdWN0Jr+wYibDz/uU4vdVfrEUXNAXSZKiA
         kz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634439; x=1778239239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r5/qzlozqLXx32LaLMX29vWWxo1OoGpelKukRnnwjFU=;
        b=HjfLc/QVqTnRV7O+TDwPrPxh4ESHfEIQ0LoDYaMJzb48jXxWTRXDMDVsUUX0sg43Tf
         7B1jz/pTcUL2UzaY35CCFBF3716BpAIbUOYjukXU3vBil+ohFFQgFkXbo3K4Xk/pV38C
         4RFnbmYE2aZMtityK5k6Y4DlvLT9Je1IPFRK7807sFFFLkt3YnVx2QaY0VDgLeB1a5T6
         XIwl5nzSfhSF+d8fbG0k5iwyx1mwZUJo/FGwV8s/swio/VXky0l5e+tuOTwAAomxQ4+d
         SjPZG/wjv2QqltRIXMQGHZotTGYmEBHtWqHi4IzT96F7xK1MxEWzX1QwuhwzSI1x1FbX
         ThSg==
X-Gm-Message-State: AOJu0YxB1CzNS6iXGG+qmbLgU0O7TBnJtp2kQH9DZjARRJOUf7tVroKl
	KCUmwMw9tggulqGyG4a5BOv5rp+XzO5sGVqD6GtS4X5AURxguIO9jCAX8X6onq2ctx8=
X-Gm-Gg: AeBDieuB4zKYq6xI7daP+hOY0mdSYe5NJYTzULyxMj0DU1Sv0hlqyI2j2wBdZASMNXH
	7k+HjpOIpLwGIjMAaepiId0xvEiDjs0Z0nxZw2dslN9TojsfT7MsX/yVqvZepHQJDj/Jmcwv5+N
	6ZXMhK6Mv2/3QHb04geYAYj57JZE/RHKr/tYLVRrIlb5P+1GCU2XyynovXfAcXAo3yJHMaaMRE0
	JShKR/N/eZgNR1CnWuzuSozeTfGugyqUT6ZGRNxZUXFcR9ZwyjZ0FMmo5CCdOHitmYp89zH/TY8
	qOkIgUWZlnU/97h5Y73uY/6OvRATT6JPCdDs+3WjIlhIMJ3yKw65jR7gdfGgKo7rPLBTQGLAlw5
	KRfAV31+Mb86Oc3+fAge09MCU1yMXFrk6Uf+TrOjj7o5BdOivM0YlV3uQnmkEY5/zU9YiignvmQ
	42Mlp54Uzf8qESa7/dFVJUfl1xsOLFv38Mm1RPbmgwu9uQ47ICgsq3ENaLl8Q+zD7zArp38Was5
	XA=
X-Received: by 2002:a05:6a00:399d:b0:82f:4b03:71c4 with SMTP id d2e1a72fcca58-834fe0aaeefmr7507696b3a.18.1777634439374;
        Fri, 01 May 2026 04:20:39 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:38 -0700 (PDT)
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
Subject: [PATCH v4 08/19] cifs: make cfid locks more granular
Date: Fri,  1 May 2026 16:50:11 +0530
Message-ID: <20260501112023.338005-8-sprasad@microsoft.com>
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

Today all synchronization of cfid related data structures are done
using cfid_list_lock. This can serialize caching of different dirs
unnecessarily.

This change introduces two new locks to provide finer locking.
Every cfid will now have a cfid_lock. This is designed to protect
everything inside a cfid that is not related to list operations.

Every cfid will now also have a cfid_open_mutex. This is designed to
protect parallel open calls to the same dir.

Additionally, this change will now make accesses to cfid->dentries
more stringent using the de_mutex.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 155 +++++++++++++++++++++++++------------
 fs/smb/client/cached_dir.h |  13 +++-
 fs/smb/client/cifs_debug.c |   7 +-
 fs/smb/client/cifsglob.h   |   2 +
 fs/smb/client/dir.c        |  34 ++++++--
 5 files changed, 149 insertions(+), 62 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index a9bc0c81868c8..ad2439856a1fe 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -16,13 +16,29 @@ static struct cached_fid *init_cached_dir(const char *path);
 static void free_cached_dir(struct cached_fid *cfid);
 static void smb2_close_cached_fid(struct kref *ref);
 static void cfids_laundromat_worker(struct work_struct *work);
-static void close_cached_dir_locked(struct cached_fid *cfid);
 
 struct cached_dir_dentry {
 	struct list_head entry;
 	struct dentry *dentry;
 };
 
+bool cached_dir_copy_lease_key(struct cached_fid *cfid,
+			      __u8 lease_key[SMB2_LEASE_KEY_SIZE])
+{
+	bool valid;
+
+	if (!cfid)
+		return false;
+
+	spin_lock(&cfid->cfid_lock);
+	valid = is_valid_cached_dir(cfid);
+	if (valid)
+		memcpy(lease_key, cfid->fid.lease_key, SMB2_LEASE_KEY_SIZE);
+	spin_unlock(&cfid->cfid_lock);
+
+	return valid;
+}
+
 static bool emit_cached_dirents(struct cached_dirents *cde,
 				struct dir_context *ctx)
 {
@@ -244,9 +260,13 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 			 * fully cached or it may be in the process of
 			 * being deleted due to a lease break.
 			 */
-			if (!is_valid_cached_dir(cfid))
+			spin_lock(&cfid->cfid_lock);
+			if (!is_valid_cached_dir(cfid)) {
+				spin_unlock(&cfid->cfid_lock);
 				return NULL;
+			}
 			kref_get(&cfid->refcount);
+			spin_unlock(&cfid->cfid_lock);
 			return cfid;
 		}
 	}
@@ -273,7 +293,9 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 	 * Concurrent processes won't be to use it yet due to @cfid->time being
 	 * zero.
 	 */
+	spin_lock(&cfid->cfid_lock);
 	cfid->has_lease = true;
+	spin_unlock(&cfid->cfid_lock);
 
 	return cfid;
 }
@@ -396,19 +418,23 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		kfree(utf16_path);
 		return -ENOENT;
 	}
+	spin_unlock(&cfids->cfid_list_lock);
+
 	/*
 	 * Return cached fid if it is valid (has a lease and has a time).
 	 * Otherwise, it is either a new entry or laundromat worker removed it
 	 * from @cfids->entries.  Caller will put last reference if the latter.
 	 */
+
+	spin_lock(&cfid->cfid_lock);
 	if (is_valid_cached_dir(cfid)) {
 		cfid->last_access_time = jiffies;
-		spin_unlock(&cfids->cfid_list_lock);
+		spin_unlock(&cfid->cfid_lock);
 		*ret_cfid = cfid;
 		kfree(utf16_path);
 		return 0;
 	}
-	spin_unlock(&cfids->cfid_list_lock);
+	spin_unlock(&cfid->cfid_lock);
 
 	pfid = &cfid->fid;
 
@@ -438,6 +464,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 			spin_lock(&cfids->cfid_list_lock);
 			list_for_each_entry(parent_cfid, &cfids->entries, entry) {
+				spin_lock(&parent_cfid->cfid_lock);
 				if (parent_cfid->dentry == dentry->d_parent) {
 					cifs_dbg(FYI, "found a parent cached file handle\n");
 					if (is_valid_cached_dir(parent_cfid)) {
@@ -447,8 +474,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 						       parent_cfid->fid.lease_key,
 						       SMB2_LEASE_KEY_SIZE);
 					}
+					spin_unlock(&parent_cfid->cfid_lock);
 					break;
 				}
+				spin_unlock(&parent_cfid->cfid_lock);
 			}
 			spin_unlock(&cfids->cfid_list_lock);
 		}
@@ -527,10 +556,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		smb2_set_replay(server, &rqst[1]);
 	}
 
+	mutex_lock(&cfid->cfid_open_mutex);
+
 	rc = compound_send_recv(xid, ses, server,
 				flags, 2, rqst,
 				resp_buftype, rsp_iov);
 	if (rc) {
+		mutex_unlock(&cfid->cfid_open_mutex);
 		if (rc == -EREMCHG) {
 			tcon->need_reconnect = true;
 			pr_warn_once("server share %s deleted\n",
@@ -538,10 +570,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 		goto oshr_free;
 	}
+	spin_lock(&cfid->cfid_lock);
 	cfid->is_open = true;
 
-	spin_lock(&cfids->cfid_list_lock);
-
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
 	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
@@ -551,8 +582,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
-		spin_unlock(&cfids->cfid_list_lock);
 		rc = -EINVAL;
+		spin_unlock(&cfid->cfid_lock);
+		mutex_unlock(&cfid->cfid_open_mutex);
 		goto oshr_free;
 	}
 
@@ -561,18 +593,21 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				 oparms.fid->lease_key,
 				 &oplock, NULL, NULL);
 	if (rc) {
-		spin_unlock(&cfids->cfid_list_lock);
+		spin_unlock(&cfid->cfid_lock);
+		mutex_unlock(&cfid->cfid_open_mutex);
 		goto oshr_free;
 	}
 
 	rc = -EINVAL;
 	if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
-		spin_unlock(&cfids->cfid_list_lock);
+		spin_unlock(&cfid->cfid_lock);
+		mutex_unlock(&cfid->cfid_open_mutex);
 		goto oshr_free;
 	}
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info)) {
-		spin_unlock(&cfids->cfid_list_lock);
+		spin_unlock(&cfid->cfid_lock);
+		mutex_unlock(&cfid->cfid_open_mutex);
 		goto oshr_free;
 	}
 	if (!smb2_validate_and_copy_iov(
@@ -584,7 +619,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 	cfid->time = jiffies;
 	cfid->last_access_time = jiffies;
-	spin_unlock(&cfids->cfid_list_lock);
+	spin_unlock(&cfid->cfid_lock);
+	mutex_unlock(&cfid->cfid_open_mutex);
 	/* At this point the directory handle is fully cached */
 	rc = 0;
 
@@ -595,23 +631,24 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 out:
 	if (rc) {
+		bool drop_lease_ref = false;
+
 		spin_lock(&cfids->cfid_list_lock);
 		if (cfid->on_list) {
 			list_del(&cfid->entry);
 			cfid->on_list = false;
 			cfids->num_entries--;
 		}
+		spin_lock(&cfid->cfid_lock);
 		if (cfid->has_lease) {
-			/*
-			 * We are guaranteed to have two references at this
-			 * point. One for the caller and one for a potential
-			 * lease. Release one here, and the second below.
-			 */
 			cfid->has_lease = false;
-			close_cached_dir_locked(cfid);
+			drop_lease_ref = true;
 		}
+		spin_unlock(&cfid->cfid_lock);
 		spin_unlock(&cfids->cfid_list_lock);
 
+		if (drop_lease_ref)
+			close_cached_dir(cfid);
 		close_cached_dir(cfid);
 	} else {
 		*ret_cfid = cfid;
@@ -642,12 +679,16 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
 		if (cfid->dentry == dentry) {
-			if (!is_valid_cached_dir(cfid))
+			spin_lock(&cfid->cfid_lock);
+			if (!is_valid_cached_dir(cfid)) {
+				spin_unlock(&cfid->cfid_lock);
 				break;
+			}
 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
 			kref_get(&cfid->refcount);
 			*ret_cfid = cfid;
 			cfid->last_access_time = jiffies;
+			spin_unlock(&cfid->cfid_lock);
 			spin_unlock(&cfids->cfid_list_lock);
 			return 0;
 		}
@@ -662,6 +703,8 @@ __releases(&cfid->cfids->cfid_list_lock)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid,
 					       refcount);
+	u64 persistent_fid = 0, volatile_fid = 0;
+	bool is_open;
 	int rc;
 
 	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
@@ -676,9 +719,17 @@ __releases(&cfid->cfids->cfid_list_lock)
 	dput(cfid->dentry);
 	cfid->dentry = NULL;
 
-	if (cfid->is_open) {
-		rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
-			   cfid->fid.volatile_fid);
+	spin_lock(&cfid->cfid_lock);
+	is_open = cfid->is_open;
+	if (is_open) {
+		persistent_fid = cfid->fid.persistent_fid;
+		volatile_fid = cfid->fid.volatile_fid;
+		cfid->is_open = false;
+	}
+	spin_unlock(&cfid->cfid_lock);
+
+	if (is_open) {
+		rc = SMB2_close(0, cfid->tcon, persistent_fid, volatile_fid);
 		if (rc) /* should we retry on -EBUSY or -EAGAIN? */
 			cifs_dbg(VFS, "close cached dir rc %d\n", rc);
 	}
@@ -691,6 +742,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	struct cached_fid *cfid = NULL;
 	int rc;
+	bool drop_lease_ref = false;
 
 	rc = open_cached_dir(xid, tcon, name, cifs_sb, true, &cfid);
 	if (rc) {
@@ -698,11 +750,16 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 		return;
 	}
 	spin_lock(&cfid->cfids->cfid_list_lock);
+	spin_lock(&cfid->cfid_lock);
 	if (cfid->has_lease) {
 		cfid->has_lease = false;
-		close_cached_dir_locked(cfid);
+		drop_lease_ref = true;
 	}
+	spin_unlock(&cfid->cfid_lock);
 	spin_unlock(&cfid->cfids->cfid_list_lock);
+
+	if (drop_lease_ref)
+		close_cached_dir(cfid);
 	close_cached_dir(cfid);
 }
 
@@ -711,8 +768,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
  *
  * The release function will be called with cfid_list_lock held to remove the
  * cached dirs from the list before any other thread can take another @cfid
- * ref. Must not be called with cfid_list_lock held; use
- * close_cached_dir_locked() called instead.
+ * ref. Must not be called with cfid_list_lock held.
  *
  * @cfid: cached dir
  */
@@ -722,30 +778,6 @@ void close_cached_dir(struct cached_fid *cfid)
 	kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfids->cfid_list_lock);
 }
 
-/**
- * close_cached_dir_locked - put a reference of a cached dir with
- * cfid_list_lock held
- *
- * Calling close_cached_dir() with cfid_list_lock held has the potential effect
- * of causing a deadlock if the invariant of refcount >= 2 is false.
- *
- * This function is used in paths that hold cfid_list_lock and expect at least
- * two references. If that invariant is violated, WARNs and returns without
- * dropping a reference; the final put must still go through
- * close_cached_dir().
- *
- * @cfid: cached dir
- */
-static void close_cached_dir_locked(struct cached_fid *cfid)
-{
-	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
-
-	if (WARN_ON(kref_read(&cfid->refcount) < 2))
-		return;
-
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
-}
-
 /*
  * Called from cifs_kill_sb when we unmount a share
  */
@@ -784,8 +816,10 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 				goto done;
 			}
 
+			spin_lock(&cfid->cfid_lock);
 			tmp_list->dentry = cfid->dentry;
 			cfid->dentry = NULL;
+			spin_unlock(&cfid->cfid_lock);
 
 			list_add_tail(&tmp_list->entry, &entry);
 		}
@@ -825,16 +859,20 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		list_move(&cfid->entry, &cfids->dying);
 		cfids->num_entries--;
+		spin_lock(&cfid->cfid_lock);
 		cfid->is_open = false;
-		cfid->on_list = false;
 		if (cfid->has_lease) {
 			/*
 			 * The lease was never cancelled from the server,
 			 * so steal that reference.
 			 */
 			cfid->has_lease = false;
-		} else
+			spin_unlock(&cfid->cfid_lock);
+		} else {
+			spin_unlock(&cfid->cfid_lock);
 			kref_get(&cfid->refcount);
+		}
+		cfid->on_list = false;
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
@@ -883,12 +921,14 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
+		spin_lock(&cfid->cfid_lock);
 		if (cfid->has_lease &&
 		    !memcmp(lease_key,
 			    cfid->fid.lease_key,
 			    SMB2_LEASE_KEY_SIZE)) {
 			cfid->has_lease = false;
 			cfid->time = 0;
+			spin_unlock(&cfid->cfid_lock);
 			/*
 			 * We found a lease remove it from the list
 			 * so no threads can access it.
@@ -904,6 +944,7 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
 		}
+		spin_unlock(&cfid->cfid_lock);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 	return false;
@@ -927,6 +968,8 @@ static struct cached_fid *init_cached_dir(const char *path)
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
+	mutex_init(&cfid->cfid_open_mutex);
+	spin_lock_init(&cfid->cfid_lock);
 	kref_init(&cfid->refcount);
 	return cfid;
 }
@@ -983,6 +1026,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	list_cut_before(&entry, &cfids->dying, &cfids->dying);
 
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+		spin_lock(&cfid->cfid_lock);
 		if (cfid->last_access_time &&
 		    time_after(jiffies, cfid->last_access_time + HZ * dir_cache_timeout)) {
 			cfid->on_list = false;
@@ -994,8 +1038,13 @@ static void cfids_laundromat_worker(struct work_struct *work)
 				 * server. Steal that reference.
 				 */
 				cfid->has_lease = false;
-			} else
+				spin_unlock(&cfid->cfid_lock);
+			} else {
+				spin_unlock(&cfid->cfid_lock);
 				kref_get(&cfid->refcount);
+			}
+		} else {
+			spin_unlock(&cfid->cfid_lock);
 		}
 	}
 	spin_unlock(&cfids->cfid_list_lock);
@@ -1062,12 +1111,16 @@ void free_cached_dirs(struct cached_fids *cfids)
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		cfid->on_list = false;
+		spin_lock(&cfid->cfid_lock);
 		cfid->is_open = false;
+		spin_unlock(&cfid->cfid_lock);
 		list_move(&cfid->entry, &entry);
 	}
 	list_for_each_entry_safe(cfid, q, &cfids->dying, entry) {
 		cfid->on_list = false;
+		spin_lock(&cfid->cfid_lock);
 		cfid->is_open = false;
+		spin_unlock(&cfid->cfid_lock);
 		list_move(&cfid->entry, &entry);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 09f1f488059c9..f82db6a7ca5b0 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -48,6 +48,8 @@ struct cached_fid {
 	struct work_struct put_work;
 	struct work_struct close_work;
 	struct cached_dirents dirents;
+	struct mutex cfid_open_mutex; /* Serializes OPEN response processing and lease key population */
+	spinlock_t cfid_lock; /* Protects: has_lease, time, is_open, file_all_info_is_valid, last_access_time, fid.lease_key reads */
 
 	/* Must be last as it ends in a flexible-array member. */
 	struct smb2_file_all_info file_all_info;
@@ -56,8 +58,12 @@ struct cached_fid {
 /* default MAX_CACHED_FIDS is 16 */
 struct cached_fids {
 	/* Must be held when:
-	 * - accessing the cfids->entries list
-	 * - accessing the cfids->dying list
+	 * - modifying cfids->entries list (add/remove entries)
+	 * - modifying cfids->dying list
+	 * - modifying cfid->on_list or cfids->num_entries
+	 *
+	 * Lock ordering: if you need both cfid_list_lock and cfid_lock,
+	 * acquire cfid_list_lock FIRST, then cfid_lock to avoid deadlock.
 	 */
 	spinlock_t cfid_list_lock;
 	int num_entries;
@@ -78,6 +84,9 @@ is_valid_cached_dir(struct cached_fid *cfid)
 	return cfid->time && cfid->has_lease;
 }
 
+bool cached_dir_copy_lease_key(struct cached_fid *cfid,
+			      __u8 lease_key[SMB2_LEASE_KEY_SIZE]);
+
 struct cached_fids *init_cached_dirs(void);
 void free_cached_dirs(struct cached_fids *cfids);
 int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 217444e3e6d01..cc7d26a3917c5 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -327,6 +327,7 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 						(unsigned long)atomic_long_read(&cfids->total_dirents_entries),
 						(unsigned long long)atomic64_read(&cfids->total_dirents_bytes));
 				list_for_each_entry(cfid, &cfids->entries, entry) {
+					spin_lock(&cfid->cfid_lock);
 					seq_printf(m, "0x%x 0x%llx 0x%llx ",
 						tcon->tid,
 						ses->Suid,
@@ -338,11 +339,13 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 					seq_printf(m, "%s", cfid->path);
 					if (cfid->file_all_info_is_valid)
 						seq_printf(m, "\tvalid file info");
+					spin_unlock(&cfid->cfid_lock);
 					if (cfid->dirents.is_valid)
 						seq_printf(m, ", valid dirents");
-					if (!list_empty(&cfid->dirents.entries))
+					if (READ_ONCE(cfid->dirents.entries_count))
 						seq_printf(m, ", dirents: %lu entries, %lu bytes",
-						cfid->dirents.entries_count, cfid->dirents.bytes_used);
+						READ_ONCE(cfid->dirents.entries_count),
+						READ_ONCE(cfid->dirents.bytes_used));
 					seq_printf(m, "\n");
 				}
 				spin_unlock(&cfids->cfid_list_lock);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 38d5600efe2c8..a15971ffeee58 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2068,6 +2068,8 @@ require use of the stronger protocol */
  *				->can_cache_brlcks
  * cifsInodeInfo->deferred_lock	cifsInodeInfo->deferred_closes	cifsInodeInfo_alloc
  * cached_fids->cfid_list_lock	cifs_tcon->cfids->entries	init_cached_dirs
+ * cached_fid->cfid_open_mutex	cached_fid OPEN/lease serialization	alloc_cached_dir
+ * cached_fid->cfid_lock	cached_fid state		alloc_cached_dir
  * cached_fid->dirents.de_mutex	cached_fid->dirents		alloc_cached_dir
  * cifsFileInfo->fh_mutex	cifsFileInfo			cifs_new_fileinfo
  * cifsFileInfo->file_info_lock	cifsFileInfo->count		cifs_new_fileinfo
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 6d2378eeb7f68..4e5c580e4de0a 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -194,6 +194,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	struct cached_fid *parent_cfid = NULL;
 	int rdwr_for_fscache = 0;
 	__le32 lease_flags = 0;
+	bool found_parent_cfid;
 
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
@@ -319,24 +320,33 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 
 retry_open:
 	if (tcon->cfids && direntry->d_parent && server->dialect >= SMB30_PROT_ID) {
+		found_parent_cfid = false;
 		parent_cfid = NULL;
 		spin_lock(&tcon->cfids->cfid_list_lock);
 		list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
+			spin_lock(&parent_cfid->cfid_lock);
 			if (parent_cfid->dentry == direntry->d_parent) {
+				kref_get(&parent_cfid->refcount);
+				spin_unlock(&parent_cfid->cfid_lock);
+				spin_unlock(&tcon->cfids->cfid_list_lock);
+				found_parent_cfid = true;
 				cifs_dbg(FYI, "found a parent cached file handle\n");
-				if (is_valid_cached_dir(parent_cfid)) {
+				if (cached_dir_copy_lease_key(parent_cfid,
+						      fid->parent_lease_key)) {
 					lease_flags
 						|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
-					memcpy(fid->parent_lease_key,
-					       parent_cfid->fid.lease_key,
-					       SMB2_LEASE_KEY_SIZE);
+					mutex_lock(&parent_cfid->dirents.de_mutex);
 					parent_cfid->dirents.is_valid = false;
 					parent_cfid->dirents.is_failed = true;
+					mutex_unlock(&parent_cfid->dirents.de_mutex);
 				}
+				close_cached_dir(parent_cfid);
 				break;
 			}
+			spin_unlock(&parent_cfid->cfid_lock);
 		}
-		spin_unlock(&tcon->cfids->cfid_list_lock);
+		if (!found_parent_cfid)
+			spin_unlock(&tcon->cfids->cfid_list_lock);
 	}
 
 	oparms = (struct cifs_open_parms) {
@@ -737,7 +747,12 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 			 * dentry is negative and parent is fully cached:
 			 * we can assume file does not exist
 			 */
-			if (cfid->dirents.is_valid) {
+			bool dirents_valid;
+
+			mutex_lock(&cfid->dirents.de_mutex);
+			dirents_valid = cfid->dirents.is_valid;
+			mutex_unlock(&cfid->dirents.de_mutex);
+			if (dirents_valid) {
 				close_cached_dir(cfid);
 				goto out;
 			}
@@ -848,7 +863,12 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 			 * dentry is negative and parent is fully cached:
 			 * we can assume file does not exist
 			 */
-			if (cfid->dirents.is_valid) {
+			bool dirents_valid;
+
+			mutex_lock(&cfid->dirents.de_mutex);
+			dirents_valid = cfid->dirents.is_valid;
+			mutex_unlock(&cfid->dirents.de_mutex);
+			if (dirents_valid) {
 				close_cached_dir(cfid);
 				return 1;
 			}
-- 
2.43.0

