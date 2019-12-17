Return-Path: <SRS0=5M6x=2H=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31F2C43603
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Dec 2019 10:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3B502072D
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Dec 2019 10:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfLQKH1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Dec 2019 05:07:27 -0500
Received: from mail.sernet.de ([185.199.217.2]:40749 "EHLO mail.SerNet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbfLQKH1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 17 Dec 2019 05:07:27 -0500
Received: from intern.SerNet.DE by mail.SerNet.DE
        with esmtps (Exim 4.92 #3)
        id 1ih9lE-0005fn-EQ; Tue, 17 Dec 2019 11:07:24 +0100
Received: by intern.sernet.de
        id 1ih9lE-0008SK-C2; Tue, 17 Dec 2019 11:07:24 +0100
Received: from bjacke by pell.sernet.de with local (Exim 4.90_1)
        (envelope-from <bjacke@sernet.de>)
        id 1ih9lE-00017m-03; Tue, 17 Dec 2019 11:07:24 +0100
Date:   Tue, 17 Dec 2019 11:07:23 +0100
From:   =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@SerNet.DE>
To:     =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: cifs multiuser mode and per session treatment
Message-ID: <20191217100723.GB18027@sernet.de>
References: <20191213121452.GA12253@sernet.de>
 <8736dkv6ub.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8736dkv6ub.fsf@suse.com>
X-Q:    Die Schriftsteller koennen nicht so schnell schreiben, wie die
 Regierungen Kriege machen; denn das Schreiben verlangt Denkarbeit. - Brecht
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2019-12-16 at 12:38 +0100 Aurélien Aptel sent off:
> In terms of implementation each cifs mount stores a dictionnary mapping
> uid to TreeCon (it's the tlink rb-tree, see cifs_sb_tlink(),
> tlink_rb_search(), etc).
> 
> I think it should just be a matter of storing the session id as the key
> in the tlink rb-tree instead of uid (we use fsuid actually). This way
> when a new session does a syscall on the mount, the lookup will fail, it
> will try to create a new tlink, and fail unless there is the krb stuff
> in the keyring.

Awewone, looks like you have a plan already.


> But are you sure root cannot "enter" an existing user session? I think
> I've done it for screen sessions in the past...

screen sessions are only local sockets without access protection from the
kernel. I can't say for sure if there is a way for root to access users'
session keyrings (I didn't find any) but it was one of the goals of the session
keyring implementation that not even root can access the user keys in there.

Cheers
Björn
