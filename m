Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5640CC433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 05:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2709F61440
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 05:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhJBFsD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 01:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhJBFsD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 01:48:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B86E361A54
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 05:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633153577;
        bh=X6dqMJFd2bpycC17wQzqbrzcMZfIUhW6JNxCiEVEWBE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=qeIZchfiecds2m+7aTBVRruARPoOO/uDWuicjCqycO33ACWr2xhljloTVKDrc+F9W
         0OCSyNBqAp8Z3jgATE9e8Gu3bgH8X5mia9qi5RD9qEP/ELQM9yOmkhm6Xhs6sVMSab
         hUoM30qY6Jv6qZXaVDf+SSO4YIZ1ZZjUzJ8LSdltgXk1bpsuWTRJOw1uK8UfrIWVEN
         hFnYh4VOLTwmVCxk3BFcVa3FZBf1AhMhJYBWx0876+fO8u05R2Um6hb7GKY8RbabYG
         /b5VlBJQDrIHXrXgD6Av9TsdzVUoyYqkiVERDjFxAS48miNcyaxlMm+aohpeFpCHcD
         LlqKfl5+DYYfQ==
Received: by mail-ot1-f42.google.com with SMTP id 97-20020a9d006a000000b00545420bff9eso14201240ota.8
        for <linux-cifs@vger.kernel.org>; Fri, 01 Oct 2021 22:46:17 -0700 (PDT)
X-Gm-Message-State: AOAM532jRX6oj3sn7TDH9vzCdo52/iZ0YvlXf2rtm67y7LmaYUiXKHzD
        /8C68pGCCxiboqlos2QZFkAi1eitCoz5eqDlpwM=
X-Google-Smtp-Source: ABdhPJzX8vi9kwzHVScAkQS4sPufq6Y//tC63szfYbBWHkCxOcrWIJHEoZAAPzBiYj5+Ct7fGq92TxkyTooxwPm4pz4=
X-Received: by 2002:a05:6830:24a8:: with SMTP id v8mr1364729ots.185.1633153577069;
 Fri, 01 Oct 2021 22:46:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Fri, 1 Oct 2021 22:46:16 -0700 (PDT)
In-Reply-To: <20211001120421.327245-14-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org> <20211001120421.327245-14-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 2 Oct 2021 14:46:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-PsL4adDyK3wLRQGp51wvuH6QX0r6xW5rywyUT_+a+3g@mail.gmail.com>
Message-ID: <CAKYAXd-PsL4adDyK3wLRQGp51wvuH6QX0r6xW5rywyUT_+a+3g@mail.gmail.com>
Subject: Re: [PATCH v5 13/20] ksmbd: remove ksmbd_verify_smb_message()
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-01 21:04 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Another leftover from SMB1 support. Remove it and use
> ksmbd_verify_smb_message()
> directly in __process_request().
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Ralph Boehme <slow@samba.org>
> ---
>  fs/ksmbd/server.c     |  2 +-
>  fs/ksmbd/smb_common.c | 24 ------------------------
>  fs/ksmbd/smb_common.h |  1 -
>  3 files changed, 1 insertion(+), 26 deletions(-)
>
> diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
> index 2a2b2135bfde..328c4225cec1 100644
> --- a/fs/ksmbd/server.c
> +++ b/fs/ksmbd/server.c
> @@ -114,7 +114,7 @@ static int __process_request(struct ksmbd_work *work,
> struct ksmbd_conn *conn,
>  	if (check_conn_state(work))
>  		return SERVER_HANDLER_CONTINUE;
>
> -	if (ksmbd_verify_smb_message(work))
> +	if (ksmbd_smb2_check_message(work))
>  		return SERVER_HANDLER_ABORT;
>
>  	command = conn->ops->get_cmd_val(work);
> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> index e1e5a071678e..4a283cd6d6e1 100644
> --- a/fs/ksmbd/smb_common.c
> +++ b/fs/ksmbd/smb_common.c
> @@ -122,30 +122,6 @@ int ksmbd_lookup_protocol_idx(char *str)
>  	return -1;
>  }
>
> -/**
> - * ksmbd_verify_smb_message() - check for valid smb2 request header
> - * @work:	smb work
> - *
> - * check for valid smb signature and packet direction(request/response)
> - *
> - * Return:      0 on success, otherwise -EINVAL
> - */
> -int ksmbd_verify_smb_message(struct ksmbd_work *work)
> -{
> -	struct smb2_hdr *smb2_hdr = ksmbd_req_buf_next(work);
> -	struct smb_hdr *hdr;
> -
> -	if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)
> -		return ksmbd_smb2_check_message(work);
> -
> -	hdr = work->request_buf;
> -	if (*(__le32 *)hdr->Protocol == SMB1_PROTO_NUMBER &&
> -	    hdr->Command == SMB_COM_NEGOTIATE)
> -		return 0;
smb1 negotiate is needed for windows connection. Have you tested with
windows client ?

> -
> -	return -EINVAL;
> -}
> -
>  /**
>   * ksmbd_smb_request() - check for valid smb request type
>   * @conn:	connection instance
> diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
> index 6e79e7577f6b..782c06292020 100644
> --- a/fs/ksmbd/smb_common.h
> +++ b/fs/ksmbd/smb_common.h
> @@ -488,7 +488,6 @@ int ksmbd_max_protocol(void);
>
>  int ksmbd_lookup_protocol_idx(char *str);
>
> -int ksmbd_verify_smb_message(struct ksmbd_work *work);
>  bool ksmbd_smb_request(struct ksmbd_conn *conn);
>
>  int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16
> dialects_count);
> --
> 2.31.1
>
>
