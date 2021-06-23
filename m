Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A8FC4743C
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 14:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7DC56101D
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 14:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhFWOU1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 10:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFWOUU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Jun 2021 10:20:20 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA12C061574
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 07:18:01 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id h15so4309219lfv.12
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 07:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QgTNCq6SO6GhkfqYgn9S0tUYxSMqVkTJ/5LDnIzUxDw=;
        b=E909bW1pSYPO+HYqMkMc/7HpwDx+wk+YAYsAy9+7dKl6skel6bgGEFHPEzoc3f3tX1
         7UUA7YOvg38tjYB6pJt+K76as5oQX+k0PsqQ5ccb5cdQOY9T/qQ3wzb0O9optZgX+4K0
         WKMnkgEnHS9b1mVGgeC/BVhVfPmNHRLg68ff7YeT9yYTKpeGTsvmRTqBwDH6hPfLWiPe
         66Ib8uzXXydGY4dJKc0Rat2/xdHDGTDdq8iRV41Ud2TpCFwgYosMj3JoDaeFXJ6jgDyx
         mRxo/NMGSVAlPzTzLcPrhIB1I/CBRfedEnakSjqp6Jky8aDr6zpEgKu8FTST+Mua5L1c
         SP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QgTNCq6SO6GhkfqYgn9S0tUYxSMqVkTJ/5LDnIzUxDw=;
        b=LnEVWOufPDrHzeUJ9F1z+kOzJ1Bh3uAtppWrPq8acnqF9+VE3GOxbuRoRgiXeZkdas
         ak2M33kUHsYBQzIrbdQztGJqvomPRblNggJX5i+bTNPY9JRwMHuOCwwSfNm/oHoK4z8M
         HhwoQ/1LPY7KIHz0PLHtJffZ7t6c+wjj4doXn6xMsG6tv1vCuoTwD1pIE7sFpVrAAQ7+
         y7lpe3+Dg7WpLL10Y2L3rMcGhnQY0SCT7uDE8RFiEdnw8jMSmRaAyvdMTSCFyWa/4/zX
         0tDARfhXiAGPBeaeTnQnG3guJgRoO28TBeWOab5ux5sBqSvZk6AmZ5NVlROJ6wkSQ/S6
         L6LA==
X-Gm-Message-State: AOAM530TX5Xf96Nh8Db7m7xYQfehRw5R5TvlmdRMgSIDjEEdcIjOTvx+
        THRTu+eqxkjp/t5MZ5d/vl6BwB5dNaRL4FEZu6w=
X-Google-Smtp-Source: ABdhPJxA/d46RE9H4GQTXzF/TNX3u/kTmlIGcqbnPxa9ZdfsrPMGrHdSkjFe5TbP4CLzJMh6fWtkTMMP/NlorTYdmQM=
X-Received: by 2002:a19:f705:: with SMTP id z5mr7122987lfe.395.1624457880054;
 Wed, 23 Jun 2021 07:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms_paV2a7KZwWkmz25pn4iS2kEDErGpNapOWZ5Kd_bUNw@mail.gmail.com>
 <87bl7wreou.fsf@suse.com>
In-Reply-To: <87bl7wreou.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 23 Jun 2021 09:17:49 -0500
Message-ID: <CAH2r5msXgL5PZB8k99MJW-u5bNbHY9QxS8hKUasRqYTYR-z0bQ@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Fix uninitialized pointer access to dacl_ptr in build_sec_desc
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jun 23, 2021 at 6:41 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Steve French <smfrench@gmail.com> writes:
>
> >     smb3: fix possible access to uninitialized pointer to DACL
> >
> >     dacl_ptr can be null so we must check for it (ie if dacloffset is
> > set) everywhere dacl_ptr is
> >     used in build_sec_desc - and we were missing one check
> >
> >     Addresses-Coverity: 1475598 ("Explicit null dereference")
>
> Looks OK since dacl_ptr is only set if dacloffset is set but it would
> be clearer if you check for dacl_ptr directly no? Any reason you are
> checking this way?
>
> I think this is clearer, unless I'm missing something:
>
> ndacl_ptr->num_aces =3D dacl_ptr ? dacl_ptr->num_aces : 0;

I agree that your suggestion is clearer but I was trying to match the
existing checks in the same code.
Will change both to your suggestion which is clearer.


> >
> >
> > --
> > Thanks,
> >
> > Steve
> > From ec06cb04376e5abc927a9b85dd768ce8728965bb Mon Sep 17 00:00:00 2001
> > From: Steve French <stfrench@microsoft.com>
> > Date: Tue, 22 Jun 2021 17:54:50 -0500
> > Subject: [PATCH] smb3: fix possible access to uninitialized pointer to =
DACL
> >
> > dacl_ptr can be null so we must check for it everywhere it is
> > used in build_sec_desc.
> >
> > Addresses-Coverity: 1475598 ("Explicit null dereference")
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> >  fs/cifs/cifsacl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> > index 784407f9280f..25a8139336fa 100644
> > --- a/fs/cifs/cifsacl.c
> > +++ b/fs/cifs/cifsacl.c
> > @@ -1308,7 +1308,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd=
, struct cifs_ntsd *pnntsd,
> >               ndacl_ptr =3D (struct cifs_acl *)((char *)pnntsd + ndaclo=
ffset);
> >               ndacl_ptr->revision =3D
> >                       dacloffset ? dacl_ptr->revision : cpu_to_le16(ACL=
_REVISION);
> > -             ndacl_ptr->num_aces =3D dacl_ptr->num_aces;
> > +             ndacl_ptr->num_aces =3D dacloffset ? dacl_ptr->num_aces :=
 0;
> >
> >               if (uid_valid(uid)) { /* chown */
> >                       uid_t id;
> > --
> > 2.30.2
> >
>
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
