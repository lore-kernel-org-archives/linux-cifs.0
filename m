Return-Path: <SRS0=LgxW=YI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5E1C10F14
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Oct 2019 04:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2A9B2089C
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Oct 2019 04:53:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="da1+odWx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfJOExv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Oct 2019 00:53:51 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46053 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbfJOExv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Oct 2019 00:53:51 -0400
Received: by mail-io1-f65.google.com with SMTP id c25so42887005iot.12;
        Mon, 14 Oct 2019 21:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FoyKK6+CZHtzLvyc+hXa9rZT9/61RNMGYHQKvCgAsn8=;
        b=da1+odWxWl7gUFhDl9t6DAPPjvv49NvV4J800iLoARhJP8025HZn3Kxd/DL6c6uO8P
         GFWRHn1nDwbjzHP+Fy5RLnWWBYInr8ZrFkwjETeXTznLEa6Mrf3oTePwZie/0zzI3pq8
         3H556MItZnzFM0oZIjoEL2ydVfi+OEpbzBIkpW9E1PGbwFNf2MMU/kKgQ6aRozQRiQIm
         ygkRH2h/xDqS2hvCa1UD0WRTidtODYmBjAnoBRKHvdEMZmoPnufZNxqLzh2MKuoLocHb
         7ZrwAP92LrsOk1ywJCXH6FKRFORrdKoRtUNICv1A69XGGWNgjAjD6us1nCtDSsPDvszE
         SQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FoyKK6+CZHtzLvyc+hXa9rZT9/61RNMGYHQKvCgAsn8=;
        b=XUeanHdwJ+UV1GKqS3qvFEpi1OLMs7nNtA7f/mqjm8I9hqycx83xmkp8H2yNJkBo5x
         nB5Fdsiat48Ye3yvK0q0VQW1mV7FDbTBnPsRtEQuietbgqA6jpglYRrgEWI6KGq4Odfy
         sbcrpsWT8i/JyS1e88fMtxC2Q6gVgMXluJUV6NiXc8QIPlWWCrSjkhu6wdyVvsDq/Yhv
         adT8eu6K8CMYFRClZSGACKRVcomSylMTe9/3NeyUG4HeXhnAHMRivb6H/eaqMBRTR4B4
         txzr4ao8Yo4n0mp+rSlm7vtu69em0FP4eyURO9clEbZJ7TkGJt+/yIf4mYN/Hhy5HVPW
         6YgA==
X-Gm-Message-State: APjAAAWE/tx11O7I/LrSWgA+PbWPk+zzSztz3Pg7CqBYD7LFSzvXGn96
        DHVLAEQcz046+73z2n0CQphVDiytdRJLlUu+xVk=
X-Google-Smtp-Source: APXvYqyQZ42Wzz4Mil0VtK34oFTpJ7nzC1L+Te3pMJBnDtnnJhfH6Tb5NGwSDCztaKyQCoaC83210VSdDSzpC57w4ow=
X-Received: by 2002:a6b:fa12:: with SMTP id p18mr14453335ioh.272.1571115230075;
 Mon, 14 Oct 2019 21:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <20191014071531.12790-1-hslester96@gmail.com> <CAKywueQY-J3g0RBF4=opP8SbhpWh-BHoHWzNEeTruxmfacnhGw@mail.gmail.com>
In-Reply-To: <CAKywueQY-J3g0RBF4=opP8SbhpWh-BHoHWzNEeTruxmfacnhGw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 14 Oct 2019 23:53:38 -0500
Message-ID: <CAH2r5msPBvF298mWgz_1Jx9svHY1NyqNti4G9TUaNdEqg=A=CQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix missed free operations
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into cifs-2.6.git for-next and cc: stable for 5.3

On Mon, Oct 14, 2019 at 4:43 PM Pavel Shilovsky via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> =D0=BF=D0=BD, 14 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 00:18, Chuhong Y=
uan <hslester96@gmail.com>:
> >
> > cifs_setattr_nounix has two paths which miss free operations
> > for xid and fullpath.
> > Use goto cifs_setattr_exit like other paths to fix them.
> >
> > Fixes: aa081859b10c ("cifs: flush before set-info if we have writeable =
handles")
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > ---
> >  fs/cifs/inode.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > index 5dcc95b38310..df9377828e2f 100644
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -2475,9 +2475,9 @@ cifs_setattr_nounix(struct dentry *direntry, stru=
ct iattr *attrs)
> >                         rc =3D tcon->ses->server->ops->flush(xid, tcon,=
 &wfile->fid);
> >                         cifsFileInfo_put(wfile);
> >                         if (rc)
> > -                               return rc;
> > +                               goto cifs_setattr_exit;
> >                 } else if (rc !=3D -EBADF)
> > -                       return rc;
> > +                       goto cifs_setattr_exit;
> >                 else
> >                         rc =3D 0;
> >         }
> > --
> > 2.20.1
> >
>
> Looks good, thanks.
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> The original patch was tagged for stable, so, it seems that this one
> should be tagged too.
>
> --
> Best regards,
> Pavel Shilovsky
>


--=20
Thanks,

Steve
