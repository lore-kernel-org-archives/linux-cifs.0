Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AE3C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Jan 2022 01:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiADBTO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Jan 2022 20:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiADBTN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Jan 2022 20:19:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D34C061761
        for <linux-cifs@vger.kernel.org>; Mon,  3 Jan 2022 17:19:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90314B81087
        for <linux-cifs@vger.kernel.org>; Tue,  4 Jan 2022 01:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABBDC36AED
        for <linux-cifs@vger.kernel.org>; Tue,  4 Jan 2022 01:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641259150;
        bh=9M8HUsN1Ucsoc9HCEDebtO8C79YxVhEy5709nuYs/Ag=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=tDo3FyLPWHqc5Pv3Q71tcMg8VUq56Dqtd/OHl0e5DJPVIBrs+lLQUadq2hqPOQDiZ
         1C3ji/x3rAYQjeinbuhzzFoBpOD8t2iTVqPDh4QrVjdvQw+1h4OFbieeus18r7u7XL
         ujufu7+Lb31zddeyDdGkUh5d/xTRmnTLtmqg7/o3EpTSFYbKIdEvHbbSW7auXd6QgT
         2o9KiVW3PB2tFmPCn/X1g7cXRm2C3NF7vdNYIgc2ueVK0ZgMjeCFHZ1jcNCooy4k8z
         pHiCcxHYddHX/OWQ8hYhWlA187kgEpnLXGuVObnnyXkhkkRVyX/h0SNJIztd0pfcaZ
         1ALt9jfwdrWqg==
Received: by mail-yb1-f176.google.com with SMTP id 139so71969741ybd.3
        for <linux-cifs@vger.kernel.org>; Mon, 03 Jan 2022 17:19:10 -0800 (PST)
X-Gm-Message-State: AOAM531gUXFlhPYch3dMItvb2UDglQVsOcanva/kVLo3mXCEttKOSh6U
        5jMzOhVUeAfeEXi0TIB148chTkF59gY0CS+tHZA=
X-Google-Smtp-Source: ABdhPJx4eUI94m1OwrXlfB5nFyljcZfJ5vuGrmK9Q33D+m+3MNWOPPdUQ88RCcaNNvhkD+rsA7lfK5X9XRjhO5PIDVM=
X-Received: by 2002:a25:d6d5:: with SMTP id n204mr10017398ybg.722.1641259149316;
 Mon, 03 Jan 2022 17:19:09 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:4357:b0:11e:f0cd:2c0e with HTTP; Mon, 3 Jan 2022
 17:19:08 -0800 (PST)
In-Reply-To: <CANFS6bZAw9gKpjAuYcFJFkPJ2bUHzAPBD2wkxFy9f=V-eXZkzw@mail.gmail.com>
References: <20220103000203.201107-1-hyc.lee@gmail.com> <CAKYAXd9GovqRjUKQHyKXMPPtaC_kZPs5+vi2cqZkQJmA41P0ig@mail.gmail.com>
 <CANFS6bZAw9gKpjAuYcFJFkPJ2bUHzAPBD2wkxFy9f=V-eXZkzw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 4 Jan 2022 10:19:08 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_+XV6rB9QT_aqV2a4n6VG+HUwZbUitS196-3BVFdyEog@mail.gmail.com>
Message-ID: <CAKYAXd_+XV6rB9QT_aqV2a4n6VG+HUwZbUitS196-3BVFdyEog@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: smbd: call rdma_accept() under CM handler
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-04 10:10 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2022=EB=85=84 1=EC=9B=94 4=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 9:45, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> 2022-01-03 9:02 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
>> > if CONFIG_LOCKDEP is enabled, the following
>> > kernel warning message is generated because
>> > rdma_accept() is called not under CM(Connection
>> > Manager) handler.
>> >
>> > [   63.211405 ] WARNING: CPU: 1 PID: 345 at
>> > drivers/infiniband/core/cma.c:4405 rdma_accept+0x17a/0x350
>> > [   63.212080 ] RIP: 0010:rdma_accept+0x17a/0x350
>> > ...
>> > [   63.214036 ] Call Trace:
>> > [   63.214098 ]  <TASK>
>> > [   63.214185 ]  smb_direct_accept_client+0xb4/0x170 [ksmbd]
>> > [   63.214412 ]  smb_direct_prepare+0x322/0x8c0 [ksmbd]
>> > [   63.214555 ]  ? rcu_read_lock_sched_held+0x3a/0x70
>> > [   63.214700 ]  ksmbd_conn_handler_loop+0x63/0x270 [ksmbd]
>> > [   63.214826 ]  ? ksmbd_conn_alive+0x80/0x80 [ksmbd]
>> > [   63.214952 ]  kthread+0x171/0x1a0
>> > [   63.215039 ]  ? set_kthread_struct+0x40/0x40
>> > [   63.215128 ]  ret_from_fork+0x22/0x30
>> I could not understand why lockdep trigger this warning.
>> Could you elaborate more ?
>>
>
> rdma_accept checks whether the handler_mutex is held. if not,
> this warning is generated. And CM holds the handler_mutex before
> ksmbd's handler callback is called.
Okay, please update patch description with this.
>
>> >
>> > To avoid this, move creating a queue pair and accepting
>> > a client from transport_ops->prepare() to
>> > smb_direct_handle_connect_request().
>> >
>> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> > ---
>> >  fs/ksmbd/transport_rdma.c | 97 +++++++++++++++++++++++---------------=
-
>> >  1 file changed, 57 insertions(+), 40 deletions(-)
>> >
>> > diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>> > index f89b64e27836..b37e4b9580ae 100644
>> > --- a/fs/ksmbd/transport_rdma.c
>> > +++ b/fs/ksmbd/transport_rdma.c
>> > @@ -568,6 +568,7 @@ static void recv_done(struct ib_cq *cq, struct
>> > ib_wc
>> > *wc)
>> >               }
>> >               t->negotiation_requested =3D true;
>> >               t->full_packet_received =3D true;
>> > +             enqueue_reassembly(t, recvmsg, 0);
>> Is this a fix related to this patch?
>
> Yes, this is required to receive the negotiation request
> from a client.
> Before this patch, posting a buffer and waiting for
> the request is done in a function. Because
> we have the reference of the buffer, we don't need to
> append it into the queue.
Okay.
>
>
>> >               wake_up_interruptible(&t->wait_status);
>> >               break;
>> >       case SMB_DIRECT_MSG_DATA_TRANSFER: {
>> > @@ -1594,19 +1595,13 @@ static int smb_direct_accept_client(struct
>> > smb_direct_transport *t)
>> >               pr_err("error at rdma_accept: %d\n", ret);
>> >               return ret;
>> >       }
>> > -
>> > -     wait_event_interruptible(t->wait_status,
>> > -                              t->status !=3D SMB_DIRECT_CS_NEW);
>> > -     if (t->status !=3D SMB_DIRECT_CS_CONNECTED)
>> > -             return -ENOTCONN;
>> >       return 0;
>> >  }
>> >
>> > -static int smb_direct_negotiate(struct smb_direct_transport *t)
>> > +static int smb_direct_prepare_negotiation(struct smb_direct_transport
>> > *t)
>> >  {
>> >       int ret;
>> >       struct smb_direct_recvmsg *recvmsg;
>> > -     struct smb_direct_negotiate_req *req;
>> >
>> >       recvmsg =3D get_free_recvmsg(t);
>> >       if (!recvmsg)
>> > @@ -1616,44 +1611,20 @@ static int smb_direct_negotiate(struct
>> > smb_direct_transport *t)
>> >       ret =3D smb_direct_post_recv(t, recvmsg);
>> >       if (ret) {
>> >               pr_err("Can't post recv: %d\n", ret);
>> > -             goto out;
>> > +             goto out_err;
>> >       }
>> >
>> >       t->negotiation_requested =3D false;
>> >       ret =3D smb_direct_accept_client(t);
>> >       if (ret) {
>> >               pr_err("Can't accept client\n");
>> > -             goto out;
>> > +             goto out_err;
>> >       }
>> >
>> >       smb_direct_post_recv_credits(&t->post_recv_credits_work.work);
>> > -
>> > -     ksmbd_debug(RDMA, "Waiting for SMB_DIRECT negotiate request\n");
>> > -     ret =3D wait_event_interruptible_timeout(t->wait_status,
>> > -                                            t->negotiation_requested
>> > ||
>> > -                                             t->status =3D=3D
>> > SMB_DIRECT_CS_DISCONNECTED,
>> > -
>> > SMB_DIRECT_NEGOTIATE_TIMEOUT * HZ);
>> > -     if (ret <=3D 0 || t->status =3D=3D SMB_DIRECT_CS_DISCONNECTED) {
>> > -             ret =3D ret < 0 ? ret : -ETIMEDOUT;
>> > -             goto out;
>> > -     }
>> > -
>> > -     ret =3D smb_direct_check_recvmsg(recvmsg);
>> > -     if (ret =3D=3D -ECONNABORTED)
>> > -             goto out;
>> > -
>> > -     req =3D (struct smb_direct_negotiate_req *)recvmsg->packet;
>> > -     t->max_recv_size =3D min_t(int, t->max_recv_size,
>> > -                              le32_to_cpu(req->preferred_send_size));
>> > -     t->max_send_size =3D min_t(int, t->max_send_size,
>> > -                              le32_to_cpu(req->max_receive_size));
>> > -     t->max_fragmented_send_size =3D
>> > -                     le32_to_cpu(req->max_fragmented_size);
>> > -
>> > -     ret =3D smb_direct_send_negotiate_response(t, ret);
>> > -out:
>> > -     if (recvmsg)
>> > -             put_recvmsg(t, recvmsg);
>> > +     return 0;
>> > +out_err:
>> > +     put_recvmsg(t, recvmsg);
>> >       return ret;
>> >  }
>> >
>> > @@ -1890,6 +1861,47 @@ static int smb_direct_create_qpair(struct
>> > smb_direct_transport *t,
>> >  static int smb_direct_prepare(struct ksmbd_transport *t)
>> >  {
>> >       struct smb_direct_transport *st =3D smb_trans_direct_transfort(t=
);
>> > +     struct smb_direct_recvmsg *recvmsg;
>> > +     struct smb_direct_negotiate_req *req;
>> > +     int ret;
>> > +
>> > +     ksmbd_debug(RDMA, "Waiting for SMB_DIRECT negotiate request\n");
>> > +     ret =3D wait_event_interruptible_timeout(st->wait_status,
>> > +                                            st->negotiation_requested
>> > ||
>> > +                                            st->status =3D=3D
>> > SMB_DIRECT_CS_DISCONNECTED,
>> > +
>> > SMB_DIRECT_NEGOTIATE_TIMEOUT * HZ);
>> > +     if (ret <=3D 0 || st->status =3D=3D SMB_DIRECT_CS_DISCONNECTED)
>> > +             return ret < 0 ? ret : -ETIMEDOUT;
>> > +
>> > +     recvmsg =3D get_first_reassembly(st);
>> > +     if (!recvmsg)
>> > +             return -ECONNABORTED;
>> > +
>> > +     ret =3D smb_direct_check_recvmsg(recvmsg);
>> > +     if (ret =3D=3D -ECONNABORTED)
>> > +             goto out;
>> > +
>> > +     req =3D (struct smb_direct_negotiate_req *)recvmsg->packet;
>> > +     st->max_recv_size =3D min_t(int, st->max_recv_size,
>> > +                               le32_to_cpu(req->preferred_send_size))=
;
>> > +     st->max_send_size =3D min_t(int, st->max_send_size,
>> > +                               le32_to_cpu(req->max_receive_size));
>> > +     st->max_fragmented_send_size =3D
>> > +                     le32_to_cpu(req->max_fragmented_size);
>> > +
>> > +     ret =3D smb_direct_send_negotiate_response(st, ret);
>> > +out:
>> > +     spin_lock_irq(&st->reassembly_queue_lock);
>> > +     st->reassembly_queue_length--;
>> > +     list_del(&recvmsg->list);
>> > +     spin_unlock_irq(&st->reassembly_queue_lock);
>> > +     put_recvmsg(st, recvmsg);
>> > +
>> > +     return ret;
>> > +}
>> > +
>> > +static int smb_direct_connect(struct smb_direct_transport *st)
>> > +{
>> >       int ret;
>> >       struct ib_qp_cap qp_cap;
>> >
>> > @@ -1911,13 +1923,11 @@ static int smb_direct_prepare(struct
>> > ksmbd_transport
>> > *t)
>> >               return ret;
>> >       }
>> >
>> > -     ret =3D smb_direct_negotiate(st);
>> > +     ret =3D smb_direct_prepare_negotiation(st);
>> >       if (ret) {
>> >               pr_err("Can't negotiate: %d\n", ret);
>> >               return ret;
>> >       }
>> > -
>> > -     st->status =3D SMB_DIRECT_CS_CONNECTED;
>> >       return 0;
>> >  }
>> >
>> > @@ -1933,6 +1943,7 @@ static bool rdma_frwr_is_supported(struct
>> > ib_device_attr *attrs)
>> >  static int smb_direct_handle_connect_request(struct rdma_cm_id
>> > *new_cm_id)
>> >  {
>> >       struct smb_direct_transport *t;
>> > +     int ret;
>> >
>> >       if (!rdma_frwr_is_supported(&new_cm_id->device->attrs)) {
>> >               ksmbd_debug(RDMA,
>> > @@ -1945,11 +1956,17 @@ static int
>> > smb_direct_handle_connect_request(struct
>> > rdma_cm_id *new_cm_id)
>> >       if (!t)
>> >               return -ENOMEM;
>> >
>> > +     ret =3D smb_direct_connect(t);
>> > +     if (ret) {
>> > +             free_transport(t);
>> > +             return ret;
>> I think that it is better to use goto statement to out after freeing
>> transport structure.
>
> Okay, I will change it.
OK.
Thanks.
>
>> > +     }
>> > +
>> >       KSMBD_TRANS(t)->handler =3D kthread_run(ksmbd_conn_handler_loop,
>> >                                             KSMBD_TRANS(t)->conn,
>> > "ksmbd:r%u",
>> >                                             smb_direct_port);
>> >       if (IS_ERR(KSMBD_TRANS(t)->handler)) {
>> > -             int ret =3D PTR_ERR(KSMBD_TRANS(t)->handler);
>> > +             ret =3D PTR_ERR(KSMBD_TRANS(t)->handler);
>> >
>> >               pr_err("Can't start thread\n");
>> >               free_transport(t);
>> > --
>> > 2.25.1
>> >
>> >
>
>
>
> --
> Thanks,
> Hyunchul
>
