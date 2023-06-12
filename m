Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBB4C88CB2
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Jun 2023 14:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbjFLODz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Jun 2023 10:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbjFLODy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Jun 2023 10:03:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD711A1
        for <linux-cifs@vger.kernel.org>; Mon, 12 Jun 2023 07:03:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 76AF122832;
        Mon, 12 Jun 2023 14:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686578632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z5fg1G72QJusOKCsnWfdIrbgNgEZN3koqTLefr5q62s=;
        b=jHi/EQwCdSSQQvlwZ8shnhZZw/vQp/H1kYZ14E9aLJ3Gw4h6HlR/TIf2KbD+zcYHMdiWqy
        QBPTE4G6o0kRHh2WMaA/nmgC+WQ2G/DB4EsWLCMXKZiLwsUIlM0KgGOkS2vhNa2uRUXkKU
        FfMtveAKggD6TkEozKIjVDrsWdcoCDc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686578632;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z5fg1G72QJusOKCsnWfdIrbgNgEZN3koqTLefr5q62s=;
        b=3P6rjI76ojZKAtyQ9h7KqskEsl5dJ0pb7Oeco+9Gs6ID3xAwwuKB99uNf/xb7Z7dlOFYij
        0YGHNbPUr/xmQNAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EF87F1357F;
        Mon, 12 Jun 2023 14:03:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zhfxK8clh2S1FAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 12 Jun 2023 14:03:51 +0000
Date:   Mon, 12 Jun 2023 11:03:27 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, tom@talpey.com,
        Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
Message-ID: <lj2b7s62nshohxchqapouawdth7q4ldke6akcil6ydncg6dpoj@dkeyhujorgyi>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
 <CANT5p=qZrNZTzaNVpf6GW5hMDn9npCOM-PXyDXXQPxuETZ4BcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANT5p=qZrNZTzaNVpf6GW5hMDn9npCOM-PXyDXXQPxuETZ4BcA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

On 06/12, Shyam Prasad N wrote:
...
>Attached the patch now. :)

(inlining the attached patch here)

> From f7b46503129ac12cd3c1240ac58d7acb050e56ae Mon Sep 17 00:00:00 2001
> From: Shyam Prasad N <sprasad@microsoft.com>
> Date: Fri, 9 Jun 2023 12:46:34 +0000
> Subject: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
> 
> With multichannel, it is useful to know the src port details
> for each channel. This change will print the ip addr and
> port details for both the socket dest and src endpoints.
> 
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifs_debug.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index 17c884724590..a8f7b4c49ae3 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -12,6 +12,7 @@
>  #include <linux/module.h>
>  #include <linux/proc_fs.h>
>  #include <linux/uaccess.h>
> +#include <net/inet_sock.h>
>  #include "cifspdu.h"
>  #include "cifsglob.h"
>  #include "cifsproto.h"
> @@ -146,6 +147,22 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
>  		   in_flight(server),
>  		   atomic_read(&server->in_send),
>  		   atomic_read(&server->num_waiters));
> +
> +#ifndef CONFIG_CIFS_SMB_DIRECT
> +	if (server->ssocket) {
> +		struct sockaddr src;
> +		int addrlen;
> +
> +		addrlen = kernel_getsockname(server->ssocket, &src);
> +		if (addrlen != sizeof(struct sockaddr_in) && addrlen != sizeof(struct sockaddr_in6))
> +			goto skip_addr_details;
> +
> +		seq_printf(m, "\n\t\tIP addr: dst: %pISpc, src: %pISpc", &server->dstaddr, &src);
> +	}
> +
> +skip_addr_details:

(nitpicking now)
I'd just check if addrlen is == sizeof(struct sockadr_{in,in6}) and seq_printf() if true, then
remove the skip_addr_details goto/label.

> +#endif
> +
>  }
>  
>  static void
> @@ -351,6 +368,19 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>  			atomic_read(&server->smbd_conn->mr_ready_count),
>  			atomic_read(&server->smbd_conn->mr_used_count));
>  skip_rdma:
> +#else
> +		if (server->ssocket) {
> +			struct sockaddr src;
> +			int addrlen;
> +
> +			addrlen = kernel_getsockname(server->ssocket, &src);
> +			if (addrlen != sizeof(struct sockaddr_in) && addrlen != sizeof(struct sockaddr_in6))
> +				goto skip_addr_details;
> +
> +			seq_printf(m, "\nIP addr: dst: %pISpc, src: %pISpc", &server->dstaddr, &src);
> +		}
> +
> +skip_addr_details:

Ditto.

>  #endif
>  		seq_printf(m, "\nNumber of credits: %d,%d,%d Dialect 0x%x",
>  			server->credits,
> -- 
> 2.34.1

But it looks much cleaner now.  Thanks.

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers
