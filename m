Return-Path: <SRS0=M6PW=B3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAA2C433DF
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Aug 2020 08:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40F6F20658
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Aug 2020 08:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgHQIsY convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:48:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:38500 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbgHQIsR (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 17 Aug 2020 04:48:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B0053AE91;
        Mon, 17 Aug 2020 08:48:40 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, samba-technical@lists.samba.org,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>, sribhat.msa@outlook.com
Subject: Re: [PATCH][SMB3] mount.cifs integration with PAM
In-Reply-To: <CANT5p=oeY91u17DPe6WO75Eq_bjzrVC0kmAErrZ=h3S1qh-Wxw@mail.gmail.com>
References: <CANT5p=pxPsBwAv3oJX6Ae9wjpZoEjLvyfGM1sM9DEhS11RNgog@mail.gmail.com>
 <87pn7t4kr9.fsf@suse.com>
 <CANT5p=oeY91u17DPe6WO75Eq_bjzrVC0kmAErrZ=h3S1qh-Wxw@mail.gmail.com>
Date:   Mon, 17 Aug 2020 10:48:13 +0200
Message-ID: <87eeo54q0i.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> Agreed. But since we're not dealing with krb5cc file directly in
> mount.cifs, I don't see it influencing this change. However, I will test it
> out too.

When reconnecting or accessing DFS links (cross-server symlinks) the
client opens a new connection to the target server and has to auth
again. Since there are no ways to ask for a password at that moment
(we're in the middle of some syscall) cifs.ko does an upcall to
cifs.upcall and passes the pid of the process who initiated the
syscall. cifs.upcall then reads that proc env (via /proc/<pid>/environ)
and looks for KRB5CCNAME, uses it and returns the required data for
cifs.ko to proceed with the SMB Session Setup.

So it is important to have this env var set if the location of the
credential cache is not the default one. If you do PAM login from
mount.cifs, the env var might be set for that process but it will only
persist in children processes of mount.cifs i.e. most likely none.

I still think this patch is a good idea but we should definitely print
something to the user that things might fail later on, or give
instructions to set the env var in the user shell or something like that.

> That does make sense. I was thinking of including a mount option to enable
> this path. But let me explore the retry-on-failure path as well.

Mount option sounds good regardless.

> Yeah. I didn't get the complete picture on session maintenance after
> reading the pam application developer's guide.
> Was hoping that somebody on samba-technical would have some idea about this.

The keyring docs have some info on it too but it's still not clear to
me.

https://man7.org/linux/man-pages/man7/session-keyring.7.html

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
