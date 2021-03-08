Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180CEC433DB
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 22:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B69F96523D
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 22:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhCHWWQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:22:16 -0500
Received: from mx.cjr.nz ([51.158.111.142]:11854 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhCHWWK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 8 Mar 2021 17:22:10 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id D58157FD3B;
        Mon,  8 Mar 2021 22:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1615242129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0PqgY3WGfot8+QkqZF1PxJfgEaN/oVuCkxxzEfcK3B4=;
        b=kDjPjb74jE+UG0ShJsrQmhO3huBoYMFL0VXhv7poCnnRKFZX3P2Xex9k+VSg4SeXSEDSRn
        9nTXU5Q/L7SspkJJCSrmkLB/c4r9qo+Ssd0Btk3NhlEEkt2+5nMtMzaiQMxV3EuE32sMJ+
        9J2znItGl4uZ2pL205tkLuIkzfK/qMZCl3gPQyViRhnFR3YV1rbr86ZiWTRnPFaS9ULlrP
        hW/YJb6KlBczWLY1EHQbJP7qvqR8Vomd6fSTtqn847pZDmNwruQV/AAqiKG8ePfnKbNkGX
        emfHOZTYHeZ8IJH7R8++uulX9o8WrnUK6TaFLEmEYMHWQQ1kNi+dqkyAAqaF8w==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 4/4] cifs: do not send close in compound create+close
 requests
In-Reply-To: <CAH2r5mvddtiKs_X7QgwpKQpGRiKaWdTD366jVNaN=H8Ha_hzyQ@mail.gmail.com>
References: <20210308150050.19902-1-pc@cjr.nz>
 <20210308150050.19902-4-pc@cjr.nz>
 <CAH2r5mvddtiKs_X7QgwpKQpGRiKaWdTD366jVNaN=H8Ha_hzyQ@mail.gmail.com>
Date:   Mon, 08 Mar 2021 19:22:05 -0300
Message-ID: <875z2170c2.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> stable?

Yes, please.
