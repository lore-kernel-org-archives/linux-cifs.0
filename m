Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4664A41
	for <linux-cifs@vger.kernel.org>; Wed,  5 Nov 2025 13:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762349560; cv=none; b=VM2TjuUIaC6lmpZDhV+48S96s6o0ei62az6u0OgRtTljksOz7OuJs89P3xJkroAO6fCmYIsKWa7o3IGCC9DaRzsB68aSxTwoZTe7xW3/eqKnVnMslCGTgQA0tMSU3thDfyMoXPnJECf9Fmd++Hy1sYhJmTY/SFDg+/NSJi+/xIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762349560; c=relaxed/simple;
	bh=jJNnJnLIewf6etZuyUBlpNNg/Za3etnSaZWGgtOueQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CILxi1oW0+kwf2Xejtvyvl2yJe+f+NoGgiSJzelmx91m1MGT7BlntRguWZsrBA+urtAfY3rX21X/eriF5nVMwqZYMFIjPWEysgjBtMm3v60GYIJObj9py7buPxSipzdgEiXK+9kNKZ/C5gTEoz9DqpZDzCRE/8DKs7S1OqqnbBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JNRis6FO; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JNRis6FO"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-429c7e0282dso3772563f8f.2
        for <linux-cifs@vger.kernel.org>; Wed, 05 Nov 2025 05:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762349556; x=1762954356; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WzTvdsBQ6kREAEgC57jtChXq9QiLBUViFrsdmxMHdCw=;
        b=JNRis6FO5hzq49xZX/D35d2hFwsPB6VBFWOODZ/rmTTkczSvvzfJEKhFkMKelOM51Y
         ttiqbROukwfwyJYQiwXT2D36qpBTOK+U6qy8WOS+iMGxVhwIjQnoBelRN1ATyUbzAEmy
         o4o5wqV9rONehF5awmRt5NcamT53XQqNjFjTmemfALT0byxIvBgp5y2Sj0ZoXNqweZFr
         P6YmNjSrrqUB0tpfCnaaMivC9Y7A9nr7/7GJnYT3mIS9zdQz346ek3n7k/yGAnZyjOJw
         xGp7Q5upkEg6QiZMtNiPtYbBITWFDYmO/GVe84dQ69c7ivcd8NxdKFqMrufm2T6DWOmC
         Nrkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762349556; x=1762954356;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WzTvdsBQ6kREAEgC57jtChXq9QiLBUViFrsdmxMHdCw=;
        b=K7MvrP9kyU5hTQZ5AJSvnRgg46BWz7HlqQ2+XwMmTZdDpw/KS7SIOMqwykl6xNaoTY
         lRPzzLkaxLxCz7fuw14vZU2sOWNzF9tZ2GNW6HMmcJwerKz2M8+Ko/F8FWfVD0g1F8Ok
         KznodxxAPL96l2PPkhbVwPsRg+FD9InTbo4kfp/cnbqmdjbM95Cg3MIyXiF+Ehh52Uwx
         FBu13/8PHRbM9jidb7Q/iYE8l8hQRt6CRg0lTl+pVv30uscopwAq8bPaT/Zuwc8EAdGq
         M27wkG4qroKfeMr9rxmjURSW4Z6kT64lC9pJ4SU+gpjpnJ/MYlrp3nFgReYvbhsXZc3A
         Vf5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVzvrx/f1LPCbY30UmNXxThaYZHh3ydHW05AFuIfaVXpo4G8rENFq4njBpxgIO4anh+Q0TFkbvjBV00@vger.kernel.org
X-Gm-Message-State: AOJu0YyqDj5o5+r/vh/G/LmqCuj7+LP0bYZMNI/eWUGPRL6sg9RVaNWt
	KyoB+ROzvqk62UIV5ZAgR3mThUhohZ6g8KDCocbQrNiN72wJ6Sp/w6euTYBcalYMFsc=
X-Gm-Gg: ASbGncv2m1MsYOaoBTl4SHAXfFPp0mfWNLXAyMp3xYffHcSMKhswJWX10nnBbgblq1z
	2pLsCWpuM1bD1SrdwuE54zP41FoAZ7l6ocBmFNqOLJ/jh2c4l8KjyNuWjfhmwBKPQ6dyNJgz7gY
	l5ehqhjNc+0CJqsZp66RuBMl3QK0chr/CAqcHuZz4+O7D+i6OXdPDZLYZrEct3yHdEv5zxwK4Fl
	x/wY6X96LHR8Vj0Ub4e+LpP07cBnBfMnjyQYegFsWBQOqXdlUkvE8Au0IwGjrw3rr3seCevlRUs
	mFl1qiOZ+fPGPt/t6pxRDI6aUGaHcGIu+OtyIONl3LivHkpvlp7wMfr2ice51Y7MJVxYO6qywal
	aEq9dVHPSRpeSbVV+wEC3VC90jx02a47uXATLCsy1IowTp+bf4LQ0345migbB/5f1wqe3wq8Xaq
	Cu49YLyT+kukZx
X-Google-Smtp-Source: AGHT+IEqmL2W7qBaKcNxVGEIor8mGPdO8EzToDXbsbdyI9xBYWgCq6Po3n2NNtNroY7nIB+YIRbSWg==
X-Received: by 2002:a05:6000:2585:b0:429:cacf:1075 with SMTP id ffacd0b85a97d-429e32e4649mr2831444f8f.17.1762349556028;
        Wed, 05 Nov 2025 05:32:36 -0800 (PST)
Received: from [192.168.15.14] ([152.234.106.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd5777833sm6380144b3a.37.2025.11.05.05.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 05:32:35 -0800 (PST)
Message-ID: <d8aa9dc3-2a94-484b-addb-2ceb18318c54@suse.com>
Date: Wed, 5 Nov 2025 10:30:23 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] smb: client: fix potential UAF in
 smb2_close_cached_fid()
To: Steve French <smfrench@gmail.com>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, ematsumiya@suse.de,
 jaeshin@redhat.com, linux-cifs@vger.kernel.org
References: <20251103225255.908859-1-henrique.carvalho@suse.com>
 <CAH2r5mtSmg-FwgPzEyPF2CFfP1zuc-Qh5CVuBjbEkA8eTA2Mtg@mail.gmail.com>
Content-Language: en-US
From: Henrique Carvalho <henrique.carvalho@suse.com>
In-Reply-To: <CAH2r5mtSmg-FwgPzEyPF2CFfP1zuc-Qh5CVuBjbEkA8eTA2Mtg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Steve,

On 11/4/25 7:42 PM, Steve French wrote:
> One minor comment that AI had on this was on the change to
> fs/smb/client/cached_dir.c (line 447). See below.
> 
>     -spin_lock(&cfid->cfids->cfid_list_lock);
>     +lockdep_assert_held(&cfid->cfids->cfid_list_lock);
> 
> 
> The lockdep_assert_held validates that the lock is held on entry, but
> the function signature __releases(&cfid->cfids->cfid_list_lock)
> indicates the lock is released inside. Consider adding a corresponding
> __acquires annotation to the call sites that call this function via
> kref_put_lock, or document why callers must hold the lock before
> calling kref_put_lock.

But we don't actually acquire the lock every time in close_cached_dir.
Only when (a) refcount is 1; and (b) refcount did not increase after we
acquired the lock. So where should __acquires annotation go?

One option would be adding documentation to smb2_close_cached_fid,
though since it's a release function that shouldn't be called elsewhere,
I'm not sure that adds much value. Do you have thoughts?

> 
> On Mon, Nov 3, 2025 at 5:00 PM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
>>
>> find_or_create_cached_dir() could grab a new reference after kref_put()
>> had seen the refcount drop to zero but before cfid_list_lock is acquired
>> in smb2_close_cached_fid(), leading to use-after-free.
>>
>> Switch to kref_put_lock() so cfid_release() is called with
>> cfid_list_lock held, closing that gap.
>>
>> Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lease is held")
>> Cc: stable@vger.kernel.org
>> Reported-by: Jay Shin <jaeshin@redhat.com>
>> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>> ---
>> V3 -> V4: rebase, added Reviewed-by and Reported-by, add
>> lockdep_assert_held in smb2_close_cached_fid, change commit subject (was
>> "smb: client: fix race in smb2_close_cached_fid()") to clearly state the
>> bug class (UAF)
>> V2 -> V3: rebase, remove unneeded comments, modify commit subject
>> V1 -> V2: kept the original function names and added __releases annotation
>> to silence sparse warning
>> ---
>>  fs/smb/client/cached_dir.c | 16 +++++++++-------
>>  1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>> index b8ac7b7faf61..018055fd2cdb 100644
>> --- a/fs/smb/client/cached_dir.c
>> +++ b/fs/smb/client/cached_dir.c
>> @@ -388,11 +388,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>>                          * lease. Release one here, and the second below.
>>                          */
>>                         cfid->has_lease = false;
>> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +                       close_cached_dir(cfid);
>>                 }
>>                 spin_unlock(&cfids->cfid_list_lock);
>>
>> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +               close_cached_dir(cfid);
>>         } else {
>>                 *ret_cfid = cfid;
>>                 atomic_inc(&tcon->num_remote_opens);
>> @@ -438,12 +438,14 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
>>
>>  static void
>>  smb2_close_cached_fid(struct kref *ref)
>> +__releases(&cfid->cfids->cfid_list_lock)
>>  {
>>         struct cached_fid *cfid = container_of(ref, struct cached_fid,
>>                                                refcount);
>>         int rc;
>>
>> -       spin_lock(&cfid->cfids->cfid_list_lock);
>> +       lockdep_assert_held(&cfid->cfids->cfid_list_lock);
>> +
>>         if (cfid->on_list) {
>>                 list_del(&cfid->entry);
>>                 cfid->on_list = false;
>> @@ -478,7 +480,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
>>         spin_lock(&cfid->cfids->cfid_list_lock);
>>         if (cfid->has_lease) {
>>                 cfid->has_lease = false;
>> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +               close_cached_dir(cfid);
>>         }
>>         spin_unlock(&cfid->cfids->cfid_list_lock);
>>         close_cached_dir(cfid);
>> @@ -487,7 +489,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
>>
>>  void close_cached_dir(struct cached_fid *cfid)
>>  {
>> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +       kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfids->cfid_list_lock);
>>  }
>>
>>  /*
>> @@ -596,7 +598,7 @@ cached_dir_offload_close(struct work_struct *work)
>>
>>         WARN_ON(cfid->on_list);
>>
>> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +       close_cached_dir(cfid);
>>         cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
>>  }
>>
>> @@ -762,7 +764,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
>>                          * Drop the ref-count from above, either the lease-ref (if there
>>                          * was one) or the extra one acquired.
>>                          */
>> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
>> +                       close_cached_dir(cfid);
>>         }
>>         queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
>>                            dir_cache_timeout * HZ);
>> --
>> 2.50.1
>>
>>
> 
> 

-- 
Henrique
SUSE Labs
