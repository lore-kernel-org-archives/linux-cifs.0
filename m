Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265BAC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Apr 2022 06:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbiDYGbC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Apr 2022 02:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiDYGa4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Apr 2022 02:30:56 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1B85C652
        for <linux-cifs@vger.kernel.org>; Sun, 24 Apr 2022 23:27:49 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id t15so16098367oie.1
        for <linux-cifs@vger.kernel.org>; Sun, 24 Apr 2022 23:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Bn3zEJcfsrFmI9qp7q9POfqDujQ0Nn0kC2CYo3zFHj0=;
        b=dS0t7KKI2UDv4KDvkbRFX9sZna/tDr9yE8UIXnznr0HkfZzGYM2W//KgpWv/WeHWFz
         1e948Ee+WOtYPK7R9N7YfG/vt6GNgA7hmW7o6fPpb5qSTxGlF5Ku2cQycUGJkEi0p2k6
         dp/a2ewC56GPv9Cb1jV8vR7TtloTnVTV7RN6D92XUwZplsN4ok05M8C58byGlD5TpvWv
         zNIOORWKZqLLPHyp8/BOUVs48vzglIYqW4bPTPsZm9XxGkyBa9Bh5jTBjXyyzSmQcFQ5
         9TaHfzhcQeR90GuUQm4enq8Evi7zEtUK+vepoExDNb7W212Yv2S1xOkb+XLhmPNodIyl
         yDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Bn3zEJcfsrFmI9qp7q9POfqDujQ0Nn0kC2CYo3zFHj0=;
        b=yfVW3OSERiZKPOfjtTUajnDOOOglzo7xzyud9yxKAICJVZkouDzMMJQpJaDIjNAC5m
         QzpexRMGuuiXfyl8SwJvoX4voYeJseZsdbVyhEC41FAmVUdVobDeaexwj4nQDRWtRH1Z
         WBo2AZwsPzdP0En65Qipr1+Aiwar93SpjV9j7WZfbSAllVM57Jnz/WpAkZno49L0RzdX
         2i2HJIQjKEEKc6QykRGMbcpe4NCD3mIsL+l1vuctpwa41CmZSXN0QcUwC8z2V+DaKXqh
         mNVbLu7MAuwhFtxFfH30jCmbI9w/Fz0WTsQnARF4P85Mbhn/f7ZRffE6TXIrLBXp2QFy
         7rwQ==
X-Gm-Message-State: AOAM533MgYFwHN9VQVPeJba7/t6+E1o3bxRiRJ1MFVF+dOT54wexI/+5
        Hzwq0LtXfCzA26vOdyaFWfPDc0f1JrvVaAj9koQNtbOA
X-Google-Smtp-Source: ABdhPJxDiOe7J/K7vTrd7tJzLsGate1mUAErel88zAK2PaTj28pfFDLqo2hkvOU6ikPUqvYOENLJSaZ2inaTXf1ldT8=
X-Received: by 2002:a05:6808:11c4:b0:2d9:c395:f15e with SMTP id
 p4-20020a05680811c400b002d9c395f15emr11626366oiv.47.1650868069022; Sun, 24
 Apr 2022 23:27:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220418051412.13193-1-hyc.lee@gmail.com> <20220418051412.13193-4-hyc.lee@gmail.com>
 <CAKYAXd_j6=3B9oLH_DZGwQP7Myj=AYXa-wpChMTcr6EF1EwvHA@mail.gmail.com>
In-Reply-To: <CAKYAXd_j6=3B9oLH_DZGwQP7Myj=AYXa-wpChMTcr6EF1EwvHA@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 25 Apr 2022 15:27:37 +0900
Message-ID: <CANFS6bYHUCiHQUDVV5FQfAUDwj-6R66sHvcJMTtFGrU4Yzr+yA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] ksmbd: smbd: handle multiple Buffer descriptors
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 4=EC=9B=94 23=EC=9D=BC (=ED=86=A0) =EC=98=A4=ED=9B=84 11:38, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-04-18 14:14 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > Make ksmbd handle multiple buffer descriptors
> > when reading and writing files using SMB direct:
> > Post the work requests of rdma_rw_ctx for
> > RDMA read/write in smb_direct_rdma_xmit(), and
> > the work request for the READ/WRITE response
> > with a remote invalidation in smb_direct_writev().
> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > ---
> > changes from v2:
> >  - Split a v2 patch to 4 patches.
> >
> >  fs/ksmbd/smb2pdu.c        |   5 +-
> >  fs/ksmbd/transport_rdma.c | 166 +++++++++++++++++++++++++-------------
> >  2 files changed, 109 insertions(+), 62 deletions(-)
> >
> > diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> > index fc9b8def50df..621fa3e55fab 100644
> > --- a/fs/ksmbd/smb2pdu.c
> > +++ b/fs/ksmbd/smb2pdu.c
> > @@ -6133,11 +6133,8 @@ static int smb2_set_remote_key_for_rdma(struct
> > ksmbd_work *work,
> >                               le32_to_cpu(desc[i].length));
> >               }
> >       }
> > -     if (ch_count !=3D 1) {
> > -             ksmbd_debug(RDMA, "RDMA multiple buffer descriptors %d ar=
e not supported
> > yet\n",
> > -                         ch_count);
> > +     if (!ch_count)
> >               return -EINVAL;
> > -     }
> >
> >       work->need_invalidate_rkey =3D
> >               (Channel =3D=3D SMB2_CHANNEL_RDMA_V1_INVALIDATE);
> > diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> > index 1343ff8e00fd..410b79edc9f2 100644
> > --- a/fs/ksmbd/transport_rdma.c
> > +++ b/fs/ksmbd/transport_rdma.c
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
> > @@ -1313,6 +1315,18 @@ static int smb_direct_writev(struct ksmbd_transp=
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
> Is there any case where orig_ent is 0?

I will remove this condition.

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
> > @@ -1321,19 +1335,14 @@ static void read_write_done(struct ib_cq *cq, s=
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
> Why is this condition needed ?

IB_WC_FLUSH_ERR is set after the RDMA connection is
disconnected. So we don't need to try to disconnect it again.

> > +                     smb_direct_disconnect_rdma_connection(t);
> >       }
> >
> > -     if (atomic_inc_return(&t->rw_credits) > 0)
> > -             wake_up(&t->wait_rw_credits);
> > -
> > -     rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
> > -                         msg->sg_list, msg->sgt.nents, dir);
> > -     sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
> >       complete(msg->completion);
> > -     kfree(msg);
> >  }
> >
> >  static void read_done(struct ib_cq *cq, struct ib_wc *wc)
> > @@ -1352,75 +1361,116 @@ static int smb_direct_rdma_xmit(struct
> > smb_direct_transport *t,
> >                               unsigned int desc_len,
> >                               bool is_read)
> >  {
> > -     struct smb_direct_rdma_rw_msg *msg;
> > -     int ret;
> > +     struct smb_direct_rdma_rw_msg *msg, *next_msg;
> > +     int i, ret;
> >       DECLARE_COMPLETION_ONSTACK(completion);
> > -     struct ib_send_wr *first_wr =3D NULL;
> > -     u32 remote_key =3D le32_to_cpu(desc[0].token);
> > -     u64 remote_offset =3D le64_to_cpu(desc[0].offset);
> > +     struct ib_send_wr *first_wr;
> > +     LIST_HEAD(msg_list);
> > +     char *desc_buf;
> >       int credits_needed;
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
> > +
> > +     ksmbd_debug(RDMA, "RDMA %s, len %#x, needed credits %#x\n",
> > +                 is_read ? "read" : "write", buf_len, credits_needed);
> >
> > -     credits_needed =3D calc_rw_credits(t, buf, buf_len);
> >       ret =3D wait_for_rw_credits(t, credits_needed);
> >       if (ret < 0)
> >               return ret;
> >
> > -     /* TODO: mempool */
> > -     msg =3D kmalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) =
+
> > -                   sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KER=
NEL);
> > -     if (!msg) {
> > -             atomic_add(credits_needed, &t->rw_credits);
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
> > -             atomic_add(credits_needed, &t->rw_credits);
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
> Is there any problem if this function returns 0?

Yes, 0 means mapping scatterlist is failed. I will change
this function to return an error code in this situation.

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
> > +     ret =3D msg->status;
> > +out:
> > +     list_for_each_entry_safe(msg, next_msg, &msg_list, list) {
> > +             list_del(&msg->list);
> > +             smb_direct_free_rdma_rw_msg(t, msg,
> > +                                         is_read ? DMA_FROM_DEVICE : D=
MA_TO_DEVICE);
> > +     }
> >       atomic_add(credits_needed, &t->rw_credits);
> > -     if (first_wr)
> > -             rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
> > -                                 msg->sg_list, msg->sgt.nents,
> > -                                 is_read ? DMA_FROM_DEVICE : DMA_TO_DE=
VICE);
> > -     sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
> > -     kfree(msg);
> > +     wake_up(&t->wait_rw_credits);
> >       return ret;
> >  }
> >
> > --
> > 2.25.1
> >
> >



--=20
Thanks,
Hyunchul
