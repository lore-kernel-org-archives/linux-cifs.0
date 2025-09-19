Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776AD2C3259
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 20:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758315097; cv=none; b=Kg1NYyN8BDOlUufXCesQ30d5CFIV3vXvwgJJ8QVS9UYHOejB37spfrgEPCQnMWmhjPGiF+9Hvf1+kthKO2VdS3qntX3aXE7sZ+LLqiDfxnUVEH2MZ73XJES64b3nxvwfHFtgx8m0cd7xazkqriGfnIrC+EvQ9mIGAH7juJr+3JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758315097; c=relaxed/simple;
	bh=Xr9JYn0gSMGcoAJ4BbA8RcrY9ro07YEjAGZlTP5n04E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j59msbRZGSpxMZxaJijITgUYsCwISLTLSitWgfQSIlbKNJpijMI+Nm7nk9AhNvBA8/fLvNsGZ1e7FZNalsn4/RvlMPM8NRIbYZo4QVvfQ8HpcRkeWTCO4ZnF2ma5ncWpJh3sfaDoRrqIxt2kD8fVjnRjZD4KciankGT/yIFOVf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZAC8s6de; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZAC8s6de"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3eebc513678so1300522f8f.1
        for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 13:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758315093; x=1758919893; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zycSjJnFz9fY6zkx/vh8i+78uM0eHjvat7qxBMzwu3o=;
        b=ZAC8s6de00i0q4OG+b8zRcQrCP63eRke9aBw7Mb8hyTSz4BXrznZB0u1VSWT2rVEPN
         a8yzEEHnq8rG7VmUxblixQa1AJFLFjhgO5ROQsimQcjn9c229LjvAI8u71WogZu/5gH1
         i8ZTFY+Gnra1uh1mFC/aOCwZK+BoWpTwK5Cg4KA1fjiSj8XhV9aKmUNWt1v13fx6heeX
         Rhs64r9OS7jgc078rioIJENTfBKT2zZkw/b4T9MttP1BioENXNXFU57oYsdPf0EYwDaa
         NnHlzAZ2XNKP6yzzUaiB0dR9Wp0U/TxbP1nD7imFenyh3sx/IwrNi3py5w0aPFe03v3T
         2PNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758315093; x=1758919893;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zycSjJnFz9fY6zkx/vh8i+78uM0eHjvat7qxBMzwu3o=;
        b=sHoAg8sVcfZCV+wWZo5Au0f7jOusVhwuUEnQCuDUr02e58EqRbCtPXuy+8kPx+fFlg
         OJKcHhq8yHsE46o5c3pb0m2Wxxwufp4JsKm9HSutILPJj9mmag6/q8dSMM5VUPzRi0TP
         OQRjnHLFwV40Ti9umUlESetOQpw+MB3Yah2luLP0+fBsN7BEf4SDnJ4+pNjF5COVuuGP
         jBsjMdSqeVOvNSBId7rbY4Xs4k532+6kRyBinsRewGJIE7WiGDFDjVC44tGTKyxdtiN4
         Zm7l9//jax/KtchvWJ85wrkrPM12w5+ahVO8ZXtXiqhDd1Quovp2deYqnB3oEvHFs5v1
         Q7qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoCFmiliPE5Nc0D/iM/gNgeyRqcLeEX7IpC/j6qpGe5vtho8JgoOAgx4I57r67k+DkPWgSXsB3wqWB@vger.kernel.org
X-Gm-Message-State: AOJu0YwAPxtd05Xpeb60ft1lscgSp/DPFX+RL1+FDgLEB5FCq/IdeeVh
	F8WpTcCGPOl6mpVX0iirdFmD580m3kvVy5uylO8It1hWGpVSkAlVp75P81UlD51X/m1uH9OwLup
	ESipR
X-Gm-Gg: ASbGnctTKm32k8gEWe7bwtp5LUvKh1upESUWCz42+aNxR3+ii2usIoIc/qYxEch/sYv
	M2lW/R5zyhly+Ybf0Hiqb2iU9Tkg6kGGn+phOKpC6CtVsWxXZ0ug2QcgCzq8Ndd4dpCiZ0MT62z
	ruiwp4D37qE1lvo74W9e8f7lX5Y1Lgf/mGMenzcsF6V+3T0on2GC8LgqV3fv81iYy7tP/gkvgpA
	nzOt6RLEZXUJtJEnatmq8cd/LlQ7sS0iux0JIZERtXP9FPrRaDdjJiBi49wyWuiqVm7aPtqdLzB
	H7QysfifzwaJwqP11n/gYsefHGYeCgcVU44YKhVyEb9a+U4lPM20ntyGY6Zi3tCCxkH891ZX/FV
	Ve5ZFM6aDm7LuoabdKG1uGvjhjYdHo641VGnCSel7zCu8ySRvRKpncVc7RiqG504YdCLXTCFUMw
	SVrw==
X-Google-Smtp-Source: AGHT+IGiWJoTggHILhSVY+kgyN+ZhkZKvSneJFqyc5MEeJdV6F9iikGaAmX6CBazzVMul5qI3Gn/yQ==
X-Received: by 2002:a05:6000:2502:b0:3d1:e1b1:9645 with SMTP id ffacd0b85a97d-3ee85581345mr4054552f8f.43.1758315092311;
        Fri, 19 Sep 2025 13:51:32 -0700 (PDT)
Received: from ?IPV6:2804:1b2:1845:cc86:aff7:4c3d:b10b:28d5? ([2804:1b2:1845:cc86:aff7:4c3d:b10b:28d5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f1815af13sm624699b3a.0.2025.09.19.13.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 13:51:31 -0700 (PDT)
Message-ID: <ef49e995-3dba-4a2d-8e3a-6d5c2bec0843@suse.com>
Date: Fri, 19 Sep 2025 17:49:22 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] smb: client: short-circuit negative lookups when
 parent dir is fully cached
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org
References: <20250919152441.228774-1-henrique.carvalho@suse.com>
 <20250919152441.228774-3-henrique.carvalho@suse.com>
 <grz6l27jndyzc4mztngv2wslloimamsvu6jztchbijsmzitybr@nl6xeyjqh3wp>
Content-Language: en-US
From: Henrique Carvalho <henrique.carvalho@suse.com>
In-Reply-To: <grz6l27jndyzc4mztngv2wslloimamsvu6jztchbijsmzitybr@nl6xeyjqh3wp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Thanks, Enzo.

I'll address the comments in an updated patch.

On 9/19/25 3:54 PM, Enzo Matsumiya wrote:
> On 09/19, Henrique Carvalho wrote:
>> When the parent directory has a valid and complete cached enumeration we
>> can assume that negative dentries are not present in the directory, thus
>> we can return without issuing a request.
>>
>> This reduces traffic for common ENOENT when the directory entries are
>> cached.
>>
>> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> 
> (unrelated to the patch)
> Can a dentry ever get here being positive?  AFAICS it can't, but I might
> have missed some obscure code path.

AFAICS no, but I would also like someone else to confirm.

> 
>> +
>> +        /*
>> +         * We can only rely on negative dentries having the same
>> +         * spelling as the cached dirent if case insensitivity is
>> +         * forced on mount.
>> +         *
>> +         * XXX: if servers correctly announce Case Sensitivity Search
>> +         * on GetInfo of FileFSAttributeInformation, then we can take
>> +         * correct action even if case insensitive is not forced on
>> +         * mount.
>> +         *
>> +         */
> 
> If you're going into the case-sensitiveness hole, several other things
> can be fixed re: cached dirs (and other areas, as we know lol):
> 
>   # mount ... /mnt # not using nocase
>   # cd /mnt
>   # mkdir abc
>   # ls
>   # ls abc
>   # ls ABC
>   # ls ABc
>   # cat /proc/fs/cifs/open_dirs
>   # Version:1
>   # Format:
>   # <tree id> <sess id> <persistent fid> <path>
>   Num entries: 4
>   0x5 0x1d800a8000021 0x760051e015     \ABc       valid file info, valid
> dirents
>   0x5 0x1d800a8000021 0x760051e012     \ABC       valid file info, valid
> dirents
>   0x5 0x1d800a8000021 0x760051e00f     \abc       valid file info, valid
> dirents
>   0x5 0x1d800a8000021 0x760051e00c        valid file info, valid dirents

Agree. The code can likely be improved for users who don't care about
case-exact matching.

> So, as I understand, for the 'nocase' cases, it might be worth building
> the path string and comparing with strcasecmp().
> 
> Other than that, this seems to work fine though.
> 
> (also, extra line at the end of the comment)
> 

-- 
Henrique
SUSE Labs
