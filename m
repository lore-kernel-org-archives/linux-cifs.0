Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CC3C3E8C5
	for <linux-cifs@archiver.kernel.org>; Sun, 29 Nov 2020 16:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D318206DF
	for <linux-cifs@archiver.kernel.org>; Sun, 29 Nov 2020 16:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="XCoDCAkc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgK2Qld (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 Nov 2020 11:41:33 -0500
Received: from mx.cjr.nz ([51.158.111.142]:7282 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgK2Qld (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 29 Nov 2020 11:41:33 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 54B757FD0A;
        Sun, 29 Nov 2020 16:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1606668051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q/pFnKkQYbu/h5xtPtgeKh9ofx/CALMoPdgBX9opbnA=;
        b=XCoDCAkcZnQItk4wRi0yuXc4ozm4/eH5LGNyHwaYiAs+kZp3y3+XKC/hk3AmpmElDXesxw
        7oYqWNeM9pv7fowjTx7VhJTU05V9h3XYPsAi27L0cerf0KwRpPszAa+FVvHa+oKLaG4NhO
        MksQTxPqqD5J48pdg8mpEKDhWSvOlgpCOTHqS+xyS3kzVdT5/5b0KW6GyIQ24y1m10alUj
        lGvSgxcrQG7mO+PVVxnDbN9X7gNZo3xJRYYsZZyKX9svJY+0rNq5S/8jTE6ACs3A02Uswx
        HXpjAj5JxTs25mnkXOyerjvkbmxwekIDOxcd8N31XaavPZsx/iX5FsiQAOb6Nw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: allow syscalls to be restarted in __smb_send_rqst()
In-Reply-To: <CAH2r5msFYUB7RmWjCxQH8s8Amz4eET8_u8V5qZq3KMhdRFDPrA@mail.gmail.com>
References: <20201128185706.8968-1-pc@cjr.nz>
 <CAH2r5msFYUB7RmWjCxQH8s8Amz4eET8_u8V5qZq3KMhdRFDPrA@mail.gmail.com>
Date:   Sun, 29 Nov 2020 13:40:45 -0300
Message-ID: <87blfgjeuq.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> Did it fix the customer application?

Yes, it did.

> Thoughts on cc:stable?

Looks like a great candidate, yes.
