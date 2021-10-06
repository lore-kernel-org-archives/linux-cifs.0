Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57964C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 02:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3694D60EE3
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 02:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhJFCIh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 22:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhJFCIh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Oct 2021 22:08:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA1C360EE3
        for <linux-cifs@vger.kernel.org>; Wed,  6 Oct 2021 02:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633486005;
        bh=wAMGv/jbMDqpfv5ml+QnJlnzt5ConvjoZenAsy01lcM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=UWOghRf6t3BxPHvQRzqh9YaZrRvMAbw1Y9AnQyTXxApuU56vsGvE+rL42eBUBl1Dh
         g7MDMuIjgDhjHAZuvwBFwjen2hQ+ED7DAno0muTwh9k1Nhe0da1nVTR2V3A3BHF/8r
         crkGZGt7HLEtxovuLUu6KWIenoI+uvBrveCDwAJL0HBGr2Jmm+1X0ztzlMMKJ+0il5
         xgoxLq1W/IU31BbqVlX2vgsoLaKwkXknzS5+8sC47NoU+LHLmsphKj3LoDCKmRhQeY
         yFjGlT7xru5XZaLrPofDT2aPpTy2EGQhuLIQrnu9F7uHkRzPSuripDLS6KJXYI9iZ1
         1xMnpWJ/fY/0Q==
Received: by mail-oi1-f170.google.com with SMTP id t4so66387oie.5
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 19:06:45 -0700 (PDT)
X-Gm-Message-State: AOAM5336pR62QA7AK8an5OJM1KzRWf8DOUWto6R4w9whjWpH0sUyXF8U
        6+pmnhR5QZHzNfV8AaP1Bb5qUgAJemXEtZUCrc0=
X-Google-Smtp-Source: ABdhPJwrRrWIgte712ihDtVbXCIUiY1v72taHR0/sXLcb0Zp+3zekITNrTaNCilmXkAnLr0Iia6EKH9wdfEZjc1KWaU=
X-Received: by 2002:a05:6808:64f:: with SMTP id z15mr5009900oih.65.1633486005291;
 Tue, 05 Oct 2021 19:06:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Tue, 5 Oct 2021 19:06:44 -0700 (PDT)
In-Reply-To: <20211005100026.250280-1-hyc.lee@gmail.com>
References: <20211005100026.250280-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 6 Oct 2021 11:06:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9KuopMe8B_BrjxXDv+XZe6=_uWXoNXv6_f8YxYMAiTiA@mail.gmail.com>
Message-ID: <CAKYAXd9KuopMe8B_BrjxXDv+XZe6=_uWXoNXv6_f8YxYMAiTiA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: improve credits management
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Ralph Boehme <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

[snip]
>
> -	if (credits_requested > 0) {
> +	/* We must grant 0 credit for the final response of an asynchronous
> +	 * operation.
> +	 */
> +	if ((hdr->Flags & SMB2_FLAGS_ASYNC_COMMAND) && !work->multiRsp) {
Can you elaborate what is this check ? especially this !work->multiRsp..
> +		credits_granted = 0;
> +	} else {
> +		/* according to smb2.credits smbtorture, Windows server
> +		 * 2016 or later grant up to 8192 credits at one.
> +		 */
>  		aux_credits = credits_requested - 1;
> -		aux_max = 32;
>  		if (hdr->Command == SMB2_NEGOTIATE)
>  			aux_max = 0;
> -		aux_credits = (aux_credits < aux_max) ? aux_credits : aux_max;
> -		credits_granted = aux_credits + credit_charge;
> +		else
> +			aux_max = conn->max_credits - credit_charge;
> +		aux_credits = min_t(unsigned short, aux_credits, aux_max);
> +		credits_granted = credit_charge + aux_credits;
> +
> +		if (conn->max_credits - conn->total_credits < credits_granted)
> +			credits_granted = conn->max_credits -
> +				conn->total_credits;
>
> -		/* if credits granted per client is getting bigger than default
> -		 * minimum credits then we should wrap it up within the limits.
> -		 */
> -		if ((conn->total_credits + credits_granted) > min_credits)
> -			credits_granted = min_credits -	conn->total_credits;
>  		/*
>  		 * TODO: Need to adjuct CreditRequest value according to
>  		 * current cpu load
>  		 */
> -	} else if (conn->total_credits == 0) {
> -		credits_granted = 1;
>  	}
>
>  	conn->total_credits += credits_granted;
> @@ -371,7 +358,6 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
>  		/* Update CreditRequest in last request */
>  		hdr->CreditRequest = cpu_to_le16(work->credits_granted);
>  	}
> -out:
>  	ksmbd_debug(SMB,
>  		    "credits: requested[%d] granted[%d] total_granted[%d]\n",
>  		    credits_requested, credits_granted,
> @@ -692,13 +678,18 @@ int setup_async_work(struct ksmbd_work *work, void
> (*fn)(void **), void **arg)
>
>  void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
>  {
> -	struct smb2_hdr *rsp_hdr;
> +	struct smb2_hdr *rsp_hdr = work->response_buf;
> +
> +	work->multiRsp = 1;
> +	if (status != STATUS_CANCELLED) {
> +		spin_lock(&work->conn->credits_lock);
> +		smb2_set_rsp_credits(work);
Can you explain why this code is needed in smb2_send_interim_resp() ?

> +		spin_unlock(&work->conn->credits_lock);
> +	}
>
> -	rsp_hdr = work->response_buf;
>  	smb2_set_err_rsp(work);
>  	rsp_hdr->Status = status;
>
> -	work->multiRsp = 1;
>  	ksmbd_conn_write(work);
>  	rsp_hdr->Status = 0;
>  	work->multiRsp = 0;
> @@ -1233,6 +1224,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
>
>  	conn->srv_sec_mode = le16_to_cpu(rsp->SecurityMode);
>  	ksmbd_conn_set_need_negotiate(work);
> +	conn->total_credits = 0;
This line is needed ?

Thanks!
>
>  err_out:
>  	if (rc < 0)
> --
> 2.25.1
>
>
