Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3176EB64DD
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Jul 2023 21:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbjGLVKg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Jul 2023 17:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbjGLVKf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Jul 2023 17:10:35 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961EF1FC9;
        Wed, 12 Jul 2023 14:10:33 -0700 (PDT)
Message-ID: <0bb4a367ebd7ae83dd1538965e3c0d2b.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1689196231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=87D1wgXkCoqNsHuc4E5XEDcTC2UydNXgWk7WyKAXs04=;
        b=ac2WVo9qoJrkyo+lyly2EEiXahbuPNp05ERxwFMbuiSTeebMGJY6pANq5YIEQk3PtD01ST
        uIWZvewXSKHpf5XObiwAFmTuobKj6aPGC/LaQq3dHokk7dB63G/awyWXlZ+SvE5X0oUp2w
        XeLzlD7dQ+MxqLHOMniTuN11JUKboAvOQiVqplL2ze3foBFMjDIhrH9ggsNklBNxi6UBNs
        4dhmU9EPJ5jZlq49bq9LIBwf7rfR1iXEuh3kAKCzAEgH6j0FdNt7EHa75+Aw47ZO4SyE4m
        go760Cg/ez5Ux9Qx9gPo0NOroq3bdsXk5Ve9x25BgIWpRd1cfOShAqvJfmmGEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1689196231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=87D1wgXkCoqNsHuc4E5XEDcTC2UydNXgWk7WyKAXs04=;
        b=rlm0uQraE0YBWwFiHeIa8DqB4Jcwntz2OKeSi49LeUXR+qN1sFiAe8iMIE0Jiz59eYUEuU
        tl+mzlN9FHAWeQ+jzPyoMwtcyAJe5lJDcjd9P+7HklY3tlblE8F3Bi7nvisuA4AjYH23P4
        biTTcSseBvF9GpQ9i+Q/F+cwcX8N8Qvpf+JjPmwKCPYn32lXIInB3XThobqHWgpN0Z43QX
        g+es4r17L8Z4sM3J1uwQpHzNdePC3t0nDjWqW0G9gXzswMq0ADCkR5U0ml/q65qoK6FXKH
        KLWZ9YBbnbOehuW5wCjpMJo0NIAJzccU7wx1CS3OAfmJA+IxcoDuEuELN54ttA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1689196231; a=rsa-sha256;
        cv=none;
        b=WUNnjkmo8Jz4mFmtub6TrzIo7XYgwURoaCmiMjREd3N5D/l9yp0lTq6cbrUkqYmAHXzcxS
        nt8NJugqhY6MWWLFsX5Up/PtCir4dsl8PTY7KBYqHr45w1z7tUAdxJ/f/hlFlL6K/TdMMO
        T6GEvLY01wAskO1lM1+cZWKYmdoTs2/iayqBZBtbw5pFCXavgH4aT5p+56Amv7c5qkJ1IB
        ph+RvsNNYp5rsT0VyAU1N+JIOsxhXDy7cr9HPDhHDxeSKw3avsgW34p8aTNbIJWTS8u2A6
        5me7AUxtqs9Cj2XudFLnDpkgwH0omYS3XxnXADNFPtlW7P/k8PILsuLyg9gKcQ==
From:   Paulo Alcantara <pc@manguebit.com>
To:     stable@vger.kernel.org
Cc:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 4/4] smb: client: improve DFS mount check
In-Reply-To: <20230628002450.18781-4-pc@manguebit.com>
References: <20230628002450.18781-1-pc@manguebit.com>
 <20230628002450.18781-4-pc@manguebit.com>
Date:   Wed, 12 Jul 2023 18:10:27 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Paulo Alcantara <pc@manguebit.com> writes:

> Some servers may return error codes from REQ_GET_DFS_REFERRAL requests
> that are unexpected by the client, so to make it easier, assume
> non-DFS mounts when the client can't get the initial DFS referral of
> @ctx->UNC in dfs_mount_share().
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/smb/client/dfs.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
> index afbaef05a1f1..a7f2e0608adf 100644

Stable team, could you please pick this up as a fix for

        8e3554150d6c ("cifs: fix sharing of DFS connections")

The upstream commit is 5f2a0afa9890 ("smb: client: improve DFS mount check").

Thanks.
