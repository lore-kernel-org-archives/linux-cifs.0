Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8055844C77
	for <linux-cifs@vger.kernel.org>; Wed,  7 May 2025 14:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746626711; cv=none; b=fsRIPgH76vdBnzCKu6rFMbV/zSVZtOKNTnHtgjKrP6urPJqBpZpBdCVufE09tJH05XnDrcPLl7+H4DReKLpQbew+dlDZnEiKAJSD2sEYIwuu7P7RD7YhNA9al4jgw8Yskp94nYQ1VrKQ6BfyfoJh3dMCuap+dA4sn5uxiO93d5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746626711; c=relaxed/simple;
	bh=C2sXimZs5V59Sbs4an+DSM7D6UzBIiq4Dmi+eQ40tOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gxx2/Rn6ORl60MKHuiS1IIan2k8J8XP8g4uWBCxOYiKMxfTr8k9HZgNNUNtQhtyhTFjEByQihyigh0nX1Jg2dxYtH705CFueSzEBOmUGxXSB3jec+QSe4eCg/7MuT40BWo8HRNVIowVIkk5pNcfG8spZFIHz7071zRlU9wkSSnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Z2KtwQ7n; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Z2KtwQ7n"
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-43cf680d351so5719975e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 07 May 2025 07:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746626707; x=1747231507; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p+FHeVvabK3jautRL3mGci1+QLK6P0EYTAbbSTJGVec=;
        b=Z2KtwQ7nUYWd8yola964Ie67xqACCa3xmjLPPy1soTodIBUQCgyRnslcciWZ8F1jBS
         ArtX3/l4hoVNEhddptEV9BEM+gbqfRuGv81Ct7+6C2qPAmoIP1pXCNfjJgNybyatODi2
         cu2z3VVmorlxFUqvt8qt1dINY2XTwVrk2jYvrDiUwIhBtcJ7US/hE01QYtMMqor1IZed
         bdilGjTYZO08PhoSO3qm2xTopZTcZsyhb+5oB/m6/XPd65TsGCoY7PAr99Bosa4DUZeP
         7zyzyggyD5Jkvv6f9tldOAQkgTllb7Hb+tSNyZQZE9GhO5Tsr8+bTI90pGPDd7a27fbN
         6bvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746626707; x=1747231507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+FHeVvabK3jautRL3mGci1+QLK6P0EYTAbbSTJGVec=;
        b=o+0WaAqTYQVPHszQzqXNxnCWSekp1L5Vp2d9ywAM7oj8deR5OsW9SEUtXUqdlV8qxB
         cAdwu15I5BIwVoC5UxiKorGBDlj6z/ww2ffI9erCCpBvxtSSp64LoprVLx00BhMUv9DX
         AzY65xn8HZFlIbWX/Wb6zIec5VJ4E6GsoMaXPojYDyiG9Lbq8oHHed2NpYVeWQWIJg5z
         CXSrweh66N7reBQZ21EKKEN5QVyD9d0DHiuj/J2cnq5ZyC1mAwXMyg3wR7nrrhupvT4M
         12vzEmu0UdnpzbkkyUhusI3+iKYIrhxrz8YYl0R+MCzFN5hY2VcplHkVsOk/aaTKjLEi
         fNjA==
X-Forwarded-Encrypted: i=1; AJvYcCUBo4Rpwu420zlQ2CUOgg3PjDykQDUDPRvG5LMG3mNqg99nOIpiEPns+BfnyFtndz0C6vvJZs5S59Af@vger.kernel.org
X-Gm-Message-State: AOJu0YyUgtJz5fFRw+CEz/621fgkzrk/oc3Mo2MZCADbHqDDzpCA0xWO
	dZqqdU6/K9vxtv/vxUd4zPu9bC2KNFukBD5r9VRvmd5iw3YCxoQf/t8TGF5XZiR5KDKiSSOlt6v
	XsJ76NA==
X-Gm-Gg: ASbGnctYq6Nzh7MGPQNLcY+oBGLN5SFcX4BURYXM0gPCkXb8tVQVl1U/dqMTekkyd7w
	nURLK080OJ84iwD0i8YaRVski8Xfh7dvb3Q9VdqqZVtFuawKrYCWqDi5ylC+oVrMkapO1da3JmC
	9rBSVci8JQiCBTkLMJp+1HGpwN5st5SdhaWnvsc8RyuWFeogXRD20zWAfm5qmBK4KyvDQaqdwRe
	/b2wZrPWF9xlbKzRYpWsDst2D06Y85bAKi35zrNb1GZoQYT3uS47sDm0aYTifLqxxHkMTNdcq05
	BHenfQj9vSyKJdpPQBLIuZao2OfAKXHnB9GzuOlXkG0ErjjlJQ==
X-Google-Smtp-Source: AGHT+IG/UB5u3j/HQ/2UvhnmiA+tHb+VaNru2z/LU84rxGNLTT83Zze8qhA1usiQezuXDdJF+1Nr6A==
X-Received: by 2002:a5d:64ec:0:b0:3a0:ad5d:f479 with SMTP id ffacd0b85a97d-3a0b43d2490mr3264237f8f.13.1746626706494;
        Wed, 07 May 2025 07:05:06 -0700 (PDT)
Received: from precision ([2804:7f0:bc00:f1b9:7b60:60cb:ca83:87b8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30ad4d2f196sm139405a91.14.2025.05.07.07.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 07:05:05 -0700 (PDT)
Date: Wed, 7 May 2025 11:03:26 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Paul Aurich <paul@darkrain42.org>
Cc: ematsumiya@suse.de, sfrench@samba.org, smfrench@gmail.com,
	pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com,
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: avoid dentry leak by not overwriting
 cfid->dentry
Message-ID: <aBtoLiUiLhAS89-W@precision>
References: <20250506223156.121141-1-henrique.carvalho@suse.com>
 <aBr6zohhW9Akuu3a@redcloak.home.arpa>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBr6zohhW9Akuu3a@redcloak.home.arpa>

On Tue, May 06, 2025 at 11:16:46PM -0700, Paul Aurich wrote:
> On 2025-05-06 19:31:56 -0300, Henrique Carvalho wrote:
> > A race, likely between lease break and open, can cause cfid->dentry to
> > be valid when open_cached_dir() tries to set it again. This overwrites
> > the old dentry without dput(), leaking it.
> > 
> > Skip assignment if cfid->dentry is already set.
> > 
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> > fs/smb/client/cached_dir.c | 23 +++++++++++++++--------
> > 1 file changed, 15 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > index 43228ec2424d..8c1f00a3fc29 100644
> > --- a/fs/smb/client/cached_dir.c
> > +++ b/fs/smb/client/cached_dir.c
> > @@ -219,16 +219,23 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> > 		goto out;
> > 	}
> > 
> > -	if (!npath[0]) {
> > -		dentry = dget(cifs_sb->root);
> > -	} else {
> > -		dentry = path_to_dentry(cifs_sb, npath);
> > -		if (IS_ERR(dentry)) {
> > -			rc = -ENOENT;
> > -			goto out;
> > +	/*
> > +	 * BB: cfid->dentry should be NULL here; if not, we're likely racing with
> > +	 * a lease break. This is a temporary workaround to avoid overwriting
> > +	 * a valid dentry. Needs proper fix.
> > +	 */
> 
> Ah ha. I think this is trying to address the same race as Shyam's 'cifs: do
> not return an invalidated cfid' [1].
> 
> What about modifying open_cached_dir to hold cfid_list_lock across the call
> to find_or_create_cached_dir through where it tests for validity, and then
> dropping the locking in find_or_create_cached_dir itself (see attached in
> case my text description isn't clear)?
> 
> That's the only way I can see that a pre-existing cfid could escape to the
> rest of open_cached_dir. I think.
> 
> ~Paul
> 
> [1] https://lore.kernel.org/linux-cifs/20250502051517.10449-2-sprasad@microsoft.com/T/#u
> 
> > +	if (!cfid->dentry) {
> > +		if (!npath[0]) {
> > +			dentry = dget(cifs_sb->root);
> > +		} else {
> > +			dentry = path_to_dentry(cifs_sb, npath);
> > +			if (IS_ERR(dentry)) {
> > +				rc = -ENOENT;
> > +				goto out;
> > +			}
> > 		}
> > +		cfid->dentry = dentry;
> > 	}
> > -	cfid->dentry = dentry;
> > 	cfid->tcon = tcon;
> > 
> > 	/*
> > -- 
> > 2.47.0

> >From 583824153dd901f1f7d63ce9364d32c9c249fd43 Mon Sep 17 00:00:00 2001
> From: Paul Aurich <paul@darkrain42.org>
> Date: Tue, 6 May 2025 22:28:09 -0700
> Subject: [PATCH] smb: client: Avoid race in open_cached_dir with lease breaks
> 
> A pre-existing valid cfid returned from find_or_create_cached_dir might
> race with a lease break, meaning open_cached_dir doesn't consider it
> valid, and thinks it's newly-constructed. This leaks a dentry reference
> if the allocation occurs before the queued lease break work runs.
> 
> Avoid the race by extending holding the cfid_list_lock across
> find_or_create_cached_dir and when the result is checked.
> 
> Signed-off-by: Paul Aurich <paul@darkrain42.org>
> Cc: stable@vger.kernel.org
> ---
>  fs/smb/client/cached_dir.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 10aad87ce679..cb8477c18905 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -27,38 +27,32 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
>  						    bool lookup_only,
>  						    __u32 max_cached_dirs)
>  {
>  	struct cached_fid *cfid;
>  
> -	spin_lock(&cfids->cfid_list_lock);
>  	list_for_each_entry(cfid, &cfids->entries, entry) {
>  		if (!strcmp(cfid->path, path)) {
>  			/*
>  			 * If it doesn't have a lease it is either not yet
>  			 * fully cached or it may be in the process of
>  			 * being deleted due to a lease break.
>  			 */
>  			if (!cfid->time || !cfid->has_lease) {
> -				spin_unlock(&cfids->cfid_list_lock);
>  				return NULL;
>  			}
>  			kref_get(&cfid->refcount);
> -			spin_unlock(&cfids->cfid_list_lock);
>  			return cfid;
>  		}
>  	}
>  	if (lookup_only) {
> -		spin_unlock(&cfids->cfid_list_lock);
>  		return NULL;
>  	}
>  	if (cfids->num_entries >= max_cached_dirs) {
> -		spin_unlock(&cfids->cfid_list_lock);
>  		return NULL;
>  	}
>  	cfid = init_cached_dir(path);
>  	if (cfid == NULL) {
> -		spin_unlock(&cfids->cfid_list_lock);
>  		return NULL;
>  	}
>  	cfid->cfids = cfids;
>  	cfids->num_entries++;
>  	list_add(&cfid->entry, &cfids->entries);
> @@ -72,11 +66,10 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
>  	 * Concurrent processes won't be to use it yet due to @cfid->time being
>  	 * zero.
>  	 */
>  	cfid->has_lease = true;
>  
> -	spin_unlock(&cfids->cfid_list_lock);
>  	return cfid;
>  }
>  
>  static struct dentry *
>  path_to_dentry(struct cifs_sb_info *cifs_sb, const char *path)
> @@ -185,21 +178,22 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  
>  	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
>  	if (!utf16_path)
>  		return -ENOMEM;
>  
> +	spin_lock(&cfids->cfid_list_lock);
>  	cfid = find_or_create_cached_dir(cfids, path, lookup_only, tcon->max_cached_dirs);
>  	if (cfid == NULL) {
> +		spin_unlock(&cfids->cfid_list_lock);
>  		kfree(utf16_path);
>  		return -ENOENT;
>  	}
>  	/*
>  	 * Return cached fid if it is valid (has a lease and has a time).
>  	 * Otherwise, it is either a new entry or laundromat worker removed it
>  	 * from @cfids->entries.  Caller will put last reference if the latter.
>  	 */
> -	spin_lock(&cfids->cfid_list_lock);
>  	if (cfid->has_lease && cfid->time) {
>  		spin_unlock(&cfids->cfid_list_lock);
>  		*ret_cfid = cfid;
>  		kfree(utf16_path);
>  		return 0;
> -- 
> 2.47.2
> 

Yes!

Closing this gap seems to be the only viable fix.

I'm running the tests, but LGTM.


Best,
Henrique
