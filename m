Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D54EAC28D13
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 02:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239456AbiHWCcg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Aug 2022 22:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239218AbiHWCcg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Aug 2022 22:32:36 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C555B5C346
        for <linux-cifs@vger.kernel.org>; Mon, 22 Aug 2022 19:32:33 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id ay12so6487975wmb.1
        for <linux-cifs@vger.kernel.org>; Mon, 22 Aug 2022 19:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=nb8+eMOoBayDzCSmgJ19IX/s7llRWZ5PdLYxrjdsEq4=;
        b=aYUMtQyV487EUMVmhrxxOvHGK4uA6b04tP4N2LORCkhyx8iqUOZsBrQJ580UgTTwZ7
         yQyeg+Dkfl8O1xjF59wHDSqA7y9v7JeRV88mb2bGL6LLyqHuSO+6JmPv05muaon+Dho4
         y/uM1pyG7R3oujw4pg6v1F8zF+inuXmxVTtGiVDs/Gn3wjjjypC4TKx5PPzUl+JBeArK
         JlDq2s75u4lwqdzY7uGgIfcmP0h0Tu+PiYKV9GLX28FbX/iW+Zxt9t2zKe3GLGPKVZ5t
         h35CpB5p7e3Nmqx+nfe1lvhV7ObDCp/uVbI3smfs0udO0xZemd5KjkXq194iXNIGiq/0
         ZbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=nb8+eMOoBayDzCSmgJ19IX/s7llRWZ5PdLYxrjdsEq4=;
        b=M15k/s4xLASN1XMImFCHedVsSSEA6Ea6+hoGOhzwIe9rI9kFfigFEwe9iLVtB5RF22
         BdYhxW/pMZv2dp8T1W4RlIdRNQNGN8K+gY47V0P3naClduD+JKy5MpDcysP3bfAvocxH
         lGvHTZ9Z3BIKpIHkGWcCFDBVaEBuYzap9f70OlFhqtsjsv5HMjOOCDuSOG1dgdunw3ZH
         cVawQGTZXNXOejM1moqncK9XPv0JzSlPofWmFZlWK+3ah+XEmo1dZV724E+TrKpuQMmh
         J8NJKS3kNcBHYWfiYb1tYmzVma40zKbUBc8oRLeyhPP/v2v4yIGDYACDZr5gBNfuvQls
         r/KQ==
X-Gm-Message-State: ACgBeo3wLAIqCg7+P4T3ydFtmkpv0UFc+VU6tI0rJudVrBriDgsvaU2d
        uJtSeI7cbnyCKW/rpHYEmEZkm0Q8hHvuLXS36Hs=
X-Google-Smtp-Source: AA6agR6xp+Q3EFzeN0evtyKhuv0SY/uQxvAoXX8zJMEgVCpzHnrkAv75xzv543sYuHdkYko988+u6qnauYnmvYTQ2G4=
X-Received: by 2002:a05:600c:5008:b0:3a6:1cd8:570d with SMTP id
 n8-20020a05600c500800b003a61cd8570dmr607744wmr.57.1661221952176; Mon, 22 Aug
 2022 19:32:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220819043557.26745-1-hyc.lee@gmail.com> <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
 <CANFS6bZ1Xh+BTFDpWQdChcoY_5t5MwT5UMQ=tQupXmEeSO3kPw@mail.gmail.com>
 <CAKYAXd_Qd3jf_GwvzmZ+V+s--k-+T8HBD9HfvDvAesuv1vth2g@mail.gmail.com>
 <CANFS6ba3zUFW3Cju6zXiAoQ0jU_-oq=1EZLfwBCf9uGyqVzOKA@mail.gmail.com> <CAKYAXd9iP8h-rxju-JG9=9QJbVTpMqsMhySGMeZzHrkA4JnC_g@mail.gmail.com>
In-Reply-To: <CAKYAXd9iP8h-rxju-JG9=9QJbVTpMqsMhySGMeZzHrkA4JnC_g@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Tue, 23 Aug 2022 11:32:20 +0900
Message-ID: <CANFS6bbMYjn9kw574vpKPj74Zs6oQYiCdPEknMbCQf77_30v6Q@mail.gmail.com>
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

2022=EB=85=84 8=EC=9B=94 23=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 9:40, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-08-22 15:24 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > 2022=EB=85=84 8=EC=9B=94 22=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 11:=
47, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
> >>
> >> 2022-08-22 11:14 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> >> > 2022=EB=85=84 8=EC=9B=94 22=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 =
9:51, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
> >> >>
> >> >> 2022-08-19 13:35 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> >> >> > if iterate_dir() returns non-negative value,
> >> >> > caller has to treat it as normal and
> >> >> > check there is any error while populating
> >> >> > dentry information. ksmbd doesn't have to
> >> >> > do anything because ksmbd already
> >> >> > checks too small OutputBufferLength to
> >> >> > store one file information.
> >> >> >
> >> >> > And because ctx->pos is set to file->f_pos
> >> >> > when iterative_dir is called, remove
> >> >> > restart_ctx().
> >> >> Shouldn't we get rid of the useless restart_ctx() ?
> >> >>
> >> >
> >> > There is one place to call this function. We can
> >> > replace that with ctx->pos =3D 0 and remove this function.
> >> Why should we do ctx->pos =3D 0 there ?
> >
> > restart_ctx has to be deleted. I misunderstood it,
> >
> >> >
> >> >> >
> >> >> > This patch fixes some failure of
> >> >> > SMB2_QUERY_DIRECTORY, which happens when
> >> >> > ntfs3 is local filesystem.
> >> >> >
> >> >> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> >> >> > ---
> >> >> >  fs/ksmbd/smb2pdu.c | 6 ++----
> >> >> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >> >> >
> >> >> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> >> >> > index 53c91ab02be2..6716c4e3c16d 100644
> >> >> > --- a/fs/ksmbd/smb2pdu.c
> >> >> > +++ b/fs/ksmbd/smb2pdu.c
> >> >> > @@ -3970,11 +3970,9 @@ int smb2_query_dir(struct ksmbd_work *work=
)
> >> >> >        */
> >> >> >       if (!d_info.out_buf_len && !d_info.num_entry)
> >> >> >               goto no_buf_len;
> >> >> > -     if (rc =3D=3D 0)
> >> >> > -             restart_ctx(&dir_fp->readdir_data.ctx);
> >> >> > -     if (rc =3D=3D -ENOSPC)
> >> >> > +     if (rc > 0 || rc =3D=3D -ENOSPC)
> >> >> Do you know why -ENOSPC error is ignored ?
> >> >>
> >> >
> >> > I don't know why and can't find the commit history
> >> > for this.
> >> After checking if -ENOSPC error is returned, there is no need to leave
> >> it if it is not needed.
> >
> > In most cases, -ENOSPC is not returned. Because the value
> > is set to the return value from filesystems' iterate or iterate_share,
> > and most file systems don't allocate disk space for this operation.
> >
> > But we cannot guarantee this. So how about changing handling iterate_di=
r
> > like gendents system call. Even if an error code is returned by
> > iterate_dir,
> > it treats as normal if several child files are iterated and the buffer
> > is filled with
> > information about those.
> Among the errors of the smb2 query directory in the specification,
> there is a file corruption error response
> type(STATUS_FILE_CORRUPT_ERROR).
> Can you check when smb server return that error response for smb2
> query directory?
>

According to MS-REREF, it means "The file or directory is corrupt and
unreadable.
Run the chkdsk utility". And there is no function to return the error in Sa=
mba.


> >
> >> >
> >> >> Thanks.
> >> >> >               rc =3D 0;
> >> >> > -     if (rc)
> >> >> > +     else if (rc)
> >> >> >               goto err_out;
> >> >> >
> >> >> >       d_info.wptr =3D d_info.rptr;
> >> >> > --
> >> >> > 2.17.1
> >> >> >
> >> >> >
> >> >
> >> >
> >> >
> >> > --
> >> > Thanks,
> >> > Hyunchul
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
