Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792795001;
	b=sSJr1RqJf3iKGpiYCaZfF/mNnf8+LHPjIxExg5VJ0aTrO61j/rOuLQXJxl+2w1bAmrV1
	 QUNjcEgBEXruc0g/0AJSeQO6fvvA2KFrrdZH02/mhwR88uPI0bg7YP3WzMvz3exVhb4rw
	 10voQ/BQP9z8NZBO8Z1ge74RAGIvroM0+F9ICFJoy8R2g1UQNdtcSwqFzQmgxorooke+0
	 NdgD39ll1KY3XpYnNCOp36Z4gKSRuEclkNuMcNYKIq5rYUrtR4L0oCtvUANUntw8qrhYB
	 GwcCMKqRc/NV37iLz1rQciWnGLVGiqMhJlEmU5B8q0TcJ2LqnUhv1n1HVg+7HCVc5qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792795001;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Content-Type:Mime-Version:Subject:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=9pwIcKu4aSwnkYlBuvUY0kGHyvfnSG4BNtsy/wzFuq8=;
	b=WK96LTzbmxrvx8MO19YoSZPHdWC5UBhJg69+iApxoFarS3p4ELLJsFj/We52Y2TkZ6Q9
	 8GBVIx1BxxwscXUn8NEQQWbguUQ6SzLkZlOxBZrOnL0gVMjpNsD4/ugUNUp5k5W09ftIT
	 nakb2xI5qU9PElFLkXM7HqMGS8fv7eUYFhpBi8TsDG+l6pZ0fdtOHEZ/JsKOdmPW1csDL
	 M+S9pY2nngxIYq4pupDWp01RmF/fmieU2ON6ypi6RHNE3nSTC1Zicoh+Wrttpuh2VRukT
	 0GMRxJdw/4hMMpYkYX+tBTy9aw7fUhUcztbshy3fQqysnCpIcbkfFFLuNhAd3K/gJCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="PTYBP/jW";
	arc=none smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC100606A31A
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 22:36:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC100606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PTYBP/jW
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so1800808a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 15:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792794999; x=1793399799; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9pwIcKu4aSwnkYlBuvUY0kGHyvfnSG4BNtsy/wzFuq8=;
        b=PTYBP/jWNIEwRh+eq7M6o9qdhj73e+lP8hTsSSxt1Mwlhm0PWDjIkubYJ6IBTRpuTa
         n5b0UStjeZJ6n3OmdmYBSzEQLfFYt9UKX4a80M3kmBVAo5+Qavjr+DPB1RQD+RdSgVQZ
         /dcXXh+4mZL5gn01Wy631viRrh2cNsQ5DGDo9gkfEfA/rSd4uk0Gg6fkcX3NStRWpWC6
         R8aqNbI6p/3yxsnx0KLaG1lL+XYkx24H2PPK6gHzat8MYcVr0Vq0QsVUmbWHDVbeFVBp
         EP7QofxhQnravAYozbIj7OF8J+qVqKjo8z6kV3NUBKIWPjc3QfGTwZol8sjai3ySFKM+
         I31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792794999; x=1793399799;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9pwIcKu4aSwnkYlBuvUY0kGHyvfnSG4BNtsy/wzFuq8=;
        b=onMJkweVRULtFdWI1OJfmEVFrrU1yWJZNC+BeWqyMQYS7a9bVJZ2Aos1cosoLytzz1
         T9uYVEJfq/SOhVuv26m1I/O6GQ9DbJTs0V0uRf3B+q8m1pDf9dSAD+Gb/8d7iD+X0mzk
         P760yxZmXchUc0TsxH1oZ5PElerKjH4t+4xDDsSjULOwktiFvPVKua96u3SQbqptV4rY
         cRDHbQKlAYvR1SRd53ylScfcEnf/XThaPmCtu3d/YocJ/pJZmqP0IvHcEszrUT47Z/wm
         fbSddWatX08h7epDyRkulDPMEERXE5DqFlRVehaSkRD/5mjSI9ItCzVeT6khoZthiJqo
         M+SA==
X-Forwarded-Encrypted: i=1; AKwUvBwNUTgeGJk89/dK9AlAdcM4PJwVZ3vFGiW5IxIyjDFFGwsfMPelxsWWn+lZUmBUQBGxf/Gicc9E8iSR@vger.kernel.org
X-Gm-Message-State: AFq9FYJuKsKkh9gqzPhoS/q4J6ksrmb8iqn64df2J4OyM1wAZ7CY25dH
	O5waUFSVjBClnhDcYa0VbGbAE8+Q2IojH5djOFeUFmEPPN2VSWcFk+9CZQV7hVEfT/Y=
X-Gm-Gg: AYBFou1Y8pT3/kbYF3MPqYmRWrqKjzFN5i0OCOlaDGO94Qprbq3SbYhaHb8Opbt42pA
	whD4mLYE3Q+WxYLkKWQdqv63ZFmd67TPWTzc8ETv3x3KLM6/yDJLeBOrhSTEYftrn3Y++589vnF
	Z1dM6SL+YXbeVyS7TZtAETeH0NRGmVJw3jg7f8rYdlY9U6P4VzvF3ymu2IfmdGrxNVCCBTN5WFk
	kE/pLnbeM0y2SVVhQiCLsV6UOBFPrgfE+0hkGiBOa41mBBY2I+YWCVW1xgp/JsJ2llovooLR36h
	gv9YN5ZMSFgOpsBeHtpPT3+QCPF8fp5JQftaWNbH41ZrkxE8c8iSnkX+sYXjjqGhAcDNoaeU8XJ
	HWek584kREMeebxCZXhljZ8qSab2bR3QuC/68JW/aIQRcgHyV2keUwrZvvKwZTbmOcUEQcagyeX
	F/kb7ueN0+cvWnAtLfnqwT5ZRo6xnAuFhod/janFjbOLzKscsowMarc9ggBMOYIpajziOPpYHNA
	mFAq98RQDkR+MKln/90ssxxU9KWyDVjkoaDpLtvoGeb4ieUgP/GpXs75S7moxitUhhzJ+3BeY+4
	k5ela1Y1pGt/JIwbeE0f82RC3eW9zP/2xshe5sX2awuUA9Qs/7rWfgn14xyaEwwBaZ5RJidPlhR
	nRGSs
X-Received: by 2002:a05:6402:2022:b0:6b1:a509:875 with SMTP id 4fb4d7f45d1cf-6b442fd86bfmr508842a12.20.1792794999094;
        Fri, 23 Oct 2026 15:36:39 -0700 (PDT)
Received: from smtpclient.apple (ip-80-113-117-72.ip.prioritytelecom.net. [80.113.117.72])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b44595d5e8sm128607a12.6.2026.10.23.15.36.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Oct 2026 15:36:38 -0700 (PDT)
From: mixalhs <mike.michalo@gmail.com>
X-Google-Original-From: mixalhs <Mike.michalo@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: ksmbd: AES-GMAC signing support?
In-Reply-To: <47ec7610-9013-4c4b-ae37-f6d88556e59a@talpey.com>
Date: Sat, 24 Oct 2026 00:36:27 +0200
Cc: Enzo Matsumiya <ematsumiya@suse.de>,
 Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <F6CE78FA-AA06-4F00-BAE0-80B0819CE6DE@gmail.com>
References: <20261023174821.17552-1-mike.michalo@gmail.com>
 <atugaviJxR8nzHQO@suse.de> <47ec7610-9013-4c4b-ae37-f6d88556e59a@talpey.com>
To: Tom Talpey <tom@talpey.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Hi Enzo, Tom,

On Fri, Oct 23, 2026, Enzo Matsumiya wrote:
> I did this 4 years ago for cifs:
>
> https://github.com/smfrench/smb3-kernel/commits/aes-gmac-v3/
> ...
> Feel free to use that code as a reference for your implementation.

Thanks, that's very helpful, and thanks for the quick replies. ksmbd
already sets up gcm(aes) AEAD transforms for encryption, so the server
side should be able to reuse most of that. Your branch will save me a
lot of time, and I'll credit you wherever I build on it.

On Fri, Oct 23, 2026, Tom Talpey wrote:
> refreshing the numbers for Linux (especially on ARM64) should be part
> of the discussion.

Agreed. I'll measure GMAC against CMAC signing on x86_64 and arm64 and
include the numbers with the patches, which as mentioned will be after
mid-November. Finally have a use for my arm64 machine hehe.

Thanks to you both!

Michalis
