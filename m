Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E971C00140
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Aug 2022 02:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiHVCOm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 21 Aug 2022 22:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiHVCOl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 21 Aug 2022 22:14:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5BC1ADB4
        for <linux-cifs@vger.kernel.org>; Sun, 21 Aug 2022 19:14:36 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h24so11466674wrb.8
        for <linux-cifs@vger.kernel.org>; Sun, 21 Aug 2022 19:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=anC1wUZsWMAkI+YvyQl+OrNskmvB2RQoen5DiwYmbvI=;
        b=hRBRoO4UioXgGecHEpsrDQfJdlQGHtpNutfwup0c4ruZPQKWb1kmDX3XJz+N0P9cgr
         PB31mkiJlQE0DtuoVvqq+n1f0GHP4CffTTlpVOMMZDXpDpXxwXJuoPbhOIPiAuS8mvft
         5SsPeFxm3xThaFdKBigbZC+BusBOCcUtMLLoTYRGVVCyWIGO1q66cj23PpSeWQe/1IeI
         gtdBQ5bP82PopY+UQ7D9eqP/6CvsHe4eXMr4s3wx+js1YeOvwOwOTl58mZHQo1a2Pajd
         y4a0F1HgrzNZE5a+nUP+aV1vxQ3/y1lorOsdRopsybAUQ3QeMO68inclV8JVoVyZOcxx
         Me+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=anC1wUZsWMAkI+YvyQl+OrNskmvB2RQoen5DiwYmbvI=;
        b=PmgX9inbCY/guAJqEMT8RXYFRjXdmd19wpSGS27Sg067lnjT18JwgecSifbSyHi6IT
         kIKRzd8uIH3R8NnB5aFUdVGLenS83bmTs06vYpQEw0SI6P5iogzbGATayyQoyowAJFnD
         wmbo4iwlpAcs+Heeft2+9rHS3BMd/ZpYXOzh8IJxE9PcnvmDFxKlhN1zEkl49TWuVI1P
         WrethEaa+aVfInE1Po/qNL9E04Risngz8fU3ipwSWcWQf3uQ+ihFcMPZLTLoWG3Ovtte
         1OTw0q44WSiLKgDzxAKZ+LWxzdEAk99lwCpRQLCoc1bL1SG4ZLD21wDBQhervBG1PmAU
         QBLQ==
X-Gm-Message-State: ACgBeo02EO/+j/pEG1sgmyRQoejb+CEOGwLuAZsf/ILvQ7wx1wSy7BAu
        IZ93Pul3LVxr4Nd8AXkDpMDjufrqaKcqS/rxsK0=
X-Google-Smtp-Source: AA6agR4hhYq6OsuoXBs5pc7OElX6MRrwXjVp8zHLHF2RvXQi8nulU7rB0/gbs3vD/GoeJqyixCWIASPIXizh786onqo=
X-Received: by 2002:adf:f082:0:b0:225:2884:c5ce with SMTP id
 n2-20020adff082000000b002252884c5cemr9724423wro.412.1661134474660; Sun, 21
 Aug 2022 19:14:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220819043557.26745-1-hyc.lee@gmail.com> <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
In-Reply-To: <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 22 Aug 2022 11:14:23 +0900
Message-ID: <CANFS6bZ1Xh+BTFDpWQdChcoY_5t5MwT5UMQ=tQupXmEeSO3kPw@mail.gmail.com>
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

2022=EB=85=84 8=EC=9B=94 22=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 9:51, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-08-19 13:35 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > if iterate_dir() returns non-negative value,
> > caller has to treat it as normal and
> > check there is any error while populating
> > dentry information. ksmbd doesn't have to
> > do anything because ksmbd already
> > checks too small OutputBufferLength to
> > store one file information.
> >
> > And because ctx->pos is set to file->f_pos
> > when iterative_dir is called, remove
> > restart_ctx().
> Shouldn't we get rid of the useless restart_ctx() ?
>

There is one place to call this function. We can
replace that with ctx->pos =3D 0 and remove this function.

> >
> > This patch fixes some failure of
> > SMB2_QUERY_DIRECTORY, which happens when
> > ntfs3 is local filesystem.
> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > ---
> >  fs/ksmbd/smb2pdu.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> > index 53c91ab02be2..6716c4e3c16d 100644
> > --- a/fs/ksmbd/smb2pdu.c
> > +++ b/fs/ksmbd/smb2pdu.c
> > @@ -3970,11 +3970,9 @@ int smb2_query_dir(struct ksmbd_work *work)
> >        */
> >       if (!d_info.out_buf_len && !d_info.num_entry)
> >               goto no_buf_len;
> > -     if (rc =3D=3D 0)
> > -             restart_ctx(&dir_fp->readdir_data.ctx);
> > -     if (rc =3D=3D -ENOSPC)
> > +     if (rc > 0 || rc =3D=3D -ENOSPC)
> Do you know why -ENOSPC error is ignored ?
>

I don't know why and can't find the commit history
for this.

> Thanks.
> >               rc =3D 0;
> > -     if (rc)
> > +     else if (rc)
> >               goto err_out;
> >
> >       d_info.wptr =3D d_info.rptr;
> > --
> > 2.17.1
> >
> >



--=20
Thanks,
Hyunchul
