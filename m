Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB1AC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Mar 2022 15:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347792AbiCHP1g (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Mar 2022 10:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347796AbiCHP1f (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Mar 2022 10:27:35 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D50C4DF65
        for <linux-cifs@vger.kernel.org>; Tue,  8 Mar 2022 07:26:39 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id C8DEC7FC42;
        Tue,  8 Mar 2022 15:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1646753197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gKiseKnYftMjo3uG9X7LhfA0PGdtnPg0St721nCHxCg=;
        b=WJivTI81UhFPuvLeJbRjHSD6hj3y4EN0m3hKB9QZlj6iTLIlvT3blUTm/geWMGc7rjQf//
        aLiK3j7CVCdxZT3g3R4xyll2Glspp/cncMRYHZUFpbRKGDl0VU0BloIpYah9OW5tz8oVrw
        wmeIByfsXIoTjLhGPpzjO3+/cCwdOAIawQXGRgAyHvNgVv0l7CRyMvpkkeEI7pSdN5v7bt
        2ERxi0ieHuU49B1ClpMAVjVkr+lHR8cWb62RzYrJu+laxMMMz4Y/Dx7lJrCccrLfNB+0lJ
        Q0wcfJpuQNeOXrT1fiWHrPeEWLBSHdmcRmOeE56NjpRA0gyl6bm2wFZJ2AF1mA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>
Subject: Re: DFS tests failing in buildbot
In-Reply-To: <CANT5p=okysnTQhdXixXwJ8KAzukM=dkh2LRxKFKcpsVBW=Ex7w@mail.gmail.com>
References: <CANT5p=okysnTQhdXixXwJ8KAzukM=dkh2LRxKFKcpsVBW=Ex7w@mail.gmail.com>
Date:   Tue, 08 Mar 2022 12:26:32 -0300
Message-ID: <87tuc81n4n.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> There is a race condition that exists between cifsd and I/O threads
> when the tcp connection is broken. The cifsd thread marks the
> server/session/tcon structures for reconnect, and recreates the
> socket, and sets 1 credit for this server. This only changes after the
> next negotiate/session-setup completes, where it can get more credits.
> During this window, if any ongoing I/O requires more than 1 credit,
> then it will return with smb3_insufficient_credits (note that slightly
> earlier in the same code, we identify reconnect with
> smb3_reconnect_detected, but do nothing about it). The I/O will now
> leak -EHOSTDOWN or -EAGAIN into userspace.

I don't see why it would be a problem returning either -EAGAIN or
-EHOSTDOWN back to userspace on *soft* mounts.  Isn't this what we want?

If the syscall gets signaled while we are waiting for the tcp connection
being restablished, then we return -ERESTARTSYS.  See
wait_event_interruptible_timeout() in smb2_reconnect().

> I feel that we should return a special error (-ERESTARTSYS?) when
> smb3_reconnect_detected, and use this errno to ask the caller to
> restart the syscall.

Userspace doesn't handle -ERESTARTSYS.  When we return -ERESTARTSYS from
a signaled syscall, this means that the kernel will either handle the
signal and restart syscall from the beginning, or return -EINTR back to
userspace.
