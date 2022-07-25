Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659E3C43334
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 00:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiGYA2p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 20:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGYA2o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 20:28:44 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B49D11A1E
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 17:28:43 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u5so13849595wrm.4
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 17:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CvBmx26diULPj/qtJM0Rph0l1aKTDQQfOOpzSz3V9yk=;
        b=UB7Av5ihUjvt1UibC3+3EHvdJ8wfjk3h8yzYXTtATeyRjvcodurARvTJIqlcIowgpu
         AW2GVuD0WeUVaj9Rgzs/MB43PEB92uyTLc1AIkL1jy6I9R7E4JeIUNBk1DotFNaQzFUt
         b1rsb+fjHkedNodvg4vFEEdD5JiqM6y588rZAG5cwddAS9reN+t6p0of8SnZvY24WiGv
         aPM5nPnVD1CtmuLNrZm83lH0inzDdXUEJi5fAPnLPAXlzIjafEh6Uv5Ke/eD6zDFybBi
         cPCdeSI5UX1WMdeFkpvHudj+CNJqLpTQVXwuiN9U/rCzAJdzb0uLZmfC66EBKV7o9ck/
         Dw1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CvBmx26diULPj/qtJM0Rph0l1aKTDQQfOOpzSz3V9yk=;
        b=1UVI7X4Ec4R2ClFhuGMI6EyOslfKOeK4rNfJf9iarsoNuYL6DKeeyBeDBBU2pBQzew
         YPnDxWsMGbnUa3zzc/O6vIXJ6KOoqegLj9ROPuOy/yVW40modoRL7IB3jwJHa96swPtw
         Le4s5di/eBbgKXkEbpFGGxAGPj8/9U1FXbNefJM+m63aTXBapl6z2ut3wbGkZd6NxUzt
         rf6j8tqnga8BZ/ig5VNq+7Id+kU0HbPk7A9eF/tfsgCB3sD1EMZdwrZtVi7benT0P3z3
         Jhu+5S+ox4uRfVxM4l5xvplhHu8QV5E0/u6z+p3hu5KHX+YhQlXMUgnkmpmtmQHMWDNe
         h8bw==
X-Gm-Message-State: AJIora/oLvxbLp5XoFXoUHMn4YGoleHPhPp5jAFqgdqXfJFZ6JlzLNw4
        b0Im2o3IIUiKTcF63kkn+3Qamr3zTXBURFtsPrY=
X-Google-Smtp-Source: AGRyM1tE3sY77ZSpUPPgLeXkjmv/nrpR4zNk6wSHnJ95OKGyfs+jS78c19A9Oceb7TtIQ1KNzZi8QVtKNO4zki3gl9A=
X-Received: by 2002:a05:6000:1f0d:b0:21e:927e:d440 with SMTP id
 bv13-20020a0560001f0d00b0021e927ed440mr50077wrb.621.1658708921980; Sun, 24
 Jul 2022 17:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220722030346.28534-1-linkinjeon@kernel.org>
In-Reply-To: <20220722030346.28534-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 25 Jul 2022 09:28:30 +0900
Message-ID: <CANFS6ba3TbQ2mDcMj6zyE2fR2Rnd-gj+9TfKTH1EOU2QFJ9GFg@mail.gmail.com>
Subject: Re: [PATCH 1/5] ksmbd: replace sessions list in connection with xarray
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Namjae,

2022=EB=85=84 7=EC=9B=94 22=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 12:04, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Replace sessions list in connection with xarray.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Looks good to me.
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  fs/ksmbd/connection.c        |  3 ++-
>  fs/ksmbd/connection.h        |  2 +-
>  fs/ksmbd/mgmt/user_session.c | 31 +++++++------------------------
>  fs/ksmbd/mgmt/user_session.h |  5 ++---
>  fs/ksmbd/smb2pdu.c           | 13 +++++++++----
>  5 files changed, 21 insertions(+), 33 deletions(-)
>
> diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
> index e8f476c5f189..ce23cc89046e 100644
> --- a/fs/ksmbd/connection.c
> +++ b/fs/ksmbd/connection.c
> @@ -36,6 +36,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
>         list_del(&conn->conns_list);
>         write_unlock(&conn_list_lock);
>
> +       xa_destroy(&conn->sessions);
>         kvfree(conn->request_buf);
>         kfree(conn->preauth_info);
>         kfree(conn);
> @@ -66,12 +67,12 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
>
>         init_waitqueue_head(&conn->req_running_q);
>         INIT_LIST_HEAD(&conn->conns_list);
> -       INIT_LIST_HEAD(&conn->sessions);
>         INIT_LIST_HEAD(&conn->requests);
>         INIT_LIST_HEAD(&conn->async_requests);
>         spin_lock_init(&conn->request_lock);
>         spin_lock_init(&conn->credits_lock);
>         ida_init(&conn->async_ida);
> +       xa_init(&conn->sessions);
>
>         spin_lock_init(&conn->llist_lock);
>         INIT_LIST_HEAD(&conn->lock_list);
> diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
> index 98c1cbe45ec9..5b39f0bdeff8 100644
> --- a/fs/ksmbd/connection.h
> +++ b/fs/ksmbd/connection.h
> @@ -55,7 +55,7 @@ struct ksmbd_conn {
>         struct nls_table                *local_nls;
>         struct list_head                conns_list;
>         /* smb session 1 per user */
> -       struct list_head                sessions;
> +       struct xarray                   sessions;
>         unsigned long                   last_active;
>         /* How many request are running currently */
>         atomic_t                        req_running;
> diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
> index 8d8ffd8c6f19..3a44e66456fc 100644
> --- a/fs/ksmbd/mgmt/user_session.c
> +++ b/fs/ksmbd/mgmt/user_session.c
> @@ -152,8 +152,6 @@ void ksmbd_session_destroy(struct ksmbd_session *sess=
)
>         if (!atomic_dec_and_test(&sess->refcnt))
>                 return;
>
> -       list_del(&sess->sessions_entry);
> -
>         down_write(&sessions_table_lock);
>         hash_del(&sess->hlist);
>         up_write(&sessions_table_lock);
> @@ -181,42 +179,28 @@ static struct ksmbd_session *__session_lookup(unsig=
ned long long id)
>         return NULL;
>  }
>
> -void ksmbd_session_register(struct ksmbd_conn *conn,
> -                           struct ksmbd_session *sess)
> +int ksmbd_session_register(struct ksmbd_conn *conn,
> +                          struct ksmbd_session *sess)
>  {
>         sess->conn =3D conn;
> -       list_add(&sess->sessions_entry, &conn->sessions);
> +       return xa_err(xa_store(&conn->sessions, sess->id, sess, GFP_KERNE=
L));
>  }
>
>  void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
>  {
>         struct ksmbd_session *sess;
> +       unsigned long id;
>
> -       while (!list_empty(&conn->sessions)) {
> -               sess =3D list_entry(conn->sessions.next,
> -                                 struct ksmbd_session,
> -                                 sessions_entry);
> -
> +       xa_for_each(&conn->sessions, id, sess) {
> +               xa_erase(&conn->sessions, sess->id);
>                 ksmbd_session_destroy(sess);
>         }
>  }
>
> -static bool ksmbd_session_id_match(struct ksmbd_session *sess,
> -                                  unsigned long long id)
> -{
> -       return sess->id =3D=3D id;
> -}
> -
>  struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,
>                                            unsigned long long id)
>  {
> -       struct ksmbd_session *sess =3D NULL;
> -
> -       list_for_each_entry(sess, &conn->sessions, sessions_entry) {
> -               if (ksmbd_session_id_match(sess, id))
> -                       return sess;
> -       }
> -       return NULL;
> +       return xa_load(&conn->sessions, id);
>  }
>
>  int get_session(struct ksmbd_session *sess)
> @@ -314,7 +298,6 @@ static struct ksmbd_session *__session_create(int pro=
tocol)
>                 goto error;
>
>         set_session_flag(sess, protocol);
> -       INIT_LIST_HEAD(&sess->sessions_entry);
>         xa_init(&sess->tree_conns);
>         INIT_LIST_HEAD(&sess->ksmbd_chann_list);
>         INIT_LIST_HEAD(&sess->rpc_handle_list);
> diff --git a/fs/ksmbd/mgmt/user_session.h b/fs/ksmbd/mgmt/user_session.h
> index e241f16a3851..8b08189be3fc 100644
> --- a/fs/ksmbd/mgmt/user_session.h
> +++ b/fs/ksmbd/mgmt/user_session.h
> @@ -57,7 +57,6 @@ struct ksmbd_session {
>         __u8                            smb3decryptionkey[SMB3_ENC_DEC_KE=
Y_SIZE];
>         __u8                            smb3signingkey[SMB3_SIGN_KEY_SIZE=
];
>
> -       struct list_head                sessions_entry;
>         struct ksmbd_file_table         file_table;
>         atomic_t                        refcnt;
>  };
> @@ -84,8 +83,8 @@ void ksmbd_session_destroy(struct ksmbd_session *sess);
>  struct ksmbd_session *ksmbd_session_lookup_slowpath(unsigned long long i=
d);
>  struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,
>                                            unsigned long long id);
> -void ksmbd_session_register(struct ksmbd_conn *conn,
> -                           struct ksmbd_session *sess);
> +int ksmbd_session_register(struct ksmbd_conn *conn,
> +                          struct ksmbd_session *sess);
>  void ksmbd_sessions_deregister(struct ksmbd_conn *conn);
>  struct ksmbd_session *ksmbd_session_lookup_all(struct ksmbd_conn *conn,
>                                                unsigned long long id);
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 94ab1dcd80e7..04d20a2e6dee 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -588,7 +588,8 @@ int smb2_check_user_session(struct ksmbd_work *work)
>         return -EINVAL;
>  }
>
> -static void destroy_previous_session(struct ksmbd_user *user, u64 id)
> +static void destroy_previous_session(struct ksmbd_conn *conn,
> +                                    struct ksmbd_user *user, u64 id)
>  {
>         struct ksmbd_session *prev_sess =3D ksmbd_session_lookup_slowpath=
(id);
>         struct ksmbd_user *prev_user;
> @@ -607,6 +608,7 @@ static void destroy_previous_session(struct ksmbd_use=
r *user, u64 id)
>         }
>
>         put_session(prev_sess);
> +       xa_erase(&conn->sessions, prev_sess->id);
>         ksmbd_session_destroy(prev_sess);
>  }
>
> @@ -1439,7 +1441,7 @@ static int ntlm_authenticate(struct ksmbd_work *wor=
k)
>         /* Check for previous session */
>         prev_id =3D le64_to_cpu(req->PreviousSessionId);
>         if (prev_id && prev_id !=3D sess->id)
> -               destroy_previous_session(user, prev_id);
> +               destroy_previous_session(conn, user, prev_id);
>
>         if (sess->state =3D=3D SMB2_SESSION_VALID) {
>                 /*
> @@ -1561,7 +1563,7 @@ static int krb5_authenticate(struct ksmbd_work *wor=
k)
>         /* Check previous session */
>         prev_sess_id =3D le64_to_cpu(req->PreviousSessionId);
>         if (prev_sess_id && prev_sess_id !=3D sess->id)
> -               destroy_previous_session(sess->user, prev_sess_id);
> +               destroy_previous_session(conn, sess->user, prev_sess_id);
>
>         if (sess->state =3D=3D SMB2_SESSION_VALID)
>                 ksmbd_free_user(sess->user);
> @@ -1650,7 +1652,9 @@ int smb2_sess_setup(struct ksmbd_work *work)
>                         goto out_err;
>                 }
>                 rsp->hdr.SessionId =3D cpu_to_le64(sess->id);
> -               ksmbd_session_register(conn, sess);
> +               rc =3D ksmbd_session_register(conn, sess);
> +               if (rc)
> +                       goto out_err;
>         } else if (conn->dialect >=3D SMB30_PROT_ID &&
>                    (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANN=
EL) &&
>                    req->Flags & SMB2_SESSION_REQ_FLAG_BINDING) {
> @@ -1828,6 +1832,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
>                         if (sess->user && sess->user->flags & KSMBD_USER_=
FLAG_DELAY_SESSION)
>                                 try_delay =3D true;
>
> +                       xa_erase(&conn->sessions, sess->id);
>                         ksmbd_session_destroy(sess);
>                         work->sess =3D NULL;
>                         if (try_delay)
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
