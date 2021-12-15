Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9383BC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Dec 2021 22:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhLOW2x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Dec 2021 17:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhLOW21 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Dec 2021 17:28:27 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA30C061191
        for <linux-cifs@vger.kernel.org>; Wed, 15 Dec 2021 14:28:23 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id q21so15612190vkn.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Dec 2021 14:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XNvdVI01zumE/adNQ3PiXhjHprq8rjZqiqPBXneehSs=;
        b=LVMqWEsC4x91E1ov7D/6Bp2EwUWB11jyDvjBSoW/OTLUTHf3pODZRMkl3npA3fVpsO
         YCcsaI6iCWtdlFFTqBZqwmOLISqM9CuRC9I+eAPtNoaSg0HeIHT5CnEnpSjrKzD00EYm
         pyBskP02CH3edkcm0z6vt4HTbEfpKMQM2lrI9GAWP9UD1ZTVMKh+CDRgDjEtmAZh4Xv7
         T9SgKl7Dsi3cPAjkKkC+40wWyk3hQxpVkhAErG3FXbVOchmS4yGcc29m2gQYWJ/YG1nk
         VfulNkw9d6tA6qqBOLb7T0oCMMH6OoDkeQ/vAsVJz5SpItuO5k7AmbS01XtKAtUCpzSa
         zlsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XNvdVI01zumE/adNQ3PiXhjHprq8rjZqiqPBXneehSs=;
        b=wrFj3Ar8Egq/6bZXFYh8aijbNay5169TktIZRDotaL3Z8W+9aO6JwpoRqKkrRaxMY5
         j5snCnupiWD2QFKejKYJbkI9qNkV74wfMMlJANkM9zaGvu4qUrJLp0An+FkVwP9SHPSA
         OoF1kI6jqwKH48CGhbZH+5O+xc+sGOpZXQS6who5zrbnTdsmuYC59+9JPXYX5VU5qoG9
         ONf04EmmsY3at3iy1xr9tc5KnB6MNjCx2dBHoy8pBkV4vR+fdtcSw3UZItKtatInx9Wq
         sbWrZgfkzyU/E/kpALeJ9wBcYUKlcuyuaIJSaZuAHrLVn2KuhiNzJm8BOINq2VD5yBYa
         wPCQ==
X-Gm-Message-State: AOAM533UEcqODqcHqvbLep6eCH30D7A/Sf+GzcLOfh6Y+hrA6G0AUjSt
        BXodBk6N+cy59iqppON984F+wGT5JcKs7XvyJ+OdE7SHzgY=
X-Google-Smtp-Source: ABdhPJxnDRuOvLv96dNOGyBW8S93UVp2JM/s+0KGqNjqEpDG8/rROaSVamvnK9OuczIzI166Rb6TKMZV2CAVbDW4bGo=
X-Received: by 2002:a1f:c9c5:: with SMTP id z188mr5028246vkf.6.1639607302550;
 Wed, 15 Dec 2021 14:28:22 -0800 (PST)
MIME-Version: 1.0
References: <20211215060206.8048-1-linkinjeon@kernel.org> <20211215060206.8048-2-linkinjeon@kernel.org>
In-Reply-To: <20211215060206.8048-2-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 16 Dec 2021 07:28:11 +0900
Message-ID: <CANFS6baExN8MdK6BUemP22MHTpZmnJ8PcoQt7iPz_T-2jyKcLg@mail.gmail.com>
Subject: Re: [PATCH 2/3] ksmbd: set both ipv4 and ipv6 in FSCTL_QUERY_NETWORK_INTERFACE_INFO
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 12=EC=9B=94 16=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 4:46, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Set ipv4 and ipv6 address in FSCTL_QUERY_NETWORK_INTERFACE_INFO.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2pdu.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 7aee3b58b16f..4f938f038a65 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7223,10 +7223,11 @@ static int fsctl_query_iface_info_ioctl(struct ks=
mbd_conn *conn,
>         struct sockaddr_storage_rsp *sockaddr_storage;
>         unsigned int flags;
>         unsigned long long speed;
> -       struct sockaddr_in6 *csin6 =3D (struct sockaddr_in6 *)&conn->peer=
_addr;
>
>         rtnl_lock();
>         for_each_netdev(&init_net, netdev) {
> +               bool ipv4_set =3D false;
> +
>                 if (out_buf_len <
>                     nbytes + sizeof(struct network_interface_info_ioctl_r=
sp)) {
>                         rtnl_unlock();
> @@ -7239,7 +7240,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmb=
d_conn *conn,
>                 flags =3D dev_get_flags(netdev);
>                 if (!(flags & IFF_RUNNING))
>                         continue;
> -
> +ipv6_retry:

Don't we need to check out_buf_len to prevent buffer overflow?

>                 nii_rsp =3D (struct network_interface_info_ioctl_rsp *)
>                                 &rsp->Buffer[nbytes];
>                 nii_rsp->IfIndex =3D cpu_to_le32(netdev->ifindex);
> @@ -7271,8 +7272,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmb=
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
> @@ -7283,6 +7283,9 @@ static int fsctl_query_iface_info_ioctl(struct ksmb=
d_conn *conn,
>                                 continue;
>                         sockaddr_storage->addr4.IPv4address =3D
>                                                 idev_ipv4_address(idev);
> +                       nbytes +=3D sizeof(struct network_interface_info_=
ioctl_rsp);
> +                       ipv4_set =3D true;
> +                       goto ipv6_retry;

if __in_dev_get_rtnl is failed , Don't we need to goto ipv6_retry?

>                 } else {
>                         struct inet6_dev *idev6;
>                         struct inet6_ifaddr *ifa;
> @@ -7304,9 +7307,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmb=
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
