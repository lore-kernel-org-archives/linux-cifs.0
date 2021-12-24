Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D38C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Dec 2021 22:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhLXWxm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Dec 2021 17:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhLXWxl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Dec 2021 17:53:41 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D587C061401
        for <linux-cifs@vger.kernel.org>; Fri, 24 Dec 2021 14:53:41 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id s144so5491532vkb.8
        for <linux-cifs@vger.kernel.org>; Fri, 24 Dec 2021 14:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VD8EgmqUHoibrVppwERd5wdLMSD657ww1vcFYrPwxvo=;
        b=G/mha1hvfinqS/c7I61FElStZW+DLEUEGPnRD79RK7zYFKdNBKb16lFyokav11JXsb
         iIp6+xFzjfOdvECocBt+immmC/604XFLdWxgYGGyLa9z68phye06uCTH5vhow9+7Q9Oe
         zH1to7MkjK64A+CW4D5ZVrktT+tGmBYdo2P8GfJ2O6IQQbqQSVySmlAa7jUWrV1RD+bt
         dMo2ouZGJk50XRC+nOl3I6c5A5a2crVcMWkrmvrwdslnpQ/5XUi1OPHpX2Cnrv1xzKNZ
         YHcCiVbO3npXymoXGzvWRT95jKPFrv5zotpsZAIBryLQZyGY5v5RTfKSsGQO3WfNzjiN
         4FoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VD8EgmqUHoibrVppwERd5wdLMSD657ww1vcFYrPwxvo=;
        b=KLpTJwsHviS0sXF79GJwJJ1109j4HZ5JjMuX4cE+Ggo8N7VaMgIQPDvlUKcx3aM1LK
         B5L2+oomS35NVaqDjAIDVasl4pBeWu9S0S6LBXu7OoiK1sPeIQldPaEdXe/DE5SMdsvp
         6aE/Lw4+ld/fL3EEvzoo7NU7WIzFtCpVflHiPvdmzGgsbZF8XweCA7nn1JvAIZ80sLV3
         w6XMbtyxUqBo9WRK7EsMQkUNswiw3npaQ0S7LfHNtAOKn7xIpk5luOy7H1I/lIy+qwYF
         uzgvpMN/U5mwUNaaqvo/K03+L9V0BWH/mhpEDkvwj2iFMzZo3y+vpJ0S2orQfsmjh3ek
         0QKA==
X-Gm-Message-State: AOAM530GTGH17/4EFkwM8K44SvvwRcLC6hVIgtwGgHqjWMRZI8aCsEcY
        vZD5s7cpod1/TszXT/StZwwy2nbMsqjTpmVZcUk=
X-Google-Smtp-Source: ABdhPJx8hM9MfHBUQMhoO6k/3UIN8vq+5av/inYPdwjxeeO4Jh8vHBvQmZxkIXwZdk2UIfHmI/2ywUU2jFlgh/8CJEU=
X-Received: by 2002:a1f:2749:: with SMTP id n70mr2683424vkn.37.1640386419830;
 Fri, 24 Dec 2021 14:53:39 -0800 (PST)
MIME-Version: 1.0
References: <20211222224306.198076-1-hyc.lee@gmail.com> <CAKYAXd_jZ8K2PgYkQbvJaAi4ByDn6o302=25ONi5e+6VwoDQHw@mail.gmail.com>
In-Reply-To: <CAKYAXd_jZ8K2PgYkQbvJaAi4ByDn6o302=25ONi5e+6VwoDQHw@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 25 Dec 2021 07:53:28 +0900
Message-ID: <CANFS6bamd=2KDK=acaOH5ccexQmG6uL0DSzq3R1tPn=Sb+x2Gg@mail.gmail.com>
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

2021=EB=85=84 12=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 4:27, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2021-12-23 7:43 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > Set the rdma capability using ib_clien, Because
> > For some devices, ib_device_get_by_netdev() returns NULL.
> >
> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> > ---
> >  fs/ksmbd/transport_rdma.c | 89 ++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 83 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> > index 7e57cbb0bb35..0820c6a9d75e 100644
> > --- a/fs/ksmbd/transport_rdma.c
> > +++ b/fs/ksmbd/transport_rdma.c
> > @@ -79,6 +79,14 @@ static int smb_direct_max_read_write_size =3D 1024 *=
 1024;
> >
> >  static int smb_direct_max_outstanding_rw_ops =3D 8;
> >
> > +static LIST_HEAD(smb_direct_device_list);
> > +static DEFINE_RWLOCK(smb_direct_device_lock);
> > +
> > +struct smb_direct_device {
> > +     struct ib_device        *ib_dev;
> > +     struct list_head        list;
> > +};
> > +
> >  static struct smb_direct_listener {
> >       struct rdma_cm_id       *cm_id;
> >  } smb_direct_listener;
> > @@ -2007,12 +2015,62 @@ static int smb_direct_listen(int port)
> >       return ret;
> >  }
> >
> > +static int smb_direct_ib_client_add(struct ib_device *ib_dev)
> > +{
> > +     struct smb_direct_device *smb_dev;
> > +
> > +     if (!ib_dev->ops.get_netdev ||
> > +         ib_dev->node_type !=3D RDMA_NODE_IB_CA ||
> > +         !rdma_frwr_is_supported(&ib_dev->attrs))
> > +             return 0;
> > +
> > +     smb_dev =3D kzalloc(sizeof(*smb_dev), GFP_KERNEL);
> > +     if (!smb_dev)
> > +             return -ENOMEM;
> > +     smb_dev->ib_dev =3D ib_dev;
> > +
> > +     write_lock(&smb_direct_device_lock);
> > +     list_add(&smb_dev->list, &smb_direct_device_list);
> > +     write_unlock(&smb_direct_device_lock);
> > +
> > +     ksmbd_debug(RDMA, "ib device added: name %s\n", ib_dev->name);
> > +     return 0;
> > +}
> > +
> > +static void smb_direct_ib_client_remove(struct ib_device *ib_dev,
> > +                                     void *client_data)
> > +{
> When is this function called? Is rdma shutdown needed here?
>

This is called when a device is unplugged. After this call,
RDMA_CM_EVENT_DEVICE_REMOVAL event is generated.
And ksmbd handles this event.

> > +     struct smb_direct_device *smb_dev, *tmp;
> > +
> > +     write_lock(&smb_direct_device_lock);
> > +     list_for_each_entry_safe(smb_dev, tmp, &smb_direct_device_list, l=
ist) {
> > +             if (smb_dev->ib_dev =3D=3D ib_dev) {
> > +                     list_del(&smb_dev->list);
> > +                     kfree(smb_dev);
> > +                     break;
> > +             }
> > +     }
> > +     write_unlock(&smb_direct_device_lock);
> > +}
> > +
> > +static struct ib_client smb_direct_ib_client =3D {
> > +     .name   =3D "ksmbd_smb_direct_ib",
> Move smb_direct_ib_client_add and smb_direct_ib_client_remove to here.
>
> > +};
> > +
> >  int ksmbd_rdma_init(void)
> >  {
> >       int ret;
> >
> >       smb_direct_listener.cm_id =3D NULL;
> >
> > +     smb_direct_ib_client.add =3D smb_direct_ib_client_add;
> > +     smb_direct_ib_client.remove =3D smb_direct_ib_client_remove;
> > +     ret =3D ib_register_client(&smb_direct_ib_client);
> > +     if (ret) {
> > +             pr_err("failed to ib_register_client\n");
> > +             return ret;
> > +     }
> > +
> >       /* When a client is running out of send credits, the credits are
> >        * granted by the server's sending a packet using this queue.
> >        * This avoids the situation that a clients cannot send packets
> > @@ -2046,20 +2104,39 @@ int ksmbd_rdma_destroy(void)
> >               destroy_workqueue(smb_direct_wq);
> >               smb_direct_wq =3D NULL;
> >       }
> > +
> > +     if (smb_direct_ib_client.add)
> > +             ib_unregister_client(&smb_direct_ib_client);
> > +     smb_direct_ib_client.add =3D NULL;
> Why ?
>

To avoid multiple calls of ib_unregister_client, because
ksmbd_rdma_destory() can be called without ksmbd_rdma_init().
I will clean two functions and remove these statements.

> >       return 0;
> >  }
> >
> >  bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
> >  {
> > -     struct ib_device *ibdev;
> > +     struct smb_direct_device *smb_dev;
> > +     int i;
> >       bool rdma_capable =3D false;
> >
> > -     ibdev =3D ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
> > -     if (ibdev) {
> > -             if (rdma_frwr_is_supported(&ibdev->attrs))
> > -                     rdma_capable =3D true;
> > -             ib_device_put(ibdev);
> > +     read_lock(&smb_direct_device_lock);
> > +     list_for_each_entry(smb_dev, &smb_direct_device_list, list) {
> > +             for (i =3D 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
> > +                     struct net_device *ndev;
> > +
> > +                     ndev =3D smb_dev->ib_dev->ops.get_netdev(smb_dev-=
>ib_dev,
> > +                                                            i + 1);
> > +                     if (!ndev)
> > +                             continue;
> > +
> > +                     if (ndev =3D=3D netdev) {
> > +                             dev_put(ndev);
> > +                             rdma_capable =3D true;
> > +                             goto out;
> > +                     }
> > +                     dev_put(ndev);
> > +             }
> >       }
> > +out:
> > +     read_unlock(&smb_direct_device_lock);
> >       return rdma_capable;
> >  }
> >
> > --
> > 2.25.1
> >
> >



--=20
Thanks,
Hyunchul
