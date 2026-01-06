Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683853BB4A
	for <linux-cifs@vger.kernel.org>; Tue,  6 Jan 2026 16:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767715429; cv=none; b=cqPAhJ69ZG9MzdFNggIFUD+eNIjw+b+eZHBGNe89IDE9SWUMkcIl1IhT/g0R86G/ASZsTiHAIUlpMDxtLpDksb1NfdWow7qWfY4riYljwglke5HqU4Dxy8PkMtayETJoZIoEu+Byoi6S467ya++h0TwZDkbc42r42k1SlXsQU8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767715429; c=relaxed/simple;
	bh=S3j+EoMmEPRDjvRenyUDQ8VZg4Df11nVrMwLKFPR7PE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MGmdQc5v7LKjqKL7rjkI79zSfTvvPoC5AvqqBHAvC8h788RBQbXIS7F10d2qhRG4y/tp191qm5qbTnyf/K1qHR5+0nOzmZx0EKlz73rPQdnngLlaYRZ8KGdgk+A2Dx8p/jr04TSIaEbXSOpuPFQ66hSlhngFCLD6Q5XQaNfApDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W2mUc/wO; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W2mUc/wO"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7e7a1b08e9dso12846b3a.2
        for <linux-cifs@vger.kernel.org>; Tue, 06 Jan 2026 08:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767715428; x=1768320228; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gTPl4GDLtDvy5s1puMd7Z8u6iUxpZqoiSEJaF90pePg=;
        b=W2mUc/wObtsr9m6Qhs8ZtTPgF8+H/70JLI7h3dEFPyFlgCf5Nf445IkyaJD7pzvK8/
         XQVzfaoPjq10eBMmRqbg+X7xAeNBKvve6Ba+WdcyEKy3rbRADjEu3k9nye2La/49n+MV
         Zl6ge9J0T27PSNYZXeXunNLq/Mq3sW+qH8KFWWvn7groHN4NLwAMLElAjE+lrRgIpAhI
         roBCXfs6/j6BEOKrGjKe6bf3hLgaqY/5vcH3T/XtfvbXWu3vmM2m9rqoYX2rxTLAO7G4
         A1eJf23dHyWZDbkX1cr/iE0S1vQZLYyIiNrhXsGxpYgUbI7MNfAYrfZ3u4gvmzDyP7FW
         eMOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767715428; x=1768320228;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gTPl4GDLtDvy5s1puMd7Z8u6iUxpZqoiSEJaF90pePg=;
        b=a2CVRl8O06lImWcHieO6rur33UQTVT8QCP1zT0O3dmNkcx1Mflr5lRqcuqiMAf+fTq
         hRLeATG+3yzYw8AVf410ejCEoti+tj9hXNTfM4btn+y68YDz0u+1vRcmkZ63iMqUnOhX
         1gl97fdm6zOVS0YlNmi4NQKzhFh4aP28fo5ynocHdqi67IBTdbcrRcaB1EVAnjxaXXG9
         FCWrN+A/qIaLA2Bt7LhniLVFycrZeBoW5IeYFL/HxiCd82NYp1B8W32sMw3Zfi+9w53r
         RVYVddOPQwuU8GvB2J2xMY7d94k603h4QZfPic2SP9EaemscN02c1P7yVfbUHzBnr09A
         /+VQ==
X-Forwarded-Encrypted: i=1; AJvYcCVX7XWLBM5DxFlSq5cf6+s9bc7LOme7q/DO4KQdla4NXX/dD27pIlY+1p0CHHapnC0qr7YT/+iXoblG@vger.kernel.org
X-Gm-Message-State: AOJu0YwN7eBJ8mtbZ+vYR7MyJA8Ppge5HEPceWsk5bMwlHE5++YxywQu
	MKRO2gx+D43ct6KjbYsH7x2HZmf6BtPH4agYbk/EvIoOLBObWHBNBJBI
X-Gm-Gg: AY/fxX4HB7HW0msxUYmix/SLOivPJJ3Tgx9VpSKRrwtCcNGHuO4oajD1i614xAbMXx8
	halpAJb8Af5bAOwx3zw+aaOrSRFIP00D2xVT9mW56a3EGUYn37cS5qAZ+0e9Df3Fik9DKZ+IjYT
	2XotSePh5hR/Hpvd7f1GmX6iLmuBKUWrwMs+VQP15fjZ3J/vxzSe5O5FUvQQQhgd0CqRmyhA1po
	6T7+jMOlUc9vj+lhCn3csZOBlCMn6Ed8SOVIrlHx07tteHzdvmnpGlAYtZMPPrvQaOP0GBw7lic
	8fzvGBfXLfj7yWO00QynjIMLVyUDygdjL5syTQj92iXNiCCLmK8pUHEjvPQjTcvz4VkJ9tpWdKs
	EzojMp0iHCLxlV4v+tYB4ASa5l4dNQXIsHN6tFQpWWzYOBT2CzwX3spj2a5K0aLyyMcij+BGXw9
	Mt2hMxC8fBOYnPVMvlQAOzpp/ewbbx68aqOExnLFFTVWdkkB2EE9kuYwRsK6CEh0xsdOzc
X-Google-Smtp-Source: AGHT+IEEqzl06p50gXT59TEM4caZ0nmMzDhPgOWelqFpx3BK0NGhSAFtElbbzRBSz8uT+0FEjHFHug==
X-Received: by 2002:a05:6a00:390c:b0:7ab:3883:36 with SMTP id d2e1a72fcca58-818834c5566mr2140732b3a.4.1767715427430;
        Tue, 06 Jan 2026 08:03:47 -0800 (PST)
Received: from ?IPV6:2405:201:4039:48b0:14b5:43be:7bc5:b81c? ([2405:201:4039:48b0:14b5:43be:7bc5:b81c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819baa195e4sm2579523b3a.3.2026.01.06.08.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 08:03:46 -0800 (PST)
Message-ID: <0b7d9053-db8b-4153-9bf4-99af66c64262@gmail.com>
Date: Tue, 6 Jan 2026 21:33:42 +0530
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: terminate session upon signature
 verification failure
To: Steve French <smfrench@gmail.com>, Enzo Matsumiya <ematsumiya@suse.de>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com
References: <20251226201939.36293-1-aadityakansal390@gmail.com>
 <s4kmfu25glkgu44wl46e3q3bjvyhlbcvnlaiuqkuey4qlg4d5o@s7ispothcved>
 <CAH2r5msUWXyzLTK1BtJ2feNe7Sj7+P-y6aix6Tdc4yJgUc8TEw@mail.gmail.com>
Content-Language: en-US
From: Aaditya Kansal <aadityakansal390@gmail.com>
In-Reply-To: <CAH2r5msUWXyzLTK1BtJ2feNe7Sj7+P-y6aix6Tdc4yJgUc8TEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/5/26 22:30, Steve French wrote:
> On Mon, Jan 5, 2026 at 10:37 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>> On 12/27, Aaditya Kansal wrote:
>>> Currently, when the SMB signature verification fails, the error is
>>> logged without any action to terminate the session.
>>>
>>> Call cifs_reconnect() to terminate the session if the signature
>>> verification fails.
>>>
>>> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
>> Thanks, I think this was long overdue.
>>
Thank you for acknowledgement.
>>> ---
>>> fs/smb/client/cifstransport.c | 7 +++++--
>>> 1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
>>> index 28d1cee90625..89818bb983ec 100644
>>> --- a/fs/smb/client/cifstransport.c
>>> +++ b/fs/smb/client/cifstransport.c
>>> @@ -169,12 +169,15 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
>>>
>>>               iov[0].iov_base = mid->resp_buf;
>>>               iov[0].iov_len = len;
>>> -              /* FIXME: add code to kill session */
>>> +
>>>               rc = cifs_verify_signature(&rqst, server,
>>>                                          mid->sequence_number);
>>> -              if (rc)
>>> +              if (rc) {
>>>                       cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
>>>                                rc);
>>> +                      cifs_reconnect(server, true);
>> I'd like to hear opinions on having reconnect happen only if signing
>> is required by server, otherwise only log the error (current behaviour).
> I was thinking the reverse - if the signature verification on the
> client fails but it was the server,
> not the client, who forced signing, then we could skip the reconnect
> (and just log), but if
> client forces signing (sign mount option eg. or
> /proc/fs/cifs/SecuritfyFlags setting forcing
> signing) then we should be more strict and reconnect
>
Thank you both for replying amidst holidays. I understand what you are
saying. I am 
happy to revise the patch. Which version should I go with: reconnecting
when server 
forces signing or the reverse?
>>> +                      return rc;
>>> +              }
>>>       }
>>>
>>>       /* BB special case reconnect tid and uid here? */
>>> --
>> Nonetheless,
>>
>> Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
>>
>>
>> Cheers,
>>
>
-- 
-AK


