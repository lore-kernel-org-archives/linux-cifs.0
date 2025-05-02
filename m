Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38649182
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 12:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746189568; cv=none; b=GfpGTwEQ1ucVcW/Rs/vz6DAhJE0ISdXdAQSssUVxqC/GrPbOPWlMamvrBYZMDhh7LgjDL2W/bg7Wle8wMjlsPuQUmCowDcrqxv9im6mclgG6FD19oZEvOeSrrWtay4wZvR1Ic9r9toj6UKVzf2q6vV+lZNj7plEAafEUpiRj/Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746189568; c=relaxed/simple;
	bh=UE6VP6/8ETu/FyNZ3tqNpoM1nreUNlvwTowukXl10cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=adjkn9MnlGujQSgBdxJWYRfPug1XtWvv+izWfU9zNR6SAwiGxqtV0qMkvIjY6vDTQ0Kf9oxKptTXDRSxhFUcqY97GboISSV5PT1CDPOMkyAi2m3S7LYZzKksbvQpDV857N/tJC4Yhjd5ZeMQzlNZSAg1+1UbdBRhHe5WkPA+MTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BgC50f0W; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BgC50f0W"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac2bb7ca40bso321549166b.3
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 05:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746189563; x=1746794363; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b7p+oYZCMWKEK8x+Pj8kKxSTZcn6i5jgP8konQX4ppM=;
        b=BgC50f0Wl5fsNwdTIY7PqYLhM+WRzFlrkXrzPeo5NxjkwaVmelG2M5GQeQ4AZdzC5x
         6kUiYivdn0GpVx4UxSR+W24YjleQTXYbjjfaaJ6H16hmJ0nvGo4QeSDuKEyNebuQcukl
         qk7oJ1FkYol5qH1hqIe0IH+CxvgIboJJangxX8MhkOE69qwfAL76z1XoQXlew8n5G6iX
         G5oY2IJupiLNbfRg4rYJrhHH9ANIw+nkM9iv5oONApzMBHRzpQ/xmWH7ycEwbd9ZdqER
         CDa+YcHZqo4fqFbNBYke/NqjejEPZzMhXJWDqXwaRjL0cv2MoWvWp7ZXh/DtV4GTxWtU
         hAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746189563; x=1746794363;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7p+oYZCMWKEK8x+Pj8kKxSTZcn6i5jgP8konQX4ppM=;
        b=iWkf5r/XZ3VERuu1a+UIcHgE+o+Ud8g7vr7OAHV5n1hUPwbQlhITEnK7p+pPHBP0nG
         Eoi8xMsuA5T8E8NtiGeEOE9x1Sy+a9vq2Uad35eCIVGjIiLLkLX90+AYny8r9MW9b96y
         b2e6mSJ2rVjmISiiWoqJSIUawZIAtp97OqqvqCer4XzwBGZMFKu8cxsn6ugQ8bLy5MKX
         PS0ofgRBvjURaAmLKCqRsE8W9I07mLTsTkFBk4Lm5bV9yl9VSxhp+pzCkNbjeUWf/SJu
         xhfBgBh876x/f/y00+/jMJfm9wJ3JkId+JjTv3sxuov/5UJWX/fIXf6ysBntAPCuAMcN
         7ihQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfr/S/FcXWQtc3YGG+0ZY23xLalkn4xaMjkjjUalvp7vRIJciwMDTIBHFjsa7dTJQpuUzxtUio7GGb@vger.kernel.org
X-Gm-Message-State: AOJu0YxoHwxORttGb+EY319ITMq8S9S1g94bjt8CFuxO/3lfvNiiJnv7
	EJJOtmyBlHF4vEL1bk68DsTEsKKbR1+YRm9mMFLLC/fdG0ZD5fXlJQ4iO1ULf4Q=
X-Gm-Gg: ASbGncuQIYnr0wz8rNxemHAiRy5vgorrvRPpnprFq1vxyYzU9p+rZEEUlyHYTx2iWRe
	W/E6VfiHG1CjYcv9GnUy7MHvrdrx1Byqko5boIA0W+wqtEppoM2zC1pULIsTToR148eWwuoBOvs
	ln1N3qWJN8TltHlWp+t3ovzpaX0DIrobPRgmSBIsebr4FmAkwnF4s2Br39VPF5p+wn31r+7r5Nc
	KHvcvBNfUbB1W2kY6nlYhWJdVXUzBjTyV/2MUBeaTfnmZODhS7MnqOKCBKL+jCt9h9AE3c3dgeF
	tVRzDAyUcHUdna9tZEaR/Vo8jiWD4YIaZq8YYGCrWYFpkcKa
X-Google-Smtp-Source: AGHT+IGE8f/+2TuSkjDHCcsG0ZUb+Qwd5Z6uqzsudpqAWXSPG/Kl23YR0d/BdpccH5V/9lWcQo78kg==
X-Received: by 2002:a17:907:d30c:b0:ace:c43e:ddc with SMTP id a640c23a62f3a-ad17b868be2mr263145766b.52.1746189563407;
        Fri, 02 May 2025 05:39:23 -0700 (PDT)
Received: from precision ([138.121.131.123])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3c6b6d8sm588157a12.69.2025.05.02.05.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 05:39:22 -0700 (PDT)
Date: Fri, 2 May 2025 09:37:34 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: nspmangalore@gmail.com
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, ematsumiya@suse.de,
	pc@manguebit.com, paul@darkrain42.org, ronniesahlberg@gmail.com,
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 1/5] cifs: protect cfid accesses with fid_lock
Message-ID: <aBS8jg4bcmh6EdwT@precision>
References: <20250502051517.10449-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502051517.10449-1-sprasad@microsoft.com>

Hi Shyam,

On Fri, May 02, 2025 at 05:13:40AM +0000, nspmangalore@gmail.com wrote:
> From: Shyam Prasad N <sprasad@microsoft.com>
> 
> There are several accesses to cfid structure today without
> locking fid_lock. This can lead to race conditions that are
> hard to debug.
> 
> With this change, I'm trying to make sure that accesses to cfid
> struct members happen with fid_lock held.
> 
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cached_dir.c | 87 ++++++++++++++++++++++----------------
>  1 file changed, 50 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index fe738623cf1b..f074675fa6be 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -31,6 +31,7 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
>  
>  	spin_lock(&cfids->cfid_list_lock);
>  	list_for_each_entry(cfid, &cfids->entries, entry) {
> +		spin_lock(&cfid->fid_lock);
>  		if (!strcmp(cfid->path, path)) {
>  			/*
>  			 * If it doesn't have a lease it is either not yet
> @@ -38,13 +39,16 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
>  			 * being deleted due to a lease break.
>  			 */
>  			if (!cfid->time || !cfid->has_lease) {
> +				spin_unlock(&cfid->fid_lock);
>  				spin_unlock(&cfids->cfid_list_lock);
>  				return NULL;
>  			}
>  			kref_get(&cfid->refcount);
> +			spin_unlock(&cfid->fid_lock);
>  			spin_unlock(&cfids->cfid_list_lock);
>  			return cfid;
>  		}
> +		spin_unlock(&cfid->fid_lock);
>  	}
>  	if (lookup_only) {
>  		spin_unlock(&cfids->cfid_list_lock);
> @@ -192,19 +196,20 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  		kfree(utf16_path);
>  		return -ENOENT;
>  	}
> +
>  	/*
>  	 * Return cached fid if it is valid (has a lease and has a time).
>  	 * Otherwise, it is either a new entry or laundromat worker removed it
>  	 * from @cfids->entries.  Caller will put last reference if the latter.
>  	 */
> -	spin_lock(&cfids->cfid_list_lock);
> +	spin_lock(&cfid->fid_lock);
>  	if (cfid->has_lease && cfid->time) {
> -		spin_unlock(&cfids->cfid_list_lock);
> +		spin_unlock(&cfid->fid_lock);
>  		*ret_cfid = cfid;
>  		kfree(utf16_path);
>  		return 0;
>  	}
> -	spin_unlock(&cfids->cfid_list_lock);
> +	spin_unlock(&cfid->fid_lock);
>  
>  	/*
>  	 * Skip any prefix paths in @path as lookup_positive_unlocked() ends up
> @@ -219,17 +224,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  		goto out;
>  	}
>  
> -	if (!npath[0]) {
> -		dentry = dget(cifs_sb->root);
> -	} else {
> -		dentry = path_to_dentry(cifs_sb, npath);
> -		if (IS_ERR(dentry)) {
> -			rc = -ENOENT;
> -			goto out;
> -		}
> -	}
> -	cfid->dentry = dentry;
> -	cfid->tcon = tcon;
>  
>  	/*
>  	 * We do not hold the lock for the open because in case
> @@ -301,9 +295,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  		}
>  		goto oshr_free;
>  	}
> -	cfid->is_open = true;
> -
> -	spin_lock(&cfids->cfid_list_lock);
>  
>  	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
>  	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
> @@ -314,7 +305,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  
>  
>  	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
> -		spin_unlock(&cfids->cfid_list_lock);
>  		rc = -EINVAL;
>  		goto oshr_free;
>  	}
> @@ -323,21 +313,15 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  				 &oparms.fid->epoch,
>  				 oparms.fid->lease_key,
>  				 &oplock, NULL, NULL);
> -	if (rc) {
> -		spin_unlock(&cfids->cfid_list_lock);
> +	if (rc)
>  		goto oshr_free;
> -	}
>  
>  	rc = -EINVAL;
> -	if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
> -		spin_unlock(&cfids->cfid_list_lock);
> +	if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
>  		goto oshr_free;
> -	}
>  	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> -	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info)) {
> -		spin_unlock(&cfids->cfid_list_lock);
> +	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
>  		goto oshr_free;
> -	}
>  	if (!smb2_validate_and_copy_iov(
>  				le16_to_cpu(qi_rsp->OutputBufferOffset),
>  				sizeof(struct smb2_file_all_info),
> @@ -345,10 +329,26 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  				(char *)&cfid->file_all_info))
>  		cfid->file_all_info_is_valid = true;
>  
> -	cfid->time = jiffies;
> -	spin_unlock(&cfids->cfid_list_lock);
>  	/* At this point the directory handle is fully cached */
>  	rc = 0;
> +	spin_lock(&cfid->fid_lock);
> +	if (!cfid->dentry) {
> +		if (!npath[0]) {
> +			dentry = dget(cifs_sb->root);
> +		} else {
> +			dentry = path_to_dentry(cifs_sb, npath);
> +			if (IS_ERR(dentry)) {
> +				spin_unlock(&cfid->fid_lock);
> +				rc = -ENOENT;
> +				goto out;
> +			}
> +		}
> +		cfid->dentry = dentry;
> +	}
> +	cfid->tcon = tcon;
> +	cfid->is_open = true;
> +	cfid->time = jiffies;
> +	spin_unlock(&cfid->fid_lock);
>  
>  oshr_free:
>  	SMB2_open_free(&rqst[0]);
> @@ -363,6 +363,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  			cfid->on_list = false;
>  			cfids->num_entries--;
>  		}
> +		spin_lock(&cfid->fid_lock);
>  		if (cfid->has_lease) {
>  			/*
>  			 * We are guaranteed to have two references at this
> @@ -372,6 +373,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  			cfid->has_lease = false;
>  			kref_put(&cfid->refcount, smb2_close_cached_fid);
>  		}
> +		spin_unlock(&cfid->fid_lock);
>  		spin_unlock(&cfids->cfid_list_lock);
>  
>  		kref_put(&cfid->refcount, smb2_close_cached_fid);
> @@ -400,13 +402,16 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
>  
>  	spin_lock(&cfids->cfid_list_lock);
>  	list_for_each_entry(cfid, &cfids->entries, entry) {
> +		spin_lock(&cfid->fid_lock);
>  		if (dentry && cfid->dentry == dentry) {
>  			cifs_dbg(FYI, "found a cached file handle by dentry\n");
>  			kref_get(&cfid->refcount);
> +			spin_unlock(&cfid->fid_lock);
>  			*ret_cfid = cfid;
>  			spin_unlock(&cfids->cfid_list_lock);
>  			return 0;
>  		}
> +		spin_unlock(&cfid->fid_lock);
>  	}
>  	spin_unlock(&cfids->cfid_list_lock);
>  	return -ENOENT;
> @@ -427,8 +432,11 @@ smb2_close_cached_fid(struct kref *ref)
>  	}
>  	spin_unlock(&cfid->cfids->cfid_list_lock);
>  
> -	dput(cfid->dentry);
> -	cfid->dentry = NULL;
> +	/* no locking necessary as we're the last user of this cfid */
> +	if (cfid->dentry) {
> +		dput(cfid->dentry);
> +		cfid->dentry = NULL;
> +	}
>  
>  	if (cfid->is_open) {
>  		rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
> @@ -451,12 +459,13 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
>  		cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
>  		return;
>  	}
> -	spin_lock(&cfid->cfids->cfid_list_lock);
> +	spin_lock(&cfid->fid_lock);
>  	if (cfid->has_lease) {
> +		/* mark as invalid */
>  		cfid->has_lease = false;
>  		kref_put(&cfid->refcount, smb2_close_cached_fid);
>  	}
> -	spin_unlock(&cfid->cfids->cfid_list_lock);
> +	spin_unlock(&cfid->fid_lock);
>  	close_cached_dir(cfid);
>  }
>  
> @@ -538,6 +547,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
>  		cfids->num_entries--;
>  		cfid->is_open = false;
>  		cfid->on_list = false;
> +		spin_lock(&cfid->fid_lock);
>  		if (cfid->has_lease) {
>  			/*
>  			 * The lease was never cancelled from the server,
> @@ -546,6 +556,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
>  			cfid->has_lease = false;
>  		} else
>  			kref_get(&cfid->refcount);
> +		spin_unlock(&cfid->fid_lock);
>  	}
>  	/*
>  	 * Queue dropping of the dentries once locks have been dropped
> @@ -600,6 +611,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
>  
>  	spin_lock(&cfids->cfid_list_lock);
>  	list_for_each_entry(cfid, &cfids->entries, entry) {
> +		spin_lock(&cfid->fid_lock);
>  		if (cfid->has_lease &&
>  		    !memcmp(lease_key,
>  			    cfid->fid.lease_key,
> @@ -612,6 +624,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
>  			 */
>  			list_del(&cfid->entry);
>  			cfid->on_list = false;
> +			spin_unlock(&cfid->fid_lock);
>  			cfids->num_entries--;
>  
>  			++tcon->tc_count;
> @@ -621,6 +634,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
>  			spin_unlock(&cfids->cfid_list_lock);
>  			return true;
>  		}
> +		spin_unlock(&cfid->fid_lock);
>  	}
>  	spin_unlock(&cfids->cfid_list_lock);
>  	return false;
> @@ -656,9 +670,6 @@ static void free_cached_dir(struct cached_fid *cfid)
>  	WARN_ON(work_pending(&cfid->close_work));
>  	WARN_ON(work_pending(&cfid->put_work));
>  
> -	dput(cfid->dentry);
> -	cfid->dentry = NULL;
> -
>  	/*
>  	 * Delete all cached dirent names
>  	 */
> @@ -703,6 +714,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
>  
>  	spin_lock(&cfids->cfid_list_lock);
>  	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
> +		spin_lock(&cfid->fid_lock);
>  		if (cfid->time &&
>  		    time_after(jiffies, cfid->time + HZ * dir_cache_timeout)) {
>  			cfid->on_list = false;
> @@ -717,6 +729,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
>  			} else
>  				kref_get(&cfid->refcount);
>  		}
> +		spin_unlock(&cfid->fid_lock);
>  	}
>  	spin_unlock(&cfids->cfid_list_lock);
>  
> @@ -726,7 +739,6 @@ static void cfids_laundromat_worker(struct work_struct *work)
>  		spin_lock(&cfid->fid_lock);
>  		dentry = cfid->dentry;
>  		cfid->dentry = NULL;
> -		spin_unlock(&cfid->fid_lock);
>  
>  		dput(dentry);
>  		if (cfid->is_open) {
> @@ -742,6 +754,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
>  			 * was one) or the extra one acquired.
>  			 */
>  			kref_put(&cfid->refcount, smb2_close_cached_fid);
> +		spin_unlock(&cfid->fid_lock);
>  	}
>  	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
>  			   dir_cache_timeout * HZ);

You are calling dput() here with a lock held, both in path_to_dentry and
in smb2_close_cached_fid. Is this correct?

Also, the lock ordering here is lock(fid_lock) -> lock(cifs_tcp_ses_lock) ->
unlock(cifs_tcp_ses_lock) -> unlock(fid_lock), won't this blow up in
another path?

Thanks,
Henrique
