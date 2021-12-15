Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E287CC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Dec 2021 22:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbhLOWPm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Dec 2021 17:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhLOWPl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Dec 2021 17:15:41 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E03EC061574
        for <linux-cifs@vger.kernel.org>; Wed, 15 Dec 2021 14:15:41 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id 107so3264961uaj.10
        for <linux-cifs@vger.kernel.org>; Wed, 15 Dec 2021 14:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JoswED7qzqKT418K1crj6NtptIQbNWbJT9sBQWoRpII=;
        b=lm39nEvlTsMxd1RkpPh3lUuAT1hzz/FHueZn3VxNaZj7jhO766kIvOctPMpjnj9jmw
         Fm+C0dBM3zOLfbUYleYd91Ivu9/75xwDPLrgr1VxI+1mKYtbQurAdbCSpV7HoqJUvnZN
         K0Ouhqxb+rpapFpD8fUgJMLGFVgazbofR7Nm3Gu4b/gxgeY7+pw3cv2y6gwcPUcJs91h
         DTngzgSPedPLaaISxX0axT6SCMqUOswYDjF3HOCrgcfVfcqrKBl5j7ft+jfaI5oWc7SX
         oY2XOY8DUbotdeishEVIE+2W7/AiaemOmQbHheUeOjX2UpYw3MBsUaZ4Q64sNFf3iKQm
         hDDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JoswED7qzqKT418K1crj6NtptIQbNWbJT9sBQWoRpII=;
        b=3KtspgV7Eb0GWIj6kEPLgjmUXRjFX7CpAbE2iOFN/rorypxeXUFRmg52BlQGiOzVPZ
         S1Zqk076DjWm/MpvcyPwhqI4LMGGnlNAQ4ooyFpawk3Re+UZI/OEiWslnQbDYSoqr9vW
         0aC9doO60E2vGNfkukdjRAeju/Oq7EhgleMD+6DSYxwW4f9DTwd6SK44oyBuNzwaLeUd
         TPmDhDmJ8PVjF9uUxixla6zVAek0Mspnsc4h8Vl4ZRFxeEL5tXmfDrbXu4/JbpqSeQGY
         7KFxGMCNLHkx+dhv5aXlfxmZToK2URqwCBmxUBhMBRx2isgZeNc6TCZONPDkzg63a5fK
         HkKQ==
X-Gm-Message-State: AOAM531XCNFs1Oj5MlwPnZzuoYh8S/H9AO9tPaaJgH65/uIW5K8Wz39g
        riKJxsGwrSXlT/ydyIOMYSh+USBM27cyr8vHpWRYTHBuDi8=
X-Google-Smtp-Source: ABdhPJxMjdYRBqV/Hmn2v1qiM+W4e7xXE43VIo2OTTsVP63jBPApbeGrXxN8xHocXo35t/jXJnln0Xyku/leWLlfhG8=
X-Received: by 2002:a05:6102:2c6:: with SMTP id h6mr4490868vsh.13.1639606540068;
 Wed, 15 Dec 2021 14:15:40 -0800 (PST)
MIME-Version: 1.0
References: <20211215060206.8048-1-linkinjeon@kernel.org>
In-Reply-To: <20211215060206.8048-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 16 Dec 2021 07:15:28 +0900
Message-ID: <CANFS6bZdA+ZDHLCgbi3P2hej0a1-nNweDc0HOeF8rNe8ayrP_g@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: set RSS capable in FSCTL_QUERY_NETWORK_INTERFACE_INFO
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Ziwei Xie <zw.xie@high-flyer.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 12=EC=9B=94 16=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 4:47, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Set RSS capable in FSCTL_QUERY_NETWORK_INTERFACE_INFO if netdev has
> multi tx queues. And add ksmbd_compare_user() to avoid racy condition
> issue in ksmbd_free_user(). because windows client is simultaneously used
> to send session setup requests for multichannel connection.
>
> Tested-by: Ziwei Xie <zw.xie@high-flyer.cn>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/mgmt/user_config.c | 10 ++++++++++
>  fs/ksmbd/mgmt/user_config.h |  1 +
>  fs/ksmbd/smb2pdu.c          | 14 +++++++++-----
>  3 files changed, 20 insertions(+), 5 deletions(-)
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
> index f7bea92d4c98..7aee3b58b16f 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -1429,10 +1429,15 @@ static int ntlm_authenticate(struct ksmbd_work *w=
ork)
>                         ksmbd_free_user(user);
>                         return 0;
>                 }
> -               ksmbd_free_user(sess->user);
> +
> +               if (!ksmbd_compare_user(sess->user, user))
> +                       return -EPERM;
> +

We  don't need to free the user? Other than that, this looks good to me.

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
> @@ -2036,9 +2041,6 @@ int smb2_session_logoff(struct ksmbd_work *work)
>
>         ksmbd_debug(SMB, "request\n");
>
> -       /* Got a valid session, set connection state */
> -       WARN_ON(sess->conn !=3D conn);
> -
>         /* setting CifsExiting here may race with start_tcp_sess */
>         ksmbd_conn_set_need_reconnect(work);
>         ksmbd_close_session_fds(work);
> @@ -7243,6 +7245,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmb=
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
