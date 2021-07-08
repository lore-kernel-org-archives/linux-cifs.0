Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986E0C07E96
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 23:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 778BA6139A
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 23:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhGHXRJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 19:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhGHXRJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 19:17:09 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5F8C061574
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jul 2021 16:14:25 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id h2so10967566edt.3
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jul 2021 16:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I/8H7HtN4goZiZRlKyF/NmMXoSpuxE5LyPhX/WJaAgQ=;
        b=GK3P6+BILO11CG4EQKg0BTOCd/tgjlZorzpu1j/PEQF/xSYTOdHgcJFOjkDJ0x5S5o
         ztwJy1DCNXXgSP4kUZsR8WRx9YmaX65QtPHxsCS1MYKSjOlux2wrDrGmHnTtrY/GaK8+
         0Cs957JktAr58fMBuuEKeqzRcyXBMvCydSZAcrzsYlJ4LStAG16pWHSlukbmZLsZY0o0
         hy1NaayO34Vq8tFOA5UYeT1mwYgifBWODM2+atYaWLGS7jqnTLjkrLzNzw5gTn6mk+Fc
         UhTVCniVrFzCOmR64FX0R8DFyLlvPU/vaJe+2+9mfpVgzcUBlrE6DD1YuksTMfUOMV9i
         0+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I/8H7HtN4goZiZRlKyF/NmMXoSpuxE5LyPhX/WJaAgQ=;
        b=CVTBpBj6eu1PyV+/NmSv+Nl08vmgb1VvzvJ6CC6IMJHhrB2gikpSzTPyi2UBCL/5Xd
         93JMs5r+ntTYBoygXFgUMmCQlaja0aegvvr10sk/PUezbDl1cwfAoE78BreULjYqyq7F
         3mPR+/OE0VbFeBxhLoHHx4G3iBPyiWEEOumi+OtLw7XtVvgLZkMQBSj3roTCh3e6WNPh
         xrKeJFr5LooaPQnzzq+Qrz+4cX5iioj5EqEsMlSzv0ThSZvYb8aosZPbV7hBlECSAwNM
         2068kGkEz3pogxURkS2RddxpEGN8/Q2kkvnVGI8VtSH+u109kZZrhqQ1bb12VA9iA9Zf
         DiYA==
X-Gm-Message-State: AOAM532OloqdZaIpzBpJ4qf+GTwp8Jf8o4aBSedjIX6UiA5l1eM0bX1/
        ql0Sjw84PEllXQlG5PNPJMR4KLA6k+gQLQkRuA==
X-Google-Smtp-Source: ABdhPJwQipt7ZX/Csywh9zw3M5XvrdAD3cUsoubx++qfG8DJywfOWK1SVbSYDySJQHboYVNt81piuFxUfvejP+Cpd1U=
X-Received: by 2002:a05:6402:358c:: with SMTP id y12mr4975308edc.329.1625786064257;
 Thu, 08 Jul 2021 16:14:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210506192513.2935-1-pc@cjr.nz> <87v97uu8nv.fsf@suse.com>
In-Reply-To: <87v97uu8nv.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 8 Jul 2021 16:14:13 -0700
Message-ID: <CAKywueSU3UPaj2nOmQqMVkBJtrSqG5zO9BLyyQEECjqLMmrxpg@mail.gmail.com>
Subject: Re: [PATCH] mount.cifs: fix crash when mount point does not exist
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 7 =D0=BC=D0=B0=D1=8F 2021 =D0=B3. =D0=B2 03:42, Aur=C3=A9lien=
 Aptel <aaptel@suse.com>:
>
> Paulo Alcantara <pc@cjr.nz> writes:
> > @mountpointp is initially set to a statically allocated string in
> > main(), and if we fail to update it in acquire_mountpoint(), make sure
> > to set it to NULL and avoid freeing it at mount_exit.
> >
> > This fixes the following crash
> >
> >       $ mount.cifs //srv/share /mnt/foo/bar -o ...
> >       Couldn't chdir to /mnt/foo/bar: No such file or directory
> >       munmap_chunk(): invalid pointer
> >       Aborted
>
> LGTM
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

Merged. Thanks!
--
Best regards,
Pavel Shilovsky
