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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7229DC433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 12:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B18564DAF
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 12:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhBPMcK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Feb 2021 07:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhBPMcK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Feb 2021 07:32:10 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0450C061574
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 04:31:29 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id p193so10298635yba.4
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 04:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gL+P+YN4+rhAIHbz6Aw43PWiq7EVCYC7nH0LYHaUP6w=;
        b=vNmJKv/ENGDQsy3ndzlXsEAzV5k+t0sG9KT+3dL6094bXQM4nTm1mB1atfFAPElHep
         lx4T/+GDR7um/QezNpp1boOV5HNqir12pYjVT+c1/NSx0t9IT5lxeo+L3bxdLbtlhJcR
         tq3CFtCJdJ0FzTujDPxH0K7PygOIGf1Dl6J9D0eO30kWMG8MxzOEzZqgBypQgq3TIn1i
         6TRs/Jaw0s0IWkO+vwPAK0zoDxfgIWXZ2FHxyTr2+/cWl8HXxFGkHGK1NUHZSQpSbA6G
         AxVGoyTyiin3AIFsipY5/L8qBpW4paV1ZiMfdbEixx02XFW1L9peB41d/2WGoa276BpV
         9Y6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gL+P+YN4+rhAIHbz6Aw43PWiq7EVCYC7nH0LYHaUP6w=;
        b=C2SpmeBBWbuhgtiQ7l5n14WKdDohzs68nWJ9KzYSfuAK0E6g2LuXF1LMIvS6KPa4U3
         EzQG/d5LvZUBUimjTOdc7UUGbKhYQiYsbt5LBnqYAkIsYoRc4snUE+LaRZYlj1O7nXLV
         zEmwGQwzO2IUyCITQUONQMvUe0+lfOjlYge0oQyCHcexegeeI1X4QXaqIaTQeT21Muga
         32G/Xl8IVY+tZpKXLyu9wV7WFI/9VLc1xhPxMIpkW3Eh5dnScvDlPP7Ebildl4c12vtn
         mJERIJFt08vfL+6etsyKEstoJhswUN5HnEcEDz9IDFafFzz3LAYWpRUNgPmTrO9yOIAu
         SsFQ==
X-Gm-Message-State: AOAM533VOzWDtzW66fBLnclIoMQ+hk81spTyws5CpKcG0cx1t9oGI/mq
        EQIVwL+RHzR5BiU5YFsI1ZUfs6Ab72vnFRU3tlQ=
X-Google-Smtp-Source: ABdhPJxCur4ppcwdivgBB6Hd7oLjXVx5e0Hh87I5BsUakRFejJJDkarQSVictH56FjZGn9VGH2uyZg21Vcd0vXsNC2o=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr28026051yba.3.1613478689007;
 Tue, 16 Feb 2021 04:31:29 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qFrK960mVaHD_zESh6prnHRLU1KeudOnbS+nqSXwiBjw@mail.gmail.com>
 <CANT5p=oaVbe2rz-38J=_XD7DqZN48Bap-myJW9v76=JLTvAetg@mail.gmail.com>
 <87k0ronno0.fsf@suse.com> <CAH2r5msvOj-Vu0_SyBTzkObYaeM9XZxVpQMKbf0din=3r6fWug@mail.gmail.com>
In-Reply-To: <CAH2r5msvOj-Vu0_SyBTzkObYaeM9XZxVpQMKbf0din=3r6fWug@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 16 Feb 2021 04:31:18 -0800
Message-ID: <CANT5p=o+zzC=A8wvS1zGwemuFyjEsOp+p0Ln_ws=5uC4rsJm0Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] cifs: Fix in error types returned for out-of-credit situations.
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

5.12 should be fine.

On Thu, Feb 4, 2021 at 8:49 AM Steve French <smfrench@gmail.com> wrote:
>
> Is it safe enough to cc:stable?  Is it important enough to get this
> fix in ASAP for 5.11-rc7 vs. 5.12?
>
> On Thu, Feb 4, 2021 at 4:16 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > For cases of zero credits found even when there are no requests
> > > in flight, replaced ENOTSUPP with EDEADLK, since we're avoiding
> > > deadlock here by returning error.
> >
> > Seems ok. libc can have different behaviours depending on error but it
> > should be ok I think and better than ENOTSUPP.
> >
> > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Regards,
Shyam
