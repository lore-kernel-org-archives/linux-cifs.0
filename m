Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED190C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 17:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C80A16103B
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 17:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344486AbhIXRW4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Sep 2021 13:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347972AbhIXRWe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Sep 2021 13:22:34 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6265C0617AF
        for <linux-cifs@vger.kernel.org>; Fri, 24 Sep 2021 10:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=cIL+GXzwE91lhAZpnxfNKtFCGGOd8ABCdLdXte0ssJ8=; b=ewVGitbW1yj4MRF1SBNdLQbxbi
        /dTZZWJUrAgTSbEE8x7WlISSSlH5Q37Pys4iTBHdy+W6ab3noyrXOUXrg7RE7TLQFDwBGHsA4qtH5
        +oQ0kw+HwG1CpU7swwUAfvr2LDDkX9sHHsVhzY0bFUJDibYJbOPAT9cs3TJ2irh2hxQKD7m8PTtgl
        Xc1A4dCoAVY/kQS9B4OOe9h0XJY1YDxJVdUV+osS4g4XGxkPFLFCJ4C643IUBlfuzMzmULbZIrX7U
        blbakpWOF7Z4Tl2603tX8FPRu3qCAMrq8fmc3uhxGxnPzIwfQzYTYqDigm4CAKbitTU8oQX9Au6IB
        ig+kZgfjtIGS0tIZubqwu3kcoDXG7egGjlvS9hEy8lfmqVeA0CywKwG7vcX2KmyZ+LEj9lyOLaxN1
        BdQz/g8I07+k69sB5GaySpON8QMWIUlQW0E7nUI7i7zYBs0Sx8xJ1WWoIv0YhHFeK2tK9Qy9kRFcx
        DK8fkLrjUp3+uFLaEkvULFxQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mTosE-007ij4-UH; Fri, 24 Sep 2021 17:20:35 +0000
Date:   Fri, 24 Sep 2021 10:20:31 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Ralph Boehme <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH v4] ksmbd: use LOOKUP_BENEATH to prevent the out of share
 access
Message-ID: <YU4I3zUm3UOOXrBz@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20210924150616.926503-1-hyc.lee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210924150616.926503-1-hyc.lee@gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Sep 25, 2021 at 12:06:16AM +0900, Hyunchul Lee wrote:
>instead of removing '..' in a given path, call
>kern_path with LOOKUP_BENEATH flag to prevent
>the out of share access.
>
>ran various test on this:
>smb2-cat-async smb://127.0.0.1/homes/../out_of_share
>smb2-cat-async smb://127.0.0.1/homes/foo/../../out_of_share
>smbclient //127.0.0.1/homes -c "mkdir ../foo2"
>smbclient //127.0.0.1/homes -c "rename bar ../bar"

FYI, MS-FSCC states:

"Except where explicitly permitted, a pathname component that is a dot directory name MUST NOT
be sent over the wire."

so it might be easier to just refuse with an
error a pathname containing "." or ".." on input
processing rather than try and deal with it.

Might be interesting to test this against a
Windows server and see what it does here.
