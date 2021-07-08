Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA21C07E96
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 23:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70A0261404
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 23:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhGHXDP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 19:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhGHXDO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 19:03:14 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1802C061574
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jul 2021 16:00:31 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h2so10927983edt.3
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jul 2021 16:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=egBQV/UTnq3JvtZrbjOtzTHsPbXsP+bJv/M7KPYEAG0=;
        b=igfI1RgbJ4izyrSL8cF2oevdWoWTxBqLP/jm5XDY8V4se1dV4VrxXpE4gYSw/cgjis
         dRcHY08Nzka3o1Po2061DstZ5vMrOvKyxE268P4Oehpstb8C4AMXg0G38hVyAAMDYthg
         hdhd4tsM9XBeLPXa1x5P2JyDjP69CWrPJ+9tnvvPkosME6P3fWZjik+uPLXH24tc+ZLG
         u8SVIXthjTmDJSx8bAD66AK5TQGx/X9oBaYdg96VJ+EUmTORFWg7KdGMscgydqnU9ZQz
         wHKgNCn/z1eFB4k/b5mCgJF0nXByQZcWOTUld6lmZSFU66pUhGct9d080b14JqHv/zc9
         lxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=egBQV/UTnq3JvtZrbjOtzTHsPbXsP+bJv/M7KPYEAG0=;
        b=fPS3+PyF8yVsbEfboosR3OHthUxRtjsICjT5BdLfTx2cL0uymcDk+ZJlA+h4WD1Mgh
         HixcfQzCavqgikFVW0QN1kcGxBtwMyzOK17eDPBOUGMdHDjdXf/WajSDQMBnZ/IGL0ks
         vYFMDvElhgujGFe/lcgoiJJb8Y7wRGd41fZLVHVRKKkMuoV/WfTMIh+GR3y0VqlYAIkT
         vTg9FlBH2ihWK0cwpeSg2+WE9bko1wEfoY2YEbHITFG9bL8ILW1yz8sp5fCAJGoTiQGS
         HOrXhlxLwo/4WIZ/XUp6oXdcvcfK9wphmAeB481sY6QIYcO+zZTwglCdTVxE9RE9GOt/
         MyyQ==
X-Gm-Message-State: AOAM531vxphJGfSZWtBodK1CbKqUOTI3jGYHJSFrn3hwTv4579oy4t6t
        79rby8HQsLBOrgoKJV3WqBdug3z2ZRRwsHCvmg==
X-Google-Smtp-Source: ABdhPJwv2NxDe/OH+6ifG2zzLwE4Ucv0raLAOyYH6KJYL960Aqk3tv+8sIlSTnLCZ0If79oHDXEEyGAkGHF+MfqeD48=
X-Received: by 2002:a05:6402:3089:: with SMTP id de9mr40688682edb.384.1625785230183;
 Thu, 08 Jul 2021 16:00:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210511163952.11670-1-pc@cjr.nz> <8735uttb7s.fsf@suse.com> <877dk5jfny.fsf@cjr.nz>
In-Reply-To: <877dk5jfny.fsf@cjr.nz>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 8 Jul 2021 16:00:19 -0700
Message-ID: <CAKywueQV6AeQmN7v489oudW7NYQuJmt1xryuQvUZnpR+MjXLXQ@mail.gmail.com>
Subject: Re: [PATCH cifs-utils] mount.cifs: handle multiple ip addresses per hostname
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Paulo,

Are you planning to post another version of this patch? If there is
already one HI which I missed, please let me know.
--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 11 =D0=BC=D0=B0=D1=8F 2021 =D0=B3. =D0=B2 11:20, Paulo Alcant=
ara <pc@cjr.nz>:
>
> Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
>
> > I would put in the commit msg that this requires recent kernel.
>
> Agreed.
>
> > We should probably merge kernel code first so we can reference it here
> > in the commit msg, and say in the man page when did the kernel change.
>
> Agreed.
>
> > There can be cases where cifs-utils is more recent than kernel and
> > mount.cifs will pass all the ip instead of trying them before passing
> > the good one to the kernel but since it's an old kernel it won't try
> > them all.
>
> Good point!  Yes, we should handle both cases.
>
> > We could add an option to enable new behavior or check the kernel
> > version from within mount.cifs.. thoughts?
>
> I don't like the idea of checking the version because the running kernel
> might not have the expected patches.
>
> Perhaps a new option would be better... I'll think more about it.
>
> > Paulo Alcantara <pc@cjr.nz> writes:
> >>
> >> +static void set_ip_params(char *options, size_t options_size, char *a=
ddrlist)
> >> +{
> >> +    char *s =3D addrlist + strlen(addrlist), *q =3D s;
> >> +    char tmp;
> >> +
> >> +    do {
> >> +            for (; s >=3D addrlist && *s !=3D ','; s--);
> >> +            tmp =3D *q;
> >> +            *q =3D '\0';
> >> +            strlcat(options, *options ? ",ip=3D" : "ip=3D", options_s=
ize);
> >> +            strlcat(options, s + 1, options_size);
> >> +            *q =3D tmp;
> >> +    } while (q =3D s--, s >=3D addrlist);
> >> +}
> >
> > I think you should write this in a clearer way and comment, this is har=
d
> > to read.
>
> That's horrible, indeed.  I'll definitely make it readable in next
> version.
>
> > I was going to say should we return errors if we truncate the ips, but
> > none of the mount.cifs.c code checks for truncation so I guess we can
> > ignore.
>
> IIRC, yes.
