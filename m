Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A159910957
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 03:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749698702; cv=none; b=tvdQYUsDHEnFqnsycKBdygHlBmWDxgxSF0OiqyHZbKXfuUCHnpqmIor+GKeEo81XGpzTc0XMKAbzgDauKylicwddLMQkITex980igxk+4PfQqplFeSQSoMFnjcePFq2LH8P2eB1wTIw0yqOe1qoaM5l9p2KTJuJ2krlGLA7A9G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749698702; c=relaxed/simple;
	bh=fcf1nws1n4K7afRBpLZFzes9FJFhvNWxdEFyd28mhAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Deg87tLu2YN+oh2IcM/KivPnTDoP7FNJevI5wyh+NW3H4CvEILvx0i49FZD2nx/vs1ZPvX5ka4trOYZ7rHGA6ukE/BOAIA0wB04jra03kDH2b49/Vy8KPn7zjqqJmC0M/pIwZULysHGs+4VNKH6CbeAQW6E8YRHr0oFKXdhtFbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=QYJ/q9mQ; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=PEiHnvvC; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="QYJ/q9mQ";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="PEiHnvvC"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1749698700; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : in-reply-to : from;
 bh=kYJinFVUmSL4oc0Frp8m+zypGtbN6hGgGBSbnqD4p3Q=;
 b=QYJ/q9mQyX6638C4FSuAl51548Gpr1emyY9kD4NSc5cEe8O642H9xZEXZzRMWwhRw4pWS
 7+Y6MPB7X1HIhjQDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1749698700; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : in-reply-to : from;
 bh=kYJinFVUmSL4oc0Frp8m+zypGtbN6hGgGBSbnqD4p3Q=;
 b=PEiHnvvCrrBMcyJXjivpZAOZb90qExoPDhXz1yZwqQMPhAFVNx7tNiebp7lk1Y8VWVmIn
 fPuv5d/OS+F4pJ3+SX0/MjDorMutczCXcZMxgHMflyf2I67hGNq97KlT10GqueTOax1Y98G
 ljEkj22zAcu4DjPHM8OHt+zk8Vu8biG1t+hQITlXAn+LHQP/gdxj8J2NtTIqVyGigqPm/vc
 ZptB+ONSJ49gD1xdlCyEC+XSpTOCKUh8XeOkawf6bExb9ClGWY36oynaoz5YLkDs4p/6t2N
 QgvUO+utMttXuga2+bAR7MJWCgicM9t1yJ/l986lU2T3o9Eb4TXqLR0EafeQ==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256
	 client-signature ED25519)
	(Client CN "otters", Issuer "otters" (not verified))
	by o-chul.darkrain42.org (Postfix) with ESMTPS id 050A08303;
	Wed, 11 Jun 2025 20:25:00 -0700 (PDT)
Received: by vaarsuvius.home.arpa (Postfix, from userid 1000)
	id C20958C1E05; Wed, 11 Jun 2025 20:24:59 -0700 (PDT)
Date: Wed, 11 Jun 2025 20:24:59 -0700
From: Paul Aurich <paul@darkrain42.org>
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com, pc@manguebit.com,
	henrique.carvalho@suse.com, ematsumiya@suse.de,
	Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 2/7] cifs: protect cfid accesses with fid_lock
Message-ID: <aEpIiybxbTbIbDBP@vaarsuvius.home.arpa>
Mail-Followup-To: nspmangalore@gmail.com, linux-cifs@vger.kernel.org,
	smfrench@gmail.com, bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com, pc@manguebit.com,
	henrique.carvalho@suse.com, ematsumiya@suse.de,
	Shyam Prasad N <sprasad@microsoft.com>
References: <20250604101829.832577-1-sprasad@microsoft.com>
 <20250604101829.832577-2-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250604101829.832577-2-sprasad@microsoft.com>

On 2025-06-04 15:48:11 +0530, nspmangalore@gmail.com wrote:
>From: Shyam Prasad N <sprasad@microsoft.com>
>
>There are several accesses to cfid structure today without
>locking fid_lock. This can lead to race conditions that are
>hard to debug.
>
>With this change, I'm trying to make sure that accesses to cfid
>struct members happen with fid_lock held.
>
>Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>---
> fs/smb/client/cached_dir.c | 86 ++++++++++++++++++++++----------------
> 1 file changed, 49 insertions(+), 37 deletions(-)
>
>diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>index e6fc92667d41..e62d3bebff9a 100644
>--- a/fs/smb/client/cached_dir.c
>+++ b/fs/smb/client/cached_dir.c
>@@ -31,6 +31,7 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
>
> 	spin_lock(&cfids->cfid_list_lock);
> 	list_for_each_entry(cfid, &cfids->entries, entry) {
>+		spin_lock(&cfid->fid_lock);
> 		if (!strcmp(cfid->path, path)) {
> 			/*
> 			 * If it doesn't have a lease it is either not yet
>@@ -38,13 +39,16 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
> 			 * being deleted due to a lease break.
> 			 */
> 			if (!cfid->time || !cfid->has_lease) {
>+				spin_unlock(&cfid->fid_lock);
> 				spin_unlock(&cfids->cfid_list_lock);
> 				return NULL;
> 			}
> 			kref_get(&cfid->refcount);
>+			spin_unlock(&cfid->fid_lock);
> 			spin_unlock(&cfids->cfid_list_lock);
> 			return cfid;
> 		}
>+		spin_unlock(&cfid->fid_lock);
> 	}
> 	if (lookup_only) {
> 		spin_unlock(&cfids->cfid_list_lock);
>@@ -193,19 +197,20 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 		kfree(utf16_path);
> 		return -ENOENT;
> 	}
>+
> 	/*
> 	 * Return cached fid if it is valid (has a lease and has a time).
> 	 * Otherwise, it is either a new entry or laundromat worker removed it
> 	 * from @cfids->entries.  Caller will put last reference if the latter.
> 	 */
>-	spin_lock(&cfids->cfid_list_lock);
>+	spin_lock(&cfid->fid_lock);
> 	if (cfid->has_lease && cfid->time) {
>-		spin_unlock(&cfids->cfid_list_lock);
>+		spin_unlock(&cfid->fid_lock);
> 		*ret_cfid = cfid;
> 		kfree(utf16_path);
> 		return 0;
> 	}
>-	spin_unlock(&cfids->cfid_list_lock);
>+	spin_unlock(&cfid->fid_lock);
>
> 	/*
> 	 * Skip any prefix paths in @path as lookup_noperm_positive_unlocked() ends up
>@@ -220,17 +225,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 		goto out;
> 	}
>
>-	if (!npath[0]) {
>-		dentry = dget(cifs_sb->root);
>-	} else {
>-		dentry = path_to_dentry(cifs_sb, npath);
>-		if (IS_ERR(dentry)) {
>-			rc = -ENOENT;
>-			goto out;
>-		}
>-	}
>-	cfid->dentry = dentry;
>-	cfid->tcon = tcon;

I think moving this down below to after the "At this point the directory 
handle is fully cached" comment is going to regress c353ee4fb119 ("smb: 
Initialize cfid->tcon before performing network ops").

> 	/*
> 	 * We do not hold the lock for the open because in case
>@@ -302,9 +296,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 		}
> 		goto oshr_free;
> 	}
>-	cfid->is_open = true;

Moving this down below is going to regress part of 66d45ca1350a ("cifs: Check 
the lease context if we actually got a lease"), I think. If parsing the lease 
fails, the cfid is disposed, but since `is_open` is false, the code won't call 
SMB2_close.

>-
>-	spin_lock(&cfids->cfid_list_lock);
>
> 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
>@@ -315,7 +306,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>
>
> 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
>-		spin_unlock(&cfids->cfid_list_lock);
> 		rc = -EINVAL;
> 		goto oshr_free;
> 	}
>@@ -324,21 +314,15 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 				 &oparms.fid->epoch,
> 				 oparms.fid->lease_key,
> 				 &oplock, NULL, NULL);
>-	if (rc) {
>-		spin_unlock(&cfids->cfid_list_lock);
>+	if (rc)
> 		goto oshr_free;
>-	}
>
> 	rc = -EINVAL;
>-	if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
>-		spin_unlock(&cfids->cfid_list_lock);
>+	if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
> 		goto oshr_free;
>-	}
> 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
>-	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info)) {
>-		spin_unlock(&cfids->cfid_list_lock);
>+	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
> 		goto oshr_free;
>-	}
> 	if (!smb2_validate_and_copy_iov(
> 				le16_to_cpu(qi_rsp->OutputBufferOffset),
> 				sizeof(struct smb2_file_all_info),
>@@ -346,10 +330,25 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 				(char *)&cfid->file_all_info))
> 		cfid->file_all_info_is_valid = true;
>
>-	cfid->time = jiffies;
>-	spin_unlock(&cfids->cfid_list_lock);
> 	/* At this point the directory handle is fully cached */
> 	rc = 0;
>+	if (!cfid->dentry) {
>+		if (!npath[0]) {
>+			dentry = dget(cifs_sb->root);
>+		} else {
>+			dentry = path_to_dentry(cifs_sb, npath);
>+			if (IS_ERR(dentry)) {
>+				rc = -ENOENT;
>+				goto out;
>+			}
>+		}
>+	}
>+	spin_lock(&cfid->fid_lock);
>+	cfid->dentry = dentry;
>+	cfid->tcon = tcon;
>+	cfid->is_open = true;
>+	cfid->time = jiffies;
>+	spin_unlock(&cfid->fid_lock);
>
> oshr_free:
> 	SMB2_open_free(&rqst[0]);
>@@ -364,6 +363,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 			cfid->on_list = false;
> 			cfids->num_entries--;
> 		}
>+		spin_lock(&cfid->fid_lock);
> 		if (cfid->has_lease) {
> 			/*
> 			 * We are guaranteed to have two references at this
>@@ -373,6 +373,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 			cfid->has_lease = false;
> 			kref_put(&cfid->refcount, smb2_close_cached_fid);
> 		}
>+		spin_unlock(&cfid->fid_lock);
> 		spin_unlock(&cfids->cfid_list_lock);
>
> 		kref_put(&cfid->refcount, smb2_close_cached_fid);
>@@ -401,13 +402,16 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
>
> 	spin_lock(&cfids->cfid_list_lock);
> 	list_for_each_entry(cfid, &cfids->entries, entry) {
>+		spin_lock(&cfid->fid_lock);
> 		if (dentry && cfid->dentry == dentry) {
> 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
> 			kref_get(&cfid->refcount);
>+			spin_unlock(&cfid->fid_lock);
> 			*ret_cfid = cfid;
> 			spin_unlock(&cfids->cfid_list_lock);
> 			return 0;
> 		}
>+		spin_unlock(&cfid->fid_lock);
> 	}
> 	spin_unlock(&cfids->cfid_list_lock);
> 	return -ENOENT;
>@@ -428,8 +432,11 @@ smb2_close_cached_fid(struct kref *ref)
> 	}
> 	spin_unlock(&cfid->cfids->cfid_list_lock);
>
>-	dput(cfid->dentry);
>-	cfid->dentry = NULL;
>+	/* no locking necessary as we're the last user of this cfid */
>+	if (cfid->dentry) {
>+		dput(cfid->dentry);
>+		cfid->dentry = NULL;
>+	}
>
> 	if (cfid->is_open) {
> 		rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
>@@ -452,12 +459,13 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
> 		cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
> 		return;
> 	}
>-	spin_lock(&cfid->cfids->cfid_list_lock);
>+	spin_lock(&cfid->fid_lock);
> 	if (cfid->has_lease) {
>+		/* mark as invalid */
> 		cfid->has_lease = false;
> 		kref_put(&cfid->refcount, smb2_close_cached_fid);
> 	}
>-	spin_unlock(&cfid->cfids->cfid_list_lock);
>+	spin_unlock(&cfid->fid_lock);
> 	close_cached_dir(cfid);
> }
>
>@@ -539,6 +547,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
> 		cfids->num_entries--;
> 		cfid->is_open = false;
> 		cfid->on_list = false;
>+		spin_lock(&cfid->fid_lock);
> 		if (cfid->has_lease) {
> 			/*
> 			 * The lease was never cancelled from the server,
>@@ -547,6 +556,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
> 			cfid->has_lease = false;
> 		} else
> 			kref_get(&cfid->refcount);
>+		spin_unlock(&cfid->fid_lock);
> 	}
> 	/*
> 	 * Queue dropping of the dentries once locks have been dropped
>@@ -601,6 +611,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
>
> 	spin_lock(&cfids->cfid_list_lock);
> 	list_for_each_entry(cfid, &cfids->entries, entry) {
>+		spin_lock(&cfid->fid_lock);
> 		if (cfid->has_lease &&
> 		    !memcmp(lease_key,
> 			    cfid->fid.lease_key,
>@@ -613,6 +624,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
> 			 */
> 			list_del(&cfid->entry);
> 			cfid->on_list = false;
>+			spin_unlock(&cfid->fid_lock);
> 			cfids->num_entries--;
>
> 			++tcon->tc_count;
>@@ -622,6 +634,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
> 			spin_unlock(&cfids->cfid_list_lock);
> 			return true;
> 		}
>+		spin_unlock(&cfid->fid_lock);
> 	}
> 	spin_unlock(&cfids->cfid_list_lock);
> 	return false;
>@@ -657,9 +670,6 @@ static void free_cached_dir(struct cached_fid *cfid)
> 	WARN_ON(work_pending(&cfid->close_work));
> 	WARN_ON(work_pending(&cfid->put_work));
>
>-	dput(cfid->dentry);
>-	cfid->dentry = NULL;
>-
> 	/*
> 	 * Delete all cached dirent names
> 	 */
>@@ -704,6 +714,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
>
> 	spin_lock(&cfids->cfid_list_lock);
> 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
>+		spin_lock(&cfid->fid_lock);
> 		if (cfid->time &&
> 		    time_after(jiffies, cfid->time + HZ * dir_cache_timeout)) {
> 			cfid->on_list = false;
>@@ -718,6 +729,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
> 			} else
> 				kref_get(&cfid->refcount);
> 		}
>+		spin_unlock(&cfid->fid_lock);
> 	}
> 	spin_unlock(&cfids->cfid_list_lock);
>
>@@ -728,8 +740,8 @@ static void cfids_laundromat_worker(struct work_struct *work)
> 		dentry = cfid->dentry;
> 		cfid->dentry = NULL;
> 		spin_unlock(&cfid->fid_lock);
>-
> 		dput(dentry);
>+
> 		if (cfid->is_open) {
> 			spin_lock(&cifs_tcp_ses_lock);
> 			++cfid->tcon->tc_count;
>-- 
>2.43.0

~Paul

