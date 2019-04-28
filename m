Return-Path: <SRS0=iF1N=S6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74711C43218
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Apr 2019 14:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48CAD206E0
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Apr 2019 14:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfD1Os4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 Apr 2019 10:48:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40234 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfD1Os4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 28 Apr 2019 10:48:56 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hKl6p-0001uM-0n; Sun, 28 Apr 2019 14:48:51 +0000
Date:   Sun, 28 Apr 2019 15:48:50 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [GIT PULL] Ceph fixes for 5.1-rc7
Message-ID: <20190428144850.GA23075@ZenIV.linux.org.uk>
References: <20190425174739.27604-1-idryomov@gmail.com>
 <CAHk-=wgPBx9xPWY7obK60=RTnOF3Ln0j9XkhYbekML=Fi3bFXg@mail.gmail.com>
 <342ef35feb1110197108068d10e518742823a210.camel@kernel.org>
 <20190425200941.GW2217@ZenIV.linux.org.uk>
 <86674e79e9f24e81feda75bc3c0dd4215604ffa5.camel@kernel.org>
 <20190426165055.GY2217@ZenIV.linux.org.uk>
 <b175faae4bb98d3379a8642fe5f4e00587c3a734.camel@kernel.org>
 <20190428043801.GE2217@ZenIV.linux.org.uk>
 <7bac7ba5655a8e783a70f915853a0846e7ff143b.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bac7ba5655a8e783a70f915853a0846e7ff143b.camel@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Apr 28, 2019 at 09:27:20AM -0400, Jeff Layton wrote:

> I don't see a problem doing what you suggest. An offset + fixed length
> buffer would be fine there.
> 
> Is there a real benefit to using __getname though? It sucks when we have
> to reallocate but I doubt that it happens with any frequency. Most of
> these paths will end up being much shorter than PATH_MAX and that slims
> down the memory footprint a bit.

AFAICS, they are all short-lived; don't forget that slabs have cache,
so in that situation allocations are cheap.

> Also, FWIW -- this code was originally copied from cifs'
> build_path_from_dentry(). Should we aim to put something in common
> infrastructure that both can call?
> 
> There are some significant logic differences in the two functions though
> so we might need some sort of callback function or something to know
> when to stop walking.

Not if you want it fast...  Indirect calls are not cheap; the cost of
those callbacks would be considerable.  Besides, you want more than
"where do I stop", right?  It's also "what output do I use for this
dentry", both for you and for cifs (there it's "which separator to use",
in ceph it's "these we want represented as //")...

Can it be called on detached subtree, during e.g. open_by_handle()?
There it can get really fishy; you end up with base being at the
random point on the way towards root.  How does that work, and if
it *does* work, why do we need the whole path in the first place?

BTW, for cifs there's no need to play with ->d_lock as we go.  For
ceph, the only need comes from looking at d_inode(), and I wonder if
it would be better to duplicate that information ("is that a
snapdir/nosnap") into dentry iself - would certainly be cheaper.
OTOH, we are getting short on spare bits in ->d_flags...
