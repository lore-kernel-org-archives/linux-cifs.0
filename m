Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4493128D822
	for <linux-cifs@vger.kernel.org>; Wed,  4 Jun 2025 10:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032316; cv=none; b=ZQjYiI6p+jYKSyVxLwoAFGlG/MxiuAcLh6x2atH/bo2pX4G2puodiB4e2LXECxaZAJ3zLom/ZBLetsHZg3k+cV3LxjeUuVDfz6wHbBTO+YaxBKptFAnBD4dRc0x+lVquIabwFqbAs8oRbKO4fpLvvQo0kqod7aQB8kkl7zeMy+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032316; c=relaxed/simple;
	bh=4GMxADMmYz3ufVVoLSqpgDm1Ytl9Cuz59fxz2TWNUG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJSGvt5oHOi85jyv+Wt4wnaeRc1+IjGhEKNcY6o+w5XqZfR3qM9SdbcdHlO1ZGUHLqZk0RyTqk0RwbUhDk4E7SvxqnIpqk/EEiG3T9O8cdMruZYbCzHeZ0FHFNfwkTPSEnddPIfLYGGJFWZCLSTobKwrDJSvaMyrNGaze0jHovU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DoULSQRx; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DoULSQRx"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-234d2d914bcso46671775ad.0
        for <linux-cifs@vger.kernel.org>; Wed, 04 Jun 2025 03:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749032313; x=1749637113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWquOV9BY6VhseYCdcHBMioYvbqBXAbmPQCKk3j+Cac=;
        b=DoULSQRxmgRcqATgfjm8M2BUUHd13x3AQqqw4Q6o8SptOvTie2k7UWrw+G4PEHHzCv
         r/fju/mE7H4ogrCVBjDOu8GVmr49ybOvm442r2UCnUwwN4vGJKc/Ti4oj5hCkoUKJ4nz
         e8A56klh4xdGoNi802lasUYXCeePkLCqyyuK0I6vZ24pPeU8v+gcqVJW0JO8XQCygLpB
         ocdjPhG/Wvsz7WG11kaDkPErVKTC+71bU0Sr96ZdISj/OppEk/ALwwyTJ2Gf3E+heOmz
         4P4LiixMegMiobAOozcEE+/a1n+4erc/aQ6a7o4K5sRJz1DL8WXe0D+zA0AIBPtxOdtC
         cHYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749032313; x=1749637113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vWquOV9BY6VhseYCdcHBMioYvbqBXAbmPQCKk3j+Cac=;
        b=GzzYoBxuNkdi3q9TtXV0hEyQBqm0xduUAvrak95bs2MmNTa3TCeCIUdCQzdfunLHvw
         lFGp3fugVjFV9WjDnzf/KpI2wNkAya3T51vwTTrHzAQouPi/VaeXxod3cGs4zQd/fT/7
         qZsP3mZaYdRNSFPrsfVHz/rwxiiusfEIOqY+tcIZ/KtS8AEMjtiJBg32CC6YAzppXPVc
         DKawHljbI1NyZpL2JlN10iqDR11NURd2eWSEH0x+DwcGFbBZUP3DoL7vkV+7knSn09SH
         SOYETnJFHWzvUdnHA07L8UMCYao/H3YPrWNJ2ng0BVtAJAbpwvH2a7RTZ8waFWybSyRQ
         KxOg==
X-Gm-Message-State: AOJu0YyyZP7xGgS1U9fBmSQeTWhq2OWfyxMSdTtRxY9z8M95EsO5QPwj
	dJkR3lUOX+fqqUNSe4hIflBWqXHsc3GLk32bpcU34AUATFnpRY8ZJAZa+Bv3PKVb
X-Gm-Gg: ASbGncu2Gpz+vCeEYwhI2Pb2Iix9PEEJG3blmkje3i8ELYUa1Fbh3rZMVdVVO5Ly+7p
	bHM8HCqxJ9DaWQYl6UeP6PkYSt0cpZvY6D0RKG/mFgcOB1IzgfIZqTfD5GH2usMl+j4PS/1O9ed
	smiw7MBNaajYZte+RLJ8jSX3jk+VfNAptLD85nfNzPWcyiOSL7Ba8IalDp4VVamXLnZM01pR53C
	g9UhNpsDoEKl/WOX24qv3zSZiv3P3sF3uHSfq8CL5O8my4aIhVmk1WOTD0/9+eJ9rUrit5Bk0RB
	YW0jEY4yJH7ngkWJe84qO1DVi1/OdeSvYNOeV5Cq/gd+BbfB9Lp7dQwmU7Oc6/cdXJU/Na7E2SS
	fXxM=
X-Google-Smtp-Source: AGHT+IGh7y3VU2moMj1NSOaA8ZWchxyo8PyBlNcuvjEIcma0A1WtkrQdlKGyBPA3UhkOW/56gdPQEQ==
X-Received: by 2002:a17:902:d502:b0:234:914b:3841 with SMTP id d9443c01a7336-235e1504e22mr33357765ad.39.1749032313060;
        Wed, 04 Jun 2025 03:18:33 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506bf8132sm100563625ad.106.2025.06.04.03.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 03:18:32 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com,
	paul@darkrain42.org,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/7] cifs: protect cfid accesses with fid_lock
Date: Wed,  4 Jun 2025 15:48:11 +0530
Message-ID: <20250604101829.832577-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250604101829.832577-1-sprasad@microsoft.com>
References: <20250604101829.832577-1-sprasad@microsoft.com>
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
 fs/smb/client/cached_dir.c | 86 ++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 37 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index e6fc92667d41..e62d3bebff9a 100644
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
@@ -193,19 +197,20 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
 	 * Skip any prefix paths in @path as lookup_noperm_positive_unlocked() ends up
@@ -220,17 +225,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
@@ -302,9 +296,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 		goto oshr_free;
 	}
-	cfid->is_open = true;
-
-	spin_lock(&cfids->cfid_list_lock);
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
@@ -315,7 +306,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
-		spin_unlock(&cfids->cfid_list_lock);
 		rc = -EINVAL;
 		goto oshr_free;
 	}
@@ -324,21 +314,15 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
@@ -346,10 +330,25 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
+		}
+	}
+	spin_lock(&cfid->fid_lock);
+	cfid->dentry = dentry;
+	cfid->tcon = tcon;
+	cfid->is_open = true;
+	cfid->time = jiffies;
+	spin_unlock(&cfid->fid_lock);
 
 oshr_free:
 	SMB2_open_free(&rqst[0]);
@@ -364,6 +363,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			cfid->on_list = false;
 			cfids->num_entries--;
 		}
+		spin_lock(&cfid->fid_lock);
 		if (cfid->has_lease) {
 			/*
 			 * We are guaranteed to have two references at this
@@ -373,6 +373,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			cfid->has_lease = false;
 			kref_put(&cfid->refcount, smb2_close_cached_fid);
 		}
+		spin_unlock(&cfid->fid_lock);
 		spin_unlock(&cfids->cfid_list_lock);
 
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
@@ -401,13 +402,16 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 
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
@@ -428,8 +432,11 @@ smb2_close_cached_fid(struct kref *ref)
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
@@ -452,12 +459,13 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
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
 
@@ -539,6 +547,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 		cfids->num_entries--;
 		cfid->is_open = false;
 		cfid->on_list = false;
+		spin_lock(&cfid->fid_lock);
 		if (cfid->has_lease) {
 			/*
 			 * The lease was never cancelled from the server,
@@ -547,6 +556,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 			cfid->has_lease = false;
 		} else
 			kref_get(&cfid->refcount);
+		spin_unlock(&cfid->fid_lock);
 	}
 	/*
 	 * Queue dropping of the dentries once locks have been dropped
@@ -601,6 +611,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
+		spin_lock(&cfid->fid_lock);
 		if (cfid->has_lease &&
 		    !memcmp(lease_key,
 			    cfid->fid.lease_key,
@@ -613,6 +624,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			 */
 			list_del(&cfid->entry);
 			cfid->on_list = false;
+			spin_unlock(&cfid->fid_lock);
 			cfids->num_entries--;
 
 			++tcon->tc_count;
@@ -622,6 +634,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
 		}
+		spin_unlock(&cfid->fid_lock);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 	return false;
@@ -657,9 +670,6 @@ static void free_cached_dir(struct cached_fid *cfid)
 	WARN_ON(work_pending(&cfid->close_work));
 	WARN_ON(work_pending(&cfid->put_work));
 
-	dput(cfid->dentry);
-	cfid->dentry = NULL;
-
 	/*
 	 * Delete all cached dirent names
 	 */
@@ -704,6 +714,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+		spin_lock(&cfid->fid_lock);
 		if (cfid->time &&
 		    time_after(jiffies, cfid->time + HZ * dir_cache_timeout)) {
 			cfid->on_list = false;
@@ -718,6 +729,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 			} else
 				kref_get(&cfid->refcount);
 		}
+		spin_unlock(&cfid->fid_lock);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
@@ -728,8 +740,8 @@ static void cfids_laundromat_worker(struct work_struct *work)
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

