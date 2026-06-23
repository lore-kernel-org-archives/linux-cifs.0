Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CAC39656D
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246035; cv=none; b=DxxJtQwZioz7VbvDH3VYYsLlgcx/CSZPKFTd0JsaLRj8lGJK54pB7BA0GRIWDgvg+MMvFu5NcWrS6667aEJQPAQYoX6+DLOBRHef5/SZVqCUIpJXW0bwRBO5DGaJNsDYtrXGebxKn7WrUXMkteyrm4Z+l9A7tZUFKqzxzeGUyLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246035; c=relaxed/simple;
	bh=kpkxuzwCsPes05cdYe0SUkPnvYojD8awpvNWC/Op0SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPGr1kH7TGbmkhP/arQhjKqnpiho/wGlU6+m2iejUN1yUcNq4tzR1paOJXbKKr0PDyVzkhkSeSV9QZosTyOijSSpMnRrGjUxWsYk1fMELrvVweqk21ZnYMvFvoto+0qoOsZeWgrBBxrKznENeVNFXKpHrKi5zgLZfBpQccrUJlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dRGbYd8k; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dRGbYd8k"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-69eb8b6bea8so147171eaf.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246033; x=1782850833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CRt9bHWAev2HhIvnQjMkH0SLO8kM0A+bz2PiDW48eA0=;
        b=dRGbYd8kkQSS00sAbEeiE0fuSq7pmGpbDwVQB8kVknubRnRQtIuieV1JXaVabslD9b
         9TEMssLBI+008OVKnOP9LRJi3/4mF7qOkFfyOkPYz6iHg/76R4YnoQS7lxfWmfx2Yr6w
         gcxo9YSCrjSXgezUyntLztbzU7hm3YVOo1E4QNPRY4C5KpP7ZFW+WGvXtxxRjO1dBvJN
         VtPSElYU7C76PaJDkEhL+xmDuWlt/Z631K/x6tQpJvNq99Qbkr1yTzIB+gSa1Kpnv0n9
         mq3/SQ9Y5+VzEdabKFyvr5DtITl/fvzgCencMtHboYwkygrZj26+kJXXs5ozp71YRY2k
         UdYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246033; x=1782850833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CRt9bHWAev2HhIvnQjMkH0SLO8kM0A+bz2PiDW48eA0=;
        b=dsPB3sbNDjBJgXq9dTzzRgtFWQsx5F423IhxXZ+aUWiK91uLjCVys2l7BHcAOGA4OJ
         kycbqeHXNcUHCGmg5TDwVcg6RXvMVS7s4+8FL9KLyK2RUpkPSYOhhwRTOFgntM6UlQCl
         BO/ef26YysfRXJ293KiMZ8TZoDjNciQUIGyM0N6JbyD3LjXzYb5dDpGZ5fsh1VaOK9Hw
         yigh+jVfrklD2BM1xfo65klQolslP33bx13UWQEJ1P/EEtEJg6omTtIcfOretcUr3prN
         L8OR0rhtI/JJ6SyxkKWm+VhYK9LIqYm0rsCpnYS55dDuZFJvp8UGN6q88n/ZzK4wITsd
         A3eQ==
X-Gm-Message-State: AOJu0Yw3Oabae0jrCb+DHmEBxxG+EZNG2dJb6QoPmUL74TuYo+YyhtVq
	OCMknyBZy828X1OTGlCr9dMiyuhHc78DaVajoEnU58LQjNjK8igjrRdqtqLVKy4y
X-Gm-Gg: AfdE7ckOt8YQvJ6M+icz10XyToPWqoQ1kw0UNorjhV25vs0l0P1RWZ9NfdU1lOlw2ES
	/cmcpBvIPoHW3pelljPmtErIs4xvOxuoZvuKCjJyCSCtkEFAXCbQ8f87xHflw0o1/2chfQz/nuZ
	8i9QFPj2HNExzag2P2QMn76Uf8WUz3MWFBKWBeKWxaB0BMdWDnxdg+FBqZ2a2k/5FH0JR3N8fqc
	hiGhcgA+uNHxfGMTJ1iYEGZ9kXqQ0vXrfrLBbXFB9cb4ZL1KyCZPiqOq0Ql+MmlFLXQdJZqXjam
	E4eyYF2PBfMdy8Ne8zs8Kr2vC+NKjZOk9JVIc8s41h/iVApn6uXSdrtl/usLnRNC7MUKY8HNlSg
	PRNKCjS29uQUxJl3QWkJiTB/5gNb0o4D+Pc0d+1YFid4/k7zM6PE5UVj1vBIcST+CLPOyANOfZw
	KezA4IeSq1Rol5+rwrqkMEKUbLfKH50QKmJ+tKUJc9R6id9AvlP89ihKapWm1qUyxjy3yQxZ2sq
	QV/X6D4JXtekY44CWyfijEQ/tPoOUjsM4Wo4lBzy3scuQGaDSD1WIH9SSmH7ZEh97Wl9vzwzPA9
	FyBiPsI0zmtKSqfBfFZXiuVvX68=
X-Received: by 2002:a05:6820:2216:b0:69e:3a90:99f5 with SMTP id 006d021491bc7-6a122eabc4fmr193208eaf.10.1782246032862;
        Tue, 23 Jun 2026 13:20:32 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:32 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 05/16] cifs: make cfid locks more granular
Date: Tue, 23 Jun 2026 15:13:32 -0500
Message-ID: <20260623201344.2043841-5-stfrench@microsoft.com>
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
 fs/smb/client/cached_dir.h |  14 +++-
 fs/smb/client/cifs_debug.c |   7 +-
 fs/smb/client/cifsglob.h   |   2 +
 fs/smb/client/dir.c        |  34 ++++++--
 5 files changed, 150 insertions(+), 62 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 13a197f1c35c..d8e96d8bbc5e 100644
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
@@ -825,16 +859,20 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
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
 
@@ -884,12 +922,14 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 
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
@@ -905,6 +945,7 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
 		}
+		spin_unlock(&cfid->cfid_lock);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 	return false;
@@ -928,6 +969,8 @@ static struct cached_fid *init_cached_dir(const char *path)
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
+	mutex_init(&cfid->cfid_open_mutex);
+	spin_lock_init(&cfid->cfid_lock);
 	kref_init(&cfid->refcount);
 	return cfid;
 }
@@ -984,6 +1027,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	list_cut_before(&entry, &cfids->dying, &cfids->dying);
 
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+		spin_lock(&cfid->cfid_lock);
 		if (cfid->last_access_time &&
 		    time_after(jiffies, cfid->last_access_time + HZ * dir_cache_timeout)) {
 			cfid->on_list = false;
@@ -995,8 +1039,13 @@ static void cfids_laundromat_worker(struct work_struct *work)
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
@@ -1063,12 +1112,16 @@ void free_cached_dirs(struct cached_fids *cfids)
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
index 724d57a8a5bc..323ebe4f5783 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -48,6 +48,9 @@ struct cached_fid {
 	struct work_struct put_work;
 	struct work_struct close_work;
 	struct cached_dirents dirents;
+	/* Serializes OPEN response processing and lease key population */
+	struct mutex cfid_open_mutex;
+	spinlock_t cfid_lock;
 
 	/* Must be last as it ends in a flexible-array member. */
 	struct smb2_file_all_info file_all_info;
@@ -56,8 +59,12 @@ struct cached_fid {
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
@@ -78,6 +85,9 @@ is_valid_cached_dir(struct cached_fid *cfid)
 	return cfid->time && cfid->has_lease;
 }
 
+bool cached_dir_copy_lease_key(struct cached_fid *cfid,
+			      __u8 lease_key[SMB2_LEASE_KEY_SIZE]);
+
 struct cached_fids *init_cached_dirs(void);
 void free_cached_dirs(struct cached_fids *cfids);
 int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 4ed4f55a0bb7..b35863eb2a66 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -329,6 +329,7 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 						(unsigned long)atomic_long_read(&cfids->total_dirents_entries),
 						(unsigned long long)atomic64_read(&cfids->total_dirents_bytes));
 				list_for_each_entry(cfid, &cfids->entries, entry) {
+					spin_lock(&cfid->cfid_lock);
 					seq_printf(m, "0x%x 0x%llx 0x%llx ",
 						tcon->tid,
 						ses->Suid,
@@ -340,11 +341,13 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
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
index 4943a15ccd57..b2181cceac3a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2066,6 +2066,8 @@ require use of the stronger protocol */
  *				->can_cache_brlcks
  * cifsInodeInfo->deferred_lock	cifsInodeInfo->deferred_closes	cifsInodeInfo_alloc
  * cached_fids->cfid_list_lock	cifs_tcon->cfids->entries	init_cached_dirs
+ * cached_fid->cfid_open_mutex	cached_fid OPEN/lease serialization	alloc_cached_dir
+ * cached_fid->cfid_lock	cached_fid state		alloc_cached_dir
  * cached_fid->dirents.de_mutex	cached_fid->dirents		alloc_cached_dir
  * cifsFileInfo->fh_mutex	cifsFileInfo			cifs_new_fileinfo
  * cifsFileInfo->file_info_lock	cifsFileInfo->count		cifs_new_fileinfo
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 88a4a1787ff0..4eb4d7731887 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -218,6 +218,7 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 	struct cached_fid *parent_cfid = NULL;
 	int rdwr_for_fscache = 0;
 	__le32 lease_flags = 0;
+	bool found_parent_cfid;
 
 	*inode = NULL;
 	*oplock = 0;
@@ -347,24 +348,33 @@ static int __cifs_do_create(struct inode *dir, struct dentry *direntry,
 
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
@@ -818,7 +828,12 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
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
@@ -929,7 +944,12 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
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
2.53.0

