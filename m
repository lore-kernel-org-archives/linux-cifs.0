Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBF6C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Dec 2021 11:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhLYL3Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Dec 2021 06:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhLYL3Q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Dec 2021 06:29:16 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31686C061401
        for <linux-cifs@vger.kernel.org>; Sat, 25 Dec 2021 03:29:16 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id x17so5228933vkx.3
        for <linux-cifs@vger.kernel.org>; Sat, 25 Dec 2021 03:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zI8MVwNhksRTsQ/EH+2Uh9UMrff/JH7Fh4gKpivoeEA=;
        b=F1Jz4Picr/YR2IGxMHvhsbPEgEmNXlI/J4ZMaMA577FDiUSlFs2X/AUAXXLX+yAMAE
         y1RCMyFCwDSz5oI9iFBbj4muhBdwZR/qmgs26EBpkIlFskSlP3Uv1z4JayPHzXvXJwZ3
         74eN1abNwwm+Ptm+RKXHTZwb404vpbf9+cWSM9ZM9hm6xLjDfZNcjgoKtrOxL+IhhBFP
         QoR2hfYodgU876x4XtLsepy8iCb7FBgHAp002wqYJyzW3Oc3kitXmtPHW+yNIu4CaE3Q
         Ddh3vgY76pvjWFpQemYI5wiO6nd+xW+8Qon3za/99rZFYtCNVDS6gVrqgKDUVqShw3sT
         1mPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zI8MVwNhksRTsQ/EH+2Uh9UMrff/JH7Fh4gKpivoeEA=;
        b=jKmOa1nr51jVSvmgE6WxFnqQyRtd5eaaRIWpjAAxqYma/4/rMlBmRRKrCN8vplGWa8
         L4yrgNB8nNFoYK7jaFYbqkhXrAHUN8ILZQEg+iz2ExGgUecEBS007JAYZgYRByOgatwl
         XhMqaImrRU6PEsvD72IvIZXrhvQkvGCsH3ZorKXtlSXzBWmhJm0O4U4/Bxj5S9ZzMmRy
         LoHWLMSMX3/BZ5UQ+HniIjrzevHAPFk6//FdydZEFJzlLGTh2y5N3DOhH0NXNOe+LuUi
         bhor2JHEKniwGMFzImCleSxvJRMGSdN1yk333M/JPvocWyAmXqh1daOyUul63o9Rt7hg
         h0Tw==
X-Gm-Message-State: AOAM531zKRD36NY7zgK8C0TVxAsoAUAy9t2stuu8evKf8iVhYsmP8hz3
        AqErtWL+yFIzmrsgxryy7BFUpRxh4KoVAusv9yc=
X-Google-Smtp-Source: ABdhPJw0KyJDhW1wk8yNxgCqmYhB7ICrgvIk70NbpxJvyp88DE//8wtRJJCGER6EVIc2FHV16cHHL7AuAL/Bw8vC99I=
X-Received: by 2002:a1f:2196:: with SMTP id h144mr3126709vkh.7.1640431755086;
 Sat, 25 Dec 2021 03:29:15 -0800 (PST)
MIME-Version: 1.0
References: <20211222224306.198076-1-hyc.lee@gmail.com> <CAKYAXd_jZ8K2PgYkQbvJaAi4ByDn6o302=25ONi5e+6VwoDQHw@mail.gmail.com>
 <CANFS6bamd=2KDK=acaOH5ccexQmG6uL0DSzq3R1tPn=Sb+x2Gg@mail.gmail.com>
 <CAKYAXd-+_uWxZQfebvK_o7UQvFieptYww3e1OyAo5bCm0ZkWRg@mail.gmail.com>
 <CANFS6bbwNrfx1FMrQ8NYKUuiKc3+tTwp6YtXeaP0woDZ+V-nMQ@mail.gmail.com> <CAKYAXd9E9VrbZSjX_33Tm9xwKkXx+avr0VEiDhTiVxya60dOjQ@mail.gmail.com>
In-Reply-To: <CAKYAXd9E9VrbZSjX_33Tm9xwKkXx+avr0VEiDhTiVxya60dOjQ@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 25 Dec 2021 20:29:03 +0900
Message-ID: <CANFS6bYUo3KeosTtjKvmX7R8jdh-a1SK=G-cOHCGzc36y_UuXw@mail.gmail.com>
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

2021=EB=85=84 12=EC=9B=94 25=EC=9D=BC (=ED=86=A0) =EC=98=A4=ED=9B=84 1:24, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2021-12-25 8:38 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > 2021=EB=85=84 12=EC=9B=94 25=EC=9D=BC (=ED=86=A0) =EC=98=A4=EC=A0=84 8:=
05, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
> >>
> >> 2021-12-25 7:53 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> >> > 2021=EB=85=84 12=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84=
 4:27, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
> >> >>
> >> >> 2021-12-23 7:43 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> >> >> > Set the rdma capability using ib_clien, Because
> >> >> > For some devices, ib_device_get_by_netdev() returns NULL.
> >> >> >
> >> >> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> >> >> > ---
> >> >> >  fs/ksmbd/transport_rdma.c | 89
> >> >> > ++++++++++++++++++++++++++++++++++++---
> >> >> >  1 file changed, 83 insertions(+), 6 deletions(-)
> >> >> >
> >> >> > diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.=
c
> >> >> > index 7e57cbb0bb35..0820c6a9d75e 100644
> >> >> > --- a/fs/ksmbd/transport_rdma.c
> >> >> > +++ b/fs/ksmbd/transport_rdma.c
> >> >> > @@ -79,6 +79,14 @@ static int smb_direct_max_read_write_size =3D =
1024
> >> >> > *
> >> >> > 1024;
> >> >> >
> >> >> >  static int smb_direct_max_outstanding_rw_ops =3D 8;
> >> >> >
> >> >> > +static LIST_HEAD(smb_direct_device_list);
> >> >> > +static DEFINE_RWLOCK(smb_direct_device_lock);
> >> >> > +
> >> >> > +struct smb_direct_device {
> >> >> > +     struct ib_device        *ib_dev;
> >> >> > +     struct list_head        list;
> >> >> > +};
> >> >> > +
> >> >> >  static struct smb_direct_listener {
> >> >> >       struct rdma_cm_id       *cm_id;
> >> >> >  } smb_direct_listener;
> >> >> > @@ -2007,12 +2015,62 @@ static int smb_direct_listen(int port)
> >> >> >       return ret;
> >> >> >  }
> >> >> >
> >> >> > +static int smb_direct_ib_client_add(struct ib_device *ib_dev)
> >> >> > +{
> >> >> > +     struct smb_direct_device *smb_dev;
> >> >> > +
> >> >> > +     if (!ib_dev->ops.get_netdev ||
> >> >> > +         ib_dev->node_type !=3D RDMA_NODE_IB_CA ||
> >> >> > +         !rdma_frwr_is_supported(&ib_dev->attrs))
> >> >> > +             return 0;
> >> >> > +
> >> >> > +     smb_dev =3D kzalloc(sizeof(*smb_dev), GFP_KERNEL);
> >> >> > +     if (!smb_dev)
> >> >> > +             return -ENOMEM;
> >> >> > +     smb_dev->ib_dev =3D ib_dev;
> >> >> > +
> >> >> > +     write_lock(&smb_direct_device_lock);
> >> >> > +     list_add(&smb_dev->list, &smb_direct_device_list);
> >> >> > +     write_unlock(&smb_direct_device_lock);
> >> >> > +
> >> >> > +     ksmbd_debug(RDMA, "ib device added: name %s\n", ib_dev->nam=
e);
> >> >> > +     return 0;
> >> >> > +}
> >> >> > +
> >> >> > +static void smb_direct_ib_client_remove(struct ib_device *ib_dev=
,
> >> >> > +                                     void *client_data)
> >> >> > +{
> >> >> When is this function called? Is rdma shutdown needed here?
> >> >>
> >> >
> >> > This is called when a device is unplugged. After this call,
> >> > RDMA_CM_EVENT_DEVICE_REMOVAL event is generated.
> >> > And ksmbd handles this event.
> >> Okay, Have you actually tested it while unplugging NICs?
> >> And This patch doesn't work on Chelsio NICs(iWARP).
> >>
> >
> > Not yet. I will test it but need some time because of
> > setting up my test environment.
> Don't send untested patch to the list.
> >
> > Is the rdma capability set on Chelsio NICs without
> > this patch?
> Yes.

Okay, After testing device removal and fixing this,
I will send the v2 patch.

> >
> >> >
> >> >> > +     struct smb_direct_device *smb_dev, *tmp;
> >> >> > +
> >> >> > +     write_lock(&smb_direct_device_lock);
> >> >> > +     list_for_each_entry_safe(smb_dev, tmp,
> >> >> > &smb_direct_device_list,
> >> >> > list) {
> >> >> > +             if (smb_dev->ib_dev =3D=3D ib_dev) {
> >> >> > +                     list_del(&smb_dev->list);
> >> >> > +                     kfree(smb_dev);
> >> >> > +                     break;
> >> >> > +             }
> >> >> > +     }
> >> >> > +     write_unlock(&smb_direct_device_lock);
> >> >> > +}
> >> >> > +
> >> >> > +static struct ib_client smb_direct_ib_client =3D {
> >> >> > +     .name   =3D "ksmbd_smb_direct_ib",
> >> >> Move smb_direct_ib_client_add and smb_direct_ib_client_remove to he=
re.
> >> >>
> >> >> > +};
> >> >> > +
> >> >> >  int ksmbd_rdma_init(void)
> >> >> >  {
> >> >> >       int ret;
> >> >> >
> >> >> >       smb_direct_listener.cm_id =3D NULL;
> >> >> >
> >> >> > +     smb_direct_ib_client.add =3D smb_direct_ib_client_add;
> >> >> > +     smb_direct_ib_client.remove =3D smb_direct_ib_client_remove=
;
> >> >> > +     ret =3D ib_register_client(&smb_direct_ib_client);
> >> >> > +     if (ret) {
> >> >> > +             pr_err("failed to ib_register_client\n");
> >> >> > +             return ret;
> >> >> > +     }
> >> >> > +
> >> >> >       /* When a client is running out of send credits, the credit=
s
> >> >> > are
> >> >> >        * granted by the server's sending a packet using this queu=
e.
> >> >> >        * This avoids the situation that a clients cannot send
> >> >> > packets
> >> >> > @@ -2046,20 +2104,39 @@ int ksmbd_rdma_destroy(void)
> >> >> >               destroy_workqueue(smb_direct_wq);
> >> >> >               smb_direct_wq =3D NULL;
> >> >> >       }
> >> >> > +
> >> >> > +     if (smb_direct_ib_client.add)
> >> >> > +             ib_unregister_client(&smb_direct_ib_client);
> >> >> > +     smb_direct_ib_client.add =3D NULL;
> >> >> Why ?
> >> >>
> >> >
> >> > To avoid multiple calls of ib_unregister_client, because
> >> > ksmbd_rdma_destory() can be called without ksmbd_rdma_init().
> >> > I will clean two functions and remove these statements.
> >> >
> >> >> >       return 0;
> >> >> >  }
> >> >> >
> >> >> >  bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
> >> >> >  {
> >> >> > -     struct ib_device *ibdev;
> >> >> > +     struct smb_direct_device *smb_dev;
> >> >> > +     int i;
> >> >> >       bool rdma_capable =3D false;
> >> >> >
> >> >> > -     ibdev =3D ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNO=
WN);
> >> >> > -     if (ibdev) {
> >> >> > -             if (rdma_frwr_is_supported(&ibdev->attrs))
> >> >> > -                     rdma_capable =3D true;
> >> >> > -             ib_device_put(ibdev);
> >> >> > +     read_lock(&smb_direct_device_lock);
> >> >> > +     list_for_each_entry(smb_dev, &smb_direct_device_list, list)=
 {
> >> >> > +             for (i =3D 0; i < smb_dev->ib_dev->phys_port_cnt; i=
++) {
> >> >> > +                     struct net_device *ndev;
> >> >> > +
> >> >> > +                     ndev =3D
> >> >> > smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
> >> >> > +                                                            i + =
1);
> >> >> > +                     if (!ndev)
> >> >> > +                             continue;
> >> >> > +
> >> >> > +                     if (ndev =3D=3D netdev) {
> >> >> > +                             dev_put(ndev);
> >> >> > +                             rdma_capable =3D true;
> >> >> > +                             goto out;
> >> >> > +                     }
> >> >> > +                     dev_put(ndev);
> >> >> > +             }
> >> >> >       }
> >> >> > +out:
> >> >> > +     read_unlock(&smb_direct_device_lock);
> >> >> >       return rdma_capable;
> >> >> >  }
> >> >> >
> >> >> > --
> >> >> > 2.25.1
> >> >> >
> >> >> >
> >> >
> >> >
> >> >
> >> > --
> >> > Thanks,
> >> > Hyunchul
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
