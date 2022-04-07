Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0B4C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Apr 2022 00:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiDGAvF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Apr 2022 20:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiDGAvE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Apr 2022 20:51:04 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D011DE6C5
        for <linux-cifs@vger.kernel.org>; Wed,  6 Apr 2022 17:49:04 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id q10so331142vkh.0
        for <linux-cifs@vger.kernel.org>; Wed, 06 Apr 2022 17:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UemPf44OnvW/XK7+t7s199pddCRJfCIPX9/cujiGb14=;
        b=FpCwV+2DWPPES5IQDGwH4IFL3cTr7sX8oRf+sEW7VK9sjlk0LcLA10id7z+6SY4+3F
         qIAgVmiuyxv9inZC1Wt52nh6RKSy1F3Z5j49mLDYUWr5a1Pcbsug/jt/mVrXqujFF30Y
         jDjBdUmgeXZs44/1J+H+MtNUPZBKJ4LPiilmCf48+t2SFnY0Hkg5fu+T6CJ3yB3dBgd7
         FAQary1y3hixVouUjfRG2loM/su5lU+u/Z7L/MMTsWlCs55eOjtJ4NScHCeagYSY/JJI
         eIuyu4VKksiCU4a5qC2BRe4wEh8Z1feDIz1ii3t27xzLnijPOFsXASVoliuFvPbF1APS
         gdNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UemPf44OnvW/XK7+t7s199pddCRJfCIPX9/cujiGb14=;
        b=7vzYLtsgCSyFeFeL1ohWcwrOcYgl47WkbkB7VRJtyp4FV67zF+/LbvIOQE1a1plmwF
         4LqDnyx7ONIB3dMfHtmxlcAz6pcoLY0GF4qNGTNfLwTw8Sa0k2BHMdlMFFrURplk25Hp
         qNQdXNfJC2zyynZtwRDejP3NqN6t4lW6opVHBPQAa3MtFaA9xv/jirJVqo4T/HJA3HAV
         up4+u3EI9oQ0ED6OztRwzpwtlr64cKWhyUvt82M3aQKtJDqiT96qS6u3Mo8YYG19CS3E
         mzVq3DXq8GTyxinxIWXxJ5MAz2IJJxoNdUoFK0NzQhrGlbHYcNtsNjH8Mf5lHahVblm3
         cclQ==
X-Gm-Message-State: AOAM532NyA3/23yNCwjw+B0G21vY3zrNO2+wMtja1LBUj4ggh73G3WkK
        pJOJL0WXim0cyUI7Vj12Tf12eXbqVH2QJoASM/c=
X-Google-Smtp-Source: ABdhPJwdmSBmcA8moYQSCh3emrK23zT4ogUrdS6Y4esBwFaODu9IfKtkHIKFcYx8e/SnkR77dvkk17XmMob+tyGSo/M=
X-Received: by 2002:a1f:a982:0:b0:33e:2d80:4493 with SMTP id
 s124-20020a1fa982000000b0033e2d804493mr4261318vke.37.1649292543103; Wed, 06
 Apr 2022 17:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220404045549.76547-1-hyc.lee@gmail.com> <CAKYAXd_DfPZm+q94v2gBCGbOb1+MQBcBHi7zk1TBHxezt3AoNg@mail.gmail.com>
In-Reply-To: <CAKYAXd_DfPZm+q94v2gBCGbOb1+MQBcBHi7zk1TBHxezt3AoNg@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 7 Apr 2022 09:48:51 +0900
Message-ID: <CANFS6bZPvHMPa8CJicM10ouPv+yGou_HJzDG-ZvpOtdUcD6VSA@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: smbd: handle multiple Buffer Decriptors
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 4=EC=9B=94 6=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 10:46, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-04-04 13:55 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > Make ksmbd handle multiple buffer descriptors
> > when reading and writing files using SMB direct:
> >
> > - Change the prototype of transport's operations
> >   to accept a pointer and length of descriptors.
> > - Post the work requests of rdma_rw_ctx for
> >   RDMA r/w in smb_direct_rdma_xmit(), and
> >   the work request for the READ/WRITE response
> >   with a remote invaliation in smb_direct_writev().
> > - SMB2_READ/WRITE request needs the number of
> >   rw credits, (the pages the request wants to
> >   transfer / the maximum pages which can be
> >   registered with one MR) to read and write
> >   a file.
> > - Allocate enough RDMA resources for the maximum
> >   number of rw credits allowed by ksmbd.
> This patch seems to be a patch that combines 4 or more patches into
> one. Is there a reason you made a patch like this? Can't you split it
> into multiple pieces for review?
>

Okay, I will split this into 3 patches, which are changing
the function prototypes, controlling RDMA resources, and
Reading/writing with multiple buffer descriptors.

> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > ---
> > changes from v1:
> > - use le16_to_cpu() instead of le32_to_cpu() to retrieve
> >   req->ReadChannelInfoOffset(reported by kernel test bot).
> >
> >
> >  fs/ksmbd/connection.c     |  32 ++--
> >  fs/ksmbd/connection.h     |  32 ++--
> >  fs/ksmbd/ksmbd_work.h     |   4 +-
> >  fs/ksmbd/smb2pdu.c        |  77 ++++-----
> >  fs/ksmbd/transport_rdma.c | 344 ++++++++++++++++++++++----------------
> >  fs/ksmbd/transport_tcp.c  |   5 +-
> >  6 files changed, 278 insertions(+), 216 deletions(-)
> >
> > diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
> > index 208d2cff7bd3..6f036ea9f43b 100644
> > --- a/fs/ksmbd/connection.c
> > +++ b/fs/ksmbd/connection.c
> > @@ -191,10 +191,10 @@ int ksmbd_conn_write(struct ksmbd_work *work)
> >       }
> >
> >       ksmbd_conn_lock(conn);
> > -     sent =3D conn->transport->ops->writev(conn->transport, &iov[0],
> > -                                     iov_idx, len,
> > -                                     work->need_invalidate_rkey,
> > -                                     work->remote_key);
> > +     sent =3D conn->transport->ops->writev(conn->transport,
> > +                                         &iov[0], iov_idx, len,
> > +                                         work->need_invalidate_rkey,
> > +                                         work->remote_key);
> >       ksmbd_conn_unlock(conn);
> >
> >       if (sent < 0) {
> > @@ -205,31 +205,35 @@ int ksmbd_conn_write(struct ksmbd_work *work)
> >       return 0;
> >  }
> >
> > -int ksmbd_conn_rdma_read(struct ksmbd_conn *conn, void *buf,
> > -                      unsigned int buflen, u32 remote_key, u64 remote_=
offset,
> > -                      u32 remote_len)
> > +int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
> > +                      void *buf, unsigned int buflen,
> > +                      struct smb2_buffer_desc_v1 *desc,
> > +                      unsigned int desc_len)
> >  {
> >       int ret =3D -EINVAL;
> >
> > +     ksmbd_conn_lock(conn);
> >       if (conn->transport->ops->rdma_read)
> >               ret =3D conn->transport->ops->rdma_read(conn->transport,
> >                                                     buf, buflen,
> > -                                                   remote_key, remote_=
offset,
> > -                                                   remote_len);
> > +                                                   desc, desc_len);
> > +     ksmbd_conn_unlock(conn);
> Is it related to multiple buffer descriptors?

No, I will remove these from this patch.

>
> >       return ret;
> >  }
> >
> > -int ksmbd_conn_rdma_write(struct ksmbd_conn *conn, void *buf,
> > -                       unsigned int buflen, u32 remote_key,
> > -                       u64 remote_offset, u32 remote_len)
> > +int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
> > +                       void *buf, unsigned int buflen,
> > +                       struct smb2_buffer_desc_v1 *desc,
> > +                       unsigned int desc_len)
> >  {
> >       int ret =3D -EINVAL;
> >
> > +     ksmbd_conn_lock(conn);
> >       if (conn->transport->ops->rdma_write)
> >               ret =3D conn->transport->ops->rdma_write(conn->transport,
> >                                                      buf, buflen,
> > -                                                    remote_key, remote=
_offset,
> > -                                                    remote_len);
> > +                                                    desc, desc_len);
> > +     ksmbd_conn_unlock(conn);
> >       return ret;
> >  }
> >
> > diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
> > index 7a59aacb5daa..51722d3a8cf6 100644
> > --- a/fs/ksmbd/connection.h
> > +++ b/fs/ksmbd/connection.h
> > @@ -119,14 +119,18 @@ struct ksmbd_transport_ops {
> >       void (*disconnect)(struct ksmbd_transport *t);
> >       void (*shutdown)(struct ksmbd_transport *t);
> >       int (*read)(struct ksmbd_transport *t, char *buf, unsigned int si=
ze);
> > -     int (*writev)(struct ksmbd_transport *t, struct kvec *iovs, int n=
iov,
> > -                   int size, bool need_invalidate_rkey,
> > +     int (*writev)(struct ksmbd_transport *t,
> > +                   struct kvec *iovs, int niov, int size,
> > +                   bool need_invalidate,
> >                     unsigned int remote_key);
> > -     int (*rdma_read)(struct ksmbd_transport *t, void *buf, unsigned i=
nt len,
> > -                      u32 remote_key, u64 remote_offset, u32 remote_le=
n);
> > -     int (*rdma_write)(struct ksmbd_transport *t, void *buf,
> > -                       unsigned int len, u32 remote_key, u64 remote_of=
fset,
> > -                       u32 remote_len);
> > +     int (*rdma_read)(struct ksmbd_transport *t,
> > +                      void *buf, unsigned int len,
> > +                      struct smb2_buffer_desc_v1 *desc,
> > +                      unsigned int desc_len);
> > +     int (*rdma_write)(struct ksmbd_transport *t,
> > +                       void *buf, unsigned int len,
> > +                       struct smb2_buffer_desc_v1 *desc,
> > +                       unsigned int desc_len);
> >  };
> >
> >  struct ksmbd_transport {
> > @@ -148,12 +152,14 @@ struct ksmbd_conn *ksmbd_conn_alloc(void);
> >  void ksmbd_conn_free(struct ksmbd_conn *conn);
> >  bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
> >  int ksmbd_conn_write(struct ksmbd_work *work);
> > -int ksmbd_conn_rdma_read(struct ksmbd_conn *conn, void *buf,
> > -                      unsigned int buflen, u32 remote_key, u64 remote_=
offset,
> > -                      u32 remote_len);
> > -int ksmbd_conn_rdma_write(struct ksmbd_conn *conn, void *buf,
> > -                       unsigned int buflen, u32 remote_key, u64 remote=
_offset,
> > -                       u32 remote_len);
> > +int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
> > +                      void *buf, unsigned int buflen,
> > +                      struct smb2_buffer_desc_v1 *desc,
> > +                      unsigned int desc_len);
> > +int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
> > +                       void *buf, unsigned int buflen,
> > +                       struct smb2_buffer_desc_v1 *desc,
> > +                       unsigned int desc_len);
> >  void ksmbd_conn_enqueue_request(struct ksmbd_work *work);
> >  int ksmbd_conn_try_dequeue_request(struct ksmbd_work *work);
> >  void ksmbd_conn_init_server_callbacks(struct ksmbd_conn_ops *ops);
> > diff --git a/fs/ksmbd/ksmbd_work.h b/fs/ksmbd/ksmbd_work.h
> > index 5ece58e40c97..58bfc661000d 100644
> > --- a/fs/ksmbd/ksmbd_work.h
> > +++ b/fs/ksmbd/ksmbd_work.h
> > @@ -69,9 +69,9 @@ struct ksmbd_work {
> >       bool                            encrypted:1;
> >       /* Is this SYNC or ASYNC ksmbd_work */
> >       bool                            syncronous:1;
> > -     bool                            need_invalidate_rkey:1;
> > +     bool                            need_invalidate_rkey:1;
> >
> > -     unsigned int                    remote_key;
> > +     unsigned int                    remote_key;
> You change only need_invalidate_rkey and remote_key  to tab? What
> about other variables in this structure?
> >       /* cancel works */
> >       int                             async_id;
> >       void                            **cancel_argv;
> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> > index 3bf6c56c654c..8d41e4966905 100644
> > --- a/fs/ksmbd/smb2pdu.c
> > +++ b/fs/ksmbd/smb2pdu.c
> > @@ -6115,11 +6115,11 @@ static noinline int smb2_read_pipe(struct ksmbd=
_work
> > *work)
> >       return err;
> >  }
> >
> > -static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
> > -                                     struct smb2_buffer_desc_v1 *desc,
> > -                                     __le32 Channel,
> > -                                     __le16 ChannelInfoOffset,
> > -                                     __le16 ChannelInfoLength)
> > +static int smb2_validate_rdma_buffer_descs(struct ksmbd_work *work,
> > +                                        struct smb2_buffer_desc_v1 *de=
sc,
> > +                                        __le32 Channel,
> > +                                        __le16 ChannelInfoOffset,
> > +                                        __le16 ChannelInfoLength)
> >  {
> >       unsigned int i, ch_count;
> >
> > @@ -6136,15 +6136,13 @@ static int smb2_set_remote_key_for_rdma(struct
> > ksmbd_work *work,
> >                               le32_to_cpu(desc[i].length));
> >               }
> >       }
> > -     if (ch_count !=3D 1) {
> > -             ksmbd_debug(RDMA, "RDMA multiple buffer descriptors %d ar=
e not supported
> > yet\n",
> > -                         ch_count);
> > +     if (ch_count < 1)
> if (!ch_count)

I will change it.

>
> >               return -EINVAL;
> > -     }
> >
> > -     work->need_invalidate_rkey =3D
> > -             (Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE);
> > -     work->remote_key =3D le32_to_cpu(desc->token);
> > +     if (Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
> > +             work->need_invalidate_rkey =3D true;
> > +             work->remote_key =3D le32_to_cpu(desc[0].token);
> > +     }
> >       return 0;
> >  }
> >
> > @@ -6152,14 +6150,12 @@ static ssize_t smb2_read_rdma_channel(struct
> > ksmbd_work *work,
> >                                     struct smb2_read_req *req, void *da=
ta_buf,
> >                                     size_t length)
> >  {
> > -     struct smb2_buffer_desc_v1 *desc =3D
> > -             (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
> >       int err;
> >
> >       err =3D ksmbd_conn_rdma_write(work->conn, data_buf, length,
> > -                                 le32_to_cpu(desc->token),
> > -                                 le64_to_cpu(desc->offset),
> > -                                 le32_to_cpu(desc->length));
> > +                                 (struct smb2_buffer_desc_v1 *)
> > +                                 ((char *)req + le16_to_cpu(req->ReadC=
hannelInfoOffset)),
> > +                                 le16_to_cpu(req->ReadChannelInfoLengt=
h));
> >       if (err)
> >               return err;
> >
> > @@ -6193,18 +6189,20 @@ int smb2_read(struct ksmbd_work *work)
> >
> >       if (req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
> >           req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1) {
> > -             unsigned int ch_offset =3D le16_to_cpu(req->ReadChannelIn=
foOffset);
> > +             struct smb2_buffer_desc_v1 *descs =3D (struct smb2_buffer=
_desc_v1 *)
> > +                     ((char *)req + le16_to_cpu(req->ReadChannelInfoOf=
fset));
> >
> > -             if (ch_offset < offsetof(struct smb2_read_req, Buffer)) {
> > +             if (le16_to_cpu(req->ReadChannelInfoOffset) <
> > +                 offsetof(struct smb2_read_req, Buffer)) {
> >                       err =3D -EINVAL;
> >                       goto out;
> >               }
> > -             err =3D smb2_set_remote_key_for_rdma(work,
> > -                                                (struct smb2_buffer_de=
sc_v1 *)
> > -                                                ((char *)req + ch_offs=
et),
> > -                                                req->Channel,
> > -                                                req->ReadChannelInfoOf=
fset,
> > -                                                req->ReadChannelInfoLe=
ngth);
> > +
> > +             err =3D smb2_validate_rdma_buffer_descs(work,
> > +                                                   descs,
> > +                                                   req->Channel,
> > +                                                   req->ReadChannelInf=
oOffset,
> > +                                                   req->ReadChannelInf=
oLength);
> >               if (err)
> >                       goto out;
> >       }
> > @@ -6252,8 +6250,7 @@ int smb2_read(struct ksmbd_work *work)
> >               work->aux_payload_buf =3D NULL;
> >               rsp->hdr.Status =3D STATUS_END_OF_FILE;
> >               smb2_set_err_rsp(work);
> > -             ksmbd_fd_put(work, fp);
> > -             return 0;
> > +             goto out;
> >       }
> >
> >       ksmbd_debug(SMB, "nbytes %zu, offset %lld mincount %zu\n",
> > @@ -6386,21 +6383,18 @@ static ssize_t smb2_write_rdma_channel(struct
> > ksmbd_work *work,
> >                                      struct ksmbd_file *fp,
> >                                      loff_t offset, size_t length, bool=
 sync)
> >  {
> > -     struct smb2_buffer_desc_v1 *desc;
> >       char *data_buf;
> >       int ret;
> >       ssize_t nbytes;
> >
> > -     desc =3D (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
> > -
> >       data_buf =3D kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
> >       if (!data_buf)
> >               return -ENOMEM;
> >
> >       ret =3D ksmbd_conn_rdma_read(work->conn, data_buf, length,
> > -                                le32_to_cpu(desc->token),
> > -                                le64_to_cpu(desc->offset),
> > -                                le32_to_cpu(desc->length));
> > +                                (struct smb2_buffer_desc_v1 *)
> > +                                ((char *)req + le16_to_cpu(req->WriteC=
hannelInfoOffset)),
> > +                                le16_to_cpu(req->WriteChannelInfoLengt=
h));
> >       if (ret < 0) {
> >               kvfree(data_buf);
> >               return ret;
> > @@ -6441,19 +6435,20 @@ int smb2_write(struct ksmbd_work *work)
> >
> >       if (req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1 ||
> >           req->Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
> > -             unsigned int ch_offset =3D le16_to_cpu(req->WriteChannelI=
nfoOffset);
> > +             struct smb2_buffer_desc_v1 *descs =3D (struct smb2_buffer=
_desc_v1 *)
> > +                     ((char *)req + le16_to_cpu(req->WriteChannelInfoO=
ffset));
> >
> >               if (req->Length !=3D 0 || req->DataOffset !=3D 0 ||
> > -                 ch_offset < offsetof(struct smb2_write_req, Buffer)) =
{
> > +                 le16_to_cpu(req->WriteChannelInfoOffset) <
> > +                 offsetof(struct smb2_write_req, Buffer)) {
> >                       err =3D -EINVAL;
> >                       goto out;
> >               }
> > -             err =3D smb2_set_remote_key_for_rdma(work,
> > -                                                (struct smb2_buffer_de=
sc_v1 *)
> > -                                                ((char *)req + ch_offs=
et),
> > -                                                req->Channel,
> > -                                                req->WriteChannelInfoO=
ffset,
> > -                                                req->WriteChannelInfoL=
ength);
> > +             err =3D smb2_validate_rdma_buffer_descs(work,
> > +                                                   descs,
> > +                                                   req->Channel,
> > +                                                   req->WriteChannelIn=
foOffset,
> > +                                                   req->WriteChannelIn=
foLength);
> >               if (err)
> >                       goto out;
> >       }
> > diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> > index e646d79554b8..1eee4be0fe32 100644
> > --- a/fs/ksmbd/transport_rdma.c
> > +++ b/fs/ksmbd/transport_rdma.c
> > @@ -80,9 +80,9 @@ static int smb_direct_max_fragmented_recv_size =3D 10=
24 *
> > 1024;
> >  /*  The maximum single-message size which can be received */
> >  static int smb_direct_max_receive_size =3D 8192;
> >
> > -static int smb_direct_max_read_write_size =3D 524224;
> > +static int smb_direct_max_read_write_size =3D 8 * 1024 * 1024;
> >
> > -static int smb_direct_max_outstanding_rw_ops =3D 8;
> > +static int smb_direct_max_outstanding_rw_ops =3D 1;
> I wonder why this set is decreased.

Because too many RDMA resources have to be allocated for
max_read_write_size * max_outstanding_rw_ops.

These values mean that a ksmbd connection can handle
just one request for 8MB simultaneously, but eight requests
for 1MB simultaneously. So nothing has not changed.

> >
> >  static LIST_HEAD(smb_direct_device_list);
> >  static DEFINE_RWLOCK(smb_direct_device_lock);
> > @@ -147,10 +147,12 @@ struct smb_direct_transport {
> >       atomic_t                send_credits;
> >       spinlock_t              lock_new_recv_credits;
> >       int                     new_recv_credits;
> > -     atomic_t                rw_avail_ops;
> > +     int                     max_rw_credits;
> > +     int                     pages_per_rw_credit;
> > +     atomic_t                rw_credits;
> >
> >       wait_queue_head_t       wait_send_credits;
> > -     wait_queue_head_t       wait_rw_avail_ops;
> > +     wait_queue_head_t       wait_rw_credits;
> >
> >       mempool_t               *sendmsg_mempool;
> >       struct kmem_cache       *sendmsg_cache;
> > @@ -159,8 +161,6 @@ struct smb_direct_transport {
> >
> >       wait_queue_head_t       wait_send_payload_pending;
> >       atomic_t                send_payload_pending;
> > -     wait_queue_head_t       wait_send_pending;
> > -     atomic_t                send_pending;
> >
> >       struct delayed_work     post_recv_credits_work;
> >       struct work_struct      send_immediate_work;
> > @@ -208,7 +208,9 @@ struct smb_direct_recvmsg {
> >  struct smb_direct_rdma_rw_msg {
> >       struct smb_direct_transport     *t;
> >       struct ib_cqe           cqe;
> > +     int                     status;
> >       struct completion       *completion;
> > +     struct list_head        list;
> >       struct rdma_rw_ctx      rw_ctx;
> >       struct sg_table         sgt;
> >       struct scatterlist      sg_list[];
> > @@ -377,7 +379,7 @@ static struct smb_direct_transport
> > *alloc_transport(struct rdma_cm_id *cm_id)
> >       t->reassembly_queue_length =3D 0;
> >       init_waitqueue_head(&t->wait_reassembly_queue);
> >       init_waitqueue_head(&t->wait_send_credits);
> > -     init_waitqueue_head(&t->wait_rw_avail_ops);
> > +     init_waitqueue_head(&t->wait_rw_credits);
> >
> >       spin_lock_init(&t->receive_credit_lock);
> >       spin_lock_init(&t->recvmsg_queue_lock);
> > @@ -388,8 +390,6 @@ static struct smb_direct_transport
> > *alloc_transport(struct rdma_cm_id *cm_id)
> >
> >       init_waitqueue_head(&t->wait_send_payload_pending);
> >       atomic_set(&t->send_payload_pending, 0);
> > -     init_waitqueue_head(&t->wait_send_pending);
> > -     atomic_set(&t->send_pending, 0);
> >
> >       spin_lock_init(&t->lock_new_recv_credits);
> >
> > @@ -419,8 +419,6 @@ static void free_transport(struct smb_direct_transp=
ort
> > *t)
> >       ksmbd_debug(RDMA, "wait for all send posted to IB to finish\n");
> >       wait_event(t->wait_send_payload_pending,
> >                  atomic_read(&t->send_payload_pending) =3D=3D 0);
> > -     wait_event(t->wait_send_pending,
> > -                atomic_read(&t->send_pending) =3D=3D 0);
> >
> >       cancel_work_sync(&t->disconnect_work);
> >       cancel_delayed_work_sync(&t->post_recv_credits_work);
> > @@ -682,10 +680,8 @@ static int smb_direct_read(struct ksmbd_transport =
*t,
> > char *buf,
> >       struct smb_direct_transport *st =3D smb_trans_direct_transfort(t)=
;
> >
> >  again:
> > -     if (st->status !=3D SMB_DIRECT_CS_CONNECTED) {
> > -             pr_err("disconnected\n");
> > +     if (st->status !=3D SMB_DIRECT_CS_CONNECTED)
> >               return -ENOTCONN;
> > -     }
> >
> >       /*
> >        * No need to hold the reassembly queue lock all the time as we a=
re
> > @@ -873,13 +869,8 @@ static void send_done(struct ib_cq *cq, struct ib_=
wc
> > *wc)
> >               smb_direct_disconnect_rdma_connection(t);
> >       }
> >
> > -     if (sendmsg->num_sge > 1) {
> > -             if (atomic_dec_and_test(&t->send_payload_pending))
> > -                     wake_up(&t->wait_send_payload_pending);
> > -     } else {
> > -             if (atomic_dec_and_test(&t->send_pending))
> > -                     wake_up(&t->wait_send_pending);
> > -     }
> > +     if (atomic_dec_and_test(&t->send_payload_pending))
> > +             wake_up(&t->wait_send_payload_pending);
> >
> >       /* iterate and free the list of messages in reverse. the list's h=
ead
> >        * is invalid.
> > @@ -911,21 +902,12 @@ static int smb_direct_post_send(struct
> > smb_direct_transport *t,
> >  {
> >       int ret;
> >
> > -     if (wr->num_sge > 1)
> > -             atomic_inc(&t->send_payload_pending);
> > -     else
> > -             atomic_inc(&t->send_pending);
> > -
> > +     atomic_inc(&t->send_payload_pending);
> >       ret =3D ib_post_send(t->qp, wr, NULL);
> >       if (ret) {
> >               pr_err("failed to post send: %d\n", ret);
> > -             if (wr->num_sge > 1) {
> > -                     if (atomic_dec_and_test(&t->send_payload_pending)=
)
> > -                             wake_up(&t->wait_send_payload_pending);
> > -             } else {
> > -                     if (atomic_dec_and_test(&t->send_pending))
> > -                             wake_up(&t->wait_send_pending);
> > -             }
> > +             if (atomic_dec_and_test(&t->send_payload_pending))
> > +                     wake_up(&t->wait_send_payload_pending);
> >               smb_direct_disconnect_rdma_connection(t);
> >       }
> >       return ret;
> > @@ -983,18 +965,18 @@ static int smb_direct_flush_send_list(struct
> > smb_direct_transport *t,
> >  }
> >
> >  static int wait_for_credits(struct smb_direct_transport *t,
> > -                         wait_queue_head_t *waitq, atomic_t *credits)
> > +                         wait_queue_head_t *waitq, atomic_t *total_cre=
dits,
> > +                         int needed)
> >  {
> >       int ret;
> >
> >       do {
> > -             if (atomic_dec_return(credits) >=3D 0)
> > +             if (atomic_sub_return(needed, total_credits) >=3D 0)
> >                       return 0;
> > -
> > -             atomic_inc(credits);
> > +             atomic_add(needed, total_credits);
> >               ret =3D wait_event_interruptible(*waitq,
> > -                                            atomic_read(credits) > 0 |=
|
> > -                                             t->status !=3D SMB_DIRECT=
_CS_CONNECTED);
> > +                                            atomic_read(total_credits)=
 >=3D needed ||
> > +                                            t->status !=3D SMB_DIRECT_=
CS_CONNECTED);
> >
> >               if (t->status !=3D SMB_DIRECT_CS_CONNECTED)
> >                       return -ENOTCONN;
> > @@ -1015,7 +997,19 @@ static int wait_for_send_credits(struct
> > smb_direct_transport *t,
> >                       return ret;
> >       }
> >
> > -     return wait_for_credits(t, &t->wait_send_credits, &t->send_credit=
s);
> > +     return wait_for_credits(t, &t->wait_send_credits, &t->send_credit=
s, 1);
> > +}
> > +
> > +static int wait_for_rw_credits(struct smb_direct_transport *t, int
> > credits)
> > +{
> > +     return wait_for_credits(t, &t->wait_rw_credits, &t->rw_credits, c=
redits);
> > +}
> > +
> > +static int calc_rw_credits(struct smb_direct_transport *t,
> > +                        char *buf, unsigned int len)
> > +{
> > +     return DIV_ROUND_UP(get_buf_page_count(buf, len),
> > +                         t->pages_per_rw_credit);
> >  }
> >
> >  static int smb_direct_create_header(struct smb_direct_transport *t,
> > @@ -1248,7 +1242,8 @@ static int smb_direct_writev(struct ksmbd_transpo=
rt
> > *t,
> >       iov[0].iov_len -=3D 4;
> >
> >       remaining_data_length =3D buflen;
> > -     ksmbd_debug(RDMA, "Sending smb (RDMA): smb_len=3D%u\n", buflen);
> > +     ksmbd_debug(RDMA, "Sending smb (RDMA): smb_len=3D%u, inv=3D%d\n",
> > +                 buflen, need_invalidate);
> >
> >       smb_direct_send_ctx_init(st, &send_ctx, need_invalidate, remote_k=
ey);
> >       start =3D i =3D 0;
> > @@ -1318,6 +1313,18 @@ static int smb_direct_writev(struct ksmbd_transp=
ort
> > *t,
> >       return ret;
> >  }
> >
> > +static void smb_direct_free_rdma_rw_msg(struct smb_direct_transport *t=
,
> > +                                     struct smb_direct_rdma_rw_msg *ms=
g,
> > +                                     enum dma_data_direction dir)
> > +{
> > +     if (msg->sgt.orig_nents) {
> > +             rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
> > +                                 msg->sgt.sgl, msg->sgt.nents, dir);
> > +             sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
> > +     }
> > +     kfree(msg);
> > +}
> > +
> >  static void read_write_done(struct ib_cq *cq, struct ib_wc *wc,
> >                           enum dma_data_direction dir)
> >  {
> > @@ -1326,19 +1333,14 @@ static void read_write_done(struct ib_cq *cq, s=
truct
> > ib_wc *wc,
> >       struct smb_direct_transport *t =3D msg->t;
> >
> >       if (wc->status !=3D IB_WC_SUCCESS) {
> > +             msg->status =3D -EIO;
> >               pr_err("read/write error. opcode =3D %d, status =3D %s(%d=
)\n",
> >                      wc->opcode, ib_wc_status_msg(wc->status), wc->stat=
us);
> > -             smb_direct_disconnect_rdma_connection(t);
> > +             if (wc->status !=3D IB_WC_WR_FLUSH_ERR)
> > +                     smb_direct_disconnect_rdma_connection(t);
> >       }
> >
> > -     if (atomic_inc_return(&t->rw_avail_ops) > 0)
> > -             wake_up(&t->wait_rw_avail_ops);
> > -
> > -     rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
> > -                         msg->sg_list, msg->sgt.nents, dir);
> > -     sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
> >       complete(msg->completion);
> > -     kfree(msg);
> >  }
> >
> >  static void read_done(struct ib_cq *cq, struct ib_wc *wc)
> > @@ -1351,94 +1353,141 @@ static void write_done(struct ib_cq *cq, struc=
t
> > ib_wc *wc)
> >       read_write_done(cq, wc, DMA_TO_DEVICE);
> >  }
> >
> > -static int smb_direct_rdma_xmit(struct smb_direct_transport *t, void *=
buf,
> > -                             int buf_len, u32 remote_key, u64 remote_o=
ffset,
> > -                             u32 remote_len, bool is_read)
> > +static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
> > +                             void *buf, int buf_len,
> > +                             struct smb2_buffer_desc_v1 *desc,
> > +                             unsigned int desc_len,
> > +                             bool is_read)
> >  {
> > -     struct smb_direct_rdma_rw_msg *msg;
> > -     int ret;
> > +     struct smb_direct_rdma_rw_msg *msg, *next_msg;
> > +     int i, ret;
> >       DECLARE_COMPLETION_ONSTACK(completion);
> > -     struct ib_send_wr *first_wr =3D NULL;
> > +     struct ib_send_wr *first_wr;
> > +     LIST_HEAD(msg_list);
> > +     char *desc_buf;
> > +     int credits_needed;
> > +     unsigned int desc_buf_len;
> > +     size_t total_length =3D 0;
> > +
> > +     if (t->status !=3D SMB_DIRECT_CS_CONNECTED)
> > +             return -ENOTCONN;
> > +
> > +     /* calculate needed credits */
> > +     credits_needed =3D 0;
> > +     desc_buf =3D buf;
> > +     for (i =3D 0; i < desc_len / sizeof(*desc); i++) {
> > +             desc_buf_len =3D le32_to_cpu(desc[i].length);
> > +
> > +             credits_needed +=3D calc_rw_credits(t, desc_buf, desc_buf=
_len);
> > +             desc_buf +=3D desc_buf_len;
> > +             total_length +=3D desc_buf_len;
> > +             if (desc_buf_len =3D=3D 0 || total_length > buf_len ||
> > +                 total_length > t->max_rdma_rw_size)
> > +                     return -EINVAL;
> > +     }
> >
> > -     ret =3D wait_for_credits(t, &t->wait_rw_avail_ops, &t->rw_avail_o=
ps);
> > +     ksmbd_debug(RDMA, "RDMA %s, len %#x, needed credits %#x\n",
> > +                 is_read ? "read" : "write", buf_len, credits_needed);
> > +
> > +     ret =3D wait_for_rw_credits(t, credits_needed);
> >       if (ret < 0)
> >               return ret;
> >
> > -     /* TODO: mempool */
> > -     msg =3D kmalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) =
+
> > -                   sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KER=
NEL);
> > -     if (!msg) {
> > -             atomic_inc(&t->rw_avail_ops);
> > -             return -ENOMEM;
> > -     }
> > +     /* build rdma_rw_ctx for each descriptor */
> > +     desc_buf =3D buf;
> > +     for (i =3D 0; i < desc_len / sizeof(*desc); i++) {
> > +             msg =3D kzalloc(offsetof(struct smb_direct_rdma_rw_msg, s=
g_list) +
> > +                           sizeof(struct scatterlist) * SG_CHUNK_SIZE,=
 GFP_KERNEL);
> > +             if (!msg) {
> > +                     ret =3D -ENOMEM;
> > +                     goto out;
> > +             }
> >
> > -     msg->sgt.sgl =3D &msg->sg_list[0];
> > -     ret =3D sg_alloc_table_chained(&msg->sgt,
> > -                                  get_buf_page_count(buf, buf_len),
> > -                                  msg->sg_list, SG_CHUNK_SIZE);
> > -     if (ret) {
> > -             atomic_inc(&t->rw_avail_ops);
> > -             kfree(msg);
> > -             return -ENOMEM;
> > -     }
> > +             desc_buf_len =3D le32_to_cpu(desc[i].length);
> >
> > -     ret =3D get_sg_list(buf, buf_len, msg->sgt.sgl, msg->sgt.orig_nen=
ts);
> > -     if (ret <=3D 0) {
> > -             pr_err("failed to get pages\n");
> > -             goto err;
> > -     }
> > +             msg->t =3D t;
> > +             msg->cqe.done =3D is_read ? read_done : write_done;
> > +             msg->completion =3D &completion;
> >
> > -     ret =3D rdma_rw_ctx_init(&msg->rw_ctx, t->qp, t->qp->port,
> > -                            msg->sg_list, get_buf_page_count(buf, buf_=
len),
> > -                            0, remote_offset, remote_key,
> > -                            is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE)=
;
> > -     if (ret < 0) {
> > -             pr_err("failed to init rdma_rw_ctx: %d\n", ret);
> > -             goto err;
> > +             msg->sgt.sgl =3D &msg->sg_list[0];
> > +             ret =3D sg_alloc_table_chained(&msg->sgt,
> > +                                          get_buf_page_count(desc_buf,=
 desc_buf_len),
> > +                                          msg->sg_list, SG_CHUNK_SIZE)=
;
> > +             if (ret) {
> > +                     kfree(msg);
> > +                     ret =3D -ENOMEM;
> > +                     goto out;
> > +             }
> > +
> > +             ret =3D get_sg_list(desc_buf, desc_buf_len,
> > +                               msg->sgt.sgl, msg->sgt.orig_nents);
> > +             if (ret <=3D 0) {
> > +                     sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
> > +                     kfree(msg);
> > +                     goto out;
> > +             }
> > +
> > +             ret =3D rdma_rw_ctx_init(&msg->rw_ctx, t->qp, t->qp->port=
,
> > +                                    msg->sgt.sgl,
> > +                                    get_buf_page_count(desc_buf, desc_=
buf_len),
> > +                                    0,
> > +                                    le64_to_cpu(desc[i].offset),
> > +                                    le32_to_cpu(desc[i].token),
> > +                                    is_read ? DMA_FROM_DEVICE : DMA_TO=
_DEVICE);
> > +             if (ret < 0) {
> > +                     pr_err("failed to init rdma_rw_ctx: %d\n", ret);
> > +                     sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
> > +                     kfree(msg);
> > +                     goto out;
> > +             }
> > +
> > +             list_add_tail(&msg->list, &msg_list);
> > +             desc_buf +=3D desc_buf_len;
> >       }
> >
> > -     msg->t =3D t;
> > -     msg->cqe.done =3D is_read ? read_done : write_done;
> > -     msg->completion =3D &completion;
> > -     first_wr =3D rdma_rw_ctx_wrs(&msg->rw_ctx, t->qp, t->qp->port,
> > -                                &msg->cqe, NULL);
> > +     /* concatenate work requests of rdma_rw_ctxs */
> > +     first_wr =3D NULL;
> > +     list_for_each_entry_reverse(msg, &msg_list, list) {
> > +             first_wr =3D rdma_rw_ctx_wrs(&msg->rw_ctx, t->qp, t->qp->=
port,
> > +                                        &msg->cqe, first_wr);
> > +     }
> >
> >       ret =3D ib_post_send(t->qp, first_wr, NULL);
> >       if (ret) {
> > -             pr_err("failed to post send wr: %d\n", ret);
> > -             goto err;
> > +             pr_err("failed to post send wr for RDMA R/W: %d\n", ret);
> > +             goto out;
> >       }
> >
> > +     msg =3D list_last_entry(&msg_list, struct smb_direct_rdma_rw_msg,=
 list);
> >       wait_for_completion(&completion);
> > -     return 0;
> > -
> > -err:
> > -     atomic_inc(&t->rw_avail_ops);
> > -     if (first_wr)
> > -             rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
> > -                                 msg->sg_list, msg->sgt.nents,
> > -                                 is_read ? DMA_FROM_DEVICE : DMA_TO_DE=
VICE);
> > -     sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
> > -     kfree(msg);
> > +     ret =3D msg->status;
> > +out:
> > +     list_for_each_entry_safe(msg, next_msg, &msg_list, list) {
> > +             list_del(&msg->list);
> > +             smb_direct_free_rdma_rw_msg(t, msg,
> > +                                         is_read ? DMA_FROM_DEVICE : D=
MA_TO_DEVICE);
> > +     }
> > +     atomic_add(credits_needed, &t->rw_credits);
> > +     wake_up(&t->wait_rw_credits);
> >       return ret;
> >  }
> >
> > -static int smb_direct_rdma_write(struct ksmbd_transport *t, void *buf,
> > -                              unsigned int buflen, u32 remote_key,
> > -                              u64 remote_offset, u32 remote_len)
> > +static int smb_direct_rdma_write(struct ksmbd_transport *t,
> > +                              void *buf, unsigned int buflen,
> > +                              struct smb2_buffer_desc_v1 *desc,
> > +                              unsigned int desc_len)
> >  {
> >       return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, b=
uflen,
> > -                                 remote_key, remote_offset,
> > -                                 remote_len, false);
> > +                                 desc, desc_len, false);
> >  }
> >
> > -static int smb_direct_rdma_read(struct ksmbd_transport *t, void *buf,
> > -                             unsigned int buflen, u32 remote_key,
> > -                             u64 remote_offset, u32 remote_len)
> > +static int smb_direct_rdma_read(struct ksmbd_transport *t,
> > +                             void *buf, unsigned int buflen,
> > +                             struct smb2_buffer_desc_v1 *desc,
> > +                             unsigned int desc_len)
> >  {
> >       return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, b=
uflen,
> > -                                 remote_key, remote_offset,
> > -                                 remote_len, true);
> > +                                 desc, desc_len, true);
> >  }
> >
> >  static void smb_direct_disconnect(struct ksmbd_transport *t)
> > @@ -1567,8 +1616,8 @@ static int smb_direct_send_negotiate_response(str=
uct
> > smb_direct_transport *t,
> >               return ret;
> >       }
> >
> > -     wait_event(t->wait_send_pending,
> > -                atomic_read(&t->send_pending) =3D=3D 0);
> > +     wait_event(t->wait_send_payload_pending,
> > +                atomic_read(&t->send_payload_pending) =3D=3D 0);
> >       return 0;
> >  }
> >
> > @@ -1638,11 +1687,19 @@ static int smb_direct_prepare_negotiation(struc=
t
> > smb_direct_transport *t)
> >       return ret;
> >  }
> >
> > +static unsigned int smb_direct_get_max_fr_pages(struct smb_direct_tran=
sport
> > *t)
> > +{
> > +     return min_t(unsigned int,
> > +                  t->cm_id->device->attrs.max_fast_reg_page_list_len,
> > +                  256);
> > +}
> > +
> >  static int smb_direct_init_params(struct smb_direct_transport *t,
> >                                 struct ib_qp_cap *cap)
> >  {
> >       struct ib_device *device =3D t->cm_id->device;
> > -     int max_send_sges, max_pages, max_rw_wrs, max_send_wrs;
> > +     int max_send_sges, max_rw_wrs, max_send_wrs;
> > +     unsigned int max_sge_per_wr, wrs_per_credit;
> >
> >       /* need 2 more sge. because a SMB_DIRECT header will be mapped,
> >        * and maybe a send buffer could be not page aligned.
> > @@ -1654,25 +1711,31 @@ static int smb_direct_init_params(struct
> > smb_direct_transport *t,
> >               return -EINVAL;
> >       }
> >
> > -     /*
> > -      * allow smb_direct_max_outstanding_rw_ops of in-flight RDMA
> > -      * read/writes. HCA guarantees at least max_send_sge of sges for
> > -      * a RDMA read/write work request, and if memory registration is =
used,
> > -      * we need reg_mr, local_inv wrs for each read/write.
> > +     /* Calculate the number of work requests for RDMA R/W.
> > +      * The maximum number of pages which can be registered
> > +      * with one Memory region can be transferred with one
> > +      * R/W credit. And at least 4 work requests for each credit
> > +      * are needed for MR registration, RDMA R/W, local & remote
> > +      * MR invalidation.
> >        */
> >       t->max_rdma_rw_size =3D smb_direct_max_read_write_size;
> > -     max_pages =3D DIV_ROUND_UP(t->max_rdma_rw_size, PAGE_SIZE) + 1;
> > -     max_rw_wrs =3D DIV_ROUND_UP(max_pages, SMB_DIRECT_MAX_SEND_SGES);
> > -     max_rw_wrs +=3D rdma_rw_mr_factor(device, t->cm_id->port_num,
> > -                     max_pages) * 2;
> > -     max_rw_wrs *=3D smb_direct_max_outstanding_rw_ops;
> > +     t->pages_per_rw_credit =3D smb_direct_get_max_fr_pages(t);
> > +     t->max_rw_credits =3D smb_direct_max_outstanding_rw_ops *
> > +             DIV_ROUND_UP(t->max_rdma_rw_size,
> > +                          (t->pages_per_rw_credit - 1) * PAGE_SIZE);
> > +
> > +     max_sge_per_wr =3D min_t(unsigned int, device->attrs.max_send_sge=
,
> > +                            device->attrs.max_sge_rd);
> > +     wrs_per_credit =3D max_t(unsigned int, 4,
> > +                            DIV_ROUND_UP(t->pages_per_rw_credit,
> > +                                         max_sge_per_wr) + 1);
> > +     max_rw_wrs =3D t->max_rw_credits * wrs_per_credit;
> >
> >       max_send_wrs =3D smb_direct_send_credit_target + max_rw_wrs;
> >       if (max_send_wrs > device->attrs.max_cqe ||
> >           max_send_wrs > device->attrs.max_qp_wr) {
> > -             pr_err("consider lowering send_credit_target =3D %d, or
> > max_outstanding_rw_ops =3D %d\n",
> > -                    smb_direct_send_credit_target,
> > -                    smb_direct_max_outstanding_rw_ops);
> > +             pr_err("consider lowering send_credit_target =3D %d\n",
> > +                    smb_direct_send_credit_target);
> >               pr_err("Possible CQE overrun, device reporting max_cqe %d=
 max_qp_wr
> > %d\n",
> >                      device->attrs.max_cqe, device->attrs.max_qp_wr);
> >               return -EINVAL;
> > @@ -1707,7 +1770,7 @@ static int smb_direct_init_params(struct
> > smb_direct_transport *t,
> >
> >       t->send_credit_target =3D smb_direct_send_credit_target;
> >       atomic_set(&t->send_credits, 0);
> > -     atomic_set(&t->rw_avail_ops, smb_direct_max_outstanding_rw_ops);
> > +     atomic_set(&t->rw_credits, t->max_rw_credits);
> >
> >       t->max_send_size =3D smb_direct_max_send_size;
> >       t->max_recv_size =3D smb_direct_max_receive_size;
> > @@ -1715,12 +1778,10 @@ static int smb_direct_init_params(struct
> > smb_direct_transport *t,
> >
> >       cap->max_send_wr =3D max_send_wrs;
> >       cap->max_recv_wr =3D t->recv_credit_max;
> > -     cap->max_send_sge =3D SMB_DIRECT_MAX_SEND_SGES;
> > +     cap->max_send_sge =3D max_sge_per_wr;
> >       cap->max_recv_sge =3D SMB_DIRECT_MAX_RECV_SGES;
> Is there no need to set this value to a value supported by the device?
> e.g. device->attrs.max_read_sge

Because we don't need more than one(SMB_DIRECT_MAX_REV_SGES),
I think it isn't necessary.

Thank you for your comments!

> >       cap->max_inline_data =3D 0;
> > -     cap->max_rdma_ctxs =3D
> > -             rdma_rw_mr_factor(device, t->cm_id->port_num, max_pages) =
*
> > -             smb_direct_max_outstanding_rw_ops;
> > +     cap->max_rdma_ctxs =3D t->max_rw_credits;
> >       return 0;
> >  }
> >
> > @@ -1813,7 +1874,8 @@ static int smb_direct_create_qpair(struct
> > smb_direct_transport *t,
> >       }
> >
> >       t->send_cq =3D ib_alloc_cq(t->cm_id->device, t,
> > -                              t->send_credit_target, 0, IB_POLL_WORKQU=
EUE);
> > +                              smb_direct_send_credit_target + cap->max=
_rdma_ctxs,
> > +                              0, IB_POLL_WORKQUEUE);
> >       if (IS_ERR(t->send_cq)) {
> >               pr_err("Can't create RDMA send CQ\n");
> >               ret =3D PTR_ERR(t->send_cq);
> > @@ -1822,8 +1884,7 @@ static int smb_direct_create_qpair(struct
> > smb_direct_transport *t,
> >       }
> >
> >       t->recv_cq =3D ib_alloc_cq(t->cm_id->device, t,
> > -                              cap->max_send_wr + cap->max_rdma_ctxs,
> > -                              0, IB_POLL_WORKQUEUE);
> > +                              t->recv_credit_max, 0, IB_POLL_WORKQUEUE=
);
> >       if (IS_ERR(t->recv_cq)) {
> >               pr_err("Can't create RDMA recv CQ\n");
> >               ret =3D PTR_ERR(t->recv_cq);
> > @@ -1852,17 +1913,12 @@ static int smb_direct_create_qpair(struct
> > smb_direct_transport *t,
> >
> >       pages_per_rw =3D DIV_ROUND_UP(t->max_rdma_rw_size, PAGE_SIZE) + 1=
;
> >       if (pages_per_rw > t->cm_id->device->attrs.max_sgl_rd) {
> > -             int pages_per_mr, mr_count;
> > -
> > -             pages_per_mr =3D min_t(int, pages_per_rw,
> > -                                  t->cm_id->device->attrs.max_fast_reg=
_page_list_len);
> > -             mr_count =3D DIV_ROUND_UP(pages_per_rw, pages_per_mr) *
> > -                     atomic_read(&t->rw_avail_ops);
> > -             ret =3D ib_mr_pool_init(t->qp, &t->qp->rdma_mrs, mr_count=
,
> > -                                   IB_MR_TYPE_MEM_REG, pages_per_mr, 0=
);
> > +             ret =3D ib_mr_pool_init(t->qp, &t->qp->rdma_mrs,
> > +                                   t->max_rw_credits, IB_MR_TYPE_MEM_R=
EG,
> > +                                   t->pages_per_rw_credit, 0);
> >               if (ret) {
> >                       pr_err("failed to init mr pool count %d pages %d\=
n",
> > -                            mr_count, pages_per_mr);
> > +                            t->max_rw_credits, t->pages_per_rw_credit)=
;
> >                       goto err;
> >               }
> >       }
> > diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
> > index 8fef9de787d3..4892b0d66a25 100644
> > --- a/fs/ksmbd/transport_tcp.c
> > +++ b/fs/ksmbd/transport_tcp.c
> > @@ -352,8 +352,9 @@ static int ksmbd_tcp_read(struct ksmbd_transport *t=
,
> > char *buf, unsigned int to_
> >       return ksmbd_tcp_readv(TCP_TRANS(t), &iov, 1, to_read);
> >  }
> >
> > -static int ksmbd_tcp_writev(struct ksmbd_transport *t, struct kvec *io=
v,
> > -                         int nvecs, int size, bool need_invalidate,
> > +static int ksmbd_tcp_writev(struct ksmbd_transport *t,
> > +                         struct kvec *iov, int nvecs, int size,
> > +                         bool need_invalidate,
> >                           unsigned int remote_key)
> >
> >  {
> >
> > base-commit: 3123109284176b1532874591f7c81f3837bbdc17
> > --
> > 2.25.1
> >
> >



--=20
Thanks,
Hyunchul
