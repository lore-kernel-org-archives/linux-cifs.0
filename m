Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8CECDB474
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Oct 2023 11:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377159AbjJTLkY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Oct 2023 07:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377036AbjJTLkI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Oct 2023 07:40:08 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FBC1707
        for <linux-cifs@vger.kernel.org>; Fri, 20 Oct 2023 04:38:31 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-5a7eef0b931so7862627b3.0
        for <linux-cifs@vger.kernel.org>; Fri, 20 Oct 2023 04:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697801910; x=1698406710; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdsKnQG/AQdgGIZUhV8N6c8uBYIeOTgKasHkGmjk/5k=;
        b=LVeeVQ20acdtE06UrzBPQ1nahAGn0rbVbKuX3ehY3ngYQFXt2f06PPTbVLYVdHnvdd
         RbBKboOfyQpaj4GHJdtljdAAsDwo+ddq9lJDZ00HWS0P7coG/P9zVx1hBMPBeeA2Ph26
         kWz2YRq1e7M47Tsq0IaXazZZpgd+xsTO/CbdylDZqpsiu7pmzkIXLXNjdzfE7k5pMnze
         snH60OTtZR0Yjfb/q6dW1pvLTqnOxYnsfCh6aF3jHzu38Q/dYNWMPDuJVeZ7hdK1zL6p
         1IC7XQGylB1VjqEcXuCWWFr7p/dI872kHCsrRU/YzjuQJN1GPw0d+tPrS4EfqUhFy9EN
         upZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697801910; x=1698406710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fdsKnQG/AQdgGIZUhV8N6c8uBYIeOTgKasHkGmjk/5k=;
        b=mDVQ7TaXWpbqbnM40RAwmVDUd0XsyYZjsAM3WbzrB6w1uIQcYVA/P4dbbkffBzgRQk
         /fYBVXCD8WlrZKtXcrGa8JRNBL0Il7SPOfsRQcGk4CifsR7fAfU+z7eJtmvzRSf3GXIc
         4oVQfbPFj+kglBuOkptMDWRKQYasQGSWi8q5BYKEjIMXgCTxf1drbzwa21PWVQcmiTn6
         aq2afsyTETnnqE6UYiktppy4syS5tAV/CMYJRrns+M3B98bF75a4BPaHAPki1zZ1KQ+c
         MT3Wmfg87AQp7a6GgURSQwaOIDElBmd+3pNXLgc/MhAlUGG+FS4g1G2VgGF8lv9/EeTo
         pq5w==
X-Gm-Message-State: AOJu0Yyg4uNpH7lW7v6A5qzth0LSRnZ0t7JaH+1gF4fnjTJ7FHCl2kar
        1fiK8R2zeTjvpxwZNkI3iGwYXSiU8DwEkMPCoQnrtjtXXA==
X-Google-Smtp-Source: AGHT+IGrh2WAbC+yXYlANMH9mMuUrHVfemn1an3auA4uVN7UpznjB24Ebl+aV81cwoQq9HwnyJIZFpFX48G4WJCFFyg=
X-Received: by 2002:a81:920f:0:b0:5a7:b782:6dd9 with SMTP id
 j15-20020a81920f000000b005a7b7826dd9mr1592900ywg.26.1697801910086; Fri, 20
 Oct 2023 04:38:30 -0700 (PDT)
MIME-Version: 1.0
References: <20231015144536.9100-1-linkinjeon@kernel.org> <11e5bc36-677d-474d-acae-ab7e6ade9b2b@talpey.com>
 <CAPbmFQZoXXdu6StcGrQO1iAzEyFfybt=GgTeqizP-KYQp7LLgQ@mail.gmail.com>
 <CAKYAXd-baiZEY=5Z4vaX=OQiSBKfKXsn+_tJOJo1mZ3uniRSzQ@mail.gmail.com> <e54f1a07-bc68-474f-83c1-a046d2b61b12@talpey.com>
In-Reply-To: <e54f1a07-bc68-474f-83c1-a046d2b61b12@talpey.com>
From:   "Kangjing (Chaser) Huang" <huangkangjing@gmail.com>
Date:   Fri, 20 Oct 2023 07:38:14 -0400
Message-ID: <CAPbmFQaA5_zz4dSLOj9tP9seW45PXMAA=BuHdNp5xGeuStMC7g@mail.gmail.com>
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

On Thu, Oct 19, 2023 at 9:14=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 10/19/2023 6:37 PM, Namjae Jeon wrote:
> > 2023-10-19 15:01 GMT+09:00, Kangjing (Chaser) Huang <huangkangjing@gmai=
l.com>:
> >> Thank you for the review. Also thanks a lot to Namjae for submitting
> >> this patch on my behalf.
> >>
> >>
> >> On Tue, Oct 17, 2023 at 10:07=E2=80=AFAM Tom Talpey <tom@talpey.com> w=
rote:
> >>>
> >>> On 10/15/2023 10:45 AM, Namjae Jeon wrote:
> >>>> From: Kangjing Huang <huangkangjing@gmail.com>
> >>>>
> >>>> Physical ib_device does not have an underlying net_device, thus its
> >>>> association with IPoIB net_device cannot be retrieved via
> >>>> ops.get_netdev() or ib_device_get_by_netdev(). ksmbd reads physical
> >>>> ib_device port GUID from the lower 16 bytes of the hardware addresse=
s
> >>>> on
> >>>> IPoIB net_device and match its underlying ib_device using ib_find_gi=
d()
> >>>>
> >>>> Signed-off-by: Kangjing Huang <huangkangjing@gmail.com>
> >>>> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> >>>> ---
> >>>>    fs/smb/server/transport_rdma.c | 39
> >>>> +++++++++++++++++++++++++---------
> >>>>    1 file changed, 29 insertions(+), 10 deletions(-)
> >>>>
> >>>> diff --git a/fs/smb/server/transport_rdma.c
> >>>> b/fs/smb/server/transport_rdma.c
> >>>> index 3b269e1f523a..a82131f7dd83 100644
> >>>> --- a/fs/smb/server/transport_rdma.c
> >>>> +++ b/fs/smb/server/transport_rdma.c
> >>>> @@ -2140,8 +2140,7 @@ static int smb_direct_ib_client_add(struct
> >>>> ib_device *ib_dev)
> >>>>        if (ib_dev->node_type !=3D RDMA_NODE_IB_CA)
> >>>>                smb_direct_port =3D SMB_DIRECT_PORT_IWARP;
> >>>>
> >>>> -     if (!ib_dev->ops.get_netdev ||
> >>>> -         !rdma_frwr_is_supported(&ib_dev->attrs))
> >>>> +     if (!rdma_frwr_is_supported(&ib_dev->attrs))
> >>>>                return 0;
> >>>>
> >>>>        smb_dev =3D kzalloc(sizeof(*smb_dev), GFP_KERNEL);
> >>>> @@ -2241,17 +2240,37 @@ bool ksmbd_rdma_capable_netdev(struct net_de=
vice
> >>>> *netdev)
> >>>>                for (i =3D 0; i < smb_dev->ib_dev->phys_port_cnt; i++=
) {
> >>>>                        struct net_device *ndev;
> >>>>
> >>>> -                     ndev =3D
> >>>> smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
> >>>> -                                                            i + 1);
> >>>> -                     if (!ndev)
> >>>> -                             continue;
> >>>> +                     /* RoCE and iWRAP ib_dev is backed by a netdev=
 */
> >>>> +                     if (smb_dev->ib_dev->ops.get_netdev) {
> >>>
> >>> The "IWRAP" is a typo, but IMO the comment is misleading. This is sim=
ply
> >>> looking up the target netdev, it's not limited to these two rdma type=
s.
> >>> I suggest deleting the comment.
> >>>
> >>
> >> I agree with this point and will update this comment in version 2 of t=
he
> >> patch.
> >>
> >>>> +                             ndev =3D smb_dev->ib_dev->ops.get_netd=
ev(
> >>>> +                                     smb_dev->ib_dev, i + 1);
> >>>> +                             if (!ndev)
> >>>> +                                     continue;
> >>>>
> >>>> -                     if (ndev =3D=3D netdev) {
> >>>> +                             if (ndev =3D=3D netdev) {
> >>>> +                                     dev_put(ndev);
> >>>> +                                     rdma_capable =3D true;
> >>>> +                                     goto out;
> >>>> +                             }
> >>>>                                dev_put(ndev);
> >>>
> >>> Why not move this dev_put up above the if (ndev =3D=3D netdev) test? =
It's
> >>> needed in both cases, so it's confusing to have two copies.
> >>
> >> I do agree that these two puts are very confusing. However, this code
> >> structure comes from the original ksmbd_rdma_capable_netdev() and
> >> this patch only indents it one more level and puts it in the if test f=
or
> >> get_netdev.
> >>
> >> Also, while two puts look very weird, IMO putting it before the if
> >> statement
> >> is equally unintuitive as well since that would be testing the pointer=
 after
> >> its
> >> reference is released. Although since no de-reference is happening her=
e, it
> >> might be fine. Please confirm this is good coding-style-wise and I wil=
l
> >> include
> >> this change in v2 of the patch.
> > There is no need to update code that does not have problems.
>

> Well, there are now at least half a dozen stanzas of
>         dev_put
>         rdma_capable =3D <T|f>
>         goto out
>
> and I don't see why these can't be simplified to
>
>         goto out_capable|out_notcapable
>
> It woud be a lot clearer, at least to this reviewer. And more reliable
> to maintain.
>

I agree, but this consolidation would be impossible without a
major overhaul of the code structure in
ksmbd_rdma_capable_netdev(). There are several clean-up
calls that need to be made (read_unlock(&smb_direct_device_lock),
dev_put, ib_device_put) and the biggest problem is brought in
by the block of code that is doing a reverse lookup on ib_dev
structs right after the patched loop.

I don't know why it is necessary for such a reverse lookup, but given
that these code depends on the behaviors of ib device drivers, which
can be very erratic. I feel that removing that block could break
something with some other devices.

In conclusion, I feel addressing these issues in this function is
beyond the scope of this patch and they should be addressed
separately. I will move forward with the comment change in v2.



> >>
> >>>
> >>>> -                             rdma_capable =3D true;
> >>>> -                             goto out;
> >>>> +                     /* match physical ib_dev with IPoIB netdev by =
GUID
> >>>> */
> >>>
> >>> Add more information to this comment, perhaps:
> >>>
> >>>     /* if no exact netdev match, check for matching Infiniband GUID *=
/
> >>>
> >>
> >> Fair point, will update this comment in v2.
> >>
> >>>> +                     } else if (netdev->type =3D=3D ARPHRD_INFINIBA=
ND) {
> >>>> +                             struct netdev_hw_addr *ha;
> >>>> +                             union ib_gid gid;
> >>>> +                             u32 port_num;
> >>>> +                             int ret;
> >>>> +
> >>>> +                             netdev_hw_addr_list_for_each(
> >>>> +                                     ha, &netdev->dev_addrs) {
> >>>> +                                     memcpy(&gid, ha->addr + 4,
> >>>> sizeof(gid));
> >>>> +                                     ret =3D ib_find_gid(smb_dev->i=
b_dev,
> >>>> &gid,
> >>>> +                                                       &port_num,
> >>>> NULL);
> >>>> +                                     if (!ret) {
> >>>> +                                             rdma_capable =3D true;
> >>>> +                                             goto out;
> >>>
> >>> Won't this leak the ndev? It needs a dev_put(ndev) before breaking
> >>> the loop, too, right?
> >>>
> >>
> >> This will not leak the ndev. Please look closer, this else branch matc=
hes
> >> with
> >> the if test on the existence of ops.get_netdev of the current ib_dev. =
And
> >> ndev
> >> is acquired only through that op. In the else branch, ndev is just not
> >> acquired.
> >> The original code was indented one more level here so the patch might =
look
> >> a bit confusing, but one of the if before this block is a deleted(-) l=
ine.
> > You're right.
>
> Ok, so I repeat my comment above!
>
> Tom.
>
> >
> > Please send v2 patch after adding comments that Tom pointed out.
> >
> > Thanks!
> >>
> >>>> +                                     }
> >>>> +                             }
> >>>>                        }
> >>>> -                     dev_put(ndev);
> >>>>                }
> >>>>        }
> >>>>    out:
> >>
> >>
> >>
> >> --
> >> Kangjing "Chaser" Huang
> >>
> >



--
Kangjing "Chaser" Huang
