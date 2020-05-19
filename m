Return-Path: <SRS0=BTJv=7B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E45CC433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 16:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C9542075F
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 16:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgESQyQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 May 2020 12:54:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:34798 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbgESQyQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 19 May 2020 12:54:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AD5C0ADD2;
        Tue, 19 May 2020 16:54:17 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: How to verify multichannel
In-Reply-To: <2024477496.29432550.1589904923298.JavaMail.zimbra@redhat.com>
References: <1628934597.29140043.1589817685407.JavaMail.zimbra@redhat.com> <87k119maco.fsf@suse.com> <2024477496.29432550.1589904923298.JavaMail.zimbra@redhat.com>
Date:   Tue, 19 May 2020 18:54:13 +0200
Message-ID: <878shnn9vu.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Xiaoli Feng <xifeng@redhat.com> writes:
> Now I can see the multiple channel info in network package when mount with
> option "max_channel=2". If doesn't specify it. Client will only open one 
> channel.

That's correct.

> And my smb.conf setup below can work for multichannel. Seems server
> and client don't require multiple network interfaces. And also don't need 
> network team.

The client will try to reuse the same server interface if it has the RSS
capability flag set.

https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/fcd862d1-1b85-42df-92b1-e103199f531f

RSS flag means that this server interface can handle things in parallel
efficiently.

> But When test seedup, it isn't change. I use two vm in the same host. And
> each have 4 cpu and 1G memory. Maybe it's the problem.

Maybe the problem is not the number of CPU but the virtual network bus
bandwidth.

Let me explain: forget SMB and measure network speed (with iperf)
between 2 VMs. Let's say you get 1GB/s.

Now you add a virtual interface to the server VM and measure again on the 2
interfaces *at the same time*. You will see at most 500MB/s on each.

If you want to measure speedup, you need to limit the bandwidth of the
server interfaces with tc so that when you max out the server interface
bandwidth, you don't also max out the total virtual bus bandwidth.
If you limit 1MB/s on each, 1+1 = 2MB/s which is still << 1GB/s but you
will get speedup of 2.

> Thanks so much.

No problem :)

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
