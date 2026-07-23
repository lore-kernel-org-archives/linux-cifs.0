Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E167841A4E4
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 20:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784838482; cv=pass; b=lc2lnogNVeDTrprMcBtYTbAFEYdv3ZOr1n4714VNaJQeuHCaWtJMrhpCMEMo+yE/WMoDgAeAaizHWJEXGBOwLZuW1HfSHiHYM9FB769i6RkaxuHM0YhI7t0obcrdERTNrpcfnlOpbeHGmE9tTFaU+sVSVdc5qD2EIM5pTf0DeC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784838482; c=relaxed/simple;
	bh=kb3KxBMHHxCZZ076s3J6OaSh/aa08vKVEphPTeMXBeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GqqxfVK3fNTT9TGe2BQCG0mp6JDz7pN9DPlhY+rwO+jjM+AcknRzo031T9BL2kSdKRzyvsL96fXQzU/Ph4ppENQQamsHullqmtpaHyWNH1EJeAnMjDnI85lZpYARi2QgmhIB+VqhS0N6f6VKnaTbgWf0ylZKMna9ZeAB5e6hQE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TzrqkJZq; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TzrqkJZq"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-9034b6b7674so11614936d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 13:27:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784838467; cv=none;
        d=google.com; s=arc-20260327;
        b=ShnzoZI5YJQCX62mhxQpwx0h8JlsPJS2exRpmZexRPo7VbXox6fHrJQ0V1GedCPOgs
         7L53rMghjZIUNh5rN0KQpLYBkyEsR4EX6YZ5znjlc4Om3SiJBfpqVRh4SyxCNn05Iai0
         ADtcnygIANVQuAZki74X2vZEexoN9uGgEEL1mw2LxoI5usZQIy9wVw74tbZG3/3L9u9A
         yl5FrjFQD+IxXnsk/WyBV/BKC2C9NinPImVuWz1LPoehLxFvD8zkCBAoja70IkD7fO6B
         koQ/y5t9ZBWio0jezxWcXHL10+GVbUyZSiY0Mw6UthtJZvDceKvQTAiWLcg9qspryzRD
         F2OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p/qIoU8Za5orhZcX78RRvB80P5yuArnqpPKEdRCSBmk=;
        fh=gwg4yiYv+t1m5aTa5A8n71jryNOjgfjdY7QFhCcDZMk=;
        b=Id+MyTyt6mEK4wHPsly6D/sEQPB3Uoctga3vZx9HKDpLhcf5KSnxiFqyAxU+1C8VNM
         1KuXQZLDhXQV8BstfCxKf22Yn+X/nHWtevNpHM08OPubnV9qq1Bp7Sejs1MC49Dji0he
         sZw0BPmUxrQ93a3x3yK4V8AX0fYUeUpXZ7hnzp5rW9A3n9lDASy/PC5lsmAmaZiA4S51
         HUM965u63soSoIvlqGzfOyWHFIL08Mu7v2Y6UKtMfdIbUqBR4ytM51A790n+2ZFqOMAc
         JRlnCzCA8kdgJXaSzkOPTq2pcDlXV31PWLecqUkUGSx2cVFzI+MRju0kNlT4NfaVg6rh
         NJ2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784838467; x=1785443267; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p/qIoU8Za5orhZcX78RRvB80P5yuArnqpPKEdRCSBmk=;
        b=TzrqkJZqPai1d2iinqx/OsPRUlS9pV4WjB7p0gkpi5UE6pyKTOgVwOuY2ErWMe/t+t
         i23HvDBkCR4y0GNiNeWzoPZwC/L4WmD4+vQx5fFkzdf0qE2VQBgAnHA4unVbjBF3UgOO
         h8yoCyVTrbSdx/TMe840y7u499O9Nx32/6nnh0B6GzZ/v+hzDBCGAv7mL39FMDzomlyw
         KENdyVNklxdM/TLH6WdFSt/6BWDk5TtyivQMXyFHMK/LMDZ5QHE7xDXGWTfVxU61kXH5
         UT9giRMmHGt1IYNnkWkAUyLBRO9ug7qkvQmccTHoGbPulby5whXeyrWjmcOEqerdtZAk
         qJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784838467; x=1785443267;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p/qIoU8Za5orhZcX78RRvB80P5yuArnqpPKEdRCSBmk=;
        b=WgW02woJXHHMdzB5QUHu2ljw9M36eOfdPOwVlf+QJ2fIYxT85kHp/ZbXt78ioiGWPL
         nVg/edOzCxXPLSmMogU6EMsnXcv8xKYAgoW2L7w2UzgZUssYZ4+2V8yclsbfakDyjWdR
         DIM1wP6+5tnsA8ZqSXgCVBm7J4DwwrVaIU3LBkmnx3XyZamfxWH/4AgAuGlW/j3AJRfq
         4hMgP7bqsx7cujBOGTwFzTaEc9ifhgB4wi+FQaW4+sjrIRi3QzOU/JuEdhWdCHTpxoPm
         +g/fRS0qWUkJmIT4DW9cHVA7nWXAVQMFPtis5oOK5zs0zGkXZT8ZjnysfsiA5L0xDWNI
         phHA==
X-Forwarded-Encrypted: i=1; AHgh+Rq08XU984d/T4xGkLoozxet3GXOgR7E/1w25hmAWk7vTjy/+KBrKVnq9NaKJqCulGV+ktVnitEzO/pu@vger.kernel.org
X-Gm-Message-State: AOJu0YwvIqVgisMIXQlYBj2zPLUkc7XOhBvrF/iMfnI+hXryTrcuhQgW
	oDh5UZVIHFR9oqT6cUQ12GUGDWAIRW9tCyUynZ7Nhj5MEBEz4xO8lNms6MmBAbxudd6bkYEu7zI
	fRS1uRtxEOjEpXchDuP50mCB0c03SM9g=
X-Gm-Gg: AR+sD13e1HXyJKao5riI85m6CSBcvmbH+XDK7tUr2ivIep0QGr1ay1SQmXOe+qLHUt3
	JzN3HyLa+tQm5R/MRPLTwMdzp0e37e+Abcpi3d1qhNq87X1qqugxl2bn/UXyrmzLNLYbvKISlkM
	PUh1g/FetOCBEAX/cRnisOBDLHgyGu/E2Icp/FcYcu8KVpA5P+b5Saor+nUN89IwyVxWdQxFuCo
	7EFKkNSq/VY4Gck2WdV/BMGNp24cIYM0OpLxpsRn0+rhuIwdKhwWs9mCzs4GoUEXRMBY3q5Co5v
	2QtP8s+Rw1dOjoa9C8I0Ieb8GSADVnmDP9eZIyNn0511Rxdv+gWRkMHzEsCym6W3ihH7+jz+VEI
	q5CCRo7NB9NFfOXBzjwk0XLsr6v99kbjoM3hl6fWDXGQKyxsPEwS608HAGPV2bMLpisq9g8zrsm
	A=
X-Received: by 2002:a05:6214:1309:b0:8e7:8d53:2417 with SMTP id
 6a1803df08f44-907ca58b1d4mr58955846d6.27.1784838466656; Thu, 23 Jul 2026
 13:27:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723184538.3888637-1-ekffu200098@gmail.com> <20260723184538.3888637-35-ekffu200098@gmail.com>
In-Reply-To: <20260723184538.3888637-35-ekffu200098@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 23 Jul 2026 15:27:35 -0500
X-Gm-Features: AUfX_mxnuBmU386xHCrO9KVt4FbuF22Bv2uMtB3Rok005YRa9Pud7LorDFd8BFc
Message-ID: <CAH2r5muT20HXUANLnXQc1dAAvs+N=jFneSsV9gUqS8GE-wWNPQ@mail.gmail.com>
Subject: Re: [PATCH 34/36] smb: client: remove conditional return with no effect
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Julia.Lawall@inria.fr, Steve French <sfrench@samba.org>, cocci@inria.fr, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, samba-technical@lists.samba.org, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You can add my Reviewed-by if it is not going through my tree.

Which tree do you want this changeset to go through?

On Thu, Jul 23, 2026 at 2:04=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail.c=
om> wrote:
>
> Both branches of the check return the same value, so the check has
> no effect. Remove it and return the value directly.
>
> This is the result of running the Coccinelle script from
> scripts/coccinelle/misc/cond_return_no_effect.cocci.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  fs/smb/client/smb1maperror.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
> index ab3d09613c91..395299f9121b 100644
> --- a/fs/smb/client/smb1maperror.c
> +++ b/fs/smb/client/smb1maperror.c
> @@ -234,11 +234,7 @@ int __init smb1_init_maperror(void)
>         if (rc)
>                 return rc;
>
> -       rc =3D mapping_table_ERRSRV_is_sorted();
> -       if (rc)
> -               return rc;
> -
> -       return rc;
> +       return mapping_table_ERRSRV_is_sorted();
>  }
>
>  #if IS_ENABLED(CONFIG_SMB1_KUNIT_TESTS)
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
