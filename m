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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F53C433E6
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 16:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4840D64F53
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 16:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237452AbhBDQvD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Feb 2021 11:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237784AbhBDQuU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Feb 2021 11:50:20 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD2EC061786
        for <linux-cifs@vger.kernel.org>; Thu,  4 Feb 2021 08:49:36 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id u25so5555910lfc.2
        for <linux-cifs@vger.kernel.org>; Thu, 04 Feb 2021 08:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CA6DhYnUYD95y0g0KYAm+VSkN1pnqJXdPsnC0zd07eE=;
        b=cjmI4+XDNnHb0/ft9WNogRjxTpl5dIAQMs6qtZjFy0aXNHfMtNC1W24DeM22d9umB/
         UfU6dlxYUPMuaGz5A1SxApM7OC2NwG64JfJ1ubmKijTuX9fw/RtAqfq69mmx/KWKpPdj
         D7dgN40mBdWLrnFojpHdTEHB2Z0ruAqPxoWxA8CkAShMwfW17Lq0TeBH1RA2xbKlZ2Wv
         NQTTeO3YtTFC/01N9WYb/S3kpSMNoLdVVXnWMfCz4dzBnP/UxauCT0PuPG//amhUun8W
         JhkiX86JGeKP6naLtMWE0HiPmkNw5aQmYSAczU1CrqARXMCReQx+SphlGhFm6/W+tpnX
         Pf1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CA6DhYnUYD95y0g0KYAm+VSkN1pnqJXdPsnC0zd07eE=;
        b=cbHldybjM/Q0Cj3hdjRqNDeJRMiSFc3bMHMb2OdM7YPF/xFdQl0E5Agh4dDK+s3V4y
         nmeQdFpYznlJaKn7NQm1zo2lonWL6mH7fSmsbPRxuWhysFARwgUyXSz6fM1WbF17lFET
         QJTKE/sGJNysEcDWmYrTwAym8yvwUGXcWFY0pVI6V6Yr9hxll2qitjn+/yyN1nmRRcnZ
         UU/8PoC42CQNS5bGig/XGIIX0XxMffxvIOb8qyf6lqCQSjDgR6Ysn1177Zjig4NxArZw
         P71Qi9gCIwRQ94NnQWIU0YyoiLpplN9biR0wqbsUIMibJdZ7pRGLRagc3DVt+W50hka0
         nbKA==
X-Gm-Message-State: AOAM533yozoWlebHCk9XX3TYUIMuvbVBocKl1LX+GRNguA12q59pkG22
        nTMedC5CLLb/pxPDSzPbWRZ51VquuoNPIF2jB7Y=
X-Google-Smtp-Source: ABdhPJwZXjiK7FEmXfFZZoguQp8D60OHMErjUXAU5GkxeftB/+0kjb3FnqHQqaC1AXbUaduaTl5/O+2UQJkgaJciFLk=
X-Received: by 2002:a19:746:: with SMTP id 67mr131634lfh.395.1612457374273;
 Thu, 04 Feb 2021 08:49:34 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qFrK960mVaHD_zESh6prnHRLU1KeudOnbS+nqSXwiBjw@mail.gmail.com>
 <CANT5p=oaVbe2rz-38J=_XD7DqZN48Bap-myJW9v76=JLTvAetg@mail.gmail.com> <87k0ronno0.fsf@suse.com>
In-Reply-To: <87k0ronno0.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 4 Feb 2021 10:49:23 -0600
Message-ID: <CAH2r5msvOj-Vu0_SyBTzkObYaeM9XZxVpQMKbf0din=3r6fWug@mail.gmail.com>
Subject: Re: [PATCH 2/4] cifs: Fix in error types returned for out-of-credit situations.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Is it safe enough to cc:stable?  Is it important enough to get this
fix in ASAP for 5.11-rc7 vs. 5.12?

On Thu, Feb 4, 2021 at 4:16 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > For cases of zero credits found even when there are no requests
> > in flight, replaced ENOTSUPP with EDEADLK, since we're avoiding
> > deadlock here by returning error.
>
> Seems ok. libc can have different behaviours depending on error but it
> should be ok I think and better than ENOTSUPP.
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
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


--=20
Thanks,

Steve
