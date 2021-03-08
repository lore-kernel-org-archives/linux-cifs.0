Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F8EC433E9
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 22:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F27A364F93
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 22:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhCHWWP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:22:15 -0500
Received: from mx.cjr.nz ([51.158.111.142]:11594 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230156AbhCHWVu (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 8 Mar 2021 17:21:50 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id ED87F7FD3B;
        Mon,  8 Mar 2021 22:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1615242098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y81cuVzy0QoI0R6om7wCcmnegUKIzYzS0UtYzRV/Oe8=;
        b=S5bC6tYH0Su6j+N6gLHBN6loHpP8IAaHBqNvSDL7UpKPPb10R09YN+pDNgxTZjurlzy5VV
        0TLoAF9dIHpQ+fgkqvVVeP/G/XDe46rn0HTc+nKcPzB7BvLuBgB/5S4pzAJ9OuuRRzFPAI
        f8kWkkoZuBOMc5+KsNmlbBjZWjrdYrMAWkArS8XSxNeIlsGEQP53+4IqbkBk9OFXN5Plm6
        fi86jjceE7frARa7LFjU9l8vZjLYwJdYI+h10eyi24HZV3BHTwqOiAcAfKyRABMDxtTuQx
        Bv+Bj+jXKAHKqMTKsx7kXL+YDa3fStu/KhTROMS7nj2dckisDmAPeSgsG2sUdw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 3/4] cifs: return proper error code in statfs(2)
In-Reply-To: <CAH2r5mt1hF3AjgT0mhjH9wgaoFby9TvnKZ_u+=bLj8LvxKS9hw@mail.gmail.com>
References: <20210308150050.19902-1-pc@cjr.nz>
 <20210308150050.19902-3-pc@cjr.nz>
 <CAH2r5mt1hF3AjgT0mhjH9wgaoFby9TvnKZ_u+=bLj8LvxKS9hw@mail.gmail.com>
Date:   Mon, 08 Mar 2021 19:21:33 -0300
Message-ID: <878s6x70cy.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> cc:stable?

Yes, please.
