Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5016C433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 01:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A87A56108B
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 01:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236789AbhEUBaD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 May 2021 21:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbhEUBaC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 May 2021 21:30:02 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334A4C061574;
        Thu, 20 May 2021 18:28:40 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id x13so9570145vsh.1;
        Thu, 20 May 2021 18:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=97uUvQf/kruW4XOW9od67M7kOn5xNQoDiEEiK0vOinw=;
        b=POVNdCCKfImDGbGVFRcnvqrktuKJIvEhOPVibfyx2I0/wQVLCnIWbeIYowLWJecJPY
         S/5UQ+USK2wNoy4KVuoxq7SJQE22lBOG8yjdA68853HLqr6SF7if2m5B4dHj9WZEPG/v
         uhEib4gZ2TwdgzKOf7gC8x+1yABRnLwAy0WHmMkUtFZOqXici71UjCx8K2keox/tFcMz
         4k6r/P3wyNlMBS0pXcdUjvCaXC9xHex/aoE7jTgjpoHacNkBnZ4bbiKTxbwHOxgXhGWN
         nF+b2f9GgapSyIm4r3cPgEalAHie66NSZeX643tikM68lX6ebwp4rLaNU9e9aITaReO7
         3Zzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=97uUvQf/kruW4XOW9od67M7kOn5xNQoDiEEiK0vOinw=;
        b=cZdDO9kQcVnxLFnqiYST5kbmEybE5wg1I0MriyZJKp8W48Bc11JZYGcR12moJdDU4R
         koltekCN61j7HuVOItfQWH84B4N/04u0ASrZTXjbR1KaD6wBeNYT0cBPDvnMept6Q5Zg
         xH4HuSdAYOAxJ3IUrwDjF21hQjuW+TDebqo6oszNxhHCvTiFbKKwd1fE+ThKYPfC5w5H
         J8fQIl5rkxaJlapPFpSuIgOZ9luDZjzdV5kgwmBSX3wp4i0w7PaOnOCtD/nwcfRCG5yu
         1w7sE1P1omCtonInEJl4hXJR6Z9UMNEbqTSRSyUdlKnJlz+ZJUPukgYWqQls4PG8olpk
         WGew==
X-Gm-Message-State: AOAM5337DjOgTy4CNt00Op75+whl0RgO6A7C4+R1aKMcHfGarH8oTkvK
        XFKDgc2ZZxePPzvV/hlS9EQ/iFOy4E9X5eLv7JQ=
X-Google-Smtp-Source: ABdhPJyox2Eb/97LTucFVmmrUIV4StiM1VXvxKb9hRfowDiRCxTyRbfDNREqd71FbvX1yH2vIhLKLFoDxR7TuAGSchc=
X-Received: by 2002:a05:6102:2431:: with SMTP id l17mr7236625vsi.45.1621560519230;
 Thu, 20 May 2021 18:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210520133301epcas1p325b7d973e4febb2e9832051462585213@epcas1p3.samsung.com>
 <20210520134211.1667806-1-weiyongjun1@huawei.com> <002501d74ddc$27b5d1d0$77217570$@samsung.com>
In-Reply-To: <002501d74ddc$27b5d1d0$77217570$@samsung.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Fri, 21 May 2021 10:28:27 +0900
Message-ID: <CANFS6bbRjsc4ni+_SYasU6h2yTxQTdtv3b3i7z+=GN3CLN=maQ@mail.gmail.com>
Subject: Re: [PATCH -next] cifsd: fix build error without CONFIG_OID_REGISTRY
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        linux-cifsd-devel <linux-cifsd-devel@lists.sourceforge.net>,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 5=EC=9B=94 21=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 9:56, N=
amjae Jeon <namjae.jeon@samsung.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> > Fix build error when CONFIG_OID_REGISTRY is not set:
> >
> > mips-linux-gnu-ld: fs/cifsd/asn1.o: in function `gssapi_this_mech':
> > asn1.c:(.text+0xaa0): undefined reference to `sprint_oid'
> > mips-linux-gnu-ld: fs/cifsd/asn1.o: in function `neg_token_init_mech_ty=
pe':
> > asn1.c:(.text+0xbec): undefined reference to `sprint_oid'
> >
> > Fixes: fad4161b5cd0 ("cifsd: decoding gss token using lib/asn1_decoder.=
c")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> I will apply it. Thanks for your patch!
>
> Hyunchul, You also need to add this change to your cifs patch.
>

Okay, I will apply this.

Thanks,
Hyunchul

> > ---
> >  fs/cifsd/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/cifsd/Kconfig b/fs/cifsd/Kconfig index 5316b1035fbe..e6=
448b04f46e 100644
> > --- a/fs/cifsd/Kconfig
> > +++ b/fs/cifsd/Kconfig
> > @@ -18,6 +18,7 @@ config SMB_SERVER
> >       select CRYPTO_CCM
> >       select CRYPTO_GCM
> >       select ASN1
> > +     select OID_REGISTRY
> >       default n
> >       help
> >         Choose Y here if you want to allow SMB3 compliant clients
>
>
