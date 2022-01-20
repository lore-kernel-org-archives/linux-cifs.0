Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346BCC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jan 2022 04:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358436AbiATETU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Jan 2022 23:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358442AbiATETS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Jan 2022 23:19:18 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05A9C061574
        for <linux-cifs@vger.kernel.org>; Wed, 19 Jan 2022 20:19:17 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id p1so8576277uap.9
        for <linux-cifs@vger.kernel.org>; Wed, 19 Jan 2022 20:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9eN690hw2Yn92u3cdD9jwMldD6MTrY7yplx/+E7iN7I=;
        b=KmZcwaEaf0E1axWNsvjqeeSO7gSY41Yg7aim++ybJZaMuovqbESz+L/5lAHq/OonOe
         2tQ6IUzUNuzKZv2g3I1GXafGInT1bRuW18Y6wz4Fp8k8LOg4BsFxqtcauQSEKgZ6w2iw
         M0M+2u1P7+Ss4h79eV3fxMXJBWCxG+yxpXKZuQAKEcSoVxWNEgDAb3Ks0lYhE/0rEAKa
         d9Zt5cpaNnq8jTeQsBqzAlTESMxIeSZitoQFKJjxUr7C7hnRfFCyEgwRK9SchuK4Lx0X
         6P6FZ8m0nZOJ/8+en4IaWh0/YgY7npdeRQ3Pl+TCSWcQ3YH/7s5CyhXVHFZcDDAVgACm
         6+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9eN690hw2Yn92u3cdD9jwMldD6MTrY7yplx/+E7iN7I=;
        b=K8mq8/ACH9BUgYn9ypKTJN/meBBLvMEICEfIw6cBFbEL5pRVZRT6RjrI6jP4o8VfxT
         uBCxE0C5ffjrSTV6FQDrWN7IV2sRc6daR6kb9sm4BBQa42BhDaI63eDipfpV6WBkWev5
         kIn4LDdZmYlBgvmPIaftTF7paFhPr8G6TbfSaLBmdMMpjRIuNrFAaqF5zNzt+dg65aIi
         DklS6W6bfUL9dfq+ODpk/fFLq9ESY10r5WOEAi7FQD7x8Lzb02d7dSWIivtd63cfnN6W
         76AQ+aLFf1yA+1vMOkiEm2AhZsC8TZnjpO1uAqCyR0FvDmb43gCJs8MSi0lYVvXxmYVd
         VGUQ==
X-Gm-Message-State: AOAM530VHsfN2bqq9o7k3YTIr08UnLpBGAJyaisCameHOd5eOOje52QN
        ItWZXUI/Ctq2lwFql+whCFPZFTclWrnGPUsX7qc=
X-Google-Smtp-Source: ABdhPJzRqbINXqa+V38z4sPMGIq3G7veqDExaWCxJvVExmggR3/vd5aD4QsynIHb9Mw3ltNffrGGM3dJ9wxz1ofqdgs=
X-Received: by 2002:a67:e19d:: with SMTP id e29mr142599vsl.56.1642652356813;
 Wed, 19 Jan 2022 20:19:16 -0800 (PST)
MIME-Version: 1.0
References: <20220119150115.177058-1-hyc.lee@gmail.com> <CAKYAXd-sxcM+tOMKHhq=K4XNPHMvDjqtcA5dN-rZUe7hy_XY0g@mail.gmail.com>
In-Reply-To: <CAKYAXd-sxcM+tOMKHhq=K4XNPHMvDjqtcA5dN-rZUe7hy_XY0g@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 20 Jan 2022 13:19:05 +0900
Message-ID: <CANFS6bYOjRZKmBWxAZ3WpkfcN6s05SnpkX-5DRg57RNUtJ7Lkg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: smbd: validate buffer descriptor structures
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 1=EC=9B=94 20=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 11:56, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-01-20 0:01 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > Check ChannelInfoOffset and ChannelInfoLength
> > to validate buffer descriptor structures.
> > And add a debug log to print the structures'
> > content.
> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > ---
> >  fs/ksmbd/smb2pdu.c | 31 +++++++++++++++++++++++++------
> >  1 file changed, 25 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> > index c3f248d461e6..f664fbadb09a 100644
> > --- a/fs/ksmbd/smb2pdu.c
> > +++ b/fs/ksmbd/smb2pdu.c
> > @@ -6130,12 +6130,20 @@ static int smb2_set_remote_key_for_rdma(struct
> > ksmbd_work *work,
> >                                       __le16 ChannelInfoOffset,
> >                                       __le16 ChannelInfoLength)
> >  {
> > +     unsigned int i, ch_count;
> > +
> >       if (work->conn->dialect =3D=3D SMB30_PROT_ID &&
> >           Channel !=3D SMB2_CHANNEL_RDMA_V1)
> >               return -EINVAL;
> >
> > -     if (ChannelInfoOffset =3D=3D 0 ||
> > -         le16_to_cpu(ChannelInfoLength) < sizeof(*desc))
> > +     ch_count =3D le16_to_cpu(ChannelInfoLength) / sizeof(*desc);
> > +     for (i =3D 0; i < ch_count; i++) {
> unneeded loop is executed on non-debug mode. I think that this loop is
> covered with rdma debug.
> Please check this :
>  if (ksmbd_debug_types & KSMBD_DEBUG_RDMA) { }
>

Okay, I will change it.

> > +             ksmbd_debug(RDMA, "RDMA r/w request %#x: token %#x, lengt=
h %#x\n",
> > +                         i,
> > +                         le32_to_cpu(desc[i].token),
> > +                         le32_to_cpu(desc[i].length));
> > +     }
> > +     if (ch_count !=3D 1)
> Need to add error print that ksmbd doesn't support multiple buffer desc y=
et.

Okay, I will apply this.

> >               return -EINVAL;
>
> And multiple buffer desc support is required for a fundamental
> solution, but it is expected that it will take a very long time for
> you to implement it. Is that right? If so, first, find a way to set

I will re-start implementing it and complete it by next week or
the middle of February.

> the optimal read/write size so that the client send a single buffer
> desc to ksmbd.

I thought about it, but there seems to be no solution because it
is caused by a client device's limitation.

> >
> >       work->need_invalidate_rkey =3D
> > @@ -6189,9 +6197,15 @@ int smb2_read(struct ksmbd_work *work)
> >
> >       if (req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
> >           req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1) {
> > +             unsigned int ch_offset =3D le16_to_cpu(req->ReadChannelIn=
foOffset);
> > +
> > +             if (ch_offset < offsetof(struct smb2_read_req, Buffer)) {
> > +                     err =3D -EINVAL;
> > +                     goto out;
> > +             }
> >               err =3D smb2_set_remote_key_for_rdma(work,
> >                                                  (struct smb2_buffer_de=
sc_v1 *)
> > -                                                &req->Buffer[0],
> > +                                                ((char *)req + ch_offs=
et),
> >                                                  req->Channel,
> >                                                  req->ReadChannelInfoOf=
fset,
> >                                                  req->ReadChannelInfoLe=
ngth);
> > @@ -6432,11 +6446,16 @@ int smb2_write(struct ksmbd_work *work)
> >
> >       if (req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1 ||
> >           req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
> > -             if (req->Length !=3D 0 || req->DataOffset !=3D 0)
> > -                     return -EINVAL;
> > +             unsigned int ch_offset =3D le16_to_cpu(req->WriteChannelI=
nfoOffset);
> > +
> > +             if (req->Length !=3D 0 || req->DataOffset !=3D 0 ||
> > +                 ch_offset < offsetof(struct smb2_write_req, Buffer)) =
{
> > +                     err =3D -EINVAL;
> > +                     goto out;
> > +             }
> >               err =3D smb2_set_remote_key_for_rdma(work,
> >                                                  (struct smb2_buffer_de=
sc_v1 *)
> > -                                                &req->Buffer[0],
> > +                                                ((char *)req + ch_offs=
et),
> >                                                  req->Channel,
> >                                                  req->WriteChannelInfoO=
ffset,
> >                                                  req->WriteChannelInfoL=
ength);
> > --
> > 2.25.1
> >
> >



--=20
Thanks,
Hyunchul
