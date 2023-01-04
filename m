Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568DCC46467
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Jan 2023 06:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjADGQP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Jan 2023 01:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjADGQO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Jan 2023 01:16:14 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2A1FE3
        for <linux-cifs@vger.kernel.org>; Tue,  3 Jan 2023 22:16:12 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id s22so34465231ljp.5
        for <linux-cifs@vger.kernel.org>; Tue, 03 Jan 2023 22:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3BavZglX0MPdgww54nttciFXCCwjf30VKpnky7JodDU=;
        b=Qq79tdd0yaMmHaZS5CCz9PBJlAk+Jf22rxPTc+IbPrbIaSvvLtAh5QSFvA9kz2Wlk1
         UVVtAqTO+mTALd1PqyQtyeBxLOuIidTjasPHSnfiDFJ42vCEZvoX693tBhvS1n5faX3f
         cKuJJ7knluPcW2fLqqfeGYa0/vMTJjUolL8pSWH9SrJvipIQVitww2za4hf9Vl26CYa5
         GYPVGftcdse+wdjTxs+4/mCaQ2FYrk2huSUzJpRTN8Fe9SP41wcAZBIk1Kx3gwA4aeq0
         vPA4XwjzU5ij9R8LkB+cxHAjH/a1aa9ht0Swd6gkz0105dB/5kGh9f5oIRLrEXi2UHqV
         BlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3BavZglX0MPdgww54nttciFXCCwjf30VKpnky7JodDU=;
        b=7Bzhob8UL9lVXrb05VSglVqBlh+CmVGx+KTJpx9WqmmGWiTKyvYdITOYO/zJrk9Abb
         HOZQyXkPiokoIm4PITGFUaw9V5bQkNsgrssnz5kaXTey+oEOzmCWCWUL7vO9SzetobJu
         ihVlkHlNkv4OScZSwaOLpGwlJFavs+rIxWGhUGr8UrI8KCxwDu3yluBiShUpQCc1a5LV
         R13k47UTkKeUktS8tXZaGOGFBzKsjw+fabslBraoQW5dT66mcWQIN69FIHTYa8byiIGg
         V0BKN6HRdjZgPE/WZPHGpj/Sxwg5kcyxUDgGNDTo9oEu3qcLZ/14afg7qmKXi/03yl6I
         czyw==
X-Gm-Message-State: AFqh2krfFNq88CyQpOGvngNUxT+PkfFGy06n7nlqhV7/pkxikuOOyTdo
        YR8mB6JyuuLdXBS90/uOsEaTM/34wzzYgnVH9Rk=
X-Google-Smtp-Source: AMrXdXuPZ2NjRL9c4q75G634zp+LrTt7Gko+NpayLpKB4m/3fmH1i5M+NaX/IcI0p+zg6t3FzzaojvJY0uB+impGCjE=
X-Received: by 2002:a05:651c:204f:b0:27f:dfc2:5037 with SMTP id
 t15-20020a05651c204f00b0027fdfc25037mr693060ljo.229.1672812971164; Tue, 03
 Jan 2023 22:16:11 -0800 (PST)
MIME-Version: 1.0
References: <20221229-cifs-kmap-v1-1-c70d0e9a53eb@intel.com> <13173438.uLZWGnKmhe@suse>
In-Reply-To: <13173438.uLZWGnKmhe@suse>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 4 Jan 2023 00:15:59 -0600
Message-ID: <CAH2r5msJRmfwAnh1p23sN0VVkAJ7oovxxOYA3vUr+0o_p4WKog@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix kmap_local_page() unmapping
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc:     Ira Weiny <ira.weiny@intel.com>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending testing

On Thu, Dec 29, 2022 at 4:38 PM Fabio M. De Francesco
<fmdefrancesco@gmail.com> wrote:
>
> On gioved=C3=AC 29 dicembre 2022 23:04:46 CET Ira Weiny wrote:
> > kmap_local_page() requires kunmap_local() to unmap the mapping.  In
> > addition memcpy_page() is provided to perform this common memcpy
> > pattern.
> >
> > Replace the kmap_local_page() and broken kunmap() with memcpy_page()
> >
> > Fixes: d406d26745ab ("cifs: skip alloc when request has no pages")
> > Cc: Paulo Alcantara <pc@cjr.nz>
> > Cc: Steve French <sfrench@samba.org>
> > Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
> > Cc: linux-cifs@vger.kernel.org
> > Cc: samba-technical@lists.samba.org
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > ---
> >  fs/cifs/smb2ops.c | 9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index dc160de7a6de..0d7e9bcd9f34 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -4488,17 +4488,12 @@ smb3_init_transform_rq(struct TCP_Server_Info
> *server,
> > int num_rqst,
> >
> >               /* copy pages form the old */
> >               for (j =3D 0; j < npages; j++) {
> > -                     char *dst, *src;
> >                       unsigned int offset, len;
> >
> >                       rqst_page_get_length(new, j, &len, &offset);
> >
> > -                     dst =3D kmap_local_page(new->rq_pages[j]) +
> offset;
> > -                     src =3D kmap_local_page(old->rq_pages[j]) +
> offset;
> > -
> > -                     memcpy(dst, src, len);
> > -                     kunmap(new->rq_pages[j]);
> > -                     kunmap(old->rq_pages[j]);
> > +                     memcpy_page(new->rq_pages[j], offset,
> > +                                 old->rq_pages[j], offset, len);
> >
> FWIW, it looks good to me...
>
> Reviewed-by: Fabio M. De Francesco
>
> Thanks,
>
> Fabio
> >               }
> >       }
> >
> >
> > ---
> > base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
> > change-id: 20221229-cifs-kmap-6700dabafcdf
> >
> > Best regards,
> > --
> > Ira Weiny <ira.weiny@intel.com>
>
>
>


--=20
Thanks,

Steve
