Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2481221A434
	for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 05:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771219113; cv=none; b=j/cNzUHIn+1/vhnQaYBDzrlPuYjtgFxcGgIF0AWSb8UZAWidDMoZHTsQCqYJD/4/S6xqcOIs6czL7T83DrdfKa0mv3ryZtlXik0lZ4nxiEfFQa8RaRRvEpjiQYxccOaNIgLl44F52sQksgoHrKz9X/ocxg3CByYfFBR2AeH/xoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771219113; c=relaxed/simple;
	bh=WlM6Kb9ZYee7SqMHjGZa5/D+QeKiFK9CeaPRekjlhLk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ODYJbqwcDIqSWtQtLRDwGd7eT53oLJenOdhTUZgPv98fsdZ2jGw6QMP+OBI5krC6Pe6UGC7d53Gc2dcYrw89LIbooqpbF4HmF/876U3zpws1SHQLRv18BrKr03Jixmuqz+6KBVVslYDtKSf5/vERy1zJy8ixvwmblzHO8SrEfQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KMQhtbrp; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KMQhtbrp"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c629a31d1d0so131240a12.1
        for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 21:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771219111; x=1771823911; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=71Pqqdflxf09yNwzd62GvZJHNB+lEYXjdnqGso1GvXw=;
        b=KMQhtbrpZc4CF9SAW5gVwqlLFQ46AyCIAe+cCSkqJ8a6tU/cKW9osZsQFfvDQ7PyWz
         rKwLVLWWhwSj0w4zWrDkhCHKiw1DJwCmy0RWgTNik3kKxCM9BD4USOcXpTTJzbcbGDsF
         5yne5LHvJodRPPS+Pfpba8llycVwU8YjLv1S+9rXa/vV+VfcPZphwjnd6oJzG8aAEOdL
         HgEOM82iXzZbM/Dy5wU+mwm82NJh/mXWzIq7GEOpOni1UVbMwJhWh9kOu076QsMThuC2
         iDQT/03Rf5EGz8dhLUVdcNGJ0pc+vGssCJTy3su2jt8en53szNYIK4oCOjb/ekBKPUvQ
         67Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771219111; x=1771823911;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=71Pqqdflxf09yNwzd62GvZJHNB+lEYXjdnqGso1GvXw=;
        b=DgMeqzcanF26CvZZg+twMsuiuNfmmiEkynfn2vBedcz5Rldw6hG7wCD0EdvjpvkNqo
         n1HgCtVxhPLH2NNXM06k0ZQ+oTxCCYvOlZqi9k8+u6sGzQJptTC4t7nKK3MwUiPJ1P9G
         zrABu+maexCYV6kHtobV0xQ1ORnWOHBY3gEdBcd6mc25Bx1LhI1PebnLu+XN8/eoDPBM
         YuHYBImgwLVSJsEVajKVC5vAVUicPPZZCzBkWCBxhxoG180vYOQXfX7BeIYqRbmnYEOw
         XPMN6XQg2wDz5l+VtzcgGxrjlgUVN9cGzNxIjIw6yVZADE5KtfsKD9Nd2W1sXRU6woYd
         +cyA==
X-Forwarded-Encrypted: i=1; AJvYcCV3ZR7GHDLK/Cd6gNOLSwzLXuhfQcLSTM3IoRCDJ+Et/Beh4DhFfZfeZ0JgadALSM2SUHmOxuVAJ3Nt@vger.kernel.org
X-Gm-Message-State: AOJu0YxMN5TRIVIPKExvB9w+OGR54TOO2OvXo1j4cM5u4vY1L7ZDqYFO
	313Q0dhsUcgWw5qcGInB7Iz5jwLH0jyaU8JCiEMuxbay9QznT7mj66vE
X-Gm-Gg: AZuq6aIlQU4Cljcf7zjiOe9XgxEnGmUqMzSQDoJuRYtNkosisLJX9ChkUOoUvt8ycOw
	qeLXypcCbzoAhlQh0+tsSp7TxFoO1DpNuBlBDJqTlnDWDJKnbIRJKH8d4+t7+dOgrS8/O7PCrY0
	flHkKlD/PO2g3xWGGTrtdhl9NIt81iRs/Hz1p1bQTDZlQiVaDrtT9PrVWjfHJ8QbEnpQDtZ/Xwu
	2MNbczx+0H86zbaLeUDTRczO66EmAQd1vdsBniHua5Pb3zwlQjMkx3gWbToeiD52UaqpQE8Eb5T
	joTloZUIr6dNvltUJgmJIv8AbRQ/3AToEft4Frpt7/VDCWThy3xR0DqEa2YM2I5+RkIvakguNfg
	a8WemmDxyMe0e2enhel6x1yGAHFPKayWfj1AdcSKQBIDhcexsRYdQCDUfT7DRzV9Sb3bbhOr44n
	ssFbiCK91PLD9yZRNJArfWn4fIEC6o/3YYhA==
X-Received: by 2002:a17:903:3d06:b0:2a7:cbe3:a6e3 with SMTP id d9443c01a7336-2ab4cef9723mr79568665ad.2.1771219111336;
        Sun, 15 Feb 2026 21:18:31 -0800 (PST)
Received: from [10.7.19.128] ([49.36.181.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a9d5bbcsm58488275ad.56.2026.02.15.21.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Feb 2026 21:18:30 -0800 (PST)
Message-ID: <5b016773-ef74-4b6c-99a3-b6fd93715e46@gmail.com>
Date: Mon, 16 Feb 2026 10:48:25 +0530
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
 <f11adc2a-2d97-43ed-b7ff-e6480449eb95@gmail.com>
 <CAH2r5msv8TJj9-X5t83z58dwr-BjtNx6=mxCjkFMjGb-CDQuTA@mail.gmail.com>
Content-Language: en-US
From: Aaditya Kansal <aadityakansal390@gmail.com>
In-Reply-To: <CAH2r5msv8TJj9-X5t83z58dwr-BjtNx6=mxCjkFMjGb-CDQuTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/16/26 06:54, Steve French wrote:
> On Sun, Feb 15, 2026 at 4:42 PM Aaditya Kansal
> <aadityakansal390@gmail.com> wrote:
>>
>>
>> On 2/16/26 02:38, Steve French wrote:
>>> On Sun, Feb 15, 2026 at 1:23 PM Aaditya Kansal
>>> <aadityakansal390@gmail.com> wrote:
>>>> On 2/16/26 00:01, Steve French wrote:
>>>>> On Sun, Feb 15, 2026 at 7:17 AM Aaditya Kansal
>>>>> <aadityakansal390@gmail.com> wrote:
>>>>>> On 2/5/26 06:30, Aaditya Kansal wrote:
>>>>>>> Currently, when smb signature verification fails, the behaviour is to log
>>>>>>> the failure without any action to terminate the session.
>>>>>>>
>>>>>>> Call cifs_reconnect() when client required signature verification fails.
>>>>>>> Otherwise, log the error without reconnecting.
>>>>>>>
>>>>>>> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
>>>>>>> ---
>>>>>>> Changes in v2:
>>>>>>> - reconnect only triggered when client required signature verification fails
>>>>>>> ---
>>>>>>>  fs/smb/client/cifstransport.c | 10 ++++++++--
>>>>>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
>>>>>>> index 28d1cee90625..6c1fbf0bef6d 100644
>>>>>>> --- a/fs/smb/client/cifstransport.c
>>>>>>> +++ b/fs/smb/client/cifstransport.c
>>>>>>> @@ -169,12 +169,18 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
>>>>>>>
>>>>>>>               iov[0].iov_base = mid->resp_buf;
>>>>>>>               iov[0].iov_len = len;
>>>>>>> -             /* FIXME: add code to kill session */
>>>>>>> +
>>>>>>>               rc = cifs_verify_signature(&rqst, server,
>>>>>>>                                          mid->sequence_number);
>>>>>>> -             if (rc)
>>>>>>> +             if (rc) {
>>>>>>>                       cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
>>>>>>>                                rc);
>>>>>>> +
>>>>>>> +                     if (!(server->sec_mode & SECMODE_SIGN_REQUIRED)) {
>>>>>>> +                             cifs_reconnect(server, true);
>>>>>>> +                             return rc;
>>>>>>> +                     }
>>>>>>> +             }
>>>>>>>       }
>>>>>>>
>>>>>>>       /* BB special case reconnect tid and uid here? */
>>>>>> Hi, I am writing this as a ping for this patch. Thanks
>>>>> merged into cifs-2.6.git for-next but had to rebase it to merge into
>>>>> current code.
>>>>>
>>>>> Have you verified the behavior of default (smb3.1.1) mounts as well?
>>>>>
>>>> Thank you. Yes, I have checked it for the default version.
>>>> Tested for both client required and server required signature verification.
>>> You were able to verify (simulate) it as well for default ie SMB3.1.1
>>> (not just for SMB1
>>> which this patch fixes), and no changes needed for SMB3.1.1?
>>>
>>>
>> Yes, I verified for default version (3.1.1). First I set signing
>> required option on server side,
>> then I set the sign flag on client side. SMB3.1.1 mounts with no issues.
> How were you able to simulate bad signatures being sent from the server
> for SMB3.1.1? and for SMB1?
>
I changed the condition that checks cifs_verify_signature on client side
and set it
to true, to ensure the failed signature verification path is hit. For
cifs, it reconnected on
client required signature verification and for server side, it just
logged the error.
For SMB3.1.1, the path doesn't hit and the behavior remains unchanged.

-- 
-AK


