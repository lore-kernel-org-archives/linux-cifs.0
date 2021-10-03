Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F0AC433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 01:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBCC561A7D
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 01:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhJCBU1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 21:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbhJCBU1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 21:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9654261A7D
        for <linux-cifs@vger.kernel.org>; Sun,  3 Oct 2021 01:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633223920;
        bh=Ldz++ihzbAz9dsBizTZaqybCyN2KepRhKI3hY2FNTEY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=thorLLzEIdCmg4s0JHwdk+NAcMLKE0oBfgJ78y+X+KnskPtLjobWw4Ul4A4q1i24u
         vHm3+0yx5ARerDukafMH1hKxSXZ9U6Ls1XYh5IjA0kpNpcMMCV9RMwlb6/wg6q36vt
         r1OrKrfNzY0WFvG2ryObOj2t0TlPv+U7edhNNDhHMJWr1prPtoFqhp7YcG0DkQZB4+
         Ldmd1FDwgwYdTF6DzcbXicILH4AnvfvQsTR4PhwpU2ULVEh+TtsJn0J5JGMNx0FGxs
         TtZfntq9yyRwalzfy+G8WdVBDDdFpP+vIoevIBfeRwLm7QikewyQmXjW2AAJEx8+tu
         hutvU5mj64z7g==
Received: by mail-ot1-f46.google.com with SMTP id j11-20020a9d190b000000b00546fac94456so16699967ota.6
        for <linux-cifs@vger.kernel.org>; Sat, 02 Oct 2021 18:18:40 -0700 (PDT)
X-Gm-Message-State: AOAM530SNgXlrMUBI0YMYzGXI0rmZPGtHQrmaygczp/SRwqwG2kpZOao
        qV4Kh6MPrZihtW/ilsN6Yvh8hyF6qZ0lscfUqv4=
X-Google-Smtp-Source: ABdhPJyJBlCw4Hobb+rVthf3k9fYSiQx2tHm76anoltKknJPczGXsFWDxD87aARLJD6IO5CN5E+Zvuu1ykRctybRODI=
X-Received: by 2002:a9d:4705:: with SMTP id a5mr4336491otf.237.1633223919991;
 Sat, 02 Oct 2021 18:18:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sat, 2 Oct 2021 18:18:39 -0700 (PDT)
In-Reply-To: <20211002131212.130629-2-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org> <20211002131212.130629-2-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 3 Oct 2021 10:18:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8X_8nAvLXxna8kAHfce1jxz4-TH1j1h6g3ufjc7WpYXw@mail.gmail.com>
Message-ID: <CAKYAXd8X_8nAvLXxna8kAHfce1jxz4-TH1j1h6g3ufjc7WpYXw@mail.gmail.com>
Subject: Re: [PATCH v6 01/14] ksmbd: add the check to vaildate if stream
 protocol length exceeds maximum value
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-02 22:11 GMT+09:00, Ralph Boehme <slow@samba.org>:
> From: Namjae Jeon <linkinjeon@kernel.org>
>
> This patch add MAX_STREAM_PROT_LEN macro and check if stream protocol
> length exceeds maximum value. opencode pdu size check in
> ksmbd_pdu_size_has_room().
>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/connection.c | 9 +++++----
>  fs/ksmbd/smb_common.c | 6 ------
>  fs/ksmbd/smb_common.h | 4 ++--
>  3 files changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
> index af086d35398a..e50353c50661 100644
> --- a/fs/ksmbd/connection.c
> +++ b/fs/ksmbd/connection.c
> @@ -296,10 +296,11 @@ int ksmbd_conn_handler_loop(void *p)
>  		pdu_size =3D get_rfc1002_len(hdr_buf);
>  		ksmbd_debug(CONN, "RFC1002 header %u bytes\n", pdu_size);
>
> -		/* make sure we have enough to get to SMB header end */
> -		if (!ksmbd_pdu_size_has_room(pdu_size)) {
> -			ksmbd_debug(CONN, "SMB request too short (%u bytes)\n",
> -				    pdu_size);
> +		/*
> +		 * Check if pdu size is valid (min : smb header size,
> +		 * max : 0x00FFFFFF).
> +		 */
> +		if (pdu_size > MAX_STREAM_PROT_LEN) {
You changed this patch not to check header size check. I think that
this patch should be backed to original one. Because your patches are
clean-up patches, not fixes.
So you need to remove header size check here in "ksmbd: check PDU len
is at least header plus body size... ".

>  			continue;
>  		}
>
> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> index db8042a173d0..b6c4c7e960fa 100644
> --- a/fs/ksmbd/smb_common.c
> +++ b/fs/ksmbd/smb_common.c
> @@ -21,7 +21,6 @@ static const char basechars[43] =3D
> "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
>  #define MAGIC_CHAR '~'
>  #define PERIOD '.'
>  #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
> -#define KSMBD_MIN_SUPPORTED_HEADER_SIZE	(sizeof(struct smb2_hdr))
>
>  struct smb_protocol {
>  	int		index;
> @@ -294,11 +293,6 @@ int ksmbd_init_smb_server(struct ksmbd_work *work)
>  	return 0;
>  }
>
> -bool ksmbd_pdu_size_has_room(unsigned int pdu)
> -{
> -	return (pdu >=3D KSMBD_MIN_SUPPORTED_HEADER_SIZE - 4);
> -}
> -
>  int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int
> info_level,
>  				      struct ksmbd_file *dir,
>  				      struct ksmbd_dir_info *d_info,
> diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
> index 994abede27e9..6e79e7577f6b 100644
> --- a/fs/ksmbd/smb_common.h
> +++ b/fs/ksmbd/smb_common.h
> @@ -48,6 +48,8 @@
>  #define CIFS_DEFAULT_IOSIZE	(64 * 1024)
>  #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
>
> +#define MAX_STREAM_PROT_LEN	0x00FFFFFF
> +
>  /* Responses when opening a file. */
>  #define F_SUPERSEDED	0
>  #define F_OPENED	1
> @@ -493,8 +495,6 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects,
> __le16 dialects_count);
>
>  int ksmbd_init_smb_server(struct ksmbd_work *work);
>
> -bool ksmbd_pdu_size_has_room(unsigned int pdu);
> -
>  struct ksmbd_kstat;
>  int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work,
>  				      int info_level,
> --
> 2.31.1
>
>
