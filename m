Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97045C28D13
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 00:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238935AbiHWAkc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Aug 2022 20:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238923AbiHWAkb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Aug 2022 20:40:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AF84C606
        for <linux-cifs@vger.kernel.org>; Mon, 22 Aug 2022 17:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8834F6144A
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 00:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC98CC433D6
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 00:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661215229;
        bh=ksJn4dac4gdZFHLME213yPYZ71hC49LkZr/LvU9jdY0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=FesJCJ/EYbWkwTL4kWT5s2rep/HSvNJlFoeqiazaGUSeaSwBgT40ejRymj8kbRjaS
         cKQuvdcpSvKxixzC7/DE0rz0oRFprnGwxqml2mKqD/RYbQ+oq7duIqkum1qkOIxZo6
         Qf2qygvM1V+KdZceCbyXx9s+nVJUm9Kkb928A9iKLQnO5dsfOxK9Y2YqKFBoM41Nhx
         ay5x7b0c5sZMnNtLqz7uzRoNk7sqtrp0xHjvUKUUd5E+wQrQ4jC0YHE4s1Bewr4AvL
         8gTEryXTlGweAUEIAcIS+5MWHDLJhYZdd0DN0dAh4+0YVy+wSGilxycx2sGsoPJiNh
         MGk6FDkJ6C/zA==
Received: by mail-oi1-f171.google.com with SMTP id s199so14286596oie.3
        for <linux-cifs@vger.kernel.org>; Mon, 22 Aug 2022 17:40:29 -0700 (PDT)
X-Gm-Message-State: ACgBeo3TIVwRvABZzi3fnquKdDvIJb8g8BVJW7x9k73R0nsHzYoVS4jK
        cvkb3ITZ3kq1sHf5XTcUYAfFF+Zp3pto/308MUY=
X-Google-Smtp-Source: AA6agR65ddXIHKqcg58nycupZv9PjDGziV0cl8MA9kX9QjqOJSdLU38gcR1Q/dwpwTYZU8OEe4xgZbH5lDiTJ6iIRBA=
X-Received: by 2002:a05:6808:14d5:b0:344:8f50:1f0f with SMTP id
 f21-20020a05680814d500b003448f501f0fmr367456oiw.257.1661215228976; Mon, 22
 Aug 2022 17:40:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Mon, 22 Aug 2022 17:40:28
 -0700 (PDT)
In-Reply-To: <CANFS6ba3zUFW3Cju6zXiAoQ0jU_-oq=1EZLfwBCf9uGyqVzOKA@mail.gmail.com>
References: <20220819043557.26745-1-hyc.lee@gmail.com> <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
 <CANFS6bZ1Xh+BTFDpWQdChcoY_5t5MwT5UMQ=tQupXmEeSO3kPw@mail.gmail.com>
 <CAKYAXd_Qd3jf_GwvzmZ+V+s--k-+T8HBD9HfvDvAesuv1vth2g@mail.gmail.com> <CANFS6ba3zUFW3Cju6zXiAoQ0jU_-oq=1EZLfwBCf9uGyqVzOKA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 23 Aug 2022 09:40:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9iP8h-rxju-JG9=9QJbVTpMqsMhySGMeZzHrkA4JnC_g@mail.gmail.com>
Message-ID: <CAKYAXd9iP8h-rxju-JG9=9QJbVTpMqsMhySGMeZzHrkA4JnC_g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix incorrect handling of iterate_dir
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-22 15:24 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2022=EB=85=84 8=EC=9B=94 22=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 11:47=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> 2022-08-22 11:14 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
>> > 2022=EB=85=84 8=EC=9B=94 22=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 9:=
51, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>> >>
>> >> 2022-08-19 13:35 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
>> >> > if iterate_dir() returns non-negative value,
>> >> > caller has to treat it as normal and
>> >> > check there is any error while populating
>> >> > dentry information. ksmbd doesn't have to
>> >> > do anything because ksmbd already
>> >> > checks too small OutputBufferLength to
>> >> > store one file information.
>> >> >
>> >> > And because ctx->pos is set to file->f_pos
>> >> > when iterative_dir is called, remove
>> >> > restart_ctx().
>> >> Shouldn't we get rid of the useless restart_ctx() ?
>> >>
>> >
>> > There is one place to call this function. We can
>> > replace that with ctx->pos =3D 0 and remove this function.
>> Why should we do ctx->pos =3D 0 there ?
>
> restart_ctx has to be deleted. I misunderstood it,
>
>> >
>> >> >
>> >> > This patch fixes some failure of
>> >> > SMB2_QUERY_DIRECTORY, which happens when
>> >> > ntfs3 is local filesystem.
>> >> >
>> >> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> >> > ---
>> >> >  fs/ksmbd/smb2pdu.c | 6 ++----
>> >> >  1 file changed, 2 insertions(+), 4 deletions(-)
>> >> >
>> >> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> >> > index 53c91ab02be2..6716c4e3c16d 100644
>> >> > --- a/fs/ksmbd/smb2pdu.c
>> >> > +++ b/fs/ksmbd/smb2pdu.c
>> >> > @@ -3970,11 +3970,9 @@ int smb2_query_dir(struct ksmbd_work *work)
>> >> >        */
>> >> >       if (!d_info.out_buf_len && !d_info.num_entry)
>> >> >               goto no_buf_len;
>> >> > -     if (rc =3D=3D 0)
>> >> > -             restart_ctx(&dir_fp->readdir_data.ctx);
>> >> > -     if (rc =3D=3D -ENOSPC)
>> >> > +     if (rc > 0 || rc =3D=3D -ENOSPC)
>> >> Do you know why -ENOSPC error is ignored ?
>> >>
>> >
>> > I don't know why and can't find the commit history
>> > for this.
>> After checking if -ENOSPC error is returned, there is no need to leave
>> it if it is not needed.
>
> In most cases, -ENOSPC is not returned. Because the value
> is set to the return value from filesystems' iterate or iterate_share,
> and most file systems don't allocate disk space for this operation.
>
> But we cannot guarantee this. So how about changing handling iterate_dir
> like gendents system call. Even if an error code is returned by
> iterate_dir,
> it treats as normal if several child files are iterated and the buffer
> is filled with
> information about those.
Among the errors of the smb2 query directory in the specification,
there is a file corruption error response
type(STATUS_FILE_CORRUPT_ERROR).
Can you check when smb server return that error response for smb2
query directory?

>
>> >
>> >> Thanks.
>> >> >               rc =3D 0;
>> >> > -     if (rc)
>> >> > +     else if (rc)
>> >> >               goto err_out;
>> >> >
>> >> >       d_info.wptr =3D d_info.rptr;
>> >> > --
>> >> > 2.17.1
>> >> >
>> >> >
>> >
>> >
>> >
>> > --
>> > Thanks,
>> > Hyunchul
>> >
>
>
>
> --
> Thanks,
> Hyunchul
>
