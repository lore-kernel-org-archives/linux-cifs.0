Return-Path: <SRS0=iF1N=S6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5743C43218
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Apr 2019 15:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D5172067C
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Apr 2019 15:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556466482;
	bh=1e9w9r2QRSeNypcp8eWRC6bh4F+buDCPj2PsTcrn58k=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=h0Qw7uqvA1OZEdp8O9UuwBfmNtjYfRKTn4CPUehZoEYCMk8PqxBpHBSkmbNTqiP/Q
	 SNabYOGlAq+YdfB5agpiVnGdfzQ+Rj6992R+kq0YUg7ogvmS4MRkff1N/RK8/jMb5W
	 es9/qSwGsKtXb1g3sjFyGJrjoGXLDejLnCofEzOE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfD1PsC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 Apr 2019 11:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726744AbfD1PsB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 28 Apr 2019 11:48:01 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A9FF20656;
        Sun, 28 Apr 2019 15:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556466480;
        bh=1e9w9r2QRSeNypcp8eWRC6bh4F+buDCPj2PsTcrn58k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iRh3zEG8ICSzQtUDi7dNIGMUStCJ5eQ7C7MtLNnmW7NpNzYDtrBpnzHzyx0hYLZ56
         Fpa7PkEcx/nt2zTXUDwMho50rjpUC2c40jTONzjv42o3alY//uYyHyqs+lf4S4J1dD
         A1A+ZzI4xeG2X8mKVaPMyBd+WCRCCmXDUsMkrvLo=
Message-ID: <b875fdb47e17ab68d18c5e5e5cbd0ec70fec7ce9.camel@kernel.org>
Subject: Re: [GIT PULL] Ceph fixes for 5.1-rc7
From:   Jeff Layton <jlayton@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Date:   Sun, 28 Apr 2019 11:47:58 -0400
In-Reply-To: <20190428144850.GA23075@ZenIV.linux.org.uk>
References: <20190425174739.27604-1-idryomov@gmail.com>
         <CAHk-=wgPBx9xPWY7obK60=RTnOF3Ln0j9XkhYbekML=Fi3bFXg@mail.gmail.com>
         <342ef35feb1110197108068d10e518742823a210.camel@kernel.org>
         <20190425200941.GW2217@ZenIV.linux.org.uk>
         <86674e79e9f24e81feda75bc3c0dd4215604ffa5.camel@kernel.org>
         <20190426165055.GY2217@ZenIV.linux.org.uk>
         <b175faae4bb98d3379a8642fe5f4e00587c3a734.camel@kernel.org>
         <20190428043801.GE2217@ZenIV.linux.org.uk>
         <7bac7ba5655a8e783a70f915853a0846e7ff143b.camel@kernel.org>
         <20190428144850.GA23075@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, 2019-04-28 at 15:48 +0100, Al Viro wrote:
> On Sun, Apr 28, 2019 at 09:27:20AM -0400, Jeff Layton wrote:
> 
> > I don't see a problem doing what you suggest. An offset + fixed length
> > buffer would be fine there.
> > 
> > Is there a real benefit to using __getname though? It sucks when we have
> > to reallocate but I doubt that it happens with any frequency. Most of
> > these paths will end up being much shorter than PATH_MAX and that slims
> > down the memory footprint a bit.
> 
> AFAICS, they are all short-lived; don't forget that slabs have cache,
> so in that situation allocations are cheap.
> 

Fair enough. Al also pointed out on IRC that the __getname/__putname
caches are likely to be hot, so using that may be less costly cpu-wise.

> > Also, FWIW -- this code was originally copied from cifs'
> > build_path_from_dentry(). Should we aim to put something in common
> > infrastructure that both can call?
> > 
> > There are some significant logic differences in the two functions though
> > so we might need some sort of callback function or something to know
> > when to stop walking.
> 
> Not if you want it fast...  Indirect calls are not cheap; the cost of
> those callbacks would be considerable.  Besides, you want more than
> "where do I stop", right?  It's also "what output do I use for this
> dentry", both for you and for cifs (there it's "which separator to use",
> in ceph it's "these we want represented as //")...
> 
> Can it be called on detached subtree, during e.g. open_by_handle()?
> There it can get really fishy; you end up with base being at the
> random point on the way towards root.  How does that work, and if
> it *does* work, why do we need the whole path in the first place?
> 

This I'm not sure of. commit 79b33c8874334e (ceph: snapshot nfs re-
export) explains this a bit, but I'm not sure it really covers this
case.

Zheng/Sage, feel free to correct me here:

My understanding is that for snapshots you need the base inode number,
snapid, and the full path from there to the dentry for a ceph MDS call.

There is a filehandle type for a snapshotted inode:

struct ceph_nfs_snapfh {
        u64 ino;
        u64 snapid;
        u64 parent_ino;
        u32 hash;
} __attribute__ ((packed));

So I guess it is possible. You could do name_to_handle_at for an inode
deep down in a snapshotted tree, and then try to open_by_handle_at after
the dcache gets cleaned out for some other reason.

What I'm not clear on is why we need to build paths at all for
snapshots. Why is a parent inode number (inside the snapshot) + a snapid
+ dentry name not sufficient?

> BTW, for cifs there's no need to play with ->d_lock as we go.  For
> ceph, the only need comes from looking at d_inode(), and I wonder if
> it would be better to duplicate that information ("is that a
> snapdir/nosnap") into dentry iself - would certainly be cheaper.
> OTOH, we are getting short on spare bits in ->d_flags...

We could stick that in ceph_dentry_info (->d_fsdata). We have a flags
field in there already.
-- 
Jeff Layton <jlayton@kernel.org>

