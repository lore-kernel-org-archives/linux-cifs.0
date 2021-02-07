Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE31C433E0
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Feb 2021 04:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F8BB64E8C
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Feb 2021 04:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBGEXe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Feb 2021 23:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhBGEXd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Feb 2021 23:23:33 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9473FC06174A
        for <linux-cifs@vger.kernel.org>; Sat,  6 Feb 2021 20:22:52 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id s18so12581357ljg.7
        for <linux-cifs@vger.kernel.org>; Sat, 06 Feb 2021 20:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q2rfqyxzbAcyxqLFd6JKu8YmoUH0ekLJQzwElkcFGEc=;
        b=WUQGoC1Nxl0IrleZbKAHoaiPLEIQfiV/hTO3UBnbGLrpwwNPbYfuvItIAmtSl+9skL
         zP1+3M1MuzlR6QtPFhEV/qst82KMydcBjq5DDpdzqAmZhpf7DjJ4dUhVz6/GofNT2uS+
         gtlZW3V3BzoM1kDIDe7NrmiZu29pWSP08Wd0aNkpfnDrvX93nQCAmivKpEPYagwvd5lb
         eH9TGsAehGKOShIMeVrhejm8U1GY4iiwkdnU64a1ElBUZfStjKs7VJwZK1YTvWrA+eKs
         0EtBwnzirGBJ+Ua3UN9WqMFo3+DakW6RRkPj20y8Am98O1vfBq9uGGs3XZ16+lw0MlJC
         2EJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q2rfqyxzbAcyxqLFd6JKu8YmoUH0ekLJQzwElkcFGEc=;
        b=Fgts3ZVA4vbOpe0qq1Gjli3GYdcITnKRUAHQNq3uThx8/TqfN/JBqD86FMwLHssyKB
         ebmtbLKeQKlgNtjO0a9NdUNPPqFq6hs6sSEcxQas+5vmVqnDAEETPCbjtXch4/HUslac
         DEQSRgE1xOOx3FKuTORjh7zeU4zf33lK8jRPNI3Q5/EMPibq6HxZlZsVMmklAwHvXk/k
         ZwzU/1efe7bX4jY3gFjA5umY8Ufa+tTraEYRhRXvjRcr5+Brsd5R1jVCuiJTDlToB1B9
         KS7RtlHvAWkYMtjI2bRZSYlvvr+shXsmmRPgeNpXGqKjGjSqN6wfhObzvbIOzYDKRvr5
         xyQQ==
X-Gm-Message-State: AOAM532dWYXnAZO0xuy5trK5/DSk9x1qFEoykAUsu+LP4WQUXcXgtIQg
        92IGjQTaPSOWAfmy3LjD8FQZiuL0EkGeMP4MhS4=
X-Google-Smtp-Source: ABdhPJyaPJJrGOFuAS8tlWg9r1k1kfK1XF81UOYtSDvPYcEsAi3wi65tZFAO3QghycRz3g0l4Xm9rUMj4v3n7uofOE0=
X-Received: by 2002:a05:651c:548:: with SMTP id q8mr7034406ljp.256.1612671770705;
 Sat, 06 Feb 2021 20:22:50 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
 <87h7msnnme.fsf@suse.com> <CANT5p=qGTC4E4Rf_-t9xXOo4yf3W=xtk97J1jg-WRLhwf0juBA@mail.gmail.com>
 <87a6sjopsc.fsf@suse.com> <CANT5p=qQJwvF11MJpiuV7S1GpH9=HZ-g=hmfOV-a07N9xkYqnA@mail.gmail.com>
In-Reply-To: <CANT5p=qQJwvF11MJpiuV7S1GpH9=HZ-g=hmfOV-a07N9xkYqnA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 6 Feb 2021 22:22:39 -0600
Message-ID: <CAH2r5mv0TzWpYi38HtuVG2gtYvW60-RDOri3a1FUUtprn19Dzw@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: Reformat DebugData and index connections by conn_id.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

the multiline strings if they make it more readable are fine (probably
fine here), so can ignore
  "quoted string split across lines"
warning

On Sat, Feb 6, 2021 at 10:14 PM Shyam Prasad N <nspmangalore@gmail.com> wro=
te:
>
> Attached patch with a few formatting changes per checkpatch.pl.
> However, some of the multi-line strings look better when the strings
> are in separate lines. Please let me know if you still feel they
> should go into a single line.
>
> Regards,
> Shyam
>
> On Thu, Feb 4, 2021 at 6:45 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
> >
> >
> > Code looks ok.
> >
> > There are little style issues reported by checkpatch.pl: Trailing
> > whitespaces and comma+space stuff; ignore the columns ones.
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
> Regards,
> Shyam



--=20
Thanks,

Steve
