Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F186C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 01:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiGYBjT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 21:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiGYBjS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 21:39:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB1C11814
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 18:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47D6DB80DDC
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 01:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B73C385A5
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 01:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658713153;
        bh=cMGSQ2wRvjT6IHmOqwmdvlgxBi/hdkgu+VesztrNj84=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=KPEKaC75YdztMqjGLYa91Mx212oXhgOlNgzqWf1pH0t6Cjew/rwxgENI4nZm+oXuf
         GJ86UyDxlPGEOJPg6ppdlvNOSbewo+UCvsMgjl0reFVQj9rftwZ+ffgUFhXsjbTHXD
         jfWqzI2ZubmcQX5O9FxaVoVwkEzBcw3bEWRAQdb0nphK4DMs+/e88KDoRJFEMipAje
         w4nrXk465TRrRcmmpoYW+DCMJ3MLqzOzeAP0Bo3qau/y+5KHedIuEf/AkT4V2s/l9f
         tdSwJOMoOrgcFiL2GJjgAKj0wgF5WrHvsqAffSNRDNBKm49zFfFzNXuDlIPmgnUQLP
         hDXjA37ZYQ/Kw==
Received: by mail-wr1-f54.google.com with SMTP id h9so14006730wrm.0
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 18:39:13 -0700 (PDT)
X-Gm-Message-State: AJIora8GwfjTFWhfrzvgQng/vwi/Vhe+30/99admCGyr1KliYAG/Un3q
        Nc2DF1ZPvtoWHUdN8A07YlDXHjCZe28+ZZIvjQE=
X-Google-Smtp-Source: AGRyM1s/e+K90p2Yccre5XXJmc1HUzqSG96cProFdOXSMynnrZ2ZuSCBBOvhE5wBpcSJs5/yEBf0hWHR9guUo2hL61E=
X-Received: by 2002:adf:e111:0:b0:21d:665e:2fa5 with SMTP id
 t17-20020adfe111000000b0021d665e2fa5mr6397283wrz.652.1658713152060; Sun, 24
 Jul 2022 18:39:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:644a:0:0:0:0:0 with HTTP; Sun, 24 Jul 2022 18:39:11
 -0700 (PDT)
In-Reply-To: <CANFS6bYcMqWuKJd0aiDSWnj5kXd9viCgZzRLLukKzh8p1yWu+Q@mail.gmail.com>
References: <20220722030346.28534-1-linkinjeon@kernel.org> <20220722030346.28534-4-linkinjeon@kernel.org>
 <CANFS6bYcMqWuKJd0aiDSWnj5kXd9viCgZzRLLukKzh8p1yWu+Q@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 25 Jul 2022 10:39:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9wJ9nNS_ZaWvYZ3onKD983fhs5qh8juscvL4dygxP+BQ@mail.gmail.com>
Message-ID: <CAKYAXd9wJ9nNS_ZaWvYZ3onKD983fhs5qh8juscvL4dygxP+BQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] ksmbd: use wait_event instead of schedule_timeout()
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-07-25 9:48 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> 2022=EB=85=84 7=EC=9B=94 22=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 12:04=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> ksmbd threads eating masses of cputime when connection is disconnected.
>> If connection is disconnected, ksmbd thread waits for pending requests
>> to be processed using schedule_timeout. schedule_timeout() incorrectly
>> is used, and it is more efficient to use wait_event/wake_up than to chec=
k
>> r_count every time with timeout.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  fs/ksmbd/connection.c |  6 +++---
>>  fs/ksmbd/connection.h |  1 +
>>  fs/ksmbd/oplock.c     | 21 ++++++++++-----------
>>  fs/ksmbd/server.c     |  1 +
>>  4 files changed, 15 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
>> index ce23cc89046e..756ad631c019 100644
>> --- a/fs/ksmbd/connection.c
>> +++ b/fs/ksmbd/connection.c
>> @@ -66,6 +66,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
>>         conn->outstanding_credits =3D 0;
>>
>>         init_waitqueue_head(&conn->req_running_q);
>> +       init_waitqueue_head(&conn->r_count_q);
>>         INIT_LIST_HEAD(&conn->conns_list);
>>         INIT_LIST_HEAD(&conn->requests);
>>         INIT_LIST_HEAD(&conn->async_requests);
>> @@ -165,7 +166,6 @@ int ksmbd_conn_write(struct ksmbd_work *work)
>>         struct kvec iov[3];
>>         int iov_idx =3D 0;
>>
>> -       ksmbd_conn_try_dequeue_request(work);
>>         if (!work->response_buf) {
>>                 pr_err("NULL response header\n");
>>                 return -EINVAL;
>> @@ -347,8 +347,8 @@ int ksmbd_conn_handler_loop(void *p)
>>
>>  out:
>>         /* Wait till all reference dropped to the Server object*/
>> -       while (atomic_read(&conn->r_count) > 0)
>> -               schedule_timeout(HZ);
>> +       wait_event(conn->r_count_q, atomic_read(&conn->r_count) =3D=3D 0=
);
>> +
>>
>>         unload_nls(conn->local_nls);
>>         if (default_conn_ops.terminate_fn)
>> diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
>> index 5b39f0bdeff8..2e4730457c92 100644
>> --- a/fs/ksmbd/connection.h
>> +++ b/fs/ksmbd/connection.h
>> @@ -65,6 +65,7 @@ struct ksmbd_conn {
>>         unsigned int                    outstanding_credits;
>>         spinlock_t                      credits_lock;
>>         wait_queue_head_t               req_running_q;
>> +       wait_queue_head_t               r_count_q;
>>         /* Lock to protect requests list*/
>>         spinlock_t                      request_lock;
>>         struct list_head                requests;
>> diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
>> index 8b5560574d4c..9bb4fb8b80de 100644
>> --- a/fs/ksmbd/oplock.c
>> +++ b/fs/ksmbd/oplock.c
>> @@ -615,18 +615,13 @@ static void __smb2_oplock_break_noti(struct
>> work_struct *wk)
>>         struct ksmbd_file *fp;
>>
>>         fp =3D ksmbd_lookup_durable_fd(br_info->fid);
>> -       if (!fp) {
>> -               atomic_dec(&conn->r_count);
>> -               ksmbd_free_work_struct(work);
>> -               return;
>> -       }
>> +       if (!fp)
>> +               goto out;
>>
>>         if (allocate_oplock_break_buf(work)) {
>>                 pr_err("smb2_allocate_rsp_buf failed! ");
>> -               atomic_dec(&conn->r_count);
>>                 ksmbd_fd_put(work, fp);
>> -               ksmbd_free_work_struct(work);
>> -               return;
>> +               goto out;
>>         }
>>
>>         rsp_hdr =3D smb2_get_msg(work->response_buf);
>> @@ -667,8 +662,11 @@ static void __smb2_oplock_break_noti(struct
>> work_struct *wk)
>>
>>         ksmbd_fd_put(work, fp);
>>         ksmbd_conn_write(work);
>> +
>> +out:
>>         ksmbd_free_work_struct(work);
>>         atomic_dec(&conn->r_count);
>> +       wake_up_all(&conn->r_count_q);
>
> I think calling wake_up_all is better if atomic_dec_return(&conn->r_count=
)
> =3D=3D 0.
Are there cases where r_count inc/dec doesn't pair?

> Otherwise, Looks good to me.
>
>>  }
>>
>>  /**
>> @@ -731,9 +729,7 @@ static void __smb2_lease_break_noti(struct work_stru=
ct
>> *wk)
>>
>>         if (allocate_oplock_break_buf(work)) {
>>                 ksmbd_debug(OPLOCK, "smb2_allocate_rsp_buf failed! ");
>> -               ksmbd_free_work_struct(work);
>> -               atomic_dec(&conn->r_count);
>> -               return;
>> +               goto out;
>>         }
>>
>>         rsp_hdr =3D smb2_get_msg(work->response_buf);
>> @@ -771,8 +767,11 @@ static void __smb2_lease_break_noti(struct
>> work_struct *wk)
>>         inc_rfc1001_len(work->response_buf, 44);
>>
>>         ksmbd_conn_write(work);
>> +
>> +out:
>>         ksmbd_free_work_struct(work);
>>         atomic_dec(&conn->r_count);
>> +       wake_up_all(&conn->r_count_q);
>>  }
>>
>>  /**
>> diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
>> index 4cd03d661df0..dfddc8dc1919 100644
>> --- a/fs/ksmbd/server.c
>> +++ b/fs/ksmbd/server.c
>> @@ -262,6 +262,7 @@ static void handle_ksmbd_work(struct work_struct *wk=
)
>>         ksmbd_conn_try_dequeue_request(work);
>>         ksmbd_free_work_struct(work);
>>         atomic_dec(&conn->r_count);
>> +       wake_up_all(&conn->r_count_q);
>>  }
>>
>>  /**
>> --
>> 2.25.1
>>
>
>
> --
> Thanks,
> Hyunchul
>
