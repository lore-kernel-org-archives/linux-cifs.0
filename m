Return-Path: <SRS0=fxvP=RX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71EEC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 21:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1BF0218B0
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 21:50:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paulo.ac header.i=@paulo.ac header.b="JSVRwsVX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfCTVu4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Mar 2019 17:50:56 -0400
Received: from mail.paulo.ac ([51.15.136.203]:35630 "EHLO mail.paulo.ac"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727116AbfCTVu4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 20 Mar 2019 17:50:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.paulo.ac (Postfix) with ESMTP id 34A8F1C0494;
        Wed, 20 Mar 2019 21:50:54 +0000 (UTC)
From:   Paulo Alcantara <paulo@paulo.ac>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=paulo.ac; s=201902;
        t=1553118654; bh=uLDu9GOSopJItD4pNxx20aWZfCurPvD8l7NnUId60qE=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=JSVRwsVX6wGZJdVFQDgy2iegNeMQK98sO9WVbmvFsZxSavOynwqJa+6zBwYDip5zB
         EN10h7N+x5EVP0IKzbrGwAx1FIeA/ipLoTSGxUSaIYoehiUvbIEp4iNW/DzZoJWjcu
         4WC1w2Ewx8UhX/YUAQG28E+blDwdUxpTuXnMyEwlsQhYQV5Yq86OiAgIEJF1VgkA0G
         meWXh6vcoL2bwQ8M0wGO8+urpriIdvTYZIXSmY/5u17CVFJjBPolc76XMhhoTCUYqA
         PveBj4uA+YPcPgjpkZC0Gkzl4e1jibyVs5izyqYYvQEyOS4BoLAdbwjyTOA3f53PB0
         9AVdmhqmhvFbQ==
To:     Andreas Hasenack <andreas@canonical.com>,
        linux-cifs@vger.kernel.org
Subject: Re: "Bad SMB2 signature for message" with kernel 5.0.0, works with 4.19.0
In-Reply-To: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
References: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
Date:   Wed, 20 Mar 2019 18:50:36 -0300
Message-ID: <87ftrh8bbn.fsf@paulo.ac>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Andreas Hasenack <andreas@canonical.com> writes:

> I can't mount a share as guest using SMB2 or higher when running the
> 5.0.0 kernel (ubuntu's 5.0.0-7.8 specifically). When I switch to a
> 4.19.x kernel (4.19.0-12-generic), then it works.
>
> This is the mount command and output:
> root@ubuntu:~# mount //localhost/pub /mnt -o guest
> mount error(13): Permission denied
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
> The share is a simple one:
> [pub]
> path = /pub
> guest ok = yes
>
> The server logs this:
> [2019/03/20 18:24:46.245816,  0]
> ../../libcli/smb/smb2_signing.c:169(smb2_signing_check_pdu)
>   Bad SMB2 signature for message
> [2019/03/20 18:24:46.245860,  0] ../../lib/util/util.c:508(dump_data)
>   [0000] 2D 60 1F CA 49 06 92 B0   69 06 60 82 42 39 21 F8   -`..I... i.`.B9!.
> [2019/03/20 18:24:46.245894,  0] ../../lib/util/util.c:508(dump_data)
>   [0000] 75 F8 77 09 63 D5 4A 7B   9F 91 51 93 6D 12 6F 6F   u.w.c.J{ ..Q.m.oo
>
> Here is a dmesg output with cifs debugging enabled:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1821053/+attachment/5247960/+files/dmesg.txt
>
> That output was from a kernel running patch
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.0/cifs-do-not-skip-smb2-message-ids-on-send-failures.patch,
> just a quick attempt to see if that fixed it, but it didn't.
>
> mount.cifs is version 6.8
>
> Server is samba 4.10.0.
>
> Is this a known issue?

Looks like a signing issue when using guest auth in SMB3.11. Could you
please try mounting it with vers=1.0, vers=2.1 and vers=3.0 and see if
it works?

cheers,
Paulo
