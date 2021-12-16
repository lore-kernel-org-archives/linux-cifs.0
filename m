Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E246C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 13:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhLPNUb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Dec 2021 08:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhLPNUb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Dec 2021 08:20:31 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF009C061574
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 05:20:30 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id p37so47064016uae.8
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 05:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cLEeq6rq3k4R0XkebZ0KiiM4zpCyusNgaRJuq7fHqjc=;
        b=R6Y3ugOGVEG8vMFyS4WQl9AFUu6Cj6C7rGxLoHjGBICTZzHf5XjOf2izEWPMeQDElZ
         UdpW0PI+TikaEKqlaRJfkKT3SQpBQQFPM5xHQ0L0qFlJ07dN6rszWLLSbkobTSyjiTi4
         gWIpQH5P4x4j6T/7ito5eM/ulIItPBigmzfC+Vda5pVfleR/fGkeANMaZvgYdh50Vrzb
         Ucn7kMcQU25VAJ9ZYFrBtksRGcaJCswc3wg1i4BtEo75ulD4AlzKXEBpHFDY3CjgqpOm
         6r302Q4rbWCZPKgRwEajHQFvGLTclhSt1WfISOilhoImWdCCBsXHP/kjxErNd176u3dT
         zXqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cLEeq6rq3k4R0XkebZ0KiiM4zpCyusNgaRJuq7fHqjc=;
        b=Cza+5KsMYsWr9GEwL2ez8ZL3GUoso393CRxBVErWSnSLyxCPFKSuEBFoDNklx9pCxO
         bTT5wAHriCoH/2TAnmoJM3SZNJ2RI58c1OzMpcWUF7PqDaspFlLt6yZD/GRBw788ZdlZ
         8IqDmp3fPXdHHzDCx8Dn43Xa6BVFpK7WADOR0ykJ6LV3WUwDVMiDs0yoYfq5KLLLgZlM
         9rIIh8adjAtn2T1i8HmkNQHaaSCuclKNAQF2XfVNw6vuwK6rJwgYRAfUjoLgBwXYJ8rR
         xPLuOzAJow5vqx4reG3EEf6neI5w0mdJztub/KE7bv5ERK99BvC6R5wwKRRgl2C2uwE9
         LDmA==
X-Gm-Message-State: AOAM533yeqY8crFU8VXS8jp+LsUmc9EQuRB+4nQDFnJjBHHenY3sAjKl
        7NedCsYvE9E58tqrFCGSbpIiL4t4RvyIhhoJ9Ee66gholx8=
X-Google-Smtp-Source: ABdhPJyzmDbEPiKFliNk9l3e7hs5HTvPmuxonJDo0noSx/1391DAlJPmB64E+U07pa+aTlJZCfdfYvce4wN86RWdXd8=
X-Received: by 2002:a67:b917:: with SMTP id q23mr5736190vsn.80.1639660830068;
 Thu, 16 Dec 2021 05:20:30 -0800 (PST)
MIME-Version: 1.0
References: <20211216013725.8065-1-linkinjeon@kernel.org> <20211216013725.8065-2-linkinjeon@kernel.org>
In-Reply-To: <20211216013725.8065-2-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 16 Dec 2021 22:20:19 +0900
Message-ID: <CANFS6baDt3-iWf1xeBQ3n=Sxn98wA7De0mduzAmiH6jRjEBWbQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ksmbd: set both ipv4 and ipv6 in FSCTL_QUERY_NETWORK_INTERFACE_INFO
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 12=EC=9B=94 16=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 5:48, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Set ipv4 and ipv6 address in FSCTL_QUERY_NETWORK_INTERFACE_INFO.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  v2:
>    - move buffer check to under ipv6_retry to validate overflow.
>
>  fs/ksmbd/smb2pdu.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 2ff4f813026e..0fbb62f9d509 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7224,15 +7224,10 @@ static int fsctl_query_iface_info_ioctl(struct ks=
mbd_conn *conn,
>         struct sockaddr_storage_rsp *sockaddr_storage;
>         unsigned int flags;
>         unsigned long long speed;
> -       struct sockaddr_in6 *csin6 =3D (struct sockaddr_in6 *)&conn->peer=
_addr;
>
>         rtnl_lock();
>         for_each_netdev(&init_net, netdev) {
> -               if (out_buf_len <
> -                   nbytes + sizeof(struct network_interface_info_ioctl_r=
sp)) {
> -                       rtnl_unlock();
> -                       return -ENOSPC;
> -               }
> +               bool ipv4_set =3D false;
>
>                 if (netdev->type =3D=3D ARPHRD_LOOPBACK)
>                         continue;
> @@ -7240,6 +7235,12 @@ static int fsctl_query_iface_info_ioctl(struct ksm=
bd_conn *conn,
>                 flags =3D dev_get_flags(netdev);
>                 if (!(flags & IFF_RUNNING))
>                         continue;
> +ipv6_retry:
> +               if (out_buf_len <
> +                   nbytes + sizeof(struct network_interface_info_ioctl_r=
sp)) {
> +                       rtnl_unlock();
> +                       return -ENOSPC;
> +               }
>
>                 nii_rsp =3D (struct network_interface_info_ioctl_rsp *)
>                                 &rsp->Buffer[nbytes];
> @@ -7272,8 +7273,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmb=
d_conn *conn,
>                                         nii_rsp->SockAddr_Storage;
>                 memset(sockaddr_storage, 0, 128);
>
> -               if (conn->peer_addr.ss_family =3D=3D PF_INET ||
> -                   ipv6_addr_v4mapped(&csin6->sin6_addr)) {
> +               if (!ipv4_set) {
>                         struct in_device *idev;
>
>                         sockaddr_storage->Family =3D cpu_to_le16(INTERNET=
WORK);
> @@ -7284,6 +7284,9 @@ static int fsctl_query_iface_info_ioctl(struct ksmb=
d_conn *conn,
>                                 continue;
>                         sockaddr_storage->addr4.IPv4address =3D
>                                                 idev_ipv4_address(idev);
> +                       nbytes +=3D sizeof(struct network_interface_info_=
ioctl_rsp);
> +                       ipv4_set =3D true;
> +                       goto ipv6_retry;
>                 } else {
>                         struct inet6_dev *idev6;
>                         struct inet6_ifaddr *ifa;
> @@ -7305,9 +7308,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmb=
d_conn *conn,
>                                 break;
>                         }
>                         sockaddr_storage->addr6.ScopeId =3D 0;
> +                       nbytes +=3D sizeof(struct network_interface_info_=
ioctl_rsp);
>                 }
> -
> -               nbytes +=3D sizeof(struct network_interface_info_ioctl_rs=
p);
>         }
>         rtnl_unlock();
>
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
