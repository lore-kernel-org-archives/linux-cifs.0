Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CD2C43334
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiGYAcb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 20:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGYAca (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 20:32:30 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B3911A1E
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 17:32:28 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bn9so2960900wrb.9
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 17:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2hp1WR0Nc4eyEivkSru9+QngB8U4iH7W0knFmZUa1pA=;
        b=Fi45FK8QT3wY7zVV0C4vOEOUcShYYaWCzRsyWxA4b5Lh6ku7P86OzLCm+MVhoikLQC
         QztiyaLnlL4/LBtEQdcTOk/Nkjzr9pY/bERZLXmBhE5kKYNufp3Z8hcbCTBj6To3bPhu
         o7wbYJDZrgb37aXe0P1kF/+qQdiiIxCdQ4rqThBmvtMa8kWoiEZrzSSTS68+qmS6KWbl
         o9OXLuCrFy5jzpT3fKkfWeuGwJzDZJXsec+mxA9bWqISQYABqT5KkSJVJcsH3ELwEXHU
         HwQb1tSFPfW33d5S4HF+hwq/AKQf1kLKOvSG8WLx5EPfPKwKfdNVDmEXV8DIojffkQJL
         Tfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2hp1WR0Nc4eyEivkSru9+QngB8U4iH7W0knFmZUa1pA=;
        b=vi7rqmEvwCpKo179cm8o/LrJHhQ/j5XHrcyexQQBgl6QgNefLn4SCXWxLcss3s3txm
         X/C0kvu5LSPtZNWfO1Y8uWaEhGFxZCsMe9CHEaa0sElaxdFPrSpAtSihnKOlVb682OvJ
         2Rh4ZhUGYISBKRQQTb+vNwjtVI8cMViFX+QhY+WteriKRn6eMqWmhOdOlFX9o2QfZc6u
         Yq+CgsRxFpDXeXP/Jt57C1gz/p1WtRWNu+q1gjbhA1YJgwfKekKPBcSvks3l+i63k8uP
         X4M87c766h8yPh4TqdY4oYKWkHBQklmP9zSLtx7mvAORgtrywjycynHxczD6nwj21S4g
         nQGQ==
X-Gm-Message-State: AJIora8kNZAWfTHcDoC8UXgTLnW54f07Mzp848+EUY2nDD229620OlmZ
        hIWwBiyqKQnHD2Bcp43Hz3M9k1PldlElUMpOkOQ=
X-Google-Smtp-Source: AGRyM1tmHnrpma4SzfaZ6gk2uMYvRBiSWpvt5ZFPlGkrHylrV6HEGjAs7W0cWpjIgv25VjMNVwpqpRzESwldjrsjtO8=
X-Received: by 2002:a05:6000:10c8:b0:21e:6b86:efe2 with SMTP id
 b8-20020a05600010c800b0021e6b86efe2mr6270503wrx.412.1658709147312; Sun, 24
 Jul 2022 17:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220722030346.28534-1-linkinjeon@kernel.org> <20220722030346.28534-2-linkinjeon@kernel.org>
In-Reply-To: <20220722030346.28534-2-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 25 Jul 2022 09:32:16 +0900
Message-ID: <CANFS6bbmJuXetrcKT_8ZoYUPQHVsF9xxLvFHrbUu=PE8b-z93g@mail.gmail.com>
Subject: Re: [PATCH 2/5] ksmbd: add channel rwlock
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 7=EC=9B=94 22=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 12:04, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Add missing rwlock for channel list in session.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Looks good to me.
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  fs/ksmbd/mgmt/user_session.c |  3 +++
>  fs/ksmbd/mgmt/user_session.h |  1 +
>  fs/ksmbd/smb2pdu.c           | 20 ++++++++++++++++++--
>  3 files changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
> index 3a44e66456fc..25e9ba3b7550 100644
> --- a/fs/ksmbd/mgmt/user_session.c
> +++ b/fs/ksmbd/mgmt/user_session.c
> @@ -32,11 +32,13 @@ static void free_channel_list(struct ksmbd_session *s=
ess)
>  {
>         struct channel *chann, *tmp;
>
> +       write_lock(&sess->chann_lock);
>         list_for_each_entry_safe(chann, tmp, &sess->ksmbd_chann_list,
>                                  chann_list) {
>                 list_del(&chann->chann_list);
>                 kfree(chann);
>         }
> +       write_unlock(&sess->chann_lock);
>  }
>
>  static void __session_rpc_close(struct ksmbd_session *sess,
> @@ -303,6 +305,7 @@ static struct ksmbd_session *__session_create(int pro=
tocol)
>         INIT_LIST_HEAD(&sess->rpc_handle_list);
>         sess->sequence_number =3D 1;
>         atomic_set(&sess->refcnt, 1);
> +       rwlock_init(&sess->chann_lock);
>
>         switch (protocol) {
>         case CIFDS_SESSION_FLAG_SMB2:
> diff --git a/fs/ksmbd/mgmt/user_session.h b/fs/ksmbd/mgmt/user_session.h
> index 8b08189be3fc..1ec659f0151b 100644
> --- a/fs/ksmbd/mgmt/user_session.h
> +++ b/fs/ksmbd/mgmt/user_session.h
> @@ -48,6 +48,7 @@ struct ksmbd_session {
>         char                            sess_key[CIFS_KEY_SIZE];
>
>         struct hlist_node               hlist;
> +       rwlock_t                        chann_lock;
>         struct list_head                ksmbd_chann_list;
>         struct xarray                   tree_conns;
>         struct ida                      tree_conn_ida;
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 04d20a2e6dee..5a0328a070dc 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -1512,7 +1512,9 @@ static int ntlm_authenticate(struct ksmbd_work *wor=
k)
>
>  binding_session:
>         if (conn->dialect >=3D SMB30_PROT_ID) {
> +               read_lock(&sess->chann_lock);
>                 chann =3D lookup_chann_list(sess, conn);
> +               read_unlock(&sess->chann_lock);
>                 if (!chann) {
>                         chann =3D kmalloc(sizeof(struct channel), GFP_KER=
NEL);
>                         if (!chann)
> @@ -1520,7 +1522,9 @@ static int ntlm_authenticate(struct ksmbd_work *wor=
k)
>
>                         chann->conn =3D conn;
>                         INIT_LIST_HEAD(&chann->chann_list);
> +                       write_lock(&sess->chann_lock);
>                         list_add(&chann->chann_list, &sess->ksmbd_chann_l=
ist);
> +                       write_unlock(&sess->chann_lock);
>                 }
>         }
>
> @@ -1594,7 +1598,9 @@ static int krb5_authenticate(struct ksmbd_work *wor=
k)
>         }
>
>         if (conn->dialect >=3D SMB30_PROT_ID) {
> +               read_lock(&sess->chann_lock);
>                 chann =3D lookup_chann_list(sess, conn);
> +               read_unlock(&sess->chann_lock);
>                 if (!chann) {
>                         chann =3D kmalloc(sizeof(struct channel), GFP_KER=
NEL);
>                         if (!chann)
> @@ -1602,7 +1608,9 @@ static int krb5_authenticate(struct ksmbd_work *wor=
k)
>
>                         chann->conn =3D conn;
>                         INIT_LIST_HEAD(&chann->chann_list);
> +                       write_lock(&sess->chann_lock);
>                         list_add(&chann->chann_list, &sess->ksmbd_chann_l=
ist);
> +                       write_unlock(&sess->chann_lock);
>                 }
>         }
>
> @@ -8351,10 +8359,14 @@ int smb3_check_sign_req(struct ksmbd_work *work)
>         if (le16_to_cpu(hdr->Command) =3D=3D SMB2_SESSION_SETUP_HE) {
>                 signing_key =3D work->sess->smb3signingkey;
>         } else {
> +               read_lock(&work->sess->chann_lock);
>                 chann =3D lookup_chann_list(work->sess, conn);
> -               if (!chann)
> +               if (!chann) {
> +                       read_unlock(&work->sess->chann_lock);
>                         return 0;
> +               }
>                 signing_key =3D chann->smb3signingkey;
> +               read_unlock(&work->sess->chann_lock);
>         }
>
>         if (!signing_key) {
> @@ -8414,10 +8426,14 @@ void smb3_set_sign_rsp(struct ksmbd_work *work)
>             le16_to_cpu(hdr->Command) =3D=3D SMB2_SESSION_SETUP_HE) {
>                 signing_key =3D work->sess->smb3signingkey;
>         } else {
> +               read_lock(&work->sess->chann_lock);
>                 chann =3D lookup_chann_list(work->sess, work->conn);
> -               if (!chann)
> +               if (!chann) {
> +                       read_unlock(&work->sess->chann_lock);
>                         return;
> +               }
>                 signing_key =3D chann->smb3signingkey;
> +               read_unlock(&work->sess->chann_lock);
>         }
>
>         if (!signing_key)
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
