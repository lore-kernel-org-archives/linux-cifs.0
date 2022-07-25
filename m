Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315C4C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 00:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiGYAlt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 20:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGYAls (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 20:41:48 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C384E0E9
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 17:41:47 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id z13so13851219wro.13
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 17:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k+9+lGriYHqIVlMddrk+2kqAiZSwWAJesSotd8aOk94=;
        b=VIR/Xv+PY5fd/29sNORJplztzIgV0HXQ/J166TlNxz3u/Ab+K7AOOwkvz5DgQJv1Yt
         JfvuZJ8Zsgjer7gVu0+2HmmQGUMdt5xrnhaOJA/oBehPt8RUhVBc0G9SD5xlyD+4h3HB
         dGfQbhvYoSL6tDzAPdpAAsIO29LWQQluW3DD2fyd6wDm4dfNmEGt5teHuhbiLHQUYkWd
         XIbj3nSBSD9GvvjgE3mzEsphvHKtm1ypq4tl6l0KZkg6fe4AWiNOFfd2oOc6QJcUD4sq
         KPSp4UL8S/NMrsl3TqZB8L4G9jT+R5fFvijokwNOJ++Z3ayOO5Z6osj2cva7TKRTGl8q
         MK8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k+9+lGriYHqIVlMddrk+2kqAiZSwWAJesSotd8aOk94=;
        b=xHBQqcS8yQqZgl6usCEc/03fyCOUucjrtdjke+/uKHaQ3N24VJ7O/51UivCsBSRjmL
         ivjwh457dC5PGDAyDv50rN8kNEXEg3iR7BAtVv2YMEpYklPRAawUxJ0MQffUvNjlSGlw
         18O9S9mvwijgmCicox2XGsPQVr7qY1PdBunrweL2idQJuxVxxc/pwwoDVtHkfvksereh
         SUWQFwJEuq3dC8rwwbFOjzo01x31vnYtpeljzeU1O1LlrJseOr2OuNdCjadvOB5I86Ww
         e8uv852cAKVhD+YEaTLOIKx3adT8nok3ApTkRTKr2sOZFtakkHO0pNdgJmMsr27hVM9E
         Y+9g==
X-Gm-Message-State: AJIora/SL0fsWn7Usc6OHSKDYp2MAyYnigodZHdOsYVBbsHaJyNbw3En
        v+jzjMYvHoOGwsupwDkunPEkqkNdmhivPhnMhyA=
X-Google-Smtp-Source: AGRyM1uLEPJN+NxwpTRwc/Uv41v5FTwgWVn0UO4Vqzp694qV8nrZ5KWTe5QeCZubWhZdeMVJ9HcM5BuK+YrVTV+c6a0=
X-Received: by 2002:a05:6000:1acd:b0:21e:7e8f:a714 with SMTP id
 i13-20020a0560001acd00b0021e7e8fa714mr4278597wry.322.1658709705550; Sun, 24
 Jul 2022 17:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220722030346.28534-1-linkinjeon@kernel.org> <20220722030346.28534-3-linkinjeon@kernel.org>
In-Reply-To: <20220722030346.28534-3-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 25 Jul 2022 09:41:34 +0900
Message-ID: <CANFS6banPFXPkoYdxO=wc9t3tT_A82BHFFbXMhDwD=+-5kabDA@mail.gmail.com>
Subject: Re: [PATCH 3/5] ksmbd: fix kernel oops from idr_remove()
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
> There is a report that kernel oops happen from idr_remove().
>
> kernel: BUG: kernel NULL pointer dereference, address: 0000000000000010
> kernel: RIP: 0010:idr_remove+0x1/0x20
> kernel:  __ksmbd_close_fd+0xb2/0x2d0 [ksmbd]
> kernel:  ksmbd_vfs_read+0x91/0x190 [ksmbd]
> kernel:  ksmbd_fd_put+0x29/0x40 [ksmbd]
> kernel:  smb2_read+0x210/0x390 [ksmbd]
> kernel:  __process_request+0xa4/0x180 [ksmbd]
> kernel:  __handle_ksmbd_work+0xf0/0x290 [ksmbd]
> kernel:  handle_ksmbd_work+0x2d/0x50 [ksmbd]
> kernel:  process_one_work+0x21d/0x3f0
> kernel:  worker_thread+0x50/0x3d0
> kernel:  rescuer_thread+0x390/0x390
> kernel:  kthread+0xee/0x120
> kthread_complete_and_exit+0x20/0x20
> kernel:  ret_from_fork+0x22/0x30
>
> While accessing files, If connection is disconnected, windows send
> session setup request included previous session destroy. But while still
> processing requests on previous session, this request destroy file
> table, which mean file table idr will be freed and set to NULL.
> So kernel oops happen from ft->idr in __ksmbd_close_fd().
> This patch don't directly destroy session in destroy_previous_session().
> It just set to KSMBD_SESS_EXITING so that connection will be
> terminated after finishing the rest of requests.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Looks good to me.
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  fs/ksmbd/mgmt/user_session.c | 2 ++
>  fs/ksmbd/smb2pdu.c           | 8 ++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
> index 25e9ba3b7550..b9acb6770b03 100644
> --- a/fs/ksmbd/mgmt/user_session.c
> +++ b/fs/ksmbd/mgmt/user_session.c
> @@ -239,6 +239,8 @@ struct ksmbd_session *ksmbd_session_lookup_all(struct=
 ksmbd_conn *conn,
>         sess =3D ksmbd_session_lookup(conn, id);
>         if (!sess && conn->binding)
>                 sess =3D ksmbd_session_lookup_slowpath(id);
> +       if (sess && sess->state !=3D SMB2_SESSION_VALID)
> +               sess =3D NULL;
>         return sess;
>  }
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 5a0328a070dc..ae5677a66cb2 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -593,6 +593,7 @@ static void destroy_previous_session(struct ksmbd_con=
n *conn,
>  {
>         struct ksmbd_session *prev_sess =3D ksmbd_session_lookup_slowpath=
(id);
>         struct ksmbd_user *prev_user;
> +       struct channel *chann;
>
>         if (!prev_sess)
>                 return;
> @@ -608,8 +609,11 @@ static void destroy_previous_session(struct ksmbd_co=
nn *conn,
>         }
>
>         put_session(prev_sess);
> -       xa_erase(&conn->sessions, prev_sess->id);
> -       ksmbd_session_destroy(prev_sess);
> +       prev_sess->state =3D SMB2_SESSION_EXPIRED;
> +       write_lock(&prev_sess->chann_lock);
> +       list_for_each_entry(chann, &prev_sess->ksmbd_chann_list, chann_li=
st)
> +               chann->conn->status =3D KSMBD_SESS_EXITING;
> +       write_unlock(&prev_sess->chann_lock);
>  }
>
>  /**
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
