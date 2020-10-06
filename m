Return-Path: <SRS0=Y/WD=DN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71ECC4363D
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 22:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A9B7208C7
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 22:22:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rDyNYJ14"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgJFWW5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Oct 2020 18:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgJFWW5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Oct 2020 18:22:57 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83219C061755
        for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2020 15:22:55 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id u6so175541iow.9
        for <linux-cifs@vger.kernel.org>; Tue, 06 Oct 2020 15:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f3Bp1gWy09OxjDaTzvi5JkA730WBy7ytAbOCR6ptwoA=;
        b=rDyNYJ14DiICihEEAiT5lsTRUrp6cFhn7T5wooZiMiTODjT74w4sivAYJmLvA1090P
         nKzt/43Q4zdgEtIB7jIKCe+AJo/7URxvqObI9nkZHD1J7MJ4FnWsGzGCDrh/Szq4gbsQ
         OS+DsmJDbW+leMeJIpF8S6oM4wtagbENoPYJfl+p63S8Wxeafqv0QRTrJSZ/uZ6Xh5bX
         5RaA1tq2a10LBOsrGVADZAS17QUWJ9bcZESZF3pdBxseD1lGRQAY6JQWUVg4xKuUNJpS
         2cD1DymiteZeNcnZ4QMVQ3t6iEwBkNKj7uKeGP6GfM6EU1kYwqfzaRuHYhBjmVrff4A/
         4UzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f3Bp1gWy09OxjDaTzvi5JkA730WBy7ytAbOCR6ptwoA=;
        b=dYDsH6v+N2L5nAWOSWKgvKEYd9ct70yXgQlWl9nMPEzy9/WK3Vj3ppbWii+AyX40ss
         I70d5Y0e9rjzh17/WfVeaRZxh7bHZa9bAImIRkoCggQwRurrPHgb5i12D3rWAim7bKRD
         ojKBt03Ar+tUQrt33cW1P98qzds3pDEg4y3B3aTsqG5NYdRyH03g4ZClQ7EGSHVIKZxZ
         kJ0SLDVVtktCbS+J11/GOEiRUPjtvq2O0QMMCtbOQvcT0iytPJ3PGmK42KDbOR2rTLNh
         5grxWYa0887VrDiigDuszAH/th7dCYIwAxWQCwAYYsYZeW1G3bIIJlY9QvkpHhswjruz
         2ZxA==
X-Gm-Message-State: AOAM533lyLJhnIggMOhn5EdsluzekgnXVl7kWxnas0He2UF+pVnn+64r
        AyL9R/lm/EGQfZSHKqGNNAp1D7umgJ+wtGeUI7I=
X-Google-Smtp-Source: ABdhPJwc31uriAwqCRK1K7yxECdsZx0FIcfGl8ZW1qzLDnmkchM7n7m7zV6TS4hBpGYMa3Bqw43b9AWrlIiD3jxNLHs=
X-Received: by 2002:a5e:9613:: with SMTP id a19mr32232ioq.116.1602022974826;
 Tue, 06 Oct 2020 15:22:54 -0700 (PDT)
MIME-Version: 1.0
References: <20201006052643.6298-1-lsahlber@redhat.com> <87ft6ripw9.fsf@suse.com>
In-Reply-To: <87ft6ripw9.fsf@suse.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 7 Oct 2020 08:22:43 +1000
Message-ID: <CAN05THRzdzc7Xy0fi2pF4jEs=QfsS-GSG_LEz_YwbexesRHvhw@mail.gmail.com>
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

On Tue, Oct 6, 2020 at 8:57 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Hi Ronnie,
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
> > Some calls that set attributes, like utimensat(), are not supposed to r=
eturn
> > -EINTR and thus do not have handlers for this in glibc which causes us
> > to leak -EINTR to the applications which are also unprepared to handle =
it.
>
> EINTR happens when the task receives a signal right?
>
> https://www.gnu.org/software/libc/manual/html_node/Interrupted-Primitives=
.html
>
> Given what you said and what the glibc doc reads it seems like the fix
> should go in glibc. Otherwise we need to care about every single syscall.

glibc have handling for EINTR in most places, but not in for example utimen=
sat()
because this function is not supposed to be able to return this error.
Similarly we have functions like chmod and chown that also come into cifs.k=
o
via the same entrypoint: cifs_setattr()
I think all of these "update inode data" are never supposed to be
interruptible since
they were classically just updating the in-memory inode and the thread
would never hit d-state.

Anyway, for these functions EINTR is not a valid return code so I
think we should take care to not
return it. Even if we change glibc adn the very very thin wrapper for
this functions there are applications
that might call the systemcall directly or via a different c-library.


>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
