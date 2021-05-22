Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F877C2B9F2
	for <linux-cifs@archiver.kernel.org>; Sat, 22 May 2021 14:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57EE361175
	for <linux-cifs@archiver.kernel.org>; Sat, 22 May 2021 14:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhEVOTK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 May 2021 10:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhEVOTJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 May 2021 10:19:09 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3628C061574;
        Sat, 22 May 2021 07:17:43 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id n1so10427904vsr.10;
        Sat, 22 May 2021 07:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xSWtMOuMI8vQMB1oMZWkSTJ4xXWh7+CmKEGeISezsYQ=;
        b=M9WMdO0l7xJvZTrvqFEAttagrcId4kIInnxYyLNkn0Fx4CBajAOWYWfkpTXVMvE9Um
         xnjRoZ2dhH4CJMeifnOOpqc6/hlbGoxXPNvWAeKeMzN9FISYRtiHv3RL/lrfOk5ri+SI
         Of/qUL9+eEg3MXFjYqJRiAHv1ukhB1rtI9HEOO1u54SIRlY7fPNK050ZNxvjVnGalJ0O
         fUsnyoJGZEyFrVm+pwpPZY7xmhu2kVVymH0qh8YBDxdkFAxuU5a1eCeCh1iDbDOO1C0A
         o3HbLN60t4DiQOD5dlx/K8pmXEv4lOm5IxnyobNRH53RoAHs+Cf0h0vC2LBQcSZ+t+ce
         vRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xSWtMOuMI8vQMB1oMZWkSTJ4xXWh7+CmKEGeISezsYQ=;
        b=kua5FGnxwC/XGcHRZEaDkKNG1VpXnGD+jMIYeUJtLKA4Z6DbXbGPyOp4SyqpgnwQWj
         OMffW1Fy5zXXC3YLkqIhV7dQbFuVs6uj9tCAwE8fxyaCgOQMxdkZTE2TiT8sCHlariIA
         kXWW8peXL4Bm82e4WyUleibKS+dgONQU0K8rBg3OxPuIcJodGxlG7xcSOvPuuS2MbQ9y
         eajmIYUqLmvA6jtN7pt0fYu4ibeCAzccjFLlZXp5ACs6yNjB40Oq+rHVNGaB8ctR+40M
         Wi/satgsK4+I0xKPdvRrlvo9Ao8C0zagdtErRaM41HtlMtmxx1k9dMfRqYIKXMXhSUeX
         vQFg==
X-Gm-Message-State: AOAM530sAYKz89Ej4E5ZM5DmeBD9lzf69QtRxgIBK2jYzpglt9uLI/wd
        laRYfMF2cJR48gjMGgg4ZgCg/VSEVit2li0yJUU=
X-Google-Smtp-Source: ABdhPJwWlsEn16IFgSd49ZQ6IoHaYRJBkGbYV8eEYt61GVVRAcx0AVj7DpHHblOmWqy3B3Rw/JRLlhtWz4/AL+4SYA4=
X-Received: by 2002:a05:6102:828:: with SMTP id k8mr15574282vsb.52.1621693062972;
 Sat, 22 May 2021 07:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210521020051.196434-1-hyc.lee@gmail.com> <87o8d4qxyi.fsf@suse.com>
In-Reply-To: <87o8d4qxyi.fsf@suse.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 22 May 2021 23:17:31 +0900
Message-ID: <CANFS6bb4AsWjkGCo+pKni_QSCF8M6vFvNiLs--K+2v=zOJ5T_A@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: decoding negTokenInit with generic ASN1 decoder
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <sfrench@samba.org>,
        David Howells <dhowells@redhat.com>, kernel-team@lge.com,
        Namjae Jeon <linkinjeon@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Aur=C3=A9lien,

2021=EB=85=84 5=EC=9B=94 21=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 5:43, A=
ur=C3=A9lien Aptel <aaptel@suse.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Hi Hyunchul,
>
> The existence of multiple ASN1 decoder has been a regular complaint,
> this looks nice. Have you tested it against any servers?
>

Yes, I have tested this patch against Windows 10, Samba 4.11.6, and cifsd.
If you have trouble,  you need to rebuild the kernel due to rebuilding
the OID registry.

> I think we need to make sure it works with Windows Server (including
> increased ones with the increased security flag, Steve do you remember
> the name of that flag?) and Samba at least.
>

If you let me know the option, I will try.

> There is the SDC EMEA plugfest coming up, might be a good time to try it
> out against other vendors as well.
>

Yes, but I am not gonna to attend the plugfest because of personal reasons.
Is there any other way to test this against other vendors?

Thanks,
Hyunchul

> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
