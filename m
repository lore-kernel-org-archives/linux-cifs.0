Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786672D606
	for <linux-cifs@vger.kernel.org>; Wed, 28 Feb 2024 09:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709112164; cv=none; b=XsX8wsak1+xMd2EHw4xR6wblocQuliAKLExIUYBYVh2a+JwCI4i3Aih88Cu1slrMIPsVmHxLc3uyfF5NK7s+m+sqx59ET36+gvLXMBJsG9ZoGEY3BpH3HD+mFjcZqLI8PoVF70HYDti0WHWhSxcRbCoCh0V1jVBPhbmrK1NyNs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709112164; c=relaxed/simple;
	bh=7ELz8KKbJq1u1zwIclMXg54BF20ys7MOOcXCdCZJciI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uixhmlYVKkr2uwyWhiLtpIxs+vyAxx5aAqi7VljILEpOQ9oF4dlUeGDeNxsshrSrMDKUtJLeNO78KhJP8vO5POjh5gjNqRIcRYYx3UM0sWYuxf0qic+eDResYkZMUfiimUjwEDRjXt6r90K+ERSU+/j+SlzkXhKA5CwBRFzABPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sairon.cz; spf=pass smtp.mailfrom=sairon.cz; dkim=pass (2048-bit key) header.d=sairon.cz header.i=@sairon.cz header.b=Ooqqsb3c; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sairon.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sairon.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sairon.cz header.i=@sairon.cz header.b="Ooqqsb3c"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a3fb8b0b7acso647941466b.2
        for <linux-cifs@vger.kernel.org>; Wed, 28 Feb 2024 01:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sairon.cz; s=google; t=1709112161; x=1709716961; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8zHQ9IzgkKxdIPKcKvYwQWkSvUGu8Q7TMd7yncXEer0=;
        b=Ooqqsb3cm8Lq8ivgLIlbLXuZqifHRoTlnTJgz3Br7BEoJWkXK/DshBU8H6U4EfzUTL
         JZSijTl4LOlCy65x3+HwRTuOYuOUs4poWRd8au8jmcas1+km8B6zbw0QPockoIPQn3cZ
         lEtpIrRkPZzqgmdRxT2PDUkpELCrUwWxSiyXy8F4NjilbreF4CbC4KbaVACcYWOqT2uk
         9aWXN9Q6cFaPukZtvGXpbh1q7DTjCfBje2kygZ8/KkTZfVfW/VS8+/vH7st+LpF6VGv+
         SfmZlkWxijiZLjgsb+18P8QovenwGwm/iki1oQeHSgVTtO/TQGBNlZQTTPdzSLt0fPQr
         fF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709112161; x=1709716961;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8zHQ9IzgkKxdIPKcKvYwQWkSvUGu8Q7TMd7yncXEer0=;
        b=Ap3uZ6oiiwbaU43Tps6zYxE7NODHNORmFTD0uHKOEqVip6/OtoJoc4tQKDnLaxgwHR
         VwJyyb1/mPepp3mG8v3madfPhkoP7YDZ9ZH8z5EdaZJ98ejssb3wfPQuJXQCUCfpX3m7
         TKDFmbya2U5blhEzqSik8v+RWCpII5ix2B0gQbIonz5+y3Pn3r58vwLViAmffYjQlhsW
         cnchzOIEmt6WhSsNVVSwJvUhQEpu/BWJpjhD57uHXsFji0Zq9oxc0YFJxN+96CMrW5Oq
         U+jaF7cKYCd1mJOxHtGlLRlVOsz1p9XcF/0o5Y9q5ZJ6Yuq9HBsO+a+WuKkWBunUXuhC
         QZTw==
X-Forwarded-Encrypted: i=1; AJvYcCVhEdg+iB7wWfhgtmGvHg45fso+XmTom+3C/rPg9b5b8DIHs5lZDk+MbuliddW/Vq0HpQEOaVYP9IVrBTjuppqd5P9SGjXFY3yskg==
X-Gm-Message-State: AOJu0YzmmruhprM2bdatH3RBKCS/ofdhITJfZJ4w7gGLyP6Ygo1SEWSr
	1bahvM5NKgJkNJfct2TpdaPZYjj506dZQKy8onGpghoalDhFnp7zvrrQbENpYW4=
X-Google-Smtp-Source: AGHT+IEUPuxYcQoSH/oPZYvIIlOKQa4bQmx32LrjwJrDBhl3tc6m/l9da5nI2oL5t9F7Ot3rygMGUg==
X-Received: by 2002:a17:906:2e89:b0:a3f:5144:ada2 with SMTP id o9-20020a1709062e8900b00a3f5144ada2mr9127014eji.2.1709112160709;
        Wed, 28 Feb 2024 01:22:40 -0800 (PST)
Received: from [192.168.127.42] (ip-89-103-66-201.bb.vodafone.cz. [89.103.66.201])
        by smtp.gmail.com with ESMTPSA id vi13-20020a170907d40d00b00a43ab37c3besm1497196ejc.195.2024.02.28.01.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 01:22:40 -0800 (PST)
Message-ID: <2abdfcf3-49e7-42fe-a985-4ce3a3562d73@sairon.cz>
Date: Wed, 28 Feb 2024 10:22:39 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] cifs: distribute channels across interfaces based
 on speed
Content-Language: en-US
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz, tom@talpey.com,
 linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
 Stefan Agner <stefan@agner.ch>
References: <20230310153211.10982-1-sprasad@microsoft.com>
 <20230310153211.10982-8-sprasad@microsoft.com>
 <4b04b2c4-b3ff-48e7-9c24-04b1f124e7fa@sairon.cz>
 <CANT5p=p4+7uiWFBa6KBsqB1z1xW2fQwYD8gbnZviCA8crFqeQw@mail.gmail.com>
From: =?UTF-8?B?SmFuIMSMZXJtw6Fr?= <sairon@sairon.cz>
In-Reply-To: <CANT5p=p4+7uiWFBa6KBsqB1z1xW2fQwYD8gbnZviCA8crFqeQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Shyam,

On 27. 02. 24 17:17, Shyam Prasad N wrote:
> These messages (in theory) should not show up if either multichannel
> or max_channels are not specified mount options.

That shouldn't be the case here, I checked with the user and he's not 
doing anything fishy himself (like interfering with the standard mount 
utilities), and the userspace tools creating the mounts should not be 
setting any of these options, which I confirmed by asking for his mounts 
list:

//192.168.1.12/folder on /mnt/data/supervisor/mounts/folder type cifs 
(rw,relatime,vers=default,cache=strict,username=user,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.1.12,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1,closetimeo=1)
//192.168.1.12/folder on /mnt/data/supervisor/media/folder type cifs 
(rw,relatime,vers=default,cache=strict,username=user,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.1.12,file_mode=0755,dir_mode=0755,soft,nounix,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1,closetimeo=1)


Or am I missing anything here?

> The repeating nature of these messages here leads me to also believe
> that there's something fishy going on here.
> Either the network health is not good, or that there's some bug at play here.

Maybe, however I'm not able to reproduce the above behavior yet. But 
there's been so far one more report of this happening, so it's not a 
single isolated case. I appreciate any advice what to look at further.

Cheers,
Jan
