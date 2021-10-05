Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85EAC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 07:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E2CD613B5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 07:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhJEHbp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 03:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhJEHbp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Oct 2021 03:31:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56E8A61507
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 07:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633418995;
        bh=1e9uvOp/V/lVNr/a/nAcnlQaMvdVlmOsYAuWbCtA5Lg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=bMjstXhu1nO9zyzd+D6V8AX7Sgba0rrZR9808RdcxAS9cHFRIPSx1dqzbbrcRq374
         BQwlPhxcLhw4k+aLQPmIyfr1FGPAO3jaybuTjXGTRtxs9hu110R+29j9i7Ish/SYeM
         l4I3nnjnDDnETPNBNv+KYF6mjdcPYilZaf5/1IDUp0at+VJYXP44lUFgyVzTPj4a38
         4WLA2momGs96OfUPgBGESDdZfB8cB5xX3UmjKbLgjEXgZgM9CcInGxjo6U6KkbyWKn
         IuYHJb1EuOFlKRrbykIx+SUH9zssvQpDP+7Y4WiwBmeTte0Uv2YDs9kKgRkD5rFPWC
         iuwzjdc3Y2lmw==
Received: by mail-oi1-f179.google.com with SMTP id v10so833933oic.12
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 00:29:55 -0700 (PDT)
X-Gm-Message-State: AOAM530uFwIZv35NsBOMllYuzC44JwTZEzCLEROUnQ9GIe+UY1l7P6wX
        AqjQik9GaFmwzXSk9rsehnHC21TXuHWWL63rVLU=
X-Google-Smtp-Source: ABdhPJwhqrXePZjTWiKvTXtfXLO8Dhf1v2V0c6dANlKfWeKOVKjn+ZER9R7ftyKT5iUEXs+l06aR1xmelIWEVnp24vI=
X-Received: by 2002:aca:b5c3:: with SMTP id e186mr1302069oif.51.1633418994685;
 Tue, 05 Oct 2021 00:29:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Tue, 5 Oct 2021 00:29:54 -0700 (PDT)
In-Reply-To: <20211005050343.268514-4-slow@samba.org>
References: <20211005050343.268514-1-slow@samba.org> <20211005050343.268514-4-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 5 Oct 2021 16:29:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8TxcswXC3oySaLKOuCGzV2Dvfdv_1DaG9S_ErY_MvDMQ@mail.gmail.com>
Message-ID: <CAKYAXd8TxcswXC3oySaLKOuCGzV2Dvfdv_1DaG9S_ErY_MvDMQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/9] ksmbd: add and use ksmbd_smb2_cur_pdu_buflen() in ksmbd_smb2_check_message()
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-05 14:03 GMT+09:00, Ralph Boehme <slow@samba.org>:
> No change in behaviour.
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Ralph Boehme <slow@samba.org>
> ---
>  fs/ksmbd/smb2misc.c | 36 +++++++++++++++++++++++++++---------
>  fs/ksmbd/smb2pdu.h  |  1 +
>  2 files changed, 28 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
> index 2cc031c39514..7ed266eb6c5e 100644
> --- a/fs/ksmbd/smb2misc.c
> +++ b/fs/ksmbd/smb2misc.c
> @@ -333,14 +333,7 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
>  	struct smb2_hdr *hdr = &pdu->hdr;
>  	int command;
>  	__u32 clc_len;  /* calculated length */
> -	__u32 len = get_rfc1002_len(pdu);
> -
> -	if (le32_to_cpu(hdr->NextCommand) > 0) {
> -		len = le32_to_cpu(hdr->NextCommand);
> -	} else if (work->next_smb2_rcv_hdr_off) {
> -		len -= work->next_smb2_rcv_hdr_off;
> -		len = round_up(len, 8);
> -	}
> +	__u32 len = ksmbd_smb2_cur_pdu_buflen(work);
>
>  	if (check_smb2_hdr(hdr))
>  		return 1;
> @@ -395,7 +388,7 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
>  		 * Some windows servers (win2016) will pad also the final
>  		 * PDU in a compound to 8 bytes.
>  		 */
> -		if (ALIGN(clc_len, 8) == len)
> +		if (ALIGN(clc_len, 8) == ALIGN(len, 8))
Can I know why you align rfc1002 len with 8 here ?

Thanks!
