Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4741FC433ED
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 02:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F4A461105
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 02:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhDICEp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 22:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbhDICEo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 22:04:44 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BD3C061760
        for <linux-cifs@vger.kernel.org>; Thu,  8 Apr 2021 19:04:31 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lUgVT-003sc1-Ve; Fri, 09 Apr 2021 02:04:24 +0000
Date:   Fri, 9 Apr 2021 02:04:23 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [CFT] vfs.git #work.cifs
Message-ID: <YG+2J/JAD06Wj3MJ@zeniv-ca.linux.org.uk>
References: <YG+yK97KkSTkhwx7@zeniv-ca.linux.org.uk>
 <CAH2r5msLHRQT5dT5KpT-41ScvhYt-23=KbYNQTfmp_DPX+R1EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msLHRQT5dT5KpT-41ScvhYt-23=KbYNQTfmp_DPX+R1EQ@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Apr 08, 2021 at 08:54:35PM -0500, Steve French wrote:
> I can put the patches back into the automated test bucket tomorrow.
> There was a problem with the last patch of the series breaking, but
> all the rest looked fine before.  I wanted to add onto those the
> change (and earlier WIP patch of mine) to move the conversion of path
> separators (depending on dialect) '/' to '\' to later (not in
> build_path_from_dentry ... but rather later (where it is safer to do
> the conversion) e.g. when the pathname is translated (usually from
> UTF8 to UCS2 Unicode).
> 
> Setting up Samba server is pretty easy for testing - some of the
> instructions are on the Samba xfstesting wiki page
> 
> Also interesting that it could even be a bit easier (setting up
> automated testing on localhost) for some soon by testing to the kernel
> server (ksmbd) but that is currently in linux-next not mainline (yet)
> pending working through various code review comments, patches etc.

Umm... the failing tests tended to be the ones with "azure" in names;
"samba" counterparts passed, IIRC...
