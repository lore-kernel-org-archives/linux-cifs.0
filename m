Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 551C7C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jun 2022 18:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbiF3S2l (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jun 2022 14:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbiF3S2e (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jun 2022 14:28:34 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6E72DD5A
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 11:28:33 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id A070380266;
        Thu, 30 Jun 2022 18:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1656613711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cU5Zg5u61oFph+0IL8uOZXAIQnFFFImvqqkBBIgeK9Y=;
        b=txBY26xeAXK7x92CKv12Q8eQmuinz1MYanwx8D7JWXr5UWVMlBcKA5ltkltR+kQpI+jzIE
        sd0Nzo7xLVMIiV0U9Y02Yw2EXXvr6YlQSxAyEE9AzUFbMMtZLy0+ffej+Y8O21nWE8J79I
        gUQbYwJq707tgI/M7YeYHAVlQl+x47iFlzIY3pR3A0+HoGJUfqA/GgDWkAujIjUg7XlBvU
        cg8JPw7eIJzkxteajMiP1UBrmPcmGc5r4+OIyzMzBAOYjRbsKA2c5jy6FjKg9nbrOrhdg0
        xWqxC0oCH30Uyz2hBqcbMpXbZbXyPOQULJBTF8Lyn9U1rLz03cnmUapXtMktjg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Julian Sikorski <belegdol@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: kernel-5.18.8 breaks cifs mounts
In-Reply-To: <10efd255-16ea-6993-5e58-2d70e452a019@gmail.com>
References: <211885e7-1823-9118-836b-169c7163d7c2@gmail.com>
 <CAN05THTbuBSF6HXh5TAThchJZycU1AwiQkA0W7hDwCwKOF+4kw@mail.gmail.com>
 <fee59438-7b4a-0a24-f116-07c2ac39a3ad@gmail.com> <87h7423ukh.fsf@cjr.nz>
 <10efd255-16ea-6993-5e58-2d70e452a019@gmail.com>
Date:   Thu, 30 Jun 2022 15:28:26 -0300
Message-ID: <87edz63t11.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Julian Sikorski <belegdol@gmail.com> writes:

> Am 30.06.22 um 19:55 schrieb Paulo Alcantara:
>> Julian Sikorski <belegdol@gmail.com> writes:
>> 
>>> Not much is there:
>>>
>>> Jun 30 18:19:34 snowball3 kernel: CIFS: Attempting to mount
>>> \\odroidxu4.local\julian
>>>
>>> Jun 30 18:19:34 snowball3 kernel: CIFS: VFS: cifs_mount failed w/return
>>> code = -22
>>>
>>>
>>> I tried reverting 16d5d91 as it was the only commit referencing smb, but
>>> it did not help unfortunately.
>> 
>> Could you please run
>> 
>> 	echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
>> 	echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
>> 	echo 1 > /proc/fs/cifs/cifsFYI
>> 	echo 1 > /sys/module/dns_resolver/parameters/debug
>> 	dmesg --clear
>> 	tcpdump -s 0 -w trace.pcap port 445 & pid=$!
>> 	mount ...
>> 	kill $pid
>> 	dmesg > trace.log
>> 
>> and then send trace.log and trace.pcap.
>
> Attached.
>
>> 
>> What SMB server and version?
>
> Openmediavault 6.0.30 running on top of armbian bullseye. The samba 
> package version is 4.13.13+dfsg-1~deb11u3.

Thanks!

So, it is failing very early during the negproto request:

	SMB2 302 Negotiate Protocol Request
	SMB2 143 Negotiate Protocol Response, Error: STATUS_INVALID_PARAMETER

which seems related to these commits in v5.18.8

	16d5d9100927 smb3: use netname when available on secondary channels
	ca83f50b43a0 smb3: fix empty netname context on secondary channels

Have you tried reverting both in v5.18.8 to see if it works?

I built v5.18.8 but couldn't reproduce it against w22 server, though.
