Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2974DC433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 00:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFD2C611C2
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 00:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbhJCBBP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 21:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234236AbhJCBBO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 21:01:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D96D961AFB
        for <linux-cifs@vger.kernel.org>; Sun,  3 Oct 2021 00:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633222767;
        bh=NYGpPnug/DAyBRNfyqmxSmeCng83eu5B6MGe9tp57AI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=X9upMKTaVrImSyreZh6QwRLZvnD04KJQhcy8Wjp5cKktaYLlHOpWbTcVUhaNe8Sos
         xOs5g3eRCqYxk8uJxCVn3aSCckquhJm1GDdAEPJbW+sKB2Ho4VURzLvwmyq4Jd4YWR
         EjidE6fQX3rZ+GCcbxTGMt2cdVUdluS9W66wzh12luYVLab/84qGVZnYKYwlCiuY71
         8l6hOSfyi9+HMiuaITr+emDxu5U7PnAfZL5Bhtq1YMLbQ5qetEtAtKADBtOr513ja2
         07nyc9cQhZeGUIQqdCZmJkLT5WBvGcn87IIc5cpuPjQs8p48V2NniUhplzlPa4SnzP
         XY9KV9vK8heSg==
Received: by mail-ot1-f41.google.com with SMTP id 5-20020a9d0685000000b0054706d7b8e5so16669678otx.3
        for <linux-cifs@vger.kernel.org>; Sat, 02 Oct 2021 17:59:27 -0700 (PDT)
X-Gm-Message-State: AOAM532vQerM9A5S1SYCsNOTurDtnC/TJWi7LFjqq8ZwB51AgC34Hx6g
        wcfgzgIdYUQB9njVjPtRvV+KvcHLZ/6/JYUGkAA=
X-Google-Smtp-Source: ABdhPJx2HI28BwKjYqEGZXAW5JIpfXAtPD9Cefg90LUZXECpbe4Y+HlvthJXsbQb3zNEL+OpP0clcsVftG8agEG1JRw=
X-Received: by 2002:a9d:729d:: with SMTP id t29mr4442116otj.61.1633222767278;
 Sat, 02 Oct 2021 17:59:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sat, 2 Oct 2021 17:59:26 -0700 (PDT)
In-Reply-To: <20211002131212.130629-8-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org> <20211002131212.130629-8-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 3 Oct 2021 09:59:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_jYHCnUbOoBGpsAPo_=H3wsbXcE8LOaAgvZT+dXzpPEA@mail.gmail.com>
Message-ID: <CAKYAXd_jYHCnUbOoBGpsAPo_=H3wsbXcE8LOaAgvZT+dXzpPEA@mail.gmail.com>
Subject: Re: [PATCH v6 07/14] ksmbd: use ksmbd_req_buf_next() in ksmbd_smb2_check_message()
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-02 22:12 GMT+09:00, Ralph Boehme <slow@samba.org>:
> No change in behaviour.
It is better to add patch subject here if there is nothing to write
patch description.
i.e. "Use ksmbd_req_buf_next() in ksmbd_smb2_check_message()"

>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Ralph Boehme <slow@samba.org>
> ---
>  fs/ksmbd/smb2misc.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
> index c1f0f10ca9f9..76f53db7db8d 100644
> --- a/fs/ksmbd/smb2misc.c
> +++ b/fs/ksmbd/smb2misc.c
> @@ -329,17 +329,12 @@ static int smb2_validate_credit_charge(struct smb2_hdr
> *hdr)
>
>  int ksmbd_smb2_check_message(struct ksmbd_work *work)
>  {
> -	struct smb2_pdu *pdu = work->request_buf;
> +	struct smb2_pdu *pdu = ksmbd_req_buf_next(work);
>  	struct smb2_hdr *hdr = &pdu->hdr;
>  	int command;
>  	__u32 clc_len;  /* calculated length */
>  	__u32 len = get_rfc1002_len(pdu);
>
> -	if (work->next_smb2_rcv_hdr_off) {
> -		pdu = ksmbd_req_buf_next(work);
> -		hdr = &pdu->hdr;
> -	}
> -
>  	if (le32_to_cpu(hdr->NextCommand) > 0) {
>  		len = le32_to_cpu(hdr->NextCommand);
>  	} else if (work->next_smb2_rcv_hdr_off) {
> --
> 2.31.1
>
>
