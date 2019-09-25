Return-Path: <SRS0=S2qj=XU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1CEC432C2
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Sep 2019 20:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2928E2146E
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Sep 2019 20:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="asmTl5dm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732890AbfIYU67 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Sep 2019 16:58:59 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46115 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfIYUzA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Sep 2019 16:55:00 -0400
Received: by mail-lj1-f193.google.com with SMTP id e17so7124386ljf.13
        for <linux-cifs@vger.kernel.org>; Wed, 25 Sep 2019 13:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vy8kv3AitNP9XZZ/vSPKU1UwuRdbFq7IdENH9c0A0cw=;
        b=asmTl5dmxmMwEJF+Q4Fe8TB1bDutHyYFQJSFmrjw3xcwSgo75N4Vof43TFOHNaOEV/
         lxAkHMFh2KZikR8XbRYbzNShUZ41EkMsVVTNNc6kKEcXR/fC4yQ5XH+4bHjRjYNDGWLN
         e3lcCPZKhqaPrDgCEmtx4PPSLGZ1uymi8SL1C01XkTRLYmPmvIsD0bstLTKraLZK58y4
         xSJlU5LC8gzPvvBK6vDG6G82A8ckdkZg9E9yrmf+4AEO2EJjk8ULetr3lOBN4ahx0jvV
         +NiEwqEXpIlksPtF5i8xS1vuPUmJLVNsTojcYUYzqnNAo3VPbZqhJkEErdmeIbvIWVAe
         5fYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vy8kv3AitNP9XZZ/vSPKU1UwuRdbFq7IdENH9c0A0cw=;
        b=lGk4faKEsOdZMDfy/mRG+0wL6eTDjv8wX1c55Q62Fl2KODM2A5RBGgQ8tBzRrPPqHw
         7T3oyPDSrsTXhIHfNcBwFBD0bhjGbsuBTqMMsyPaWFi6GsQhc3epWkQ64jIG6++MobEB
         yYqOUaGHsfUghzCSx4v3rFpU29xI4g1wnLVX0mPtYqV9mnMaTE4y8TjIe9N+fSlO8AlY
         jcZA1V5QU4m5eM7iiPh7kuQN73mwqFXc/Ki+yBbKveziaa3aHYtoUKReAYH6mh6MPnWd
         iKoT54T8W9uqM8+PsGkUuk+jN5adMSWt1UnR7aEumlmQXwAn/Q778KFidmGbKdkCR6G/
         2Udg==
X-Gm-Message-State: APjAAAX4zFV5NzW6oMXvZqkHdqgDtpTnBrSmcwNH4cqkD1WApW+PyFeh
        UQARdLc32SKLOkRPmmtq22UzvLpWd0S6wQ1EbT79
X-Google-Smtp-Source: APXvYqyGqbuPWVbLCaU9V1VyUqemX2GGlLXuWH8XGiN5LvFxIssdC15Kdsc1kXnGbjjYbqdKYnNhRGXXmrjtMSQHTQI=
X-Received: by 2002:a2e:9049:: with SMTP id n9mr176283ljg.45.1569444896571;
 Wed, 25 Sep 2019 13:54:56 -0700 (PDT)
MIME-Version: 1.0
References: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
 <CAKywueT=hWCTM=Crsafrj-8P=1mD93DY73oK=Ub8JeWc5X85fQ@mail.gmail.com>
 <4a017b583eb0f5fab477ecbe0e43b3a1@moritzmueller.ee> <CAN05THR5FE80VsnbKfpBzvt+g5jPu3rtiOqWkzU5yKoKUkhkiA@mail.gmail.com>
 <CAKywueTOjoP-Jh7WWCi5XJhfzgK+KZs3kvHKuVG_HW0fnYYY7A@mail.gmail.com>
 <CAKywueQUuwRK7hbbJhdquVVPre2+8GBCvnrG76L-KodoMm9m6g@mail.gmail.com> <b7b7a790feac88d59fe00c9ca2f5960d@moritzmueller.ee>
In-Reply-To: <b7b7a790feac88d59fe00c9ca2f5960d@moritzmueller.ee>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 25 Sep 2019 13:54:45 -0700
Message-ID: <CAKywueQ7g9VYe=d7WU4AzL2Hv+pPznUgQBD7-RVi0ygBkhtGRw@mail.gmail.com>
Subject: Re: Possible timeout problem when opening a file twice on a SMB mount
To:     Moritz M <mailinglist@moritzmueller.ee>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks for testing it!

Please update the thread once you verify the patch with the other
software you mentioned. If it works fine, I will prepare a formal
patch for the mainline and active stable kernels.

--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 25 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 12:23, Morit=
z M <mailinglist@moritzmueller.ee>:
>
>
> Thanks Pavel.
> After messing around with the Kernel build procedure on my distro and
> adapting the patch slightly (filenumbers did not match) I got a working
> cifs module. And it solved the issue at least for the python test.
>
> I'll check tomorrow the other software where it occured.
>
> >>
> > Could you try the following patch in your setup to see if it fixes the
> > problem?
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 047066493832..00d2ac80cd6e 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -3314,6 +3314,11 @@ smb21_set_oplock_level(struct cifsInodeInfo
> > *cinode, __u32 oplock,
> >         if (oplock =3D=3D SMB2_OPLOCK_LEVEL_NOCHANGE)
> >                 return;
> >
> > +       /* Check if the server granted an oplock rather than a lease */
> > +       if (oplock & SMB2_OPLOCK_LEVEL_EXCLUSIVE)
> > +               return smb2_set_oplock_level(cinode, oplock, epoch,
> > +                                            purge_cache);
> > +
> >         if (oplock & SMB2_LEASE_READ_CACHING_HE) {
> >                 new_oplock |=3D CIFS_CACHE_READ_FLG;
> >                 strcat(message, "R");
> >
> >
> > --
> > Best regards,
> > Pavel Shilovsky
