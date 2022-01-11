Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC49C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jan 2022 13:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbiAKNVw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Jan 2022 08:21:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50404 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240355AbiAKNVv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Jan 2022 08:21:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EA76B81AC6
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 13:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599CAC36AE3
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 13:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641907309;
        bh=hehYCxcp9pG/Oo3+iHkPI5CwMGeWl6N3BGfjP/MwY4Y=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=mG9qdGzjnOlkt4srTEBbH2K3lzodKgIYjuiajhqlxPJBR8kq3p+qAKIv4RJTwxXQ1
         NGsEOuPmJXcv0UNXc/KKUZxoVnOhrw/OxtyIev/fE6dm3Izqc+40mSD3d7tQmC6jPD
         8M0X0yM1PMB33UaX8NSr3WbSuYIjA/zvaHn/E/h3zfq56gt/ZH4N7YFSL7PYWXW0CY
         x7sJgKmN1JahrO2PtbPh8UwPQd1nFfJ7v+u8AXtiWEFxZG9FZa5ONS51iKdzTI59Mq
         z1dXjK1jwIrW7FdOEE08glacwNTlxValjT4uMvwxzISuQ7GWbkj6AJaPbLvdB4tAzS
         hK3vR4quWW58w==
Received: by mail-yb1-f174.google.com with SMTP id h14so29841985ybe.12
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jan 2022 05:21:49 -0800 (PST)
X-Gm-Message-State: AOAM530YRM9gDCn+nsMo89zzcdsIvlmlDs+rukiSAz7DrCFEtutGGPsT
        flD5Um2byMVtx2WVLxM3gibvWp/cD3jE364cNqo=
X-Google-Smtp-Source: ABdhPJwmal3q/YRy87HlRzD5ZVHH26TAc4GkKUdrmwk+wnuZ4Pt5gwXW1kcSxpkLBoLbj30ruNyMjTBbKJRrZvDZu3U=
X-Received: by 2002:a5b:58d:: with SMTP id l13mr5990511ybp.475.1641907308468;
 Tue, 11 Jan 2022 05:21:48 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:5011:b0:123:6c39:8652 with HTTP; Tue, 11 Jan 2022
 05:21:48 -0800 (PST)
In-Reply-To: <20220111115703.893347-1-hyc.lee@gmail.com>
References: <20220111115703.893347-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 11 Jan 2022 22:21:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-a=8eAE023ECCoBKPD3L+q=Jb=Sem17VSVcheeryt9Dw@mail.gmail.com>
Message-ID: <CAKYAXd-a=8eAE023ECCoBKPD3L+q=Jb=Sem17VSVcheeryt9Dw@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: smbd: fix missing client's memory region invalidation
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-11 20:57 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
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
> changes from v1:
>  - factor out setting a remote key to a helper functions.
Can we make it as one helper function if desc, Channel,
ChannelInfoOffset, ChannelInfoLength are given as arguments?

>
>  fs/ksmbd/smb2pdu.c | 58 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 44 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index ced8f949a4d6..b87969576642 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -6124,13 +6124,11 @@ static noinline int smb2_read_pipe(struct ksmbd_work
> *work)
>  	return err;
>  }
>
> -static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
> -				      struct smb2_read_req *req, void *data_buf,
> -				      size_t length)
> +static int smb2_set_remote_key_for_rdma_read(struct ksmbd_work *work,
> +					     struct smb2_read_req *req)
Can we make it as one helper function if desc, Channel,
ChannelInfoOffset, ChannelInfoLength are given as arguments? i.e.
smb2_set_remote_key_for_rdma().

>  {
>  	struct smb2_buffer_desc_v1 *desc =
>  		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
> -	int err;
>
>  	if (work->conn->dialect == SMB30_PROT_ID &&
>  	    req->Channel != SMB2_CHANNEL_RDMA_V1)
> @@ -6143,6 +6141,16 @@ static ssize_t smb2_read_rdma_channel(struct
> ksmbd_work *work,
>  	work->need_invalidate_rkey =
>  		(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
>  	work->remote_key = le32_to_cpu(desc->token);
> +	return 0;
> +}
> +
> +static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
> +				      struct smb2_read_req *req, void *data_buf,
> +				      size_t length)
> +{
> +	struct smb2_buffer_desc_v1 *desc =
> +		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
> +	int err;
>
>  	err = ksmbd_conn_rdma_write(work->conn, data_buf, length,
>  				    le32_to_cpu(desc->token),
> @@ -6179,6 +6187,13 @@ int smb2_read(struct ksmbd_work *work)
>  		return smb2_read_pipe(work);
>  	}
>
> +	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
> +	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
> +		err = smb2_set_remote_key_for_rdma_read(work, req);
> +		if (err)
> +			goto out;
> +	}
> +
>  	fp = ksmbd_lookup_fd_slow(work, le64_to_cpu(req->VolatileFileId),
>  				  le64_to_cpu(req->PersistentFileId));
>  	if (!fp) {
> @@ -6352,17 +6367,11 @@ static noinline int smb2_write_pipe(struct
> ksmbd_work *work)
>  	return err;
>  }
>
> -static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
> -				       struct smb2_write_req *req,
> -				       struct ksmbd_file *fp,
> -				       loff_t offset, size_t length, bool sync)
> +static int smb2_set_remote_key_for_rdma_write(struct ksmbd_work *work,
> +					      struct smb2_write_req *req)
>  {
> -	struct smb2_buffer_desc_v1 *desc;
> -	char *data_buf;
> -	int ret;
> -	ssize_t nbytes;
> -
> -	desc = (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
> +	struct smb2_buffer_desc_v1 *desc =
> +		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
>
>  	if (work->conn->dialect == SMB30_PROT_ID &&
>  	    req->Channel != SMB2_CHANNEL_RDMA_V1)
> @@ -6378,6 +6387,20 @@ static ssize_t smb2_write_rdma_channel(struct
> ksmbd_work *work,
>  	work->need_invalidate_rkey =
>  		(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
>  	work->remote_key = le32_to_cpu(desc->token);
> +	return 0;
> +}
> +
> +static ssize_t smb2_write_rdma_channel(struct ksmbd_work *work,
> +				       struct smb2_write_req *req,
> +				       struct ksmbd_file *fp,
> +				       loff_t offset, size_t length, bool sync)
> +{
> +	struct smb2_buffer_desc_v1 *desc;
> +	char *data_buf;
> +	int ret;
> +	ssize_t nbytes;
> +
> +	desc = (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
>
>  	data_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
>  	if (!data_buf)
> @@ -6425,6 +6448,13 @@ int smb2_write(struct ksmbd_work *work)
>  		return smb2_write_pipe(work);
>  	}
>
> +	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
> +	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
> +		err = smb2_set_remote_key_for_rdma_write(work, req);
> +		if (err)
> +			goto out;
> +	}
> +
>  	if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
>  		ksmbd_debug(SMB, "User does not have write permission\n");
>  		err = -EACCES;
> --
> 2.25.1
>
>
