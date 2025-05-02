Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0471443169
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746198714; cv=none; b=FhFxwxE7fOYbvsPBfM/4gdCpRtg9iCFQwSVIORZzu2sg/gtQtiaEPDINNsYSWzH2X3K9oZmG4gjah2JShqAdYacrzWb2aKd/8XQfA0AzXzCShAbwUFg00w/UwO96nUXO1IyeYOFXGco2t3nm1oxbTW/rL1n3cEKcZC4KvTIkd3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746198714; c=relaxed/simple;
	bh=kr7ctnfd/h+IyfYwQUgKCN9HKu/1OTFYQ/Be7oRUvm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QVGR5gchw6tyzTa52P8gLRp0/oXcMoFHzV0ofeoxXHE6AmyTQcqBuidSDjxCTwGwwuOhZVrQpn+6KugStGPRPulyp6WTNGFpNcve9jmsQoeHqxy0f8VMPHjP7pSjRpL8s3IuInGNGDJ67zBO+kgfwCcpnpNqvmzVpSsnaot536A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LOLnkS86; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LOLnkS86"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39ee57c0b8cso1844510f8f.0
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 08:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746198710; x=1746803510; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4OipznjfOKRSJh/6gWFOfK3IgDJ7Pdr5bBo4SExNsBI=;
        b=LOLnkS86X9vx7WX/mMM/P/28mv18IdDWwpw/37rysYod/XqaW6kmZn8skD5u4tCzsS
         NGdSBwgLMWMldkuZUClPSUfbE8LkvGDytskl0FqqPrTQWAX1NSvOKV8MHrot36EkYey4
         97W3hldOI2xrhUqK1tzyb48cxChPkSXYWfe9WJkgtMGmnHVKVLxYUwX/3THkjAMt/iLL
         5TPbjsfPLkzdcpDaDJmK6jCCi+So3zSoe8iZNqzzORAGKBsQrWd5xvWqpzDjaablE298
         FsZ0HzGlDLot2402MhCcue+YvBvlskAVJsgAhezvRZPENy5ruUip8+awL4SoOR8Qrux5
         khHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746198710; x=1746803510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4OipznjfOKRSJh/6gWFOfK3IgDJ7Pdr5bBo4SExNsBI=;
        b=dVY8wQ53mtIVl65yMK9y11poqSlK6b32jbSuyCIHNHE+c7ZlR1U3s9th/RRDGEGSR8
         JC44W+aOdOFi5MiaZo3/YEZm2zOzdD7H0fO5e8/+g5iCqpfRXgbleUchDtF9DordmR94
         suByzTrtgFJl0AwFmjwqVfi7lL7akd4H5AoYSUYuOLOprp9LG1nBvhX+FRvtPt790q2I
         ha25qUve2/rQ4jWp1/Wp+6iQXP+9K143w5hrUz1QIP1A5ISWwklzFUvusFlFTF4O7h6l
         dkj6cqsacKZ9bUArnIxzkU0NPPAINvma/pwty380GXeLLXrkFYNFmjDqMnJ46/oHaw/i
         DPOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAnyJIRJbep0/Wubgr3OfyPRFS5gEppsP+ScP02Cvlg829H8VBdHB8pXxIHy7tGfKC9GR2Pw3CKOfL@vger.kernel.org
X-Gm-Message-State: AOJu0YxfpN43GCiBp1vD1lMmCBmm/21l51cD+NXpwwLX4Dhub8QvHWJ0
	KA/45mItzjUI9UmlV0bZRrwDpeGxDrHo4am4NFDHCFfV8N3xTTwZyYFNRvCBUxA=
X-Gm-Gg: ASbGncszAbeBy/cJwbSGDf1Maq4J39OQ4hjkpqpmkpyrbdX+ZTC9ZOfPuCVTqYxwHb7
	O6Ad/GdAuBNiAcnBRXk3r/NlpFAH6WmrLYIWlfyLuAB1OY70KJDngHGOTuGfmLQ5DNwV+1CM+RT
	rxA8Tt5JtNEAlO0adgE2P+VBo9cpZ199O/u4ZspIWD9Cj5P42bWgYjVQVDW3VC+eex5MKytuwZG
	O9LaZfr9pvVnCiP9yA4Zeab1x3vMbZj2U3/RfkAnw6BX5yN2TNW56ADz+P61xA86IfdzVoaLiWs
	k2aD1q3S9QUU58hTdhgcIuvdfIXJ6fTy7SMheLP0HZsbR8Am
X-Google-Smtp-Source: AGHT+IH4wIhBB0rC9EXxk1WvFWiF1qkUw33lt/mU7afEriIw+lzin+d0HYZ1zBuTe+LUyDpkQp8CCA==
X-Received: by 2002:a05:6000:3109:b0:39c:2688:612b with SMTP id ffacd0b85a97d-3a099ad30dfmr2776788f8f.7.1746198710079;
        Fri, 02 May 2025 08:11:50 -0700 (PDT)
Received: from precision ([138.121.131.123])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405905fce9sm1668394b3a.128.2025.05.02.08.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 08:11:49 -0700 (PDT)
Date: Fri, 2 May 2025 12:10:04 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: nspmangalore@gmail.com
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, ematsumiya@suse.de,
	pc@manguebit.com, paul@darkrain42.org, ronniesahlberg@gmail.com,
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 3/5] cifs: serialize initialization and cleanup of cfid
Message-ID: <aBTgTCnAn4S-UT9V@precision>
References: <20250502051517.10449-1-sprasad@microsoft.com>
 <20250502051517.10449-3-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502051517.10449-3-sprasad@microsoft.com>

Hi Shyam,

On Fri, May 02, 2025 at 05:13:42AM +0000, nspmangalore@gmail.com wrote:
> From: Shyam Prasad N <sprasad@microsoft.com>
> 
> Today we can have multiple processes calling open_cached_dir
> and other workers freeing the cached dir all in parallel.
> Although small sections of this code is locked to protect
> individual fields, there can be races between these threads
> which can be hard to debug.
> 
> This patch serializes all initialization and cleanup of
> the cfid struct and the associated resources: dentry and
> the server handle.
> 
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cached_dir.c | 16 ++++++++++++++++
>  fs/smb/client/cached_dir.h |  1 +
>  2 files changed, 17 insertions(+)
> 
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index d307636c2679..9aedb6cf66df 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -197,6 +197,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  		return -ENOENT;
>  	}
>  
> +	/*
> +	 * the following is a critical section. We need to make sure that the
> +	 * callers are serialized per-cfid
> +	 */
> +	mutex_lock(&cfid->cfid_mutex);
> +
>  	/*
>  	 * check again that the cfid is valid (with mutex held this time).
>  	 * Return cached fid if it is valid (has a lease and has a time).
> @@ -207,11 +213,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  	spin_lock(&cfid->fid_lock);
>  	if (cfid->has_lease && cfid->time) {
>  		spin_unlock(&cfid->fid_lock);
> +		mutex_unlock(&cfid->cfid_mutex);
>  		*ret_cfid = cfid;
>  		kfree(utf16_path);
>  		return 0;
>  	} else if (!cfid->has_lease) {
>  		spin_unlock(&cfid->fid_lock);
> +		mutex_unlock(&cfid->cfid_mutex);
>  		/* drop the ref that we have */
>  		kref_put(&cfid->refcount, smb2_close_cached_fid);
>  		kfree(utf16_path);
> @@ -228,6 +236,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  	 */
>  	npath = path_no_prefix(cifs_sb, path);
>  	if (IS_ERR(npath)) {
> +		mutex_unlock(&cfid->cfid_mutex);
>  		rc = PTR_ERR(npath);
>  		goto out;
>  	}
> @@ -389,6 +398,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  		*ret_cfid = cfid;
>  		atomic_inc(&tcon->num_remote_opens);
>  	}
> +	mutex_unlock(&cfid->cfid_mutex);
> +
>  	kfree(utf16_path);
>  
>  	if (is_replayable_error(rc) &&
> @@ -432,6 +443,9 @@ smb2_close_cached_fid(struct kref *ref)
>  					       refcount);
>  	int rc;
>  
> +	/* make sure not to race with server open */
> +	mutex_lock(&cfid->cfid_mutex);
> +
>  	spin_lock(&cfid->cfids->cfid_list_lock);
>  	if (cfid->on_list) {
>  		list_del(&cfid->entry);
> @@ -454,6 +468,7 @@ smb2_close_cached_fid(struct kref *ref)
>  	}
>  
>  	free_cached_dir(cfid);
> +	mutex_unlock(&cfid->cfid_mutex);
>  }
>  
>  void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
> @@ -666,6 +681,7 @@ static struct cached_fid *init_cached_dir(const char *path)
>  	INIT_LIST_HEAD(&cfid->entry);
>  	INIT_LIST_HEAD(&cfid->dirents.entries);
>  	mutex_init(&cfid->dirents.de_mutex);
> +	mutex_init(&cfid->cfid_mutex);
>  	spin_lock_init(&cfid->fid_lock);
>  	kref_init(&cfid->refcount);
>  	return cfid;
> diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> index 1dfe79d947a6..93c936af2253 100644
> --- a/fs/smb/client/cached_dir.h
> +++ b/fs/smb/client/cached_dir.h
> @@ -42,6 +42,7 @@ struct cached_fid {
>  	struct kref refcount;
>  	struct cifs_fid fid;
>  	spinlock_t fid_lock;
> +	struct mutex cfid_mutex;
>  	struct cifs_tcon *tcon;
>  	struct dentry *dentry;
>  	struct work_struct put_work;
> -- 
> 2.43.0
> 
>

I might be missing something, but...

First, if smb2_close_cached_fid is the release function, meaning I just
released the last cfid ref. So in my understanding I want to, as fast as
possible, remove this cfid from list so it is not found anymore on
find_or_create_cached_dir and then free the cfid. That mutex inside the
function has the intention of preventing a race with open, but if I have
another cfid waiting to acquire the mutex that will just cause an UAF.

Second, I am not fully convinced that we need a mutex there. :/ I have
thought about it many times and I could not get a proof that there is a
race happening there.

Third, (referencing PATCH 2) even if we have a mutex there, shouldn't we
just let the thread that just acquired the mutex retry to acquire the
lease (which I believe is the current behavior).

Thanks,
Henrique
