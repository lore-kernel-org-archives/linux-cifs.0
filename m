Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18271C43334
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jun 2022 23:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiFMXNL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Jun 2022 19:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiFMXNK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Jun 2022 19:13:10 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3802AE12
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 16:13:09 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id s1so8883358wra.9
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 16:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=puCqNPrE1+q2zB/HA6fCrAGqSMGm9W9HOWStKlt/2DQ=;
        b=kcaybPD5Cu1Mokokl0sFbTGZKX7VhPHqkXzmjLJkD/Hp9D2r2yRS5sHXGeWOCm2GHr
         HJHtOHQs4lcIrNepWBcR78ZGEFCYmrxegjMqjhbTrF7/4z095u5nMGiyilsj6GM8l8ce
         QuWnw1Hxma5iJyCuXl0ljnRToaZTu3PX/MjQ15hLZNgkKmR2lDhHxl08gj4I8/Wj3BNy
         2mFOwSkhj4Cn09zP0KRpao+DNM+5DJ/qN9hHuYE/rtCKVUAXurWqFYASaP/1iVcQmnD7
         H3sav6spoJ+Zv7e+BreQUwhs/0jJDQaqFkUbZtSREAA3X0U/8f/gZbKRxiwQt9lZX3Ek
         URmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=puCqNPrE1+q2zB/HA6fCrAGqSMGm9W9HOWStKlt/2DQ=;
        b=aSoz8y39hjAakFXEA6qly12iBLk0lsdPL1klY+RrTKk3oxlBgF+AgxdRZYCzse3fBT
         HZgZqhZoaRAN+v6xMJ0/hTE5FdVQgjCGp0AHu97u+ltd3yz9cyzDAdGI/2ko0q8zhI5m
         fbY6bHlFZQ+kTdHTuUK5zO6OO+g9B7Fn+KL6DMRmA1Bm34vGkev6dExhSWKKK6+eA391
         nygLl0xXJM/aDinxr4VGkgdWPbzBcoQ0sjYD1WtLXJdB34BjTXfS1lDZdB8ZXJy2sHUz
         /xfTYJDptTv4v+uyuvbVqio5zeR6JfRkc4m8b5mPvsA9Ia5GzIAKCI2ZSrqZJMvSWYsw
         JA+A==
X-Gm-Message-State: AJIora9bdU3xaFGE++qtlaliJb4PoYSgEDU0s/dQW7qB+zbYd7vADf9C
        cDWoW5ggMurHenEUCc3YjTNQSIxEfTmFNuLDpnIQaZfM
X-Google-Smtp-Source: AGRyM1uZAJArdE/ko0YPcV5AexDFCgy9d5ysycXVmbVpw9T52K3dze5HHBWUoNWipT7jqvLXYXfxgjUjJ2fUvs4raL0=
X-Received: by 2002:adf:ed0a:0:b0:217:7f86:2e0c with SMTP id
 a10-20020adfed0a000000b002177f862e0cmr1945784wro.322.1655161987800; Mon, 13
 Jun 2022 16:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220613230119.73475-1-hyc.lee@gmail.com> <CAKYAXd_4drxMozKppYKG8n5NJ2WqSn_n6dWoFBf=AsJ9zWrMvA@mail.gmail.com>
In-Reply-To: <CAKYAXd_4drxMozKppYKG8n5NJ2WqSn_n6dWoFBf=AsJ9zWrMvA@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Tue, 14 Jun 2022 08:12:56 +0900
Message-ID: <CANFS6bZ4uK8TwP69OOQuFg7PO7thOnZMUr7hXh=jix09x_Vi0A@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: remove duplicate flag set in smb2_write
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 6=EC=9B=94 14=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 8:08, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-06-14 8:01 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > The writethrough flag is set again if
> > is_rdma_channel is false.
> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > ---
> >  fs/ksmbd/smb2pdu.c | 3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> > index e6f4ccc12f49..553aad4ca6fa 100644
> > --- a/fs/ksmbd/smb2pdu.c
> > +++ b/fs/ksmbd/smb2pdu.c
> > @@ -6506,9 +6506,6 @@ int smb2_write(struct ksmbd_work *work)
> >                                   le16_to_cpu(req->DataOffset));
> >
> >               ksmbd_debug(SMB, "flags %u\n", le32_to_cpu(req->Flags));
> Could you move debug print to flags check above also ?
>

Okay, I will.

> > -             if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUG=
H)
> > -                     writethrough =3D true;
> > -
> >               ksmbd_debug(SMB, "filename %pd, offset %lld, len %zu\n",
> >                           fp->filp->f_path.dentry, offset, length);
> >               err =3D ksmbd_vfs_write(work, fp, data_buf, length, &offs=
et,
> > --
> > 2.25.1
> >
> >



--=20
Thanks,
Hyunchul
