Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE8B244691;
	Wed,  6 Aug 2025 13:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754485920; cv=none; b=GfxMpVnMphBlI+9AhjM9xoGQ57WNTGMRhlSzj0w/Pehu2dfqzCyG+fptqZXlTOXkNr2kcGfT9ZtErcb6vINxbHDvIdTceDXJ1czGCGDQUPdmXVpFrQl+LsK+eG+tRmleEGjhkukOFLBC3D8GpTSIsC/sJvFz0Ev833rWS2TYN8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754485920; c=relaxed/simple;
	bh=up6HznFRCo4Kwue6phlQROxxqBLCthAji6XRDD7kZc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V5aGyxxM4NYPr891Mj/7eqKtMhrF8TNp/7ad1qFIFDyUU/vWE/PwBaHNXYUNSULCua2AJ1Mt5CdUGjCAPMCVE76kkHGhuKAFGwnZq7q1688nVC2Om5usYQ1+r0IqljJxcbJX3nPCvzDbilC6zp3q1Kcb3AzL7Yb6YmmGwyVAqMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-24049e42f37so6052135ad.2;
        Wed, 06 Aug 2025 06:11:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754485918; x=1755090718;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pyO3bEIx87RK0J8Y5zDIpZVaRTgChtksd99Tn6a74Mc=;
        b=SM4LVfPFit7ezyZPZHhFqV0thcNVabuqoOAusKSKsH02Tw02xqFDrhxPHpXPAciiNy
         SWAtRKO/7qJ5zIJzkh2yQFE0MLDzQjeysd4df9Rp2q/hYbchzzgu8djYqxEneu1NY9iR
         L/iU+/S4vx3PsHERPgvVsQVHofn6NktOeO/O5tXbgiwEPGiKv4sKXzKNtes3NsEgaoYs
         MmpPcLzU72fqaBc2Si14IybFjlcEjAhD1f6U/O7j71pOb+AurKjZbV8i/sO+zqI3/wis
         wyLqfZhFQTAbjZqF+foV+0vKD60fNX4KLm1ZS3wNFi7gmD8qCQzgFTsvQcP2B0OhjTPr
         okLA==
X-Forwarded-Encrypted: i=1; AJvYcCXNr9UIIRx37lcNBBxk2ryFCxiQdMxH1DLUY6iMGsb1FEVD7Lhz8IKqlGL6Sf79fgqAQmJzphOdFlka@vger.kernel.org, AJvYcCXxgYpxzvb/I1X02Mt7JZFaiswdRxUSswG2DPPjgmIDVHCX9p/lsIS6vbVx5CpHHMgmNDOqFv8YnOne/Rie@vger.kernel.org
X-Gm-Message-State: AOJu0YwV1vOuBrJ6oaXS7Ur7ivtkOebA2AUC5036ZL4kDrAbNVWMlAHz
	wxFcUQPrwRh8gkhhzCrVYI+bUyUME1IetwHVRicbTL5FjpeE+9lrw5sF
X-Gm-Gg: ASbGncuCAYW+6oJxqEG7f9MwvOtesA1HrUNT1rzVivfDJf0KeKsEvIhOR4yv5GrXfY9
	jcrU5O5Q3YLvT86gqSHR3PDQx+yErR/RkPTJkvhzEMJnXuoTFn3cmKOlxRky/BYlDCb5I9a6jXM
	Xe02wjxyAIyrob0c9sS5PTs8vXT0wqmw2C2rNmWZbU7fnnxYRdY3K/CXo96yg9zIVBnzeqEiLvs
	M6lvnohk/ixwY+oEQ/Oduds9wopsVReUDdqAUhIT4w289FRf9/0PIkqVofBJl0iidBHxxilsrsK
	82IkswIB+EdWvZ+s/eTBt2404iDAUD4qI8lNIwmaKKDSNi076wQebCW7ca/6KZQDycLiHw5/2Ip
	WvmBBehuQz7ID8SNGO6n+58FK/pKo/eGoeQ599TfFcho=
X-Google-Smtp-Source: AGHT+IFSqw8CaSRoNU335WEu5gn+pCRxtQcb4ASN0QjLJMqlu5hcoW8AY/KvD+4w4PhQ8l7o6U1qpw==
X-Received: by 2002:a17:902:db08:b0:234:bfcb:5c0a with SMTP id d9443c01a7336-2429f47b92fmr17984715ad.5.1754485917472;
        Wed, 06 Aug 2025 06:11:57 -0700 (PDT)
Received: from [192.168.50.136] ([118.32.98.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm157686225ad.23.2025.08.06.06.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 06:11:57 -0700 (PDT)
Message-ID: <e99617c4-2481-4cae-a80c-2f55e41506dd@kzalloc.com>
Date: Wed, 6 Aug 2025 22:11:52 +0900
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: add kcov remote coverage support via ksmbd_conn
To: Stefan Metzmacher <metze@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, linux-cifs@vger.kernel.org, syzkaller@googlegroups.com,
 linux-kernel@vger.kernel.org, notselwyn@pwning.tech
References: <20250805155627.1605911-2-ysk@kzalloc.com>
 <d12e1d6a-d9e8-4bb3-abe4-9bcef1cb8f77@samba.org>
Content-Language: en-US
From: Yunseong Kim <ysk@kzalloc.com>
Organization: kzalloc
In-Reply-To: <d12e1d6a-d9e8-4bb3-abe4-9bcef1cb8f77@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Stefan,

Thank you for the code review!

On 8/6/25 9:14 오후, Stefan Metzmacher wrote:
> Hi Yunseong,

> conn->kcov_handle is a new element in ksmbd_conn
> and I can't find the place in this patch where it is initialized...
> 
> metze

Thanks for pointing out that important part — I absolutely missed it!
I’ll add initialization of the conn->kcov_handle in ksmbd_conn_alloc().

Best regards,
Yunseong Kim
