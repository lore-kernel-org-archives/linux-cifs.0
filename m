Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41949C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jan 2022 02:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiATC4e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:56:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43502 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiATC4e (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Jan 2022 21:56:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B8F361604
        for <linux-cifs@vger.kernel.org>; Thu, 20 Jan 2022 02:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41FCC340E3
        for <linux-cifs@vger.kernel.org>; Thu, 20 Jan 2022 02:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642647393;
        bh=0MkilCkGjYn9WbQsWPwx/vQVVhiKz7a19dTRBjSNzTc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=TItwrGfZeohChDWGaZyQP0SEgAEe95EQ5aa01SwAIcHBSHuoZQ2C/CtAGZ2MUfbLK
         b5O0C9YAJx0aFAprVq6M67uJlGmtdqv0X/tSiEpLrXUrtz2J31xIKu5xUtay1Cj5EJ
         T8x8Cntvcn7yVrvPtXnwhRiggdUNL9wBdDpNj+SPy3i8TizwSvcD6UolXrBAolp3aO
         /r5w8ZsCysusm0lU57UxIK8S4HDvq9QEvn51I4WKlj8Bj84PKHgQQ7ZR6ts3FJtvye
         7cPEn5NsgSPxZKRp1FJxF7GW6mq2ScslPb4MR9PSCgHyFZ8CA5WLRAB4RmdUIqCpVi
         wpyB5Ab2SokNw==
Received: by mail-yb1-f172.google.com with SMTP id m6so13583654ybc.9
        for <linux-cifs@vger.kernel.org>; Wed, 19 Jan 2022 18:56:32 -0800 (PST)
X-Gm-Message-State: AOAM5320mHq9KXfnUUpdLv1W9NwtBY4YtUjN7P3udDQvcapJtNzytsMu
        IIsHax4S6L0QJ98R6d0CPXe9md1h3Xmn3iu0qbo=
X-Google-Smtp-Source: ABdhPJzi37kDSMyL8QKHWG4mW4GcxCDyumS/kui4aDObhdPubPPeu3q419Xw29/apkkbQoVrryifBgoKjYDvg+jHuwU=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr13802895ybg.106.1642647392047;
 Wed, 19 Jan 2022 18:56:32 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:5011:b0:123:6c39:8652 with HTTP; Wed, 19 Jan 2022
 18:56:31 -0800 (PST)
In-Reply-To: <20220119150115.177058-1-hyc.lee@gmail.com>
References: <20220119150115.177058-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 20 Jan 2022 11:56:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-sxcM+tOMKHhq=K4XNPHMvDjqtcA5dN-rZUe7hy_XY0g@mail.gmail.com>
Message-ID: <CAKYAXd-sxcM+tOMKHhq=K4XNPHMvDjqtcA5dN-rZUe7hy_XY0g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: smbd: validate buffer descriptor structures
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-20 0:01 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Check ChannelInfoOffset and ChannelInfoLength
> to validate buffer descriptor structures.
> And add a debug log to print the structures'
> content.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> ---
>  fs/ksmbd/smb2pdu.c | 31 +++++++++++++++++++++++++------
>  1 file changed, 25 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index c3f248d461e6..f664fbadb09a 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -6130,12 +6130,20 @@ static int smb2_set_remote_key_for_rdma(struct
> ksmbd_work *work,
>  					__le16 ChannelInfoOffset,
>  					__le16 ChannelInfoLength)
>  {
> +	unsigned int i, ch_count;
> +
>  	if (work->conn->dialect == SMB30_PROT_ID &&
>  	    Channel != SMB2_CHANNEL_RDMA_V1)
>  		return -EINVAL;
>
> -	if (ChannelInfoOffset == 0 ||
> -	    le16_to_cpu(ChannelInfoLength) < sizeof(*desc))
> +	ch_count = le16_to_cpu(ChannelInfoLength) / sizeof(*desc);
> +	for (i = 0; i < ch_count; i++) {
unneeded loop is executed on non-debug mode. I think that this loop is
covered with rdma debug.
Please check this :
 if (ksmbd_debug_types & KSMBD_DEBUG_RDMA) { }

> +		ksmbd_debug(RDMA, "RDMA r/w request %#x: token %#x, length %#x\n",
> +			    i,
> +			    le32_to_cpu(desc[i].token),
> +			    le32_to_cpu(desc[i].length));
> +	}
> +	if (ch_count != 1)
Need to add error print that ksmbd doesn't support multiple buffer desc yet.
>  		return -EINVAL;

And multiple buffer desc support is required for a fundamental
solution, but it is expected that it will take a very long time for
you to implement it. Is that right? If so, first, find a way to set
the optimal read/write size so that the client send a single buffer
desc to ksmbd.
>
>  	work->need_invalidate_rkey =
> @@ -6189,9 +6197,15 @@ int smb2_read(struct ksmbd_work *work)
>
>  	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
>  	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
> +		unsigned int ch_offset = le16_to_cpu(req->ReadChannelInfoOffset);
> +
> +		if (ch_offset < offsetof(struct smb2_read_req, Buffer)) {
> +			err = -EINVAL;
> +			goto out;
> +		}
>  		err = smb2_set_remote_key_for_rdma(work,
>  						   (struct smb2_buffer_desc_v1 *)
> -						   &req->Buffer[0],
> +						   ((char *)req + ch_offset),
>  						   req->Channel,
>  						   req->ReadChannelInfoOffset,
>  						   req->ReadChannelInfoLength);
> @@ -6432,11 +6446,16 @@ int smb2_write(struct ksmbd_work *work)
>
>  	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
>  	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
> -		if (req->Length != 0 || req->DataOffset != 0)
> -			return -EINVAL;
> +		unsigned int ch_offset = le16_to_cpu(req->WriteChannelInfoOffset);
> +
> +		if (req->Length != 0 || req->DataOffset != 0 ||
> +		    ch_offset < offsetof(struct smb2_write_req, Buffer)) {
> +			err = -EINVAL;
> +			goto out;
> +		}
>  		err = smb2_set_remote_key_for_rdma(work,
>  						   (struct smb2_buffer_desc_v1 *)
> -						   &req->Buffer[0],
> +						   ((char *)req + ch_offset),
>  						   req->Channel,
>  						   req->WriteChannelInfoOffset,
>  						   req->WriteChannelInfoLength);
> --
> 2.25.1
>
>
