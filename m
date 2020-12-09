Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9B9C4361B
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 15:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A39D23AC4
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 15:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgLIPG5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 10:06:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:57894 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbgLIPG5 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 9 Dec 2020 10:06:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 456F7ACF4;
        Wed,  9 Dec 2020 15:06:15 +0000 (UTC)
From:   Paulo Alcantara <palcantara@suse.de>
To:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.de>, scabrero@suse.de,
        linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
Subject: Re: [PATCH v4 00/11] Witness protocol support for transparent failover
In-Reply-To: <87a6undum4.fsf@suse.com>
References: <20201130180257.31787-1-scabrero@suse.de> <87a6undum4.fsf@suse.com>
Date:   Wed, 09 Dec 2020 12:06:11 -0300
Message-ID: <87tusvow7w.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aurélien Aptel <aaptel@suse.de> writes:

> I've added a "failover" test group to the buildbot that mounts a
> "regular" (non-scaleout) cluster and switches the fileserver to another
> cluster node live and it looks like it's working: you can keep on using
> the mount.
>
> In non-scale-out, the file server has its own virtual IP that both node
> share. So when you "move" the fileserver to a different node, it doesn't
> actually change IP. After doing that we realized that this actually
> works already without -o witness since it's reconnecting to the same IP.
>
> Now we need to add a scale-out cluster fileserver in buildbot where,
> IIUC (please correct me Samuel) the fileserver is actually using the
> node IP instead of this virtual-IP shared by nodes. So that when we move
> the fileserver, it actually changes its IP address and we can test this
> properly.
>
> As for the code, I'm not an expert on reconnection but it looks for
> merging I think. It doesn't handle multichannel but multchannel doesn't
> handle reconnection well anyway. There is an issue which pops up in
> other parts of the code as well.
>
> If you run a command too quickly after the transition, they will fail
> with EIO so it's not completely failing over but I think there can be
> the same issue with DFS (Paulo, any ideas/comments?)  which is why we do
> 2 times ls and we ignore the result of the first in the DFS tests.
>
> the dfs test code:
>
>     def io_reco_test(unc, opts, cwd, expected):
>         try:
>             lsdir = '.'
>             cddir = os.path.join(ARGS.mnt, cwd)
>             info(("TEST: mount {unc} , cd {cddir} , ls {lsdir}, expect:[{expect}]\n"+
>                   "      disconnect {cddir} , ls#1 {lsdir} (fail here is ok),  ls#2 (fail here NOT ok)").format(
>                       unc=unc, cddir=cddir, lsdir=lsdir, expect=" ".join(['"%s"'%x for x in expected])
>                   ))

For soft mounts, it is OK ignoring the first ls.  But for hard mounts,
we shouldn't ignore the first ls as it must retry forever until failover
is done.
