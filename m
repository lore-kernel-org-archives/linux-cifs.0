Return-Path: <SRS0=ZQfQ=2G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE103C43603
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Dec 2019 11:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0236206EC
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Dec 2019 11:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfLPLiI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Dec 2019 06:38:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:55652 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727199AbfLPLiI (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 16 Dec 2019 06:38:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B7CF8AB89;
        Mon, 16 Dec 2019 11:38:06 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     =?utf-8?Q?Bj=C3=B6rn?= JACKE <bj@SerNet.DE>,
        linux-cifs@vger.kernel.org
Subject: Re: cifs multiuser mode and per session treatment
In-Reply-To: <20191213121452.GA12253@sernet.de>
References: <20191213121452.GA12253@sernet.de>
Date:   Mon, 16 Dec 2019 12:38:04 +0100
Message-ID: <8736dkv6ub.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Björn,

Björn JACKE <bj@SerNet.DE> writes:
> cifs.upcall might need some tuning to make use of a session keyring but even if
> that would be done, there is still one important limitation left to solve: cifs

IIRC cifs.upcall uses the session keyring already. 

> multiuser SMB connections should also be initiated per session, same like the
> keyring. Currently the cifs SMB connections are accessible also from other all
> sessions.

That needs to be implemented indeed.

> For example if I kinit a ticket, access a multiuser cifs mount successfully (so
> that the smb session is initiated), then kdestroy my ticket, log in to the
> machine again to open a new session, and then access the multiuser cifs mount
> from there, this is currently successful. For a cifs multiuser mount with per
> session limitation, this access should be denied accordingly.

I think I understood.

In terms of implementation each cifs mount stores a dictionnary mapping
uid to TreeCon (it's the tlink rb-tree, see cifs_sb_tlink(),
tlink_rb_search(), etc).

I think it should just be a matter of storing the session id as the key
in the tlink rb-tree instead of uid (we use fsuid actually). This way
when a new session does a syscall on the mount, the lookup will fail, it
will try to create a new tlink, and fail unless there is the krb stuff
in the keyring.

But are you sure root cannot "enter" an existing user session? I think
I've done it for screen sessions in the past... If yes, would this make
this per-session smb session pointless or is there still some value? 

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
