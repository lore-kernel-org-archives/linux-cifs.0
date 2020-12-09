Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFCFC433FE
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 12:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF2B723B23
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 12:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731157AbgLIMhH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 07:37:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:41174 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730658AbgLIMhB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 9 Dec 2020 07:37:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 374F4ACEB;
        Wed,  9 Dec 2020 12:36:20 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.de>
To:     scabrero@suse.de, linux-cifs@vger.kernel.org,
        Steve French <smfrench@gmail.com>,
        Paulo Alcantara <palcantara@suse.de>
Subject: Re: [PATCH v4 00/11] Witness protocol support for transparent failover
In-Reply-To: <20201130180257.31787-1-scabrero@suse.de>
References: <20201130180257.31787-1-scabrero@suse.de>
Date:   Wed, 09 Dec 2020 13:36:19 +0100
Message-ID: <87a6undum4.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

I've added a "failover" test group to the buildbot that mounts a
"regular" (non-scaleout) cluster and switches the fileserver to another
cluster node live and it looks like it's working: you can keep on using
the mount.

In non-scale-out, the file server has its own virtual IP that both node
share. So when you "move" the fileserver to a different node, it doesn't
actually change IP. After doing that we realized that this actually
works already without -o witness since it's reconnecting to the same IP.

Now we need to add a scale-out cluster fileserver in buildbot where,
IIUC (please correct me Samuel) the fileserver is actually using the
node IP instead of this virtual-IP shared by nodes. So that when we move
the fileserver, it actually changes its IP address and we can test this
properly.

As for the code, I'm not an expert on reconnection but it looks for
merging I think. It doesn't handle multichannel but multchannel doesn't
handle reconnection well anyway. There is an issue which pops up in
other parts of the code as well.

If you run a command too quickly after the transition, they will fail
with EIO so it's not completely failing over but I think there can be
the same issue with DFS (Paulo, any ideas/comments?)  which is why we do
2 times ls and we ignore the result of the first in the DFS tests.

the dfs test code:

    def io_reco_test(unc, opts, cwd, expected):
        try:
            lsdir = '.'
            cddir = os.path.join(ARGS.mnt, cwd)
            info(("TEST: mount {unc} , cd {cddir} , ls {lsdir}, expect:[{expect}]\n"+
                  "      disconnect {cddir} , ls#1 {lsdir} (fail here is ok),  ls#2 (fail here NOT ok)").format(
                      unc=unc, cddir=cddir, lsdir=lsdir, expect=" ".join(['"%s"'%x for x in expected])
                  ))


Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
