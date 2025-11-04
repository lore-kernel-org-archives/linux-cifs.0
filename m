Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2DA1465B4
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 18:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762281388; cv=none; b=W7ZtXbhEdwYMIj56T6dbkkyD7/XU5nO4I+XYtxVVxnR+GMp1kvq6tzSj5AbCLMuVZAM0YRHFnH3uSpmb6zb7s5mz1GQuH77mhkDsr4qsju3dCtcvOEwLuzXQiXorXUqZLDkyjtPUm49WAeNfKFeiTMvrKMS8joMaaMbUp0MnSxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762281388; c=relaxed/simple;
	bh=AuWLO47Op0A6cXiQCT3lnMl7si4MV471QvuioS+vdqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TicCrdlaw3pn+GA9K2XExziQg9bpfiIPpd6M6Rmsonx6a0nDT+89rN+DE1rRrR0LphMP2PKALy2AykYNHNSmKejFfZzPAUxodTHnffWaFatDM1jcZSFUH1fYjF7HuAu1dOhIGwRV7vzn+Yp1NajIuomRrd/SEgDEBAjkIg5jz/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HBIDbtxO; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HBIDbtxO"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4775638d819so5348835e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 10:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762281385; x=1762886185; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S+qOQwxfN64qmYsF01vjK7YlVT/sIFKRQ4EeU3BDs4o=;
        b=HBIDbtxOjeulc/p1M3/WFPuBqjchvgQInrCIfAsgoj5z1ohWS82RZakjTs+ALxzi3o
         JLmFrGy8gKL11o83DdyhVRu4eGhlkH0VKUSWNTREa06MHDpDfjLn0W9Tda6ggZMghoVm
         19HOhz14KjtvN89IvD+Uj5nMZEzRECPBQ3dQ6RTOc0SkWuoxWWIMYdejQRNyorsNfUqL
         yN1qVSdWevyLqgZQ+o47o+oe+ljQ6Kal2UJBaVJrbwxyc8+RXKtcIzLociyaVjLkD8RJ
         pKgthmlQVlnbja+wGI8woQoI9eO5rro2kPeLeQTexcVr93n2IngoT5j9mb0Z1Kfdor/e
         XO4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762281385; x=1762886185;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S+qOQwxfN64qmYsF01vjK7YlVT/sIFKRQ4EeU3BDs4o=;
        b=alt0xPoML4R1vur0cIdGWN7UziAiq6ATrKCAW1XEmM+14CX9lvYpnEcoh1jpiEGqDB
         TTBHOMVl3poDPI4ggXtj1T69VMm6FB/xCuvweZsoAyjZx44CXM7AK76xlx0PPF1vfQ+9
         6PgBCfpA7i0Oz4D5ftF0Sc1gEskBmyelsnABDV7A7bm1rmtp5VVQnzO40TYSKAGu6Sxl
         BHzTL5SjOxz1n77Tp6b+tcCx9LOtL2v0wI1ZmPDgh/xISrFzKrTeLcagfkLovWYiGIId
         p4XTwwkIydoaWtVAw3PsVRK8YQFRiP4nP34jwRf9OmDmNQzwMKbWWasojHvuLW5MhZUo
         nzTg==
X-Forwarded-Encrypted: i=1; AJvYcCW3nbb7fepKlThIS4pdFdg/cUPeg2+lOG4PgkQCVkmWtA8Sn2IujBQ7EnsP0rcLL2k0nEIdRZWAiid8@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+z9pINujs+0NDJwdYwVNSTpUGpiO/3UodDrTerrLkVQu81hL8
	7NYMpKwaThz5xz11uBx+AfHhw1eBpfELlAOqUPryF951z67FkCAuqevwzX7+pO8mWYI=
X-Gm-Gg: ASbGncsMDC/MesBHN93jCcu/pQKLfPuDccFiFf4Uf7g7pXUwHxjNp/455SoM67eJwFh
	XP8nUa6xzcu+AXblF1S8NnULuH34Mq5lYLVHdX96j2WgTw4veZzidyiCZduMk3ex2rTb/WL2LTY
	Vk8EBWFQdkmBCNyrbpM0bLukeOVE/7rop80rH4UVDeTWubHfB/SSEhe/BmO+jm97KP+BOz8JISA
	JSwYrGdnVzFtY7tfQ7TdDpRVlXQDuvn9uunCduXfhfwONHq9BO4btNGz4nbcZmyids+CT3MDCEI
	lSASCqmhp0o+Zj+jCia6lTvSWvPNUjkFfP3YredYHtqO0I2Mtrjj+pJVrzpdpXV16JezZ0tz4dQ
	rLZLndx6nzNK42Ck6az6RJjuh9xxQPLjToQghyH7teppPMpUq4/Bly2rZZN81YP/ZN14dHgcnIT
	deSoXHOpfqj8iw3jQfgCqu5c0=
X-Google-Smtp-Source: AGHT+IEnR2psnzPx+1g8M1v8iuPpltBNgHmLBznqDt6V+MFNoJ7oCyKOUDMVl+6Ny1hv8tF/qNLwHw==
X-Received: by 2002:a05:600c:1d07:b0:471:803:6a26 with SMTP id 5b1f17b1804b1-4775ce265d1mr2708915e9.37.1762281384874;
        Tue, 04 Nov 2025 10:36:24 -0800 (PST)
Received: from [192.168.15.14] ([152.234.106.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd392040csm3651030b3a.19.2025.11.04.10.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 10:36:24 -0800 (PST)
Message-ID: <33de0eaf-474b-4e88-a445-2f12387bc36c@suse.com>
Date: Tue, 4 Nov 2025 15:34:12 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: fix refcount leak in smb2_set_path_attr
To: Shuhao Fu <sfual@cse.ust.hk>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
 Bharath SM <bharathsm@microsoft.com>
References: <aQoYCxKqMHwH4sOK@osx.local>
 <CAH2r5mu7s4p88RhUbCm5mqUvEVM60OOTTJOZ+rz09nFfc+t3mQ@mail.gmail.com>
 <648b7b14-d285-449a-a1b3-4cd062a55b02@suse.com> <aQowQ7gCdDruGVro@chcpu18>
Content-Language: en-US
From: Henrique Carvalho <henrique.carvalho@suse.com>
In-Reply-To: <aQowQ7gCdDruGVro@chcpu18>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/4/25 1:56 PM, Shuhao Fu wrote:
> On Tue, Nov 04, 2025 at 01:23:33PM -0300, Henrique Carvalho wrote:
>>
>>
>> On 11/4/25 1:12 PM, Steve French via samba-technical wrote:
>>> There are multiple callers - are there callers that don't call
>>> "set_writeable_path()" ?    And so could cause the reverse refcount
>>> issue?
>>
>> Yes... Even if it does not cause an issue today, that fix looks like it
>> belongs inside smb2_rename_path?
> 
> I placed decrement in `smb2_set_path_attr` since it seems like a wrapper
> of `smb2_compound_op`. I figured that this wrapper should handle the
> failure cases the same way as `smb2_compound_op`.

Makes sense.

Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>

> 
> Thanks,
> Shuhao
>>
>>>
>>> On Tue, Nov 4, 2025 at 9:21 AM Shuhao Fu <sfual@cse.ust.hk> wrote:
>>>>
>>>> Fix refcount leak in `smb2_set_path_attr` when path conversion fails.
>>>>
>>>> Function `cifs_get_writable_path` returns `cfile` with its reference
>>>> counter `cfile->count` increased on success. Function `smb2_compound_op`
>>>> would decrease the reference counter for `cfile`, as stated in its
>>>> comment. By calling `smb2_rename_path`, the reference counter of `cfile`
>>>> would leak if `cifs_convert_path_to_utf16` fails in `smb2_set_path_attr`.
>>>>
>>>> Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by path name")
>>>> Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
>>>> ---
>>>>  fs/smb/client/smb2inode.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
>>>> index 09e3fc81d..69cb81fa0 100644
>>>> --- a/fs/smb/client/smb2inode.c
>>>> +++ b/fs/smb/client/smb2inode.c
>>>> @@ -1294,6 +1294,8 @@ static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
>>>>         smb2_to_name = cifs_convert_path_to_utf16(to_name, cifs_sb);
>>>>         if (smb2_to_name == NULL) {
>>>>                 rc = -ENOMEM;
>>>> +               if (cfile)
>>>> +                       cifsFileInfo_put(cfile);
>>>>                 goto smb2_rename_path;
>>>>         }
>>>>         in_iov.iov_base = smb2_to_name;
>>>> --
>>>> 2.39.5 (Apple Git-154)
>>>>
>>>>
>>>
>>>
>>
>> -- 
>> Henrique
>> SUSE Labs

-- 
Henrique
SUSE Labs
