Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A5AC433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Oct 2022 18:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiJDSlO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Oct 2022 14:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJDSlN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Oct 2022 14:41:13 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3A265646
        for <linux-cifs@vger.kernel.org>; Tue,  4 Oct 2022 11:41:13 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 9FFD27FC9E;
        Tue,  4 Oct 2022 18:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1664908871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/KDX/9MAr6ov936Xk4H3yooZcb9hicW7SatC8EaltwU=;
        b=h4V+Y8YaQCeQqqxAvqF3xIawABEiX29+fhTi3nhwvj9+oMLaqTh5oL6xjKL6Ul4mqBQgrN
        mPK44Kg8srZ+J0DgHHmdFVYwU8Jazl5FshaDN3zUgUWdM2nJ7UzeuBWjuCf+SMvj5zIZbK
        6AKMiF+iCkfhjlt+PzZ3V8tc0LWaVJPST84pIZdibGs1JeycgLl6+Gip9NLMOWTZJ5xRNx
        JoHBjKjQBqkv0kv6N68vRiDCSCCwneW846BS15dBIto/fB9JU0WB+YpF74yTLaZ83yVwFZ
        8YqM+jXsfdsYiI6CItG5pawPyRLCqWnwAfTTLX2Ke7l16x28cbReadWymuwuWQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Tom Talpey <tom@talpey.com>, smfrench@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, longli@microsoft.com, dhowells@redhat.com,
        Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH v2 0/6] Reduce SMBDirect RDMA SGE counts and sizes
In-Reply-To: <cover.1663961449.git.tom@talpey.com>
References: <cover.1663961449.git.tom@talpey.com>
Date:   Tue, 04 Oct 2022 15:42:01 -0300
Message-ID: <871qrn5t3a.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tom Talpey <tom@talpey.com> writes:

> Allocate fewer SGEs and standard packet sizes in both kernel SMBDirect
> implementations.
>
> The current maximum values (16 SGEs and 8192 bytes) cause failures on the
> SoftiWARP provider, and are suboptimal on others. Reduce these to 6 and
> 1364. Additionally, recode smbd_send() to work with as few as 2 SGEs,
> and for debug sanity, reformat client-side logging to more clearly show
> addresses, lengths and flags in the appropriate base.
>
> Tested over SoftiWARP and SoftRoCE with shell, Connectathon basic and general.
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
>
>  fs/cifs/smbdirect.c       | 227 ++++++++++++++++----------------------
>  fs/cifs/smbdirect.h       |  14 ++-
>  fs/ksmbd/transport_rdma.c |   6 +-
>  3 files changed, 109 insertions(+), 138 deletions(-)

Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
