Return-Path: <SRS0=9bed=DP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D42C433E7
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Oct 2020 23:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF85D221FD
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Oct 2020 23:31:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="of7SYsZS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgJHXbN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Oct 2020 19:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgJHXbN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Oct 2020 19:31:13 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125EAC0613D2
        for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2020 16:31:13 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g7so8211592iov.13
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2020 16:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QPY5AdWgnawEqEy9/lCwyYdAG+08r5KYJtfc0B2WMes=;
        b=of7SYsZSgvLjETiQcRKRMbcT9JqzBrAcgai3BaiLJ76z7MGr6vRGbZ39HK7KbHcfop
         mEX9ePCCKVPRi8IVhShtnbxZ/y8Or1el/mortTnhx3SjFewNC5osJ46u7osZmAU29Ber
         qQs7sfpWqWiCmZBs9ThjYa1aCoPMHMqM6yEidsrt1hCpR96D8xnB4YMvxV4ck0E2AQMy
         f9KKTTcxEr8/1Z696DrMhMkm7o3O8S594uNkhMG1ANyKIxnHWi+tEqv4cuG2hPG1v0kz
         RSc6CClhifW6IkPEdZYk1+FKKnTtbyrqPVogRA3mzy7scuc0jOtJ7WuTItVDzmWh2P0r
         T3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QPY5AdWgnawEqEy9/lCwyYdAG+08r5KYJtfc0B2WMes=;
        b=Dfbpw4Zi1Qm0QXdDFpQNfeB5nD+hn/4v9fNbfQv6Bp02Qva8VL2L2vSTbjYiuCFDx+
         G7T+hJaN+CTfBqu9xMbx11JY/Pjakb3or6eeIAd6tvdPz0aoUmfKebQUqXRDSx1CM7R1
         HN7ZrAj3Zavnn4xmIgRBrf2V4qH5E9C1bWo4BAYX1j+gmr1DFNrosBl4qA4l4+TLWl1O
         e9EcxO7DcgILaCcxSkj0axV4YJ1anyfXM4UfUHo2vYBsKzsgm+6CSgOz25LwXxQc54QP
         H9EG+xHPPgiYyuIaE6xTCxiD2BWDhgJeZsnxcmOukSibS2e46n6hAMQm74fbVZaaMSbk
         ezJA==
X-Gm-Message-State: AOAM531xSrgjKYassqwxkzXQO0L2tSVjfJCjUzbBkZxelUZGge235jHf
        oYOFfZpM2zQ6ni+vBAsEozkv3OGahVU8Aex8qnY=
X-Google-Smtp-Source: ABdhPJxrkAsSvbREPcI3x3MWosmXRWB7x2be8Pa7qypeXgkLOtOOHzFcCCAO89vB9j3VZqeNSWwFAP31RmMxddu4KZQ=
X-Received: by 2002:a6b:610c:: with SMTP id v12mr7610642iob.101.1602199872301;
 Thu, 08 Oct 2020 16:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <20201006052643.6298-1-lsahlber@redhat.com> <87ft6ripw9.fsf@suse.com>
 <CAN05THRzdzc7Xy0fi2pF4jEs=QfsS-GSG_LEz_YwbexesRHvhw@mail.gmail.com> <87d01uiaaz.fsf@suse.com>
In-Reply-To: <87d01uiaaz.fsf@suse.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 9 Oct 2020 09:31:00 +1000
Message-ID: <CAN05THR-CrNZBJ99xCuztQd+LGuxb9uyEZDS89zJmxonnyKVOg@mail.gmail.com>
Subject: Re: [PATCH] cifs: handle -EINTR in cifs_setattr
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Oct 7, 2020 at 8:45 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> ronnie sahlberg <ronniesahlberg@gmail.com> writes:
> > glibc have handling for EINTR in most places, but not in for example ut=
imensat()
> > because this function is not supposed to be able to return this error.
> > Similarly we have functions like chmod and chown that also come into ci=
fs.ko
> > via the same entrypoint: cifs_setattr()
> > I think all of these "update inode data" are never supposed to be
> > interruptible since
> > they were classically just updating the in-memory inode and the thread
> > would never hit d-state.
>
> I see, thanks for the explanation.
>
> > Anyway, for these functions EINTR is not a valid return code so I
> > think we should take care to not
> > return it. Even if we change glibc adn the very very thin wrapper for
> > this functions there are applications
> > that might call the systemcall directly or via a different c-library.
>
> Should we use is_retryable_error() to check for the errcode?


That is probably a good idea.
I will resend the patch with that suggestion.

Thanks!
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
