Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FBAC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Dec 2021 23:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhLXXFA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Dec 2021 18:05:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42680 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbhLXXFA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Dec 2021 18:05:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11737620DB
        for <linux-cifs@vger.kernel.org>; Fri, 24 Dec 2021 23:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEA2C36AE5
        for <linux-cifs@vger.kernel.org>; Fri, 24 Dec 2021 23:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640387099;
        bh=1MpqJUWTy7GGSdokv/KV91gWwrNud3/8Wv+Y41aEJwQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=StwG9mNRBryP6IbiK/2z/sD1DHU74rmHq6DyAsoZRBlojsyWOllSGFPZFfQclQ6V0
         cyS3sw6JvVOHHdoYVlpDgbG68R1lPmfQXffmtstmvFpy0Gz6jmeEDZ34KS5ZP1OMZr
         qiKyThWOhgRc7I3V4csTzwlyyzXmYsn+GNbmqIG2Tou/HXvatmzZ9Qa9N8J7F3OGdJ
         3cogY/hdpKX1BJQGOQpwbO3eHYS056+KsRNmPRDSp5DgvYcktsMVkYGfaKX3O19xFd
         mmfUgoRqrWOrs/kEPgb9cUxV0gMTwLOGs+H5UkRFfShyUIdriLjdrBjWGaZYxxOwHk
         TFPCN4zO9mAvA==
Received: by mail-yb1-f179.google.com with SMTP id i3so12084481ybh.11
        for <linux-cifs@vger.kernel.org>; Fri, 24 Dec 2021 15:04:59 -0800 (PST)
X-Gm-Message-State: AOAM532bL7Ag72UCmAt5VGw+pemWfVNaB6bNwrprbZ3FVISCYw77xHtX
        CDl0t6r23NIZ8VcjmNMQ3p9Y5HPZvCwLulMFS9s=
X-Google-Smtp-Source: ABdhPJynVCM04F0ZWPMXJ8pwXNq1IyHN29UqX8N8uRGNHwQgRLtOrRv6XTgDxeuvFOfJheYP47X7excknBzeUHzy2p4=
X-Received: by 2002:a25:9d0a:: with SMTP id i10mr1651832ybp.507.1640387098562;
 Fri, 24 Dec 2021 15:04:58 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:1313:b0:11b:f4cd:b869 with HTTP; Fri, 24 Dec 2021
 15:04:58 -0800 (PST)
In-Reply-To: <CANFS6bamd=2KDK=acaOH5ccexQmG6uL0DSzq3R1tPn=Sb+x2Gg@mail.gmail.com>
References: <20211222224306.198076-1-hyc.lee@gmail.com> <CAKYAXd_jZ8K2PgYkQbvJaAi4ByDn6o302=25ONi5e+6VwoDQHw@mail.gmail.com>
 <CANFS6bamd=2KDK=acaOH5ccexQmG6uL0DSzq3R1tPn=Sb+x2Gg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 25 Dec 2021 08:04:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-+_uWxZQfebvK_o7UQvFieptYww3e1OyAo5bCm0ZkWRg@mail.gmail.com>
Message-ID: <CAKYAXd-+_uWxZQfebvK_o7UQvFieptYww3e1OyAo5bCm0ZkWRg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: set the rdma capability of network adapter using ib_client
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-12-25 7:53 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2021=EB=85=84 12=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 4:27=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> 2021-12-23 7:43 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
>> > Set the rdma capability using ib_clien, Because
>> > For some devices, ib_device_get_by_netdev() returns NULL.
>> >
>> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> > ---
>> >  fs/ksmbd/transport_rdma.c | 89 ++++++++++++++++++++++++++++++++++++--=
-
>> >  1 file changed, 83 insertions(+), 6 deletions(-)
>> >
>> > diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>> > index 7e57cbb0bb35..0820c6a9d75e 100644
>> > --- a/fs/ksmbd/transport_rdma.c
>> > +++ b/fs/ksmbd/transport_rdma.c
>> > @@ -79,6 +79,14 @@ static int smb_direct_max_read_write_size =3D 1024 =
*
>> > 1024;
>> >
>> >  static int smb_direct_max_outstanding_rw_ops =3D 8;
>> >
>> > +static LIST_HEAD(smb_direct_device_list);
>> > +static DEFINE_RWLOCK(smb_direct_device_lock);
>> > +
>> > +struct smb_direct_device {
>> > +     struct ib_device        *ib_dev;
>> > +     struct list_head        list;
>> > +};
>> > +
>> >  static struct smb_direct_listener {
>> >       struct rdma_cm_id       *cm_id;
>> >  } smb_direct_listener;
>> > @@ -2007,12 +2015,62 @@ static int smb_direct_listen(int port)
>> >       return ret;
>> >  }
>> >
>> > +static int smb_direct_ib_client_add(struct ib_device *ib_dev)
>> > +{
>> > +     struct smb_direct_device *smb_dev;
>> > +
>> > +     if (!ib_dev->ops.get_netdev ||
>> > +         ib_dev->node_type !=3D RDMA_NODE_IB_CA ||
>> > +         !rdma_frwr_is_supported(&ib_dev->attrs))
>> > +             return 0;
>> > +
>> > +     smb_dev =3D kzalloc(sizeof(*smb_dev), GFP_KERNEL);
>> > +     if (!smb_dev)
>> > +             return -ENOMEM;
>> > +     smb_dev->ib_dev =3D ib_dev;
>> > +
>> > +     write_lock(&smb_direct_device_lock);
>> > +     list_add(&smb_dev->list, &smb_direct_device_list);
>> > +     write_unlock(&smb_direct_device_lock);
>> > +
>> > +     ksmbd_debug(RDMA, "ib device added: name %s\n", ib_dev->name);
>> > +     return 0;
>> > +}
>> > +
>> > +static void smb_direct_ib_client_remove(struct ib_device *ib_dev,
>> > +                                     void *client_data)
>> > +{
>> When is this function called? Is rdma shutdown needed here?
>>
>
> This is called when a device is unplugged. After this call,
> RDMA_CM_EVENT_DEVICE_REMOVAL event is generated.
> And ksmbd handles this event.
Okay, Have you actually tested it while unplugging NICs?
And This patch doesn't work on Chelsio NICs(iWARP).

>
>> > +     struct smb_direct_device *smb_dev, *tmp;
>> > +
>> > +     write_lock(&smb_direct_device_lock);
>> > +     list_for_each_entry_safe(smb_dev, tmp, &smb_direct_device_list,
>> > list) {
>> > +             if (smb_dev->ib_dev =3D=3D ib_dev) {
>> > +                     list_del(&smb_dev->list);
>> > +                     kfree(smb_dev);
>> > +                     break;
>> > +             }
>> > +     }
>> > +     write_unlock(&smb_direct_device_lock);
>> > +}
>> > +
>> > +static struct ib_client smb_direct_ib_client =3D {
>> > +     .name   =3D "ksmbd_smb_direct_ib",
>> Move smb_direct_ib_client_add and smb_direct_ib_client_remove to here.
>>
>> > +};
>> > +
>> >  int ksmbd_rdma_init(void)
>> >  {
>> >       int ret;
>> >
>> >       smb_direct_listener.cm_id =3D NULL;
>> >
>> > +     smb_direct_ib_client.add =3D smb_direct_ib_client_add;
>> > +     smb_direct_ib_client.remove =3D smb_direct_ib_client_remove;
>> > +     ret =3D ib_register_client(&smb_direct_ib_client);
>> > +     if (ret) {
>> > +             pr_err("failed to ib_register_client\n");
>> > +             return ret;
>> > +     }
>> > +
>> >       /* When a client is running out of send credits, the credits are
>> >        * granted by the server's sending a packet using this queue.
>> >        * This avoids the situation that a clients cannot send packets
>> > @@ -2046,20 +2104,39 @@ int ksmbd_rdma_destroy(void)
>> >               destroy_workqueue(smb_direct_wq);
>> >               smb_direct_wq =3D NULL;
>> >       }
>> > +
>> > +     if (smb_direct_ib_client.add)
>> > +             ib_unregister_client(&smb_direct_ib_client);
>> > +     smb_direct_ib_client.add =3D NULL;
>> Why ?
>>
>
> To avoid multiple calls of ib_unregister_client, because
> ksmbd_rdma_destory() can be called without ksmbd_rdma_init().
> I will clean two functions and remove these statements.
>
>> >       return 0;
>> >  }
>> >
>> >  bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
>> >  {
>> > -     struct ib_device *ibdev;
>> > +     struct smb_direct_device *smb_dev;
>> > +     int i;
>> >       bool rdma_capable =3D false;
>> >
>> > -     ibdev =3D ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
>> > -     if (ibdev) {
>> > -             if (rdma_frwr_is_supported(&ibdev->attrs))
>> > -                     rdma_capable =3D true;
>> > -             ib_device_put(ibdev);
>> > +     read_lock(&smb_direct_device_lock);
>> > +     list_for_each_entry(smb_dev, &smb_direct_device_list, list) {
>> > +             for (i =3D 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
>> > +                     struct net_device *ndev;
>> > +
>> > +                     ndev =3D
>> > smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
>> > +                                                            i + 1);
>> > +                     if (!ndev)
>> > +                             continue;
>> > +
>> > +                     if (ndev =3D=3D netdev) {
>> > +                             dev_put(ndev);
>> > +                             rdma_capable =3D true;
>> > +                             goto out;
>> > +                     }
>> > +                     dev_put(ndev);
>> > +             }
>> >       }
>> > +out:
>> > +     read_unlock(&smb_direct_device_lock);
>> >       return rdma_capable;
>> >  }
>> >
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
