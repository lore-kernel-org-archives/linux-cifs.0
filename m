Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3540FC433C1
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 16:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08E4A61949
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 16:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbhCSQw6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 12:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhCSQwm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 12:52:42 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30764C06174A
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 09:52:42 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id b83so11011361lfd.11
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 09:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EJqA6ZTPH/dKVWuvPduq3w1nBZQlz0wZ2NlwVBHaLbc=;
        b=PzlA5QZthjyibYf1bNUgglfZKss4DJIYOHDTsGf4K4MvBWTr0+UFDzPmq7G5adqNUc
         s9RazQHg2Nqiv9JFSPx8l8RW/Fumma6S0c3Gd28fyenqf4yz9mQ74gp4/l8a/GmCd8d6
         D3yBMhY4eXBPnIQrjAGWAFLogtRBkNj79Sh/nHRzJvKLdIGLadl5m1GFRmi4pIOLPHZC
         AItFoQdieQArjU/6bWKJHhUKz67iy++OLdmsnQKOyraT4WD7RyT/lO6Qkl7EDUuD4bXa
         eQtHUf+YA7qFXIDdtElsF78SGSmsCOgpbvNvAZ5ljjI6WvA5mTtTriAGJGV1tjFGUewp
         83lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EJqA6ZTPH/dKVWuvPduq3w1nBZQlz0wZ2NlwVBHaLbc=;
        b=UJFLC0HmKne8kUKimearjKLhD3lQLEybto8hqRS5tKjcVIQyaWUC62VjXg08aeT1Gj
         OzJoZLWTNTo1YzrO/wNuNfgVnY+lgN9pOonIDx2qhPAYS6k3TNp1mswTC7cBb4aU0WU5
         SKZa9iXy4bhbakFs/83z64TZT3IlYKI56u9L/q2c2st9wTByaIpuY0y62Ug1L6xnNx34
         KUMGA4tkjWRyrE5A2jY4ktafj8/lr2HHCZfXp5ct9qc0AjHsJAvOQiW/YtYu3yAjJO83
         Bi8pI01VRHaNsDFSPh2iGQmxjLDlRCAhGXr/FDDDM5YcHMB4WNQkl1GvcWCsZtKDdrrj
         shsw==
X-Gm-Message-State: AOAM532ObET8kkPhsQudqCojIyImfkWCZbYV6b5sdcgD9dAAEFVBV26t
        IZ7Qb1c5Y/IyIj7Od6qpSz671NpTjGm5393hUaaU8GDnhto=
X-Google-Smtp-Source: ABdhPJxdEMK9QGmep5ndtpKO+xFi/IBkrAqALodTEdL9E/x60RUu0pKuXxZi5BRKus4YMAY5Vb6b9ubQshX5+2E4OAU=
X-Received: by 2002:a19:404f:: with SMTP id n76mr1361152lfa.184.1616172760672;
 Fri, 19 Mar 2021 09:52:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv0kMa__3-KvRRE20OZ3R=cnOFVbrAzVyRA0zpXsbaBiw@mail.gmail.com>
 <87blbfrtif.fsf@suse.com>
In-Reply-To: <87blbfrtif.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Mar 2021 11:52:29 -0500
Message-ID: <CAH2r5muT6BLymqf56euuM1MYh3O9xa4bw1uoFE5HKq71ggsQrg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix allocation size on newly created files
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

patch updated - thx

On Fri, Mar 19, 2021 at 11:35 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
>
>
> I gave it a try and it seems correct, alloc size is zero without the
> patch, despite size being >0.
>
> The estimate seems reasonable, it will get updated when cache timeout
> runs out.
>
> Server is supposed to return newly allocated blocks on Close Response
> but I see it's zero on Windows Server despite file size being >0 (maybe
> server bug).
>
> In any case change looks ok, you can
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> But little nit picking on comments and useless final hunk:
>
> Steve French <smfrench@gmail.com> writes:
> > + /*
> > + * i_blocks is not related to (i_size / i_blksize),
> > + * but instead 512 byte (2**9) size is required for
> > + * calculating num blocks. Until we can query the
> > + * server for actual allocation size, this is best estimate
> > + * we have for the blocks allocated for this file
> > + */
> > + inode->i_blocks =3D (512 - 1 + attrs->ia_size) >> 9;
>
> I would put in the comment: number of 512bytes blocks rounded up, much
> easier to read.
>
> >
> >   /*
> >   * The man page of truncate says if the size changed,
> > @@ -2912,7 +2920,7 @@ cifs_setattr_nounix(struct dentry *direntry,
> > struct iattr *attrs)
> >   sys_utimes in which case we ought to fail the call back to
> >   the user when the server rejects the call */
> >   if ((rc) && (attrs->ia_valid &
> > - (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
> > +     (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
> >   rc =3D 0;
> >   }
>
> You should remove that hunk, it's not doing anything
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
