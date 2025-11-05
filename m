Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBE6219A79
	for <linux-cifs@vger.kernel.org>; Wed,  5 Nov 2025 21:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762377509; cv=none; b=aIotojhJ55+dXVsI3zKNu3vfPMFGODzP1dQFuZY7T/JjdFqrSlhFoBNlWKl3iZMhPzVzoNveRwvxtvT0wplLW9espVjgfDPFdDu2ztrQxoPspy+7iWSpYq/vP0I9UAg0OAhnaNPM4j+/zk1X9LYzmMedMkdb8YkgAbZdMoR2sz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762377509; c=relaxed/simple;
	bh=UddrVL3QzuHMvnX6l4E2NBDqO9Xy2GXW1FQCzw9YdYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/E/hz79p2WBfs09RhKVy55n0NxszLq9HcBXiXgU3PspiGR4VfR/uRCBEwW+RlZklVW0UW5QVLI+nfgRD/gAPpUJI5qsaqPBBun+s5e7bmDUAdko1iGtrO79DJmzPFkBCD50141XT+p9kfh4YgtlN2phnojHkxUVQUMOyT2NOt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aqhtiu0j; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aqhtiu0j"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3ecde0be34eso776708f8f.1
        for <linux-cifs@vger.kernel.org>; Wed, 05 Nov 2025 13:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762377505; x=1762982305; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hxP4QuqNzjfjEvUcLs0JHlG1THCLkaB6nCbEdnOATbE=;
        b=aqhtiu0jkzDzzhF2OrsZVq91CWMifTWSUIR36+IF8G+SYSQngyp8mVi/Nxzzg3PRzH
         sfTyPsdI2No8kKDqr/9LDMtkcmTCnrHNaFF+1/2CQ5nj1XgSHUEzMROI31XJoMWG369+
         u6YiD7aanpQSVzbnLj3adD3pb5NHZD15w1gsqEyPj2/KFGo8smNvulE1dPlmoC/zMIPT
         ByP9H/V5+24NstUA5NX1+94/aGdVB0mQNfBPAJQhkZ+gg/8eNG4jk4NOND9kEKne5khF
         Q+f3V5D5UzT/64IGmmqqRbIY2gASfIEbZ2naaysRGdKhZGIU3U9PNSweCOIaqj0+tuQV
         WG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762377505; x=1762982305;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hxP4QuqNzjfjEvUcLs0JHlG1THCLkaB6nCbEdnOATbE=;
        b=iNaw3XlIFPn2Qlca1jO5BfkyIfaGHQpTqZq41qVLAkHdDgKcxd+rPVCTjhb9uYDdUW
         Z6daCXF8vHw+WQdT3l6iOUHtRdXCP2EGW8MCgQ53+blmunjmY0o4ZiPYSohtvoLNHgf2
         5e7ih2jBefEGrmzy6qX4UpA09IFdh5jnQT3T9QYBPu8CKrbGjuIwep9odZWIvMg8FG/v
         CxN3HScMdQCldDKmyaLROs1mFGlStqIEk4eHIaEDS3J/axdQEC5pJJeU1dsoSfjXXS2u
         ufeB8Z4C+8JiOzfboU6BA40+8b+WAKIj6owsH3C+tWRYMZVtTPd/VnVWkNlBoD3p1Hag
         d3hA==
X-Forwarded-Encrypted: i=1; AJvYcCWOj6vloImX3MFuIUd1a50DRTe4blerrUvVBXkZOqKTh3ZyEkve2uRjCRNza3mAPkO8bDDRd6fDsm0f@vger.kernel.org
X-Gm-Message-State: AOJu0YwM/UqB4uH4A68x0xE5aKOAC0dqDtFTk6xq8OCV0tYpoZdJrCDY
	rir77Hm1dKAQ8S3Md3bqdOk0ffQFP9wpdYdtvVB7T/GB9wA1ExuTlNFexPNg70sDmG0=
X-Gm-Gg: ASbGncvND5iiJReSlyTGeUlYtW86MN4RBnODPZuGfyDzbcCC4jMto2DUFG+o+2F78Ld
	9CP+unOhX05wFqzMEjbPp0vLEgNvvGP91AMBBTln1ZkL/wCURrma0wgZS64IgEwUyc9uRQkbP4Z
	cieUEcBUHnCWwGcGlEBdFOCAOWkD5n/o9S4l3NAm/5vkmaONMeNWmHXDrh6cmkIRMa4fFdVxKGQ
	wCHdq0qq/RSTXlvZKmHjLpKZ3p62OGL6DetvqG1Ui2kImfXt5dq5f4lDRaeQvAUb47/pxZPO+7X
	bxKsqqdLaInWPhvffErjXVHtDAhjuvSGUUpT1WAPkbMqleNTqoHWygomkQIKpyW0cW3S8QAvQYz
	MDkTCrg2DpVFMsYJ3vRleYRXnmTvuUezIza0mt2BJJiPkLXZ3Os7LRQbZVLaaOkvba2F6fIxkVN
	H2zkNTE000u1i+
X-Google-Smtp-Source: AGHT+IGhM1OsjB8ILgBiibtEKGWC0wh5mzOrOKe1tDzOLFjPv/FIEFIT2Ny5f5a9t5rWrIixVIkjBA==
X-Received: by 2002:a05:6000:288a:b0:429:8fbc:9824 with SMTP id ffacd0b85a97d-429eb12fbf1mr775543f8f.3.1762377505014;
        Wed, 05 Nov 2025 13:18:25 -0800 (PST)
Received: from [192.168.15.14] ([152.234.106.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba8ffe36ad7sm256566a12.22.2025.11.05.13.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 13:18:24 -0800 (PST)
Message-ID: <5823dbac-9d20-4b00-b723-fe0c9a03341b@suse.com>
Date: Wed, 5 Nov 2025 18:16:11 -0300
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
Cc: Paulo Alcantara <pc@manguebit.org>,
 ronnie sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath S M <bharathsm@microsoft.com>, Enzo Matsumiya <ematsumiya@suse.de>,
 Jay Shin <jaeshin@redhat.com>, linux-cifs@vger.kernel.org
References: <20251103225255.908859-1-henrique.carvalho@suse.com>
 <CAH2r5mtSmg-FwgPzEyPF2CFfP1zuc-Qh5CVuBjbEkA8eTA2Mtg@mail.gmail.com>
 <d8aa9dc3-2a94-484b-addb-2ceb18318c54@suse.com>
 <9d2bfeac-d6d8-4299-87f0-791ff9940971@suse.com>
 <CAH2r5mvkefptGUvjarOmOW=hQA7_ZRFLwOk_jptOSAyzuMUGuw@mail.gmail.com>
Content-Language: en-US
From: Henrique Carvalho <henrique.carvalho@suse.com>
In-Reply-To: <CAH2r5mvkefptGUvjarOmOW=hQA7_ZRFLwOk_jptOSAyzuMUGuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Steve,

On 11/5/25 1:20 PM, Steve French wrote:
> I can run it through again if you semd mean updated patch
> 
> Thanks,
> 
> Steve

I don't think there's anything to update here.

Adding a separate __acquires at call sites would be misleading. Not only
the call site is correctly annotated -- refcount_dec_and_lock() is
annotated with __cond_acquires(lock). Sparse reports no warnings, so
there's no missing annotation to fix.

Likewise, documenting that callers must hold the lock before calling
kref_put_lock() would be incorrect -- they must not.

No one should call kref_put_lock() directly. Likewise, no one should
call smb2_close_cached_fid() directly. lockdep_assert_held() is there
simply to ensure the invariant at runtime and as a hint to other
developers.

If you think it would help, I can add a short comment in
smb2_close_cached_fid() noting that the lock is held via
kref_put_lock().

Let me know if you prefer that comment and I'll send a v5.

> 
> On Wed, Nov 5, 2025, 10:18 AM Henrique Carvalho <henrique.carvalho@suse.com>
> wrote:
> 
>>
>>
>> On 11/5/25 10:30 AM, Henrique Carvalho wrote:
>>> Hi Steve,
>>>
>>> On 11/4/25 7:42 PM, Steve French wrote:
>>>> One minor comment that AI had on this was on the change to
>>>> fs/smb/client/cached_dir.c (line 447). See below.
>>>>
>>>>     -spin_lock(&cfid->cfids->cfid_list_lock);
>>>>     +lockdep_assert_held(&cfid->cfids->cfid_list_lock);
>>>>
>>>>
>>>> The lockdep_assert_held validates that the lock is held on entry, but
>>>> the function signature __releases(&cfid->cfids->cfid_list_lock)
>>>> indicates the lock is released inside. Consider adding a corresponding
>>>> __acquires annotation to the call sites that call this function via
>>>> kref_put_lock, or document why callers must hold the lock before
>>>> calling kref_put_lock.
>>>
>>> But we don't actually acquire the lock every time in close_cached_dir.
>>> Only when (a) refcount is 1; and (b) refcount did not increase after we
>>> acquired the lock. So where should __acquires annotation go?
>>>
>>> One option would be adding documentation to smb2_close_cached_fid,
>>> though since it's a release function that shouldn't be called elsewhere,
>>> I'm not sure that adds much value. Do you have thoughts?
>>>
>>
>> I think it's worth adding that kref_put_lock uses refcount_dec_and_lock,
>> which is defined as
>>
>> extern __must_check bool refcount_dec_and_lock(refcount_t *r, spinlock_t
>> *lock) __cond_acquires(lock);
>>
>> __cond_acquires() was introduced in commit 4a557a5d1a614 ("sparse:
>> introduce conditional lock acquire function attribute").
>>
>> So in a sense, if I understand it correctly, the "acquires" is already
>> there to make the sparse __releases annotation work. This should be
>> enough to satisfy the comment the AI raised.
>>
>>>>
>>>> On Mon, Nov 3, 2025 at 5:00 PM Henrique Carvalho
>>>> <henrique.carvalho@suse.com> wrote:
>>>>>
>>>>> find_or_create_cached_dir() could grab a new reference after kref_put()
>>>>> had seen the refcount drop to zero but before cfid_list_lock is
>> acquired
>>>>> in smb2_close_cached_fid(), leading to use-after-free.
>>>>>
>>>>> Switch to kref_put_lock() so cfid_release() is called with
>>>>> cfid_list_lock held, closing that gap.
>>>>>
>>>>> Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a
>> lease is held")
>>>>> Cc: stable@vger.kernel.org
>>>>> Reported-by: Jay Shin <jaeshin@redhat.com>
>>>>> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>>>>> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>>>>> ---
>>>>> V3 -> V4: rebase, added Reviewed-by and Reported-by, add
>>>>> lockdep_assert_held in smb2_close_cached_fid, change commit subject
>> (was
>>>>> "smb: client: fix race in smb2_close_cached_fid()") to clearly state
>> the
>>>>> bug class (UAF)
>>>>> V2 -> V3: rebase, remove unneeded comments, modify commit subject
>>>>> V1 -> V2: kept the original function names and added __releases
>> annotation
>>>>> to silence sparse warning
>>>>> ---
>>>>>  fs/smb/client/cached_dir.c | 16 +++++++++-------
>>>>>  1 file changed, 9 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>>>>> index b8ac7b7faf61..018055fd2cdb 100644
>>>>> --- a/fs/smb/client/cached_dir.c
>>>>> +++ b/fs/smb/client/cached_dir.c
>>>>> @@ -388,11 +388,11 @@ int open_cached_dir(unsigned int xid, struct
>> cifs_tcon *tcon,
>>>>>                          * lease. Release one here, and the second
>> below.
>>>>>                          */
>>>>>                         cfid->has_lease = false;
>>>>> -                       kref_put(&cfid->refcount,
>> smb2_close_cached_fid);
>>>>> +                       close_cached_dir(cfid);
>>>>>                 }
>>>>>                 spin_unlock(&cfids->cfid_list_lock);
>>>>>
>>>>> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
>>>>> +               close_cached_dir(cfid);
>>>>>         } else {
>>>>>                 *ret_cfid = cfid;
>>>>>                 atomic_inc(&tcon->num_remote_opens);
>>>>> @@ -438,12 +438,14 @@ int open_cached_dir_by_dentry(struct cifs_tcon
>> *tcon,
>>>>>
>>>>>  static void
>>>>>  smb2_close_cached_fid(struct kref *ref)
>>>>> +__releases(&cfid->cfids->cfid_list_lock)
>>>>>  {
>>>>>         struct cached_fid *cfid = container_of(ref, struct cached_fid,
>>>>>                                                refcount);
>>>>>         int rc;
>>>>>
>>>>> -       spin_lock(&cfid->cfids->cfid_list_lock);
>>>>> +       lockdep_assert_held(&cfid->cfids->cfid_list_lock);
>>>>> +
>>>>>         if (cfid->on_list) {
>>>>>                 list_del(&cfid->entry);
>>>>>                 cfid->on_list = false;
>>>>> @@ -478,7 +480,7 @@ void drop_cached_dir_by_name(const unsigned int
>> xid, struct cifs_tcon *tcon,
>>>>>         spin_lock(&cfid->cfids->cfid_list_lock);
>>>>>         if (cfid->has_lease) {
>>>>>                 cfid->has_lease = false;
>>>>> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
>>>>> +               close_cached_dir(cfid);
>>>>>         }
>>>>>         spin_unlock(&cfid->cfids->cfid_list_lock);
>>>>>         close_cached_dir(cfid);
>>>>> @@ -487,7 +489,7 @@ void drop_cached_dir_by_name(const unsigned int
>> xid, struct cifs_tcon *tcon,
>>>>>
>>>>>  void close_cached_dir(struct cached_fid *cfid)
>>>>>  {
>>>>> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
>>>>> +       kref_put_lock(&cfid->refcount, smb2_close_cached_fid,
>> &cfid->cfids->cfid_list_lock);
>>>>>  }
>>>>>
>>>>>  /*
>>>>> @@ -596,7 +598,7 @@ cached_dir_offload_close(struct work_struct *work)
>>>>>
>>>>>         WARN_ON(cfid->on_list);
>>>>>
>>>>> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
>>>>> +       close_cached_dir(cfid);
>>>>>         cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
>>>>>  }
>>>>>
>>>>> @@ -762,7 +764,7 @@ static void cfids_laundromat_worker(struct
>> work_struct *work)
>>>>>                          * Drop the ref-count from above, either the
>> lease-ref (if there
>>>>>                          * was one) or the extra one acquired.
>>>>>                          */
>>>>> -                       kref_put(&cfid->refcount,
>> smb2_close_cached_fid);
>>>>> +                       close_cached_dir(cfid);
>>>>>         }
>>>>>         queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
>>>>>                            dir_cache_timeout * HZ);
>>>>> --
>>>>> 2.50.1
>>>>>
>>>>>
>>>>
>>>>
>>>
>>
>> --
>> Henrique
>> SUSE Labs
>>
> 

-- 
Henrique
SUSE Labs
