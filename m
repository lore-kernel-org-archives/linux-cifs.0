Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14B7C28D13
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Aug 2022 06:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbiHVGY7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Aug 2022 02:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbiHVGYx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Aug 2022 02:24:53 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD2A13E3A
        for <linux-cifs@vger.kernel.org>; Sun, 21 Aug 2022 23:24:37 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n7so11891743wrv.4
        for <linux-cifs@vger.kernel.org>; Sun, 21 Aug 2022 23:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=1SHgw3inDjC4xP0p2UkjWwqBI6y+REKQv8oF7J6LmbY=;
        b=QntkU/EwFTldfF889YuzPyGUcfBWHqmBJw/FRVo4ZIIUsfVhdCqcHxHjeuoU83s6DN
         IuMJuPUgo6ZB+Km6CBBTbE7ozd+H9wBRQamQZhhZYLe5o14If2Jn4nmtRcEn0MEjSbp+
         /9Uxe4781aCLWilbN2ZfhPuUpAVaxO7GmCA6peLVCB7jFf2ziTovQgbsF3FJKQmDmWjr
         cvPYHlR5clrQNTAhnSupCPgApCrWcX/bLssTguNIdpx0vJTt7DeI1T7jigT/WZ4Qnfov
         KtgNiKaUlIIf7M6FdVYasjWTQtslrjR1pIrTVNhC2rin2h3k0lebHVV0Gq03Wn7rg0nK
         LFtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=1SHgw3inDjC4xP0p2UkjWwqBI6y+REKQv8oF7J6LmbY=;
        b=f6muLld+LA/4NGxx8ZTVHftctPuNHsojwfryLKene3KI8j4RVZy1V9RbGO1mbp1emP
         XUVqYfz735M0mcVADokYYxjAIMpU2JU/Od9ug32bsvY5DOFXXlX2X3qe+9zvWLXvyhWj
         cAZmsyk6eX45Mu/X1sPEuIRg7YSOlXpH7iS+kk/PtMziX66OByQlgGbAhORw/MI1atLc
         GSw9O5Ltw9ZASXF04Zdo/KIJhfxwV3gaE34Fsw6ccwQszZ4hxuxNQUgCkzlg6+w6ERfx
         esn4dTOrkdBSEQfCqkqQ/U++ZEneIMFeGNyk+xzl20Lci21UnDeIIYe8WLcfOWqWknU/
         vN3g==
X-Gm-Message-State: ACgBeo1pvzoAo3LyTeWNm9CPTPrmx7JBvDWGvsXYLH5gSXz3U34Oh3th
        PDRyMcz2ZoYaR9d04iAUj3Rqq1JDKxRjXK0qiuA=
X-Google-Smtp-Source: AA6agR6WaezD/hVhfmiTiAkb4XxsRpBk9mndyFgRHNRw2CcPuvBPF2C9dJm2dIFlMltCkCNWhMk8gDSusOhxARWg8lU=
X-Received: by 2002:a05:6000:168e:b0:220:87da:c3e4 with SMTP id
 y14-20020a056000168e00b0022087dac3e4mr9681418wrd.559.1661149474099; Sun, 21
 Aug 2022 23:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220819043557.26745-1-hyc.lee@gmail.com> <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
 <CANFS6bZ1Xh+BTFDpWQdChcoY_5t5MwT5UMQ=tQupXmEeSO3kPw@mail.gmail.com> <CAKYAXd_Qd3jf_GwvzmZ+V+s--k-+T8HBD9HfvDvAesuv1vth2g@mail.gmail.com>
In-Reply-To: <CAKYAXd_Qd3jf_GwvzmZ+V+s--k-+T8HBD9HfvDvAesuv1vth2g@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 22 Aug 2022 15:24:22 +0900
Message-ID: <CANFS6ba3zUFW3Cju6zXiAoQ0jU_-oq=1EZLfwBCf9uGyqVzOKA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix incorrect handling of iterate_dir
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 8=EC=9B=94 22=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 11:47, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-08-22 11:14 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > 2022=EB=85=84 8=EC=9B=94 22=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 9:5=
1, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1=
:
> >>
> >> 2022-08-19 13:35 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> >> > if iterate_dir() returns non-negative value,
> >> > caller has to treat it as normal and
> >> > check there is any error while populating
> >> > dentry information. ksmbd doesn't have to
> >> > do anything because ksmbd already
> >> > checks too small OutputBufferLength to
> >> > store one file information.
> >> >
> >> > And because ctx->pos is set to file->f_pos
> >> > when iterative_dir is called, remove
> >> > restart_ctx().
> >> Shouldn't we get rid of the useless restart_ctx() ?
> >>
> >
> > There is one place to call this function. We can
> > replace that with ctx->pos =3D 0 and remove this function.
> Why should we do ctx->pos =3D 0 there ?

restart_ctx has to be deleted. I misunderstood it,

> >
> >> >
> >> > This patch fixes some failure of
> >> > SMB2_QUERY_DIRECTORY, which happens when
> >> > ntfs3 is local filesystem.
> >> >
> >> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> >> > ---
> >> >  fs/ksmbd/smb2pdu.c | 6 ++----
> >> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >> >
> >> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> >> > index 53c91ab02be2..6716c4e3c16d 100644
> >> > --- a/fs/ksmbd/smb2pdu.c
> >> > +++ b/fs/ksmbd/smb2pdu.c
> >> > @@ -3970,11 +3970,9 @@ int smb2_query_dir(struct ksmbd_work *work)
> >> >        */
> >> >       if (!d_info.out_buf_len && !d_info.num_entry)
> >> >               goto no_buf_len;
> >> > -     if (rc =3D=3D 0)
> >> > -             restart_ctx(&dir_fp->readdir_data.ctx);
> >> > -     if (rc =3D=3D -ENOSPC)
> >> > +     if (rc > 0 || rc =3D=3D -ENOSPC)
> >> Do you know why -ENOSPC error is ignored ?
> >>
> >
> > I don't know why and can't find the commit history
> > for this.
> After checking if -ENOSPC error is returned, there is no need to leave
> it if it is not needed.

In most cases, -ENOSPC is not returned. Because the value
is set to the return value from filesystems' iterate or iterate_share,
and most file systems don't allocate disk space for this operation.

But we cannot guarantee this. So how about changing handling iterate_dir
like gendents system call. Even if an error code is returned by iterate_dir=
,
it treats as normal if several child files are iterated and the buffer
is filled with
information about those.

> >
> >> Thanks.
> >> >               rc =3D 0;
> >> > -     if (rc)
> >> > +     else if (rc)
> >> >               goto err_out;
> >> >
> >> >       d_info.wptr =3D d_info.rptr;
> >> > --
> >> > 2.17.1
> >> >
> >> >
> >
> >
> >
> > --
> > Thanks,
> > Hyunchul
> >



--=20
Thanks,
Hyunchul
