Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E9435CB76
	for <linux-cifs@vger.kernel.org>; Sun,  2 Aug 2026 11:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785671821; cv=none; b=jkuD4C5uOlwvoT0Yo1HEFozVU8pQEoofjADCu74xjy4WAHd0FZ8qB3MczX/6Z23IO9mAtLqBbSwY4P/hCejLKCgsRjhkfwc4BGE+n9Hjqs+5f2BSduQjvZSSHimsOdjfKhkGo2yz2cCXSqpSFaMby5PQKJ11Zp92dgBEAWbIuPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785671821; c=relaxed/simple;
	bh=DPrR3gMiV2U/5iA7a8FGTFAozA5SAhBq6pSbzgQqg0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=boCMGx2a8SdTACxxGL2UMGbV2kTJwkg2aKUJQm+CeowOTfE0aM9kqUiJCjIQcZUHXWrlJHlnHzQaYgXWH5TJtMMfs3pXMwKuvr7glTvTtLPOaXI3nMrVK1IHLwOVEd7NN1PDhwIxIg3fY0gUXtbDms5py7gVw+o0dcks/am9qH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G3bbEu87; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HrndNjXr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G3bbEu87";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HrndNjXr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785671818;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+UOShm/Wtsy/GiMsmztssQM6a2ft1SsQqKChxVHMrYw=;
	b=G3bbEu87LTkXyAvRPtNv2w/jNFb7DIOGUc2q1BOei95BHfSWoR/8jaUwpyP3XO4/s+HgjH
	VsXslpcE6BEY1T7bNBLlngDbhqPOOiEWCFEclnLv/dYBUw8UbO5SOmViGHKvwv3phMd89o
	YBy0J4xd/w0A9c5j1MHPdw22ZxlBzJs=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-hIh-mFCyNYGBjUpysXpwMQ-1; Sun, 02 Aug 2026 07:56:55 -0400
X-MC-Unique: hIh-mFCyNYGBjUpysXpwMQ-1
X-Mimecast-MFC-AGG-ID: hIh-mFCyNYGBjUpysXpwMQ_1785671814
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e74781faaaso5318772a34.2
        for <linux-cifs@vger.kernel.org>; Sun, 02 Aug 2026 04:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785671814; x=1786276614; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+UOShm/Wtsy/GiMsmztssQM6a2ft1SsQqKChxVHMrYw=;
        b=HrndNjXrHfsInGe7KijkeNV5Ss2lbPU45+NRckpakwTbGbJLnMxMycrdJc65FBt5UX
         6WsmaHDkfV7bVL+XFha0+Xu4cK9N7HW65IveLeMXF9HBinkGsXmrNQpK5ogyK2Ir6D3/
         BLspO39JwMfbNg9m09kW2ptGsI4q3iCYZOchNpUJW5M/QMBhBo1BSLRRK8KOQIqQyZDY
         DDdwAMwabgxm9hAA95vovqGIYFrG8HtQMaKF6DKdPoq5XlntYAYQYFn22by3O2LDlfqU
         QPLkwfbMkcT5k/QyO74FRC0sOrWh5Vdxr/Wr3+xEou87WcH6X59N7JGqr+PjeBzlJdPW
         /cUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785671814; x=1786276614;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+UOShm/Wtsy/GiMsmztssQM6a2ft1SsQqKChxVHMrYw=;
        b=HXJmDMB8ywEnXP9685+hFM9nEiHZe/MfS8dS0RYBMZDmg2ZhUbzLhv8MULQoiOXS5+
         zlkkRnZwBqYsd+sKgC8jcB4sCw5y97f285TvgbwwCkuXkF44lTv4hlpZRiOhe1ZR/WHD
         ln9T9S7QbjmOkHfWOSMHVvoNtrMocdknCMf4K6GLdrhVHy52W6icb4mWQvhIyIM5VAdy
         6m249g1tND4vHezTPIZoiBBh514L1S7P5h6DCWat7bslZyeyCzSqF/2eWsjRLfbiZLM3
         eV66vS0J3MEIGGf+at7TbbD9y9Qrpqjw8/i2/qPm/0taF/lwUN+YILSULRa0UveGiXOE
         4wFA==
X-Gm-Message-State: AOJu0YwExAovNOKOtZ596UVjzKitpITC/ZbXaiU49+GQzjQgqU1F0L5K
	7I95+Rg8lIrRRK6PGaEW6Zv148HXtMJ9IaRYRSn8D1g+Q0hZI21gHJqoWjkVnbVYHIrE+sxMW3n
	/33UrKQFgtltlYPmXAXL7b7tGwFyqKAaTAb7RXV5Ku8z6supwOsfUafOlns5qi3s=
X-Gm-Gg: AR+sD12LbQjJLLYiLdJoxyspe5OuGSWFNAD0NJeYHC40KbIxK/Fx6hHAFU1Hc4VFQAm
	PUYLWXq1HgrdyLFWvEyj+AHn9DifaMZ9XHrgHoxX3q/udYLXzAWfx6Dn9fNDu5V0j8dAHo3uJZE
	d/t8qo791/Z9s/JI9wrEc7w6uT0Y/Evw/P9z19ErCOEXbbrOrKI8mds+GDNh+XwJHg3qHRDFC+6
	BE2bScG62OAqUKjnNirIbMvTcM9ZuhwQSTj5IFPTNpmq71ms/lsDXxsWXnUqH2w7jM1eropTDtk
	wLokx+rLYUe0AZglEr4NyF+yHOzHs8c8ZGzZQX6EMu7EqNumQQDd5Bv62tOuxmPKBqHHG1uVVfE
	DG770p13oXiodHn4qS9dRXO6cqyF5xMGL0asCTqz6
X-Received: by 2002:a05:6830:3699:b0:7e9:cad9:4bc4 with SMTP id 46e09a7af769-7f196c588dfmr10738200a34.7.1785671814491;
        Sun, 02 Aug 2026 04:56:54 -0700 (PDT)
X-Received: by 2002:a05:6830:3699:b0:7e9:cad9:4bc4 with SMTP id 46e09a7af769-7f196c588dfmr10738184a34.7.1785671814098;
        Sun, 02 Aug 2026 04:56:54 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f18ed3c81fsm5031530a34.5.2026.08.02.04.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2026 04:56:53 -0700 (PDT)
Message-ID: <a7724609-20ab-49b0-aef8-4d7673f0d308@redhat.com>
Date: Sun, 2 Aug 2026 06:56:51 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH v2 1/4] cifs: use cifs_invalidate_cache() in
 cifs_do_truncate() for O_TRUNC
To: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stfrench@microsoft.com,
 hehuiwen@kylinos.cn, stable@vger.kernel.org,
 Paulo Alcantara <pc@manguebit.com>
References: <20260731153500.660569-2-sorenson@redhat.com>
 <20260731153500.660569-1-sorenson@redhat.com>
 <2259642.1785537449@warthog.procyon.org.uk>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <2259642.1785537449@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 7/31/26 5:37 PM, David Howells wrote:
> Frank Sorenson <sorenson@redhat.com> wrote:
>
>> cifs_do_truncate() is invoked from cifs_open() without i_rwsem, so it
>> cannot use cifs_resize_file_locked() to perform a proper fscache cookie
>> resize.  Instead, add cifs_invalidate_cache() after cifs_setsize().
>>
>> cifs_invalidate_cache() calls fscache_invalidate(), which works without
>> holding i_rwsem: it unconditionally increments inval_counter and sets
>> FSCACHE_COOKIE_NO_DATA_TO_READ, ensuring that stale cached data is not
>> served once the cookie is later activated by fscache_use_cookie().
>> Truncation to zero leaves no valid cached data, making invalidation the
>> correct semantic here.
> What happens if there's a concurrent read or write in another thread?
> truncate(), buffered read/write and direct read/write() will play reasonably
> with each other through a combination of i_rwsem and the stuff in
> fs/netfs/locking.c.
>
> But apart from that, I think that invalidating the cache should work.  It may
> be slower, but since you're getting rid of all the data anyway...
>
> David

The lockless call is pre-existing; this patch just adds the 
fscache_invalidate on top of it and doesn't worsen it, since it's safe 
to call without i_rwsem.  Fixing the concurrent I/O issue properly is 
out of scope for this series.


Frank

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

