Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CDB3358D5
	for <linux-cifs@vger.kernel.org>; Wed,  5 Nov 2025 16:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762359508; cv=none; b=tR5kjEs50biu54JRHm8hvPl6W9Zo5fKJYyQhZHYPUXAggHz+oRLUVSm2ECcm9iRiFLLQ8Q0xed8aObdyDBQ7DUf7FQ6XB89sjwgSIK28VMYL9aVLj+kY8x7K5fQddtIc2xDKNIyhDT8Iv0N8cgPF97q3CRxQN9q2HwNq7/oCU6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762359508; c=relaxed/simple;
	bh=K0OC+j65O/fa2V3hIvnOGZ10k9EO1zoxN0uyyXz0Gck=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=BCB+qq+FI/WhbqxWH91rSvlox5zFWTw+Ykj3MAd5lilPBzjNgPCbvGo1C8zuEcZg9ZaGF3q/pyXgWqvVXTC9UuBb7eUcIYwvDklyWJ+/DXoKoO//G7q/zse9k7Yrxbu2gkksz0FmK1jXepi2k5m8h1J3CGXJ8qLxPENsWCvNFjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b+JjEKm8; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b+JjEKm8"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3ecde0be34eso645058f8f.1
        for <linux-cifs@vger.kernel.org>; Wed, 05 Nov 2025 08:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762359504; x=1762964304; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JKmufh7optOuo89GlQIb6/0bSO/4avNYARkFogSIKMM=;
        b=b+JjEKm8dQvRIF3TYKJJK2a0NkYrwnaDbAahUaqI70xEwsfB74w25JgOJBBLA11ZUt
         h0zjdhjiIg7+XaVJowRQQ8yM0wfMy1dy/jfBZuy2Go34n38/jHjCLodm42O9Zu8BZYyz
         9V2zGDUm/evaPKPIFD2knq0RbfpNmJjCKXk7wd7z3FwqeVBy0EaXOZ3rm5EolLININR8
         6JtwAbNoCYOgmtViBtBJLWsM+rMUbgf+ZT0u4QFGuT4PB1kd/8bWAxdRkWoGLvrW3xPF
         AiodVDIs8t5ET6zQCaJAFESeCZNr95Nw7aqDLWP67P0Ru41stG54zj058LQQkLNgYdzG
         pOBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762359504; x=1762964304;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JKmufh7optOuo89GlQIb6/0bSO/4avNYARkFogSIKMM=;
        b=nIuBG6SJvA1rkM7Edny9Vyfd4oKrksibZqnWTZlFXfIcmrsZdN2PCc1wh8w+qZC+Jj
         hmLHGrDOXijWxl9S2qEdALamupDIQMF67Ch9OtiCnUtJ41TYBKGn3OeZU4TpqcXc138O
         JP0yx/EodgErhzjVnkDHuqZVYq5tY/pshL7MAXu4Bp2AKHvPMdL3o4tBHT9wEMz0/pRv
         aIltBpIyznKiTKb8q4czVb2I3LTBJ+3cQGnoo3gCmvfg+SHfeyTkynXaespMkn8jp4Q7
         O8HWG8X+FKXlPrQRhUw5Zd451kuGDyM+q+yUsf8a/XIwTnBVimMC+zcySJIwOiZAeIKx
         zf2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWpibqSfMfVdEQy073Jz+mkYVFosY96mnV6I6hr8neDsYTwaIqZC3hdmyr3vqUkfo3tdbUGDeHMXkOI@vger.kernel.org
X-Gm-Message-State: AOJu0YxNJ6uVyGK/LoQ7Lwv9FHTEC0PsMe4SYz5ACfdKDyKzmySbUbFD
	+UmWwL97LG6iNtiNLwVc2lxXmqmoLPTmga2oUnUidv/0Tbd8GacUVF14Ok+OTTWp0fk=
X-Gm-Gg: ASbGnct9GV93CKTq02RQK66tTmriuRuuuKWIeiqSiWIGrPepAsOCsTUy7LGZLx2OBNi
	Nvq5389HAITJ3S6zMLaDQJqk/ryrHGYW1iTRou0aSEz17kNEMzTMH8RFptJ8g1udKFkU8o5EQ4v
	cIV6bbTk7gghkaH1MfbIsJAXA/TjgcQTLB+RHWgfvA4auWKGPHDXk8tVhBA4LW3XyGQsq9/g71t
	0sxcztDVfgc0p1ASEVbu0CuLhsvOv6WnFzQsC3eWxUTOOHxvNKqahK6sbu2f6WjmOv1++fOQ+sv
	CAh25eFRUghN1lLUIYSQYrtS0P3Q4fw6+QFypCAa2T1zXZ4al1ayZQR6hMbSYT/dObAcXoTlUAv
	acsQsKgRZVI7Oc5ksrSBHwU1lk3EwZO5PYKgZsBuAFB/dclGNGJT6I6TRhxuFh1YSjiAJLPX2DV
	7BQIAVK+60PILr
X-Google-Smtp-Source: AGHT+IGhAupCj3ThM9zYtP9C2DiUKXzpUtf+Jir8zV0gl709ovL7KjxMMlKAFhAbFM1m2m4Z5U+Zmw==
X-Received: by 2002:a05:6000:420b:b0:429:bfbb:5dae with SMTP id ffacd0b85a97d-429dbcfe4c0mr7384155f8f.17.1762359504277;
        Wed, 05 Nov 2025 08:18:24 -0800 (PST)
Received: from [192.168.15.14] ([152.234.106.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba1f1831141sm6090946a12.4.2025.11.05.08.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 08:18:23 -0800 (PST)
Message-ID: <9d2bfeac-d6d8-4299-87f0-791ff9940971@suse.com>
Date: Wed, 5 Nov 2025 13:16:11 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] smb: client: fix potential UAF in
 smb2_close_cached_fid()
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Steve French <smfrench@gmail.com>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, ematsumiya@suse.de,
 jaeshin@redhat.com, linux-cifs@vger.kernel.org
References: <20251103225255.908859-1-henrique.carvalho@suse.com>
 <CAH2r5mtSmg-FwgPzEyPF2CFfP1zuc-Qh5CVuBjbEkA8eTA2Mtg@mail.gmail.com>
 <d8aa9dc3-2a94-484b-addb-2ceb18318c54@suse.com>
Content-Language: en-US
In-Reply-To: <d8aa9dc3-2a94-484b-addb-2ceb18318c54@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/5/25 10:30 AM, Henrique Carvalho wrote:
> Hi Steve,
> 
> On 11/4/25 7:42 PM, Steve French wrote:
>> One minor comment that AI had on this was on the change to
>> fs/smb/client/cached_dir.c (line 447). See below.
>>
>>     -spin_lock(&cfid->cfids->cfid_list_lock);
>>     +lockdep_assert_held(&cfid->cfids->cfid_list_lock);
>>
>>
>> The lockdep_assert_held validates that the lock is held on entry, but
>> the function signature __releases(&cfid->cfids->cfid_list_lock)
>> indicates the lock is released inside. Consider adding a corresponding
>> __acquires annotation to the call sites that call this function via
>> kref_put_lock, or document why callers must hold the lock before
>> calling kref_put_lock.
> 
> But we don't actually acquire the lock every time in close_cached_dir.
> Only when (a) refcount is 1; and (b) refcount did not increase after we
> acquired the lock. So where should __acquires annotation go?
> 
> One option would be adding documentation to smb2_close_cached_fid,
> though since it's a release function that shouldn't be called elsewhere,
> I'm not sure that adds much value. Do you have thoughts?
> 

I think it's worth adding that kref_put_lock uses refcount_dec_and_lock,
which is defined as

extern __must_check bool refcount_dec_and_lock(refcount_t *r, spinlock_t
*lock) __cond_acquires(lock);

__cond_acquires() was introduced in commit 4a557a5d1a614 ("sparse:
introduce conditional lock acquire function attribute").

So in a sense, if I understand it correctly, the "acquires" is already
there to make the sparse __releases annotation work. This should be
enough to satisfy the comment the AI raised.

>>
>> On Mon, Nov 3, 2025 at 5:00 PM Henrique Carvalho
>> <henrique.carvalho@suse.com> wrote:
>>>
>>> find_or_create_cached_dir() could grab a new reference after kref_put()
>>> had seen the refcount drop to zero but before cfid_list_lock is acquired
>>> in smb2_close_cached_fid(), leading to use-after-free.
>>>
>>> Switch to kref_put_lock() so cfid_release() is called with
>>> cfid_list_lock held, closing that gap.
>>>
>>> Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lease is held")
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Jay Shin <jaeshin@redhat.com>
>>> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>>> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>>> ---
>>> V3 -> V4: rebase, added Reviewed-by and Reported-by, add
>>> lockdep_assert_held in smb2_close_cached_fid, change commit subject (was
>>> "smb: client: fix race in smb2_close_cached_fid()") to clearly state the
>>> bug class (UAF)
>>> V2 -> V3: rebase, remove unneeded comments, modify commit subject
>>> V1 -> V2: kept the original function names and added __releases annotation
>>> to silence sparse warning
>>> ---
>>>  fs/smb/client/cached_dir.c | 16 +++++++++-------
>>>  1 file changed, 9 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>>> index b8ac7b7faf61..018055fd2cdb 100644
>>> --- a/fs/smb/client/cached_dir.c
>>> +++ b/fs/smb/client/cached_dir.c
>>> @@ -388,11 +388,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>>>                          * lease. Release one here, and the second below.
>>>                          */
>>>                         cfid->has_lease = false;
>>> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
>>> +                       close_cached_dir(cfid);
>>>                 }
>>>                 spin_unlock(&cfids->cfid_list_lock);
>>>
>>> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
>>> +               close_cached_dir(cfid);
>>>         } else {
>>>                 *ret_cfid = cfid;
>>>                 atomic_inc(&tcon->num_remote_opens);
>>> @@ -438,12 +438,14 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
>>>
>>>  static void
>>>  smb2_close_cached_fid(struct kref *ref)
>>> +__releases(&cfid->cfids->cfid_list_lock)
>>>  {
>>>         struct cached_fid *cfid = container_of(ref, struct cached_fid,
>>>                                                refcount);
>>>         int rc;
>>>
>>> -       spin_lock(&cfid->cfids->cfid_list_lock);
>>> +       lockdep_assert_held(&cfid->cfids->cfid_list_lock);
>>> +
>>>         if (cfid->on_list) {
>>>                 list_del(&cfid->entry);
>>>                 cfid->on_list = false;
>>> @@ -478,7 +480,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
>>>         spin_lock(&cfid->cfids->cfid_list_lock);
>>>         if (cfid->has_lease) {
>>>                 cfid->has_lease = false;
>>> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
>>> +               close_cached_dir(cfid);
>>>         }
>>>         spin_unlock(&cfid->cfids->cfid_list_lock);
>>>         close_cached_dir(cfid);
>>> @@ -487,7 +489,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
>>>
>>>  void close_cached_dir(struct cached_fid *cfid)
>>>  {
>>> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
>>> +       kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfids->cfid_list_lock);
>>>  }
>>>
>>>  /*
>>> @@ -596,7 +598,7 @@ cached_dir_offload_close(struct work_struct *work)
>>>
>>>         WARN_ON(cfid->on_list);
>>>
>>> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
>>> +       close_cached_dir(cfid);
>>>         cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
>>>  }
>>>
>>> @@ -762,7 +764,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
>>>                          * Drop the ref-count from above, either the lease-ref (if there
>>>                          * was one) or the extra one acquired.
>>>                          */
>>> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
>>> +                       close_cached_dir(cfid);
>>>         }
>>>         queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
>>>                            dir_cache_timeout * HZ);
>>> --
>>> 2.50.1
>>>
>>>
>>
>>
> 

-- 
Henrique
SUSE Labs
