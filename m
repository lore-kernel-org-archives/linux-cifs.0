Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0185C3D544
	for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 22:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771195328; cv=none; b=qkDxG6SqTkOJs12dntdVrcWen7wgDPa5Ju7+1b/t0BejgLZoi58u8PXFhvEO1vLdQB6vmAPSVpNneZFLQBGhpBTkRNgsm3r948JR3Vl7+Rpxh8IZfFP5Rf5lbdv4d441jI17kayeotrpRL/RgDwHD+6FicjhiDQVUbyd9dJ8wfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771195328; c=relaxed/simple;
	bh=eFMSbGPHKJLKd+UUfyavbVJ10Byid5SES0I3ALuitYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ROpykA+yxrs+aUSZKOQvzr9mvIdOMQjm5EGmcKf3MxcSRuvdm2ghzYlkhHnZmuMHLcilO8l6/CmaCWA0pcSzEhKVRwJY4sa+oXGsgaRenMjEFpNTNWnBgptw6Jj9wLpxI8BHuo7IvEkSzh3sZy30aAodtj3agQhlNcs9h+2cJI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ImfcI1IH; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ImfcI1IH"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-824b621ef8aso360779b3a.1
        for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 14:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771195326; x=1771800126; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mBZZhM9RxJ2wT2YJxrw9okWoxgUFRqqH8dmb9Tm/Uk0=;
        b=ImfcI1IHDFVdzto8Nc4XMEE/Bhf3qlCc3JfGFaDZnc6PD2oUMKORAchUtzucomsoLD
         iidS9FYy317NCpF6bzYOFK/LAW+Ig/n9eIBbGLCUMaD+2auugzgV3MGfolA9uFKA4U/3
         OOMev7hPj1UCZOC5rxpc8nJi4i7IQFTSvWhUN0+dWgxeaVRu0yo2ZXfc4teoDfTE8pLo
         FT/dkiqpxEu1xxCfJuodLeRq1fXufkoR5QgIL00fID+gWrvCUSujSMfpodIUCTXM6N1U
         jNwu9COLoVKhKpuH7R0xTn+YxSv9GyNyo2r1RIkzFVw197Hv3krxjXtBqPjgNmr1VORr
         jNfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771195326; x=1771800126;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mBZZhM9RxJ2wT2YJxrw9okWoxgUFRqqH8dmb9Tm/Uk0=;
        b=eSRYexSx41VNzSeqED5ihZivBBGZeTOOCBlLKN85zaUkl99UV7IcF4SNJ9K7gIOtTe
         mIuWBifHrVub9oxqZf6sUe+J30jJ4wSnGXCsF6SPYu87lTDOk8yPkJBHu824Bcv1swFS
         UmPyFxKH3yBom7KVBgCCNbZSgHcORWenpBljE4tDlRz++jYWwKWwfgxGqPumt/5lRJOw
         Mx9gMLGWbvXXEspkTPpyetALAZ5ThTliI9o06Qcu/GHSS5Z2S4J7NN483QvPTriewqP7
         F5DzTCIPIRGRGT82qDV1EUt5eBv/vVRdvmcfKWsRfbiBSRj/CFlpNdTLi8aFSV5UNbsI
         2J/A==
X-Forwarded-Encrypted: i=1; AJvYcCVNt38OkGhCeQBm+kKvQ3mKXbiKs3EYyyNDTlFzOEO7mZKOLDMWwonjztSKNjWvMAyTq1xvBYN9ymww@vger.kernel.org
X-Gm-Message-State: AOJu0YyA7REkpj6fuhp0nvuxfn0tFncRpJPtqFfLdp9P/iENMJeQLfzP
	LLXXv6t7BkAbxc97K2xbT89G62BgN/nYjreXVe/0kvTALBVp7TKLa2J8
X-Gm-Gg: AZuq6aJBROCu7tdk/GZ7C1Uhmqn9PzKRulBNzkWbm9CrfvYKQTDPWy6F4fiMtFu+UPW
	MWUXPV4nQT9Piv7M3u9qcGiNipXaiDjJz9/SJYdZUof7rv5U7INcdIsqrPA4efHMderTHCF/3ja
	DlFCnD7jn4wutF1EGgZox4YrPVdGwAGshKc/lB5t1VhZn9pt4XI+gteEVd2PxEFux+cPc1HP7z4
	97b7074YX1P6vKjwVXsC0eKW78J77URrTS0uOp+9NfBPWF/34TcGkKhcKihyUWV5b6XxtCi/wCe
	Scyfjej3MArFsEGc8hdmkbLe63yLX/3FQyfE0yhyPvMh+Zdr8w6KyNNU5A4IbIJMNsUzKvRYI5S
	qk5BG4k0KdgDtP66uGKZ1Jdffi15tXMUSKqbD1RMMi62DITCBrBSu275RqVuA9/G15ChzfqAFe2
	AEID2XnQ7XcJ6DnOcEfj5UAueO7s/iaf4/nQ==
X-Received: by 2002:a17:90b:33c1:b0:340:b8f2:24f6 with SMTP id 98e67ed59e1d1-356a763a941mr5586948a91.2.1771195326245;
        Sun, 15 Feb 2026 14:42:06 -0800 (PST)
Received: from [10.7.19.128] ([49.36.181.127])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35848e46ad4sm5542812a91.11.2026.02.15.14.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Feb 2026 14:42:05 -0800 (PST)
Message-ID: <f11adc2a-2d97-43ed-b7ff-e6480449eb95@gmail.com>
Date: Mon, 16 Feb 2026 04:12:01 +0530
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
 <edd75933-91b7-428e-b88b-dcc4e8bdcae7@gmail.com>
 <CAH2r5msF43X+Gm-7eY3m=wyf+K6Hwzxx0522QrqD7VSWeJJwog@mail.gmail.com>
Content-Language: en-US
From: Aaditya Kansal <aadityakansal390@gmail.com>
In-Reply-To: <CAH2r5msF43X+Gm-7eY3m=wyf+K6Hwzxx0522QrqD7VSWeJJwog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2/16/26 02:38, Steve French wrote:
> On Sun, Feb 15, 2026 at 1:23 PM Aaditya Kansal
> <aadityakansal390@gmail.com> wrote:
>>
>> On 2/16/26 00:01, Steve French wrote:
>>> On Sun, Feb 15, 2026 at 7:17 AM Aaditya Kansal
>>> <aadityakansal390@gmail.com> wrote:
>>>>
>>>> On 2/5/26 06:30, Aaditya Kansal wrote:
>>>>> Currently, when smb signature verification fails, the behaviour is to log
>>>>> the failure without any action to terminate the session.
>>>>>
>>>>> Call cifs_reconnect() when client required signature verification fails.
>>>>> Otherwise, log the error without reconnecting.
>>>>>
>>>>> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
>>>>> ---
>>>>> Changes in v2:
>>>>> - reconnect only triggered when client required signature verification fails
>>>>> ---
>>>>>  fs/smb/client/cifstransport.c | 10 ++++++++--
>>>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
>>>>> index 28d1cee90625..6c1fbf0bef6d 100644
>>>>> --- a/fs/smb/client/cifstransport.c
>>>>> +++ b/fs/smb/client/cifstransport.c
>>>>> @@ -169,12 +169,18 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
>>>>>
>>>>>               iov[0].iov_base = mid->resp_buf;
>>>>>               iov[0].iov_len = len;
>>>>> -             /* FIXME: add code to kill session */
>>>>> +
>>>>>               rc = cifs_verify_signature(&rqst, server,
>>>>>                                          mid->sequence_number);
>>>>> -             if (rc)
>>>>> +             if (rc) {
>>>>>                       cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
>>>>>                                rc);
>>>>> +
>>>>> +                     if (!(server->sec_mode & SECMODE_SIGN_REQUIRED)) {
>>>>> +                             cifs_reconnect(server, true);
>>>>> +                             return rc;
>>>>> +                     }
>>>>> +             }
>>>>>       }
>>>>>
>>>>>       /* BB special case reconnect tid and uid here? */
>>>> Hi, I am writing this as a ping for this patch. Thanks
>>> merged into cifs-2.6.git for-next but had to rebase it to merge into
>>> current code.
>>>
>>> Have you verified the behavior of default (smb3.1.1) mounts as well?
>>>
>> Thank you. Yes, I have checked it for the default version.
>> Tested for both client required and server required signature verification.
> You were able to verify (simulate) it as well for default ie SMB3.1.1
> (not just for SMB1
> which this patch fixes), and no changes needed for SMB3.1.1?
>
>
Yes, I verified for default version (3.1.1). First I set signing
required option on server side,
then I set the sign flag on client side. SMB3.1.1 mounts with no issues.

-- 
-AK


