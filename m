Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBB8C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 05:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B9A261A56
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 05:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhJBF5j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 01:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhJBF5j (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 01:57:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1490F61A56
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 05:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633154154;
        bh=+CG4tXOwS6AeoehGqjS9htyfqeVieRrM5HMwx98jeW0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=glg4AMF7i3gq4H6cIvDnwH7haIyvjrjBZnqtjWb7uOiHpwnQuRs9uQ9WBH4vU7Fcc
         YDesQITQ2fWowq8OW6XBMzPIa6VTqBRWnGyGJ5AoUoLCoeFDVWFBX4DFTujRjeKYSc
         Qq9Bas8rmhJiPmTN7ZLLCEX2m/50aNXgEcvplc/3bkd+pMYpKWu8dVbk4LPZxKvdwE
         /T4RhtDp7LW9PxKbvAOSJID/j+pQSe7zXdYDRCUPLA6bGu+BMgiXDK0FywHhDEonkU
         apUsUhi5QaadjLc5fgwTmhJa40VCKXPMhF4wyx1A+hP1z3/JPrcRVII2t703a2Z2fR
         XE6X6S8uvI11Q==
Received: by mail-ot1-f46.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so14215522otq.7
        for <linux-cifs@vger.kernel.org>; Fri, 01 Oct 2021 22:55:54 -0700 (PDT)
X-Gm-Message-State: AOAM531GtTMHOu6z/GiBtlrFTI+nn4Ar1Wz/is0ydMXynmn00Eut+Q9H
        zk//Gko1Ty8cmauJBylXJuOIN+bGSmJaBXZQ6/I=
X-Google-Smtp-Source: ABdhPJy029piHjzr2vxO/2EMNZCkVfF3u8xirFQhPhG9PsnqiDzHQpsXAxevgF0tHpIlgORiSMbI8yREboDKDf0PEWE=
X-Received: by 2002:a9d:4705:: with SMTP id a5mr1427052otf.237.1633154153454;
 Fri, 01 Oct 2021 22:55:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Fri, 1 Oct 2021 22:55:53 -0700 (PDT)
In-Reply-To: <20211001120421.327245-17-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org> <20211001120421.327245-17-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 2 Oct 2021 14:55:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8UH+LBDFSNCOHJOEFco=9CTzFmTzP9D+u_h1USm1bj1Q@mail.gmail.com>
Message-ID: <CAKYAXd8UH+LBDFSNCOHJOEFco=9CTzFmTzP9D+u_h1USm1bj1Q@mail.gmail.com>
Subject: Re: [PATCH v5 16/20] ksmbd: check PDU len is at least header plus
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

2021-10-01 21:04 GMT+09:00, Ralph Boehme <slow@samba.org>:
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
when only this patch is applied, how can you guarantee that session id
and tree id of smb2 header are vaild ?

> +
>  	if (hdr->StructureSize != SMB2_HEADER_STRUCTURE_SIZE) {
>  		ksmbd_debug(SMB, "Illegal structure size %u\n",
>  			    le16_to_cpu(hdr->StructureSize));
> --
> 2.31.1
>
>
