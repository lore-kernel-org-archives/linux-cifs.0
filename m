Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33F6C43334
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Jul 2022 21:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiGOVk0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Jul 2022 17:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiGOVkZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Jul 2022 17:40:25 -0400
X-Greylist: delayed 639 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jul 2022 14:40:24 PDT
Received: from c.mail.sonic.net (c.mail.sonic.net [64.142.111.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B342E8149B
        for <linux-cifs@vger.kernel.org>; Fri, 15 Jul 2022 14:40:24 -0700 (PDT)
Received: from ocelot (157-131-251-247.fiber.dynamic.sonic.net [157.131.251.247])
        (authenticated bits=0)
        by c.mail.sonic.net (8.16.1/8.16.1) with ESMTPA id 26FLTem5032435;
        Fri, 15 Jul 2022 14:29:40 -0700
From:   Forest <forestix@sonic.net>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>
Subject: Re: getxattr() on cifs sometimes hangs since kernel 5.14
Date:   Fri, 15 Jul 2022 14:29:40 -0700
Message-ID: <5fm3dhtbeenvgekqbgc6u4dsrjahq9m08p@4ax.com>
References: <91188ht5vqi7kq3ml5d3a48sjo9ltqjko3@4ax.com> <CAN05THT8uZiDC_PS+HYyLAytGOze_nrVkzq9zbHSMiHYpB+3ug@mail.gmail.com>
In-Reply-To: <CAN05THT8uZiDC_PS+HYyLAytGOze_nrVkzq9zbHSMiHYpB+3ug@mail.gmail.com>
X-Mailer: Forte Agent 3.3/32.846
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Sonic-CAuth: UmFuZG9tSVaukvjo6y8q0RBfZ1Rx8aMd6FETEovNiRPsGgDVSth1c6U5ggEaKQZbilDS5LPY425aUOw02hrSvlUxmWiY7Ssl
X-Sonic-ID: C;nq0TPIUE7RGlUPU2He8XJw== M;Fk8dPIUE7RGlUPU2He8XJw==
X-Sonic-Spam-Details: 0.0/5.0 by cerberusd
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 18 May 2022 13:18:02 +1000, ronnie sahlberg wrote:

>Please post the reproducer. It will be useful for testing as well as
>verifying if a potential fix.

I sent the reproducer to you guys back in May, but forgot to cc: the list.
There is now a report in bugzilla, with the reproducer attached:

https://bugzilla.samba.org/show_bug.cgi?id=15123

I'm dropping off the mailing list, but updates to the bug report should
still reach me.
