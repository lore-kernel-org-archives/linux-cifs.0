Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6EBC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Jan 2022 00:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiADApK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Jan 2022 19:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiADApJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Jan 2022 19:45:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C7CC061761
        for <linux-cifs@vger.kernel.org>; Mon,  3 Jan 2022 16:45:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40D3CB80259
        for <linux-cifs@vger.kernel.org>; Tue,  4 Jan 2022 00:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A52C36AEB
        for <linux-cifs@vger.kernel.org>; Tue,  4 Jan 2022 00:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641257105;
        bh=SXvBaZdXV2SGMJBs3B/4biStiniZm9aZ9wymwKNqcC4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=stlckMb+BAMhuL8qiYCRDXuu08sa/RFCNkxMnNGv/+bRfRdS8Jaqus3O8WsNR4R/d
         YpktNyqdrOrSa2o2l9H4QZXwnHD8wagXmGtbsmc1eDvLJ7hPdU46Bt63xuyWRxYODR
         zheXEUvz6/t27lq+W+2op8PdYeBMhgkFH7A8nYrdA6KjisXXmyp5TPvDg6B+ZGu0D3
         ZNXwWd2XZsHMMCrKbg+7Q83gWBHF8O4EG7SboyyEO81M/SwYh7SQSn85xIDgzHkZrX
         3uHv6Zz2eBGlknccacIrmriWzjW/joftAc+ulSERn0HZ5AbDBI91ayBcRY1jR3hohC
         yKJh6WhXgXEVg==
Received: by mail-yb1-f169.google.com with SMTP id e202so60634009ybf.4
        for <linux-cifs@vger.kernel.org>; Mon, 03 Jan 2022 16:45:05 -0800 (PST)
X-Gm-Message-State: AOAM530NMWmS5SlGha3+2z5SpSAi+WW/zsp+6rveueQAzBVA1j1mgbSA
        pLl15S52QSv8KPvu6Qu7OThOd83MhLkWZv2NiKM=
X-Google-Smtp-Source: ABdhPJzCvNQV/yptqxx0Yq0TcynzPynTLIPvPKsb+7HliOSOXJo+hWJnHFBp0ugn7yxQeQpOnc6onco3SU6MpZUvzAk=
X-Received: by 2002:a25:d889:: with SMTP id p131mr56529969ybg.475.1641257104867;
 Mon, 03 Jan 2022 16:45:04 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:4357:b0:11e:f0cd:2c0e with HTTP; Mon, 3 Jan 2022
 16:45:04 -0800 (PST)
In-Reply-To: <20220103000203.201107-1-hyc.lee@gmail.com>
References: <20220103000203.201107-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 4 Jan 2022 09:45:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9GovqRjUKQHyKXMPPtaC_kZPs5+vi2cqZkQJmA41P0ig@mail.gmail.com>
Message-ID: <CAKYAXd9GovqRjUKQHyKXMPPtaC_kZPs5+vi2cqZkQJmA41P0ig@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: smbd: call rdma_accept() under CM handler
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-03 9:02 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> if CONFIG_LOCKDEP is enabled, the following
> kernel warning message is generated because
> rdma_accept() is called not under CM(Connection
> Manager) handler.
>
> [   63.211405 ] WARNING: CPU: 1 PID: 345 at
> drivers/infiniband/core/cma.c:4405 rdma_accept+0x17a/0x350
> [   63.212080 ] RIP: 0010:rdma_accept+0x17a/0x350
> ...
> [   63.214036 ] Call Trace:
> [   63.214098 ]  <TASK>
> [   63.214185 ]  smb_direct_accept_client+0xb4/0x170 [ksmbd]
> [   63.214412 ]  smb_direct_prepare+0x322/0x8c0 [ksmbd]
> [   63.214555 ]  ? rcu_read_lock_sched_held+0x3a/0x70
> [   63.214700 ]  ksmbd_conn_handler_loop+0x63/0x270 [ksmbd]
> [   63.214826 ]  ? ksmbd_conn_alive+0x80/0x80 [ksmbd]
> [   63.214952 ]  kthread+0x171/0x1a0
> [   63.215039 ]  ? set_kthread_struct+0x40/0x40
> [   63.215128 ]  ret_from_fork+0x22/0x30
I could not understand why lockdep trigger this warning.
Could you elaborate more ?

>
> To avoid this, move creating a queue pair and accepting
> a client from transport_ops->prepare() to
> smb_direct_handle_connect_request().
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> ---
>  fs/ksmbd/transport_rdma.c | 97 +++++++++++++++++++++++----------------
>  1 file changed, 57 insertions(+), 40 deletions(-)
>
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index f89b64e27836..b37e4b9580ae 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -568,6 +568,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc
> *wc)
>  		}
>  		t->negotiation_requested = true;
>  		t->full_packet_received = true;
> +		enqueue_reassembly(t, recvmsg, 0);
Is this a fix related to this patch?
>  		wake_up_interruptible(&t->wait_status);
>  		break;
>  	case SMB_DIRECT_MSG_DATA_TRANSFER: {
> @@ -1594,19 +1595,13 @@ static int smb_direct_accept_client(struct
> smb_direct_transport *t)
>  		pr_err("error at rdma_accept: %d\n", ret);
>  		return ret;
>  	}
> -
> -	wait_event_interruptible(t->wait_status,
> -				 t->status != SMB_DIRECT_CS_NEW);
> -	if (t->status != SMB_DIRECT_CS_CONNECTED)
> -		return -ENOTCONN;
>  	return 0;
>  }
>
> -static int smb_direct_negotiate(struct smb_direct_transport *t)
> +static int smb_direct_prepare_negotiation(struct smb_direct_transport *t)
>  {
>  	int ret;
>  	struct smb_direct_recvmsg *recvmsg;
> -	struct smb_direct_negotiate_req *req;
>
>  	recvmsg = get_free_recvmsg(t);
>  	if (!recvmsg)
> @@ -1616,44 +1611,20 @@ static int smb_direct_negotiate(struct
> smb_direct_transport *t)
>  	ret = smb_direct_post_recv(t, recvmsg);
>  	if (ret) {
>  		pr_err("Can't post recv: %d\n", ret);
> -		goto out;
> +		goto out_err;
>  	}
>
>  	t->negotiation_requested = false;
>  	ret = smb_direct_accept_client(t);
>  	if (ret) {
>  		pr_err("Can't accept client\n");
> -		goto out;
> +		goto out_err;
>  	}
>
>  	smb_direct_post_recv_credits(&t->post_recv_credits_work.work);
> -
> -	ksmbd_debug(RDMA, "Waiting for SMB_DIRECT negotiate request\n");
> -	ret = wait_event_interruptible_timeout(t->wait_status,
> -					       t->negotiation_requested ||
> -						t->status == SMB_DIRECT_CS_DISCONNECTED,
> -					       SMB_DIRECT_NEGOTIATE_TIMEOUT * HZ);
> -	if (ret <= 0 || t->status == SMB_DIRECT_CS_DISCONNECTED) {
> -		ret = ret < 0 ? ret : -ETIMEDOUT;
> -		goto out;
> -	}
> -
> -	ret = smb_direct_check_recvmsg(recvmsg);
> -	if (ret == -ECONNABORTED)
> -		goto out;
> -
> -	req = (struct smb_direct_negotiate_req *)recvmsg->packet;
> -	t->max_recv_size = min_t(int, t->max_recv_size,
> -				 le32_to_cpu(req->preferred_send_size));
> -	t->max_send_size = min_t(int, t->max_send_size,
> -				 le32_to_cpu(req->max_receive_size));
> -	t->max_fragmented_send_size =
> -			le32_to_cpu(req->max_fragmented_size);
> -
> -	ret = smb_direct_send_negotiate_response(t, ret);
> -out:
> -	if (recvmsg)
> -		put_recvmsg(t, recvmsg);
> +	return 0;
> +out_err:
> +	put_recvmsg(t, recvmsg);
>  	return ret;
>  }
>
> @@ -1890,6 +1861,47 @@ static int smb_direct_create_qpair(struct
> smb_direct_transport *t,
>  static int smb_direct_prepare(struct ksmbd_transport *t)
>  {
>  	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
> +	struct smb_direct_recvmsg *recvmsg;
> +	struct smb_direct_negotiate_req *req;
> +	int ret;
> +
> +	ksmbd_debug(RDMA, "Waiting for SMB_DIRECT negotiate request\n");
> +	ret = wait_event_interruptible_timeout(st->wait_status,
> +					       st->negotiation_requested ||
> +					       st->status == SMB_DIRECT_CS_DISCONNECTED,
> +					       SMB_DIRECT_NEGOTIATE_TIMEOUT * HZ);
> +	if (ret <= 0 || st->status == SMB_DIRECT_CS_DISCONNECTED)
> +		return ret < 0 ? ret : -ETIMEDOUT;
> +
> +	recvmsg = get_first_reassembly(st);
> +	if (!recvmsg)
> +		return -ECONNABORTED;
> +
> +	ret = smb_direct_check_recvmsg(recvmsg);
> +	if (ret == -ECONNABORTED)
> +		goto out;
> +
> +	req = (struct smb_direct_negotiate_req *)recvmsg->packet;
> +	st->max_recv_size = min_t(int, st->max_recv_size,
> +				  le32_to_cpu(req->preferred_send_size));
> +	st->max_send_size = min_t(int, st->max_send_size,
> +				  le32_to_cpu(req->max_receive_size));
> +	st->max_fragmented_send_size =
> +			le32_to_cpu(req->max_fragmented_size);
> +
> +	ret = smb_direct_send_negotiate_response(st, ret);
> +out:
> +	spin_lock_irq(&st->reassembly_queue_lock);
> +	st->reassembly_queue_length--;
> +	list_del(&recvmsg->list);
> +	spin_unlock_irq(&st->reassembly_queue_lock);
> +	put_recvmsg(st, recvmsg);
> +
> +	return ret;
> +}
> +
> +static int smb_direct_connect(struct smb_direct_transport *st)
> +{
>  	int ret;
>  	struct ib_qp_cap qp_cap;
>
> @@ -1911,13 +1923,11 @@ static int smb_direct_prepare(struct ksmbd_transport
> *t)
>  		return ret;
>  	}
>
> -	ret = smb_direct_negotiate(st);
> +	ret = smb_direct_prepare_negotiation(st);
>  	if (ret) {
>  		pr_err("Can't negotiate: %d\n", ret);
>  		return ret;
>  	}
> -
> -	st->status = SMB_DIRECT_CS_CONNECTED;
>  	return 0;
>  }
>
> @@ -1933,6 +1943,7 @@ static bool rdma_frwr_is_supported(struct
> ib_device_attr *attrs)
>  static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id)
>  {
>  	struct smb_direct_transport *t;
> +	int ret;
>
>  	if (!rdma_frwr_is_supported(&new_cm_id->device->attrs)) {
>  		ksmbd_debug(RDMA,
> @@ -1945,11 +1956,17 @@ static int smb_direct_handle_connect_request(struct
> rdma_cm_id *new_cm_id)
>  	if (!t)
>  		return -ENOMEM;
>
> +	ret = smb_direct_connect(t);
> +	if (ret) {
> +		free_transport(t);
> +		return ret;
I think that it is better to use goto statement to out after freeing
transport structure.
> +	}
> +
>  	KSMBD_TRANS(t)->handler = kthread_run(ksmbd_conn_handler_loop,
>  					      KSMBD_TRANS(t)->conn, "ksmbd:r%u",
>  					      smb_direct_port);
>  	if (IS_ERR(KSMBD_TRANS(t)->handler)) {
> -		int ret = PTR_ERR(KSMBD_TRANS(t)->handler);
> +		ret = PTR_ERR(KSMBD_TRANS(t)->handler);
>
>  		pr_err("Can't start thread\n");
>  		free_transport(t);
> --
> 2.25.1
>
>
