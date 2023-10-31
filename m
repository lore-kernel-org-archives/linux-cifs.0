Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A51DC4167B
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Oct 2023 15:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344689AbjJaPTo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 11:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344756AbjJaPTo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 11:19:44 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E0B1BC5
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 08:18:21 -0700 (PDT)
Message-ID: <364e6840dba943b3d23e5b50b793550d.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698765498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pu0rl9d2zICtGR2C9PV7BqpjSP6H7Sp24F9TBCXtkqA=;
        b=P7c8Jmfbv52VNjjh7LHDTdSpzyNul7k1SHA5DQOsCDHcIAuy4ZsiOQcM2VH/RvuKInkMr/
        DT+tC64NHTMEmruMYd6m6Sn8vFQY2DbLrfZp3CW18SmB98CApl2Ee9WdaNaDd1jJ3PVvaL
        w7FHMdphhUme0PiY0+0tjn+rpScNB1RYmiVyP/fy3S6LmThBJM9+Bnw5mGqe+zJ5uZlRd+
        pyLvF25etSXyVWx3WV/KvGt/0rdmPlv6o2aQp2ejEgb0wCqgwhSjHghzANn09LjnFTwxYW
        z2ZZ1BxxaVUDtKofTslsRYGpJ81TCim+T8/yleqN+B+5BXrhqs0YpoW/fbdfog==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1698765498; a=rsa-sha256;
        cv=none;
        b=XtnDIs+vko0K/uLOmyWdjbznI4GbiDDwG2hrDe0N2sa1jocNhWz3Anm0tReslUJnc0I98X
        b/7ZiZlz9WOAw+DJM0Au20oH0sNaIiIYyG+/onTU3l9ZTspRRDj7xjKlNUp8R6L142Lx6l
        yCx9Vi60d2AxYXMGuWuCNrUwa7PskGnJtfK7M8uFB//U9yT0hFFLIlJZerJo7i4HzjjWI5
        1NrosEoQ6iqQx8qA6A4aI48FQ/0ILpASe9YCGrD0eJM4vvv8dHwB9dfVLhtxjiAs0OqWif
        tk9sciwvCxkA9FgPMi0zGOKy04j5XVeIgTrQQyyx3lIwO+S2dv3zUoqLgfY4TQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698765498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pu0rl9d2zICtGR2C9PV7BqpjSP6H7Sp24F9TBCXtkqA=;
        b=EeRoJivyRuabqJFKvgfwakaoMeHX2CqJhJyV0Z24Y2BHM4qNdrqXJYDPmNQd9gYzAxlOv1
        oye7FVTdcxlrRPXMzmdgeySKdAoRkr1wOtrIpboIQh9tGLfY+sGoIhxjLU6MUF1yHWg7GB
        a+Zb/zTnikfW/MeqMZs70sV/DCIgYS6PPon95r2uHclIAepwia2qgeeIf69lX3C9XFTGyu
        8JqEkAmoNVt+Vt3ScJYi6fi77GgxSKE1Q6zhez/4QUisE+E/PN3Uz8JBKuCxHbWXPM6YDy
        Mj5ubfkinz7Bd83Bg8fytKAchWfSAzSgAMl4a87BPRU9NYD6Y5aHAWq5JMHhcA==
From:   Paulo Alcantara <pc@manguebit.com>
To:     nspmangalore@gmail.com, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 13/14] cifs: display the endpoint IP details in DebugData
In-Reply-To: <20231030110020.45627-13-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-13-sprasad@microsoft.com>
Date:   Tue, 31 Oct 2023 12:18:14 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

nspmangalore@gmail.com writes:

> From: Shyam Prasad N <sprasad@microsoft.com>
>
> With multichannel, it is useful to know the src port details
> for each channel. This change will print the ip addr and
> port details for both the socket dest and src endpoints.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifs_debug.c | 73 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 71 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index e23fcabb78d6..d8362e098310 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -13,6 +13,7 @@
>  #include <linux/proc_fs.h>
>  #include <linux/uaccess.h>
>  #include <uapi/linux/ethtool.h>
> +#include <net/inet_sock.h>
>  #include "cifspdu.h"
>  #include "cifsglob.h"
>  #include "cifsproto.h"
> @@ -158,11 +159,37 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
>  		   in_flight(server),
>  		   atomic_read(&server->in_send),
>  		   atomic_read(&server->num_waiters));
> +
>  #ifdef CONFIG_NET_NS
>  	if (server->net)
>  		seq_printf(m, " Net namespace: %u ", server->net->ns.inum);
>  #endif /* NET_NS */
>  
> +#ifdef CONFIG_CIFS_SMB_DIRECT

No need to check for CONFIG_CIFS_SMB_DIRECT as @server->{rdma,smbd_conn}
are always defined.

> +	if (!server->rdma)

cifs_rdma_enabled()?  To be consistent with other places.

> +		goto skip_rdma;
> +
> +	if (server->smbd_conn && server->smbd_conn->id) {
> +		struct rdma_addr *addr =
> +			&server->smbd_conn->id->route.addr;
> +		seq_printf(m, "\n\t\tIP addr: dst: %pISpc, src: %pISpc",
> +			   &addr->dst_addr, &addr->src_addr);
> +	}
> +
> +skip_rdma:
> +#endif

The goto is no longer necessary when removing above #ifdef.

> +	if (server->ssocket) {
> +		struct sockaddr src;
> +		int addrlen;
> +
> +		addrlen = kernel_getsockname(server->ssocket, &src);
> +		if (addrlen != sizeof(struct sockaddr_in) &&
> +		    addrlen != sizeof(struct sockaddr_in6))
> +			return;
> +
> +		seq_printf(m, "\n\t\tIP addr: dst: %pISpc, src: %pISpc",
> +			   &server->dstaddr, &src);
> +	}
>  }
>  
>  static inline const char *smb_speed_to_str(size_t bps)
> @@ -279,7 +306,7 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
>  static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>  {
>  	struct mid_q_entry *mid_entry;
> -	struct TCP_Server_Info *server;
> +	struct TCP_Server_Info *server, *nserver;
>  	struct TCP_Server_Info *chan_server;
>  	struct cifs_ses *ses;
>  	struct cifs_tcon *tcon;
> @@ -336,7 +363,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>  
>  	c = 0;
>  	spin_lock(&cifs_tcp_ses_lock);
> -	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
> +	list_for_each_entry_safe(server, nserver, &cifs_tcp_ses_list, tcp_ses_list) {
>  		/* channel info will be printed as a part of sessions below */
>  		if (SERVER_IS_CHAN(server))
>  			continue;
> @@ -414,8 +441,39 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>  		seq_printf(m, "\nMR mr_ready_count: %x mr_used_count: %x",
>  			atomic_read(&server->smbd_conn->mr_ready_count),
>  			atomic_read(&server->smbd_conn->mr_used_count));
> +		if (server->smbd_conn->id) {
> +			struct rdma_addr *addr =
> +				&server->smbd_conn->id->route.addr;
> +			seq_printf(m, "\nIP addr: dst: %pISpc, src: %pISpc",
> +				   &addr->dst_addr, &addr->src_addr);
> +		}
>  skip_rdma:
>  #endif
> +		if (server->ssocket) {
> +			struct sockaddr src;
> +			int addrlen;
> +
> +			/* kernel_getsockname can block. so drop the lock first */
> +			server->srv_count++;
> +			spin_unlock(&cifs_tcp_ses_lock);
> +
> +			addrlen = kernel_getsockname(server->ssocket, &src);
> +			if (addrlen != sizeof(struct sockaddr_in) &&
> +			    addrlen != sizeof(struct sockaddr_in6)) {
> +				cifs_put_tcp_session(server, 0);
> +				spin_lock(&cifs_tcp_ses_lock);
> +
> +				goto skip_addr_details;
> +			}

What about

			addrlen = kernel_getsockname(server->ssocket, &src);
			if (addrlen == sizeof(struct sockaddr_in) &&
			    addrlen == sizeof(struct sockaddr_in6)) {
                                seq_printf(m, "\nIP addr: dst: %pISpc, src: %pISpc",
				           &server->dstaddr, &src);
                                cifs_put_tcp_session(server, 0);
                                spin_lock(&cifs_tcp_ses_lock);
                        }

> +
> +			seq_printf(m, "\nIP addr: dst: %pISpc, src: %pISpc",
> +				   &server->dstaddr, &src);
> +
> +			cifs_put_tcp_session(server, 0);
> +			spin_lock(&cifs_tcp_ses_lock);
> +		}
> +
> +skip_addr_details:

Then you can get rid of this goto as well.

>  		seq_printf(m, "\nNumber of credits: %d,%d,%d Dialect 0x%x",
>  			server->credits,
>  			server->echo_credits,
> @@ -515,7 +573,18 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>  				seq_printf(m, "\n\n\tExtra Channels: %zu ",
>  					   ses->chan_count-1);
>  				for (j = 1; j < ses->chan_count; j++) {
> +					/*
> +					 * kernel_getsockname can block inside
> +					 * cifs_dump_channel. so drop the lock first
> +					 */
> +					server->srv_count++;
> +					spin_unlock(&cifs_tcp_ses_lock);
> +
>  					cifs_dump_channel(m, j, &ses->chans[j]);
> +
> +					cifs_put_tcp_session(server, 0);
> +					spin_lock(&cifs_tcp_ses_lock);

Here you are re-acquiring @cifs_tcp_ses_lock spinlock under
@ses->chan_lock, which will introduce deadlocks in threads calling
cifs_match_super(), cifs_signal_cifsd_for_reconnect(),
cifs_mark_tcp_ses_conns_for_reconnect(), cifs_find_smb_ses(), ...
