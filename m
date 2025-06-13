Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDD633E1
	for <linux-cifs@vger.kernel.org>; Fri, 13 Jun 2025 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749826599; cv=none; b=IwXsOcR2SC/2YgWLL3nzAGle2VgLNLfYp9VV2Wcxxmbac9f9JdhxkXNe/v/UX9GsN7XBwW2BvEduqRswM3FM4VhUP0mgwjgO+THVNhGh7ppwnuzT1u1YH6a3qVVFlVumVV14/lY2jBXiZrPa2t3Bp6j+Eyv8cQQL0vKDSz/v8XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749826599; c=relaxed/simple;
	bh=D264kdCh4hkjq4Rz73Cj/ktHKxcuNQZ5MDku+aqQ+0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P38WeAFlEsF+UT4GzIewIWc3A9CZrJmXJI8vF6xl1Ve/+BpCXCscXcB5tcBGSjFUSJg1wudlZpO4I2eo9UkmkLTkS/fbsZa1q3jj56d3t91lCf8yZlZ3diYuk1PKP+XpV4epco+bBqkGqD1P8SFC06ENBH23V+F8Zwx2SzmOv+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fg44Jiik; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fg44Jiik"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-23649faf69fso22798865ad.0
        for <linux-cifs@vger.kernel.org>; Fri, 13 Jun 2025 07:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749826597; x=1750431397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V5+ziPrcegBUWuKFiAv8yzTt4+0ZPxhpbDeM/kwH5xk=;
        b=Fg44JiikbZHM1KDJHtwyVxVDJcg6LRSYGJRvN0HqMUt48nerIQFHH4Ww+smsDivU30
         UVlUrvpsLsDLXDqXhxUwVAd6EMIdW87VLKO6kullnHc7tmRu4JTo6DJuGZ5Uh1TAFzHR
         dxJmItrOlvm+cwhcNaIO8lqv2cdAb0ve6bHl+8xNselYU4c62LriP1INhQtxtOBqOHzX
         tjhR4NCxTKlxSPHCHv/D0UZD/nlj+E2WyuZQ0lqjCXdAHnyDdsWIhCnQXuU008mmx5tl
         i9rI28oIjkE2eKgUHifGZtusm1DtZwnp+A3zA/VXwKqIRLh6bAdHXf11bxH8F0eWyKfZ
         Hulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749826597; x=1750431397;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V5+ziPrcegBUWuKFiAv8yzTt4+0ZPxhpbDeM/kwH5xk=;
        b=YNU3FsHwk/2XzfMQa48OFlTs+0qh4a/eePQzLcYonmEvsoCavgyRipZQMl1QaugloN
         HtLmKJd5sw20n0EN6N1x2ENy9XTKtPVANgNOLNs8LluUEPwoj7rD78EOnCUBkfBssn/9
         mkQNeXYxknaILVRXndAFjQ5MHjhExgv7MoAEr4pBVrBJOQE4dSul3MwJKM5U8kRZNcjq
         QnpPK7mQ8MvXB/mnnK7kBPVaXpW3Lxo/9zrQa/68L3sxAbDEQkvC5WNFxl0m1YTLRc2V
         lZw6YHBr919J2o4Am4vybxy4v+Wezik2tlsGIAWvxkiSl+o2pZoFw+Ws2EWrIxar4ksV
         BCPA==
X-Gm-Message-State: AOJu0Yx0solxEFc9ZWnO8C9s0RJY+ZjSI/yOTAmCrhEIvQncJpwhm3PG
	YvkG1Kdty9aOv9iplehWAXcTHq0JdXqRpdgNWDKt/d7nYagvm6F7qPJ16ejhvhzF
X-Gm-Gg: ASbGncuTV5gzNjjjuOtE6K6jhlApDgpBCiRDi/rrCZJy7tQZYeRmzuX1ndweO8voqY+
	DWmkRT7XTjmEcaCrEjWY1ilOLqihH88XlGVclqnDffWk5GlqUEcs26DWLNcFfXInWz7uEQBCHks
	VUvVXuYrPPf0rGGMC6bPV0Lz5AyufPq5QC70BWpBHdfzudy9Avl0M6khETOBDoQJdPKa9sbRN1/
	h+7eOtx5Jwb0U/s/O/7oVDm5KJAxJpb89RJC6ivv633Ax20Wq9VcHyuLALCdNog8rkqrL0D3KNe
	/0TLqLhqYDlk8xXm7E1Lcwdwib9Cj+qRdofXEGUq1IW95RayWX34rUV+7Zipuy9J1dZZyWGZx5a
	KMQDA2ox6iZ1xb7dB
X-Google-Smtp-Source: AGHT+IHVyDYEdvi/1NrMaw2K6LzwiG7N6fwEruK95bW2UJil93RR1nruJZDhalE7P3GQn305hVEO7w==
X-Received: by 2002:a17:902:f682:b0:235:ef87:bd50 with SMTP id d9443c01a7336-2365dd3d389mr48439985ad.45.1749826596816;
        Fri, 13 Jun 2025 07:56:36 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365decad8dsm15132595ad.214.2025.06.13.07.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 07:56:36 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/6] cifs: protect cfid accesses with fid_lock
Date: Fri, 13 Jun 2025 20:26:01 +0530
Message-ID: <20250613145627.987042-1-sprasad@microsoft.com>
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
 fs/smb/client/cached_dir.c | 130 +++++++++++++++++++++----------------
 1 file changed, 75 insertions(+), 55 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 373e6b688fe3..5cfad05d9cbf 100644
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
@@ -194,19 +198,20 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
 
 	pfid = &cfid->fid;
 
@@ -223,36 +228,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
-		if (dentry->d_parent && server->dialect >= SMB30_PROT_ID) {
-			struct cached_fid *parent_cfid;
-
-			spin_lock(&cfids->cfid_list_lock);
-			list_for_each_entry(parent_cfid, &cfids->entries, entry) {
-				if (parent_cfid->dentry == dentry->d_parent) {
-					cifs_dbg(FYI, "found a parent cached file handle\n");
-					if (parent_cfid->has_lease && parent_cfid->time) {
-						lease_flags
-							|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
-						memcpy(pfid->parent_lease_key,
-						       parent_cfid->fid.lease_key,
-						       SMB2_LEASE_KEY_SIZE);
-					}
-					break;
-				}
-			}
-			spin_unlock(&cfids->cfid_list_lock);
-		}
-	}
-	cfid->dentry = dentry;
+	spin_lock(&cfid->fid_lock);
 	cfid->tcon = tcon;
+	spin_unlock(&cfid->fid_lock);
 
 	/*
 	 * We do not hold the lock for the open because in case
@@ -324,9 +302,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 		goto oshr_free;
 	}
-	cfid->is_open = true;
-
-	spin_lock(&cfids->cfid_list_lock);
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
@@ -335,9 +310,15 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
+	/*
+	 * regardless of what failures happen from this point, we should close
+	 * the handle.
+	 */
+	spin_lock(&cfid->fid_lock);
+	cfid->is_open = true;
+	spin_unlock(&cfid->fid_lock);
 
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
-		spin_unlock(&cfids->cfid_list_lock);
 		rc = -EINVAL;
 		goto oshr_free;
 	}
@@ -346,21 +327,15 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
@@ -368,10 +343,42 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				(char *)&cfid->file_all_info))
 		cfid->file_all_info_is_valid = true;
 
-	cfid->time = jiffies;
-	spin_unlock(&cfids->cfid_list_lock);
 	/* At this point the directory handle is fully cached */
 	rc = 0;
+	if (!cfid->dentry) {
+		if (!npath[0]) {
+			dentry = dget(cifs_sb->root);
+		} else {
+			dentry = path_to_dentry(cifs_sb, npath);
+			if (IS_ERR(dentry)) {
+				rc = -ENOENT;
+				goto out;
+			}
+			if (dentry->d_parent && server->dialect >= SMB30_PROT_ID) {
+				struct cached_fid *parent_cfid;
+
+				spin_lock(&cfids->cfid_list_lock);
+				list_for_each_entry(parent_cfid, &cfids->entries, entry) {
+					if (parent_cfid->dentry == dentry->d_parent) {
+						cifs_dbg(FYI, "found a parent cached file handle\n");
+						if (parent_cfid->has_lease && parent_cfid->time) {
+							lease_flags
+								|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
+							memcpy(pfid->parent_lease_key,
+							       parent_cfid->fid.lease_key,
+							       SMB2_LEASE_KEY_SIZE);
+						}
+						break;
+					}
+				}
+				spin_unlock(&cfids->cfid_list_lock);
+			}
+		}
+	}
+	spin_lock(&cfid->fid_lock);
+	cfid->dentry = dentry;
+	cfid->time = jiffies;
+	spin_unlock(&cfid->fid_lock);
 
 oshr_free:
 	SMB2_open_free(&rqst[0]);
@@ -386,6 +393,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			cfid->on_list = false;
 			cfids->num_entries--;
 		}
+		spin_lock(&cfid->fid_lock);
 		if (cfid->has_lease) {
 			/*
 			 * We are guaranteed to have two references at this
@@ -395,6 +403,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			cfid->has_lease = false;
 			kref_put(&cfid->refcount, smb2_close_cached_fid);
 		}
+		spin_unlock(&cfid->fid_lock);
 		spin_unlock(&cfids->cfid_list_lock);
 
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
@@ -423,13 +432,16 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 
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
@@ -450,8 +462,11 @@ smb2_close_cached_fid(struct kref *ref)
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
@@ -474,12 +489,13 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
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
 
@@ -561,6 +577,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 		cfids->num_entries--;
 		cfid->is_open = false;
 		cfid->on_list = false;
+		spin_lock(&cfid->fid_lock);
 		if (cfid->has_lease) {
 			/*
 			 * The lease was never cancelled from the server,
@@ -569,6 +586,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 			cfid->has_lease = false;
 		} else
 			kref_get(&cfid->refcount);
+		spin_unlock(&cfid->fid_lock);
 	}
 	/*
 	 * Queue dropping of the dentries once locks have been dropped
@@ -623,6 +641,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
+		spin_lock(&cfid->fid_lock);
 		if (cfid->has_lease &&
 		    !memcmp(lease_key,
 			    cfid->fid.lease_key,
@@ -635,6 +654,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			 */
 			list_del(&cfid->entry);
 			cfid->on_list = false;
+			spin_unlock(&cfid->fid_lock);
 			cfids->num_entries--;
 
 			++tcon->tc_count;
@@ -644,6 +664,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
 		}
+		spin_unlock(&cfid->fid_lock);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 	return false;
@@ -679,9 +700,6 @@ static void free_cached_dir(struct cached_fid *cfid)
 	WARN_ON(work_pending(&cfid->close_work));
 	WARN_ON(work_pending(&cfid->put_work));
 
-	dput(cfid->dentry);
-	cfid->dentry = NULL;
-
 	/*
 	 * Delete all cached dirent names
 	 */
@@ -726,6 +744,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+		spin_lock(&cfid->fid_lock);
 		if (cfid->time &&
 		    time_after(jiffies, cfid->time + HZ * dir_cache_timeout)) {
 			cfid->on_list = false;
@@ -740,6 +759,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 			} else
 				kref_get(&cfid->refcount);
 		}
+		spin_unlock(&cfid->fid_lock);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
@@ -750,8 +770,8 @@ static void cfids_laundromat_worker(struct work_struct *work)
 		dentry = cfid->dentry;
 		cfid->dentry = NULL;
 		spin_unlock(&cfid->fid_lock);
-
 		dput(dentry);
+
 		if (cfid->is_open) {
 			spin_lock(&cifs_tcp_ses_lock);
 			++cfid->tcon->tc_count;
-- 
2.43.0

