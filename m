Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEF4C433B4
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Apr 2021 23:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95F546101C
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Apr 2021 23:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhDSXkO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Apr 2021 19:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhDSXkO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Apr 2021 19:40:14 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CF3C06174A;
        Mon, 19 Apr 2021 16:39:42 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id z8so41355969ljm.12;
        Mon, 19 Apr 2021 16:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LfEpz0iSjiNDbPXawTwLPZzoSRuzzKGOxdOGebsOX3c=;
        b=OZJ2dq2qJ5uj4GxBGsnYxJZ0yMig951/JM5Yx8zlFk5Ker01MAUc003nNQt+po7kRO
         debCIwjD1HJqCkzEIVAWep2IarzX+nzs/P8lhCNblHpS5gnfmFx6G1GZgGC68AZ81gdf
         9WKGDRkeQXEGZnmOA3EUTeCV/W2o5LqtaA0VCuUjQe+eKn8//52l2mBqHM/v1H5uIDCj
         7egCMZbOs2OL9Kqt/H/cugtDgZKITs57StunHsMH5/LGyWUYQX1M35bAQQOMceldKpQT
         HAkSumSoVHkp5sTZxIcGoUEXjFcjll1DqkSnrOFdG5QOCabCcWZI1QvFpd0xuZXa6YiT
         u1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LfEpz0iSjiNDbPXawTwLPZzoSRuzzKGOxdOGebsOX3c=;
        b=EdQGrfy8zKahsJxlRQR1zlc7HMuWNZwIDEZVmXsoOk0XZSS5UjbJdULDK4cZk/SpTn
         0stAWa/JNgDEIyLZ8RWm9nf5M173iDrsxj4hxABeW/gV/KBP5wJ8YMoXZWqo09jz8UhS
         40bLdryrGe7Oe/7FDbaaG6sPUxJsPC20p/kbtj7rROzSKDmG9gPsZjDRR/rZy0LMdSC6
         zQ/L2EAjIejdYuceOcDS0QcQB5XbBlHD4G7rr3Sf9TikfLnQLSqksOWUTR9McZGenY4y
         sJRxIQA491Se0vxYJTtER/DP7kH/C5iO12OseCuNy5Nzv2dCmpzzzRICyUCxxPymlYeY
         M7dw==
X-Gm-Message-State: AOAM532KB7BVEEcKVduULUKVeLoDBi+o+GYbh+0lWh02Ys5ZAI9y8I0d
        RYyTmLl2BLAi/ttdC96DzaWZmcxHNpto42iny04=
X-Google-Smtp-Source: ABdhPJwBuUhwU7MDlAnuogmGpFmJLlcos+VhDPWVAgQqC+uDhcnnkQThfnFQxkMCz8S1PFN/Uc33qunbbsOd4idJ5vE=
X-Received: by 2002:a2e:b8d2:: with SMTP id s18mr12849213ljp.148.1618875577658;
 Mon, 19 Apr 2021 16:39:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210415152409.GA2286719@LEGION> <8735vp18su.fsf@suse.com>
In-Reply-To: <8735vp18su.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 19 Apr 2021 18:39:26 -0500
Message-ID: <CAH2r5mtwMep4J1yu1jUUEp3+CmwhFuv2mJKqN1ViBkSxi-jGTg@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: remove unnecessary copies of tcon->crfid.fid
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Muhammad Usama Anjum <musamaanjum@gmail.com>,
        Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS)" 
        <linux-cifs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Colin King <colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I changed the comment to

+               /*
+                * See commit 2f94a3125b87. Increment the refcount when we
+                * get a lease for root, release it if lease break occurs
+                */

and added Aurelien's Reviewed-by.  Let me know if you see any
additional problems.

On Sat, Apr 17, 2021 at 5:54 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Hi,
>
> This is better I think.
>
> Muhammad Usama Anjum <musamaanjum@gmail.com> writes:
> > @@ -894,6 +891,10 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >
> >       /* BB TBD check to see if oplock level check can be removed below=
 */
> >       if (o_rsp->OplockLevel =3D=3D SMB2_OPLOCK_LEVEL_LEASE) {
> > +             /*
> > +              * caller expects this func to set the fid in crfid to va=
lid
> > +              * cached root, so increment the refcount.
> > +              */
>
> This comment is misleading. crfid variable doesn't exist anymore, and
> the kref_get() here is because of this commit:
>
>     commit 2f94a3125b87
>     Author: Ronnie Sahlberg <lsahlber@redhat.com>
>     Date:   Thu Mar 28 11:20:02 2019 +1000
>
>         cifs: fix kref underflow in close_shroot()
>
>         [...]
> -->     This extra get() is only used to hold the structure until we get =
a lease
> -->     break from the server at which point we will kref_put() it during=
 lease
> -->     processing.
>         [...]
>
>
>
> When we queue a lease break, we usually get() the cifsFileInfo, but if
> that cifsFileInfo is backed by a cached_fid, the cached_fid isn't
> bumped. That commit was probably a work around for that.
>
> @Ronnie :
>
> struct cached_fid is starting to look very much like struct
> cifsFileInfo. I wonder why we couldn't use it, along with
> find_writable_file()/find_readable_file() to handle the caching.
>
> Alternatively, make cifsFileInfo use cached_fid (perhaps renaming it in
> the process, I don't know)
>
> Because I suspect a lot more issues will come up regarding cached_fid
> refcount and cifsFileInfo refcount going out of sync otherwise.
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
