Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7834C433B4
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 18:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97D4360FD8
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 18:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbhETSKi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 May 2021 14:10:38 -0400
Received: from mx.cjr.nz ([51.158.111.142]:32334 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhETSKh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 20 May 2021 14:10:37 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 9364D80BAA;
        Thu, 20 May 2021 18:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1621534154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=shBKbqiu0Nc70PxClEYNiRFdqspXWs3SR4czrdwAN9k=;
        b=EFywGGbKe5B7JS/idAObSVpHqKD5QSix4CsKBNjXtI8nwtDtbbKshJwHuZNGSorUXs85TW
        rVx6Xs0GY6BCfhqvDRso3mPwSMl3ykZzO02H5y0eIXU47iZn3UVwo31AXGPwZxW/uafJyK
        U/0DAf3kdG87/BgGH2RQaF4kbWasJsPU6N6FN3baEttbkrXD5BCulPoq8O0+It8XaIi33+
        RpNyApbpGRxA7h/1znz1KKl6s01UR+igqFKOV3c3k13qKzXjJNTQAj2tKIC1lpF1iVnmG9
        xFM5NWfnNZXSuq34kZTBdoB4YA9FzhWW5RLMlhlY+kYNEDlO7Mv4GQymr++vFQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: use the expiry output of dns_query to schedule
 next resolution
In-Reply-To: <CANT5p=qzxhOjAY_s9NMsiS5F4FtsNJXytHbihF+esv+n4ytDvw@mail.gmail.com>
References: <CANT5p=qzxhOjAY_s9NMsiS5F4FtsNJXytHbihF+esv+n4ytDvw@mail.gmail.com>
Date:   Thu, 20 May 2021 15:09:00 -0300
Message-ID: <87wnrtl1kz.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> @Paulo Alcantara I know this can create merge conflicts when your
> patch gets merged.
> I can rebase my changes on top of yours when it gets merged.

No worries.  Thanks for letting me know.

I'll rebase mine on top of yours when I finish the dfs series.
