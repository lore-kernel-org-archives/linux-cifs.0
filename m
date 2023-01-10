Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E775BC54EBC
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 17:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbjAJRUs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 12:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbjAJRUA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 12:20:00 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DF65E0B2
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 09:18:57 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2991238648;
        Tue, 10 Jan 2023 17:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673371136; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p1CV/63olESn0tD73PTlbErS/qrVB0kEePgJ1lgLL4w=;
        b=iURI2jtbD91wC0FkAtGVO1xnZYdBruXIZNNETgNJBr1aAMbsqCihrVRhBATfDffDyvNx6r
        oUF6ZEDfcH+y/rPilmTzPjbKv5NaaE2ck3hxJYWPmQMWqqmfd6hdQzePEkmqjiGe8n4VFZ
        D1lNuksPIX57jajltaWYvT7BxRgdmHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673371136;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p1CV/63olESn0tD73PTlbErS/qrVB0kEePgJ1lgLL4w=;
        b=/8n7+6b/F81xxXyyv71EqayJFg5TCbHaEL0Cp9zZ95puB2x7tjKndkuloKZfXLNrMYyC2L
        d3CUpn/tH3GKFqDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A20071358A;
        Tue, 10 Jan 2023 17:18:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id B550Gf+dvWP4PAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 10 Jan 2023 17:18:55 +0000
Date:   Tue, 10 Jan 2023 14:18:53 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>,
        =?utf-8?B?QXVyw6lsaWVu?= Aptel <aurelien.aptel@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: Connection sharing in SMB multichannel
Message-ID: <20230110171853.ysh7svc5gxgnzlxp@suse.de>
References: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

I 100% agree with your proposed changes. I came up with an idea and got
to draw a diagram a while ago that would handle multichannel connections
in a similar way you propose here.

https://exis.tech/cifs-multicore-multichannel.png

The main idea is to have the 'channels' (sockets) pool for a particular
server, but also create submission/receiving queues (SQ/RQ) (similar to NVMe
and io_uring) for each online CPU.  Then each CPU/queue is free to send
to any of the available channels, based on whatever algorithm is chosen
(RR, free channel, fastest NIC, etc).

I still haven't got time to design the receiving flow, but it shouldn't
change much from the reverse of the sending side.

Of course, there's a lot to improve/fix in that design, but something I
thought would enhance cifs multichannel performance a lot.

I've discussed this idea with Paulo a while back, and he already
provided me with great improvements/fixes for this.  Since I still
haven't got the time to work on it, I hope this to serve as inspiration.


Cheers,

Enzo

On 01/10, Shyam Prasad N wrote:
>Hi all,
>
>I wanted to revisit the way we do a few things while doing
>multichannel mounts in cifs.ko:
>
>1.
>The way connections are organized today, the connections of primary
>channels of sessions can be shared among different sessions and their
>channels. However, connections to secondary channels are not shared.
>i.e. created with nosharesock.
>Is there a reason why we have it that way?
>We could have a pool of connections for a particular server. When new
>channels are to be created for a session, we could simply pick
>connections from this pool.
>Another approach could be not to share sockets for any of the channels
>of multichannel mounts. This way, multichannel would implicitly mean
>nosharesock. Assuming that multichannel is being used for performance
>reasons, this would actually make a lot of sense. Each channel would
>create new connection to the server, and take advantage of number of
>interfaces and RSS capabilities of server interfaces.
>I'm planning to take the latter approach for now, since it's easier.
>Please let me know about your opinions on this.
>
>2.
>Today, the interface list for a server hangs off the session struct. Why?
>Doesn't it make more sense to hang it off the server struct? With my
>recent changes to query the interface list from the server
>periodically, each tcon is querying this and keeping the results in
>the session struct.
>I plan to move this to the server struct too. And avoid having to
>query this too many times unnecessarily. Please let me know if you see
>a reason not to do this.
>
>3.
>I saw that there was a bug in iface_cmp, where we did not do full
>comparison of addresses to match them.
>Fixed it here:
>https://github.com/sprasad-microsoft/smb3-kernel-client/commit/cef2448dc43d1313571e21ce8283bccacf01978e.patch
>
>@Tom Talpey Was this your concern with iface_cmp?
>
>4.
>I also feel that the way an interface is selected today for
>multichannel will not scale.
>We keep selecting the fastest server interface, if it supports RSS.
>IMO, we should be distributing the requests among the server
>interfaces, based on the interface speed adveritsed.
>Something on these lines:
>https://github.com/sprasad-microsoft/smb3-kernel-client/commit/ebe1ac3426111a872d19fea41de365b1b3aca0fe.patch
>
>The above patch assigns weights to each interface (which is a function
>of it's advertised speed). The weight is 1 for the interface that is
>advertising minimum speed, and for any interface that does not support
>RSS.
>Please let me know if you have any opinions on this change.
>
>====
>Also, I did not find a good way to test out these changes yet i.e.
>customize and change the QueryInterface response from the server on
>successive requests.
>So I've requested Steve not to take this into his branch yet.
>
>I'm thinking I'll hard code the client code to generate different set
>of dummy interfaces on every QueryInterface call.
>Any ideas on how I can test this more easily will be appreciated.
>
>-- 
>Regards,
>Shyam
