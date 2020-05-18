Return-Path: <SRS0=5fY1=7A=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3780BC433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 18 May 2020 17:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 138D620829
	for <linux-cifs@archiver.kernel.org>; Mon, 18 May 2020 17:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgERRRO convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 May 2020 13:17:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:36560 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgERRRO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 18 May 2020 13:17:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5ABF2B184;
        Mon, 18 May 2020 17:17:15 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Xiaoli Feng <xifeng@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: How to verify multichannel
In-Reply-To: <1628934597.29140043.1589817685407.JavaMail.zimbra@redhat.com>
References: <1628934597.29140043.1589817685407.JavaMail.zimbra@redhat.com>
Date:   Mon, 18 May 2020 19:17:11 +0200
Message-ID: <87k119maco.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Xiaoli,

Xiaoli Feng <xifeng@redhat.com> writes:
> Hello,
>
> When I test multichannel. I don't know how to verify if it works. I just catch network
> packages to see if server and client communicate with multiple IP. But from my test, it
> doesn't. Does any one know how to verify multichannel?

Testing if it works vs checking speed improvement are 2 different
things unfortunately.

Source code
===========

First you need the latest patchset which is available on my github remote:

    https://github.com/aaptel/linux.git

You can use the "multichan-page" branch or you can extract the last
patches of it (with "multichannel:" in the title). These patches add the
multichannel support to the main read/write codepaths from memory pages.

Client setup
============

Then you need to mount with "vers=3.11,multichannel,max_channels=N" where N
will be the total number of channels the client will try to open.

Do a network capture of the mount and run couple of commands in the
mount point (ls, cat, stat, ...).

If the client also has multiple interface, make sure you capture all
interfaces traffic (otherwise you might ignore the other channels).

Interface list check
====================

Look at the trace in wireshark and use "smb2" filter.

Look for "Ioctl Response FSCTL_QUERY_NETWORK_INTERFACE_INFO", if the
server has multiple interfaces you should see a list.

You can also look at /proc/fs/cifs/DebugDate to see the list of
interfaces the client saw and has connected to.

Multichannel check
==================

Still in wireshark:
- right-click on the first "Negotiate protocol" packet
- "Colorize conversation" > "F5 TCP"

You can repeat this for each channel to see clearly different colors for
each channels.

I have made some screenshots, maybe this can help:

https://imgur.com/a/j3IBewF

You can see the alternating colors in my traces that shows different
channels being used.

Speedup check
=============

Now this is the hard part.

If you test with VMs and the interface are "virtual", when you make 2
channels you are actually just dividing by 2 the bandwidth of the
virtual bus, so you won't see much speedup. 

To see a speedup you need to limit the bandwidth of the server
interface, for example 1MB/s to each, so that together with 2 channel
you might see 2MB/s.

You can look into iperf to check raw bandwidth and tc to limit it:
- https://iperf.fr/
- https://netbeez.net/blog/how-to-use-the-linux-traffic-control/

Also similarly if the VM only has 1 CPU you might not see much
improvement as it will switch from one NIC to the other sequentially
instead of in parallel.

This gets tricky very quick...


> Setup:
> server is samba server in linux upstream.
> client is linux upstream.
> smb.conf is:
> [global]
> interfaces = eth1, eth2, team0
> server multi channel support = yes
> vfs objects = recycle aio_pthread
> aio read size = 1
> aio write size = 1
> [cifs]
> path=/mnt/cifs
> writeable=yes

This looks ok but I've mostly used Windows Server 2019 in my test.

Let me know how it goes.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
