Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD57C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Dec 2021 23:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhLXXim (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Dec 2021 18:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhLXXim (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Dec 2021 18:38:42 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5501C061757
        for <linux-cifs@vger.kernel.org>; Fri, 24 Dec 2021 15:38:41 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id p37so17080628uae.8
        for <linux-cifs@vger.kernel.org>; Fri, 24 Dec 2021 15:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W6ZMFUllmKsrbuGIUA6KDCL0BL6LS6sUwACcAhfX1lY=;
        b=TxCycQDifeKJoAT0JhbWpY3m6fk9KqhVjngmFsBLF//VD4Lq0RW9Fnk01Zp8QcijuE
         NBmtnjD+UAwHQ7ukk38Gsp0YwdgRixMJHQf+njD/diL+7PWeP2tJROckd9h9sbCQOW7e
         VcJ9hLsmuwTbhWDkB4XgzhcLWASGzMQxmWR3BKUPePeg3qAQaE+4YjWbgPjrNe8/uDdc
         tnvH6lEWjkT2ynpQx3kTAXJ5ewq8h/J5xE0rlxlB1Sn7u0nV6syUBcGtmAYzO4rgazdi
         TFbYgYf93V+iL8JqwVQoutEz7t434Z41mnA/ZeF/Gq9ddHoVxeMbqbiefNRgoRdy1jGw
         p+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W6ZMFUllmKsrbuGIUA6KDCL0BL6LS6sUwACcAhfX1lY=;
        b=sUWJB9Ffcb/NwlQdVOD4p1XUPi1LNjuIhw7pUbIk3u8qo4ANtgrPwUZG4z/sv/ENDt
         cFH+fb7dZiA+ByrzAo48DZHADNIHblIM7gIi1ufZGWGVv4Hm8/bPBfmSMQEH8YDMVQXi
         vK88mF8LNOBNxsFW1kLjrrepUSRivV4yZCgMZkm5NWl8D6NjOP3GrtsTgu4f8sahKj2q
         gLwc6RKbDLEywRXNti+sERkKSrdenAWcN0reggWwKYCPAa2LND1QsaLHDsV3OF0sSayO
         U6SQNyJAP+ul8c6fgxCtF44bPr6HpTAhV+6wcxa1C1dXR/BjPsZULJLxmKjqgibidMkB
         wRwA==
X-Gm-Message-State: AOAM533JjygIFt2oOFdfwu8kZ53hH4eQ4Nc2jEHGjj9vFU3BrpE/SFYP
        3EcNMT6gBfQQDVhnKy+4wCLqiB5tdCcyC0xlK1E=
X-Google-Smtp-Source: ABdhPJwCWib1W5V4Je5I75KWiNhZAihIcj86X/X3de0z+C3VH9WRoG27uCpMmCscrU25VC9IQOrJHsomDGotHSE8mtI=
X-Received: by 2002:a05:6102:3306:: with SMTP id v6mr2497395vsc.56.1640389120840;
 Fri, 24 Dec 2021 15:38:40 -0800 (PST)
MIME-Version: 1.0
References: <20211222224306.198076-1-hyc.lee@gmail.com> <CAKYAXd_jZ8K2PgYkQbvJaAi4ByDn6o302=25ONi5e+6VwoDQHw@mail.gmail.com>
 <CANFS6bamd=2KDK=acaOH5ccexQmG6uL0DSzq3R1tPn=Sb+x2Gg@mail.gmail.com> <CAKYAXd-+_uWxZQfebvK_o7UQvFieptYww3e1OyAo5bCm0ZkWRg@mail.gmail.com>
In-Reply-To: <CAKYAXd-+_uWxZQfebvK_o7UQvFieptYww3e1OyAo5bCm0ZkWRg@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 25 Dec 2021 08:38:29 +0900
Message-ID: <CANFS6bbwNrfx1FMrQ8NYKUuiKc3+tTwp6YtXeaP0woDZ+V-nMQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: set the rdma capability of network adapter using ib_client
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 12=EC=9B=94 25=EC=9D=BC (=ED=86=A0) =EC=98=A4=EC=A0=84 8:05, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2021-12-25 7:53 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > 2021=EB=85=84 12=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 4:=
27, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
> >>
> >> 2021-12-23 7:43 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> >> > Set the rdma capability using ib_clien, Because
> >> > For some devices, ib_device_get_by_netdev() returns NULL.
> >> >
> >> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> >> > ---
> >> >  fs/ksmbd/transport_rdma.c | 89 ++++++++++++++++++++++++++++++++++++=
---
> >> >  1 file changed, 83 insertions(+), 6 deletions(-)
> >> >
> >> > diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> >> > index 7e57cbb0bb35..0820c6a9d75e 100644
> >> > --- a/fs/ksmbd/transport_rdma.c
> >> > +++ b/fs/ksmbd/transport_rdma.c
> >> > @@ -79,6 +79,14 @@ static int smb_direct_max_read_write_size =3D 102=
4 *
> >> > 1024;
> >> >
> >> >  static int smb_direct_max_outstanding_rw_ops =3D 8;
> >> >
> >> > +static LIST_HEAD(smb_direct_device_list);
> >> > +static DEFINE_RWLOCK(smb_direct_device_lock);
> >> > +
> >> > +struct smb_direct_device {
> >> > +     struct ib_device        *ib_dev;
> >> > +     struct list_head        list;
> >> > +};
> >> > +
> >> >  static struct smb_direct_listener {
> >> >       struct rdma_cm_id       *cm_id;
> >> >  } smb_direct_listener;
> >> > @@ -2007,12 +2015,62 @@ static int smb_direct_listen(int port)
> >> >       return ret;
> >> >  }
> >> >
> >> > +static int smb_direct_ib_client_add(struct ib_device *ib_dev)
> >> > +{
> >> > +     struct smb_direct_device *smb_dev;
> >> > +
> >> > +     if (!ib_dev->ops.get_netdev ||
> >> > +         ib_dev->node_type !=3D RDMA_NODE_IB_CA ||
> >> > +         !rdma_frwr_is_supported(&ib_dev->attrs))
> >> > +             return 0;
> >> > +
> >> > +     smb_dev =3D kzalloc(sizeof(*smb_dev), GFP_KERNEL);
> >> > +     if (!smb_dev)
> >> > +             return -ENOMEM;
> >> > +     smb_dev->ib_dev =3D ib_dev;
> >> > +
> >> > +     write_lock(&smb_direct_device_lock);
> >> > +     list_add(&smb_dev->list, &smb_direct_device_list);
> >> > +     write_unlock(&smb_direct_device_lock);
> >> > +
> >> > +     ksmbd_debug(RDMA, "ib device added: name %s\n", ib_dev->name);
> >> > +     return 0;
> >> > +}
> >> > +
> >> > +static void smb_direct_ib_client_remove(struct ib_device *ib_dev,
> >> > +                                     void *client_data)
> >> > +{
> >> When is this function called? Is rdma shutdown needed here?
> >>
> >
> > This is called when a device is unplugged. After this call,
> > RDMA_CM_EVENT_DEVICE_REMOVAL event is generated.
> > And ksmbd handles this event.
> Okay, Have you actually tested it while unplugging NICs?
> And This patch doesn't work on Chelsio NICs(iWARP).
>

Not yet. I will test it but need some time because of
setting up my test environment.

Is the rdma capability set on Chelsio NICs without
this patch?

> >
> >> > +     struct smb_direct_device *smb_dev, *tmp;
> >> > +
> >> > +     write_lock(&smb_direct_device_lock);
> >> > +     list_for_each_entry_safe(smb_dev, tmp, &smb_direct_device_list=
,
> >> > list) {
> >> > +             if (smb_dev->ib_dev =3D=3D ib_dev) {
> >> > +                     list_del(&smb_dev->list);
> >> > +                     kfree(smb_dev);
> >> > +                     break;
> >> > +             }
> >> > +     }
> >> > +     write_unlock(&smb_direct_device_lock);
> >> > +}
> >> > +
> >> > +static struct ib_client smb_direct_ib_client =3D {
> >> > +     .name   =3D "ksmbd_smb_direct_ib",
> >> Move smb_direct_ib_client_add and smb_direct_ib_client_remove to here.
> >>
> >> > +};
> >> > +
> >> >  int ksmbd_rdma_init(void)
> >> >  {
> >> >       int ret;
> >> >
> >> >       smb_direct_listener.cm_id =3D NULL;
> >> >
> >> > +     smb_direct_ib_client.add =3D smb_direct_ib_client_add;
> >> > +     smb_direct_ib_client.remove =3D smb_direct_ib_client_remove;
> >> > +     ret =3D ib_register_client(&smb_direct_ib_client);
> >> > +     if (ret) {
> >> > +             pr_err("failed to ib_register_client\n");
> >> > +             return ret;
> >> > +     }
> >> > +
> >> >       /* When a client is running out of send credits, the credits a=
re
> >> >        * granted by the server's sending a packet using this queue.
> >> >        * This avoids the situation that a clients cannot send packet=
s
> >> > @@ -2046,20 +2104,39 @@ int ksmbd_rdma_destroy(void)
> >> >               destroy_workqueue(smb_direct_wq);
> >> >               smb_direct_wq =3D NULL;
> >> >       }
> >> > +
> >> > +     if (smb_direct_ib_client.add)
> >> > +             ib_unregister_client(&smb_direct_ib_client);
> >> > +     smb_direct_ib_client.add =3D NULL;
> >> Why ?
> >>
> >
> > To avoid multiple calls of ib_unregister_client, because
> > ksmbd_rdma_destory() can be called without ksmbd_rdma_init().
> > I will clean two functions and remove these statements.
> >
> >> >       return 0;
> >> >  }
> >> >
> >> >  bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
> >> >  {
> >> > -     struct ib_device *ibdev;
> >> > +     struct smb_direct_device *smb_dev;
> >> > +     int i;
> >> >       bool rdma_capable =3D false;
> >> >
> >> > -     ibdev =3D ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN)=
;
> >> > -     if (ibdev) {
> >> > -             if (rdma_frwr_is_supported(&ibdev->attrs))
> >> > -                     rdma_capable =3D true;
> >> > -             ib_device_put(ibdev);
> >> > +     read_lock(&smb_direct_device_lock);
> >> > +     list_for_each_entry(smb_dev, &smb_direct_device_list, list) {
> >> > +             for (i =3D 0; i < smb_dev->ib_dev->phys_port_cnt; i++)=
 {
> >> > +                     struct net_device *ndev;
> >> > +
> >> > +                     ndev =3D
> >> > smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
> >> > +                                                            i + 1);
> >> > +                     if (!ndev)
> >> > +                             continue;
> >> > +
> >> > +                     if (ndev =3D=3D netdev) {
> >> > +                             dev_put(ndev);
> >> > +                             rdma_capable =3D true;
> >> > +                             goto out;
> >> > +                     }
> >> > +                     dev_put(ndev);
> >> > +             }
> >> >       }
> >> > +out:
> >> > +     read_unlock(&smb_direct_device_lock);
> >> >       return rdma_capable;
> >> >  }
> >> >
> >> > --
> >> > 2.25.1
> >> >
> >> >
> >
> >
> >
> > --
> > Thanks,
> > Hyunchul
> >



--=20
Thanks,
Hyunchul
