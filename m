Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8676D3451CD;
	Tue, 19 Aug 2025 08:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755590417; cv=none; b=AbjDAa3kIarGW27x+NDng1Mbr9AZLBfH42n0c+eoHs14gIUlxaCSMtz0M9FQSrl9M9wxH0F+jh5vLccF0DPbKAwyI8Xme9AeWqGncharu9q9Tdm0+VyDpRTXtz8V0j5RV8nB1ahEjHArAdwY7TSEa+2Gmrk/H75ZDfvku0hRsqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755590417; c=relaxed/simple;
	bh=tmc3N1nD1K1xMBNw5cScsvqY8FA1XStzHAdcTAMUWwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h2RYW01GBtCqU8FQAyl1JG+a5lm01EpBpO7ldfepz7QIsIW2OaCSO5Kc6Q84v8AhyRwlrcebUKPSPLu5iC2D87FJJ2aFdoPtAVA3bci/V+qCqZU0JMUL1T5FIxI1riq6L+hV72CE8YqHJerrgE55pJEu029RGkjPcofRmTdAfSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TDzEvhn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TDzEvhn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2492DC19423;
	Tue, 19 Aug 2025 08:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755590417;
	bh=tmc3N1nD1K1xMBNw5cScsvqY8FA1XStzHAdcTAMUWwU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TDzEvhn9w129Bk1K2/599fYjPtuu7/Vr+nqK7rCgst2FvdTo5AvyKuuvDGb6J/lHv
	 WQd1BWLRWyY1naSkQwhJoAVBXqcFLi9i77rQZW6ApWCmnatW+G3jDNhZj26sOid6Xp
	 x3EGXhDWQyERHOBjgY7pFWHm4v9stMTU+ig8IbdIG/AyRj2VOm0GBP7jDuqOUfp++l
	 nNAL4YSzCcU/juHWh70HlyiW1v6HtLVB8jIqvJLEnbbPon09vmPViG5d549nmWQAKF
	 ga0B+OrcFCIzGyf714r4ZVZVme2pupL0Sn2JIviRXJ2rWF7RAJ6bvE3B7jBvUVtOwg
	 QhYIOQRzY6Umw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb7ae31caso889259566b.3;
        Tue, 19 Aug 2025 01:00:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXI4paF5/Cz3aowvS8zcbcCYni8fePEK/5MOdGeiLWr0hAK3a+krwx46X3Any837tIiRUNcUQE/Bx2mim6H@vger.kernel.org, AJvYcCXLqb5NNMJZ2YeDS9YsexlOz5lG7mT1Yo8NiWiqI/KC1INoZljtkfxE0B4fqYB1Pj6mKeuIvJ5xv5kp@vger.kernel.org
X-Gm-Message-State: AOJu0YySh26dx92YOJfRb6PFn7UmupR6N9y0vEEJz0PpxvXjbTXzYjjT
	djoH3wNs1O7Gr+xxdVvanHbzy77Y0bC3aNKdvcNplbQE1+JWCWEdYElEWnWnZ1UwzmXkeom4dcA
	Hs4zCVCUKt9okeUi398r1UsUOA4atOPI=
X-Google-Smtp-Source: AGHT+IHArXvGj+Ci5nhs1OVnJgbgZb4wKUqrrHL+0qqkNF7bbarfoDEI/LiSAx0MJQn6bCoIras0ivyA8UgHEpeIKeg=
X-Received: by 2002:a17:907:3f07:b0:ae0:66e8:9ddb with SMTP id
 a640c23a62f3a-afddcbc241amr151884266b.19.1755590415511; Tue, 19 Aug 2025
 01:00:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806143955.122816-2-ysk@kzalloc.com>
In-Reply-To: <20250806143955.122816-2-ysk@kzalloc.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 19 Aug 2025 17:00:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-7ojpN=jc+R2wwxyQsZCTBJT6tEYszb4VOgbPeWn1NKA@mail.gmail.com>
X-Gm-Features: Ac12FXzKNX4ih0NnnSVYjLX5TrEIPXLQcAFOEVNQvlAyBPLacLhiPlH3HBC0KlU
Message-ID: <CAKYAXd-7ojpN=jc+R2wwxyQsZCTBJT6tEYszb4VOgbPeWn1NKA@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: add kcov remote coverage support via ksmbd_conn
To: Yunseong Kim <ysk@kzalloc.com>
Cc: Steve French <smfrench@gmail.com>, Stefan Metzmacher <metze@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	linux-cifs@vger.kernel.org, syzkaller@googlegroups.com, 
	linux-kernel@vger.kernel.org, notselwyn@pwning.tech
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 6, 2025 at 11:41=E2=80=AFPM Yunseong Kim <ysk@kzalloc.com> wrot=
e:
>
Hi Yunseong,
> KSMBD processes SMB requests on per-connection threads and then hands
> off work items to a kworker pool for actual command processing by
> handle_ksmbd_work(). Because each connection may enqueue multiple
> struct ksmbd_work instances, attaching the kcov handle to the work
> itself is not sufficient: we need a stable, per-connection handle.
>
> Introduce a kcov_handle field on struct ksmbd_conn (under CONFIG_KCOV)
> and initialize it when the connection is set up. In both
> ksmbd_conn_handler_loop() which only receives a struct ksmbd_conn*
> and handle_ksmbd_work() which receives a struct ksmbd_work*, start
> kcov_remote with the per-connection handle before processing and stop
> it afterward. This ensures coverage collection remains active across
> the entire asynchronous path of each SMB request.
I'm a bit unclear on the overall impact. Do you have the goal to measure
the code coverage of all ksmbd components ?
Is there the next patch set or any plan for next work, or is this patch eno=
ugh
to check all functions of ksmbd with syzkaller?

Thanks.
>
> The kcov context tied to the connection itself, correctly supporting
> multiple outstanding work items per connection.
>
> In patch v2, I added the missing initialization of kcov_handle. In v3,
> I fixed an kcov_hanlde argument was previously unused on
> ksmbd_conn_set_kcov_handle().
>
> The related work for syzkaller support is currently being developed
> in the following GitHub PR:
> Link: https://github.com/google/syzkaller/pull/5524
>
> Based on earlier work by Lau.
> Link: https://pwning.tech/ksmbd-syzkaller/
>
> Cc: linux-cifs@vger.kernel.org
> Cc: notselwyn@pwning.tech
> Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
> ---
>  fs/smb/server/connection.c |  7 ++++++-
>  fs/smb/server/connection.h | 22 ++++++++++++++++++++++
>  fs/smb/server/server.c     |  4 ++++
>  3 files changed, 32 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
> index 3f04a2977ba8..21352f37384f 100644
> --- a/fs/smb/server/connection.c
> +++ b/fs/smb/server/connection.c
> @@ -93,6 +93,9 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
>         down_write(&conn_list_lock);
>         list_add(&conn->conns_list, &conn_list);
>         up_write(&conn_list_lock);
> +
> +       ksmbd_conn_set_kcov_handle(conn, kcov_common_handle());
> +
>         return conn;
>  }
>
> @@ -322,6 +325,8 @@ int ksmbd_conn_handler_loop(void *p)
>         if (t->ops->prepare && t->ops->prepare(t))
>                 goto out;
>
> +       kcov_remote_start_common(ksmbd_conn_get_kcov_handle(conn));
> +
>         max_req =3D server_conf.max_inflight_req;
>         conn->last_active =3D jiffies;
>         set_freezable();
> @@ -412,7 +417,7 @@ int ksmbd_conn_handler_loop(void *p)
>                         break;
>                 }
>         }
> -
> +       kcov_remote_stop();
>  out:
>         ksmbd_conn_set_releasing(conn);
>         /* Wait till all reference dropped to the Server object*/
> diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
> index dd3e0e3f7bf0..a90bd1b3e1df 100644
> --- a/fs/smb/server/connection.h
> +++ b/fs/smb/server/connection.h
> @@ -15,6 +15,7 @@
>  #include <linux/kthread.h>
>  #include <linux/nls.h>
>  #include <linux/unicode.h>
> +#include <linux/kcov.h>
>
>  #include "smb_common.h"
>  #include "ksmbd_work.h"
> @@ -109,6 +110,9 @@ struct ksmbd_conn {
>         bool                            binding;
>         atomic_t                        refcnt;
>         bool                            is_aapl;
> +#ifdef CONFIG_KCOV
> +       u64                             kcov_handle;
> +#endif
>  };
>
>  struct ksmbd_conn_ops {
> @@ -246,4 +250,22 @@ static inline void ksmbd_conn_set_releasing(struct k=
smbd_conn *conn)
>  }
>
>  void ksmbd_all_conn_set_status(u64 sess_id, u32 status);
> +
> +static inline void ksmbd_conn_set_kcov_handle(struct ksmbd_conn *conn,
> +                                      const u64 kcov_handle)
> +{
> +#ifdef CONFIG_KCOV
> +       conn->kcov_handle =3D kcov_handle;
> +#endif
> +}
> +
> +static inline u64 ksmbd_conn_get_kcov_handle(struct ksmbd_conn *conn)
> +{
> +#ifdef CONFIG_KCOV
> +       return conn->kcov_handle;
> +#else
> +       return 0;
> +#endif
> +}
> +
>  #endif /* __CONNECTION_H__ */
> diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
> index 8c9c49c3a0a4..0757cd6ef4f7 100644
> --- a/fs/smb/server/server.c
> +++ b/fs/smb/server/server.c
> @@ -264,6 +264,8 @@ static void handle_ksmbd_work(struct work_struct *wk)
>         struct ksmbd_work *work =3D container_of(wk, struct ksmbd_work, w=
ork);
>         struct ksmbd_conn *conn =3D work->conn;
>
> +       kcov_remote_start_common(ksmbd_conn_get_kcov_handle(conn));
> +
>         atomic64_inc(&conn->stats.request_served);
>
>         __handle_ksmbd_work(work, conn);
> @@ -271,6 +273,8 @@ static void handle_ksmbd_work(struct work_struct *wk)
>         ksmbd_conn_try_dequeue_request(work);
>         ksmbd_free_work_struct(work);
>         ksmbd_conn_r_count_dec(conn);
> +
> +       kcov_remote_stop();
>  }
>
>  /**
> --
> 2.50.0
>
