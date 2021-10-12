Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86179C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 08:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7014960E0B
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 08:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbhJLIF4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Oct 2021 04:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234807AbhJLID1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 12 Oct 2021 04:03:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F7CB60F23
        for <linux-cifs@vger.kernel.org>; Tue, 12 Oct 2021 08:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634025675;
        bh=/Y9syVzR36BZTXhD0qV3dUarZrAvgBkUHESv31elQr0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=s6v3bpuQL0Y2sunbb1uXfd/rX4GkPTKI7iGoA2/LnMa5qRRKekp0nuVOa533MAt2N
         zbMbHB1b/GKL/cHx7N58dqSi4mt6i8Ts+Sn472OpVxTi72byPNLjCMbeY8xPqbO27k
         29l+Ldad7TmlzahcCEAcQ7p3FYgoon8LTyiga2pgLYqnIxVg/DmMIk4aG6PWCUGZM1
         8h72mMSAH1XWcaz7aKB4fOKhcF+HVcwkW/G7HA8YeA4xQmvqt8/uiV0fGwDOr/pbVE
         ihAVBJkrTqAN+MjZm2xUUlSBt+JRk5QDYAgByWFxO54MbGUx+Yk5+P+0ddi7HzOQY0
         g6BKUBaF3xRdA==
Received: by mail-ot1-f47.google.com with SMTP id s18-20020a0568301e1200b0054e77a16651so8159993otr.7
        for <linux-cifs@vger.kernel.org>; Tue, 12 Oct 2021 01:01:15 -0700 (PDT)
X-Gm-Message-State: AOAM531u0rGW7AzuEgDAhrBwiXio2zNTyojGiZzh76zcu4xXTQ7ZONkt
        DBr29SFck0zg6VCOJelD7boV3fqeQkeqt0Nk6aQ=
X-Google-Smtp-Source: ABdhPJxQ2qPyiy3H0DoVICb7t2lMJ+EnSsyweyGK+A32dNnLtLeIbc3LzXyX6OVc3yEDprFNKQIJN3KW/zB72rsUr5E=
X-Received: by 2002:a05:6830:17da:: with SMTP id p26mr25324830ota.116.1634025674446;
 Tue, 12 Oct 2021 01:01:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Tue, 12 Oct 2021 01:01:14
 -0700 (PDT)
In-Reply-To: <20211011121404.26392-1-hyc.lee@gmail.com>
References: <20211011121404.26392-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 12 Oct 2021 17:01:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_5a7As-g+YBZve76bgyp=-axQyHt67d-B0Zy3EcyShJQ@mail.gmail.com>
Message-ID: <CAKYAXd_5a7As-g+YBZve76bgyp=-axQyHt67d-B0Zy3EcyShJQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add buffer validation for smb direct
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Ralph Boehme <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-11 21:14 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Add buffer validation for smb direct.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> ---
>  fs/ksmbd/transport_rdma.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index 3a7fa23ba850..18f50e06ad15 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -549,6 +549,10 @@ static void recv_done(struct ib_cq *cq, struct ib_wc
> *wc)
>
>  	switch (recvmsg->type) {
>  	case SMB_DIRECT_MSG_NEGOTIATE_REQ:
> +		if (wc->byte_len < sizeof(struct smb_direct_negotiate_req)) {
> +			put_empty_recvmsg(t, recvmsg);
> +			return;
> +		}
>  		t->negotiation_requested = true;
>  		t->full_packet_received = true;
>  		wake_up_interruptible(&t->wait_status);
> @@ -556,9 +560,18 @@ static void recv_done(struct ib_cq *cq, struct ib_wc
> *wc)
>  	case SMB_DIRECT_MSG_DATA_TRANSFER: {
>  		struct smb_direct_data_transfer *data_transfer =
>  			(struct smb_direct_data_transfer *)recvmsg->packet;
> -		int data_length = le32_to_cpu(data_transfer->data_length);
> +		int data_length;
                int data_length = le32_to_cpu(data_transfer->data_length);

>  		int avail_recvmsg_count, receive_credits;
>
> +		if (wc->byte_len < offsetof(struct smb_direct_data_transfer, padding) ||
> +		    (le32_to_cpu(data_transfer->data_length) > 0 &&
> +		     wc->byte_len < sizeof(struct smb_direct_data_transfer) +
> +		     le32_to_cpu(data_transfer->data_length))) {
32bit overflow is possible here?

> +			put_empty_recvmsg(t, recvmsg);
> +			return;
> +		}
> +
> +		data_length = le32_to_cpu(data_transfer->data_length);
this can be moved to the above to avoid redundant le conversion.

Thanks!
>  		if (data_length) {
>  			if (t->full_packet_received)
>  				recvmsg->first_segment = true;
> --
> 2.25.1
>
>
