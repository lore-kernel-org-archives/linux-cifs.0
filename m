Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55363C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Apr 2022 06:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbiDYGa3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Apr 2022 02:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbiDYGa2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Apr 2022 02:30:28 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF115C657
        for <linux-cifs@vger.kernel.org>; Sun, 24 Apr 2022 23:27:23 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id e15-20020a9d63cf000000b006054e65aaecso10171962otl.0
        for <linux-cifs@vger.kernel.org>; Sun, 24 Apr 2022 23:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=48Ic8azlFEK0Dd9oIX7aJHh1N2UV1T4cAy2HLGke+zw=;
        b=SYi7Okq4R7piTLlZtfZI7i0rFeKZ2JXhebc18h7I0RYAJEDjEg+U1B7CKuM1gurP2M
         SyKWluFaKJclrnsE9jWrOPXduY6xCDuDcdJsRUFT1J4/n+OT/3fyVoaTri46EFOFFfh8
         2ohbREQAFcCJqUsEZxUIonSKDOedwQ4da3quzVKJwiMXQCZdk17ES1wh/YYtC8L2aPIh
         HcJh1jDz3O2X7D65loS10U7c+gY+zLjjvuwQlUD30BB7OKWHPpP/umoKYnuYMrH8pJ/3
         xE6G2nmDygF7pjy4rgXF8YMOtaz8Hyhf5vAMXe1eI/p0/XzukTC+8FqYF5GujGAAKG/c
         nILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=48Ic8azlFEK0Dd9oIX7aJHh1N2UV1T4cAy2HLGke+zw=;
        b=b9tC2orgq6Gfpo20o06Uzl9WbEKfCNZGfwdN71lJJgBwb+8PKg6evtOG4rSZQX4LIn
         5uiP4kyMI3eqPqsSRlgZWMhjxA+SnOECFavzrh7P6/k3ap2DLF+eMAK9B2fzdL+77QZA
         SFGXkOhsezz6TBcocZWQB9L4CUeqPaMNvddjRtDun18ruek3n3nVasoUzanv6zoJerm8
         3kzO03WpR4uryULaQkzWG9SDzI+fcheTM5U7mYlYQqisZL3+PSHYFNMOJolNFYgaGC81
         1hHBfIRFgTNEUpcyvfC2ewNqH9G1B2vFliecm54zvAx4UcisEKRY7Zvyp93C8THWli1p
         JazA==
X-Gm-Message-State: AOAM5335J7nTixCMhyrWJkFbinJxXWneKTM6YX40SL/H9ESTOVCrwc5q
        Rj7Jn/ZHELUOITg1D9usItk3EHwfwjBy9UqDBKE=
X-Google-Smtp-Source: ABdhPJwOY2LQtFz808YHpTwtQlRuRAOY0k1bYmRvDVvZsCQBf3aKZxXyr85X7U/drAzGDzYLOfsNQcogFuguIdHutIE=
X-Received: by 2002:a05:6830:2641:b0:605:921f:eb74 with SMTP id
 f1-20020a056830264100b00605921feb74mr4713493otu.1.1650868043117; Sun, 24 Apr
 2022 23:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220418051412.13193-1-hyc.lee@gmail.com> <20220418051412.13193-2-hyc.lee@gmail.com>
 <CAKYAXd_R0i0pUMav5CFMJqZe_Q9SzLGFus-sbYXYn3KmTsEjLQ@mail.gmail.com>
In-Reply-To: <CAKYAXd_R0i0pUMav5CFMJqZe_Q9SzLGFus-sbYXYn3KmTsEjLQ@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 25 Apr 2022 15:27:10 +0900
Message-ID: <CANFS6bZbjJJxXTRT6gK7s4vewdGqdTD1sV_gP_ysT3HN=KHbHw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ksmbd: smbd: introduce read/write credits for RDMA read/write
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

2022=EB=85=84 4=EC=9B=94 23=EC=9D=BC (=ED=86=A0) =EC=98=A4=ED=9B=84 11:37, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-04-18 14:14 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > SMB2_READ/SMB2_WRITE request has to be granted the number
> > of rw credits, the pages the request wants to transfer
> > / the maximum pages which can be registered with one
> > MR to read and write a file.
> > And allocate enough RDMA resources for the maximum
> > number of rw credits allowed by ksmbd.
> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > ---
> > changes from v2:
> >  - Split a v2 patch to 4 patches.
> >
> >  fs/ksmbd/transport_rdma.c | 120 +++++++++++++++++++++++---------------
> >  1 file changed, 72 insertions(+), 48 deletions(-)
> >
> > diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> > index 5e34625b5faf..895600cc8c5d 100644
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
> > +static int smb_direct_outstanding_max_read_write =3D 1;
> this variable is neeeded ?

Okay, I will remove this.

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
> > @@ -983,18 +985,19 @@ static int smb_direct_flush_send_list(struct
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
> >
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
> > @@ -1015,7 +1018,19 @@ static int wait_for_send_credits(struct
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
> > @@ -1331,8 +1346,8 @@ static void read_write_done(struct ib_cq *cq, str=
uct
> > ib_wc *wc,
> >               smb_direct_disconnect_rdma_connection(t);
> >       }
> >
> > -     if (atomic_inc_return(&t->rw_avail_ops) > 0)
> > -             wake_up(&t->wait_rw_avail_ops);
> > +     if (atomic_inc_return(&t->rw_credits) > 0)
> > +             wake_up(&t->wait_rw_credits);
> >
> >       rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
> >                           msg->sg_list, msg->sgt.nents, dir);
> > @@ -1363,8 +1378,10 @@ static int smb_direct_rdma_xmit(struct
> > smb_direct_transport *t,
> >       struct ib_send_wr *first_wr =3D NULL;
> >       u32 remote_key =3D le32_to_cpu(desc[0].token);
> >       u64 remote_offset =3D le64_to_cpu(desc[0].offset);
> > +     int credits_needed;
> >
> > -     ret =3D wait_for_credits(t, &t->wait_rw_avail_ops, &t->rw_avail_o=
ps);
> > +     credits_needed =3D calc_rw_credits(t, buf, buf_len);
> > +     ret =3D wait_for_rw_credits(t, credits_needed);
> >       if (ret < 0)
> >               return ret;
> >
> > @@ -1372,7 +1389,7 @@ static int smb_direct_rdma_xmit(struct
> > smb_direct_transport *t,
> >       msg =3D kmalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) =
+
> >                     sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KER=
NEL);
> >       if (!msg) {
> > -             atomic_inc(&t->rw_avail_ops);
> > +             atomic_add(credits_needed, &t->rw_credits);
> >               return -ENOMEM;
> >       }
> >
> > @@ -1381,7 +1398,7 @@ static int smb_direct_rdma_xmit(struct
> > smb_direct_transport *t,
> >                                    get_buf_page_count(buf, buf_len),
> >                                    msg->sg_list, SG_CHUNK_SIZE);
> >       if (ret) {
> > -             atomic_inc(&t->rw_avail_ops);
> > +             atomic_add(credits_needed, &t->rw_credits);
> >               kfree(msg);
> >               return -ENOMEM;
> >       }
> > @@ -1417,7 +1434,7 @@ static int smb_direct_rdma_xmit(struct
> > smb_direct_transport *t,
> >       return 0;
> >
> >  err:
> > -     atomic_inc(&t->rw_avail_ops);
> > +     atomic_add(credits_needed, &t->rw_credits);
> >       if (first_wr)
> >               rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
> >                                   msg->sg_list, msg->sgt.nents,
> > @@ -1642,11 +1659,19 @@ static int smb_direct_prepare_negotiation(struc=
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
> Why is its max of 256 ?

ksmbd uses rdma_rw infrastructure, and it limits the maximum
pages per one Memory region to 256. I haven't found any macro for
the value. nvme seems to define a macro for it by itself.

https://elixir.bootlin.com/linux/latest/source/drivers/nvme/host/rdma.c#L34


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
> > @@ -1658,25 +1683,31 @@ static int smb_direct_init_params(struct
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
> > +     t->max_rw_credits =3D smb_direct_outstanding_max_read_write *
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
> > @@ -1711,7 +1742,7 @@ static int smb_direct_init_params(struct
> > smb_direct_transport *t,
> >
> >       t->send_credit_target =3D smb_direct_send_credit_target;
> >       atomic_set(&t->send_credits, 0);
> > -     atomic_set(&t->rw_avail_ops, smb_direct_max_outstanding_rw_ops);
> > +     atomic_set(&t->rw_credits, t->max_rw_credits);
> >
> >       t->max_send_size =3D smb_direct_max_send_size;
> >       t->max_recv_size =3D smb_direct_max_receive_size;
> > @@ -1719,12 +1750,10 @@ static int smb_direct_init_params(struct
> > smb_direct_transport *t,
> >
> >       cap->max_send_wr =3D max_send_wrs;
> >       cap->max_recv_wr =3D t->recv_credit_max;
> > -     cap->max_send_sge =3D SMB_DIRECT_MAX_SEND_SGES;
> > +     cap->max_send_sge =3D max_sge_per_wr;
> >       cap->max_recv_sge =3D SMB_DIRECT_MAX_RECV_SGES;
> Again, Is there no need to set this value to a value supported by the dev=
ice?
> e.g. device->attrs.max_read_sge

Yes, I think so, because ksmbd needs only 1 sge for receiving a packet
from a client.
Let me know if I am wrong.

>
> >       cap->max_inline_data =3D 0;
> > -     cap->max_rdma_ctxs =3D
> > -             rdma_rw_mr_factor(device, t->cm_id->port_num, max_pages) =
*
> > -             smb_direct_max_outstanding_rw_ops;
> > +     cap->max_rdma_ctxs =3D t->max_rw_credits;
> >       return 0;
> >  }
> >
> > @@ -1817,7 +1846,8 @@ static int smb_direct_create_qpair(struct
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
> > @@ -1826,8 +1856,7 @@ static int smb_direct_create_qpair(struct
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
> > @@ -1856,17 +1885,12 @@ static int smb_direct_create_qpair(struct
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
> > --
> > 2.25.1
> >
> >



--=20
Thanks,
Hyunchul
