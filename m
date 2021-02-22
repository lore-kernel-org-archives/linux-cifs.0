Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2768EC433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Feb 2021 17:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E595664ED6
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Feb 2021 17:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhBVRCz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Feb 2021 12:02:55 -0500
Received: from blockout.pre-sense.de ([213.238.39.74]:59969 "EHLO
        mail.pre-sense.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230316AbhBVRCz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Feb 2021 12:02:55 -0500
Received: from smtp.pre-sense.de (tetris_b.pre-sense.de [10.9.0.76])
        by mail.pre-sense.de (Postfix) with ESMTP id 37D5B5E42E;
        Mon, 22 Feb 2021 18:02:11 +0100 (CET)
Received: from atlan.none (dynamic-095-112-249-201.95.112.pool.telefonica.de [95.112.249.201])
        by smtp.pre-sense.de (Postfix) with ESMTPS id 5DEBE127E;
        Mon, 22 Feb 2021 18:01:35 +0100 (CET)
To:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
References: <c04ed8bc-9a36-0ff5-6b5f-1fce3d2d1402@pre-sense.de>
 <874ki41k5n.fsf@suse.com>
 <CAH2r5msGOKUYRiBS8vk79a+zJK4ijRU8rQAneEU-gW3EvjSNZg@mail.gmail.com>
 <CAH2r5mtL4Q-2g2Mrchz7Y=hXXypMj6R298wjhdO6+o4XUzGBOg@mail.gmail.com>
From:   =?UTF-8?Q?Till_D=c3=b6rges?= <doerges@pre-sense.de>
Organization: PRESENSE Technologies GmbH
Subject: Re: Mounting share on NetApp using SMB 3.1.1 and encryption
Message-ID: <916ffc5f-3af8-4f8d-e49f-5ebc9f885af1@pre-sense.de>
Date:   Mon, 22 Feb 2021 18:02:10 +0100
User-Agent: Thunderbird
MIME-Version: 1.0
In-Reply-To: <CAH2r5mtL4Q-2g2Mrchz7Y=hXXypMj6R298wjhdO6+o4XUzGBOg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello everyone,


@Aurélien, Steve:

Thanks for your answers.


Am 22.02.21 um 11:17 schrieb Aurélien Aptel:

> The nested namespace might be problematic. DFS is tricky.


Am 22.02.21 um 17:45 schrieb Steve French:

> LinuxCIFSKernel - SambaWiki
> <https://wiki.samba.org/index.php/LinuxCIFSKernel#Changes_by_release>
> 
> for list of when features went in, although many distros backport these
> features to older kernels.


There's been progress. A simple test case (no DFS/nested NS) works fine with 3.1.1 
and encryption.

So currently it looks like DFS and/or NS might in deed be the problem.


Since I'm not exactly sure how much has been added/backported to the cifs.ko I'm 
using (it reports as version 2.22), I'll try a recent vanilla Linux Kernel.

For version 2.28 the changelog states "Various DFS (global namespace) fixes." Maybe 
that already does it.


And if that doesn't work I'll proceed according to 
https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting


Thanks again and regards -- Till
-- 
Dipl.-Inform. Till Dörges                  doerges@pre-sense.de

PRESENSE Technologies GmbH             Nagelsweg 41, D-20097 HH
Geschäftsführer/Managing Directors       AG Hamburg, HRB 107844
Till Dörges, Jürgen Sander               USt-IdNr.: DE263765024
