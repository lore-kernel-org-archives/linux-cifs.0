Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DFF7E
	for <linux-cifs@vger.kernel.org>; Sun, 14 Jan 2024 05:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="guP6w95p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435B5C433C7
	for <linux-cifs@vger.kernel.org>; Sun, 14 Jan 2024 05:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705209619;
	bh=dlSVwMMMA5C+kPqVWkik8cpooQSbg74PLFdOnDlC4ss=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=guP6w95plluS/WHURoniJ6NPL2jcg9la2dS8uc8qoFMtmFUP/pJMBEaA23QupwFmF
	 WjWGZLJuNyS5xAFwaITjDQMEhxJAL3Ns7XeBR2Nw0PHzpc3SDNGZbkGlARSTN3hosv
	 oo33fOIm/RZGv8uhREut39H7Tuc9tpWdR7xatlGBhJAeYlvOXodDKlyy3GpCGAWl4B
	 IOM+MvPb3KYdSjtTfHRpSsooycUnffj27rBFmf5pwMwNACC6NytUKJphsS+RLOKBMd
	 k9cKGldQ9hkRJPoioMce6JWriBUQCuyUmuUD8IH1I/VgF4tQ+iVHgJ7cWnJr+19hX0
	 Fy3CcNVU1h7Lg==
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-598e70cd444so431174eaf.1
        for <linux-cifs@vger.kernel.org>; Sat, 13 Jan 2024 21:20:19 -0800 (PST)
X-Gm-Message-State: AOJu0YxTQdNx4PPNaA/NNtOP0CdIiaP9hyDqMf10/JvsoANZSS8/vO54
	5vIUYXwMmjSCqG4flIc2FMH3/BWChzJNZIu3a7M=
X-Google-Smtp-Source: AGHT+IGZiEzqimeX9BOUQ6gL+WS4SM6Y7iTzQi0KsISLrhNCGQOF6ttclOzOX7L4ZtD+/Gu58nRp9M217zKOinRS9ZM=
X-Received: by 2002:a4a:ad01:0:b0:598:9a54:c687 with SMTP id
 r1-20020a4aad01000000b005989a54c687mr1856432oon.8.1705209618569; Sat, 13 Jan
 2024 21:20:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:668c:0:b0:513:2a06:84a8 with HTTP; Sat, 13 Jan 2024
 21:20:17 -0800 (PST)
In-Reply-To: <6b7670f5-44d4-4b1e-aef1-5f15ec809072@talpey.com>
References: <20240113064643.4151-1-linkinjeon@kernel.org> <6b7670f5-44d4-4b1e-aef1-5f15ec809072@talpey.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 14 Jan 2024 14:20:17 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-mwcZx2e1wz+fL3EFwMfRjyytpLQ5yic+rVGw4Tu4dgA@mail.gmail.com>
Message-ID: <CAKYAXd-mwcZx2e1wz+fL3EFwMfRjyytpLQ5yic+rVGw4Tu4dgA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: update feature status in documentation
To: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"

2024-01-14 8:53 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 1/13/2024 1:46 AM, Namjae Jeon wrote:
>> Update ksmbd feature status in documentation file.
>>   - add support for v2 lease feature and SMB3 CCM/GCM256 encryption.
>>   - add planned features.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   Documentation/filesystems/smb/ksmbd.rst | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/filesystems/smb/ksmbd.rst
>> b/Documentation/filesystems/smb/ksmbd.rst
>> index 7bed96d794fc..251e27900f88 100644
>> --- a/Documentation/filesystems/smb/ksmbd.rst
>> +++ b/Documentation/filesystems/smb/ksmbd.rst
>> @@ -73,15 +73,14 @@ Auto Negotiation               Supported.
>>   Compound Request               Supported.
>>   Oplock Cache Mechanism         Supported.
>>   SMB2 leases(v1 lease)          Supported.
>> -Directory leases(v2 lease)     Planned for future.
>> +Directory leases(v2 lease)     Supported.
>>   Multi-credits                  Supported.
>>   NTLM/NTLMv2                    Supported.
>>   HMAC-SHA256 Signing            Supported.
>>   Secure negotiate               Supported.
>>   Signing Update                 Supported.
>>   Pre-authentication integrity   Supported.
>> -SMB3 encryption(CCM, GCM)      Supported. (CCM and GCM128 supported,
>> GCM256 in
>> -                               progress)
>> +SMB3 encryption(CCM, GCM)      Supported. (CCM/GCM128 and CCM/GCM256
>> supported)
>>   SMB direct(RDMA)               Supported.
>>   SMB3 Multi-channel             Partially Supported. Planned to
>> implement
>>                                  replay/retry mechanisms for future.
>> @@ -112,6 +111,9 @@ DCE/RPC support                Partially Supported. a
>> few calls(NetShareEnumAll,
>>                                  for Witness protocol e.g.)
>>   ksmbd/nfsd interoperability    Planned for future. The features that
>> ksmbd
>>                                  support are Leases, Notify, ACLs and
>> Share modes.
>> +SMB2 Compression               Planned for future.
>> +SMB over QUIC                  Planned for future.
>
> Technically speaking both compression and QUIC are SMB3.1.1-only.
Okay, I will update it on v2.
Thanks for pointing out!
>
> Tom.
>
>> +Signing/Encryption over RDMA   Planned for future.
>>   ==============================
>> =================================================
>>
>>
>
