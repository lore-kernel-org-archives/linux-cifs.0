Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF18AC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jan 2022 01:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346471AbiAKB6c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Jan 2022 20:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346469AbiAKB6b (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Jan 2022 20:58:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBEBC06173F
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jan 2022 17:58:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D18C6149E
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 01:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1388C36AED
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 01:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641866310;
        bh=dwngxYGwJ9hrzOZ84o2eiuCocomF4dmUAOcf3RDioMg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=tpYN/HkpDOD9/bWVPno7WGIVRNpafWbO8BV7oHV8qOgwsu5RFFuF3tT35CMoKNOPq
         4A1+RiJZthxBKBGgta7QiAHqdwMFQpiP5jXzpqHwN56HmrVX5HfBbto1qY5t5p+l5+
         t1efpyRS2/4t1u0V46DbsceBXMERtUv7H1MTF2yMD3t2GWjYfHZzY5ZX4RJzkR3y8R
         6SpraNhPY3xLjD5N/VqHoiD68eATL7ZTPSFndffeVP30nnQsZS7zDkyFeJa41inaCy
         aZVCQhJUxfW5EbHxCrWyg3/fMApAdXGKrlG7dNn/MmjG8SeGUVFnQHo324lG/FpYky
         uNbcj0lDj2q8Q==
Received: by mail-yb1-f181.google.com with SMTP id p5so35967751ybd.13
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jan 2022 17:58:30 -0800 (PST)
X-Gm-Message-State: AOAM530K8ii+mkCBYFI/uGiz4BbpHVcuwC0A+LxKG4PEfRdS4SIaYdgx
        yBUFvrA2TWhjFzfFAdGUrSKNBH4dzvk3zLucFjg=
X-Google-Smtp-Source: ABdhPJwlixXwb+EmwCsTbF9WnsFWDwp2p0F0nK+LjibKwiM+doJds8xGRoTKdMkN4Z2Ud+O6+GPGH8fQzWCR8GYOxd8=
X-Received: by 2002:a25:a321:: with SMTP id d30mr3564003ybi.373.1641866309741;
 Mon, 10 Jan 2022 17:58:29 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:5011:b0:123:6c39:8652 with HTTP; Mon, 10 Jan 2022
 17:58:29 -0800 (PST)
In-Reply-To: <20220110013639.841324-1-hyc.lee@gmail.com>
References: <20220110013639.841324-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 11 Jan 2022 10:58:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8cXmqoQFwc1b-cT21SX5Yt7Lv=qqs0syaCc17DiPHBQw@mail.gmail.com>
Message-ID: <CAKYAXd8cXmqoQFwc1b-cT21SX5Yt7Lv=qqs0syaCc17DiPHBQw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: smbd: fix missing client's memory region invalidation
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-10 10:36 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> if the Channel of a SMB2 WRITE request is
> SMB2_CHANNEL_RDMA_V1_INVALIDTE, a client
> does not invalidate its memory regions but
> ksmbd must do it by sending a SMB2 WRITE response
> with IB_WR_SEND_WITH_INV.
>
> But if errors occur while processing a SMB2
> READ/WRITE request, ksmbd sends a response
> with IB_WR_SEND. So a client could use memory
> regions already in use.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> ---
>  fs/ksmbd/smb2pdu.c | 76 ++++++++++++++++++++++++++++++----------------
>  1 file changed, 49 insertions(+), 27 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index ced8f949a4d6..19355511b777 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -6132,18 +6132,6 @@ static ssize_t smb2_read_rdma_channel(struct
> ksmbd_work *work,
>  		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
>  	int err;
>
> -	if (work->conn->dialect == SMB30_PROT_ID &&
> -	    req->Channel != SMB2_CHANNEL_RDMA_V1)
> -		return -EINVAL;
> -
> -	if (req->ReadChannelInfoOffset == 0 ||
> -	    le16_to_cpu(req->ReadChannelInfoLength) < sizeof(*desc))
> -		return -EINVAL;
> -
> -	work->need_invalidate_rkey =
> -		(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
> -	work->remote_key = le32_to_cpu(desc->token);
> -
>  	err = ksmbd_conn_rdma_write(work->conn, data_buf, length,
>  				    le32_to_cpu(desc->token),
>  				    le64_to_cpu(desc->offset),
> @@ -6179,6 +6167,28 @@ int smb2_read(struct ksmbd_work *work)
>  		return smb2_read_pipe(work);
>  	}
>
> +	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
> +	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
> +		struct smb2_buffer_desc_v1 *desc =
> +			(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
> +
> +		if (work->conn->dialect == SMB30_PROT_ID &&
> +		    req->Channel != SMB2_CHANNEL_RDMA_V1) {
> +			err = -EINVAL;
> +			goto out;
> +		}
> +
> +		if (req->ReadChannelInfoOffset == 0 ||
> +		    le16_to_cpu(req->ReadChannelInfoLength) < sizeof(*desc)) {
> +			err = -EINVAL;
> +			goto out;
> +		}
> +
> +		work->need_invalidate_rkey =
> +			(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
> +		work->remote_key = le32_to_cpu(desc->token);
> +	}
Can we factor out a helper for this ?
> +
>  	fp = ksmbd_lookup_fd_slow(work, le64_to_cpu(req->VolatileFileId),
>  				  le64_to_cpu(req->PersistentFileId));
>  	if (!fp) {
> @@ -6364,21 +6374,6 @@ static ssize_t smb2_write_rdma_channel(struct
> ksmbd_work *work,
>
>  	desc = (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
>
> -	if (work->conn->dialect == SMB30_PROT_ID &&
> -	    req->Channel != SMB2_CHANNEL_RDMA_V1)
> -		return -EINVAL;
> -
> -	if (req->Length != 0 || req->DataOffset != 0)
> -		return -EINVAL;
> -
> -	if (req->WriteChannelInfoOffset == 0 ||
> -	    le16_to_cpu(req->WriteChannelInfoLength) < sizeof(*desc))
> -		return -EINVAL;
> -
> -	work->need_invalidate_rkey =
> -		(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
> -	work->remote_key = le32_to_cpu(desc->token);
> -
>  	data_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
>  	if (!data_buf)
>  		return -ENOMEM;
> @@ -6425,6 +6420,33 @@ int smb2_write(struct ksmbd_work *work)
>  		return smb2_write_pipe(work);
>  	}
>
> +	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
> +	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
> +		struct smb2_buffer_desc_v1 *desc =
> +			(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
> +
> +		if (work->conn->dialect == SMB30_PROT_ID &&
> +		    req->Channel != SMB2_CHANNEL_RDMA_V1) {
> +			err = -EINVAL;
> +			goto out;
> +		}
> +
> +		if (req->Length != 0 || req->DataOffset != 0) {
> +			err = -EINVAL;
> +			goto out;
> +		}
> +
> +		if (req->WriteChannelInfoOffset == 0 ||
> +		    le16_to_cpu(req->WriteChannelInfoLength) < sizeof(*desc)) {
> +			err = -EINVAL;
> +			goto out;
> +		}
> +
> +		work->need_invalidate_rkey =
> +			(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
> +		work->remote_key = le32_to_cpu(desc->token);
> +	}
Ditto.

Thanks!
> +
>  	if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
>  		ksmbd_debug(SMB, "User does not have write permission\n");
>  		err = -EACCES;
> --
> 2.25.1
>
>
