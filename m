Return-Path: <SRS0=SjeK=VW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A1FC76190
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Jul 2019 20:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49BAA218EA
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Jul 2019 20:35:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I/SbeOa8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfGYUfm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Jul 2019 16:35:42 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46743 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfGYUfl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Jul 2019 16:35:41 -0400
Received: by mail-lj1-f194.google.com with SMTP id v24so49371653ljg.13
        for <linux-cifs@vger.kernel.org>; Thu, 25 Jul 2019 13:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bZH1EfO+wp4ZZepYUwOn6w2UpQm5V1jccHCzgFCqyAE=;
        b=I/SbeOa8k5S8/M7sVSOen0A+TyTVCHMCzF/FbUKc5gXpS83cIUlnNWsABNgzRrohMV
         CNa1akp/y9X8N2IjtLMu+vRWp6d4g8sjcmYED3KjUV1gdaOsd9nB84co5NNH1Ios69bD
         ZrUosYNmc78JfRsXfA1C6FATWO9H7DP/hvuU6PruMXcOTF7eKaEBiLFdDvq8yOrPY+zC
         gojt5sSW9bmJFqwrvhTFFGM3ydrgIDkTs+LkVZdZNwoc7EI/DNt9k7EHw6jgjnIhJahl
         XMgxtMxx327dvT9YtwwPIUItWPOxjEa+L0Km/dvILnsPEmfGawo/Ygapg9Ur+8wMLKhJ
         o0og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bZH1EfO+wp4ZZepYUwOn6w2UpQm5V1jccHCzgFCqyAE=;
        b=kmOznuhb50fKnPc6BZBlm6KHFcchfZOatVmM3dy1cYY8aFloW2r5Vxi68nyhyHmmcq
         hxa6kPbUrQPRVHESe53nLKi2kOGjv1+WEjXQxFi+f7JWL34qssXXOy8iH1NEPRXTf3du
         BILQwQ/XxlgQ4F0GbvHyfo3+tDtCOYJPtniR6mm+Vtafn5CgVi+eFKbjvR9qrLbfLZi/
         QxgkojooM/Fn3V98TobuK7O1CHKz7s7EqDLaDU2UAiwtMCv6IXK/mTICa/gapkCNPp0d
         cWrIj8iqMt0mpQufVmd+5/G5zsqVB0oVqAcmDDPgZ1l0eFvsidM1KU7+uXT+zo6PWMwL
         YRGw==
X-Gm-Message-State: APjAAAUD55nCFZH9uP2Z8EdvgYHGnzRUGF7X7vpqgeSiELMypwfikf4I
        3HOiPQE48bZjyH/UKq38/c56AXN1j1qCr1I1ig==
X-Google-Smtp-Source: APXvYqyCpZoR6mH4jGliesmebXDKnBSJSvMH10sJOh78OipnpgT6Ur5RY8DiqAJhXEZzpNUZHov+Sw9DK9ImJ4hOv0w=
X-Received: by 2002:a2e:8945:: with SMTP id b5mr46051581ljk.93.1564086939506;
 Thu, 25 Jul 2019 13:35:39 -0700 (PDT)
MIME-Version: 1.0
References: <380e1b86-1911-b8a5-6b02-276b6d4be4fe@wallix.com>
In-Reply-To: <380e1b86-1911-b8a5-6b02-276b6d4be4fe@wallix.com>
From:   Pavel Shilovsky <pavel.shilovsky@gmail.com>
Date:   Thu, 25 Jul 2019 13:35:27 -0700
Message-ID: <CAKywueSO=choOsw6THnEnmN4UwhACHU1o1pJX8ypx0wjVTmiKQ@mail.gmail.com>
Subject: Re: PROBLEM: Kernel oops when mounting a encryptData CIFS share with CONFIG_DEBUG_VIRTUAL
To:     Sebastien Tisserant <stisserant@wallix.com>
Cc:     Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Cristian Popi <cpopi@wallix.com>,
        Cyrille Mucchietto <cmucchietto@wallix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 25 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 09:57, Sebastien T=
isserant via samba-technical
<samba-technical@lists.samba.org>:
...
>
> mount works without CONFIG_DEBUG_VIRTUAL
>
> If we don't set CONFIG_VMAP_STACK mount works with CONFIG_DEBUG_VIRTUAL
>
>
> We have the following (very quick and dirty) patch :
>
> Index: linux-4.19.60/fs/cifs/smb2ops.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-4.19.60.orig/fs/cifs/smb2ops.c
> +++ linux-4.19.60/fs/cifs/smb2ops.c
> @@ -2545,7 +2545,15 @@ fill_transform_hdr(struct smb2_transform
>  static inline void smb2_sg_set_buf(struct scatterlist *sg, const void *b=
uf,
>                     unsigned int buflen)
>  {
> -    sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
> +      void *addr;
> +      /*
> +       * VMAP_STACK (at least) puts stack into the vmalloc address space
> +      */
> +      if (is_vmalloc_addr(buf))
> +              addr =3D vmalloc_to_page(buf);
> +      else
> +              addr =3D virt_to_page(buf);
> +      sg_set_page(sg, addr, buflen, offset_in_page(buf));
>  }
>
>  /* Assumes the first rqst has a transform header as the first iov.
>
>

Thanks for reporting this. The patch looks good to me. Did you test
your scenario all together with it (not only mounting)?


Best regards,
Pavel Shilovskiy
