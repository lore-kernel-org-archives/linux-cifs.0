Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB526ECAAD5
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Sep 2022 16:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiIFQcm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Sep 2022 12:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbiIFQcE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Sep 2022 12:32:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843547171D
        for <linux-cifs@vger.kernel.org>; Tue,  6 Sep 2022 09:05:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 30BEA1F9BC;
        Tue,  6 Sep 2022 16:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662480311; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mQjbUqaCRT95yvDnUzPy9Zdgt57NBQCmKWTymVfWTTk=;
        b=t/auK8JdCvp6FsxaG/ey6+d5M2DVlm5X3+Lu+0CWGtrk70SxTm7bcTQLtJAj8kn4TuPwK6
        GdP61f2OIokeyC4i1WB0jKAJqdqS6T2lTnwUYo9FzCmQc/28bCUic7IZvoGTJrLYlSWLkh
        D0GKxY7w/a7A/5+3YeRjVQ7+8z11yNM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662480311;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mQjbUqaCRT95yvDnUzPy9Zdgt57NBQCmKWTymVfWTTk=;
        b=IDZ6710Q4yg5QG8PvA0pA1Jk0bCVlbT4IbDg3FFV6r8VsDLaASr6pkWaLEOqmUUk/wfPIt
        wKVG7EqcJ0b5NmDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AADBC13A19;
        Tue,  6 Sep 2022 16:05:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JwSkG7ZvF2PJLQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 06 Sep 2022 16:05:10 +0000
Date:   Tue, 6 Sep 2022 13:05:08 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: perf improvement - use faster macros ALIGN() and
 round_up()
Message-ID: <20220906160508.x4ahjzo3tr34w6k5@cyberdelia>
References: <20220906013040.2467-1-ematsumiya@suse.de>
 <CAN05THRK3hPQ0c4h9bxhrJYa17eH7NjXKe4Gj8upCcuMvPB2cQ@mail.gmail.com>
 <20220906144102.yfxvwx2jbs3iy2x3@cyberdelia>
 <a644c02b-8a43-0c35-c843-26c8ed9ad0bf@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <a644c02b-8a43-0c35-c843-26c8ed9ad0bf@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/06, Tom Talpey wrote:
>In addition to polluting fewer registers and generally being more
>lightweight to frob just four low bits.
>
>I am a bit shocked at the improvement though. It's almost worth a
>fully profiled before/after analysis.
>
>Reviewed-by: Tom Talpey <tom@talpey.com>

Thanks, Tom. (see below)

>>>>Afraid this was a useless micro-optimization, I ran some tests with a
>>>>very light workload, and I observed a ~50% perf improvement already:
>>>>
>>>>Record all cifs.ko functions:
>>>>=A0 # trace-cmd record --module cifs -p function_graph
>>>>
>>>>(test-dir has ~50MB with ~4000 files)
>>>>Test commands after share is mounted and with no activity:
>>>>=A0 # cp -r test-dir /mnt/test
>>>>=A0 # sync
>>>>=A0 # umount /mnt/test
>>>>
>>>>Number of traced functions:
>>>>=A0 # trace-cmd report -l | awk '{ print $6 }' | grep "^[0-9].*" | wc -l
>>>>- unpatched: 307746
>>>>- patched: 313199
>>>>
>>>>Measuring the average latency of all traced functions:
>>>>=A0 # trace-cmd report -l | awk '{ print $6 }' | grep "^[0-9].*" |=20
>>>>jq -s add/length
>>>>- unpatched: 27105.577791262822 us
>>>>- patched: 14548.665733635338 us
>>>>
>>>>So even though the patched version made 5k+ more function calls (for
>>>>whatever reason), it still did it with ~50% reduced latency.
>>>>
>>>>On a larger scale, given the affected code paths, this patch should
>>>>show a relevant improvement.

So I ran these tests several times to confirm what I was seeing. Again,
they might look (and actually are) micro-optimizations at first sight.
But the improvement comes from the fact that cifs.ko calls the affected
functions many, many times, even for such light (50MB copy) workloads.

On those tests of mine, the user-perceived (i.e. wall clock) improvement
was presented as a 0.02 - 0.05 seconds difference -- still looks minor
for, e.g. NAS boxes that does backups once a week, but aiming for 24/7
90% loaded datacenter systems, my expectation is this will be called an
improvement.


Cheers,

Enzo
