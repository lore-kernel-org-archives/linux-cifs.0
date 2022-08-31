Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 123CBECAAD3
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 07:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiHaHHB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 03:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiHaHHA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 03:07:00 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A2B66A57
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 00:06:59 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id v7-20020a1cac07000000b003a6062a4f81so11146723wme.1
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 00:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=t6WIQe5xgioTGCnI0aV0P92uGo3UVb2tWSIHWk3zcmA=;
        b=RahmbWWNT7eDZuezqqwOJLFIvGslm8SoQz8r6CfTD5kmGjWnx0lnFEYY0PeFRMevCB
         k/rByHprVP84yde5cxdO2DaZDznjvzi9SyGW64upq/B4BMd7hYzODr6Wje4K7U9jZKbV
         ty/PsRXvnLowLQ4GYp5S3xqQuZKIw+PdJ7D6AwI0NhBxnvmkv5IgjSt/1BFSq9dmkoeS
         vO9o8TsSfOZJgy9EIUC12jctesBYcECmllqGCsH/qz9iAi8C7O9qX+zrVaHpkLIUzl0h
         7pT9Lb8OscUD2riCMubWgZ0ggYi8/Lqh2lIvAVWt22VbkaD36J+De0fu63ATIbqLDKS0
         fvjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=t6WIQe5xgioTGCnI0aV0P92uGo3UVb2tWSIHWk3zcmA=;
        b=MAOvFJZ3JYSNdkNSs39xs86AHvlZh3c1kxUk0z1W52LcxmeojMBeEbS2U0PFDJ9wJH
         GcZ6sDN3QCQF9X2ruA77V3QyUJHdXb3s5UoeA+RQio8IOpWmOnGqwXyoCg9WkOlUK+AA
         5jMd23nYmu/OKKptM0woxLuF31rDt00T6xSMx+U69QbQ8AgGCJyD8gdgPi0kUAVci8pG
         KFAH72GGCU7KMr0KCqzhDjQj0vWss2NepT0hbHoH82SUuFIYgvaRQNPpTMw0r5M+fboj
         qLelGfJoXirbvZO8KeNLNYvfpJ3jNYOlQd6J0xAX8nDRvPPFJBOyDfPWat4rGSuF1KBN
         13/g==
X-Gm-Message-State: ACgBeo1cqO3O5C6YlBmxrGbuFLzELW9WUvNU4hT+hSLh1zAuA4jppicq
        RBBIBylZkvOAVJdaJqxihfulTgoBRg5SfXjdUxs=
X-Google-Smtp-Source: AA6agR7KgVMQvgkPE+Ka3gJTjKrXnrSfdvBpGXczA9ePTKaTuGsUySL24GUvbkNCMD6ER/mzrvG4g/52jg47e+77LtI=
X-Received: by 2002:a05:600c:657:b0:3a5:e4e6:ee24 with SMTP id
 p23-20020a05600c065700b003a5e4e6ee24mr959414wmm.68.1661929617734; Wed, 31 Aug
 2022 00:06:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220819043557.26745-1-hyc.lee@gmail.com> <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
 <CANFS6bZ1Xh+BTFDpWQdChcoY_5t5MwT5UMQ=tQupXmEeSO3kPw@mail.gmail.com>
 <CAKYAXd_Qd3jf_GwvzmZ+V+s--k-+T8HBD9HfvDvAesuv1vth2g@mail.gmail.com>
 <CANFS6ba3zUFW3Cju6zXiAoQ0jU_-oq=1EZLfwBCf9uGyqVzOKA@mail.gmail.com>
 <CAKYAXd9iP8h-rxju-JG9=9QJbVTpMqsMhySGMeZzHrkA4JnC_g@mail.gmail.com>
 <CANFS6bbMYjn9kw574vpKPj74Zs6oQYiCdPEknMbCQf77_30v6Q@mail.gmail.com>
 <CAKYAXd9yiTOg2FPtCtyZn+4fdCbXOU2edDk2L-9Vv5ehJ+w=jA@mail.gmail.com>
 <CANFS6bbwZDGhB4Dp+A192U=S1VfWa0091OBvmxhTB_C4BPz7sA@mail.gmail.com> <CAKYAXd_7p1gmV+3HZE9v+biUxRPzoNL7-cqRpfY8yCFHik7M5g@mail.gmail.com>
In-Reply-To: <CAKYAXd_7p1gmV+3HZE9v+biUxRPzoNL7-cqRpfY8yCFHik7M5g@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 31 Aug 2022 16:06:46 +0900
Message-ID: <CANFS6bYYEtXPDQnmAKFujLPu_xO7zhtwhQ+kJqdkjjgKcvZLjQ@mail.gmail.com>
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

2022=EB=85=84 8=EC=9B=94 24=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 9:10, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-08-23 17:26 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > 2022=EB=85=84 8=EC=9B=94 23=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 11:=
45, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
> >>
> >> >> >> >> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> >> >> >> >> > index 53c91ab02be2..6716c4e3c16d 100644
> >> >> >> >> > --- a/fs/ksmbd/smb2pdu.c
> >> >> >> >> > +++ b/fs/ksmbd/smb2pdu.c
> >> >> >> >> > @@ -3970,11 +3970,9 @@ int smb2_query_dir(struct ksmbd_work
> >> >> >> >> > *work)
> >> >> >> >> >        */
> >> >> >> >> >       if (!d_info.out_buf_len && !d_info.num_entry)
> >> >> >> >> >               goto no_buf_len;
> >> >> >> >> > -     if (rc =3D=3D 0)
> >> >> >> >> > -             restart_ctx(&dir_fp->readdir_data.ctx);
> >> >> >> >> > -     if (rc =3D=3D -ENOSPC)
> >> >> >> >> > +     if (rc > 0 || rc =3D=3D -ENOSPC)
> >> >> >> >> Do you know why -ENOSPC error is ignored ?
> >> >> >> >>
> >> >> >> >
> >> >> >> > I don't know why and can't find the commit history
> >> >> >> > for this.
> >> >> >> After checking if -ENOSPC error is returned, there is no need to
> >> >> >> leave
> >> >> >> it if it is not needed.
> >> >> >
> >> >> > In most cases, -ENOSPC is not returned. Because the value
> >> >> > is set to the return value from filesystems' iterate or
> >> >> > iterate_share,
> >> >> > and most file systems don't allocate disk space for this operatio=
n.
> >> >> >
> >> >> > But we cannot guarantee this. So how about changing handling
> >> >> > iterate_dir
> >> >> > like gendents system call. Even if an error code is returned by
> >> >> > iterate_dir,
> >> >> > it treats as normal if several child files are iterated and the
> >> >> > buffer
> >> >> > is filled with
> >> >> > information about those.
> >> >> Among the errors of the smb2 query directory in the specification,
> >> >> there is a file corruption error response
> >> >> type(STATUS_FILE_CORRUPT_ERROR).
> >> >> Can you check when smb server return that error response for smb2
> >> >> query directory?
> >> >>
> >> >
> >> > According to MS-REREF, it means "The file or directory is corrupt an=
d
> >> > unreadable.
> >> > Run the chkdsk utility". And there is no function to return the erro=
r
> >> > in
> >> > Samba.
> >> Is samba not able to know corruption errors using getdents syscall as =
you
> >> said?
> >
> > If iterate_dir returns an error and there are files iterated, getdents
> > syscall will succeed.
> > But if a client requests SMB2_QUERY_DIR again due to STATUS_NO_MORE_FIL=
ES
> > absence of the last response, iterate_dir returns an error again and
> > there are no
> > files iterated, getdents syscall will fail. Samba can send a response
> > with an error.
> Sorry, can't understand. What error ?


When I set the last entry of directory FAT chain to be invalid value in exF=
AT,
the last getdents returns -EIO, but Samba sends responses without an error

> >
> >> There is no reason to follow it. I think that ksmbd is able to return
> >> this error.
> >
> > Can we determine we should return a response with STATUS_FILE_CORRUPT_E=
RROR
> > if iterate_dir returns -EIO?
> STATUS_FILE_CORRUPT_ERROR is still not cleared. want to know how
> windows server handle it.

In the above example, Windows server sends an empty SMB2_QUERY_DIRECTORY
response with STATUS_FILE_CORRUPT_ERROR.

And when executing "dir <directory>" in Windows terminal for the local
exFAT filesystem,
there are no files iterated and DirIOError is generated.


> >
> > --
> > Thanks,
> > Hyunchul
> >



--
Thanks,
Hyunchul
