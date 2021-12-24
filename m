Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167F8C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Dec 2021 07:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351796AbhLXH1E (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343514AbhLXH1E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Dec 2021 02:27:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097FCC061401
        for <linux-cifs@vger.kernel.org>; Thu, 23 Dec 2021 23:27:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4D8C61FF9
        for <linux-cifs@vger.kernel.org>; Fri, 24 Dec 2021 07:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C03C36AEA
        for <linux-cifs@vger.kernel.org>; Fri, 24 Dec 2021 07:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640330822;
        bh=TuO7323/TYFkHg3yHUdTAS0+LGyVcl3VzWjyKqRHaUw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=pmAIjPTKB9DRtVarbtcRmYTqhpK4+EeyrVzd025R49vygoaK52beG8XAen1ip9Mlo
         5iln6qmeF5pE23vaT8b1FiZzVM5t2q9IFAN675riL8ow5jy/myFrX6sFCzwMzwiCLm
         RL6X6dbpJsmBi8NheAC5JhAqrySYi+bGQLxKvXcpLghz5Np3MazTdhqp8Mxh9YEYlO
         PhSTgGBH+ffPo9XvJ58qqIQqsT+gdqHXaiAG5M0IRP9/rt7TE+EHQ1XLRpnITbdxA2
         WKFzH6NRMxyuwHxOrFtg3XzmLsFfMGSr3h+wBs4EVcoDHWW0CmV13P5A18xPlgEuZZ
         tWjrBER54lQvg==
Received: by mail-yb1-f181.google.com with SMTP id d10so23682823ybn.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Dec 2021 23:27:02 -0800 (PST)
X-Gm-Message-State: AOAM531W3NQm4cm7r5deyHiICCic2dXHK0pmYLUbLihLUzXiFAY2KGqV
        MLGDthro7XWWvsBdT7VexUCrLClTwvwKtD64Skg=
X-Google-Smtp-Source: ABdhPJydk85JczjKm2WvtBlDYe1hEvUH8Bam4LOdTe75EZK1h/dW4CBpZar+VbJXEXDbrvavyBY+Fn9bLxLrUUxJ3wE=
X-Received: by 2002:a25:7451:: with SMTP id p78mr7687512ybc.507.1640330821128;
 Thu, 23 Dec 2021 23:27:01 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:1313:b0:11b:f4cd:b869 with HTTP; Thu, 23 Dec 2021
 23:27:00 -0800 (PST)
In-Reply-To: <20211222224306.198076-1-hyc.lee@gmail.com>
References: <20211222224306.198076-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 24 Dec 2021 16:27:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_jZ8K2PgYkQbvJaAi4ByDn6o302=25ONi5e+6VwoDQHw@mail.gmail.com>
Message-ID: <CAKYAXd_jZ8K2PgYkQbvJaAi4ByDn6o302=25ONi5e+6VwoDQHw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: set the rdma capability of network adapter using ib_client
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-12-23 7:43 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Set the rdma capability using ib_clien, Because
> For some devices, ib_device_get_by_netdev() returns NULL.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> ---
>  fs/ksmbd/transport_rdma.c | 89 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 83 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index 7e57cbb0bb35..0820c6a9d75e 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -79,6 +79,14 @@ static int smb_direct_max_read_write_size = 1024 * 1024;
>
>  static int smb_direct_max_outstanding_rw_ops = 8;
>
> +static LIST_HEAD(smb_direct_device_list);
> +static DEFINE_RWLOCK(smb_direct_device_lock);
> +
> +struct smb_direct_device {
> +	struct ib_device	*ib_dev;
> +	struct list_head	list;
> +};
> +
>  static struct smb_direct_listener {
>  	struct rdma_cm_id	*cm_id;
>  } smb_direct_listener;
> @@ -2007,12 +2015,62 @@ static int smb_direct_listen(int port)
>  	return ret;
>  }
>
> +static int smb_direct_ib_client_add(struct ib_device *ib_dev)
> +{
> +	struct smb_direct_device *smb_dev;
> +
> +	if (!ib_dev->ops.get_netdev ||
> +	    ib_dev->node_type != RDMA_NODE_IB_CA ||
> +	    !rdma_frwr_is_supported(&ib_dev->attrs))
> +		return 0;
> +
> +	smb_dev = kzalloc(sizeof(*smb_dev), GFP_KERNEL);
> +	if (!smb_dev)
> +		return -ENOMEM;
> +	smb_dev->ib_dev = ib_dev;
> +
> +	write_lock(&smb_direct_device_lock);
> +	list_add(&smb_dev->list, &smb_direct_device_list);
> +	write_unlock(&smb_direct_device_lock);
> +
> +	ksmbd_debug(RDMA, "ib device added: name %s\n", ib_dev->name);
> +	return 0;
> +}
> +
> +static void smb_direct_ib_client_remove(struct ib_device *ib_dev,
> +					void *client_data)
> +{
When is this function called? Is rdma shutdown needed here?

> +	struct smb_direct_device *smb_dev, *tmp;
> +
> +	write_lock(&smb_direct_device_lock);
> +	list_for_each_entry_safe(smb_dev, tmp, &smb_direct_device_list, list) {
> +		if (smb_dev->ib_dev == ib_dev) {
> +			list_del(&smb_dev->list);
> +			kfree(smb_dev);
> +			break;
> +		}
> +	}
> +	write_unlock(&smb_direct_device_lock);
> +}
> +
> +static struct ib_client smb_direct_ib_client = {
> +	.name	= "ksmbd_smb_direct_ib",
Move smb_direct_ib_client_add and smb_direct_ib_client_remove to here.

> +};
> +
>  int ksmbd_rdma_init(void)
>  {
>  	int ret;
>
>  	smb_direct_listener.cm_id = NULL;
>
> +	smb_direct_ib_client.add = smb_direct_ib_client_add;
> +	smb_direct_ib_client.remove = smb_direct_ib_client_remove;
> +	ret = ib_register_client(&smb_direct_ib_client);
> +	if (ret) {
> +		pr_err("failed to ib_register_client\n");
> +		return ret;
> +	}
> +
>  	/* When a client is running out of send credits, the credits are
>  	 * granted by the server's sending a packet using this queue.
>  	 * This avoids the situation that a clients cannot send packets
> @@ -2046,20 +2104,39 @@ int ksmbd_rdma_destroy(void)
>  		destroy_workqueue(smb_direct_wq);
>  		smb_direct_wq = NULL;
>  	}
> +
> +	if (smb_direct_ib_client.add)
> +		ib_unregister_client(&smb_direct_ib_client);
> +	smb_direct_ib_client.add = NULL;
Why ?

>  	return 0;
>  }
>
>  bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
>  {
> -	struct ib_device *ibdev;
> +	struct smb_direct_device *smb_dev;
> +	int i;
>  	bool rdma_capable = false;
>
> -	ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
> -	if (ibdev) {
> -		if (rdma_frwr_is_supported(&ibdev->attrs))
> -			rdma_capable = true;
> -		ib_device_put(ibdev);
> +	read_lock(&smb_direct_device_lock);
> +	list_for_each_entry(smb_dev, &smb_direct_device_list, list) {
> +		for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
> +			struct net_device *ndev;
> +
> +			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
> +							       i + 1);
> +			if (!ndev)
> +				continue;
> +
> +			if (ndev == netdev) {
> +				dev_put(ndev);
> +				rdma_capable = true;
> +				goto out;
> +			}
> +			dev_put(ndev);
> +		}
>  	}
> +out:
> +	read_unlock(&smb_direct_device_lock);
>  	return rdma_capable;
>  }
>
> --
> 2.25.1
>
>
