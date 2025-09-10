Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC912F39CD
	for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 21:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757538720; cv=none; b=QUgD65l17ynTNdGYJ3odQQsKsTU8Z8FahzLgUgrp8+eIDouBHzigA3jfTq+uPCs5PQXH43CnnBoTjW5LLk9WiP9834cjMnoW8h+Rlnr/lC4tpKSOuCbXuyNu1zy5x0SDgYW7EmXTGDFnNRQCFj+9N+mbR4q9W/26nz3RAZL7Rv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757538720; c=relaxed/simple;
	bh=bS+E8cGbXEib0dmEK6WzkqwbOjhkGuOek5jenywHwgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kzL5NwRNXxc0Uj6UCEyAV83ON2oc8f4+wdJs5w3jg0Sk/uAOQaLgF/zG0FnvDiaI7khfydwjHkH4MglTDNRD+Kt+39uI+Wg+S9jFHMZpRqGS/S49LPvg1b9/5exQUrtnch4NOb80NoxOP9Ze82G5vbH1HZcslFZTX03NqKFdJd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZCTD4u0L; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZCTD4u0L"
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-3e249a4d605so69181f8f.3
        for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 14:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757538716; x=1758143516; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dFjIdo311qfr/nM9ouC4UV2APZrUJBcpU235QviOfxY=;
        b=ZCTD4u0LYEY+KuvqcIhRgZ9CVr+6FetYZPbsPMdWD+pj0BmDGPQUCJylEeEJp5xUcN
         wrxgxMeZTYq7XZt7zNkKXmYcVOrlXJlY5cHL5v7TbqD/fNWAXIluThEGh5JQXxsvH1HG
         w/2KuAmKAXxUj6fQyGBwMUpKP46BfSWPPS0inZ4FaNv3uHFpRFZmRUqgcUbeYKCBYqOx
         CRiP+keIgK4u1WCp+n3vkwqfkarUOXsp7nAqAcYhElBB0pLBIBhfaoSKH5P3pir8KXeD
         mQDe1R6Okxzj9pSzEpJQCAMgO9mY0Swde6a/d5OkNT+KpTgQ3TANGAme0iASvH1YhNZP
         W14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757538716; x=1758143516;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dFjIdo311qfr/nM9ouC4UV2APZrUJBcpU235QviOfxY=;
        b=RUrAjUAHPoAexkG+kQ3F4x3/1m4HvolgdrS49k5yDa/dOFRw6wGVRAOXDIf3jimpLv
         MA4nH0+aJ6HcxdrTzBL7PHRO6HPWbiTEbhRHEmf6Zk2eWT2Hr/9XSJ2mL4zBzYMGMQp/
         1Vk0uNFnPSnSsYrKc+9nQLEFhsxPKhMi5MdjPTQrx5K9Z2H4NcKjyqnkRPvCe5r1SJ6w
         TKCodFU+KO1nXQqv8T3ltM45J8hkqQtY9fs56WpW/9kz/sKkpbpZmr3RvTSx0mk3Xt/w
         7XInw2KjBhC7SZDvrV2ir/g0H5SyrKxba73aJESgkyd0HLHiYrUPdQ8FVhn180ya5oVl
         vYgw==
X-Forwarded-Encrypted: i=1; AJvYcCUtVgDhJ7Oijs4cg0AUSGHwuth4i1wyu/+1qCiYfleYZPpCAL+4+iTvVVyhQvFMNZmx4fjKTBhpKhiX@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm1OUlYlFgdWm/3nbqb0hJqgIo9PUIxRbwcavZLhGxaA6IsfD0
	+Ln3LfxR6yU4yxSu+FJdJwbMGHN6JmAVr3xWx2JMJTyoz2fzCT6sGW2HCmqAX777krI=
X-Gm-Gg: ASbGncuE4A25neeh5g9dMNWGXPr7fd3wOnCdvQ0Nk3zOoEY7uK6ghWQxqNUgaWo2qgQ
	7OoLH3OMS+IvTGQa5gDVUnNfoqf/I5jl4XyLWf6niTBSZSUpuvcRz+NOxDexRGFlK4V3fJ74Y1o
	bvaHHpcZoegVMjUeN3lfXfCEWcd2PlRZjiSb9vVR3Yj9ndfxDC4IDqyIdtv+v8h0zjUO9FeNgPL
	7qSUMg3XyWkDKphrYVTVEb2Z83N7nMod9ry1iXCr98oSFiO5DacYx94zrwNabYv8tkGC1PSLAo4
	x80fYaJ/Gr1MdzKd24sQZzo7czUq6TATUBACAddV5xLk1XTEuRkrB+BY86fwKSBI9+zN0wVx7hL
	FNm6w53JDunzzntAJ9SPdNKm9NKCNN6DZln2kI08bGtfjSqd0W5jLV5O7tR+jDf1qAwnvRjRZgA
	1Q5GfrSE+mkCw+uw==
X-Google-Smtp-Source: AGHT+IEcKmb8uDWA0PKY3fKg8Bi9Oq67kuj07j35mxH9x5UGpQKpOm3TuPdv7nT3KwpjfX8kDe8R6A==
X-Received: by 2002:a05:6000:2203:b0:3d2:208c:45aa with SMTP id ffacd0b85a97d-3e64b82d62bmr13247572f8f.29.1757538715579;
        Wed, 10 Sep 2025 14:11:55 -0700 (PDT)
Received: from ?IPV6:2804:7f0:bc02:9180:8dff:c7fe:5faf:7356? ([2804:7f0:bc02:9180:8dff:c7fe:5faf:7356])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25bf675b77fsm881355ad.43.2025.09.10.14.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 14:11:55 -0700 (PDT)
Message-ID: <bdfb29eb-35ab-473c-be08-1e0857c3c96b@suse.com>
Date: Wed, 10 Sep 2025 18:09:51 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: skip cifs_lookup on mkdir
To: Steve French <smfrench@gmail.com>
Cc: ematsumiya@suse.de, linux-cifs@vger.kernel.org
References: <20250909202749.2443617-1-henrique.carvalho@suse.com>
 <CAH2r5ms_Nr0qt=Ntg4dBNXxrPhCNdKPg5qWW1BhBkt281fw2yQ@mail.gmail.com>
 <CAH2r5muyRvOn_OgKimn05V8o-XDt8SVdDzVU7peRmT_KGNzdkQ@mail.gmail.com>
Content-Language: en-US
From: Henrique Carvalho <henrique.carvalho@suse.com>
In-Reply-To: <CAH2r5muyRvOn_OgKimn05V8o-XDt8SVdDzVU7peRmT_KGNzdkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Steve,

On 9/10/25 5:28 PM, Steve French wrote:
> Henrique, I can repro the failure in generic/005 with your patches,
> but am fascinated that one of your patches may have worked around the
> generic/637 problem at least in some cases, but am having difficulty
> bisecting this.

I had not seen the failures in generic/005, but I also had not tested
with smb 2.1.

I will run more tests and dig into both generic/637 and the other
failing cases.

I will get back to you once I have something more concrete.

> 
> On Wed, Sep 10, 2025 at 12:50 PM Steve French <smfrench@gmail.com> wrote:
>>
>> Interesting that running with three of your patches, I no longer see
>> the failure in generic/637 (dir lease related file contents bug) but I
>> do see two unexpected failures in generic/005 and generic/586:
>>
>> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/116
>>
>> e.g.
>>
>> generic/005 5s ... - output mismatch (see
>> /data/xfstests-dev/results//smb21/generic/005.out.bad)
>>     --- tests/generic/005.out 2024-05-15 02:56:10.033955659 -0500
>>     +++ /data/xfstests-dev/results//smb21/generic/005.out.bad
>> 2025-09-10 08:33:45.271123450 -0500
>>     @@ -1,8 +1,51 @@
>>      QA output created by 005
>>     +ln: failed to create symbolic link 'symlink_00': No such file or directory
>>     +ln: failed to create symbolic link 'symlink_01': No such file or directory
>>     +ln: failed to create symbolic link 'symlink_02': No such file or directory
>>     +ln: failed to create symbolic link 'symlink_03': No such file or directory
>>     +ln: failed to create symbolic link 'symlink_04': No such file or directory
>>     +ln: failed to create symbolic link 'symlink_05': No such file or directory
>>
>> Do you also see these test failures?
>>
>> On Tue, Sep 9, 2025 at 3:30 PM Henrique Carvalho
>> <henrique.carvalho@suse.com> wrote:
>>>
>>> For mkdir the final component is looked up with LOOKUP_CREATE |
>>> LOOKUP_EXCL.
>>>
>>> We don't need an existence check in mkdir; return NULL and let mkdir
>>> create or fail with -EEXIST (on STATUS_OBJECT_NAME_COLLISION).
>>>
>>> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>>> ---
>>>  fs/smb/client/dir.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
>>> index 5223edf6d11a..d26a14ba6d9b 100644
>>> --- a/fs/smb/client/dir.c
>>> +++ b/fs/smb/client/dir.c
>>> @@ -684,6 +684,10 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>>>         void *page;
>>>         int retry_count = 0;
>>>
>>> +       /* if in mkdir, let create path handle it */
>>> +       if (flags == (LOOKUP_CREATE | LOOKUP_EXCL))
>>> +               return NULL;
>>> +
>>>         xid = get_xid();
>>>
>>>         cifs_dbg(FYI, "parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
>>> --
>>> 2.50.1
>>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
> 
> 
> 

-- 
Henrique
SUSE Labs
