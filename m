Return-Path: <SRS0=iF1N=S6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139ADC43219
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Apr 2019 16:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAFFF206A3
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Apr 2019 16:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfD1Qke (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 Apr 2019 12:40:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41822 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfD1Qke (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 28 Apr 2019 12:40:34 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hKmqs-0004Vn-Ld; Sun, 28 Apr 2019 16:40:30 +0000
Date:   Sun, 28 Apr 2019 17:40:30 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [GIT PULL] Ceph fixes for 5.1-rc7
Message-ID: <20190428164030.GC23075@ZenIV.linux.org.uk>
References: <342ef35feb1110197108068d10e518742823a210.camel@kernel.org>
 <20190425200941.GW2217@ZenIV.linux.org.uk>
 <86674e79e9f24e81feda75bc3c0dd4215604ffa5.camel@kernel.org>
 <20190426165055.GY2217@ZenIV.linux.org.uk>
 <b175faae4bb98d3379a8642fe5f4e00587c3a734.camel@kernel.org>
 <20190428043801.GE2217@ZenIV.linux.org.uk>
 <7bac7ba5655a8e783a70f915853a0846e7ff143b.camel@kernel.org>
 <20190428144850.GA23075@ZenIV.linux.org.uk>
 <b875fdb47e17ab68d18c5e5e5cbd0ec70fec7ce9.camel@kernel.org>
 <20190428155216.GB23075@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428155216.GB23075@ZenIV.linux.org.uk>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Apr 28, 2019 at 04:52:16PM +0100, Al Viro wrote:
> On Sun, Apr 28, 2019 at 11:47:58AM -0400, Jeff Layton wrote:
> 
> > We could stick that in ceph_dentry_info (->d_fsdata). We have a flags
> > field in there already.
> 
> Yes, but...  You have it freed in ->d_release(), AFAICS, and without
> any delays.  So lockless accesses will be trouble.

You could RCU-delay the actual kmem_cache_free(ceph_dentry_cachep, di)
in there, but I've no idea whether the overhead would be painful -
on massive eviction (e.g. on memory pressure) it might be.  Another
variant is to introduce ->d_free(), to be called from __d_free()
and __d_free_external().  That, however, would need another ->d_flags
bit for presence of that method, so that we don't get extra overhead
from looking into ->d_op...

Looking through ->d_release() instances, we have

afs: empty, might as well have not been there

autofs: does some sync stuff (eviction from ->active_list/->expire_list)
plus kfree_rcu

ceph: some sync stuff + immediate kmem_cache_free()

debugfs: kfree(), might or might not be worth RCU-delaying

ecryptfs: sync stuff (path_put for ->lower) + RCU-delayed part

fuse: kfree_rcu()

nfs: kfree()

overlayfs: a bunch of dput() (obviously sync) + kfree_rcu()

9p: sync

So it actually might make sense to move the RCU-delayed bits to
separate method.  Some ->d_release() instances would be simply
gone, as for the rest...  I wonder which of the sync parts can
be moved over to ->d_prune().  Not guaranteed to be doable
(or a good idea), but...  E.g. for autofs it almost certainly
would be the right place for the sync parts - we are,
essentially, telling the filesystem to forget its private
(non-refcounted) references to the victim.
