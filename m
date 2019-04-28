Return-Path: <SRS0=iF1N=S6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF601C43218
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Apr 2019 13:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 872BD20843
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Apr 2019 13:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556458044;
	bh=kXxRuMxpn6XuhqKDuNS/WvUjBrLbhsr6cIWv2K+eIJ4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=2KBAlOq91S6SLg8JtnurihUzZMvSKA+Odc5pCmAMN/2rECqHOVo7dmF7pm5adH5+9
	 99RgSue2Vl9eF4uRMSbKqSIo4128IqcecuxiQE9Ds95q8OwNXgv5dfrE+SpK5Jr5S6
	 sc9YVsc9SRPWULMuGprbGTUF9CZw3dClPx+uIMaA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfD1N1Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 Apr 2019 09:27:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfD1N1X (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 28 Apr 2019 09:27:23 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DA0F206A3;
        Sun, 28 Apr 2019 13:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556458043;
        bh=kXxRuMxpn6XuhqKDuNS/WvUjBrLbhsr6cIWv2K+eIJ4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=By7LJSUymg+low6MjLpavERyqgTUYbhUd89tb1TQ37s9g/R5j+M6iVhKP1ejoI7kF
         1SH4UxprAXjNkbqThU6vXV6XC5i7TXRyi0u9QkZEVALr2MmAw6oTRofVFcmgSNUFLY
         5wOVg5L/UZylFbBRtyEbLgfQtb5IdoIOcdpNar0k=
Message-ID: <7bac7ba5655a8e783a70f915853a0846e7ff143b.camel@kernel.org>
Subject: Re: [GIT PULL] Ceph fixes for 5.1-rc7
From:   Jeff Layton <jlayton@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Date:   Sun, 28 Apr 2019 09:27:20 -0400
In-Reply-To: <20190428043801.GE2217@ZenIV.linux.org.uk>
References: <20190425174739.27604-1-idryomov@gmail.com>
         <CAHk-=wgPBx9xPWY7obK60=RTnOF3Ln0j9XkhYbekML=Fi3bFXg@mail.gmail.com>
         <342ef35feb1110197108068d10e518742823a210.camel@kernel.org>
         <20190425200941.GW2217@ZenIV.linux.org.uk>
         <86674e79e9f24e81feda75bc3c0dd4215604ffa5.camel@kernel.org>
         <20190426165055.GY2217@ZenIV.linux.org.uk>
         <b175faae4bb98d3379a8642fe5f4e00587c3a734.camel@kernel.org>
         <20190428043801.GE2217@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, 2019-04-28 at 05:38 +0100, Al Viro wrote:
> On Fri, Apr 26, 2019 at 01:30:53PM -0400, Jeff Layton wrote:
> 
> > > I _probably_ would take allocation out of the loop (e.g. make it
> > > __getname(), called unconditionally) and turned it into the
> > > d_path.c-style read_seqbegin_or_lock()/need_seqretry()/done_seqretry()
> > > loop, so that the first pass would go under rcu_read_lock(), while
> > > the second (if needed) would just hold rename_lock exclusive (without
> > > bumping the refcount).  But that's a matter of (theoretical) livelock
> > > avoidance, not the locking correctness for ->d_name accesses.
> > > 
> > 
> > Yeah, that does sound better. I want to think about this code a bit
> 
> FWIW, is there any reason to insist that the pathname is put into the
> beginning of the buffer?  I mean, instead of path + pathlen we might
> return path + offset, with the pathname going from path + offset to
> path + PATH_MAX - 1 inclusive, with path being the thing eventually
> freed.
> 
> It's easier to build the string backwards, seeing that we are walking
> from leaf to root...

(cc'ing linux-cifs)

I don't see a problem doing what you suggest. An offset + fixed length
buffer would be fine there.

Is there a real benefit to using __getname though? It sucks when we have
to reallocate but I doubt that it happens with any frequency. Most of
these paths will end up being much shorter than PATH_MAX and that slims
down the memory footprint a bit.

Also, FWIW -- this code was originally copied from cifs'
build_path_from_dentry(). Should we aim to put something in common
infrastructure that both can call?

There are some significant logic differences in the two functions though
so we might need some sort of callback function or something to know
when to stop walking.

-- 
Jeff Layton <jlayton@kernel.org>

