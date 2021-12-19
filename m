Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2ACC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Dec 2021 22:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbhLSWZs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 19 Dec 2021 17:25:48 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:38880 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhLSWZr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 19 Dec 2021 17:25:47 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8C9861F37B;
        Sun, 19 Dec 2021 22:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639952746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cNj5DlnCHyjaPrWIau4XhkrXVY1jEriZcdRQj3Namjo=;
        b=Yh763UTixeLAfh7ho0Yg0vCQL5sAxSo0RsPtXIUsvLf3NuDeq3Hskapog+e3gT+Ewkn9kw
        6TSUFytsybLP4a1VeVu1HVs/X2IlI5msZxQa3bLmVWAEZOi5mZa46arppkWttgvLGqNmZM
        6XgHOJI1qyE+po96nEhaVeVMcDONxMI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639952746;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cNj5DlnCHyjaPrWIau4XhkrXVY1jEriZcdRQj3Namjo=;
        b=GDb/FrsLYJNoxSVLIG8xF/0bNztWmMJXlMK9X5RiL7HUfVuMrNAeihgX3SXKxfu9p95DpU
        rhvasxV8/WHGAAAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 00801133FE;
        Sun, 19 Dec 2021 22:25:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ot4ULWmxv2F7SAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sun, 19 Dec 2021 22:25:45 +0000
Date:   Sun, 19 Dec 2021 19:25:43 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: invalidate dns resolver keys after use
Message-ID: <20211219222214.zetr4d26qqumqgub@cyberdelia>
References: <CANT5p=rxedYesnqitKypJ3X9YU6eANo4zSDid_aKjk7EBCDStg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANT5p=rxedYesnqitKypJ3X9YU6eANo4zSDid_aKjk7EBCDStg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

On 12/18, Shyam Prasad N wrote:
>Hi Steve/Paulo/David,
>
>Please review the attached patch.
>
>I noticed that DNS resolution did not always upcall to userspace when
>the IP address changed. This addresses the fix for it.
>
>I would even recommend CC:stable for this one.

(I'm pasting the patch here so I can comment inline)

> From 604ab4c350c2552daa8e77f861a54032b49bc706 Mon Sep 17 00:00:00 2001
> From: Shyam Prasad N <sprasad@microsoft.com>
> Date: Sat, 18 Dec 2021 17:28:10 +0000
> Subject: [PATCH] cifs: invalidate dns resolver keys after use
> 
> We rely on dns resolver module to upcall to userspace
> using request_key and get us the DNS mapping.
> However, the invalidate arg for dns_query was set
> to false, which meant that the key created during the
> first call for a hostname would continue to be cached
> till it expires. This expiration period depends on
> how the dns_resolver is configured.

Ok.

> 
> Fixing this by setting invalidate=true during dns_query.
> This means that the key will be cleaned up by dns_resolver
> soon after it returns the data. This also means that
> the dns_resolver subsystem will not cache the key for
> an interval indicated by the DNS records TTL.

This is ok too, which is an approach that I did try before, but
didn't work (see below).

> But this is
> okay since we use the TTL value returned to schedule the
> next lookup.

This is an incorrect assumption. keyutils' key.dns_resolve uses
getaddrinfo() for A/AAAA queries, which doesn't contain DNS TTL
information.

Meaning that the TTL returned to dns_resolve_server_name_to_ip() is
actually either key.dns_resolve.conf's default_ttl value, or the default
key_expiry value (5).

I have a patch ready (working, but still testing) for keyutils that implements
a "common" DNS interface, and the caller only specifies the query type,
which is then resolved via res_nquery(). This way, all returned records
have generic their metadata (TTL included), along with type-specific
metadata (e.g. AFSDB or SRV specifics) as well.

Another option/suggestion would be to:
1. decrease SMB_DNS_RESOLVE_INTERVAL_DEFAULT
2. and/or make it user-configurable via sysfs
3. call dns_query() with expiry=NULL and invalidate=true

So we'd use keyutils exclusively for kernel-userspace communication, and
handle the expiration checking/configuration on cifs side.

> 
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/cifs/dns_resolve.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
> index 0458d28d71aa..8890af1537ef 100644
> --- a/fs/cifs/dns_resolve.c
> +++ b/fs/cifs/dns_resolve.c
> @@ -66,7 +66,7 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr, time64_t *expiry)
>  
>  	/* Perform the upcall */
>  	rc = dns_query(current->nsproxy->net_ns, NULL, hostname, len,
> -		       NULL, ip_addr, expiry, false);
> +		       NULL, ip_addr, expiry, true);
>  	if (rc < 0)
>  		cifs_dbg(FYI, "%s: unable to resolve: %*.*s\n",
>  			 __func__, len, len, hostname);


Cheers,

Enzo
