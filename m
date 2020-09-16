Return-Path: <SRS0=zmi3=CZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B440DC43461
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Sep 2020 20:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57EAA2087D
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Sep 2020 20:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UEA51e3C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgIPUt2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgIPQ6x (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Sep 2020 12:58:53 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6E1C035433
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2020 09:17:37 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id s19so5825580ybc.5
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2020 09:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QvqMZZbehGU480XHJh/s30Ptd76/W0ORw+Qbz/0V5Qo=;
        b=UEA51e3CxfA7556R/xsloNZAAG96Lg369ezJw7V82WOCXZgwac2iXEEtokXTOVvAx5
         zo+3KkVmeg0lzB+DfpnmcRTMTyJkPjZxvlcY1eP2yX7dA2s5V9Bp995TYggtu1nYQYnn
         EEoHC1XLqOlOAz2dGzVjI6LBgB1QhjgQJLkAx0EikFjESXHJejbdp8gBvpbMOjy660Gp
         NiEqgrWAtE4AkeGRtD29Tdn0qq1R1+1Rw7wDUWmprDWcUSLiGirHKvcOuvJsnLNuHHuZ
         3k3ajAGSSalEZ1ttOkc5kin/meCv3wrk8rJLjKDBDX5uBUqyiErdhjmUBJ5NFI9xt9fV
         CkmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QvqMZZbehGU480XHJh/s30Ptd76/W0ORw+Qbz/0V5Qo=;
        b=LbCvxvV8UhdUFxubQgL/ZVmmHPfbdc67qKC10Czo+c23vPxvQPG795cFu6/EuMV4k9
         sFaWzXJMNkzZ++nigsNzna8HlR61tUKfiWsEWhhM7/EOd97PjzvNcM3SSgLSSvNpHSDM
         VtWGj16w3uWQ/Pkl+EZgqpgly662JNyWTLNFMWLoKSCTh/XoMoRTE9SDfu72RS8FaHw3
         2wLJFsn3q1H+e0BYhtpSN0gsjlmWMt/Q7VOKF2Ea4nZXuL99d5Q3RzeW0wEy4VXDzdPS
         zzeb+FIyJMyF6rr2/oMb7JZDdKzCadMtEvWWg5YsNw8ETXwKcaIMm4ahEikrhhhLil1z
         iz9A==
X-Gm-Message-State: AOAM5316VoysdnteTrXu8caefeqYqFs6U3Bew2uhKBGtWThTD1aJ9OMB
        939VndQIrjMnLC2WTN6TikKtcuYZ9G8zuIFfm9nadpG64U6RQQ==
X-Google-Smtp-Source: ABdhPJyyL0OhXI+3KzTYmMrNSp9UM1maWxc6Ubj1OVHjjAba2NvJSAyhOAItyYiT5GvlA2KvS5uKTKYC3j1eXCQTF3k=
X-Received: by 2002:a25:54d:: with SMTP id 74mr34669758ybf.331.1600273056634;
 Wed, 16 Sep 2020 09:17:36 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oiTY63d5yVyywiTrCqpAmvaugMVVpQRV7RT7ZA9HU2+Q@mail.gmail.com>
 <87r1r2ugzw.fsf@suse.com>
In-Reply-To: <87r1r2ugzw.fsf@suse.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 16 Sep 2020 21:47:25 +0530
Message-ID: <CANT5p=qV6BWojwBET+kYUwJf7tQDFoRtUb8O+pWHrqWMw5e5LQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs: use SUDO_UID env variable for cruid
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Aur=C3=A9lien,

Thanks for the review. Please read my responses inline below.

On Wed, Sep 16, 2020 at 4:26 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > This is a fix for the scenario of a krb5 user running a "sudo mount".
> > Even if the user has cred cache populated, when the mount is run using
> > sudo, uid switches to 0. So cred cache for the root user will be
> > searched for, unless cruid is specified explicitly. This fix checks
> > for cruid=3D$SUDO_UID as a fallback option, when the mount fails with
> > ENOKEY.
>
> The idea seems good.
This was Pavel's suggestion. :)

>
> > @@ -2053,7 +2066,24 @@ int main(int argc, char **argv)
> >               parsed_info =3D NULL;
> >               fprintf(stderr, "Unable to allocate memory: %s\n",
> >                               strerror(errno));
> > -             return EX_SYSERR;
> > +             rc =3D EX_SYSERR;
> > +             goto mount_exit;
> > +     }
> > +
> > +     reinit_parsed_info =3D
> > +             (struct parsed_mount_info *) malloc(sizeof(*reinit_parsed=
_info));
> > +     if (reinit_parsed_info =3D=3D NULL) {
> > +             fprintf(stderr, "Unable to allocate memory: %s\n",
> > +                             strerror(errno));
> > +             rc =3D EX_SYSERR;
> > +             goto mount_exit;
> > +     }
> > +
> > +     options =3D calloc(options_size, 1);
> > +     if (!options) {
> > +             fprintf(stderr, "Unable to allocate memory.\n");
> > +             rc =3D EX_SYSERR;
> > +             goto mount_exit;
>
> This function later forks, so if you allocate before the fork, you need
> to free in parent and in the child.

Good point.
I think I'm doing it right though. I allocate all that I need at the beginn=
ing.
And the function always terminates in mount_exit, both for parent and
child. That is where the allocations are freed.
I know the child will have the options buffer unnecessarily allocated,
but isn't the code flow simpler this way?
Please let me know if you see an issue there.

> > @@ -2228,6 +2252,7 @@ mount_retry:
> >                               if (nextaddress)
> >                                       *nextaddress++ =3D '\0';
> >                       }
> > +                     memset(options, 0, sizeof(*options));
> >                       goto mount_retry;
>
> Altho not wrong this is a bit misleading as options is a char*. If you
> do a memset do it option_size, or do options[0] =3D 0;

Got it. Will do.

>
> >               case ENODEV:
> >                       fprintf(stderr,
> > @@ -2250,6 +2275,21 @@ mount_retry:
> >                               already_uppercased =3D 1;
> >                               goto mount_retry;
> >                       }
>
> Need to reset options again before goto I guess. Maybe reset option
> after the retry label?

Good catch. This code existed before my changes, and I had noted this
bug. But forgot it during my changes. :)
I was actually confused if I should reset after the label, or before the go=
to.
After the label is an added overhead in the "happy" code path, so went
with this. But it does reduce the chances of missing out a reset.
For now I'll reset options before each goto mount_retry. Please let me
know if you feel the other approach is better.

>
> >       }
> > -     free(options);
> > -     free(orgoptions);
> > -     free(mountpoint);
> > +     if (reinit_parsed_info)
> > +             free(reinit_parsed_info);
> > +     if (options)
> > +             free(options);
> > +     if (orgoptions)
> > +             free(orgoptions);
> > +     if (mountpoint)
> > +             free(mountpoint);
> >       return rc;
>
> free(NULL) is defined to be a no-op, you don't need the checks.
Sure. Will do.

>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
-Shyam
