Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814C73BAD8F
	for <linux-cifs@vger.kernel.org>; Fri, 10 Apr 2026 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775838367; cv=pass; b=lBm8bITBSD+nIWsuhrC9Z2V++ZCs0N1lxwRIP0AvCQS6a2/AVvTMZx5ICxkYERl5CCCWnXQIkQADwa0ZrbWXSSX3pB0LqKHYQJdTnLdtqLwtaU/1fdW6OIGsHFKIDe8uNn4/5104q77XXCfHJ8/sBooJotMCtx/vQRbaWiRdgvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775838367; c=relaxed/simple;
	bh=lkzrT07a8/Qg46Fp9kKMFKI1f9fKUzYQJv/j5e0aJzU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l+lpFBRGhWEMYnTOxiOZf0zXwiitGZHCTsIzMwkhvszWUxizEyVbg4CYaP0y6m2EwLVZ2GkKwnCaPgBKVM4GvK2i/25WicOoJuOOdNZRB4llyU9d50Bu5BNteZJyZp/6N2ScFyU51GaNfFPrI2BBzy+3B1m0v26bX4SjR4craoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IVjK9sxt; arc=pass smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IVjK9sxt"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cd71fb9f06so134188485a.2
        for <linux-cifs@vger.kernel.org>; Fri, 10 Apr 2026 09:26:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775838365; cv=none;
        d=google.com; s=arc-20240605;
        b=ZynD9RrJB8AqlAAN5ZdSzjX4Bs+0yRJCIh7k2260WbGMJkCX5uSFt4/8Yi3vmtCpYg
         rWzkSx0JrZymmdVR8mE45PI4Q9tQoOzeg/H8eDI2Ngb6qVWH1+DS4LH+2Nhfzh+Rwrhn
         QcCWccR4WpvSpfcnr5yhFoj//BY7oLL/YfVlsaV/vVFofAlMkH3kM9d1yyI06OtTd5z6
         LyZHEbjhnn5XrOokmDfYunRITYr8coNsu0NRubrXOj+7qHQloofKmz34IoTaluFsSs7H
         H10RkjMOWL52jPRu/2lXdGthzEVvE16NYDRhfYpcdxMGgZtYfkek6hTMVL+1dobMmCj7
         7gvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y5zcGD70rMW3J3k9zmjVKV4kgX1S9eCtey5rqaqexSc=;
        fh=3tkfIilU2xDfke4UP895gocGMxYcdTKEzF9/FyxlmBc=;
        b=Hm21Zqq60ALgHtMFjppkCvQo3uUjrj5B2yeFUQdRwyK0jyDDUe9NH2hlYfWL2IxWk7
         KVYBNCN1BKJ1fAEAR1hiCkJ722eKOwSSCiiBjaVPddXdraW5vTS/V81O+qEI9dvO02tQ
         jn4G1M0EONGhmxAIsyOe15mcuIovebowvQmWoHtV4cKaXT9pp3x5hTr+1xSlHIG0lbON
         61Q9EqJsU51kaV2P3l22mqG8TBoJWql7JlyF8kpR8mXkU1TXLUVUXX9FH0LbX/svZWDX
         +UbfZ9u+TiqqJbgAXRYuJtq3/g5U0uyctDlrgsP+1HSJZOmx+WnYkPQOkRqmOf5WUkNU
         zYSg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775838365; x=1776443165; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y5zcGD70rMW3J3k9zmjVKV4kgX1S9eCtey5rqaqexSc=;
        b=IVjK9sxtrWP14IlVT7zCe/IP2faPYVVJvYN6ORWO9s6HIUX2ldnXXAafeEfLHQQZo/
         G7+7yXOykPOTIawj8aTWE2CdvRKn7a1jWekbsr7EFfg3E3QSEwLe6IniAQoDdgdPlN3+
         PLiZeCArrCslwmYegO3yaBzRYuTasSl0qqAKYkiGaFMFCFJEWuCYQ6HUGCysY+zlKoA7
         VyvglogGWwwDvnIica871uTxPyWk9+XXkAtgp86riAIxDMzpvwVPUVmrLBb2a0V0MfUs
         r0jP/iB8aS295YR+LqGK3fuMsDCeJzMhCFkqTyaD0URRZ3KYe04CQF6fhLZFO8S7uWpO
         OORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775838365; x=1776443165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y5zcGD70rMW3J3k9zmjVKV4kgX1S9eCtey5rqaqexSc=;
        b=bJATAbrydtzaeLBvmZi7zluWaC4H7YRpfkT4golxYNZfx9K8tNkF4ApBSFQiSURGcs
         X/4FCl0E4gQ/jDWt8Ts7wed9EhyQoLcujhuWoFnjjQdl0ZSzOpV8HSOap+xyox+Ql2Ub
         WDDvDsM6eTGFjp8c8o2LBRfOQNFe6Hck1yL1MARDAd6uDoaCIa5bxeEz76BVo3OiJJdp
         ino5ral5lmAb3wxoVcmKXSNyrsfJWPiPQ71Cy7haX2zRe6+DMdOTgMAL7JS2pHP5lNOb
         irR0Bf1ZSWdqPjmxY45SI8pTVyFXh8t9x2awlmGu3TDNK3EMzVmif0JEf0e4FCcE2or9
         zBEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmEphF4smq5tRQZ9+1Df5E1uTeovszbAkBONblrjyN5Bfl7E5zwcFmK8De08LkOdEm1lEg+whHY7sb@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2B9PBMsqzGBhjgs2KqsJ7XyADto5pj71zkanhP/wccSgjGglr
	OeDBCFxh4n7k1yWRUZK9NXxG3T5OMTwsNbUvQ+tDw/GTEpXwAauKFJiH25OjAPe7LP/DNMH4v00
	RqYtRnjDOKu70DARDyONNRMH29sa02jM=
X-Gm-Gg: AeBDieuH2ZLwUTS6+6O1uiKWfTDoimVdxooMsgxi7bHVF1D/DRlyJ9IIHkBK8joR/LZ
	KvFsoT57tFyRVEE3Cvz5jBYAZznfplG915BvArhKWYGjuvW5HcULbidhopyS7yFimfs1oGA/t25
	BL/qzCnz0iMC8KcHdUzKmu2T8FqLaByr0gdheBZfY/4OEqpbraUOp0++zwYR3S/yX8k0Syk2bWw
	AHDSh12I0YmmJ86fUiXgEeTn4TkW4813meWk0yBgW1hzojiwwDufb3UZXlmVmZD1PW880QUrxxJ
	or9CQMHcZ9rwW64ExpKjBlNnZ8x2jl+w+mbXbW9/xcc3wgQcwOepkvdLot98YfhO3zRcjJtrup9
	LhX30xoAVHrWWxlWEzjuYN13X8gH2FQja7/BENd3diwBDPB91TY3yqJaoVRv/QvuLFNfxItJlNt
	gaDUbjkGsKwFVkr22f136A0miTtzjp+MPB
X-Received: by 2002:a0c:e017:0:b0:89c:4d3e:fa41 with SMTP id
 6a1803df08f44-8ac860e881bmr47833156d6.12.1775838365363; Fri, 10 Apr 2026
 09:26:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410150247.93178-2-venkat88@linux.ibm.com> <f2beb294-1fa3-4370-906b-570616fc4b88@chenxiaosong.com>
In-Reply-To: <f2beb294-1fa3-4370-906b-570616fc4b88@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 10 Apr 2026 11:25:52 -0500
X-Gm-Features: AQROBzBcRk3OMNIRbgJ331ZgxpUFolQQJGCjrJObqeA8QNkoUhRYo8deNTlG2-g
Message-ID: <CAH2r5mup=BpCfa9sr8Q+0qVswTBXcbCHs_sCD0JwfL=XHSuApA@mail.gmail.com>
Subject: Re: [PATCH v3] smb: client: add missing MODULE_DESCRIPTION() to smb1maperror_test
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>, sfrench@samba.org, pc@manguebit.org, 
	skb99@linux.ibm.com, maddy@linux.ibm.com, linux-cifs@vger.kernel.org, 
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added to cifs-2.6.git for-next

On Fri, Apr 10, 2026 at 10:59=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Looks good to me. Feel free to add:
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> On 4/10/26 23:02, Venkat Rao Bagalkote wrote:
> > On the latest linux-next following modpost warning is reported:
> >
> >    WARNING: modpost: missing MODULE_DESCRIPTION() in
> >    fs/smb/client/smb1maperror_test.o
> >
> > Add MODULE_DESCRIPTION() to the test module to fix the warning.
> >
> > Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> > ---
> > Changes in v3:
> > - Update MODULE_DESCRIPTION as suggested in review
> >
> >   fs/smb/client/smb1maperror_test.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/smb/client/smb1maperror_test.c b/fs/smb/client/smb1mape=
rror_test.c
> > index 820c0dd3bcce..2caaf11228ef 100644
> > --- a/fs/smb/client/smb1maperror_test.c
> > +++ b/fs/smb/client/smb1maperror_test.c
> > @@ -74,3 +74,4 @@ static struct kunit_suite maperror_suite =3D {
> >   kunit_test_suite(maperror_suite);
> >
> >   MODULE_LICENSE("GPL");
> > +MODULE_DESCRIPTION("KUnit tests of SMB1 maperror");
>
> --
> ChenXiaoSong <chenxiaosong@kylinos.cn>
> Chinese Homepage: chenxiaosong.com
> English Homepage: chenxiaosong.com/en
>
>


--=20
Thanks,

Steve
