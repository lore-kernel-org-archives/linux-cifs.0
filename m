Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794334664;
	b=FQktHKZeVVF366LL7LpSx3ndqx06Ni6Oa1uRspuK6Acw+Rl/pphbgf8Oceqlq1FkWL+H
	 k2KMiuRjS8zNNXapOTu0l7JUq+vwsdS0j/qcay7QpEahI62X/n64s3l8Lpi92IQUw8sP8
	 ba9CB0x19iejAlxPyMMchQb82TxWi9sBM6yEQmDqQbTibMAVeC7+pQ2T1+ek/+9ETTth0
	 IjArZX7Rx2ymWvASCsoazG3yGz86y260cwdkXpGpYPci9BeA6abg+Go+c/84kWM9VgIb7
	 bCAIgzE4Yt4KwlKIpbcR/eZHp5tn0sWnUR9O7yvVUr4xxaF+o9daWHTm+flfPYVISQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794334664;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Content-Type:Mime-Version:Subject:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=sHccIo2W74JWJTwt1pWbxPtLRrMDVhYETC/mnvIlimI=;
	b=IqUmMSwZWqRRO2EOZI1u1ifok/A5lNJ7SGqgdS8x3pqwWn8v3+Azwg9YwsbSJGW4aNGN
	 XkG/16WLf29LYgIyliLODjopkTzdwoDmBV+WtTDN0Hk0/FOfcaJwBo/QZINqK+00iFIS/
	 55Qw5+8HgvKv1w9cZKxVNLAm4lotfel7du15uhyEcIVBVEU8smgaLqP9j8JcWrmaYxdhZ
	 FA3g0FDRuXrXYFr7ZLHMYUnOSb2y4IdZzPiW9FVx6TEJ19ZsI9vmjPm5e7gxfSYwisHQe
	 q2Un6mNGJNFGzg2jW5TwVqwIorYd3yyUgiEW2ENMrvjM/kAUrmfP9QShUSqoCOGf4fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="sFX/ml93";
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25483606A321
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 18:17:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25483606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sFX/ml93
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3b09a65c76dso1767908a91.1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 10:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794334663; x=1794939463; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sHccIo2W74JWJTwt1pWbxPtLRrMDVhYETC/mnvIlimI=;
        b=sFX/ml93fLvoZaK4uTWGjiIEIReJRrI/X+5sUtF6Nsvssif+axCDW2HmpI5wP1Mvnv
         z6RyxGfaB19WIs2ibfNZ0qhMrVtzP09wppil1+7rQWY0LMKsGSZDP9LLouFmGKXbd9D2
         rkk+rQ0LRX2RaMzQ/yhz2BC9lE2m+DaDPXv8WOOVrSxjqvozFR852LPyQsTkT0wVrIRh
         urcatdteP6o9YYwo5YpR/0tq2NUX75tPbYPsXdERvCkDearwX6dGLDW2mPGOYBjwItnN
         I5fS1tx/+93/1GqNHbfdpHv4o3zimEovvKPB09BckpmDuBclDEvD9CgD72lQFtN8oHb8
         mceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794334663; x=1794939463;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sHccIo2W74JWJTwt1pWbxPtLRrMDVhYETC/mnvIlimI=;
        b=CwrwNuuH29+SNZ1QaBelzSWhqu+0j4d+aYRVVIhE8hq9suGoidfk5UiewWimJRhgGv
         /jGWTPwPSQWMlpymC3X9JpzOjvA0hbDwMtxDo0+X6UfADRcx2+XLpAkaulzv/iSFONcZ
         5bo5AQBNAy3m0YoWXWifq1yPHP6dxTa+hIoKJ6VfuCsrzdx/bUGkMan4i2CRQ+fppZXF
         4jVqTr8dspmyIFAFh6z/ZounLVAn5VvJP+ZInUtzUTfwNRDbPNXTA3Dr4SzbTReVqh93
         xJako+tfRwnP7d5DldsQyucznSJB/qUVJABwHgtWDKvgdNJENPXvLWt2LuIOPEzlkiN1
         u/Cg==
X-Forwarded-Encrypted: i=1; AL+hErFKhPa31l0wmbeNGA8czdgjwoDm32GP/xU0a9tTevH7XGBVNJ1O4Ov5LlDDUrENa6NehAmJPtnsdO2V@vger.kernel.org
X-Gm-Message-State: APuU4Z8NV69ZNAKrLLBa5utJCTNc3flqJAiVS01XmaOY8eMKHv3n2N/j
	Xh4YkI5Mdg3oiAnqXEz1WAmmGQYwlz+M8VkA1oEPY5tqj4vOrWg56qvA
X-Gm-Gg: AYBFou3uWB+Z6BPG6pUXbTE41eSNGLyXqj69qKZSjEgE3Z19pLq6cQfmtqygKaEEHb5
	yFxVo5Zh4RS0bMnAY2N2JQEJQJ1pZQBI52sDpZJcgMbHg4BUyxuobL8JfAZSRN9Ymci7QVngJdV
	WntJbNSZvzHyRPaURnUl/ZcxwewtAHdXbnvQRuq8hVbsLoMqIPStIESjvmDRAcikvD+tj2eLdqM
	TPvC3hOox0hkc3QhOWOUNJMnZhtas1v7i34jWTknT3llgw3UoERvUvfwoUGqhTs0knM+sfln/7y
	4334fg5zfhQyHHoUuQPanyp4mU9I3bMRARAK5sP353Pg7UJRpUKs3+OBrLU9+cIf5EgjT5a44F1
	kKE2i24Iqc7eDfBXHg7c+eL/JmmCbBPh5ajUKL4qQQzrJCYIYKIoA/wCCOliFf+yNHNPj6yDALM
	sReapjmbxBvwvQco8127WG96tuXkbrylj13Lko/zk88H8ERy448EvTSjx0p/sB5UEIDmYf+L/dH
	Hvor2ixBPBNa+VA9IE3aH6BKYaPZiB0VBxaHPMxjrNUPZwZh0l229ZSyOE4fXR+ovrvZcOKOJXK
	dP1eHbAo85hoZT6i7FT7eHs806p+O3E/IdoV7TiAhypoaoy91u9P/RVPr3mR7FET1uGMEWRZpcX
	uVGI/ArjPzY5Nkt/rWHB0xJgA74alKz0V0I1Irx+AreZalrmJ
X-Received: by 2002:a17:90a:d887:b0:3ac:7556:8ee6 with SMTP id 98e67ed59e1d1-3b166cc02abmr3414334a91.16.1794334663437;
        Tue, 10 Nov 2026 10:17:43 -0800 (PST)
Received: from smtpclient.apple (mx-ll-183.88.2-201.dynamic.3bb.co.th. [183.88.2.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d4a329sm12243585ad.23.2026.11.10.10.17.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Nov 2026 10:17:43 -0800 (PST)
From: mixalhs <mike.michalo@gmail.com>
X-Google-Original-From: mixalhs <Mike.michalo@gmail.com>
Content-Type: text/plain;
	charset=utf-8
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v4 0/6] ksmbd: verify session setup requests before
 signing with their key
In-Reply-To: <20261110165834.28162-1-mike.michalo@gmail.com>
Date: Wed, 11 Nov 2026 01:17:24 +0700
Cc: icb@fastmail.org,
 senozhatsky@chromium.org,
 tom@talpey.com,
 chenxiaosong@chenxiaosong.com,
 ematsumiya@suse.de,
 lsahlber@redhat.com,
 hyc.lee@gmail.com,
 linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C5746055-5C40-4335-9A30-5522244EBA55@gmail.com>
References: <20261110165834.28162-1-mike.michalo@gmail.com>
To: linkinjeon@kernel.org,
 stfrench@microsoft.com
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Sashiko=E2=80=99s review has already pointed out some real bugs that =
will require a V5

I will fix them and send it, will spend extra time verifying everything =
but if there=20
Is any feedback for this version I would appreciate it.

Thanks,=20

Michails=
