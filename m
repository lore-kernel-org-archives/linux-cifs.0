Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69470C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jun 2022 17:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiF3RzT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jun 2022 13:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiF3RzT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jun 2022 13:55:19 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780903818B
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 10:55:17 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 7E64E80266;
        Thu, 30 Jun 2022 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1656611715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QixAnLylD6BGPAHjId76SXQFdlnldIO75tAoP4yCl8I=;
        b=nW87KSKZN/Eaw/N5aFZgzhwDBC0KgaPPog1UPahQ2lJf+WKJlK8sqK8OCprQSPbJR5t9x6
        l1BY3ePOgMaxAy6pE62K4YGYhWNXm9+f5kqQfknr4EMkmMXxWESzZ8D/4WUxq4GEwsmtPW
        zldEOBmJqgS/W2WAxmUgeEl1SFHptGDyH7ICeH1OBCvNenDgg3t/J4weDpSRoQVbcPf1m1
        E7kXytoOYsBYqzNxEyMB8aSCKCXTiYo1xvaiyhsBXDB7JtSTRvNVvnWNPlEtOISWdYbp9I
        pkZap1IbaTe9Wv8ddeiBW3mrR41bb+AAnhgvW8InQDsKeDIenU1gikMdZI++TA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Julian Sikorski <belegdol@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: kernel-5.18.8 breaks cifs mounts
In-Reply-To: <fee59438-7b4a-0a24-f116-07c2ac39a3ad@gmail.com>
References: <211885e7-1823-9118-836b-169c7163d7c2@gmail.com>
 <CAN05THTbuBSF6HXh5TAThchJZycU1AwiQkA0W7hDwCwKOF+4kw@mail.gmail.com>
 <fee59438-7b4a-0a24-f116-07c2ac39a3ad@gmail.com>
Date:   Thu, 30 Jun 2022 14:55:10 -0300
Message-ID: <87h7423ukh.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Julian Sikorski <belegdol@gmail.com> writes:

> Not much is there:
>
> Jun 30 18:19:34 snowball3 kernel: CIFS: Attempting to mount 
> \\odroidxu4.local\julian
>
> Jun 30 18:19:34 snowball3 kernel: CIFS: VFS: cifs_mount failed w/return 
> code = -22
>
>
> I tried reverting 16d5d91 as it was the only commit referencing smb, but 
> it did not help unfortunately.

Could you please run

	echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
	echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
	echo 1 > /proc/fs/cifs/cifsFYI
	echo 1 > /sys/module/dns_resolver/parameters/debug
	dmesg --clear
	tcpdump -s 0 -w trace.pcap port 445 & pid=$!
	mount ...
	kill $pid
	dmesg > trace.log

and then send trace.log and trace.pcap.

What SMB server and version?
