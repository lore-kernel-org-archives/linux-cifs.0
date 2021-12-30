Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D81C9C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Dec 2021 22:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237533AbhL3WBG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Dec 2021 17:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbhL3WBG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Dec 2021 17:01:06 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30181C061574
        for <linux-cifs@vger.kernel.org>; Thu, 30 Dec 2021 14:01:06 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id m200so14357853vka.6
        for <linux-cifs@vger.kernel.org>; Thu, 30 Dec 2021 14:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RyItsoMTaAjY3HUOJzuQLUudNXV7vyYjaSnmAZDEvDk=;
        b=W/EiO0qhCJDHC5wV+h69NpBpAYjmhLONDi1dMskGzfkeBXyfoHvbgX7nvCeHUDsJuZ
         5bxZj2GZWxEdImizkP9QwwrNZYH+3kBfCPZsJWEnVgCL3OKlbr2WwzJDWfYN4Y/zp4dt
         N33sjFYKR4PXophOWM5zTwHIE1yo1HldoelembFhsdBBvVIMbyC/JaqzKMO3X34F/aNN
         OMfnDr8O362y2J4np4h0ZI65CPKeTZSOY1dj9Bzt+J49nwtFm89ChbSSShU0+JP3sZh9
         yQl8+7PfJocKNQxMSCXghdEBMTwSXLTiHVTRKHbjIy1uUT8pNBAAfh6cj9Xztvj4jV+L
         ztbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RyItsoMTaAjY3HUOJzuQLUudNXV7vyYjaSnmAZDEvDk=;
        b=lIj+F2+QUPDzxUbXrDltgDuhNfKyGPw+bcaD3mbUFHXxFgaDOsz2DDuSPqKkXImM9O
         QyGmlNuQXxKSSryTlRNPDtFITCAHbaNZH31EyYYo26vgcqwy0kVNy0X7FzXavi1CybgB
         p/Uivy1+Jqv3T1Y2gls9NCUg951aue1+x6FmdhdGUJXBieukHl0wRIUgiR41H6DB3YNk
         8DH4aUqNJ+LA7UXFihrWYDn96ZmlrQXjigO2MeDTpHhdkeZ33OTgQugweK8YQ6zhaZaN
         9RlVsDMoe64ys8tKdnNgHGy5AidNysfc1qRcMo5YdWI0or2l1aDbylUhABEKNSVOUHy+
         9XMg==
X-Gm-Message-State: AOAM533/AYcI3GySCdDCCECUeDDLXbObXbCBnVqcoAtkaV5DOtnwb2JK
        ykRIoad4njVgR8GqRaPGsFDW41dEVZ/zjDPnUEXPBW9Q
X-Google-Smtp-Source: ABdhPJwpbgs7M+MOqE0/a1jQKDmd4h3MwyabBYWVFNNSmOdP30S5gOVrYJb+eYyuRy+1wRPPBM+6U+uLwuYKkVtyXxc=
X-Received: by 2002:a05:6122:1073:: with SMTP id k19mr7235768vko.37.1640901664795;
 Thu, 30 Dec 2021 14:01:04 -0800 (PST)
MIME-Version: 1.0
References: <20211229141457.11636-1-linkinjeon@kernel.org> <20211229141457.11636-3-linkinjeon@kernel.org>
In-Reply-To: <20211229141457.11636-3-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Fri, 31 Dec 2021 07:00:53 +0900
Message-ID: <CANFS6bb+p-1LNLnPXpSbLVrDCk5qS1yNFPV1HHZD7fHYG94YXg@mail.gmail.com>
Subject: Re: [PATCH 3/4] ksmbd: add support for smb2 max credit parameter
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 12=EC=9B=94 31=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 2:55, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Add smb2 max credits parameter to adjust maximum credits value to limit
> number of outstanding requests.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  fs/ksmbd/connection.h    |  1 -
>  fs/ksmbd/ksmbd_netlink.h |  1 +
>  fs/ksmbd/smb2misc.c      |  2 +-
>  fs/ksmbd/smb2ops.c       | 16 ++++++++++++----
>  fs/ksmbd/smb2pdu.c       |  8 ++++----
>  fs/ksmbd/smb2pdu.h       |  1 +
>  fs/ksmbd/smb_common.h    |  1 +
>  fs/ksmbd/transport_ipc.c |  2 ++
>  8 files changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
> index 72dfd155b5bf..42ffb6d9c5d8 100644
> --- a/fs/ksmbd/connection.h
> +++ b/fs/ksmbd/connection.h
> @@ -62,7 +62,6 @@ struct ksmbd_conn {
>         /* References which are made for this Server object*/
>         atomic_t                        r_count;
>         unsigned short                  total_credits;
> -       unsigned short                  max_credits;
>         spinlock_t                      credits_lock;
>         wait_queue_head_t               req_running_q;
>         /* Lock to protect requests list*/
> diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
> index c6718a05d347..a5c2861792ae 100644
> --- a/fs/ksmbd/ksmbd_netlink.h
> +++ b/fs/ksmbd/ksmbd_netlink.h
> @@ -103,6 +103,7 @@ struct ksmbd_startup_request {
>                                          * we set the SPARSE_FILES bit (0=
x40).
>                                          */
>         __u32   sub_auth[3];            /* Subauth value for Security ID =
*/
> +       __u32   smb2_max_credits;       /* MAX credits */
>         __u32   ifc_list_sz;            /* interfaces list size */
>         __s8    ____payload[];
>  };
> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
> index 50d0b1022289..6892d1822269 100644
> --- a/fs/ksmbd/smb2misc.c
> +++ b/fs/ksmbd/smb2misc.c
> @@ -326,7 +326,7 @@ static int smb2_validate_credit_charge(struct ksmbd_c=
onn *conn,
>                 ksmbd_debug(SMB, "Insufficient credit charge, given: %d, =
needed: %d\n",
>                             credit_charge, calc_credit_num);
>                 return 1;
> -       } else if (credit_charge > conn->max_credits) {
> +       } else if (credit_charge > conn->vals->max_credits) {
>                 ksmbd_debug(SMB, "Too large credit charge: %d\n", credit_=
charge);
>                 return 1;
>         }
> diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
> index 02a44d28bdaf..ab23da2120b9 100644
> --- a/fs/ksmbd/smb2ops.c
> +++ b/fs/ksmbd/smb2ops.c
> @@ -19,6 +19,7 @@ static struct smb_version_values smb21_server_values =
=3D {
>         .max_read_size =3D SMB21_DEFAULT_IOSIZE,
>         .max_write_size =3D SMB21_DEFAULT_IOSIZE,
>         .max_trans_size =3D SMB21_DEFAULT_IOSIZE,
> +       .max_credits =3D SMB2_MAX_CREDITS,
>         .large_lock_type =3D 0,
>         .exclusive_lock_type =3D SMB2_LOCKFLAG_EXCLUSIVE,
>         .shared_lock_type =3D SMB2_LOCKFLAG_SHARED,
> @@ -44,6 +45,7 @@ static struct smb_version_values smb30_server_values =
=3D {
>         .max_read_size =3D SMB3_DEFAULT_IOSIZE,
>         .max_write_size =3D SMB3_DEFAULT_IOSIZE,
>         .max_trans_size =3D SMB3_DEFAULT_TRANS_SIZE,
> +       .max_credits =3D SMB2_MAX_CREDITS,
>         .large_lock_type =3D 0,
>         .exclusive_lock_type =3D SMB2_LOCKFLAG_EXCLUSIVE,
>         .shared_lock_type =3D SMB2_LOCKFLAG_SHARED,
> @@ -70,6 +72,7 @@ static struct smb_version_values smb302_server_values =
=3D {
>         .max_read_size =3D SMB3_DEFAULT_IOSIZE,
>         .max_write_size =3D SMB3_DEFAULT_IOSIZE,
>         .max_trans_size =3D SMB3_DEFAULT_TRANS_SIZE,
> +       .max_credits =3D SMB2_MAX_CREDITS,
>         .large_lock_type =3D 0,
>         .exclusive_lock_type =3D SMB2_LOCKFLAG_EXCLUSIVE,
>         .shared_lock_type =3D SMB2_LOCKFLAG_SHARED,
> @@ -96,6 +99,7 @@ static struct smb_version_values smb311_server_values =
=3D {
>         .max_read_size =3D SMB3_DEFAULT_IOSIZE,
>         .max_write_size =3D SMB3_DEFAULT_IOSIZE,
>         .max_trans_size =3D SMB3_DEFAULT_TRANS_SIZE,
> +       .max_credits =3D SMB2_MAX_CREDITS,
>         .large_lock_type =3D 0,
>         .exclusive_lock_type =3D SMB2_LOCKFLAG_EXCLUSIVE,
>         .shared_lock_type =3D SMB2_LOCKFLAG_SHARED,
> @@ -197,7 +201,6 @@ void init_smb2_1_server(struct ksmbd_conn *conn)
>         conn->ops =3D &smb2_0_server_ops;
>         conn->cmds =3D smb2_0_server_cmds;
>         conn->max_cmds =3D ARRAY_SIZE(smb2_0_server_cmds);
> -       conn->max_credits =3D SMB2_MAX_CREDITS;
>         conn->signing_algorithm =3D SIGNING_ALG_HMAC_SHA256_LE;
>
>         if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
> @@ -215,7 +218,6 @@ void init_smb3_0_server(struct ksmbd_conn *conn)
>         conn->ops =3D &smb3_0_server_ops;
>         conn->cmds =3D smb2_0_server_cmds;
>         conn->max_cmds =3D ARRAY_SIZE(smb2_0_server_cmds);
> -       conn->max_credits =3D SMB2_MAX_CREDITS;
>         conn->signing_algorithm =3D SIGNING_ALG_AES_CMAC_LE;
>
>         if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
> @@ -240,7 +242,6 @@ void init_smb3_02_server(struct ksmbd_conn *conn)
>         conn->ops =3D &smb3_0_server_ops;
>         conn->cmds =3D smb2_0_server_cmds;
>         conn->max_cmds =3D ARRAY_SIZE(smb2_0_server_cmds);
> -       conn->max_credits =3D SMB2_MAX_CREDITS;
>         conn->signing_algorithm =3D SIGNING_ALG_AES_CMAC_LE;
>
>         if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
> @@ -265,7 +266,6 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
>         conn->ops =3D &smb3_11_server_ops;
>         conn->cmds =3D smb2_0_server_cmds;
>         conn->max_cmds =3D ARRAY_SIZE(smb2_0_server_cmds);
> -       conn->max_credits =3D SMB2_MAX_CREDITS;
>         conn->signing_algorithm =3D SIGNING_ALG_AES_CMAC_LE;
>
>         if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
> @@ -304,3 +304,11 @@ void init_smb2_max_trans_size(unsigned int sz)
>         smb302_server_values.max_trans_size =3D sz;
>         smb311_server_values.max_trans_size =3D sz;
>  }
> +
> +void init_smb2_max_credits(unsigned int sz)
> +{
> +       smb21_server_values.max_credits =3D sz;
> +       smb30_server_values.max_credits =3D sz;
> +       smb302_server_values.max_credits =3D sz;
> +       smb311_server_values.max_credits =3D sz;
> +}
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index b00108921bbb..860fe3a03ad7 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -308,7 +308,7 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
>
>         hdr->CreditCharge =3D req_hdr->CreditCharge;
>
> -       if (conn->total_credits > conn->max_credits) {
> +       if (conn->total_credits > conn->vals->max_credits) {
>                 hdr->CreditRequest =3D 0;
>                 pr_err("Total credits overflow: %d\n", conn->total_credit=
s);
>                 return -EINVAL;
> @@ -329,12 +329,12 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
>         if (hdr->Command =3D=3D SMB2_NEGOTIATE)
>                 aux_max =3D 0;
>         else
> -               aux_max =3D conn->max_credits - credit_charge;
> +               aux_max =3D conn->vals->max_credits - credit_charge;
>         aux_credits =3D min_t(unsigned short, aux_credits, aux_max);
>         credits_granted =3D credit_charge + aux_credits;
>
> -       if (conn->max_credits - conn->total_credits < credits_granted)
> -               credits_granted =3D conn->max_credits -
> +       if (conn->vals->max_credits - conn->total_credits < credits_grant=
ed)
> +               credits_granted =3D conn->vals->max_credits -
>                         conn->total_credits;
>
>         conn->total_credits +=3D credits_granted;
> diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
> index 4a3e4339d4c4..725b800c29c8 100644
> --- a/fs/ksmbd/smb2pdu.h
> +++ b/fs/ksmbd/smb2pdu.h
> @@ -980,6 +980,7 @@ int init_smb3_11_server(struct ksmbd_conn *conn);
>  void init_smb2_max_read_size(unsigned int sz);
>  void init_smb2_max_write_size(unsigned int sz);
>  void init_smb2_max_trans_size(unsigned int sz);
> +void init_smb2_max_credits(unsigned int sz);
>
>  bool is_smb2_neg_cmd(struct ksmbd_work *work);
>  bool is_smb2_rsp(struct ksmbd_work *work);
> diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
> index 50590842b651..e1369b4345a9 100644
> --- a/fs/ksmbd/smb_common.h
> +++ b/fs/ksmbd/smb_common.h
> @@ -365,6 +365,7 @@ struct smb_version_values {
>         __u32           max_read_size;
>         __u32           max_write_size;
>         __u32           max_trans_size;
> +       __u32           max_credits;
>         __u32           large_lock_type;
>         __u32           exclusive_lock_type;
>         __u32           shared_lock_type;
> diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
> index 1acf1892a466..3ad6881e0f7e 100644
> --- a/fs/ksmbd/transport_ipc.c
> +++ b/fs/ksmbd/transport_ipc.c
> @@ -301,6 +301,8 @@ static int ipc_server_config_on_startup(struct ksmbd_=
startup_request *req)
>                 init_smb2_max_write_size(req->smb2_max_write);
>         if (req->smb2_max_trans)
>                 init_smb2_max_trans_size(req->smb2_max_trans);
> +       if (req->smb2_max_credits)
> +               init_smb2_max_credits(req->smb2_max_credits);
>
>         ret =3D ksmbd_set_netbios_name(req->netbios_name);
>         ret |=3D ksmbd_set_server_string(req->server_string);
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
