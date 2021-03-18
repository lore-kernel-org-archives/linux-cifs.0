Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B95C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 08:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7910F64F33
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 08:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCRIGT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 04:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhCRIGK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Mar 2021 04:06:10 -0400
X-Greylist: delayed 940 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 18 Mar 2021 01:06:10 PDT
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61692C06174A
        for <linux-cifs@vger.kernel.org>; Thu, 18 Mar 2021 01:06:10 -0700 (PDT)
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        for linux-cifs@vger.kernel.org
        id 1lMnQH-00037x-Bg; Thu, 18 Mar 2021 08:50:25 +0100
Received: by intern.sernet.de
        id 1lMnQH-0004UU-8Q; Thu, 18 Mar 2021 08:50:25 +0100
Received: from bjacke by pell.sernet.de with local (Exim 4.93)
        (envelope-from <bjacke@sernet.de>)
        id 1lMnQH-002WIB-2m
        for linux-cifs@vger.kernel.org; Thu, 18 Mar 2021 08:50:25 +0100
Date:   Thu, 18 Mar 2021 08:50:25 +0100
From:   =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@SerNet.DE>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: we actually need richacls ...
Message-ID: <20210318075025.GA600594@sernet.de>
References: <bug-14494-10630@https.bugzilla.samba.org/>
 <bug-14494-10630-dugIJZXmUw@https.bugzilla.samba.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bug-14494-10630-dugIJZXmUw@https.bugzilla.samba.org/>
X-Q:    Die Schriftsteller koennen nicht so schnell schreiben, wie die
 Regierungen Kriege machen; denn das Schreiben verlangt Denkarbeit. - Brecht
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2021-03-18 at 07:33 +0000 samba-bugs@samba.org sent off:
> --- Comment #1 from Björn Jacke <bjacke@samba.org> ---
> Generlly much of the cifsacl stuff is really nice bug with the outstanding
> bugs, some of those that Micah  reported, cifs vfs with NT ACLs is just not
> usable and people who *need* to use full NT ACLs with a POSIX client have no
> other option than using a different OS with native NFS4 ACLs support like
> FreeBSD currently.

it would also be great if the cifs developers would all trogether try to
convince the kernel developers that the richacl implmentation gets upstreamed.
cifs vfs urgently needs it. NT ACLs on POSIX clients are practically unusabe
without having richalcs. Same for the upcoming cifs kernel server.

I tried to bring up the richacl topic a while ago on the kerenel mailing list
but the voices of many of the cifs developers will be much more significant and
can not so easily be ignored by the kernel maintainer I think.

Björn
