Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF588CDB465
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Oct 2023 06:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjJSGCS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Oct 2023 02:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbjJSGCE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Oct 2023 02:02:04 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D81C10DE
        for <linux-cifs@vger.kernel.org>; Wed, 18 Oct 2023 23:01:49 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-579de633419so94029587b3.3
        for <linux-cifs@vger.kernel.org>; Wed, 18 Oct 2023 23:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697695308; x=1698300108; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXB9eg1Lez6+G7BKLwabl6u2BEa3suXsudQsmTGAZt8=;
        b=I3OWVUTYgpO0MCa5NGjuTI0As6sobwwGtOjngM+18tujVMbhvLxNgqeHA2LvNuRoku
         FFtIFX8CtLq62CI3mbxTHmZe6vZTmQ/aIrfr7wfMgzPjHCKKE60CBNX9Hh3PHd4OSStO
         McpjYOpN3DVJHsqvbtnr+v6VbHN74aZ7Vf1jhO3YHyy47a92KRS+dFEtvBhxChS6lpxZ
         LQnpr0DjcsJNGOaGl4qpVQkdcTTf+NAKfHoMsQ9pSHudBlghvU1oNS/Gfc8RwWZBw4Ys
         GBcaZ4RvWhkgUJf5XAoz5+5my5hs7lgW2MeZCP5YkXbsAA2NIHIggaeQzh2kScLgkXDI
         mygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697695308; x=1698300108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZXB9eg1Lez6+G7BKLwabl6u2BEa3suXsudQsmTGAZt8=;
        b=OaDnd/1hMxR1oz/16AEX8+CupsPc2hXCdhYCkpnUInxG/GqTRfJqOup5bedJGgwkX9
         32GN+dc1vF5S8Vy/FdlElPEDYG5TNwO27soMKFEzSsdrZAlmKeshwza+UaLV0Z2A+pIb
         Onq1PvPAnkXb3oYdH1UCJqW66HLCv8r6V+BEW3nuWg5mztxjTjw5hsJ+vXN7qpnzCG6s
         tGVzUEm0GNl5vDWg9m4D1osGXDYot0+QOOKOhvybbVCQRXddPTQvJOEOk/wuyB2UZ702
         ltvPuhBWmQmYkHjL8Is4pxNCpkefTlVcXpy98006HKcSu0HxVoTvNOKBbI6kv9jjU/z6
         llQg==
X-Gm-Message-State: AOJu0Yy50jZ6VwrFXnKletJUpkT9PXgS44AmahdS96OqBIPD//xsWsl/
        y3yqkk5maqI//wgQa00+AHoHR4srDnYK991/nw==
X-Google-Smtp-Source: AGHT+IHxFr2D2hRsU7GCKbAxGTPXrnxDaCzoh8yvBSrj75WaNFHFsJkvafgYIDY0EeVh0xCbahUAuSNI0+U5Y4qfoAA=
X-Received: by 2002:a05:690c:ec2:b0:58f:a19f:2b79 with SMTP id
 cs2-20020a05690c0ec200b0058fa19f2b79mr1849489ywb.9.1697695307931; Wed, 18 Oct
 2023 23:01:47 -0700 (PDT)
MIME-Version: 1.0
References: <20231015144536.9100-1-linkinjeon@kernel.org> <11e5bc36-677d-474d-acae-ab7e6ade9b2b@talpey.com>
In-Reply-To: <11e5bc36-677d-474d-acae-ab7e6ade9b2b@talpey.com>
From:   "Kangjing (Chaser) Huang" <huangkangjing@gmail.com>
Date:   Thu, 19 Oct 2023 02:01:31 -0400
Message-ID: <CAPbmFQZoXXdu6StcGrQO1iAzEyFfybt=GgTeqizP-KYQp7LLgQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix missing RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()
To:     Tom Talpey <tom@talpey.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thank you for the review. Also thanks a lot to Namjae for submitting
this patch on my behalf.


On Tue, Oct 17, 2023 at 10:07=E2=80=AFAM Tom Talpey <tom@talpey.com> wrote:
>
> On 10/15/2023 10:45 AM, Namjae Jeon wrote:
> > From: Kangjing Huang <huangkangjing@gmail.com>
> >
> > Physical ib_device does not have an underlying net_device, thus its
> > association with IPoIB net_device cannot be retrieved via
> > ops.get_netdev() or ib_device_get_by_netdev(). ksmbd reads physical
> > ib_device port GUID from the lower 16 bytes of the hardware addresses o=
n
> > IPoIB net_device and match its underlying ib_device using ib_find_gid()
> >
> > Signed-off-by: Kangjing Huang <huangkangjing@gmail.com>
> > Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> > ---
> >   fs/smb/server/transport_rdma.c | 39 +++++++++++++++++++++++++--------=
-
> >   1 file changed, 29 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_r=
dma.c
> > index 3b269e1f523a..a82131f7dd83 100644
> > --- a/fs/smb/server/transport_rdma.c
> > +++ b/fs/smb/server/transport_rdma.c
> > @@ -2140,8 +2140,7 @@ static int smb_direct_ib_client_add(struct ib_dev=
ice *ib_dev)
> >       if (ib_dev->node_type !=3D RDMA_NODE_IB_CA)
> >               smb_direct_port =3D SMB_DIRECT_PORT_IWARP;
> >
> > -     if (!ib_dev->ops.get_netdev ||
> > -         !rdma_frwr_is_supported(&ib_dev->attrs))
> > +     if (!rdma_frwr_is_supported(&ib_dev->attrs))
> >               return 0;
> >
> >       smb_dev =3D kzalloc(sizeof(*smb_dev), GFP_KERNEL);
> > @@ -2241,17 +2240,37 @@ bool ksmbd_rdma_capable_netdev(struct net_devic=
e *netdev)
> >               for (i =3D 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
> >                       struct net_device *ndev;
> >
> > -                     ndev =3D smb_dev->ib_dev->ops.get_netdev(smb_dev-=
>ib_dev,
> > -                                                            i + 1);
> > -                     if (!ndev)
> > -                             continue;
> > +                     /* RoCE and iWRAP ib_dev is backed by a netdev */
> > +                     if (smb_dev->ib_dev->ops.get_netdev) {
>
> The "IWRAP" is a typo, but IMO the comment is misleading. This is simply
> looking up the target netdev, it's not limited to these two rdma types.
> I suggest deleting the comment.
>

I agree with this point and will update this comment in version 2 of the pa=
tch.

> > +                             ndev =3D smb_dev->ib_dev->ops.get_netdev(
> > +                                     smb_dev->ib_dev, i + 1);
> > +                             if (!ndev)
> > +                                     continue;
> >
> > -                     if (ndev =3D=3D netdev) {
> > +                             if (ndev =3D=3D netdev) {
> > +                                     dev_put(ndev);
> > +                                     rdma_capable =3D true;
> > +                                     goto out;
> > +                             }
> >                               dev_put(ndev);
>
> Why not move this dev_put up above the if (ndev =3D=3D netdev) test? It's
> needed in both cases, so it's confusing to have two copies.

I do agree that these two puts are very confusing. However, this code
structure comes from the original ksmbd_rdma_capable_netdev() and
this patch only indents it one more level and puts it in the if test for
get_netdev.

Also, while two puts look very weird, IMO putting it before the if statemen=
t
is equally unintuitive as well since that would be testing the pointer afte=
r its
reference is released. Although since no de-reference is happening here, it
might be fine. Please confirm this is good coding-style-wise and I will inc=
lude
this change in v2 of the patch.

>
> > -                             rdma_capable =3D true;
> > -                             goto out;
> > +                     /* match physical ib_dev with IPoIB netdev by GUI=
D */
>
> Add more information to this comment, perhaps:
>
>    /* if no exact netdev match, check for matching Infiniband GUID */
>

Fair point, will update this comment in v2.

> > +                     } else if (netdev->type =3D=3D ARPHRD_INFINIBAND)=
 {
> > +                             struct netdev_hw_addr *ha;
> > +                             union ib_gid gid;
> > +                             u32 port_num;
> > +                             int ret;
> > +
> > +                             netdev_hw_addr_list_for_each(
> > +                                     ha, &netdev->dev_addrs) {
> > +                                     memcpy(&gid, ha->addr + 4, sizeof=
(gid));
> > +                                     ret =3D ib_find_gid(smb_dev->ib_d=
ev, &gid,
> > +                                                       &port_num, NULL=
);
> > +                                     if (!ret) {
> > +                                             rdma_capable =3D true;
> > +                                             goto out;
>
> Won't this leak the ndev? It needs a dev_put(ndev) before breaking
> the loop, too, right?
>

This will not leak the ndev. Please look closer, this else branch matches w=
ith
the if test on the existence of ops.get_netdev of the current ib_dev. And n=
dev
is acquired only through that op. In the else branch, ndev is just not acqu=
ired.
The original code was indented one more level here so the patch might look
a bit confusing, but one of the if before this block is a deleted(-) line.

> > +                                     }
> > +                             }
> >                       }
> > -                     dev_put(ndev);
> >               }
> >       }
> >   out:



--
Kangjing "Chaser" Huang
