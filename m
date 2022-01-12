Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E4FC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Jan 2022 00:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346891AbiALAJS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Jan 2022 19:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbiALAJR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Jan 2022 19:09:17 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B16C06173F
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 16:09:17 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id m15so1719021uap.6
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 16:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=58aR18/+HW7ZKegb+QXPtZWDO5qdpX2PaqIv3/Ar+KM=;
        b=QvjlSZowZet5zv8amKnAgy0PZ9QeoT5VzXLjBaFF8exr3iHdXTfJgDF66iFPi3z/U3
         F8kgzhUtKXKf1VGfUwo6vjkCu5UBF3svJVrsjS8T0upNJzeyN/4UgqyGCo7gYSnTj9Od
         Gxfq2/cMj1g4Z+a93ilreLC5r5JykkCyxyspataZDCqej/xpppuXUyBboe7I9yZCDKYH
         PlMyE4tKSmq+H9R6J0aEFZy6rhB7ASrpjcRXd6Eq8qASHteH1kLvgulz+uInXiJRFfiG
         o0q4gxxIxD8Q51kToHdXEmAG4hKHVefLmgOevrRb4zkmKCG1BbzmoqF9rPJju+h48m6Q
         3MZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=58aR18/+HW7ZKegb+QXPtZWDO5qdpX2PaqIv3/Ar+KM=;
        b=2Ewdx1Wq/qeN/pDLlcG8bLYm9SvwQt4Cymiw3qErSs6wVAxiO9UgtaDA/2y2P3noQF
         NX/xhPxyIoFxz7L0zAPD85L6O/peNSBCLNNPtMchOEb3ray2bRhNB0mk6cRS92/mNNWV
         rgtbaf0Hg7zq04zEYE1Urrb7zVbx9WHvO4roCUftqJ9ZIcAHwZwuNSqmD+ofpOLAgbw9
         2ZDwIWIO1Ax7Mj/afXRRAAhxDGXwoSGs5So+ZkjcufP4+cy4TD/FvTrc8D2DQjqhqn6O
         hhl1BpMs8nC7piZb8QP9Ea1d1QvYpEtNLZBnwoQ+/eJhVFoLZ0Y+rM8Ib7OIEqFN1xce
         Fexg==
X-Gm-Message-State: AOAM533jBPIjGemm2lxSe/EGB6cm+hk2qL1kNYGsDIWDphlvFVWseurh
        /dhngnEjJVIVcX0roTOnRf+ynVIVMM+G8u17jSTIOtBq
X-Google-Smtp-Source: ABdhPJzsUhx6SmjRnc8xa9G14pWGLpvGZPyrEMJvhJRZLfHnjdmYw5GjXp7IjTiHnJubDs7TCsW6Uz7SfzS7enNboLs=
X-Received: by 2002:ab0:59cf:: with SMTP id k15mr3167850uad.47.1641946156693;
 Tue, 11 Jan 2022 16:09:16 -0800 (PST)
MIME-Version: 1.0
References: <20220111115703.893347-1-hyc.lee@gmail.com> <CAKYAXd-a=8eAE023ECCoBKPD3L+q=Jb=Sem17VSVcheeryt9Dw@mail.gmail.com>
In-Reply-To: <CAKYAXd-a=8eAE023ECCoBKPD3L+q=Jb=Sem17VSVcheeryt9Dw@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 12 Jan 2022 09:09:05 +0900
Message-ID: <CANFS6bahayu7kq6aq3SUcGSKhingopEhdSTZ4M+-MMf=EhGzSw@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: smbd: fix missing client's memory region invalidation
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 1=EC=9B=94 11=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 10:21, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-01-11 20:57 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > if the Channel of a SMB2 WRITE request is
> > SMB2_CHANNEL_RDMA_V1_INVALIDTE, a client
> > does not invalidate its memory regions but
> > ksmbd must do it by sending a SMB2 WRITE response
> > with IB_WR_SEND_WITH_INV.
> >
> > But if errors occur while processing a SMB2
> > READ/WRITE request, ksmbd sends a response
> > with IB_WR_SEND. So a client could use memory
> > regions already in use.
> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > ---
> > changes from v1:
> >  - factor out setting a remote key to a helper functions.
> Can we make it as one helper function if desc, Channel,
> ChannelInfoOffset, ChannelInfoLength are given as arguments?
>

Okay, I will change it.

> >
> >  fs/ksmbd/smb2pdu.c | 58 +++++++++++++++++++++++++++++++++++-----------
> >  1 file changed, 44 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> > index ced8f949a4d6..b87969576642 100644
> > --- a/fs/ksmbd/smb2pdu.c
> > +++ b/fs/ksmbd/smb2pdu.c
> > @@ -6124,13 +6124,11 @@ static noinline int smb2_read_pipe(struct ksmbd=
_work
> > *work)
> >       return err;
> >  }
> >
> > -static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
> > -                                   struct smb2_read_req *req, void *da=
ta_buf,
> > -                                   size_t length)
> > +static int smb2_set_remote_key_for_rdma_read(struct ksmbd_work *work,
> > +                                          struct smb2_read_req *req)
> Can we make it as one helper function if desc, Channel,
> ChannelInfoOffset, ChannelInfoLength are given as arguments? i.e.
> smb2_set_remote_key_for_rdma().
>
> >  {
> >       struct smb2_buffer_desc_v1 *desc =3D
> >               (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
> > -     int err;
> >
> >       if (work->conn->dialect =3D=3D SMB30_PROT_ID &&
> >           req->Channel !=3D SMB2_CHANNEL_RDMA_V1)
> > @@ -6143,6 +6141,16 @@ static ssize_t smb2_read_rdma_channel(struct
> > ksmbd_work *work,
> >       work->need_invalidate_rkey =3D
> >               (req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE);
> >       work->remote_key =3D le32_to_cpu(desc->token);
> > +     return 0;
> > +}
> > +
> > +static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
> > +                                   struct smb2_read_req *req, void *da=
ta_buf,
> > +                                   size_t length)
> > +{
> > +     struct smb2_buffer_desc_v1 *desc =3D
> > +             (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
> > +     int err;
> >
> >       err =3D ksmbd_conn_rdma_write(work->conn, data_buf, length,
> >                                   le32_to_cpu(desc->token),
> > @@ -6179,6 +6187,13 @@ int smb2_read(struct ksmbd_work *work)
> >               return smb2_read_pipe(work);
> >       }
> >
> > +     if (req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
> > +         req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1) {
> > +             err =3D smb2_set_remote_key_for_rdma_read(work, req);
> > +             if (err)
> > +                     goto out;
> > +     }
> > +
> >       fp =3D ksmbd_lookup_fd_slow(work, le64_to_cpu(req->VolatileFileId=
),
> >                                 le64_to_cpu(req->PersistentFileId));
> >       if (!fp) {
> > @@ -6352,17 +6367,11 @@ static noinline int smb2_write_pipe(struct
> > ksmbd_work *work)
> >       return err;
> >  }
> >
> > -static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
> > -                                    struct smb2_write_req *req,
> > -                                    struct ksmbd_file *fp,
> > -                                    loff_t offset, size_t length, bool=
 sync)
> > +static int smb2_set_remote_key_for_rdma_write(struct ksmbd_work *work,
> > +                                           struct smb2_write_req *req)
> >  {
> > -     struct smb2_buffer_desc_v1 *desc;
> > -     char *data_buf;
> > -     int ret;
> > -     ssize_t nbytes;
> > -
> > -     desc =3D (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
> > +     struct smb2_buffer_desc_v1 *desc =3D
> > +             (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
> >
> >       if (work->conn->dialect =3D=3D SMB30_PROT_ID &&
> >           req->Channel !=3D SMB2_CHANNEL_RDMA_V1)
> > @@ -6378,6 +6387,20 @@ static ssize_t smb2_write_rdma_channel(struct
> > ksmbd_work *work,
> >       work->need_invalidate_rkey =3D
> >               (req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE);
> >       work->remote_key =3D le32_to_cpu(desc->token);
> > +     return 0;
> > +}
> > +
> > +static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
> > +                                    struct smb2_write_req *req,
> > +                                    struct ksmbd_file *fp,
> > +                                    loff_t offset, size_t length, bool=
 sync)
> > +{
> > +     struct smb2_buffer_desc_v1 *desc;
> > +     char *data_buf;
> > +     int ret;
> > +     ssize_t nbytes;
> > +
> > +     desc =3D (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
> >
> >       data_buf =3D kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
> >       if (!data_buf)
> > @@ -6425,6 +6448,13 @@ int smb2_write(struct ksmbd_work *work)
> >               return smb2_write_pipe(work);
> >       }
> >
> > +     if (req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1 ||
> > +         req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
> > +             err =3D smb2_set_remote_key_for_rdma_write(work, req);
> > +             if (err)
> > +                     goto out;
> > +     }
> > +
> >       if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABL=
E)) {
> >               ksmbd_debug(SMB, "User does not have write permission\n")=
;
> >               err =3D -EACCES;
> > --
> > 2.25.1
> >
> >



--=20
Thanks,
Hyunchul
