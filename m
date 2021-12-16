Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9FBC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 13:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbhLPNLX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Dec 2021 08:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237306AbhLPNLX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Dec 2021 08:11:23 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0F7C061574
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 05:11:23 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id 70so16775589vkx.7
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 05:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i2DLktKRQEDKedBJeATIiKMnhKb9qBwTc67xoncAV1Y=;
        b=iWWXUBxPhHmlJA3ybt2oF7pcv88ugSw+31f8xtNX5kpAtHI6P4XGCIV+ZUOcZrYNxI
         bVvn/PecS1aV2x7DGhGeFzNKvdcgKWcM20LviilSbfEw9hA0AufUTiQfWJC8ktP3iIAk
         bVAKZyOAbUsRliSPeoF+4eAAgkMI27ztecsy+JfKbMHoTAV7a7hQC3X8NjQqHMHrCFy4
         Cb+FYjZdt/FH5idml4PV5jKluOJaNWd8k2CosmblA+po5Gvroi06vjX1cgso3RP1a815
         9cYwSn0mqQ0wwYagtyR/1oVDBw8Z5t+tqO9Vyx/PKuerZcs/tzgRF4lR5E12l/fgBlQe
         TbTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i2DLktKRQEDKedBJeATIiKMnhKb9qBwTc67xoncAV1Y=;
        b=z7BgiU4MhCJTw5niEI5S7acogt4lT1ReEwXL7OiN3yCO6am1wF3Me2Fq/DxFrBlktw
         DvEK3dFlEYIetLOGejgF4wwKIKoUFDO7M9R5gP1q1miFNLhVTgpxhRUzYepg/hPJOsh0
         3P2vrmGi2b82Z4V486oUitQEWVe3yLodQMaBszL/btmzIkp69GgA39XpCvqG8Nhn3mdk
         0PumBWjk1yQP5Bx/uBou8bQgFYAT9zNbjFB7tousw8i5ASrIGdfHbglvv6aFI16c/Xe8
         r1wwdUDDOt7jzrt+WgSWUKhQg8ACQ5CYw0GFo/QucNajYcF/8BVowH0nlGQnPW9d3ZCb
         y9Tg==
X-Gm-Message-State: AOAM531WHr/PCja+jKFBtrlO6Sg6nYVpZefcQyLJRL/sFePwNV1LZqLh
        jrdgnmLaEv1X5FZpXM8hDzE+XHIyol3IaZIK5m+Fk7uZF/s=
X-Google-Smtp-Source: ABdhPJwGdt6JxeT52mHAvAvPaRc3iNf/HHkmV9Pkq+Z/gSjCTiM0xN4dNOo06//0nukh1dNEFM4sJlvOR+B/Xpr9B3o=
X-Received: by 2002:a05:6122:12c2:: with SMTP id d2mr6276066vkp.37.1639660282131;
 Thu, 16 Dec 2021 05:11:22 -0800 (PST)
MIME-Version: 1.0
References: <20211216013725.8065-1-linkinjeon@kernel.org>
In-Reply-To: <20211216013725.8065-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 16 Dec 2021 22:11:11 +0900
Message-ID: <CANFS6baAqvCoix=7RAo_F=EYbPtrAXAC4nThDjdxqO=SfdXrDQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ksmbd: set RSS capable in FSCTL_QUERY_NETWORK_INTERFACE_INFO
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
> Set RSS capable in FSCTL_QUERY_NETWORK_INTERFACE_INFO if netdev has
> multi tx queues. And add ksmbd_compare_user() to avoid racy condition
> issue in ksmbd_free_user(). because windows client is simultaneously used
> to send session setup requests for multichannel connection.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  v2:
>    - Add missing free ksmbd_user before returning.
>
>  fs/ksmbd/mgmt/user_config.c | 10 ++++++++++
>  fs/ksmbd/mgmt/user_config.h |  1 +
>  fs/ksmbd/smb2pdu.c          | 15 ++++++++++-----
>  3 files changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ksmbd/mgmt/user_config.c b/fs/ksmbd/mgmt/user_config.c
> index 1019d3677d55..279d00feff21 100644
> --- a/fs/ksmbd/mgmt/user_config.c
> +++ b/fs/ksmbd/mgmt/user_config.c
> @@ -67,3 +67,13 @@ int ksmbd_anonymous_user(struct ksmbd_user *user)
>                 return 1;
>         return 0;
>  }
> +
> +bool ksmbd_compare_user(struct ksmbd_user *u1, struct ksmbd_user *u2)
> +{
> +       if (strcmp(u1->name, u2->name))
> +               return false;
> +       if (memcmp(u1->passkey, u2->passkey, u1->passkey_sz))
> +               return false;
> +
> +       return true;
> +}
> diff --git a/fs/ksmbd/mgmt/user_config.h b/fs/ksmbd/mgmt/user_config.h
> index aff80b029579..6a44109617f1 100644
> --- a/fs/ksmbd/mgmt/user_config.h
> +++ b/fs/ksmbd/mgmt/user_config.h
> @@ -64,4 +64,5 @@ struct ksmbd_user *ksmbd_login_user(const char *account=
);
>  struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp);
>  void ksmbd_free_user(struct ksmbd_user *user);
>  int ksmbd_anonymous_user(struct ksmbd_user *user);
> +bool ksmbd_compare_user(struct ksmbd_user *u1, struct ksmbd_user *u2);
>  #endif /* __USER_CONFIG_MANAGEMENT_H__ */
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index f7bea92d4c98..2ff4f813026e 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -1429,10 +1429,16 @@ static int ntlm_authenticate(struct ksmbd_work *w=
ork)
>                         ksmbd_free_user(user);
>                         return 0;
>                 }
> -               ksmbd_free_user(sess->user);
> +
> +               if (!ksmbd_compare_user(sess->user, user)) {
> +                       ksmbd_free_user(user);
> +                       return -EPERM;
> +               }
> +               ksmbd_free_user(user);
> +       } else {
> +               sess->user =3D user;
>         }
>
> -       sess->user =3D user;
>         if (user_guest(sess->user)) {
>                 if (conn->sign) {
>                         ksmbd_debug(SMB, "Guest login not allowed when si=
gning enabled\n");
> @@ -2036,9 +2042,6 @@ int smb2_session_logoff(struct ksmbd_work *work)
>
>         ksmbd_debug(SMB, "request\n");
>
> -       /* Got a valid session, set connection state */
> -       WARN_ON(sess->conn !=3D conn);
> -
>         /* setting CifsExiting here may race with start_tcp_sess */
>         ksmbd_conn_set_need_reconnect(work);
>         ksmbd_close_session_fds(work);
> @@ -7243,6 +7246,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmb=
d_conn *conn,
>                 nii_rsp->IfIndex =3D cpu_to_le32(netdev->ifindex);
>
>                 nii_rsp->Capability =3D 0;
> +               if (netdev->real_num_tx_queues > 1)
> +                       nii_rsp->Capability |=3D cpu_to_le32(RSS_CAPABLE)=
;
>                 if (ksmbd_rdma_capable_netdev(netdev))
>                         nii_rsp->Capability |=3D cpu_to_le32(RDMA_CAPABLE=
);
>
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
