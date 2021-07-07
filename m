Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A940C07E95
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 21:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6409261376
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 21:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhGGVSQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 17:18:16 -0400
Received: from mx.cjr.nz ([51.158.111.142]:18004 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229829AbhGGVSQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 7 Jul 2021 17:18:16 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id EFA8B7FD1E;
        Wed,  7 Jul 2021 21:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1625692534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N8KbZXNK7ej4jCOJECbZ3s18x4mnuaDlzxiILZ+xM8w=;
        b=PBdEBdazgCZCidRYF1tFK4UTYJPdq75c+l/lenBTdg+osLGSvW7gM0rOZ1ZiqSgkBzhnal
        ri6WNFzXUmLIhydRfwZgbsGPFRAp2qD4J/0DuS5IJreZriD6Cge+5XiC/6sAZjj30v/PrL
        EcdBKGqymLj4clio3vYDruXhQT93eQiMTJNxkvTkPlJGAO67J6Y8p21yrVuREw3pcc1M3f
        Ya+zPaYIQL2DL2QkvH4XpmYRp3hR+VJEHO/IjJgrSLDxJYCbXByQ67gokAGstlPrmC2g3H
        fn+b5u8gnsc729jics+/vKd6N3xeGCud0Y6GtUNkXc//Tj7Kc0UwtmSKSCACNw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][CIFS] Clarify SMB1 code for rename open file
In-Reply-To: <CAH2r5msZ8+-HcjXK0xgRDjBRkUg597_mGWx8ry2-PxhJY16mkw@mail.gmail.com>
References: <CAH2r5msZ8+-HcjXK0xgRDjBRkUg597_mGWx8ry2-PxhJY16mkw@mail.gmail.com>
Date:   Wed, 07 Jul 2021 18:15:28 -0300
Message-ID: <87a6mx6d1r.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> And one more trivial coverity issue related patch ...
> (with fewer old issues like this, in the future it will be easier
> to spot important new ones that tools like this report)
>
> Coverity also complains about the way we calculate the offset
> (starting from the address of a 4 byte array within the
> header structure rather than from the beginning of the struct
> plus 4 bytes) for SMB1 RenameOpenFile. This changeset
> doesn't change the address but makes it slightly clearer.
>
> Addresses-Coverity: 711521 ("Out of bounds write")
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/cifssmb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
