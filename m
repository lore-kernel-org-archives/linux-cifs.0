Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5174C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 01:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4A0761214
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 01:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbhJCBNc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 21:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234236AbhJCBNc (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 21:13:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB80061214
        for <linux-cifs@vger.kernel.org>; Sun,  3 Oct 2021 01:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633223505;
        bh=jbVyWV2nSvNmFiSru0/T/oT/3kkY60Z/PsMima9AVLs=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=FGTRtELetjwSjEN1peFLHrRnBpQkaUFlLp2akYHy42bOXZ1gzTxNvPFV+AiCOvC33
         toPsh5gqv7P0ZXud0zqpvyLkm4KB9xEkknnF7qZolOizcJClboGY+7SD5AM4z2fbsm
         nmSDUSrE598iEAz4SBqZZ1OC9raDOK1vh9ppiih80Aj57yBjBA4KqYL6v7yfBjX7HT
         3/FJj0499qQG79bXjEBxWRz4jXKY+grvsJQnJe636tjVqH8K7kDdxdVSDaNs1+Mh1/
         oDtgtVNe8gZuIlbazYRPJCZsVs0Y2m8meJLnc7njalq5e2K7O/lle/lRuU7ev2U+fK
         CGbvQrAhySCkg==
Received: by mail-ot1-f51.google.com with SMTP id g62-20020a9d2dc4000000b0054752cfbc59so16712211otb.1
        for <linux-cifs@vger.kernel.org>; Sat, 02 Oct 2021 18:11:45 -0700 (PDT)
X-Gm-Message-State: AOAM532NoqcYOsKRCYTwRRI4o5bVYgKtn6LzAD6/XT/bNNvys45MaYki
        GVkW+nD7ZpPG+s7thPjhuhqcRYhvpuISGQoLUsQ=
X-Google-Smtp-Source: ABdhPJxKUxXPh8qel26VpB9eOjXWdEkzAPhX/mB+aiFNAH6ZUHe0xM2G7J2igICpmz/ocFmIr8MJSJB2yeuaQ8ogIoI=
X-Received: by 2002:a05:6830:24a8:: with SMTP id v8mr4183893ots.185.1633223505093;
 Sat, 02 Oct 2021 18:11:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sat, 2 Oct 2021 18:11:44 -0700 (PDT)
In-Reply-To: <20211002131212.130629-10-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org> <20211002131212.130629-10-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 3 Oct 2021 10:11:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ZL6so9yBiUpY6MTa95s00M4=+H5RVLeAy5J-+q2FHVw@mail.gmail.com>
Message-ID: <CAKYAXd-ZL6so9yBiUpY6MTa95s00M4=+H5RVLeAy5J-+q2FHVw@mail.gmail.com>
Subject: Re: [PATCH v6 09/14] ksmbd: check PDU len is at least header plus
 body size in ksmbd_smb2_check_message()
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
> Note: we already have the same check in is_chained_smb2_message(), but there
> it
> only applies to compound requests, so we have to repeat the check here to
> cover
> both cases.
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Ralph Boehme <slow@samba.org>
> ---
>  fs/ksmbd/smb2misc.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
> index 7ed266eb6c5e..541b39b7a84b 100644
> --- a/fs/ksmbd/smb2misc.c
> +++ b/fs/ksmbd/smb2misc.c
> @@ -338,6 +338,9 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
>  	if (check_smb2_hdr(hdr))
>  		return 1;
>
> +	if (len < sizeof(struct smb2_pdu) - 4)
> +		return 1;
The point I'm talking about is an issue caused by you moving the
header buffer size here first( and you remove header buffer size check
in ksmbd_conn_handler_loop().)
When I apply patch till 09/14 number, check_user_session() and
get_ksmbd_tcon() is still has problem that access header without
header buffer size check.

And there still are functions to access header without header buffer
size check. Please check allocate_rsp_buf(), is_transform_hdr() and
init_rsp_hdr() in __handle_ksmbd_work().

> +
>  	if (hdr->StructureSize != SMB2_HEADER_STRUCTURE_SIZE) {
>  		ksmbd_debug(SMB, "Illegal structure size %u\n",
>  			    le16_to_cpu(hdr->StructureSize));
> --
> 2.31.1
>
>
