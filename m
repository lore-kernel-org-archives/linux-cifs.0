Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D86C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 08:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16BCC6105A
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 08:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhIYInq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 04:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbhIYInp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 04:43:45 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF6EC061570
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 01:42:11 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id h30so12587481vsq.3
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 01:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EYZsbHXHdunYrfeo+Yp5CuoV+69L1e1NYMrDJtvhPQI=;
        b=bwpkGQh4+ojqYVFgtSaUNyj8OVX0oau8+3qv7FtTB9g2gLOXrlzQLsZxkSDWyfXLpd
         lx+fiLkdkoNsIa85ycvimbOcE72Iq7aaNPu+h+o8tqjEJxIMJCYbI5i63EVocllAqUaG
         61i+LAWVK7o/UzOMHmq1GjOOXCAk6P7u1UXsufNMz81i94hmWwPgxAutndthc8VAZooj
         5WBvatWAFLL3rtmCNWThpmss7SikC5HHTwgR4Tk5V4uaV9ima4vG8DxSiuG8qPg10rjl
         XUi0EJvgRb6SEXY6LMd47gqanLLMDdGXQPkGGMrStmlc+XyLRDbaoS9JDuudPtSJNat1
         TYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EYZsbHXHdunYrfeo+Yp5CuoV+69L1e1NYMrDJtvhPQI=;
        b=fOrnRHndpcrg1+sHag5+3UDgWAhnlpXhEhGZKKbLF8MA2+nN6qG0dQ53q4VKcO6GUL
         GrWa4alSc5hnNUTfuQz3RrIrlxuBx/XQ3WQvsz7DmELea05EHvDLfroNR0cl/o94HdEW
         YXt8lmQ+ZEodk4/OaQQiAU1AuGIyWTA+1R8IdC2krSYZgMKD+Osc+mnWwixokPHXx1RE
         dsLQfODAKHiDrrHjp9lCjiaoyN32I4NaW9YMGTmXONrQLLSOLWnwfoPgmLYTu39r70u9
         3HsVNcTLzVuP7SFYI4wBSussgq3AsfEiXz8Wj2/1JzIr/KdzmFEKaaC1FGxWNs8gKf2n
         NXHQ==
X-Gm-Message-State: AOAM531izTnYsgL41ydHHWuZrHiTf8oQ/3HNYVunVR7920tsdCxB5bYS
        uCG6dqpDb4w7EZjWbL+tlKREbUiFPvpFRQlE1Go=
X-Google-Smtp-Source: ABdhPJwJyLKKEDUMeb89XD3hI8kvQq9AJDnt4ekrSEiOgq4ZZ9IeSlVjjL3vjc9ezj37x1F01KmqLtBh9VM+pi3JMvA=
X-Received: by 2002:a67:c088:: with SMTP id x8mr12845617vsi.45.1632559330515;
 Sat, 25 Sep 2021 01:42:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210924021254.27096-1-linkinjeon@kernel.org> <20210924021254.27096-6-linkinjeon@kernel.org>
In-Reply-To: <20210924021254.27096-6-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 25 Sep 2021 17:41:59 +0900
Message-ID: <CANFS6baqgQeHdQwmfekMVC2u_FaAkUgfr3BMhBHDEKKr+1J=wA@mail.gmail.com>
Subject: Re: [PATCH 5/7] ksmbd: add the check to vaildate if stream protocol
 length exceeds maximum value
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 9=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 11:13, =
Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> This patch add MAX_STREAM_PROT_LEN macro and check if stream protocol
> length exceeds maximum value. opencode pdu size check in
> ksmbd_pdu_size_has_room().
>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/connection.c | 10 ++++++----
>  fs/ksmbd/smb_common.c |  6 ------
>  fs/ksmbd/smb_common.h |  4 ++--
>  3 files changed, 8 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
> index af086d35398a..48b18b4ec117 100644
> --- a/fs/ksmbd/connection.c
> +++ b/fs/ksmbd/connection.c
> @@ -296,10 +296,12 @@ int ksmbd_conn_handler_loop(void *p)
>                 pdu_size =3D get_rfc1002_len(hdr_buf);
>                 ksmbd_debug(CONN, "RFC1002 header %u bytes\n", pdu_size);
>
> -               /* make sure we have enough to get to SMB header end */
> -               if (!ksmbd_pdu_size_has_room(pdu_size)) {
> -                       ksmbd_debug(CONN, "SMB request too short (%u byte=
s)\n",
> -                                   pdu_size);
> +               /*
> +                * Check if pdu size is valid (min : smb header size,
> +                * max : 0x00FFFFFF).
> +                */
> +               if (pdu_size < __SMB2_HEADER_STRUCTURE_SIZE ||
> +                   pdu_size > MAX_STREAM_PROT_LEN) {
>                         continue;
>                 }
>
> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> index 5901b2884c60..20bd5b8e3c0a 100644
> --- a/fs/ksmbd/smb_common.c
> +++ b/fs/ksmbd/smb_common.c
> @@ -21,7 +21,6 @@ static const char basechars[43] =3D "0123456789ABCDEFGH=
IJKLMNOPQRSTUVWXYZ_-!@#$%";
>  #define MAGIC_CHAR '~'
>  #define PERIOD '.'
>  #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
> -#define KSMBD_MIN_SUPPORTED_HEADER_SIZE        (sizeof(struct smb2_hdr))
>
>  struct smb_protocol {
>         int             index;
> @@ -272,11 +271,6 @@ int ksmbd_init_smb_server(struct ksmbd_work *work)
>         return 0;
>  }
>
> -bool ksmbd_pdu_size_has_room(unsigned int pdu)
> -{
> -       return (pdu >=3D KSMBD_MIN_SUPPORTED_HEADER_SIZE - 4);
> -}
> -
>  int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_=
level,
>                                       struct ksmbd_file *dir,
>                                       struct ksmbd_dir_info *d_info,
> diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
> index 994abede27e9..6e79e7577f6b 100644
> --- a/fs/ksmbd/smb_common.h
> +++ b/fs/ksmbd/smb_common.h
> @@ -48,6 +48,8 @@
>  #define CIFS_DEFAULT_IOSIZE    (64 * 1024)
>  #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
>
> +#define MAX_STREAM_PROT_LEN    0x00FFFFFF

Do we need to append "SMB" to this macro name?
Looks good to me.
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>


> +
>  /* Responses when opening a file. */
>  #define F_SUPERSEDED   0
>  #define F_OPENED       1
> @@ -493,8 +495,6 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, =
__le16 dialects_count);
>
>  int ksmbd_init_smb_server(struct ksmbd_work *work);
>
> -bool ksmbd_pdu_size_has_room(unsigned int pdu);
> -
>  struct ksmbd_kstat;
>  int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work,
>                                       int info_level,
> --
> 2.25.1
>


--
Thanks,
Hyunchul
