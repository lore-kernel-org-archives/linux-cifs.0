Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7636E28643A
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 04:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772080074; cv=none; b=hmdnh21b5HaZ1Tojof1pEbc4xm6TywOZ1dEkMcABphus2GICMni3gcocvG7Xkg1DUAb5ZsERlVBOVU30BeOG6DFSetJzYwFNPZa/0u2MD1VbF776wZixi/DKPniV8JIYH6y7tfNXts+E6/2E1c0om/jspaL/EFpUmXCpsCfhv+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772080074; c=relaxed/simple;
	bh=WBfy3V4IcMBGEHu59aBLnhYDf395E/35FG2XiQilr2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fa99kugOxANFpSTt7lKWaHUG277lxUpOa6+Mj1UFAWDzH7/6fge0WPdpPWLrfBv8Bvb2aO/lQhS0wBglFWYeApfbXEu3rmPQO5K92UKBEcwHC4lb6gI7bvMBqt8+qEVSaKpDtv0sTRBVEkkBbszM8PPSVOgQIJREKfIda2/LVKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZNXD+50X; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZNXD+50X"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2adbd435864so1324965ad.2
        for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 20:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772080073; x=1772684873; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=0hgYTjKG6CxePh4c18qcmDKdU8dbdd4hE3eggxiOExo=;
        b=ZNXD+50XgT8RruOBMfHIe++uiyag5Noion2tnJz90aR23mPqBGilp7ns0mM9QgjJqv
         UZdl8LdTwyw59AWowvp0D95cP7sxaYStsPMgT3L5bbXIKz0drYMq2KaVs3ibYRmUusui
         ido/6DRE2S1AhDvudlNRfkt+VxWZSUlrUhDHsn96wBa7bQe/pO39ww+0ot0D8p+OOrMC
         4H5wM8YOA2tMpIuCiXaZkXXjlv1hMvNJbtvj4oZkK2f/ojLP3MtvgkaXzSFR49FKK+Rn
         S+rTKEU3nVxWY0Ff4mi7uYK46ECO45kSh4IFiwgbPzpcQ7iADqeshUuDrbFUgiqf+Csi
         LPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772080073; x=1772684873;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0hgYTjKG6CxePh4c18qcmDKdU8dbdd4hE3eggxiOExo=;
        b=je+Sti18mhljlBFpEy/ekPLcwLr08/rQ7pxNV6rXDcp77OOFxU2OQ61PnRT34rSyrQ
         MqVbpgOKy4I6x/P41Y573RaH3ERVGLJS00wmO9ulnd7IrbUHna6F0JuPMle8z6bDD5gX
         GfSoqgqEI2x9rd2nOOUfQhMH1V6bE7B8pxelv7UNQ5NITJIWYxto5+UDcx1y2MsHm4lu
         a34t5sWF0tozqS63jm/dRtoPyXorILOtBYfhLVHaH5IHfvpiM8mcTKWajZ0ZA5lHXBSb
         6Q14TzSqzwEnxzUvwtWtFKvkspeoP2EIPY2bNbjuSZcLi1X5MtudF/IlDVf1bQqCQDLU
         I2vw==
X-Forwarded-Encrypted: i=1; AJvYcCWokdXDJCvhDWJEmQ1VjphkV5sHotoTS23myfB4M+DmSkGkl2uaq/CLOj8PwuRwM+k9aweLe8AuX69L@vger.kernel.org
X-Gm-Message-State: AOJu0YzhmxB82Bto7tjaIjlU55Okr62MppXTX9J9tw11X5UuaebyJALn
	RjHeTd4bqd0WH1KPmigTL28YiOCLNdG7Ec1bOgowGCUGbEmTGntr3m15
X-Gm-Gg: ATEYQzyS4BhN7vjfIk6879z27kfwcocbL8sSCPHr+5Au0y5b6BZB/MUbDWWaXrRaODe
	6mtljxdv4cUToXObfDPa2Alal6rSoMdMJ8bL8KOLtRDeNRl2UB6TcifoMjd0A4Pe1Sc1s2tSftV
	LkHlJvItICM6yRsJWAnag2B5sDM1bZa2GiWGiYSXMO7wovuqinOApHoZWTg4ne+jgDcgHMZzooS
	i415MQ7u054CoJZ3I3pRW0awrfpXN8zJFFTQIuRxbt7hoclmSCV3bNlOGL5sJH0VIk1MDtGS64T
	aN5PnScZEzWfxko+Shv1XvP/qzt6thnkKSr9aJfXdYFffV5npxsadqYpXgSTTYehoEj/dJsXk9D
	uO6Lha8aavtnQzf+58fcSQ8mbYAzksUL6cuqvCJJ/mQcSBLPoYb/89vS2ji5uNmvU7qEfmfbH5n
	OGGEO31QPG5pQbCWjXSmLrQWY0gch22qF5aploiE1mVXMwwZLokpnIdJ0rjj/Qiz6za3204up3
X-Received: by 2002:a17:903:2c5:b0:29e:76b8:41e5 with SMTP id d9443c01a7336-2ad74513efemr180605555ad.30.1772080072843;
        Wed, 25 Feb 2026 20:27:52 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a05e831sm841946b3a.58.2026.02.25.20.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 20:27:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <cf791e95-23c2-42d4-9bd6-828320a2f430@roeck-us.net>
Date: Wed, 25 Feb 2026 20:27:50 -0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] smb/server: fix refcount leak in smb2_open()
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251229031518.1027240-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251229031518.1027240-2-chenxiaosong.chenxiaosong@linux.dev>
 <97979f06-7dd2-46bd-9bdd-3a9c45fc5b1d@roeck-us.net>
 <d3d93c04-fdd1-4b96-90f2-293a2d45f647@chenxiaosong.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <d3d93c04-fdd1-4b96-90f2-293a2d45f647@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 2/25/26 20:12, ChenXiaoSong wrote:
> Hi Guenter,
> 
> Thank you for taking the time to look into this issue.
> 
> I reviewed the relevant code in more detail and did not find any leak.
> 
> Both `ksmbd_put_durable_fd()` and `ksmbd_fd_put()` will eventually call `__ksmbd_remove_fd()` (remove fd from file table).
> 
Thanks a lot for taking the time and checking the code.

> If my understanding is incorrect, please let me know.
> 

Just to make sure, I'll have another look at the code and provide
your feedback to the AI agent.

Again, thanks a lot for your time.

Guenter

> Thanks,
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> 
> 在 2026/2/26 00:49, Guenter Roeck 写道:
>> Running an experimental AI agent on this patch produced the following
>> feedback:
>>
>> This isn't a bug introduced by your patch, but it looks like there is still a
>> resource leak here. If ksmbd_override_fsids() fails, we jump to err_out2.
>> At that point, fp is NULL because it hasn't been assigned dh_info.fp yet,
>> so ksmbd_fd_put(work, fp) will not be called. However, dh_info.fp was
>> already inserted into the session file table by ksmbd_reopen_durable_fd(),
>> so it will leak in the session file table until the session is closed.
>> Should fp = dh_info.fp; be moved before the ksmbd_override_fsids() check?
>>
>> PTAL and let me know if it has a point or if it is missing something.
> 

