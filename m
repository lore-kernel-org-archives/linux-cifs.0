Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D680C32772
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 09:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241016AbiHWJAY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 05:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240444AbiHWI7v (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 04:59:51 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF3F8168C
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 01:27:11 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id d5so6791516wms.5
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 01:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=AbMkCyH1n1Om612YOVCPJJBi/Ce5LDUpghdQwpdxd44=;
        b=mAAaPDZ9yAjVgkovD1YtFpPH5BJukVX67oeucZ6Nlbk4CL44RUkBUCRwManAHuBzDo
         8y3rQRgxhN3Rlz9oNCN9DPHlxw7b+oS2PnL2dGmWdVXyt+Z+JpMqfrYsXyPRoO+27XvZ
         GfkatWyMmBkYklShOgVaesZdhGwCKI8i5d5siuo9UmGbF07Uye1asjto4dt9HRnsORHd
         /LbdcoZma1OOSTId6y+nE62qRQvgQsDjBWfUtX+gqgPYhG9BYSO5hTr+hVD5LRmbr0t4
         1rKxLyPebaAKZAEFPPA/Roc14BNkW6ofRgTNNPeyQAkEUjFr6ylg9LIE2ZYSLpPQ4Bp9
         wNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=AbMkCyH1n1Om612YOVCPJJBi/Ce5LDUpghdQwpdxd44=;
        b=elyaGL8yeObuXZuWaBfaCmUH4E+JG8qzItdSCKCx+i7z0eDb+nSmxxKkh5E7gJWC4+
         BUXG0jEZH227YtO/3nDAMJ7Bi9RETJJaxfHcB8IDatQi008BYxHM/Tv3mvdqlrWtvWDZ
         PaXGMLJjumGRQ6kZrg2OyNunXPueUkRfd8b5gWO1EtZYwro/8mM3S9xfLdcM5l9WvirJ
         mPOv1wdzBH1EM5clblLxQfmu2XsflUTlrCfnNNjRvV+hY5IWEq0f5e+fmFi0Ohmunlsl
         vWtbeIfSlYSIFUxt1ch603tTN1XbnGgb9vIhpd5yOg61Pum3sCvHNEj2/iIBocviUHh6
         sGTA==
X-Gm-Message-State: ACgBeo3+y9ngbLClF7vgByhTaoEH9rA96mOv7L7by+Nm+xnsG0ksKgra
        7Oo9fNKkvvpdr8xcSsVAnyU/4tJTH1r4i4SgZyc=
X-Google-Smtp-Source: AA6agR7OxibIrrUGumqnqBYDwj4/mpRk+idtz7A0KomBSNZsli+Kp6KkVR3/wXP1Mbs/Akwt8itaLft9s3z7CdYA4ak=
X-Received: by 2002:a05:600c:15c5:b0:3a5:b800:3c53 with SMTP id
 v5-20020a05600c15c500b003a5b8003c53mr1373967wmf.176.1661243227693; Tue, 23
 Aug 2022 01:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220819043557.26745-1-hyc.lee@gmail.com> <CAKYAXd-18=_Yv1LAG=cqAQMORVD3mdA=9OP1t6+PxM+bUxLM2Q@mail.gmail.com>
 <CANFS6bZ1Xh+BTFDpWQdChcoY_5t5MwT5UMQ=tQupXmEeSO3kPw@mail.gmail.com>
 <CAKYAXd_Qd3jf_GwvzmZ+V+s--k-+T8HBD9HfvDvAesuv1vth2g@mail.gmail.com>
 <CANFS6ba3zUFW3Cju6zXiAoQ0jU_-oq=1EZLfwBCf9uGyqVzOKA@mail.gmail.com>
 <CAKYAXd9iP8h-rxju-JG9=9QJbVTpMqsMhySGMeZzHrkA4JnC_g@mail.gmail.com>
 <CANFS6bbMYjn9kw574vpKPj74Zs6oQYiCdPEknMbCQf77_30v6Q@mail.gmail.com> <CAKYAXd9yiTOg2FPtCtyZn+4fdCbXOU2edDk2L-9Vv5ehJ+w=jA@mail.gmail.com>
In-Reply-To: <CAKYAXd9yiTOg2FPtCtyZn+4fdCbXOU2edDk2L-9Vv5ehJ+w=jA@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Tue, 23 Aug 2022 17:26:56 +0900
Message-ID: <CANFS6bbwZDGhB4Dp+A192U=S1VfWa0091OBvmxhTB_C4BPz7sA@mail.gmail.com>
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

2022=EB=85=84 8=EC=9B=94 23=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 11:45, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> >> >> >> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> >> >> >> > index 53c91ab02be2..6716c4e3c16d 100644
> >> >> >> > --- a/fs/ksmbd/smb2pdu.c
> >> >> >> > +++ b/fs/ksmbd/smb2pdu.c
> >> >> >> > @@ -3970,11 +3970,9 @@ int smb2_query_dir(struct ksmbd_work
> >> >> >> > *work)
> >> >> >> >        */
> >> >> >> >       if (!d_info.out_buf_len && !d_info.num_entry)
> >> >> >> >               goto no_buf_len;
> >> >> >> > -     if (rc =3D=3D 0)
> >> >> >> > -             restart_ctx(&dir_fp->readdir_data.ctx);
> >> >> >> > -     if (rc =3D=3D -ENOSPC)
> >> >> >> > +     if (rc > 0 || rc =3D=3D -ENOSPC)
> >> >> >> Do you know why -ENOSPC error is ignored ?
> >> >> >>
> >> >> >
> >> >> > I don't know why and can't find the commit history
> >> >> > for this.
> >> >> After checking if -ENOSPC error is returned, there is no need to le=
ave
> >> >> it if it is not needed.
> >> >
> >> > In most cases, -ENOSPC is not returned. Because the value
> >> > is set to the return value from filesystems' iterate or iterate_shar=
e,
> >> > and most file systems don't allocate disk space for this operation.
> >> >
> >> > But we cannot guarantee this. So how about changing handling
> >> > iterate_dir
> >> > like gendents system call. Even if an error code is returned by
> >> > iterate_dir,
> >> > it treats as normal if several child files are iterated and the buff=
er
> >> > is filled with
> >> > information about those.
> >> Among the errors of the smb2 query directory in the specification,
> >> there is a file corruption error response
> >> type(STATUS_FILE_CORRUPT_ERROR).
> >> Can you check when smb server return that error response for smb2
> >> query directory?
> >>
> >
> > According to MS-REREF, it means "The file or directory is corrupt and
> > unreadable.
> > Run the chkdsk utility". And there is no function to return the error i=
n
> > Samba.
> Is samba not able to know corruption errors using getdents syscall as you=
 said?

If iterate_dir returns an error and there are files iterated, getdents
syscall will succeed.
But if a client requests SMB2_QUERY_DIR again due to STATUS_NO_MORE_FILES
absence of the last response, iterate_dir returns an error again and
there are no
files iterated, getdents syscall will fail. Samba can send a response
with an error.

> There is no reason to follow it. I think that ksmbd is able to return
> this error.

Can we determine we should return a response with STATUS_FILE_CORRUPT_ERROR
if iterate_dir returns -EIO?

--=20
Thanks,
Hyunchul
