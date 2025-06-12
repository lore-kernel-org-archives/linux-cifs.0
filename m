Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAD410957
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 03:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749698728; cv=none; b=MWvHYbiLLYAAgb6BsR/SR3tvUBy/lbpko65wgjeInUpwBJKnKXW5JrfnSheUL7Oo91Zd65bGg5IOJKuBypDQBrZ8X328JhJLrLo69SYf9yMIqRD5wgvd8NPYCqV2/aYPsNR29yibarRyfnx5TUWAiNswS2hDf2fKrccd/CG6uNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749698728; c=relaxed/simple;
	bh=hiJuwYcigNyX/u6PQToQR214Mv/c6T8BZtMowqgvInY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXQGFFWi6rMCDkuwefDPVeMsw31Ij86gF4W2+q5OEeksT4Uc9Erps9Do2E+QS+JqjoejISh6c1b3VEGq2DcGIUZ+yqxQtn9Qm+m2lVRK+Z5TkX4EBXwJvcic9fASmqF2YFIjUZMOdSAGv3u3Cu1iZZHX+ZSkBkhr7MHR3IpB6XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=NbGHHGrF; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=qX3jX+Zg; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="NbGHHGrF";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="qX3jX+Zg"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1749698726; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : in-reply-to : from;
 bh=KY/xsiZHgHVbKJ3+pd7YuM5b8S8bvaONm5n27vToJyo=;
 b=NbGHHGrFTt/5UfqKuOsCYNxOozIhTZf/ENnDT+Uma9kKiWqW+2Km5n+QrRiOh2GaV0+rj
 fVSDB+9hUvTFBp6BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1749698726; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : in-reply-to : from;
 bh=KY/xsiZHgHVbKJ3+pd7YuM5b8S8bvaONm5n27vToJyo=;
 b=qX3jX+ZgmE2M2/H4ZxwR7AET/+9GEci2ZClalO7IWP+MLgsyI6n2DG2PgeUoWqXz7IVgN
 zTrABTnSB/cE0iTk4jjmCWwATXUZ/TAmhEaDgWT+ETrJz2gAvmmtgALibtRdt9S1n5qxl60
 H5+bAzfH3OFpoLbSetVMJIud7aZTp2ti9vs0Bd6ayIqZ6PxO863hdQR3XKhIKn/5qPTacEf
 uf9rLMnNjpKKlZ1GJiXpphT/3RQvNz9PuqdHFhBOz88HyaA8D7A3INXFi2xtMzlGUrboAdz
 wffzXRz56lIw2WeUfU5hC7HdC3ZHZNvkaFtp+O2NWC6/FPUCCVf+lnSmjEgA==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256
	 client-signature ED25519)
	(Client CN "otters", Issuer "otters" (not verified))
	by o-chul.darkrain42.org (Postfix) with ESMTPS id E5C508303;
	Wed, 11 Jun 2025 20:25:26 -0700 (PDT)
Received: by vaarsuvius.home.arpa (Postfix, from userid 1000)
	id E8C358C1E05; Wed, 11 Jun 2025 20:25:25 -0700 (PDT)
Date: Wed, 11 Jun 2025 20:25:25 -0700
From: Paul Aurich <paul@darkrain42.org>
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com, pc@manguebit.com,
	henrique.carvalho@suse.com, ematsumiya@suse.de,
	Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 4/7] cifs: serialize initialization and cleanup of cfid
Message-ID: <aEpIpa3gbbz-nk86@vaarsuvius.home.arpa>
Mail-Followup-To: nspmangalore@gmail.com, linux-cifs@vger.kernel.org,
	smfrench@gmail.com, bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com, pc@manguebit.com,
	henrique.carvalho@suse.com, ematsumiya@suse.de,
	Shyam Prasad N <sprasad@microsoft.com>
References: <20250604101829.832577-1-sprasad@microsoft.com>
 <20250604101829.832577-4-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250604101829.832577-4-sprasad@microsoft.com>

On 2025-06-04 15:48:13 +0530, nspmangalore@gmail.com wrote:
>From: Shyam Prasad N <sprasad@microsoft.com>
>
>Today we can have multiple processes calling open_cached_dir
>and other workers freeing the cached dir all in parallel.
>Although small sections of this code is locked to protect
>individual fields, there can be races between these threads
>which can be hard to debug.
>
>This patch serializes all initialization and cleanup of
>the cfid struct and the associated resources: dentry and
>the server handle.
>
>Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>---
> fs/smb/client/cached_dir.c | 16 ++++++++++++++++
> fs/smb/client/cached_dir.h |  1 +
> 2 files changed, 17 insertions(+)
>
>diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>index 94538f52dfc8..2746d693d80a 100644
>--- a/fs/smb/client/cached_dir.c
>+++ b/fs/smb/client/cached_dir.c
>@@ -198,6 +198,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 		return -ENOENT;
> 	}
>
>+	/*
>+	 * the following is a critical section. We need to make sure that the
>+	 * callers are serialized per-cfid
>+	 */
>+	mutex_lock(&cfid->cfid_mutex);
>+
> 	/*
> 	 * check again that the cfid is valid (with mutex held this time).
> 	 * Return cached fid if it is valid (has a lease and has a time).
>@@ -208,11 +214,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 	spin_lock(&cfid->fid_lock);
> 	if (cfid->has_lease && cfid->time) {
> 		spin_unlock(&cfid->fid_lock);
>+		mutex_unlock(&cfid->cfid_mutex);
> 		*ret_cfid = cfid;
> 		kfree(utf16_path);
> 		return 0;
> 	} else if (!cfid->has_lease) {
> 		spin_unlock(&cfid->fid_lock);
>+		mutex_unlock(&cfid->cfid_mutex);
> 		/* drop the ref that we have */
> 		kref_put(&cfid->refcount, smb2_close_cached_fid);
> 		kfree(utf16_path);
>@@ -229,6 +237,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 	 */
> 	npath = path_no_prefix(cifs_sb, path);
> 	if (IS_ERR(npath)) {
>+		mutex_unlock(&cfid->cfid_mutex);

Double mutex_unlock?  (It's also unlocked unconditionally in the 'out' path)

> 		rc = PTR_ERR(npath);
> 		goto out;
> 	}
>@@ -389,6 +398,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 		*ret_cfid = cfid;
> 		atomic_inc(&tcon->num_remote_opens);
> 	}
>+	mutex_unlock(&cfid->cfid_mutex);
>+
> 	kfree(utf16_path);
>
> 	if (is_replayable_error(rc) &&
>@@ -432,6 +443,9 @@ smb2_close_cached_fid(struct kref *ref)
> 					       refcount);
> 	int rc;
>
>+	/* make sure not to race with server open */
>+	mutex_lock(&cfid->cfid_mutex);
>+
> 	spin_lock(&cfid->cfids->cfid_list_lock);
> 	if (cfid->on_list) {
> 		list_del(&cfid->entry);
>@@ -452,6 +466,7 @@ smb2_close_cached_fid(struct kref *ref)
> 		if (rc) /* should we retry on -EBUSY or -EAGAIN? */
> 			cifs_dbg(VFS, "close cached dir rc %d\n", rc);
> 	}
>+	mutex_unlock(&cfid->cfid_mutex);
>
> 	free_cached_dir(cfid);
> }
>@@ -666,6 +681,7 @@ static struct cached_fid *init_cached_dir(const char *path)
> 	INIT_LIST_HEAD(&cfid->entry);
> 	INIT_LIST_HEAD(&cfid->dirents.entries);
> 	mutex_init(&cfid->dirents.de_mutex);
>+	mutex_init(&cfid->cfid_mutex);
> 	spin_lock_init(&cfid->fid_lock);
> 	kref_init(&cfid->refcount);
> 	return cfid;
>diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
>index 1dfe79d947a6..93c936af2253 100644
>--- a/fs/smb/client/cached_dir.h
>+++ b/fs/smb/client/cached_dir.h
>@@ -42,6 +42,7 @@ struct cached_fid {
> 	struct kref refcount;
> 	struct cifs_fid fid;
> 	spinlock_t fid_lock;
>+	struct mutex cfid_mutex;
> 	struct cifs_tcon *tcon;
> 	struct dentry *dentry;
> 	struct work_struct put_work;
>-- 
>2.43.0
>

~Paul

