Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27A428371
	for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 19:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771183398; cv=none; b=FUmnUnwCAT9dv3kpBInGHe3d5gRLYpqipc71K+VHP79GArNaaD7DnLQGlUM0yyCnJNy3gMTPAbUJy2REDoLRyeynTrtUaBF5M+A5n9iR7jhv2rNsRhtXDtHUj0XFAbZB8l8xTbyHOGDHdLtN7Z85WtN+w7u+A9Uod2MW4WzfqaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771183398; c=relaxed/simple;
	bh=1FWna5Ib/OAtv8B2GY1vSXFEYnWEyAPcK55OZL0arbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZXqoj/RBSqm+1ETn6maon1aCbFjXkTw3FkM+y10NRa6dGcCWdPYfoQi/kgc6ZyAz+z13gRzUeRIEwBaSmKBA6ZeZG3hMDUf8AGs6jHsLcX4tUc/lPi9TGJpftakBujhdzF67X/9yQXV6jvRMXXMnLD5eS+y7QAD0k6vhdqoyoBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fd0qQzwO; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fd0qQzwO"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35622f00cb0so125099a91.3
        for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 11:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771183397; x=1771788197; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PmqCpvPxfkxskVldiO4M9fau3YMWRtcEpBYx3zR/vD4=;
        b=Fd0qQzwObwZlox1+U6NETwPN5zYVi8HcnWrY+ZzFyUo0uMdY0M4gZUPYLYZlJdRV0k
         6bcCyqjSqE7Gv6C7Vljx5FTtsikTslbMRy1gaJZCE8psF1mtwEjWcmULE0sVshXUjll6
         VyJw8zgCQb1Vd1qgqwF7XAuF+Bh6d6xiq+8dd/Ojc49SvmD+TXPBSegZgyViOAc6xWeb
         b1fPyR9T6hKJEVTcJM4/BcEoAa+ZnTCyir0wgIyQvlFoRqSMjt1zujVWjJUa68c12jN9
         oVUElAKjQR0qbO0w1nZId8f/dpu/8PpkmQVdTFxvSvq8kZvYI1bRxe5OXAPw4s7lQuPi
         TT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771183397; x=1771788197;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PmqCpvPxfkxskVldiO4M9fau3YMWRtcEpBYx3zR/vD4=;
        b=MxM1IawdTPFqWZe6e2hJksxJY7Ar/hvD3iiJC2IoP0luxEI4oECCFZ7x0xzcCpZDTG
         dG6L5GClwMXz78oZuiLToP7WftCloh5Y1wQ4tDE6MwPKKIFKHX7NU4OEAHGi3rF9MGxm
         EOuIdBHpXi5my9E7zcriHqq4lb/FSH70tBMwjQWULbSUAy7rxlK7Xd+/51NdRg6zZ5Si
         AS4lUuQWSp1GEiE7v2vfr6124Pv4uSsVovP0MHGAClnfcLPcrTHEAoYW/jM30SJSBgBN
         hq/QwYIc8xMeeKSjmrlOD3Kh2x5FLLcrBmBdnCiAQalxt1gVrAOm3B09SydHbYkaHY1l
         kLOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXB9V6L+waxop1jxduLYBhPXbDX1rwRLTEVB7E0ehlQYVU2LUibZ56Im/3HJJ5IK6rnmnlNiXXopYL5@vger.kernel.org
X-Gm-Message-State: AOJu0Ywmfqvmtmov4ZKmEleXZYy5n3gcD8Kxc6XzDXnYOLNGGKyowyCr
	hzmugLGzmebJsYuYZgBH4JQRyBBNOHfjqjfCa2hFpEG+DMTCvjMSk/Ru
X-Gm-Gg: AZuq6aIwhsFYg+ovRT7b8UFq+SD1LssYgIdFBPWVCdA3anS7FQL8udHCS3eNP4yIt2Z
	kuHanEj0S2CnuZgpvZ9cK3mlYdDgUmun/pIOLAKsSluyvdWG6m/JRufeHNbc/Chl2FXdJe33HJf
	yTo49cI5mT4AmKrS5h0Ttwi/OMnrZOY+yLom8vJUcJ29S3a2tdQjMlIQSW/WzE6JeWYSi/M2nYj
	tbV+xnUC4yYalHJLQCGbM7zbiGMWwUV95JgmuPtYEujN/evj2k7R5Ho77so4peDAOriTXnoIbXL
	GBC2b6fTwHuO55Yw84h2LSWMsxw9qPOxxNQ7jDo7wJJrrzX+nodoDMzzPV6DJXwjtqo91SCZIdo
	rQKYCVyHhkCbx2BbdkfyXY6qNwWZXrkUD7FVN7DOI0LzBUYVAVg+CKVtsJXfF6Q8bDm43Rhm2Ag
	Ol3hiccVzBUHp9lL5S7zGt9IJvicWqpYOlZA==
X-Received: by 2002:a05:6a20:9146:b0:345:42cb:50b8 with SMTP id adf61e73a8af0-39467329e4cmr6468616637.8.1771183397087;
        Sun, 15 Feb 2026 11:23:17 -0800 (PST)
Received: from [10.7.19.128] ([49.36.181.127])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6b6a3edsm8324050b3a.41.2026.02.15.11.23.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Feb 2026 11:23:16 -0800 (PST)
Message-ID: <edd75933-91b7-428e-b88b-dcc4e8bdcae7@gmail.com>
Date: Mon, 16 Feb 2026 00:53:12 +0530
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: client: terminate session upon failed client
 required signing
To: Steve French <smfrench@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org
References: <20260205010012.2011764-1-aadityakansal390@gmail.com>
 <b36e2732-0678-48c4-a50e-58512b4d9f6c@gmail.com>
 <CAH2r5mt+608DDhj93Fa55PZ_-1yfJZTa5v4LQ-D48V9ZYPDJUA@mail.gmail.com>
Content-Language: en-US
From: Aaditya Kansal <aadityakansal390@gmail.com>
In-Reply-To: <CAH2r5mt+608DDhj93Fa55PZ_-1yfJZTa5v4LQ-D48V9ZYPDJUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 2/16/26 00:01, Steve French wrote:
> On Sun, Feb 15, 2026 at 7:17 AM Aaditya Kansal
> <aadityakansal390@gmail.com> wrote:
>>
>>
>> On 2/5/26 06:30, Aaditya Kansal wrote:
>>> Currently, when smb signature verification fails, the behaviour is to log
>>> the failure without any action to terminate the session.
>>>
>>> Call cifs_reconnect() when client required signature verification fails.
>>> Otherwise, log the error without reconnecting.
>>>
>>> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
>>> ---
>>> Changes in v2:
>>> - reconnect only triggered when client required signature verification fails
>>> ---
>>>  fs/smb/client/cifstransport.c | 10 ++++++++--
>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
>>> index 28d1cee90625..6c1fbf0bef6d 100644
>>> --- a/fs/smb/client/cifstransport.c
>>> +++ b/fs/smb/client/cifstransport.c
>>> @@ -169,12 +169,18 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
>>>
>>>               iov[0].iov_base = mid->resp_buf;
>>>               iov[0].iov_len = len;
>>> -             /* FIXME: add code to kill session */
>>> +
>>>               rc = cifs_verify_signature(&rqst, server,
>>>                                          mid->sequence_number);
>>> -             if (rc)
>>> +             if (rc) {
>>>                       cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
>>>                                rc);
>>> +
>>> +                     if (!(server->sec_mode & SECMODE_SIGN_REQUIRED)) {
>>> +                             cifs_reconnect(server, true);
>>> +                             return rc;
>>> +                     }
>>> +             }
>>>       }
>>>
>>>       /* BB special case reconnect tid and uid here? */
>> Hi, I am writing this as a ping for this patch. Thanks
> merged into cifs-2.6.git for-next but had to rebase it to merge into
> current code.
>
> Have you verified the behavior of default (smb3.1.1) mounts as well?
>
Thank you. Yes, I have checked it for the default version.
Tested for both client required and server required signature verification.

-- 
-AK


