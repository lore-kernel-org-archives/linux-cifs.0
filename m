Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4E2C43334
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 06:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiGYGHQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 02:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGYGHQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 02:07:16 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0BEDF4F
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 23:07:13 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id q18so4022463wrx.8
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 23:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+fijV2P3ONsZcy7aDEg7s5qD0MMfvdLHIwoCAzYc+z0=;
        b=IVA3Id+ZJKEnOsweRfU5keJ5VW5bs7rJ6d7mRCRE0kS9K2hJ/TTymsOy4kGQa/LrzK
         W5PUAq0229LboyoVsK4K9ozf8Yoi/VZQ/6a3l9dAjsV1foXA0Z+VuRkrfEQuYJHQiAWY
         o85en++OWGzaLJVZrxbxe3Er63M426YOYuxYk2UFzEJ++zHd/C9ILZrhZlV7gTqfuiiG
         tYWWNVNBGA4sYgfjpfQ6jIjtKho/uGe301Swxmwr0G5iqVel1UfBG/SsmvPaPFaKItKj
         5TlFXX0Ubdw8F26xG+kjzW3/Tk0Qb4ln2rS0ZRiDDTfF+m5QQXq676dku6yYRwR7TEfT
         sbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+fijV2P3ONsZcy7aDEg7s5qD0MMfvdLHIwoCAzYc+z0=;
        b=ZPwkBUXBnEeGnI1O+bgLCLvHR60bcnTrBWkK2cr286lYs3E/kzsXV4bKJx+0vw2Wjg
         ijMCWZqju55woxn6PzkwBb+BOEFt3SFjd3UhTaCakABK2qrjUww0E+3qcKiqzYdbgU29
         BWV2GyIUBPMHIKOdkQp3+qe+mt6xkLDSAvgk7+2qcG/GmZ7LiLjfzDsBIZvX36Y3L4qB
         lNluroMcPhDfbLJIHDQUVO/VUc9FKTdb+hHjc90yvOaBW1XllwaDz0fiIOZgZYVTqjVB
         GAlJy4J6NaiSn4LgypfdyPP0ixapYWrm+48BBXsVFjvyl+NZ4q9djj242bNo5CZRW9m1
         xEFg==
X-Gm-Message-State: AJIora+tuLB76Ft7uXxB2QenqkTUk05XpOiWefoefAqZD0lqZoITnK9F
        dkalpAX6hmMRpzVFuTlk+GgsLiVSxeX+5kSaWiw=
X-Google-Smtp-Source: AGRyM1u1/ONZ35Ue19lj84SVGa07SFsV4PWCt+8mQDSmQYBQ9oQ0imh5Ewl/MVBKfcNPNrawhuPRAANXNOU32JKnVhg=
X-Received: by 2002:a05:6000:10c8:b0:21e:6b86:efe2 with SMTP id
 b8-20020a05600010c800b0021e6b86efe2mr6717988wrx.412.1658729231884; Sun, 24
 Jul 2022 23:07:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAKYAXd8HGh0Bp0JUezSGTxCeDAd__Ops7yQZ8HdB3AXZKT21zQ@mail.gmail.com>
In-Reply-To: <CAKYAXd8HGh0Bp0JUezSGTxCeDAd__Ops7yQZ8HdB3AXZKT21zQ@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 25 Jul 2022 15:07:00 +0900
Message-ID: <CANFS6bat9WmyVOUmpUfpKqgZoUu-yp0FJems0exj9U02L2cG0g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ksmbd: use wait_event instead of schedule_timeout()
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 7=EC=9B=94 25=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 1:42, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> ksmbd threads eating masses of cputime when connection is disconnected.
> If connection is disconnected, ksmbd thread waits for pending requests
> to be processed using schedule_timeout. schedule_timeout() incorrectly
> is used, and it is more efficient to use wait_event/wake_up than to check
> r_count every time with timeout.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  v2:
>    - When r_count is zero, call wake_up event.
>
>  fs/ksmbd/connection.c |  6 +++---
>  fs/ksmbd/connection.h |  1 +
>  fs/ksmbd/oplock.c     | 25 ++++++++++++-------------
>  fs/ksmbd/server.c     |  3 ++-
>  4 files changed, 18 insertions(+), 17 deletions(-)
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
> index 8b5560574d4c..7bd019ea628f 100644
> --- a/fs/ksmbd/oplock.c
> +++ b/fs/ksmbd/oplock.c
> @@ -615,18 +615,13 @@ static void __smb2_oplock_break_noti(struct
> work_struct *wk)
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
> @@ -667,8 +662,11 @@ static void __smb2_oplock_break_noti(struct
> work_struct *wk)
>
>         ksmbd_fd_put(work, fp);
>         ksmbd_conn_write(work);
> +
> +out:
>         ksmbd_free_work_struct(work);
> -       atomic_dec(&conn->r_count);
> +       if (atomic_dec_return(&conn->r_count) =3D=3D 0)
> +               wake_up_all(&conn->r_count_q);
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
> -       atomic_dec(&conn->r_count);
> +       if (atomic_dec_return(&conn->r_count) =3D=3D 0)
> +               wake_up_all(&conn->r_count_q);
>  }
>
>  /**
> diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
> index 4cd03d661df0..4a122412eff8 100644
> --- a/fs/ksmbd/server.c
> +++ b/fs/ksmbd/server.c
> @@ -261,7 +261,8 @@ static void handle_ksmbd_work(struct work_struct *wk)
>
>         ksmbd_conn_try_dequeue_request(work);
>         ksmbd_free_work_struct(work);
> -       atomic_dec(&conn->r_count);
> +       if (atomic_dec_return(&conn->r_count) =3D=3D 0)
> +               wake_up_all(&conn->r_count_q);
>  }
>
>  /**
> --
> 2.34.1



--=20
Thanks,
Hyunchul
