Return-Path: <SRS0=bDWC=DO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1C1C3279D
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Oct 2020 01:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67ACC20782
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Oct 2020 01:44:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FDTqmZqH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgJGBop (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Oct 2020 21:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbgJGBoo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Oct 2020 21:44:44 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DF9C0613D2
        for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2020 18:44:43 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id b12so410482lfp.9
        for <linux-cifs@vger.kernel.org>; Tue, 06 Oct 2020 18:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Vq2ha87oH3peVHcyOOP3ZM8i7oNofOpXIV1SVxdCTI=;
        b=FDTqmZqHsy4F4g7NqFgEmVJZB0fdDqnHXWiX2y9FJyBegZJIvXLezPGbip6KdFuUEg
         MtilgGVP15iUcAkdHtDaJBS+Tb9Lea80xxn9HdYzG0U5fA+ZHJbWu2ljxwTgA0jwckf8
         ZKfL9llOstSNkSaAH+AiRM/0BxJJZnnx1cgy/v1UX1yyvPVjK+iSDoxCAQ/EM/+0uTvM
         hZwXBwDiiJKdaebPgO1aGHmgMyGks58MSW7X9kMc/zq1v2hIEIAvyOz2x8xRg8I910EE
         V+w51DYw3aK0KSXBTNdhqqPcOMBtA7dCfNq/vD2CWXPoipoHa5bDDJ7NwyRgqA6Utg8j
         nExw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Vq2ha87oH3peVHcyOOP3ZM8i7oNofOpXIV1SVxdCTI=;
        b=ewlY1ti6XtDQ3XXSYtYTj7WgsMfqgtsi+TtwCW5bHEcS8g1fX0z/Oo03Q5fNBYWTbn
         a49Nr7JXR/IZkD5PbK1KTj475+7bCHcReKGMeT1JYRr2b6gvTEWAGXb8Z+twNos7DjQr
         XDTG0+prXua9COFQskokZWDAiLbTidjgw0erpVsCUwhZdTe1lkbQK0RIOFU1/fI4H9Z+
         xX68bQCnfRyHd6yLV9lFwluKYuzsolRNXb0plR32Ncl6W059ZjdKy0UZ3NGjIMlV8Bdc
         rtv2XWtu4sVNcsdDH7Jxu03VcIrP19tnBIz54jaxvbfd69uZFxjLpgdnU/+lGt0s2dQS
         HluQ==
X-Gm-Message-State: AOAM533sxmF4QlD7bpbWzJel+eiHwcu8feLHsY+cLIS0Z816cq+2tb7n
        T7MY56bUj07GjynnKf2erTqb0p2+pOvpO1LTXuA=
X-Google-Smtp-Source: ABdhPJy0QKO5ZPf9qfUsbvdWufv4CinoOhAvglEYbeGjPORoGhEfLlt9+RZc18CsDhdGJQm32P8WQbsnTrvTsNYyZKQ=
X-Received: by 2002:a05:6512:36cd:: with SMTP id e13mr183321lfs.165.1602035081445;
 Tue, 06 Oct 2020 18:44:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201006052643.6298-1-lsahlber@redhat.com> <87ft6ripw9.fsf@suse.com>
 <CAN05THRzdzc7Xy0fi2pF4jEs=QfsS-GSG_LEz_YwbexesRHvhw@mail.gmail.com>
In-Reply-To: <CAN05THRzdzc7Xy0fi2pF4jEs=QfsS-GSG_LEz_YwbexesRHvhw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 6 Oct 2020 20:44:30 -0500
Message-ID: <CAH2r5muszEqf9zbv6Xv8UzAmcPq6gvhYEhb5LBPEbPfW61tRGA@mail.gmail.com>
Subject: Re: [PATCH] cifs: handle -EINTR in cifs_setattr
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged updated version of this patch into cifs-2.6.git
for-next pending more testing and reviews

On Tue, Oct 6, 2020 at 5:22 PM ronnie sahlberg <ronniesahlberg@gmail.com> w=
rote:
>
> On Tue, Oct 6, 2020 at 8:57 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
> >
> > Hi Ronnie,
> >
> > Ronnie Sahlberg <lsahlber@redhat.com> writes:
> > > Some calls that set attributes, like utimensat(), are not supposed to=
 return
> > > -EINTR and thus do not have handlers for this in glibc which causes u=
s
> > > to leak -EINTR to the applications which are also unprepared to handl=
e it.
> >
> > EINTR happens when the task receives a signal right?
> >
> > https://www.gnu.org/software/libc/manual/html_node/Interrupted-Primitiv=
es.html
> >
> > Given what you said and what the glibc doc reads it seems like the fix
> > should go in glibc. Otherwise we need to care about every single syscal=
l.
>
> glibc have handling for EINTR in most places, but not in for example utim=
ensat()
> because this function is not supposed to be able to return this error.
> Similarly we have functions like chmod and chown that also come into cifs=
.ko
> via the same entrypoint: cifs_setattr()
> I think all of these "update inode data" are never supposed to be
> interruptible since
> they were classically just updating the in-memory inode and the thread
> would never hit d-state.
>
> Anyway, for these functions EINTR is not a valid return code so I
> think we should take care to not
> return it. Even if we change glibc adn the very very thin wrapper for
> this functions there are applications
> that might call the systemcall directly or via a different c-library.
>
>
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)



--=20
Thanks,

Steve
