Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B9DC43334
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 00:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiGYAsp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 20:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiGYAso (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 20:48:44 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD3C101C6
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 17:48:43 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id q18so3443713wrx.8
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 17:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VnmapGNmfIESulbB2k3WvOM3i/E5LJDa5yWnT92++nY=;
        b=T7W4tjpr3IrnmcustrU7+hWD/sjsbYMsg9jOyKi1WArWrfov6APnU25YbYrw5OsBAs
         /wFVsn8x1WB7lI/t4u9dYNPiEzYASjR5uQsqCEAGa+u4SQJhpA8wJpOlaf18pOk+JAcv
         oq6Q8Avnr8i6iNF15BsL8RjAWmjsgvZzmrSTbPp4bG46Oz5UxpSpByuLw1f0yh9F6MCb
         x/+n1fMivtPHivzKsQsKqFn7wfaWAKBuOxvgWRAeF8Tj1oJn4WD4JNqRYPmJtgM0rPUV
         A3QpxiH/32oPF4XH95+AUvBfc6JYWLl/hIchIE7rTVhUv7Z0R0HHUPFoMWCiJuBqq3th
         DZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VnmapGNmfIESulbB2k3WvOM3i/E5LJDa5yWnT92++nY=;
        b=WshulAIKEyTNCS5RxSLaTXyeSzUxW4FFgF7az0B6zIHBjMY4VyQddw2u5ddTJj12kN
         jugwPQorHtxT7VMFfBayARfMGRQhlTr5EAlyT5H5W9u7DrPyc0d9cUQ7ekRoLxWYJgZq
         v/8vbiJqWUXT9fERFdlmCRnl8i2SFfpjkUHitWeJEK3s8HlEVAI3hRmnnttmdr6t8wpo
         69Mvt8blJRcKuAGUKcrxqUinT6IAZ/ul8gW+NGLSNsBNATVm1e3nDuG+ePb+3Yw+/mLF
         AYzkYWNPZCmYjzMoXtMsOW3KNscSQ/zoYVOrV4qsi1YjDHDTli9M/LGMa04CtPN5j+h2
         loaQ==
X-Gm-Message-State: AJIora8LKi2uF8zwSx37Tet9HZY6VLunoD+McPzaAJJ/qiGzMIic1vYC
        uROwTLwLsY5DR1vQzgXISAw0bdGgRjskTfo5GDA=
X-Google-Smtp-Source: AGRyM1txagRyw5rdBHiXoeZ+lxunR8a1tJbZNpHo8cwf+3+OImwCgLwMzbKNidCPaJAMrrid+kmtOFGCSycccLZrHSo=
X-Received: by 2002:a5d:4651:0:b0:21e:3988:4744 with SMTP id
 j17-20020a5d4651000000b0021e39884744mr6063621wrs.136.1658710122006; Sun, 24
 Jul 2022 17:48:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220722030346.28534-1-linkinjeon@kernel.org> <20220722030346.28534-4-linkinjeon@kernel.org>
In-Reply-To: <20220722030346.28534-4-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 25 Jul 2022 09:48:30 +0900
Message-ID: <CANFS6bYcMqWuKJd0aiDSWnj5kXd9viCgZzRLLukKzh8p1yWu+Q@mail.gmail.com>
Subject: Re: [PATCH 4/5] ksmbd: use wait_event instead of schedule_timeout()
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
> ksmbd threads eating masses of cputime when connection is disconnected.
> If connection is disconnected, ksmbd thread waits for pending requests
> to be processed using schedule_timeout. schedule_timeout() incorrectly
> is used, and it is more efficient to use wait_event/wake_up than to check
> r_count every time with timeout.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/connection.c |  6 +++---
>  fs/ksmbd/connection.h |  1 +
>  fs/ksmbd/oplock.c     | 21 ++++++++++-----------
>  fs/ksmbd/server.c     |  1 +
>  4 files changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
> index ce23cc89046e..756ad631c019 100644
> --- a/fs/ksmbd/connection.c
> +++ b/fs/ksmbd/connection.c
> @@ -66,6 +66,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
>         conn->outstanding_credits =3D 0;
>
>         init_waitqueue_head(&conn->req_running_q);
> +       init_waitqueue_head(&conn->r_count_q);
>         INIT_LIST_HEAD(&conn->conns_list);
>         INIT_LIST_HEAD(&conn->requests);
>         INIT_LIST_HEAD(&conn->async_requests);
> @@ -165,7 +166,6 @@ int ksmbd_conn_write(struct ksmbd_work *work)
>         struct kvec iov[3];
>         int iov_idx =3D 0;
>
> -       ksmbd_conn_try_dequeue_request(work);
>         if (!work->response_buf) {
>                 pr_err("NULL response header\n");
>                 return -EINVAL;
> @@ -347,8 +347,8 @@ int ksmbd_conn_handler_loop(void *p)
>
>  out:
>         /* Wait till all reference dropped to the Server object*/
> -       while (atomic_read(&conn->r_count) > 0)
> -               schedule_timeout(HZ);
> +       wait_event(conn->r_count_q, atomic_read(&conn->r_count) =3D=3D 0)=
;
> +
>
>         unload_nls(conn->local_nls);
>         if (default_conn_ops.terminate_fn)
> diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
> index 5b39f0bdeff8..2e4730457c92 100644
> --- a/fs/ksmbd/connection.h
> +++ b/fs/ksmbd/connection.h
> @@ -65,6 +65,7 @@ struct ksmbd_conn {
>         unsigned int                    outstanding_credits;
>         spinlock_t                      credits_lock;
>         wait_queue_head_t               req_running_q;
> +       wait_queue_head_t               r_count_q;
>         /* Lock to protect requests list*/
>         spinlock_t                      request_lock;
>         struct list_head                requests;
> diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
> index 8b5560574d4c..9bb4fb8b80de 100644
> --- a/fs/ksmbd/oplock.c
> +++ b/fs/ksmbd/oplock.c
> @@ -615,18 +615,13 @@ static void __smb2_oplock_break_noti(struct work_st=
ruct *wk)
>         struct ksmbd_file *fp;
>
>         fp =3D ksmbd_lookup_durable_fd(br_info->fid);
> -       if (!fp) {
> -               atomic_dec(&conn->r_count);
> -               ksmbd_free_work_struct(work);
> -               return;
> -       }
> +       if (!fp)
> +               goto out;
>
>         if (allocate_oplock_break_buf(work)) {
>                 pr_err("smb2_allocate_rsp_buf failed! ");
> -               atomic_dec(&conn->r_count);
>                 ksmbd_fd_put(work, fp);
> -               ksmbd_free_work_struct(work);
> -               return;
> +               goto out;
>         }
>
>         rsp_hdr =3D smb2_get_msg(work->response_buf);
> @@ -667,8 +662,11 @@ static void __smb2_oplock_break_noti(struct work_str=
uct *wk)
>
>         ksmbd_fd_put(work, fp);
>         ksmbd_conn_write(work);
> +
> +out:
>         ksmbd_free_work_struct(work);
>         atomic_dec(&conn->r_count);
> +       wake_up_all(&conn->r_count_q);

I think calling wake_up_all is better if atomic_dec_return(&conn->r_count) =
=3D=3D 0.
Otherwise, Looks good to me.

>  }
>
>  /**
> @@ -731,9 +729,7 @@ static void __smb2_lease_break_noti(struct work_struc=
t *wk)
>
>         if (allocate_oplock_break_buf(work)) {
>                 ksmbd_debug(OPLOCK, "smb2_allocate_rsp_buf failed! ");
> -               ksmbd_free_work_struct(work);
> -               atomic_dec(&conn->r_count);
> -               return;
> +               goto out;
>         }
>
>         rsp_hdr =3D smb2_get_msg(work->response_buf);
> @@ -771,8 +767,11 @@ static void __smb2_lease_break_noti(struct work_stru=
ct *wk)
>         inc_rfc1001_len(work->response_buf, 44);
>
>         ksmbd_conn_write(work);
> +
> +out:
>         ksmbd_free_work_struct(work);
>         atomic_dec(&conn->r_count);
> +       wake_up_all(&conn->r_count_q);
>  }
>
>  /**
> diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
> index 4cd03d661df0..dfddc8dc1919 100644
> --- a/fs/ksmbd/server.c
> +++ b/fs/ksmbd/server.c
> @@ -262,6 +262,7 @@ static void handle_ksmbd_work(struct work_struct *wk)
>         ksmbd_conn_try_dequeue_request(work);
>         ksmbd_free_work_struct(work);
>         atomic_dec(&conn->r_count);
> +       wake_up_all(&conn->r_count_q);
>  }
>
>  /**
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
