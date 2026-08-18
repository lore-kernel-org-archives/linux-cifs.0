Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9B79460
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 06:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787034811; cv=none; b=jrMxRVYRNAWWJO2ABd7qKEdhqnAduJu1p1NLIEVpBMFTjnmqP2XuAln3gFrpwwu33fsV4SCRnlo7YUTueMGx4RCG762Po7wvN7J/lqlZ9fAQ2JNYLbQRSxWZFCzpI3e6BRzav0MVFGvphEshlzoVBA3g9IZJnxDaJdsBuUvsym0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787034811; c=relaxed/simple;
	bh=wACIL5l1nzeTMxOMXilHAzB3Vyr0BmkowTFodjAyfFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B934Yv+bblCWj5y9cpyc6pLv/vRCIdUzetb4lTu8cu9CA1s82akKkTgbOl0wgcSNOAycBl8zk7hmnN0IvVXdpO/ehSUKdzN7LjnN3IBYuUYzzxQhQmGOFbKXZBRImweF0X71HZ3HzFBWlJl38au3Uf4c7OA4SEsU7swpwqh56ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q7EGYW7b; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lFb+EToK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q7EGYW7b";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lFb+EToK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787034807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FP6/4QD++Lt11Si7AWptT9ARlethlVge9lcY7SIdRy0=;
	b=Q7EGYW7bJCbvgtrjuywkY54payJ7RS98moX8TzesCkDiqbxGYRBDjtLwLolrjvlIk7CqeK
	utvvCRXFJB41X33wiFJVFktlaKXH0bhivR4c9SHa1J9IUD0AiQPCx8z7wdAL1wG5rH0iOC
	V4+lEvzn8Hk1DNJRXTjKV25IQXWrZxA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-C5KDnf1NP525srUMEFs6wg-1; Tue, 18 Aug 2026 02:33:26 -0400
X-MC-Unique: C5KDnf1NP525srUMEFs6wg-1
X-Mimecast-MFC-AGG-ID: C5KDnf1NP525srUMEFs6wg_1787034805
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4957287363bso24989005e9.0
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 23:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787034805; x=1787639605; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FP6/4QD++Lt11Si7AWptT9ARlethlVge9lcY7SIdRy0=;
        b=lFb+EToKgWgrwCjZ3cZa/sYunhFGwwqSZ+SQ2ctQT29MFsbgCE3GCVWz0J9jn1FXXB
         4IZ/+Iqn81vu0N8M639+ABrAZzmGX6fJE0y2rMQasSOfJlF0XuehBj/6Rq5ksC3TdQXA
         Ro2/6gLPQ9HluGA4bldS1BUu5SWsgQQdCEbWRfvBprlUiMZCNVhpYmzkAJEbfvdimou6
         UqXxOWaqt0PWphXy9wj3v3Vg/vnFA9nHd+sIf7ASlmAhwdeZXWe6vQRH/A1kThHCiTCQ
         /sIFeI1vGU9DOGORYW1rCEgImSz7eooK/y6wgof16vM40oT6grZ3qh2FkrCmUpht5chj
         tP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787034805; x=1787639605;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FP6/4QD++Lt11Si7AWptT9ARlethlVge9lcY7SIdRy0=;
        b=eE5ElKXveuCCMewnDKWuKs740/uvwj9D8HsuwPp0363ZQynoGHmnFExYFYZTxfmU+3
         mueuJRi2+mhqDcQvio9eSBwMpXwM6yx1Kmvt9vJQhuapPW8qqzCKYHwLscXo7c7h3Tta
         SGuSnxgAZIHsjHa88wtlNZExL0vmtdZaDqX4iZAEVTRLCMrudLOXbKI8T+OdcRQ2f6iy
         sXXgh7pmV4NsGC2b49h+ruoQpBB/jdjf5rhxgQCKxTHJtABkPr6C8ns3RiJwvk1x89yu
         EE7TyyCdJVdGMBJlMwJU+BaxdkGWTeWQqaeMYyGlT5HqqrLWHYKOr377L9Ma98Dx5jG8
         UjBQ==
X-Forwarded-Encrypted: i=1; AHgh+RrywSrB2tPY4JR5Q+aZ8GPvhRP3ZdCNO7qLRCImI6Is9cBzrXm8Nia+c0feQHAxYXMScv16iiPsATTm@vger.kernel.org
X-Gm-Message-State: AOJu0YyIl1L1VFV8FmwYoQSWsXiPB5UwNdOBbvJY3wrlsPU3XXfcp7kU
	XmqVzF0rJt6jGjqTxAuzgDIwcQULYEoTiMmAG4/rZrVhQcI3iiL+Y1vN+kEVR/G5HP8ZNrIqPkL
	GDz7mUVMdBAjgnkWOxb4Cz4jMCB70puA4d7qHjC+czMYL5IhUygW7HPRlSSvL+Uw=
X-Gm-Gg: AR+sD13BasK8GbgHnA9EGbyWvG63MELbivMq0ks3zt3w8u1getNN9O9u6SK1/6kpByr
	e5LdKCItSQ0XbTdntKjxK9InUCfXGUkcNI/CE+vbCcdX0U//z4sHWG7DAARK77YfoPYycfKCiw7
	VuRUuVvQZYATFZHmnd9LKow+q+RyDd0oQrHAb923tWGoId8zgCu2/uELm09Ec5YExtbqnXnL1YU
	BxJBlJjYy3FNvSvI+QOmzXRgHfxr1x0cWj+2jCq7z5Vf/VZ1Mgd11+zO7ruz1JEBM8SZnaG691O
	1Bh0/4jIuUXmc5Se0mYQdkAaNI/bchpJJufOzsO9vVAkv9RWgQ/q7JVYCOCJ23SX8d9msTfQPbI
	IQ5thP8YcJzMZ7MxsWXF8pe3ZhNRz58V4Ermi
X-Received: by 2002:a05:600c:3f06:b0:499:484a:81d0 with SMTP id 5b1f17b1804b1-49987961c32mr504855485e9.9.1787034805200;
        Mon, 17 Aug 2026 23:33:25 -0700 (PDT)
X-Received: by 2002:a05:600c:3f06:b0:499:484a:81d0 with SMTP id 5b1f17b1804b1-49987961c32mr504854765e9.9.1787034804876;
        Mon, 17 Aug 2026 23:33:24 -0700 (PDT)
Received: from ?IPV6:2a01:599:b20:fbe:bc54:ff69:ca5:383c? ([2a01:599:b20:fbe:bc54:ff69:ca5:383c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996100184sm262439635e9.1.2026.08.17.23.33.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 23:33:24 -0700 (PDT)
Message-ID: <779785af-8700-42ee-a0f2-562343af6db2@redhat.com>
Date: Tue, 18 Aug 2026 08:33:23 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] smb: client: Clear sensitive stack data in
 smb1encrypt.c
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
References: <20260812130152.2861834-1-thuth@redhat.com>
 <20260812130152.2861834-5-thuth@redhat.com>
 <CAKYAXd_yLTgWFBv_ygYvbBdQcp3Z=pZ7F0A=_c8qdXWTLGdi1w@mail.gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <CAKYAXd_yLTgWFBv_ygYvbBdQcp3Z=pZ7F0A=_c8qdXWTLGdi1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18/08/2026 07.58, Namjae Jeon wrote:
> On Wed, Aug 12, 2026 at 10:13 PM Thomas Huth <thuth@redhat.com> wrote:
>>
>> From: Thomas Huth <thuth@redhat.com>
>>
>> Make sure to not leak signature data via the stack, clear it
>> with memzero_explicit() before leaving the function.
>>
>> To avoid that we have to introduce "goto"-cleanup here, we re-arrange
>> the code a little bit (and drop the commented cifs_dump_mem debug
>> code that looks like a leftover from very early days).
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   fs/smb/client/smb1encrypt.c | 19 +++++++++----------
>>   1 file changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/smb/client/smb1encrypt.c b/fs/smb/client/smb1encrypt.c
>> index bf10fdeeedcab..c9eb68f04e7b0 100644
>> --- a/fs/smb/client/smb1encrypt.c
>> +++ b/fs/smb/client/smb1encrypt.c
>> @@ -81,6 +81,7 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
>>          else
>>                  memcpy(cifs_pdu->Signature.SecuritySignature, smb_signature, 8);
>>
>> +       memzero_explicit(smb_signature, sizeof(smb_signature));
>>          return rc;
>>   }
>>
>> @@ -126,15 +127,13 @@ int cifs_verify_signature(struct smb_rqst *rqst,
>>          rc = cifs_calc_signature(rqst, server, what_we_think_sig_should_be);
>>          cifs_server_unlock(server);
> The MD5 context in  cifs_calc_signature()  may remain uncleared when
> __cifs_calc_signature()  fails.
> 
> rc = __cifs_calc_signature(...);
>                                                 ┃
> memzero_explicit(&ctx, sizeof(ctx));
My plan was to handle that via a __cleanup() function, too, but I need to 
get that merged first:

  https://lore.kernel.org/lkml/20260813134953.979481-7-thuth@redhat.com/

  Thomas

