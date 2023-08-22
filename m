Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB71EE4996
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Aug 2023 15:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbjHVPKH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbjHVPKH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Aug 2023 11:10:07 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A876198
        for <linux-cifs@vger.kernel.org>; Tue, 22 Aug 2023 08:10:04 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id 006d021491bc7-56f557e9e84so2177790eaf.3
        for <linux-cifs@vger.kernel.org>; Tue, 22 Aug 2023 08:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692717003; x=1693321803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1lZgbYgN8ofCL7AsgWLNizh1gtl3+nW1cZvHVqIf9NM=;
        b=sT32MG03tISgPKcfBZIYvTG/YDdyoX/wx1ITh1ZHhIrJeou/didcTVKAlnJNbShGOn
         99Y3HUxpXfrbmomLGIqGPxSfdlplYWqN+7mr+ScBSy1VC+NaWWQcbEycxDDrZyZYAZnq
         BUbbBX8y9l6nIy2uX7YKgLdYincRMGHxQmRBS6vB/FUbMqGGMWFPIsRPaUUpGXewx8fS
         bBe++yJ5jARYdGEGhNXFrDfaNXgexT2KByzhylFgnlX9ERQFFD6eJ5xw2wanuVd+U5NS
         7gAo0W1w0Q+Gh6Hnqh23v90s28X4Hg+Io0ZL8YZaWeibjBEp+VmriQ9bZ3Y9TIdKWBv4
         yCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692717003; x=1693321803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1lZgbYgN8ofCL7AsgWLNizh1gtl3+nW1cZvHVqIf9NM=;
        b=RkN0Hhz4bDhbAg6lG01VuEUVg3cmem4NE0r/eHhSy1e4ttXWyNuJpNIghKZS8or/wV
         v90GAC65oVxtj9YUVqEhOkRLqB3fsyswlP3wisgn57FSLW6zZHSSLUYmfufgG/tzG4fu
         MDmykVP/3eoRPe5kWp6JRW39l078GcItbqbW6Rrfnb0emdoYSXZe6s6+68tcmcWm5E0e
         b4Kvv4mQtfBQXJ+WkQzgfYaaebXJa4npuufOmzLkiqezd5ZGfeTiDtwGn4F3tiy2/PoE
         S21zOG0f4e2YPjiAikEwU6U4YNw/nH1BI9gVL6BcyTR0346y0bwWdieQaiYGye+0SJwp
         PBrQ==
X-Gm-Message-State: AOJu0YzxSCKAGxRDgGbOEsuYrN8AFLfdpsyRbi2djtg+FMveKnWKhR57
        OuRAuUR1fUp9myinPn2XtOH9BLuuyqHXirsTvIk=
X-Google-Smtp-Source: AGHT+IEL3A6E6AYzZZRl+GimziOHnaZlTFJ6AsPyc0U9rL7NtGZ1O1mY1cvpEOSAICU0YF/Om2kB1WZPWA0oO247kr8=
X-Received: by 2002:a05:6358:63a2:b0:134:c8cb:6a00 with SMTP id
 k34-20020a05635863a200b00134c8cb6a00mr10542184rwh.12.1692717003280; Tue, 22
 Aug 2023 08:10:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230816202638.17616-1-bharathsm@microsoft.com> <CANT5p=ocZ1V-0buA7i8fJXYCMdWi5MZjQbvRJugmKMp+SHBpRQ@mail.gmail.com>
In-Reply-To: <CANT5p=ocZ1V-0buA7i8fJXYCMdWi5MZjQbvRJugmKMp+SHBpRQ@mail.gmail.com>
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Tue, 22 Aug 2023 20:39:52 +0530
Message-ID: <CAGypqWwxxOZAnKX49mmfOSPW_iytO7eYXEU_ypgyW-qmGsS6Og@mail.gmail.com>
Subject: Re: [PATCH] cifs: update desired access while requesting for
 directory lease
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     pc@manguebit.com, sfrench@samba.org, sprasad@microsoft.com,
        tom@talpey.com, linux-cifs@vger.kernel.org, bharathsm@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Adding smfrench@gmail.com

On Thu, Aug 17, 2023 at 3:12=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Thu, Aug 17, 2023 at 1:58=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.c=
om> wrote:
> >
> > We read and cache directory contents when we get directory
> > lease, so we should ask for read permission to read contents
> > of directory.
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/smb/client/cached_dir.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> > index fe483f163dbc..2d5e9a9d5b8b 100644
> > --- a/fs/smb/client/cached_dir.c
> > +++ b/fs/smb/client/cached_dir.c
> > @@ -218,7 +218,7 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
> >                 .tcon =3D tcon,
> >                 .path =3D path,
> >                 .create_options =3D cifs_create_options(cifs_sb, CREATE=
_NOT_FILE),
> > -               .desired_access =3D FILE_READ_ATTRIBUTES,
> > +               .desired_access =3D  FILE_READ_DATA | FILE_READ_ATTRIBU=
TES,
> >                 .disposition =3D FILE_OPEN,
> >                 .fid =3D pfid,
> >         };
> > --
> > 2.39.2
> >
>
> Looks good to me.
> Should also CC stable.
>
> Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
>
> --
> Regards,
> Shyam
