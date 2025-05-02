Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B9E137C37
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 05:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746162936; cv=none; b=cv5cNdqATOlB+oDOvhRVd/ne/mshO6BrJLqjDvJTfCLTHFL0aslWhcluZhj4T0g0efTWkGYpiOOVeKr5Bj0ZSfNPC+ZZJkpg571Gb1tuv3U4Zigfn5d7Ln74JN0CH7OxZq7XnDN0dcZVz75t3HanOqI/tAzqwNyC74hsp24Oq4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746162936; c=relaxed/simple;
	bh=FEVXgCsLNyT6k+fuW2GKM7H9HAvBDhRN6MkkWut8F3I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cCFdcnTMqrTze3t0IQqVgB38yP1KUs5qtSOo29WKiGHo1HfvkzKQDGqHjEysLI4xjamcEv7RIWIvbitypuPTxGLewc2RVcJ5hfVTLODPefq5bzq+4ujF4v/5DM4/zqtRBxPCYZNHTN9zZ3VNAOi74lbr5t2owSR4kQldEjZ90LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CF68BN5l; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CF68BN5l"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-736b98acaadso1654097b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 01 May 2025 22:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746162934; x=1746767734; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W3zvfRLTpQ4JsYLv3c+1kdqBGqFVdox5Oj6OK2Pvojc=;
        b=CF68BN5lfBUvipKjL2v63vsMecpJ2qcyn3aue7Kcv9YXylaiAqwR44h9agPLeObxoL
         1xnThBkN5gHxndcHeZjQ4VZvty04oNz+sJTH1YFSKBpBwgSENUGqroAwZ1mYUTH6pzs7
         jYGVOwYTHsfJj6MfxsnVhNu+VMcdDuWiyNIHLt7OOzXqOWqWUL6LzrxQ28tFX3hufoGP
         5PrWqfIxlXSq8NDdNAGFuKjQxozC6rbhUx0PzlYjZq/cvPlq5xdjRSc5wAv/mpSnlRzd
         CZ2sL122j4lGrXJZg81GDC1A44kUZtifzxBASyCoe9CANS29sffKjgB6zM/fbbA3QEb2
         Y5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746162934; x=1746767734;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W3zvfRLTpQ4JsYLv3c+1kdqBGqFVdox5Oj6OK2Pvojc=;
        b=lVchqpgEKSkPRAoX8jGwlve/kOI3BLU0v8lOYMxiE2YfQ/hgaYPD/HjGUphwd3QVtw
         Aa62corsqTIvd+oJLigVJiCzYwrkmWO/+nitxEFFki3569OLoD5Fu3nwpH+wk0BgJ6vc
         waw4GG8nEkM1KqYuyTnaayoX8jOfCsAV+sbVGhLaB0Y8pmVbwI2BqSPeFQ7A3HnkpD7o
         GTsS9EbSzDTgOqMF0JOl4t/BPGtT+pKu+5sD2eR6aMowAbzrBCwChRVj/DGJjXUoFrsG
         aF1m0/3phbz5CUSL4ziOn2gSmN+EKCAqqadaz7JsRlwLP3osvwGj1S27EQXrDlH6mNTw
         Qftw==
X-Forwarded-Encrypted: i=1; AJvYcCU7a3cTY/1o2u5vJqfiQdT9JQtnTeNdkhim6cj96LISX+9qsEePI/13O2ijc+rjuHXDYbNuKwe3uzao@vger.kernel.org
X-Gm-Message-State: AOJu0YxY4m8s6cmqwnAkJVLhqjjIlhvCyrW7XhHsiRLGPttbHYSj7/+g
	81shauo0PjaS920r/w1vO9DMdXDbiNE5dI9GegUcd9oTCQ+v+78K
X-Gm-Gg: ASbGnctfvcaGG7vOZVy30vhpaHJ1QRazE4Nk9KVbU60leJicZK0asxbVPJoozjmcNmA
	F9b/nRpyF7tVr6qi0kvygX9BmiFh0uS4rO7bkJ5uHtN9fUBohMKN/FBvjf6fnzhqOtiCD8MBqP1
	NlTZ6ywLzSYKKb95klevcjhDniKzO5d0IzOT+yK/sPxRRb2x6ZrBhxbduMMSL+TwVB4+JLerreV
	yNqx/MhL+4hul8nSOjZJNQGuq1Ijxo/mLcY7J00be9IUJ1lG+EsRG+bLExZdkATZUTW+uiBzJD/
	aR7AounLFH/4PwnKN778xXnjtAK10tWSeNliRiQXJjLmndoJ2bAdbf1GggnLeOXIKPVxs3l/Wue
	BE4pmNMOZuAIlpg==
X-Google-Smtp-Source: AGHT+IHM/yRckf/x9PAsmurOdhFHMvxyASVaWcEu7vYjZpBPhIqMYSE0z9RnPiA/Pfj/C+lrkDkrSg==
X-Received: by 2002:a05:6a21:2d08:b0:1f5:7873:3041 with SMTP id adf61e73a8af0-20cde85a072mr2454047637.18.1746162933710;
        Thu, 01 May 2025 22:15:33 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fa82ba71asm425397a12.45.2025.05.01.22.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 22:15:33 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	ematsumiya@suse.de,
	pc@manguebit.com,
	paul@darkrain42.org,
	ronniesahlberg@gmail.com,
	linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/5] cifs: protect cfid accesses with fid_lock
Date: Fri,  2 May 2025 05:13:40 +0000
Message-ID: <20250502051517.10449-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

There are several accesses to cfid structure today without
locking fid_lock. This can lead to race conditions that are
hard to debug.

With this change, I'm trying to make sure that accesses to cfid
struct members happen with fid_lock held.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 87 ++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 37 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index fe738623cf1b..f074675fa6be 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -31,6 +31,7 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
+		spin_lock(&cfid->fid_lock);
 		if (!strcmp(cfid->path, path)) {
 			/*
 			 * If it doesn't have a lease it is either not yet
@@ -38,13 +39,16 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 			 * being deleted due to a lease break.
 			 */
 			if (!cfid->time || !cfid->has_lease) {
+				spin_unlock(&cfid->fid_lock);
 				spin_unlock(&cfids->cfid_list_lock);
 				return NULL;
 			}
 			kref_get(&cfid->refcount);
+			spin_unlock(&cfid->fid_lock);
 			spin_unlock(&cfids->cfid_list_lock);
 			return cfid;
 		}
+		spin_unlock(&cfid->fid_lock);
 	}
 	if (lookup_only) {
 		spin_unlock(&cfids->cfid_list_lock);
@@ -192,19 +196,20 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		kfree(utf16_path);
 		return -ENOENT;
 	}
+
 	/*
 	 * Return cached fid if it is valid (has a lease and has a time).
 	 * Otherwise, it is either a new entry or laundromat worker removed it
 	 * from @cfids->entries.  Caller will put last reference if the latter.
 	 */
-	spin_lock(&cfids->cfid_list_lock);
+	spin_lock(&cfid->fid_lock);
 	if (cfid->has_lease && cfid->time) {
-		spin_unlock(&cfids->cfid_list_lock);
+		spin_unlock(&cfid->fid_lock);
 		*ret_cfid = cfid;
 		kfree(utf16_path);
 		return 0;
 	}
-	spin_unlock(&cfids->cfid_list_lock);
+	spin_unlock(&cfid->fid_lock);
 
 	/*
 	 * Skip any prefix paths in @path as lookup_positive_unlocked() ends up
@@ -219,17 +224,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		goto out;
 	}
 
-	if (!npath[0]) {
-		dentry = dget(cifs_sb->root);
-	} else {
-		dentry = path_to_dentry(cifs_sb, npath);
-		if (IS_ERR(dentry)) {
-			rc = -ENOENT;
-			goto out;
-		}
-	}
-	cfid->dentry = dentry;
-	cfid->tcon = tcon;
 
 	/*
 	 * We do not hold the lock for the open because in case
@@ -301,9 +295,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 		goto oshr_free;
 	}
-	cfid->is_open = true;
-
-	spin_lock(&cfids->cfid_list_lock);
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
@@ -314,7 +305,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
-		spin_unlock(&cfids->cfid_list_lock);
 		rc = -EINVAL;
 		goto oshr_free;
 	}
@@ -323,21 +313,15 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				 &oparms.fid->epoch,
 				 oparms.fid->lease_key,
 				 &oplock, NULL, NULL);
-	if (rc) {
-		spin_unlock(&cfids->cfid_list_lock);
+	if (rc)
 		goto oshr_free;
-	}
 
 	rc = -EINVAL;
-	if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
-		spin_unlock(&cfids->cfid_list_lock);
+	if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
 		goto oshr_free;
-	}
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
-	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info)) {
-		spin_unlock(&cfids->cfid_list_lock);
+	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
 		goto oshr_free;
-	}
 	if (!smb2_validate_and_copy_iov(
 				le16_to_cpu(qi_rsp->OutputBufferOffset),
 				sizeof(struct smb2_file_all_info),
@@ -345,10 +329,26 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				(char *)&cfid->file_all_info))
 		cfid->file_all_info_is_valid = true;
 
-	cfid->time = jiffies;
-	spin_unlock(&cfids->cfid_list_lock);
 	/* At this point the directory handle is fully cached */
 	rc = 0;
+	spin_lock(&cfid->fid_lock);
+	if (!cfid->dentry) {
+		if (!npath[0]) {
+			dentry = dget(cifs_sb->root);
+		} else {
+			dentry = path_to_dentry(cifs_sb, npath);
+			if (IS_ERR(dentry)) {
+				spin_unlock(&cfid->fid_lock);
+				rc = -ENOENT;
+				goto out;
+			}
+		}
+		cfid->dentry = dentry;
+	}
+	cfid->tcon = tcon;
+	cfid->is_open = true;
+	cfid->time = jiffies;
+	spin_unlock(&cfid->fid_lock);
 
 oshr_free:
 	SMB2_open_free(&rqst[0]);
@@ -363,6 +363,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			cfid->on_list = false;
 			cfids->num_entries--;
 		}
+		spin_lock(&cfid->fid_lock);
 		if (cfid->has_lease) {
 			/*
 			 * We are guaranteed to have two references at this
@@ -372,6 +373,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			cfid->has_lease = false;
 			kref_put(&cfid->refcount, smb2_close_cached_fid);
 		}
+		spin_unlock(&cfid->fid_lock);
 		spin_unlock(&cfids->cfid_list_lock);
 
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
@@ -400,13 +402,16 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
+		spin_lock(&cfid->fid_lock);
 		if (dentry && cfid->dentry == dentry) {
 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
 			kref_get(&cfid->refcount);
+			spin_unlock(&cfid->fid_lock);
 			*ret_cfid = cfid;
 			spin_unlock(&cfids->cfid_list_lock);
 			return 0;
 		}
+		spin_unlock(&cfid->fid_lock);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 	return -ENOENT;
@@ -427,8 +432,11 @@ smb2_close_cached_fid(struct kref *ref)
 	}
 	spin_unlock(&cfid->cfids->cfid_list_lock);
 
-	dput(cfid->dentry);
-	cfid->dentry = NULL;
+	/* no locking necessary as we're the last user of this cfid */
+	if (cfid->dentry) {
+		dput(cfid->dentry);
+		cfid->dentry = NULL;
+	}
 
 	if (cfid->is_open) {
 		rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
@@ -451,12 +459,13 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
 		return;
 	}
-	spin_lock(&cfid->cfids->cfid_list_lock);
+	spin_lock(&cfid->fid_lock);
 	if (cfid->has_lease) {
+		/* mark as invalid */
 		cfid->has_lease = false;
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
-	spin_unlock(&cfid->cfids->cfid_list_lock);
+	spin_unlock(&cfid->fid_lock);
 	close_cached_dir(cfid);
 }
 
@@ -538,6 +547,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 		cfids->num_entries--;
 		cfid->is_open = false;
 		cfid->on_list = false;
+		spin_lock(&cfid->fid_lock);
 		if (cfid->has_lease) {
 			/*
 			 * The lease was never cancelled from the server,
@@ -546,6 +556,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 			cfid->has_lease = false;
 		} else
 			kref_get(&cfid->refcount);
+		spin_unlock(&cfid->fid_lock);
 	}
 	/*
 	 * Queue dropping of the dentries once locks have been dropped
@@ -600,6 +611,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
+		spin_lock(&cfid->fid_lock);
 		if (cfid->has_lease &&
 		    !memcmp(lease_key,
 			    cfid->fid.lease_key,
@@ -612,6 +624,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			 */
 			list_del(&cfid->entry);
 			cfid->on_list = false;
+			spin_unlock(&cfid->fid_lock);
 			cfids->num_entries--;
 
 			++tcon->tc_count;
@@ -621,6 +634,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
 		}
+		spin_unlock(&cfid->fid_lock);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 	return false;
@@ -656,9 +670,6 @@ static void free_cached_dir(struct cached_fid *cfid)
 	WARN_ON(work_pending(&cfid->close_work));
 	WARN_ON(work_pending(&cfid->put_work));
 
-	dput(cfid->dentry);
-	cfid->dentry = NULL;
-
 	/*
 	 * Delete all cached dirent names
 	 */
@@ -703,6 +714,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+		spin_lock(&cfid->fid_lock);
 		if (cfid->time &&
 		    time_after(jiffies, cfid->time + HZ * dir_cache_timeout)) {
 			cfid->on_list = false;
@@ -717,6 +729,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 			} else
 				kref_get(&cfid->refcount);
 		}
+		spin_unlock(&cfid->fid_lock);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
@@ -726,7 +739,6 @@ static void cfids_laundromat_worker(struct work_struct *work)
 		spin_lock(&cfid->fid_lock);
 		dentry = cfid->dentry;
 		cfid->dentry = NULL;
-		spin_unlock(&cfid->fid_lock);
 
 		dput(dentry);
 		if (cfid->is_open) {
@@ -742,6 +754,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 			 * was one) or the extra one acquired.
 			 */
 			kref_put(&cfid->refcount, smb2_close_cached_fid);
+		spin_unlock(&cfid->fid_lock);
 	}
 	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
 			   dir_cache_timeout * HZ);
-- 
2.43.0

