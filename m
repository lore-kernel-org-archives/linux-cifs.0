Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90CADC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 06:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F325619E5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 06:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhJBGD0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 02:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhJBGDZ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 02:03:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67513619E5
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633154500;
        bh=e1XLgOXfPpD3WLQlbWrIQUaDkXZLpHIgAMYezTUHgMc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=vO+PxTolTeP18UPg4JuecFIDBMKTKzycb5QXC43NMV5L83FbtJJjhpyyTcvD/0044
         OFsYxq4En34EKfGi6DyV1V45y577wwTgmNhpQfoCS7k88IibJKpGHXtdYOJDXnkkon
         S4AGYCoGzVYOWOjdl33zEaq6xw/Rm5xaiq5FModnSb2iS11Z2GoQenPbv9ba2GI6IQ
         tXDTNrZtOu0+Jz25mcySKOM5SzWbbHq2FEL8zzlCGBs2j1i6a9JXEnpYrX3kwl/HRx
         QLAT/1ACCwHW5NfuWbXlu9hj6tuWzz2Y+YtQiEu3UxDdXOddP7y/bXqjuYrcgAV4J2
         1bfFT1XhEIFHg==
Received: by mail-oo1-f49.google.com with SMTP id j11-20020a4a92cb000000b002902ae8cb10so3547825ooh.7
        for <linux-cifs@vger.kernel.org>; Fri, 01 Oct 2021 23:01:40 -0700 (PDT)
X-Gm-Message-State: AOAM532Noy4v+pzJ/pKZ6r5iXWq8xwdCjURx++xaJKzmkOHgkk4TGis6
        78HCx19fkl/tNi1NeUfl4OT5cNFQAodE3atl+yU=
X-Google-Smtp-Source: ABdhPJwINB1XoL3ROwa0dlBYyLBePyjseqo5gqmrPKaekZZULt/g0CxskEYzZVaqkYNcQzeVup7tBSPdmRU+VfiIpkY=
X-Received: by 2002:a05:6820:1018:: with SMTP id v24mr1608473oor.27.1633154499817;
 Fri, 01 Oct 2021 23:01:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Fri, 1 Oct 2021 23:01:39 -0700 (PDT)
In-Reply-To: <20211001120421.327245-20-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org> <20211001120421.327245-20-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 2 Oct 2021 15:01:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd83=qxkzrzO_72U4tQsRzWks0CdYLGLnZqQXoXqQ67Vbw@mail.gmail.com>
Message-ID: <CAKYAXd83=qxkzrzO_72U4tQsRzWks0CdYLGLnZqQXoXqQ67Vbw@mail.gmail.com>
Subject: Re: [PATCH v5 19/20] ksmbd: make smb2_check_user_session() callabe
 for compound PDUs
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
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Ralph Boehme <slow@samba.org>
> ---
>  fs/ksmbd/smb2pdu.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 5b1fead05c49..ef551e3633db 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -411,7 +411,6 @@ static void init_chained_smb2_rsp(struct ksmbd_work
> *work)
>  		work->compound_pfid =
>  			le64_to_cpu(((struct smb2_create_rsp *)rsp)->
>  				PersistentFileId);
> -		work->compound_sid = le64_to_cpu(rsp->SessionId);
>  	}
>
>  	len = get_rfc1002_len(work->response_buf) - work->next_smb2_rsp_hdr_off;
> @@ -592,6 +591,8 @@ int smb2_check_user_session(struct ksmbd_work *work)
>  	unsigned long long sess_id;
>
>  	work->sess = NULL;
> +	work->compound_sid = 0;
> +
>  	/*
>  	 * SMB2_ECHO, SMB2_NEGOTIATE, SMB2_SESSION_SETUP command do not
>  	 * require a session id, so no need to validate user session's for
> @@ -604,11 +605,17 @@ int smb2_check_user_session(struct ksmbd_work *work)
>  	if (!ksmbd_conn_good(work))
>  		return -EINVAL;
>
> -	sess_id = le64_to_cpu(req_hdr->SessionId);
> +	if (req_hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS)
> +		sess_id = work->compound_sid;
same comment with previous tree id patch.
> +	else
> +		sess_id = le64_to_cpu(req_hdr->SessionId);
> +
>  	/* Check for validity of user session */
>  	work->sess = ksmbd_session_lookup_all(conn, sess_id);
> -	if (work->sess)
> +	if (work->sess) {
> +		work->compound_sid = sess_id;
>  		return 1;
> +	}
>  	ksmbd_debug(SMB, "Invalid user session, Uid %llu\n", sess_id);
>  	return -EINVAL;
>  }
> --
> 2.31.1
>
>
