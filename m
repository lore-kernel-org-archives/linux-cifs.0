Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8968445038;
	Wed,  6 Aug 2025 14:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754489555; cv=none; b=lR9QTpQArKzYo6vPIVS+57swsg0WQS/dUyJ8C+GhAv/wvIxoDuBTySR4iQn8xjmynj7fVT+s2YZ6sIq7mP9UAfCbBtajfoNfMGC/lqR4u1Kq9ATEdMr64Fx78SM/7FKJIwCij2PjjrZMqF4siu6aFcrdMtkeQeHPNLc2PyvkB5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754489555; c=relaxed/simple;
	bh=fI2GocGMDYd8/5vPDJKAp9Fwa/WsmL2Lg4dByaVulDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GGQFvtHLIwTBlQiadsA9+ibRM9vBLOhfh/ds/dCZkWaU4KYY5zE0IFSXW9wuCncpgdEGfuOdMhr8aXX0+Tl7HnIQWAf+fBbwZ3c7xFyWG5ig0nAESjHix+XZbubrL95lGuL+9+o0vXlWKlMCLGAZIsQZb2ZQ5DP/6PsrG9EipKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2400a0c3cf7so10197365ad.0;
        Wed, 06 Aug 2025 07:12:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754489554; x=1755094354;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WE4YZzPuzT5r+GbThf5d4JoKY9BzLmCL2oxBBVs6R7w=;
        b=wOS3GXl8E968dP5XQJzPx7482NSTwfLX99myYcmiJkgamFpwNzum8IfEWdhLw4LBEj
         BpGKFmoSFNlS0WpsmkeAoHkJNLAaXAj4Iz2IdIhkJ7rPo7V6YLumDdS9e+sQofMEUZWq
         AN41mhVdB7NNxNjQqjnR5Eu4yTaUs9np3H445uGUGZm2ODauVCNvByAcIRsE72YgWSvp
         ozc/KMOvonhyQyJChVfZ/jlguERNz19p5RxEYWD50g3mPY1NaoriecYXFOmXKm3fn5+5
         PZFWYXUVeRKhm3s/4y3pGUyt06DXcs9EV6I5ULuUaT2wn/tXsd/C7vxtOA7Yd+9WiowW
         /dsA==
X-Forwarded-Encrypted: i=1; AJvYcCV7j1nJ4FZLFvrnXMsl7gk6H1ylk7lqj/tgQDIniTRW52raZ2hoclnIGgVgUbxIOuE0jRl+BOVjUWAo4/bG@vger.kernel.org, AJvYcCWxtE+zw0GvgmZAJAmH2kH/FHJoaU3z0M1f1HuBQUz+keuAu3vIJUE3Q9mCm8xipd+v3lOKctU0UH6x@vger.kernel.org
X-Gm-Message-State: AOJu0YxlGZOvey31FxSNSx8xn4KQezX6jHBkqKMpVEPtFkyu80tccOHA
	Swo34QAORoq+Lt3wM8L8J8vyZk/K+1GXkRFkw3u3FsCuP+FVKESD/0gJ
X-Gm-Gg: ASbGnctIMIJjYGZmhdYNu9DgrEv57aMSXQvrMXnrOrW2/Jx1QvmNLoxpQKT4zpvXtOg
	6t4+zNPb0h62NHVQyIrn1u382Tub52TxaDhEqMBgWOzM2tpHahXPMR5gU0w8oMTd2sZJAGYxyw5
	eTmxxhwtBj9W0xShVBFuKkr3GQxSVqGMnlbZIqjb9Ccwx8KVmie+kkzlXLjYrEzeumBYKPK4qLA
	zJXaY9LOYQXRVclZeTED624Bv3hjdlWhCX6J6Um5KUilPEYsOkvOYCcxsbbEx/n4Zuo/aBPbV2Z
	Y6tNf4/GC9+7w2eR+neL5c4ypF589rujCPcH9oyiCqHN8iBhuxyf/oh3U3zfheI+I/iKSeMGICR
	5sUSerziyyds3lvOPz5CfdsHTzp3u15AUdcu0G5YL23U=
X-Google-Smtp-Source: AGHT+IFL8qrUxyDiGs1eBbFmxgUyJeO1pmJI1IFC+fqtCTB0nvRaKpWvapMPgtEKb+b7fbisuGIwmQ==
X-Received: by 2002:a17:902:da8d:b0:240:9ab5:4cae with SMTP id d9443c01a7336-2429ee76d21mr23515275ad.1.1754489553566;
        Wed, 06 Aug 2025 07:12:33 -0700 (PDT)
Received: from [192.168.50.136] ([118.32.98.101])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422bacbb74sm13617379a12.42.2025.08.06.07.12.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 07:12:33 -0700 (PDT)
Message-ID: <751a8c65-282f-4ed7-b09c-9f115f526134@kzalloc.com>
Date: Wed, 6 Aug 2025 23:12:28 +0900
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmbd: add kcov remote coverage support via ksmbd_conn
To: Stefan Metzmacher <metze@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, syzkaller@googlegroups.com,
 linux-kernel@vger.kernel.org, notselwyn@pwning.tech
References: <20250806135224.116724-2-ysk@kzalloc.com>
 <91f09266-b81e-4e28-95c3-4272096a0fca@samba.org>
Content-Language: en-US
From: Yunseong Kim <ysk@kzalloc.com>
Organization: kzalloc
In-Reply-To: <91f09266-b81e-4e28-95c3-4272096a0fca@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Stefan,

On 8/6/25 10:57 오후, Stefan Metzmacher wrote:
> Hi Yunseong,
> 
>> diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
>> index 3f04a2977ba8..21352f37384f 100644
>> --- a/fs/smb/server/connection.c
>> +++ b/fs/smb/server/connection.c
>> @@ -93,6 +93,9 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
>>       down_write(&conn_list_lock);
>>       list_add(&conn->conns_list, &conn_list);
>>       up_write(&conn_list_lock);
>> +
>> +    ksmbd_conn_set_kcov_handle(conn, kcov_common_handle());
>> +
>>       return conn;
>>   }
> 
> ...
> 
>> +
>> +static inline void ksmbd_conn_set_kcov_handle(struct ksmbd_conn *conn,
>> +                       const u64 kcov_handle)
>> +{
>> +#ifdef CONFIG_KCOV
>> +    conn->kcov_handle = kcov_common_handle();
>> +#endif
>> +}
> 
> The caller passes kcov_common_handle() as argument, which is not used
> but kcov_common_handle() is called again...
> 
> metze

You're right — this is definitely wrong. I'll fix it and send an updated
version. Thanks!


Best regards,
Yunseong Kim

