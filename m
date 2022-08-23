Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DE1C32772
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 19:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbiHWTRV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 15:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiHWTQ7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 15:16:59 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7559F69F46
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 10:54:14 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 43E5780273;
        Tue, 23 Aug 2022 17:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1661276729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MFc9TKoccWHxmM8wvMAEsAIVnThFyUvGmn+naB5s5Dk=;
        b=sbz5f4cvfIXLgy5iFS7peSW6r+r4HQ0AvqjLTE2ZDSxl/40p0+VFeLNQn0J/dlskiiizR+
        yehWCRVGukFTDIAOccYByiyQbk1H1w+L0Scneynqo/fEYVqFkIvf+3KuXqlN0gpA8yw/aR
        68pdM2vHTNIc+P7NiGwso/x89+MZNyzD8Jq2T7FH+HVedfs2iznCFkjSW+vjRdxh1+HIhb
        qK9KbzBSK8jdNQH74VKBKcC2S0yPu5IEvbGo6NxzI123KyNgyy7whuZpC1Oqo9WzLqrLOW
        tXpuDhQNJaj2GUb0fAE0TTMTG3RR+3gHXxRifjbpRlA62R5vbymt7z0EGugmLw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: fix some memory leak when negotiate/session setup
 fails
In-Reply-To: <20220823142531.9057-1-ematsumiya@suse.de>
References: <20220823142531.9057-1-ematsumiya@suse.de>
Date:   Tue, 23 Aug 2022 14:45:48 -0300
Message-ID: <8735dmj1kj.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

>
> Fix memory leaks from some ses fields when cifs_negotiate_protocol() or
> cifs_setup_session() fails in cifs_get_smb_ses().
>
> A leak from ses->domainName has also been identified in setup_ntlmv2_rsp()
> when session setup fails.

Those fields are already freed by sesInfoFree().

> These has been reported by kmemleak.

Could you please include the report in commit message?
