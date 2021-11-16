Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5044CC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 15:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EA4F60F38
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 15:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbhKPPcK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Nov 2021 10:32:10 -0500
Received: from mx.cjr.nz ([51.158.111.142]:62144 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238265AbhKPPcG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 16 Nov 2021 10:32:06 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 515DE8081B;
        Tue, 16 Nov 2021 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1637076544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jLIDXb1I+WF8y+VTx5XN0MSt/PCPnyg02IMSd6o13YM=;
        b=M+F3vN2sy3f+ddmUtjdbEgBMHEytSiUe8ELig91oyt4v/zK9DVAhLGV2gwGizqPCPL1c+w
        COXhPHrQhR40qP7zNrwfvnb/aZdEAIkO2apKUfky/5xzoRatmEB5Y2RA+G3bUijDLzG9cz
        c1BeIpgosVZw6JlTECAVylm5bJbU8EjZGmOm6uxa4QVbPpv6eEgvZl2LOJUaRzvtFM1RQI
        hIb4CMAfJULwgVTWddEu97ZlWe8aUs9Ea4Ekq5RVfc3t67aBXAh9NpxaoTw2v1NGSK1OeV
        qCpS9l1haIWE6Cop47IraC8jrQKirbi82RtkLzkewnQ0wFYm02K2y+GQLg0QgA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
Subject: Re: [PATCH] trivial coverity cleanup from multichannel series
In-Reply-To: <CAH2r5msH=b0UCkxfXsCEHpqQxkcvJ68qUSD+cy6JeMYi17zsHA@mail.gmail.com>
References: <CAH2r5msH=b0UCkxfXsCEHpqQxkcvJ68qUSD+cy6JeMYi17zsHA@mail.gmail.com>
Date:   Tue, 16 Nov 2021 12:28:59 -0300
Message-ID: <87a6i415ms.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good,

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
