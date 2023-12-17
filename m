Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5804AF98
	for <linux-cifs@vger.kernel.org>; Sun, 17 Dec 2023 23:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHUSsdgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFF6C433C7
	for <linux-cifs@vger.kernel.org>; Sun, 17 Dec 2023 23:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702857483;
	bh=skET3iz98dpuNhdEhSGEsXlw1rIb8S23ZcVcrFmn7Uo=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=CHUSsdgZsf3uUqluzl9RQ4I2cOqlYj7W05hn1ms0dsh5M7TUXFYKONMJLYIGJhkay
	 NNp7IARlAYXTp+B18gozI0iUZRh1htmPRjzp9hl8rG+0jvxYy6DWwRRE9Gseq2cZBU
	 UXepflpuf7a0awIV4o/ULhIgOyN/XoB7GEGT1+8rHXBa8ydYle/rY9OhQ8N/DCgqnY
	 6IBOozjORPLqr2j5XDwTBh/jMyxpkmcHS9Bn06pFfUYVhiJTMNSW/BDPU1H6ypTEVC
	 wREc5L1N42xlP4RTxfVCW0QzxGfNIzu1GAUwmTRzQuqQGZAkXf5gM60xfxRBPBH2Ih
	 S3qqvH0MzYMhw==
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6d9d29a2332so1107551a34.0
        for <linux-cifs@vger.kernel.org>; Sun, 17 Dec 2023 15:58:03 -0800 (PST)
X-Gm-Message-State: AOJu0YyTfZn0iMWZ0LX7quocFHupsn72B6JwsS6070794/SYRlo/XrLn
	uwIHZsMaC1HmivpmL1fHDjHzetjGlquOhpVqhwc=
X-Google-Smtp-Source: AGHT+IGELtbRDLazngKTM0oj1eJiY0KuVMYjAfCuX1W2asRmSOMPMZ6yJpnrT2WJZSC/E8mohGeJfvU3W1DYj2FVefE=
X-Received: by 2002:a05:6830:1d68:b0:6da:56d7:4ea1 with SMTP id
 l8-20020a0568301d6800b006da56d74ea1mr1653239oti.9.1702857482592; Sun, 17 Dec
 2023 15:58:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:7f88:0:b0:507:5de0:116e with HTTP; Sun, 17 Dec 2023
 15:58:01 -0800 (PST)
In-Reply-To: <4cdd0fbb-2afe-497c-ade3-e445c5c0ae53@talpey.com>
References: <20231216122938.4511-1-linkinjeon@kernel.org> <4cdd0fbb-2afe-497c-ade3-e445c5c0ae53@talpey.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 18 Dec 2023 08:58:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_X8Ono47BMPc-4UQVLJe-PSdRFLD5WxK-Vbs=5KbDTyg@mail.gmail.com>
Message-ID: <CAKYAXd_X8Ono47BMPc-4UQVLJe-PSdRFLD5WxK-Vbs=5KbDTyg@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: set v2 lease version on lease upgrade
To: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"

2023-12-16 22:37 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 12/16/2023 7:29 AM, Namjae Jeon wrote:
>> If file opened with v2 lease is upgraded with v1 lease, smb server
>
> Can you elaborate on this scenario? Lease v1 is SMB2, while v2 is SMB3.
> So how can the same client expect to do both? And how can the server
> support that?
This patch is to fix smb2.lease.epoch2 testcase in smbtorture.
This test case assumes the following scenario:
 1. smb2 create with v2 lease(R, LEASE1 key)
 2. smb server return smb2 create response with v2 lease context(R,
LEASE1 key, epoch + 1)
 3. smb2 create with v1 lease(RH, LEASE1 key)
 4. smb server return smb2 create response with v2 lease context(RH,
LEASE1 key, epoch + 2)

i.e. If same client(same lease key) try to open a file that is being
opened with v2 lease with v1 lease, smb server should return v2 lease
create context to client.

>
> MS-SMB2:
>
>> 3.2.4.3.8 Requesting a Lease on a File or a Directory
> ...
>> If Connection.Dialect belongs to the SMB 3.x dialect family, the client
>> MUST attach an
>> SMB2_CREATE_REQUEST_LEASE_V2 create context to the request. The create
>> context MUST be
>> formatted as described in section 2.2.13.2.10 with the following values
> ...
>> If Connection.Dialect is equal to "2.1", the client MUST attach an
>> SMB2_CREATE_REQUEST_LEASE
>> create context to the request. The create context MUST be formatted as
>> described in section
>> 2.2.13.2.8, with the LeaseState value provided by the application
>
>
>
> Tom.
>
>> should response v2 lease create context to client.
>> This patch fix smb2.lease.v2_epoch2 test failure.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/smb/server/oplock.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
>> index 562b180459a1..9a19d8b06c8c 100644
>> --- a/fs/smb/server/oplock.c
>> +++ b/fs/smb/server/oplock.c
>> @@ -1036,6 +1036,7 @@ static void copy_lease(struct oplock_info *op1,
>> struct oplock_info *op2)
>>   	lease2->duration = lease1->duration;
>>   	lease2->flags = lease1->flags;
>>   	lease2->epoch = lease1->epoch++;
>> +	lease2->version = lease1->version;
>>   }
>>
>>   static int add_lease_global_list(struct oplock_info *opinfo)
>
