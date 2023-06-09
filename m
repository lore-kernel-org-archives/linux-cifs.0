Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BE0C7EE29
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jun 2023 18:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjFISCc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Jun 2023 14:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjFISCb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Jun 2023 14:02:31 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603CA30F0
        for <linux-cifs@vger.kernel.org>; Fri,  9 Jun 2023 11:02:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1BC1321A8E;
        Fri,  9 Jun 2023 18:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686333749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ALpup1/so0RPDEzo/l90fLmBev//jdQ5UfKd1br/SY=;
        b=NO/qongHKiaEOPSU2K6PlLkzgv6utDL2vqc1i7TznlbneAx/GW4kQ8IyCc7/2lOZs9KiW+
        90ZCMkXe+FrIfH/A+goxRl4Cu6Y7e18mM7cj7PqkJhXeGWZz9s0oc8HRWItMuNc+G0BaKh
        Y1tJ8/BpOkBPt0IKNL5M8diXsqdWHtk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686333749;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ALpup1/so0RPDEzo/l90fLmBev//jdQ5UfKd1br/SY=;
        b=IRO6cDejcuMQWb9uRcyt62tWLdOMmSFWZREpzufxaYyC0efSvt4FDmjI0ggEQY+d0M9Rph
        qvq8czOuti3ms0AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8813D139C8;
        Fri,  9 Jun 2023 18:02:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GLFWEzRpg2SDJwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 09 Jun 2023 18:02:28 +0000
Date:   Fri, 9 Jun 2023 15:02:23 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, tom@talpey.com,
        Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
Message-ID: <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-4-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230609174659.60327-4-sprasad@microsoft.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

On 06/09, Shyam Prasad N wrote:
>With multichannel, it is useful to know the src port details
>for each channel. This change will print the ip addr and
>port details for both the socket dest and src endpoints.
>
>Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>---
> fs/smb/client/cifs_debug.c | 46 ++++++++++++++++++++++++++++++++++++++
> 1 file changed, 46 insertions(+)
>
>diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
>index 17c884724590..d5fd3681f56e 100644
>--- a/fs/smb/client/cifs_debug.c
>+++ b/fs/smb/client/cifs_debug.c
>@@ -12,6 +12,7 @@
> #include <linux/module.h>
> #include <linux/proc_fs.h>
> #include <linux/uaccess.h>
>+#include <net/inet_sock.h>
> #include "cifspdu.h"
> #include "cifsglob.h"
> #include "cifsproto.h"
>@@ -146,6 +147,30 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
> 		   in_flight(server),
> 		   atomic_read(&server->in_send),
> 		   atomic_read(&server->num_waiters));
>+
>+#ifndef CONFIG_CIFS_SMB_DIRECT
>+	if (server->ssocket) {
>+		if (server->dstaddr.ss_family == AF_INET6) {
>+			struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&server->dstaddr;
>+			struct sock *sk = server->ssocket->sk;
>+			struct inet_sock *inet = inet_sk(server->ssocket->sk);
>+			seq_printf(m, "\n\t\tIPv6 Dest: [%pI6]:%d Src: [%pI6]:%d",
>+				   &ipv6->sin6_addr,
>+				   ntohs(ipv6->sin6_port),
>+				   &sk->sk_v6_rcv_saddr.s6_addr32,
>+				   ntohs(inet->inet_sport));
>+		} else {
>+			struct sockaddr_in *ipv4 = (struct sockaddr_in *)&server->dstaddr;
>+			struct inet_sock *inet = inet_sk(server->ssocket->sk);
>+			seq_printf(m, "\n\t\tIPv4 Dest: %pI4:%d Src: %pI4:%d",
>+				   &ipv4->sin_addr,
>+				   ntohs(ipv4->sin_port),
>+				   &inet->inet_saddr,
>+				   ntohs(inet->inet_sport));
>+		}
>+	}
>+#endif
>+
> }
>
> static void
>@@ -351,6 +376,27 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
> 			atomic_read(&server->smbd_conn->mr_ready_count),
> 			atomic_read(&server->smbd_conn->mr_used_count));
> skip_rdma:
>+#else
>+		if (server->ssocket) {
>+			if (server->dstaddr.ss_family == AF_INET6) {
>+				struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&server->dstaddr;
>+				struct sock *sk = server->ssocket->sk;
>+				struct inet_sock *inet = inet_sk(server->ssocket->sk);
>+				seq_printf(m, "\nIPv6 Dest: [%pI6]:%d Src: [%pI6]:%d",
>+					   &ipv6->sin6_addr,
>+					   ntohs(ipv6->sin6_port),
>+					   &sk->sk_v6_rcv_saddr.s6_addr32,
>+					   ntohs(inet->inet_sport));
>+			} else {
>+				struct sockaddr_in *ipv4 = (struct sockaddr_in *)&server->dstaddr;
>+				struct inet_sock *inet = inet_sk(server->ssocket->sk);
>+				seq_printf(m, "\nIPv4 Dest: %pI4:%d Src: %pI4:%d",
>+					   &ipv4->sin_addr,
>+					   ntohs(ipv4->sin_port),
>+					   &inet->inet_saddr,
>+					   ntohs(inet->inet_sport));
>+			}
>+		}
> #endif
> 		seq_printf(m, "\nNumber of credits: %d,%d,%d Dialect 0x%x",
> 			server->credits,

You could save a lot of lines by using the generic formats for IP
addresses (Documentation/printk-formats.txt, look for "IPv4/IPv6
addresses (generic, with port, flowinfo, scope)").

e.g. using %pISpc will give you:
1.2.3.4:12345 for IPv4 or [1:2:3:4:5:6:7:8]:12345 for IPv6, just by
passing &server->dstaddr (without any casts), and you don't have to
check address family every time as well.

And to properly get the source IP being used by the socket there's
kernel_getpeername().

e.g.:
{
	...
	struct sockaddr src;
	int addrlen;

	addrlen = kernel_getpeername(server->ssocket, &src);
	if (addrlen != sizeof(struct sockaddr_in) && addrlen != sizeof(struct sockaddr_in6))
		continue; // skip or "return addrlen < 0 ? addrlen : -EAFNOSUPPORT;"
	...
	seq_print(m, "IP: src=%pISpc, dest=%pISpc", &server->dstaddr, &src);
	...
}


Cheers,

Enzo
