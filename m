Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4E6C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 22:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4982961359
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 22:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhKGWu3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 17:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhKGWu3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 17:50:29 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F5BC061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 14:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=by+f14H7d/bX0zfgiJpiZLhM4F6fECKCNAYDiw9tFWg=; b=Zm3Be/WqIjq9McKCqcZb9XD7bq
        FBsUq6FVIJFTNC1maKv/Twew8Ulzz7J3uJVc0k/u+jXJ1tlfqFqF+k+/m2CPVwEDXUGfpwmkUKPRh
        vHrlsxn8qidyE9rWH1nJOu4wbElQ7W8azr9xZl/ZqauGZ9DdOy4RDSo2nOykzp6ZlfwmcOq9xlU0N
        Hw1RiwFu8++5e89iqLEddNcjSt+MlPysV+GBs/ZAnx/kwJRVLAT1F4Rm54iqWKxz1BVkJBZSxmkyL
        GSYfD452Rjznm225q9atHa9HBoIa9UMf86SO7SbgrSnM2lfiPFVwRdOjypCAKwHDrfJDNvD7Cfx6t
        3oLpgvYl+K1CQgyK43U/f2g8FSjz040gMICqNCG/ZOkDpmWU/gFlYxbUhtTNIQkmaZ4O72wpyOQqB
        UfW9EZKaOp193doFlhMdn4ofWl2zsKAfBewBmLqZJEjOvqBzkywwhf29tzMQNE1JqvJmmVgOXXubD
        9xL3wmUbCNvcK2XXHt+7p3lY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mjqwx-005gQe-88; Sun, 07 Nov 2021 22:47:43 +0000
Date:   Sun, 7 Nov 2021 14:47:40 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Julian Sikorski <belegdol@gmail.com>
Cc:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
Subject: Re: Permission denied when chainbuilding packages with mock
Message-ID: <YYhXjG46ZZ1tqpxJ@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
 <YYhI1bpioEOXnFYf@jeremy-acer>
 <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Nov 07, 2021 at 11:15:49PM +0100, Julian Sikorski wrote:
>Hi,
>
>thanks for responding. I am using loglevel 10. I have uploaded the 
>logs to my dropbox as they are too big to attach:
>
>https://www.dropbox.com/sh/r4b7q7ti2zmtlu9/AACqFY0FW2oW41Vu8l3nLZJSa?dl=0
>
>The problem happens around 15:45:48. Do the logs show what access mask 
>the fsp is being opened with you requested?
>I am using quite an old samba server (4.9.5+dfsg-5+deb10u1) due to the 
>fact that openmediavault is based off debian 10 and there are no samba 
>backports available. Having said that, this configuration can work, as 
>shown by goffice/goffice-0.10.50-1.fc35.src.rpm rebuild and the fact 
>that it was working before for months previously.

The error is occurring on the file:

/srv/dev-disk-by-label-omv/julian/kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35/goffice-devel-0.10.50-2.fc35.x86_64.rpm

this is a regular file, not a directory
opened with ACCESS_MASK: 0x00120089

that is:

SEC_STD_SYNCHRONIZE|
SEC_STD_READ_CONTROL|
SEC_FILE_READ_ATTRIBUTE|
SEC_FILE_READ_EA|
SEC_FILE_READ_DATA

so indeed, this is being opened *without*
SEC_FILE_WRITE_DATA|SEC_FILE_APPEND_DATA
so smbd is correct in returning ACCESS_DENIED
to an SMB2_FLUSH call.

Looks like this is a client bug, in that it
is passing a Linux fsync(fd) call directly
to the SMB2 server without checking if the
underlying file is open for write access.

In this case, the SMB2 client should just
return success to the caller, as any SMB_FLUSH
call will always return ACCESS_DENIED on a
non-writable file handle, and according to
Linux semantics calling fsync(fd) on an fd
open with O_RDNLY should return success.

Steve, over to you :-).

Jeremy.
