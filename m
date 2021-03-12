Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA15C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Mar 2021 18:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DD5D64F56
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Mar 2021 18:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbhCLSBG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbhCLSAg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Mar 2021 13:00:36 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C765C061574
        for <linux-cifs@vger.kernel.org>; Fri, 12 Mar 2021 10:00:36 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id mj10so54988590ejb.5
        for <linux-cifs@vger.kernel.org>; Fri, 12 Mar 2021 10:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HCUOobbvndHs7hDtgG04W+jkNYEqOdipbudlYadOdL4=;
        b=Z8Khb2P4lvdz1tytMDn7N374DfEmoSE0BYqehAsc7FkbU0P2TDlMMbxDTGlNOwORzZ
         qoa5SivDLtHv1skEedhDpUqoi0NcJxXtkUk+YSDW/8Gt8KUC7KZ5dvYfsR+VufX7SPq3
         vlp0nWcUb8YQFMuWyYOBT8y2k3ZY8cGQr9mfsggLWGPqfWf9OYHRIXVoZMhmTQXmis/5
         XmFQUTvVRKA2CHva4lOLKeAz6A0VauKL3XDKeC1oF5RHzElUvDGYlLWC9zrhZt4DPD3X
         7oH3tur7XE75+j7vv0pEjEg26/HJgIM/YeiHmg75I8VuSCEF5xuj338jmKzDtBokKC0W
         CcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HCUOobbvndHs7hDtgG04W+jkNYEqOdipbudlYadOdL4=;
        b=ewJ4i9oo+NIKcDsh/OyiuJeViUGVXz7Zorr44ufLYfvxMbbWwZ1Fv0wqYBQChqdoMn
         ssm+v2jh1+pkDluUycBjjoxHkCAElgccwa+wi/usjDeITWO6WZGUrORvdMGbaoM6I+z+
         fOMBE8lKUYYoVs68RVVypv4766DGcuYPuR4r3udVNcMGJaPZ6A4ETe8jVgSilSON7kaZ
         68b+ZixBLCFIwVMTly5Px0VSvzgmP6ksE1QHYc++u0Xsy7G8y7XG3uH9l50V0+pau2Qh
         W7aJl+M1fEGzwXo47Cq/YHRzj5tkGp5A7rXbD6wSXRjBSeZuy5/9FX/cKIdyat8kWN0F
         MLRg==
X-Gm-Message-State: AOAM531F5cadeD8YR3y8XJF11RhAd5SIjQ7nEvH4VevIIZRtNw8LRfLJ
        TzIXzqauDekR5V6Hsy4SP0zNjM/sWKfzFrO8UAesRYk=
X-Google-Smtp-Source: ABdhPJwtx2YfDYqxy9DpJzhdFyr8VGNEkN3BV40kGkUY17FGc7fC3A1cc8bDFukB1f+WzcfLwz8gtjl83MgpAtC2Zzs=
X-Received: by 2002:a17:906:da0e:: with SMTP id fi14mr10237850ejb.188.1615572034158;
 Fri, 12 Mar 2021 10:00:34 -0800 (PST)
MIME-Version: 1.0
References: <20210310122040.17515-1-vincent.whitchurch@axis.com>
 <CAH2r5mvkX7T=HLCJmL-T=5B3P7ipKMuzGJF6psoBLru-2fNfWw@mail.gmail.com> <87v99yt3h7.fsf@suse.com>
In-Reply-To: <87v99yt3h7.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 12 Mar 2021 10:00:23 -0800
Message-ID: <CAKywueRW2pq6m1NhtMT1JXmF9+SYVi_0Vo_famRWC42TVOvWMw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix preauth hash corruption
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>, kernel <kernel@axis.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks for the patch! Agree with a stable tag.
--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 11 =D0=BC=D0=B0=D1=80. 2021 =D0=B3. =D0=B2 02:01, Aur=C3=A9li=
en Aptel <aaptel@suse.com>:
>
> Steve French <smfrench@gmail.com> writes:
> > cc: stable?
>
> Sounds good
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
