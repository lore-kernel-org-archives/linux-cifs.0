Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B89FC38147
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Jan 2023 20:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjARUHH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Jan 2023 15:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjARUHD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Jan 2023 15:07:03 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B4E3FF15
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jan 2023 12:07:01 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 7F7377FC01;
        Wed, 18 Jan 2023 20:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1674072420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+9vC2s4j7umRA0W/Z7czAm0H8MDNZCf7iAEUsCAkqII=;
        b=DhPkmjC+CG9UpGhRCQBi47ZiNrCOjQvV2xxwhk7j4JZyDe8H9R6jzbtWI2axtwOlfjISd/
        6StEW2ReR8OC62DOLBQqRUB7ghfySFM7VrK99MM4Nev1QEzz9U0DvxSp8Fyvog6Trod1H5
        VstwjxtO/USRA37QMXePdiVdwryjyO8q4QvFnBCRYfGNawGXTMSl7qZhuGO3VOGZrgXJZk
        syE/OeU55jUzMq1rT4uRzZUJawyP21jVUHJJQ+K9Ww20TyIDR9l5i57YfH4A0yIWHHsjqU
        WMNGOLUIBUJJqV/xe333K60YfO9VQwK0yyLI0y17oF6cs3i0PyTCQIcaQbkkRQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: do not include page data when checking signature
In-Reply-To: <20230118170657.17585-1-ematsumiya@suse.de>
References: <20230118170657.17585-1-ematsumiya@suse.de>
Date:   Wed, 18 Jan 2023 17:06:56 -0300
Message-ID: <871qnrvc7z.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

> On async reads, page data is allocated before sending.  When the
> response is received but it has no data to fill (e.g.
> STATUS_END_OF_FILE), __calc_signature() will still include the pages in
> its computation, leading to an invalid signature check.
>
> This patch fixes this by not setting the async read smb_rqst page data
> (zeroed by default) if its got_bytes is 0.
>
> This can be reproduced/verified with xfstests generic/465.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/smb2pdu.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
