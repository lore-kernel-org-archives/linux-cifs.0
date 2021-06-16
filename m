Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 637C9C48BE6
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Jun 2021 15:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 426A561027
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Jun 2021 15:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbhFPPty (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Jun 2021 11:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235504AbhFPPss (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Jun 2021 11:48:48 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30383C0611BC;
        Wed, 16 Jun 2021 08:40:32 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id c18so3041956qkc.11;
        Wed, 16 Jun 2021 08:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qzT+aoRD/micuUO2QotAKO9v1rg3ul7+XoTwzXpmu7I=;
        b=X14yWQKmOQIhew8GwnEl0Nw3M3HrN3/XAe6nUgife5+zS60oiVzVO//zAS3pubCY7G
         h/0kKA7gZAqh2FDk6QMQHPGMDJqYT4uyAgmq/2ecDTVQjLlRshe+f0VO6h3anR2ooK1C
         enKBl78D3xUkDfLnAZZJb3BbW8N1NyfjoJI3gHDkosOntS5zRj2be0MsIdrRH5ZYf5Ln
         sl8dAeTJZDiwL1OA533izDhvwsryUtnowNO7XyrXCig12rT9/9OBfJMWYl2Z5AIlpOzu
         osovW7dFAxen+EL7McQ1hJj5EyWbAmxzG0DoqpPUbDl7Miq950N1bzRpitQJzkkdX04p
         5EfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qzT+aoRD/micuUO2QotAKO9v1rg3ul7+XoTwzXpmu7I=;
        b=R+W8lstzyrpfLwTS5ectfBwdI2Y//2fChsXzyiETUDBvXEejLzET02YCJhOw+wg4Nx
         sW9tx2DyAs8/BwY0aoPDCwai+nj7qxUMjBQlE2N/eMF/YtZyvQFCTO5iDRhKrhGORKNk
         YI2gHi0Sy8GFr5p41VqB6NDe/vohFk0tD9xGPk+xb5/VfdZI7bqwmUl7xQuAt7HNKqCG
         V1bY5l8QHT8cTaH0jBJAgUBZlwFWfYXyumnwTUsrG9/MVA4cBU0ee0F1iBFOku70xBsP
         lfKmqC+vq+watIGp9QXdFfgmmLDczSlhiC+d0wp+sAgUe8qgX/I6Wyd61LAziWWGOEKp
         HRHA==
X-Gm-Message-State: AOAM530bw4Q/aIknALBkXDs27u/3ISxDES53yiBGWeOlzoRrKo2OMklO
        ikK7LbsEqm5b12RDU9MXWDw=
X-Google-Smtp-Source: ABdhPJzoQoQt4lnYIajkrn73fyIbeZvwusV0zc2bf78GNxdsnm5lUH5E1wgfOZvLYWzACvgPBNfx/g==
X-Received: by 2002:a05:620a:1443:: with SMTP id i3mr638021qkl.193.1623858031421;
        Wed, 16 Jun 2021 08:40:31 -0700 (PDT)
Received: from nyarly.rlyeh.local ([179.233.244.167])
        by smtp.gmail.com with ESMTPSA id m199sm1818009qke.71.2021.06.16.08.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 08:40:30 -0700 (PDT)
Date:   Wed, 16 Jun 2021 12:40:26 -0300
From:   Thiago Rafael Becker <trbecker@gmail.com>
To:     =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cifs: retry lookup and readdir when EAGAIN is returned.
Message-ID: <YMobapLxHv/BPzFP@nyarly.rlyeh.local>
References: <20210615164256.173715-1-trbecker@gmail.com>
 <CAN05THQqBdT-uvVS+jq1Hv8MwDVCTJFHhzan8M0+4ztNbpCZ0g@mail.gmail.com>
 <87zgvqqg09.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zgvqqg09.fsf@suse.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks for the comments, I'm working on them.

On Wed, Jun 16, 2021 at 12:07:50PM +0200, Aurélien Aptel wrote:

> I guess it looks ok as a quick fix for the issue at hand but:
> - should we check for more error codes (use is_retryable_error()?)
> - all syscalls will need something similar, the session can be closed at
>   any point
>   * either we add a loop everywhere
>   * or we change cifs_send_receive to retry (most?) calls
>   * might be worth looking at what nfs does here

Some syscall can return EAGAIN, so we would need to check which
operation is retryable and if the error is retryable. I don't know if
all Linux syscalls mappable to smb2 operations in the wire, but it may
be worth mapping.

NFS requeues the calls, and fails after a configurable timeout
for soft mounts, or issues an error message and requeues the request
for hard mounts (retrans and timeo mount options).

> - Should this be done for both soft (default) and hard mounts? I guess
>   for hard we would retry indefinitely

Good point, but the correct option is to retry on hard mounts until the
operation succeeds.

NFS hard mounts create issues like being unable to do a clean shutdown on
a server failure, because oustanding I/O blocks it. The NFS has atempted
to fix this by adding options to kill all outstanding I/O, but I'm not
current on the efforts/issues in this front.

So this would create the same issue with outstanding mounts on cifs 
shares, so a similar solution to NFS may be adapted/created in the future.

One thing that I forgot to mention in the patch is that this uncovered a
bug in compuond requests, where wait_for_compund_request will block the
readdir request with EDEADLK, if the share needs reconnect. I'm looking
into this patch, and will submmit it separatelly, as this looks like a
corner case uncovered by the patch and specific conditions in the tests.

> Cheers,
Best regards,
Thiago
