Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84266C001DF
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Oct 2023 22:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbjJSWh7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Oct 2023 18:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235549AbjJSWh6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Oct 2023 18:37:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C9CFA
        for <linux-cifs@vger.kernel.org>; Thu, 19 Oct 2023 15:37:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F130DC433C8
        for <linux-cifs@vger.kernel.org>; Thu, 19 Oct 2023 22:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697755076;
        bh=IBjqmdqOhZYLxZ+R/YiYDDN/Xazyb49tNkUuOyaNNX4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=MyJC1/Z7hwJ9LsDOb60aUmMirueL0t9dgEsyyiwvAKtlLyvSj22ITM0ffd82ZZ2UL
         G7cGa2FwaiqxrRbj+S0w7EyoA+Z+GJ9MvVTfN9MwIR3XfFZXskoScc4j0mAyBvQjp1
         YmMX7rBXCpeOz5ikS+e5kWoRSZRs/LwehbkDdu2frru4AP4rNJzgGrYDrBaBMZLLac
         Bv01Xj6FBFiHuS8UOO8P63X9yyqUgGg8k+FPjP5oNUcE/EtWNrUm4QRUuwALVfCUpE
         53tN+WPwH2ykkaqw9wCdp7X4H9EBb6UbR80HF+bWmxQxBFzTc6NYYWprCp8KHcW9aE
         hqTpEkvTW/F6g==
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6c4a25f6390so149409a34.2
        for <linux-cifs@vger.kernel.org>; Thu, 19 Oct 2023 15:37:55 -0700 (PDT)
X-Gm-Message-State: AOJu0YyzN66ttLcv05CILC7zBpxLYdFdflu8ysY31y9+5R/p/3H8m8Gr
        hMD7zVZEoz15YiG3FotetxHRHtV4t1+qLLGcTj8=
X-Google-Smtp-Source: AGHT+IGfHMhEoJTehGnnZcyw9FLYwScYy12RH2mBZ1kWA4x4MkEw/qrGsWFAm0HP1Nxjw0KNlI+DU6jEZcpzlOKyMlo=
X-Received: by 2002:a05:6830:2092:b0:6b9:2e88:79cc with SMTP id
 y18-20020a056830209200b006b92e8879ccmr137774otq.19.1697755075191; Thu, 19 Oct
 2023 15:37:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:347:0:b0:4fa:bc5a:10a5 with HTTP; Thu, 19 Oct 2023
 15:37:53 -0700 (PDT)
In-Reply-To: <CAPbmFQZoXXdu6StcGrQO1iAzEyFfybt=GgTeqizP-KYQp7LLgQ@mail.gmail.com>
References: <20231015144536.9100-1-linkinjeon@kernel.org> <11e5bc36-677d-474d-acae-ab7e6ade9b2b@talpey.com>
 <CAPbmFQZoXXdu6StcGrQO1iAzEyFfybt=GgTeqizP-KYQp7LLgQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 20 Oct 2023 07:37:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-baiZEY=5Z4vaX=OQiSBKfKXsn+_tJOJo1mZ3uniRSzQ@mail.gmail.com>
Message-ID: <CAKYAXd-baiZEY=5Z4vaX=OQiSBKfKXsn+_tJOJo1mZ3uniRSzQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix missing RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()
To:     "Kangjing (Chaser) Huang" <huangkangjing@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-10-19 15:01 GMT+09:00, Kangjing (Chaser) Huang <huangkangjing@gmail.co=
m>:
> Thank you for the review. Also thanks a lot to Namjae for submitting
> this patch on my behalf.
>
>
> On Tue, Oct 17, 2023 at 10:07=E2=80=AFAM Tom Talpey <tom@talpey.com> wrot=
e:
>>
>> On 10/15/2023 10:45 AM, Namjae Jeon wrote:
>> > From: Kangjing Huang <huangkangjing@gmail.com>
>> >
>> > Physical ib_device does not have an underlying net_device, thus its
>> > association with IPoIB net_device cannot be retrieved via
>> > ops.get_netdev() or ib_device_get_by_netdev(). ksmbd reads physical
>> > ib_device port GUID from the lower 16 bytes of the hardware addresses
>> > on
>> > IPoIB net_device and match its underlying ib_device using ib_find_gid(=
)
>> >
>> > Signed-off-by: Kangjing Huang <huangkangjing@gmail.com>
>> > Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>> > ---
>> >   fs/smb/server/transport_rdma.c | 39
>> > +++++++++++++++++++++++++---------
>> >   1 file changed, 29 insertions(+), 10 deletions(-)
>> >
>> > diff --git a/fs/smb/server/transport_rdma.c
>> > b/fs/smb/server/transport_rdma.c
>> > index 3b269e1f523a..a82131f7dd83 100644
>> > --- a/fs/smb/server/transport_rdma.c
>> > +++ b/fs/smb/server/transport_rdma.c
>> > @@ -2140,8 +2140,7 @@ static int smb_direct_ib_client_add(struct
>> > ib_device *ib_dev)
>> >       if (ib_dev->node_type !=3D RDMA_NODE_IB_CA)
>> >               smb_direct_port =3D SMB_DIRECT_PORT_IWARP;
>> >
>> > -     if (!ib_dev->ops.get_netdev ||
>> > -         !rdma_frwr_is_supported(&ib_dev->attrs))
>> > +     if (!rdma_frwr_is_supported(&ib_dev->attrs))
>> >               return 0;
>> >
>> >       smb_dev =3D kzalloc(sizeof(*smb_dev), GFP_KERNEL);
>> > @@ -2241,17 +2240,37 @@ bool ksmbd_rdma_capable_netdev(struct net_devi=
ce
>> > *netdev)
>> >               for (i =3D 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
>> >                       struct net_device *ndev;
>> >
>> > -                     ndev =3D
>> > smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
>> > -                                                            i + 1);
>> > -                     if (!ndev)
>> > -                             continue;
>> > +                     /* RoCE and iWRAP ib_dev is backed by a netdev *=
/
>> > +                     if (smb_dev->ib_dev->ops.get_netdev) {
>>
>> The "IWRAP" is a typo, but IMO the comment is misleading. This is simply
>> looking up the target netdev, it's not limited to these two rdma types.
>> I suggest deleting the comment.
>>
>
> I agree with this point and will update this comment in version 2 of the
> patch.
>
>> > +                             ndev =3D smb_dev->ib_dev->ops.get_netdev=
(
>> > +                                     smb_dev->ib_dev, i + 1);
>> > +                             if (!ndev)
>> > +                                     continue;
>> >
>> > -                     if (ndev =3D=3D netdev) {
>> > +                             if (ndev =3D=3D netdev) {
>> > +                                     dev_put(ndev);
>> > +                                     rdma_capable =3D true;
>> > +                                     goto out;
>> > +                             }
>> >                               dev_put(ndev);
>>
>> Why not move this dev_put up above the if (ndev =3D=3D netdev) test? It'=
s
>> needed in both cases, so it's confusing to have two copies.
>
> I do agree that these two puts are very confusing. However, this code
> structure comes from the original ksmbd_rdma_capable_netdev() and
> this patch only indents it one more level and puts it in the if test for
> get_netdev.
>
> Also, while two puts look very weird, IMO putting it before the if
> statement
> is equally unintuitive as well since that would be testing the pointer af=
ter
> its
> reference is released. Although since no de-reference is happening here, =
it
> might be fine. Please confirm this is good coding-style-wise and I will
> include
> this change in v2 of the patch.
There is no need to update code that does not have problems.
>
>>
>> > -                             rdma_capable =3D true;
>> > -                             goto out;
>> > +                     /* match physical ib_dev with IPoIB netdev by GU=
ID
>> > */
>>
>> Add more information to this comment, perhaps:
>>
>>    /* if no exact netdev match, check for matching Infiniband GUID */
>>
>
> Fair point, will update this comment in v2.
>
>> > +                     } else if (netdev->type =3D=3D ARPHRD_INFINIBAND=
) {
>> > +                             struct netdev_hw_addr *ha;
>> > +                             union ib_gid gid;
>> > +                             u32 port_num;
>> > +                             int ret;
>> > +
>> > +                             netdev_hw_addr_list_for_each(
>> > +                                     ha, &netdev->dev_addrs) {
>> > +                                     memcpy(&gid, ha->addr + 4,
>> > sizeof(gid));
>> > +                                     ret =3D ib_find_gid(smb_dev->ib_=
dev,
>> > &gid,
>> > +                                                       &port_num,
>> > NULL);
>> > +                                     if (!ret) {
>> > +                                             rdma_capable =3D true;
>> > +                                             goto out;
>>
>> Won't this leak the ndev? It needs a dev_put(ndev) before breaking
>> the loop, too, right?
>>
>
> This will not leak the ndev. Please look closer, this else branch matches
> with
> the if test on the existence of ops.get_netdev of the current ib_dev. And
> ndev
> is acquired only through that op. In the else branch, ndev is just not
> acquired.
> The original code was indented one more level here so the patch might loo=
k
> a bit confusing, but one of the if before this block is a deleted(-) line=
.
You're right.

Please send v2 patch after adding comments that Tom pointed out.

Thanks!
>
>> > +                                     }
>> > +                             }
>> >                       }
>> > -                     dev_put(ndev);
>> >               }
>> >       }
>> >   out:
>
>
>
> --
> Kangjing "Chaser" Huang
>
