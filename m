Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0105020E6
	for <linux-cifs@vger.kernel.org>; Mon, 18 Dec 2023 02:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qzcNuJk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8AAC433CB
	for <linux-cifs@vger.kernel.org>; Mon, 18 Dec 2023 02:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702865153;
	bh=7WLxAtXwQp4PI++HPoUqRdL+RI9QLfLz2HQHMDa1zfE=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=qzcNuJk+1zN3pxCWcVl1Q3S3XsL8hGdV2qUq59vdxkEiL4fGlqGtROItWdQklwYG5
	 Y+elVx4wKO88nHQxKcOb1jPXzxUENel8c6B8BbCNe8Oalte6KL0/HBVV3Cgbqh5xDr
	 uKVxTgl0qy8XKsh4+Ti4OtdqpRdVfV8TJdAtV/gFbGpLueHhwphCAf5LrxkTz/Z03L
	 U/0+PSb66+oMDL9NdUYXu6r7aRMzSW0beB7q+hPCYZc1jj5k1FVUnDsDz6GI0Ed8xN
	 AZOmkXmy542p5CRJQCNoB36gqyCN5VCZyKG2Dv8G20OR5PBcm7tZfzdC/db2ICvJRs
	 azKYbR4y1YsfQ==
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-590b3337d2bso2065286eaf.2
        for <linux-cifs@vger.kernel.org>; Sun, 17 Dec 2023 18:05:53 -0800 (PST)
X-Gm-Message-State: AOJu0YyPwRIqHBzd26SfRPf7kI12nGPUeNY8DcboRROTGdw3vBaVYGxY
	oIKG6IPo3f3MUiUKU/UQX3F2S6SgIypKhxqGuhU=
X-Google-Smtp-Source: AGHT+IFFxfQ90F9+5gt1F5R2CYfiY2xppstNd0lCYz3vnLxFdVNfRlppKf4an0m2LJyb7hprR5w6jNHK+ZJkwBdLQ/4=
X-Received: by 2002:a05:6820:1ac8:b0:58d:6ea3:8fc with SMTP id
 bu8-20020a0568201ac800b0058d6ea308fcmr14461704oob.2.1702865152646; Sun, 17
 Dec 2023 18:05:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:7f88:0:b0:507:5de0:116e with HTTP; Sun, 17 Dec 2023
 18:05:51 -0800 (PST)
In-Reply-To: <80c916d6-6759-4590-9636-a3f393be4652@talpey.com>
References: <20231216122938.4511-1-linkinjeon@kernel.org> <4cdd0fbb-2afe-497c-ade3-e445c5c0ae53@talpey.com>
 <CAKYAXd_X8Ono47BMPc-4UQVLJe-PSdRFLD5WxK-Vbs=5KbDTyg@mail.gmail.com> <80c916d6-6759-4590-9636-a3f393be4652@talpey.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 18 Dec 2023 11:05:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Pff+2f1R-yJqhYi6nBSB5dAMUr=qguHR2PXEs8oRJZQ@mail.gmail.com>
Message-ID: <CAKYAXd_Pff+2f1R-yJqhYi6nBSB5dAMUr=qguHR2PXEs8oRJZQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: set v2 lease version on lease upgrade
To: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"

2023-12-18 10:33 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 12/17/2023 6:58 PM, Namjae Jeon wrote:
>> 2023-12-16 22:37 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 12/16/2023 7:29 AM, Namjae Jeon wrote:
>>>> If file opened with v2 lease is upgraded with v1 lease, smb server
>>>
>>> Can you elaborate on this scenario? Lease v1 is SMB2, while v2 is SMB3.
>>> So how can the same client expect to do both? And how can the server
>>> support that?
>> This patch is to fix smb2.lease.epoch2 testcase in smbtorture.
>> This test case assumes the following scenario:
>>   1. smb2 create with v2 lease(R, LEASE1 key)
>>   2. smb server return smb2 create response with v2 lease context(R,
>> LEASE1 key, epoch + 1)
>>   3. smb2 create with v1 lease(RH, LEASE1 key)
>>   4. smb server return smb2 create response with v2 lease context(RH,
>> LEASE1 key, epoch + 2)
>
> Oh, this makes my head hurt. The protocol requires the client to never
> mix REQUEST_LEASE and REQUEST_LEASE_V2 on a connection (as I quoted
> below).
>
> BUT! There is no requirement for the server to enforce this, and in fact
> a requirement instead that it merge v1 and v2 leases, where possible.
> This kinda sorta makes sense for SMB2.1 and SMB3+ interop. But it opens
> up this ambiguity!
>
> Practically speaking, I don't think this should ever happen, given a
> conformantly written client. But the patch does appear to match the
> required server behavior.
>
> So, reluctantly...
>
> Acked-by: Tom Talpey <tom@talpey.com>
Thanks for your ack:) and I will update the patch description also.

>
>
>>
>> i.e. If same client(same lease key) try to open a file that is being
>> opened with v2 lease with v1 lease, smb server should return v2 lease
>> create context to client.
>>
>>>
>>> MS-SMB2:
>>>
>>>> 3.2.4.3.8 Requesting a Lease on a File or a Directory
>>> ...
>>>> If Connection.Dialect belongs to the SMB 3.x dialect family, the client
>>>> MUST attach an
>>>> SMB2_CREATE_REQUEST_LEASE_V2 create context to the request. The create
>>>> context MUST be
>>>> formatted as described in section 2.2.13.2.10 with the following values
>>> ...
>>>> If Connection.Dialect is equal to "2.1", the client MUST attach an
>>>> SMB2_CREATE_REQUEST_LEASE
>>>> create context to the request. The create context MUST be formatted as
>>>> described in section
>>>> 2.2.13.2.8, with the LeaseState value provided by the application
>>>
>>>
>>>
>>> Tom.
>>>
>>>> should response v2 lease create context to client.
>>>> This patch fix smb2.lease.v2_epoch2 test failure.
>>>>
>>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>>> ---
>>>>    fs/smb/server/oplock.c | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
>>>> index 562b180459a1..9a19d8b06c8c 100644
>>>> --- a/fs/smb/server/oplock.c
>>>> +++ b/fs/smb/server/oplock.c
>>>> @@ -1036,6 +1036,7 @@ static void copy_lease(struct oplock_info *op1,
>>>> struct oplock_info *op2)
>>>>    	lease2->duration = lease1->duration;
>>>>    	lease2->flags = lease1->flags;
>>>>    	lease2->epoch = lease1->epoch++;
>>>> +	lease2->version = lease1->version;
>>>>    }
>>>>
>>>>    static int add_lease_global_list(struct oplock_info *opinfo)
>>>
>>
>
