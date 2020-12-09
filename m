Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AECC1B0D8
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 19:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D058323BAC
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 19:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgLITdy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 14:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgLITdi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Dec 2020 14:33:38 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6457C0613CF
        for <linux-cifs@vger.kernel.org>; Wed,  9 Dec 2020 11:32:57 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id x16so3817047ejj.7
        for <linux-cifs@vger.kernel.org>; Wed, 09 Dec 2020 11:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Z2yAwF31Ul8BjXpds4dmW3r9IsLEPZSiQLqhXqGa4o=;
        b=KXtWghu7EuZn6nrb7yBuFZUSwyQlqz4OmEiS6460fu44kaJporE8aUZujKd/nTsLbB
         eJas4QJly+hjAXDM/cenevIF3ewi7dTwlvtqKMBrjmNBSvenIi1xX8Qq4FUS0wSvljNQ
         PiBT7r6eLV7rG1I+6iROHy4zAGDsjGXNOvAjwD9Gu8nP8WSNlzAlfT+XzgTVesQ80HVa
         sdm+aUBa1znR/roqSfu8blCWYhZMu4gdpjHJzZRMQtb9LPW7p09fQMfieuLdWAuabLPb
         1cRHfuIB7tkFnOqJPzhK3iQeyddKXoWxqpCpDRpemWi1Qxnc7za39x64pir5hQv8kK7R
         yYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Z2yAwF31Ul8BjXpds4dmW3r9IsLEPZSiQLqhXqGa4o=;
        b=KGkmAb+ufrV2hPE/ilMCSWYQ9dDWeqkdyAW6xA8tyRZw7JQ25g9mRZkj8mcPL+5zxh
         hkxFbc2Gsdi4OQzE324Nh5CgqRciGHnkrMa9r/qwpMfP5RJndIEmwD8fDRC23t0XAHdR
         qJBJYY3n6i/SdzXjZCvR4cWeTwMwHgO/srdD4ZxA8zQ1CCwm3B4wB0vnNw3rwGkTI5Iz
         zJ7+FGJ2V4X7uRobsU38sQgw/F6RLBGNDQFenTAI6Zx5HsAM4WMnYluL14HTMM4t/yAy
         RvlrlGy1zS/zL6IiNp9nOEz0n5hlCpQ5DfLmq85jLqQPRn5/RyQprThKotYSToVFo6Wg
         z/UQ==
X-Gm-Message-State: AOAM532R8HV4DT8wG9iomyoB7GAqx/yc1Z5xworQtQ73GWbucaOzzzMH
        CAaaQ/nqBWXViN+GAFBHXGNaBFvmXtP7hW9yaw==
X-Google-Smtp-Source: ABdhPJxurssu+h+cICZuHn8mTyLm81NIMtlGpy+iB3B5CiQVPMiam2CPQzOvrlBRpio1YLj+sgrrYrmDD9rOxipp3Kc=
X-Received: by 2002:a17:906:c7d9:: with SMTP id dc25mr3499270ejb.138.1607542376593;
 Wed, 09 Dec 2020 11:32:56 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oiTY63d5yVyywiTrCqpAmvaugMVVpQRV7RT7ZA9HU2+Q@mail.gmail.com>
 <87r1r2ugzw.fsf@suse.com> <CANT5p=qV6BWojwBET+kYUwJf7tQDFoRtUb8O+pWHrqWMw5e5LQ@mail.gmail.com>
 <87wo0slr0c.fsf@suse.com> <CANT5p=rarYr0bErP77GF5QOu8=xx7Ovfy2dWdUNxnOTGkLXMKQ@mail.gmail.com>
 <87o8m4lnig.fsf@suse.com> <CANT5p=rKKZeS+HqonXQF4eaKFTod0rhb56GM4dXkYKhCcDhftw@mail.gmail.com>
 <87lfh3lexw.fsf@suse.com> <CAKywueRcmWYOJ748Tc4jmAD+8HRpNBUG9AtAKhKvm5OmmsT=pw@mail.gmail.com>
 <CANT5p=r2fwDd118_LTvB1PDDNbwzijdwXzF21O7AhpZpjxMU6w@mail.gmail.com>
In-Reply-To: <CANT5p=r2fwDd118_LTvB1PDDNbwzijdwXzF21O7AhpZpjxMU6w@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 9 Dec 2020 11:32:45 -0800
Message-ID: <CAKywueSs9h+UuthwKcCD-o5z9oEz=9oLYy10aCCXNivy755mMQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs: use SUDO_UID env variable for cruid
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged. Thanks!
--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 27 =D0=BD=D0=BE=D1=8F=D0=B1. 2020 =D0=B3. =D0=B2 02:25, Shyam=
 Prasad N <nspmangalore@gmail.com>:
>
> Hi Pavel,
>
> Please consider the attached patch instead of the one I submitted earlier=
.
> Contains the fix to the bug identified by Aurelien.
>
> Regards,
> Shyam
>
> On Tue, Nov 10, 2020 at 5:13 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > Merged. Thanks!
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D0=BF=D0=BD, 21 =D1=81=D0=B5=D0=BD=D1=82. 2020 =D0=B3. =D0=B2 01:19, A=
ur=C3=A9lien Aptel <aaptel@suse.com>:
> > >
> > >
> > > Thanks Shyam, looks good to me :)
> > >
> > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > Here's the updated patch.
> > >
> > > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> > >
> > > Cheers,
> > > --
> > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnb=
erg, DE
> > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
>
>
>
> --
> -Shyam
