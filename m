Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15106C4741F
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Nov 2020 23:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9F65206ED
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Nov 2020 23:43:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HY/9JC21"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgKIXnf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Nov 2020 18:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730171AbgKIXne (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Nov 2020 18:43:34 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B340C0613CF
        for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2020 15:43:33 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id za3so14839218ejb.5
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2020 15:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9oJh2bFbehkEpQjnGhjVScK/dBeawbJgeaMHEbQDuJM=;
        b=HY/9JC21cYSdoOBw4LBJjs5lrE41wg8wNSKTtIc+gPy6mrUKHp85p+CZXRZXgNP5eE
         M9NFXgUJyzKsWNZFEbATjHUNZVD+P5485s8mYsIMBEKdeFXlIhPt8TOy5oJsE78/rTtn
         m77jx2nRgx1NdYMSkNEqn1SyQOjrG7g36QeFMBmG0cEwd9N3n9uG0VhiNyrlWnZZQGIj
         Ek5MFoZ/RgWcaPTb6uyJjWz1JcNU1x/Tj5+n/Dg1Kp5O7GT9YWTfnDWy7MRHCEckGNbc
         P0zxA+DDBhbsxrtaa/KD3WLJEpKNh3D7+3+BxyReRcDlR6o4Es7UYdwb4WWPZOfhTS5H
         PPug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9oJh2bFbehkEpQjnGhjVScK/dBeawbJgeaMHEbQDuJM=;
        b=YJm15xkXdPzYJzidX2gXwaKocryZiopmiBRDTPVbW8+6uu3wafX0peiHG+AwKLEVnH
         qafbVAbFkBODkWLEbW5GEYD9/Ud0uL07tyMVWT09af4A5FpEUwiJ5/XCH+ovuPxuspFR
         efeniJIXBVNN5TSRS3HLRt19l+MBBdZsAeN3/3AP6J9TAsog3ZbFs2Km/4ciFaj9kYHc
         23pymFg0NaKq5aG8M9Yj/owbL8NkFC2/z7RWa4saSaBb0D+y/j5LTUZjTXWIs//mhp8o
         xKviZFadNRA0F4gEZLwmIqLwQwTAP/VfYhix56q62IMQo9geVn41sPAcMIbJw+7RZ6JL
         y38w==
X-Gm-Message-State: AOAM532ucNJt+0eRKqI8gCSmHUR/AG0/VJSZRwmShs6muE3ugYFNpaSM
        +3uHhacAPQ0/Nc91N4ndMIwokj5a3LGEXzW+TQ==
X-Google-Smtp-Source: ABdhPJw6QU71ipbGy6nEYpINAF3vS1BULf3Z1NCRb9Z4qZSV5quYmENHcORVBhDY4buMEdD32itym1y0oTMrVS/IsyM=
X-Received: by 2002:a17:906:f753:: with SMTP id jp19mr17073701ejb.280.1604965411288;
 Mon, 09 Nov 2020 15:43:31 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oiTY63d5yVyywiTrCqpAmvaugMVVpQRV7RT7ZA9HU2+Q@mail.gmail.com>
 <87r1r2ugzw.fsf@suse.com> <CANT5p=qV6BWojwBET+kYUwJf7tQDFoRtUb8O+pWHrqWMw5e5LQ@mail.gmail.com>
 <87wo0slr0c.fsf@suse.com> <CANT5p=rarYr0bErP77GF5QOu8=xx7Ovfy2dWdUNxnOTGkLXMKQ@mail.gmail.com>
 <87o8m4lnig.fsf@suse.com> <CANT5p=rKKZeS+HqonXQF4eaKFTod0rhb56GM4dXkYKhCcDhftw@mail.gmail.com>
 <87lfh3lexw.fsf@suse.com>
In-Reply-To: <87lfh3lexw.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 9 Nov 2020 15:43:20 -0800
Message-ID: <CAKywueRcmWYOJ748Tc4jmAD+8HRpNBUG9AtAKhKvm5OmmsT=pw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs: use SUDO_UID env variable for cruid
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
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

=D0=BF=D0=BD, 21 =D1=81=D0=B5=D0=BD=D1=82. 2020 =D0=B3. =D0=B2 01:19, Aur=
=C3=A9lien Aptel <aaptel@suse.com>:
>
>
> Thanks Shyam, looks good to me :)
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > Here's the updated patch.
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
