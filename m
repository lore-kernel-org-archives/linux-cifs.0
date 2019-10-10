Return-Path: <SRS0=PeaU=YD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB95C10F14
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Oct 2019 07:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5540C218AC
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Oct 2019 07:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732944AbfJJHiI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Oct 2019 03:38:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:40106 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733012AbfJJHWT (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 10 Oct 2019 03:22:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BA635AE48;
        Thu, 10 Oct 2019 07:22:18 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Kenneth Dsouza <kdsouza@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] smb2quota.py: Userspace helper to display quota
 information for the Linux SMB client file system (CIFS)
In-Reply-To: <CAN05THSfA9e1DP9+nM=CkgU-mKRnUeJp2p96umrOA3aBiWe9Gg@mail.gmail.com>
References: <20190924045611.21689-1-kdsouza@redhat.com>
 <87o8yqf4f6.fsf@suse.com>
 <CAA_-hQL8MpS9YEcaQpuiQnbsuJwerutnbxWhE-Fyk1X4jpvwcw@mail.gmail.com>
 <87k19ef0si.fsf@suse.com>
 <CAN05THSfA9e1DP9+nM=CkgU-mKRnUeJp2p96umrOA3aBiWe9Gg@mail.gmail.com>
Date:   Thu, 10 Oct 2019 09:22:17 +0200
Message-ID: <87h84hf4k6.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"ronnie sahlberg" <ronniesahlberg@gmail.com> writes:
> I think it would be good to have these tools as part of the actual install.
> They are in python so they are imho much more useful to the target users
> (sysadmins) than a utility written in C.
> (I kind of regret that smbinfo is in C, it should have been python
> too:-( )

I completely agree, we could rewrite smbinfo in python.

> Maybe we just need to decide on a naming prefix for these utilities
> and then there shouldn't be
> a problem to add many small useful tools.

We can also make the C code call the python script for now (or vice
versa, while smbinfo gets rewritten).

> The nice thing with small python tools is that it is so easy to tweak
> them to specific usecases.

+100

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
