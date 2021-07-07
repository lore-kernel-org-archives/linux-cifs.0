Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CBDC07E95
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 16:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D95361C94
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 16:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhGGQ3s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 12:29:48 -0400
Received: from mx.cjr.nz ([51.158.111.142]:50230 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhGGQ3r (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 7 Jul 2021 12:29:47 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id C4B897FD1E;
        Wed,  7 Jul 2021 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1625675226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XNvTmmW4DCdOJKEB5c0j9iV2LlI73Be2vTgbrEar54M=;
        b=dMA4hcHssU9CRTrUH5JC8rEvbeurIBqUBEtUEN48RkD83vDZARxB7SblzefxzOYM8VkX9f
        h2yrwu+mnDYQnr4hirV50Bs/wSh+jh/XaIHgrlCzd9T/GNs7XkTd0YcULCodVoa9EHbTcA
        YIkkJ2yUeTFu3xb0OKb0lCLIm6kAXAjWtSXg9CgEM2DYdc6ZKEnvUcjhOff5m+myRXYQQp
        NHXD5bXIqsC3mDyWdA8yGfR04H7ZQYKBKi2kv/7BQTqqzV5i33RWGM6eJftzAwp6YF/56P
        V91DOHmX3SRCJwFkOGq+Bro8MSUB3bw2I/Zw7daj7yRgxG8ulphy34dfkYvCAQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [CIFS][PATCH] Clarify SMB1 code for delete
In-Reply-To: <CAH2r5mudi2+JF---Ou_8eojmH0f8o7Fz2NejuNvFmPaLPCbUww@mail.gmail.com>
References: <CAH2r5mudi2+JF---Ou_8eojmH0f8o7Fz2NejuNvFmPaLPCbUww@mail.gmail.com>
Date:   Wed, 07 Jul 2021 13:27:02 -0300
Message-ID: <87czru5bu1.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> Coverity also complains about the way we calculate the offset
> (starting from the address of a 4 byte array within the
> header structure rather than from the beginning of the struct
> plus 4 bytes) for SMB1 SetFileDisposition (which is used to
> unlink a file by setting the delete on close flag).  This
> changeset doesn't change the address but makes it slightly
> clearer.
>
> Addresses-Coverity: 711524 ("Out of bounds write")
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/cifssmb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
