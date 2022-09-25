Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77D8C04A95
	for <linux-cifs@archiver.kernel.org>; Sun, 25 Sep 2022 03:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiIYDp4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 24 Sep 2022 23:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiIYDpx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 24 Sep 2022 23:45:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5C52B273
        for <linux-cifs@vger.kernel.org>; Sat, 24 Sep 2022 20:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E463460C5F
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 03:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4E8C433D6
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 03:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664077548;
        bh=q9hWSL7zk8mK1kzbfPqqmQnSjM4eaFqW6HzJS6g5gsA=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=WyMT6jdTOZa4L/cg52u6hbpRwB4WJQg9tg/1DHFMm0qNnqAAHCCTWC4JL6dENB0Bl
         XYlx4ussjwDuwHDvzeKCHXPBYWAipSYtKpaiR2F4odZp5WGQaC4E7lAapDuBHbl/yg
         DzsRohx9ir2ndPdu+TzzmmTAoCYQx+5AcSZ5yK4WZf7MYvHOyrP4qlxNe2dMl88D1H
         bX6nLJarLjuJzPtJfPbZyxaXNQP0YilF2rTv5UVShg70mzVYgkpTBI+prJ5aP+Th3p
         zShva5IFc0cDZ0tX9XiKe70bDzoW4LcVC3vTtWyeeDfJR/dttY9cNQgHAZbcYhN0xC
         +gQ4B9I6D/9/Q==
Received: by mail-oo1-f42.google.com with SMTP id r15-20020a4abf0f000000b004761c7e6be1so640343oop.9
        for <linux-cifs@vger.kernel.org>; Sat, 24 Sep 2022 20:45:48 -0700 (PDT)
X-Gm-Message-State: ACrzQf0J/NSxdB102duUj1YSptiATMweYGILuXZLqzjFn0WTL/CxAmvW
        ngIPrUZ6EH4yzrSqRY5UutMd/HspseZ3bvE926s=
X-Google-Smtp-Source: AMsMyM7ORlXcAxC8OYvzCcc0Y5fKCc0i7vgMB7iy4Goyi005ZwKLjSMdZnk+SEnlrmG96eQnxxvIWGuCPErk3A28N78=
X-Received: by 2002:a4a:2243:0:b0:44a:e5cf:81e5 with SMTP id
 z3-20020a4a2243000000b0044ae5cf81e5mr6434098ooe.44.1664077547479; Sat, 24 Sep
 2022 20:45:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Sat, 24 Sep 2022 20:45:47
 -0700 (PDT)
In-Reply-To: <cover.1663961449.git.tom@talpey.com>
References: <cover.1663961449.git.tom@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 25 Sep 2022 12:45:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-53MEeq5RwM4jeSU1VT7oNdn3xOzQSGSnPaBnA5euBJA@mail.gmail.com>
Message-ID: <CAKYAXd-53MEeq5RwM4jeSU1VT7oNdn3xOzQSGSnPaBnA5euBJA@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Reduce SMBDirect RDMA SGE counts and sizes
To:     Tom Talpey <tom@talpey.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org,
        senozhatsky@chromium.org, bmt@zurich.ibm.com, longli@microsoft.com,
        dhowells@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-24 6:53 GMT+09:00, Tom Talpey <tom@talpey.com>:
> Allocate fewer SGEs and standard packet sizes in both kernel SMBDirect
> implementations.
>
> The current maximum values (16 SGEs and 8192 bytes) cause failures on the
> SoftiWARP provider, and are suboptimal on others. Reduce these to 6 and
> 1364. Additionally, recode smbd_send() to work with as few as 2 SGEs,
> and for debug sanity, reformat client-side logging to more clearly show
> addresses, lengths and flags in the appropriate base.
>
> Tested over SoftiWARP and SoftRoCE with shell, Connectathon basic and
> general.
>
> v2: correct an uninitialized value issue found by Coverity
>
> Tom Talpey (6):
>   Decrease the number of SMB3 smbdirect client SGEs
>   Decrease the number of SMB3 smbdirect server SGEs
>   Reduce client smbdirect max receive segment size
>   Reduce server smbdirect max send/receive segment sizes
>   Handle variable number of SGEs in client smbdirect send.
>   Fix formatting of client smbdirect RDMA logging
You are missing adding prefix(cifs or ksmbd:) to each patch.

>
>  fs/cifs/smbdirect.c       | 227 ++++++++++++++++----------------------
>  fs/cifs/smbdirect.h       |  14 ++-
>  fs/ksmbd/transport_rdma.c |   6 +-
>  3 files changed, 109 insertions(+), 138 deletions(-)
>
> --
> 2.34.1
>
>
