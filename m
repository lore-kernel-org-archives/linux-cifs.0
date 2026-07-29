Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E9E49250A
	for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 13:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785333176; cv=none; b=hHfWhQDqGpWJhtFwX9lHmNZUfg6CFliDRpJv255KrxBY9S/plOsaoyvK4xRdQf1ngVtCVj2TL/84Ge2dRhbUICtA7qs9FPbL3NQXE9zZwAaJN7rB5zxsVMc4QfRf8uLqWOIaiQ7mGDhUmr0hHZqe6dt3MHgfmlBhYg1MQWjImb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785333176; c=relaxed/simple;
	bh=U9jP5g2UlQMpLn1Q6VDzXuieWkoFot4JFR3mrV1ZUZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H7g88V+FP/FQVGFKkWtfZMEuRNJ+GDxFN0PwcZtZjvGLhYrPjztkZXpghnkOH9/5jfufd5JIPWupcO6BbQrMY6cTzvBnNEkjmvMFoEsULpk49voL5PyuiRE7fjS4gOqyCFnRs/mFfYj6gT4Dx+FwWEn7Y57AfmkTY2z+rlFuhuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KzBNRK6G; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HyuBJNRU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KzBNRK6G";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HyuBJNRU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785333170;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dm746TS8EnyhI8+mzBi8QtOCUfuL1ZTqgnyHRBXxPjM=;
	b=KzBNRK6GOMFVTZ9nhUlvWz4VtwLlLXq6PMo0Qmz229RAhaf+tbhyIxGEUhmvxnZL5XPeBp
	oUALkgfV+9BJ3uHJKfas8h+gDloHIBZrIgUX4vHpy5cjD7bkR3QDDGpbHt62kxFt0nzkwo
	13YZVOdmlMFHrwgHshU2Od6ibjON/HM=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-8crRTMt2N4SUnZXNjsAyCg-1; Wed, 29 Jul 2026 09:52:48 -0400
X-MC-Unique: 8crRTMt2N4SUnZXNjsAyCg-1
X-Mimecast-MFC-AGG-ID: 8crRTMt2N4SUnZXNjsAyCg_1785333168
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7ee1e335245so653490a34.1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 06:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785333168; x=1785937968; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dm746TS8EnyhI8+mzBi8QtOCUfuL1ZTqgnyHRBXxPjM=;
        b=HyuBJNRUPVDZtzo6Ba/87MLpIglkg8d78vbvwFUCv0QeulondIAOb1MXFbiIFcbX65
         6AvMAvCZLbWWhusYqMBbaxqgyngrpXZB/9odBpuEp+wK89rIMcw4VPIqGR+d1HJfLbl0
         V+MU85eLdmbIWa6jgv+r30hQldMLsj6+TKv4FDcTDibc/SjBIWqRdsScM5c2ZLNRFuWC
         yEa0qXc9/GoVq4tl6S4qirrojznQAeRn2ew87I1Ow8MDH9lTXyMzMa3EmYr2C/HB9Woc
         meMceORTFaFBrdOZOxCJT6R42jhgzmezV5vOzJKlaOrbjQWiwKikQGkNlGTWzGRDS1My
         G1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785333168; x=1785937968;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dm746TS8EnyhI8+mzBi8QtOCUfuL1ZTqgnyHRBXxPjM=;
        b=psC5RAq1P7jiwDOXQ0wXQ7+DG52G8QjSLgFcCq5BfZGVJF5w+u6m6ASqDwxQS/J3A8
         baB2+IpbWGpyHoCM4lhoFrY7ROIcqG17hA7vNM68usTZoZTYFbM9KEvH6CdRs6VEs8Uy
         MxEiUxWZLDQHD25xAZoGocp3HoPLplHJdi7cZ2WbClfRXpZVU3Nppoxz82FxJDw6xoTp
         1Mujdt+QO+TSxqUCGka7iZQ22Kb/0bnkBQdP+f2iC1JC5qD4c5uq6UTS8D30oEodPdQY
         0wk/lhCbO/r+mZhrpC/Alu/dsl0Ev6NrlWj3CjhxlvJWx629NvtTqVOcDFE3hXzQSUDu
         Jezw==
X-Forwarded-Encrypted: i=1; AHgh+Rp8CTrzNMZBPMC4ihGLiu4k2IGjmAbD02eMjuXfiF0cmJoXiAkkcK/fBgYPzFpPpvelfbMM1DWhc6m4@vger.kernel.org
X-Gm-Message-State: AOJu0YwIhLItNtTZBQMtX/bQhrG/ZvdFs5FQkKDg0Ip7hIcChGauK9v0
	Jw1jVLxBqxsEH5W7F6tbQlHyILQnGtAfkKzxOIWEUWNT8XZf3bEYvnjj0sWAN9n6Z50w9J5oMJt
	AuJUwYeUhwF8EfsImNT9x5mjXvQ7AIrTzxpLR76XJxhD7QWQPWSEvt1AkDhzRPFg=
X-Gm-Gg: AR+sD10MlIQcWWwlMlBYzV8OlZQZlorjlE1HGwRnWzDblQVuoKz5JkpV1ve2tcZAkB5
	LOf1+GbF9+Gjsf4noGVxKHjP2v6Y9ejtmJ+yY7n8e440aF/1ZdGBozQ9L7RL9uFyvqf3Egt90Z6
	Pi9C3xHd10axUxS/0crLw9q+rgAmc0QGrglE+8G9u2u/DoIMOKwOjAj1sd5852keuT84fFMIUGL
	xg0gkHDctn5FGFSi88xN3ZyGMCrpT5oBKzPbmqIFtbhNm5ZtOR3g1jHF4nWhff8jjzHuvrbuP7a
	b2xvGewzDZKFYRKO5UtzfbV6jku80C0AwGiWA//2Phik5rTeCsIquic+g+Na3/WviC8qbsHS334
	o1vVRFzm9LdSN4LOMBGjE4gAgUs8mAfiYlAdwhSgd
X-Received: by 2002:a05:6830:6ab1:b0:7e9:d250:a731 with SMTP id 46e09a7af769-7efff247ec7mr3509867a34.20.1785333167880;
        Wed, 29 Jul 2026 06:52:47 -0700 (PDT)
X-Received: by 2002:a05:6830:6ab1:b0:7e9:d250:a731 with SMTP id 46e09a7af769-7efff247ec7mr3509859a34.20.1785333167468;
        Wed, 29 Jul 2026 06:52:47 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f00d94d404sm2325351a34.23.2026.07.29.06.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 06:52:47 -0700 (PDT)
Message-ID: <1c417111-ebaa-4da8-af32-11ce073dee43@redhat.com>
Date: Wed, 29 Jul 2026 08:52:45 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH 1/3] cifs: use cifs_invalidate_cache() in
 cifs_do_truncate() for O_TRUNC
To: Huiwen He <hehuiwen@kylinos.cn>, linux-cifs@vger.kernel.org,
 pc@manguebit.org, stfrench@microsoft.com
Cc: stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
 Paulo Alcantara <pc@manguebit.com>
References: <20260728211438.3859107-1-sorenson@redhat.com>
 <20260728211438.3859107-2-sorenson@redhat.com>
 <b21c1885-a46c-44d5-9b20-2b0072a3b50d@kylinos.cn>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <b21c1885-a46c-44d5-9b20-2b0072a3b50d@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Huiwen,

Okay, that makes sense.  Thanks for explaining further.  Let me work on 
that.

Frank


On 7/28/26 11:20 PM, Huiwen He wrote:
> Hi Frank,
>
> Patch 1 handles the quiescent-cookie case, but the cookie is not
> guaranteed to be quiescent here: another open may already keep it
> active. In that case, cifs_setsize() may still call
> fscache_resize_cookie() without i_rwsem before the invalidation.
>
> Maybe we could keep cifs_setsize() as the basic size/page-cache helper
> and add a wrapper for the paths holding i_rwsem, for example:
>
>   /* Caller must hold inode->i_rwsem for write. */
>   void cifs_resize_file_locked(struct inode *inode, loff_t offset)
>   {
>       struct fscache_cookie *cookie = cifs_inode_cookie(inode);
>
>       lockdep_assert_held_write(&inode->i_rwsem);
>
>       netfs_resize_file(netfs_inode(inode), offset, true);
>       cifs_setsize(inode, offset);
>
>       if (!cookie)
>           return;
>
>       fscache_use_cookie(cookie, true);
>       fscache_resize_cookie(cookie, offset);
>       cifs_fscache_unuse_inode_cookie(inode, true);
>   }
>
> cifs_file_set_size(), smb2_duplicate_extents(), and both
> smb3_simple_falloc() branches could use this wrapper, since those 
> paths already hold i_rwsem. O_TRUNC could continue to use cifs_setsize()
> followed by cifs_invalidate_cache(), without attempting a resize.
>
> Patches 2 and 3 look good to me.
>
> Thanks,
>
> Huiwen
>
>
> 在 2026/7/29 05:14, Frank Sorenson 写道:
>> cifs_setsize() now calls fscache_resize_cookie() since commit
>> fa724e235cfd ("cifs: add fscache_resize_cookie() to cifs_setsize()").
>> However, cifs_do_truncate() is called from cifs_open() before
>> fscache_use_cookie() activates the cookie, so the fscache cookie is
>> still quiescent at this point.  fscache_begin_operation() requires
>> FSCACHE_COOKIE_IS_CACHING to be set and returns failure for a quiescent
>> cookie, making fscache_resize_cookie() a null operation in this path.
>>
>> The correct fix for this path is cifs_invalidate_cache(), which calls
>> fscache_invalidate().  Unlike fscache_resize_cookie(), 
>> fscache_invalidate()
>> works on quiescent cookies: it unconditionally increments inval_counter
>> and sets FSCACHE_COOKIE_NO_DATA_TO_READ, ensuring that stale cached data
>> is not served once the cookie is later activated by 
>> fscache_use_cookie().
>>
>> Truncation to zero leaves no valid cached data, making invalidation the
>> correct semantic.  No inode lock is required for 
>> cifs_invalidate_cache().
>>
>> Fixes: fa724e235cfd ("cifs: add fscache_resize_cookie() to 
>> cifs_setsize()")
>> Cc: stable@vger.kernel.org
>> Cc: Huiwen He <hehuiwen@kylinos.cn>
>> Cc: David Howells <dhowells@redhat.com>
>> Cc: Paulo Alcantara <pc@manguebit.com>
>> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
>> ---
>>   fs/smb/client/file.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
>> index ac89c1ba56b1..389083f9ce00 100644
>> --- a/fs/smb/client/file.c
>> +++ b/fs/smb/client/file.c
>> @@ -1016,6 +1016,7 @@ static int cifs_do_truncate(const unsigned int 
>> xid, struct dentry *dentry)
>>           if (!rc) {
>>               netfs_resize_file(&cinode->netfs, 0, true);
>>               cifs_setsize(inode, 0);
>> +            cifs_invalidate_cache(inode, 0);
>>           }
>>       }
>>       if (cfile)
>
-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

