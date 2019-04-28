Return-Path: <SRS0=iF1N=S6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D6CC43219
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Apr 2019 16:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C485E206A3
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Apr 2019 16:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556468283;
	bh=1SaD5I+zLIUb4wHyGKaUi1WiE1ndGN+AH1sSoln7zW0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=DC1IewFQAj3snVum89wIQGr//UxVUhUPagiPTpi0ucJjr42jkyWL5Uv6wtf+hLmiP
	 6nhFtHzktnUPti/Mzmx2CoXGuCOfBjhNIH1aJ5n9iMst3SPgGNdkDbXBIwz+mgMwcm
	 EDCTxPD91NzgEXGwTcoOMTWQVTrPjBakW+jJVI4M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfD1QSD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 Apr 2019 12:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfD1QSD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 28 Apr 2019 12:18:03 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D910C20693;
        Sun, 28 Apr 2019 16:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556468282;
        bh=1SaD5I+zLIUb4wHyGKaUi1WiE1ndGN+AH1sSoln7zW0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KL484Oas0TEC31AlJjWiOZ7359uhLrVnXyLq3wfxa8fJnYJbpwHpQByef9lgmEe3W
         bBbw716/HnNB64mWtVY6UAUwzYtdesxclRtYgFAnQjMdB4NRgWkV6Qu8dEzogba5cG
         nnAJepQxLHzukn2sMmKBDiXuctpaeT3rIova8qXs=
Message-ID: <c570c901c850b6308bc78fcc6c7308f0bc491cb1.camel@kernel.org>
Subject: Re: [GIT PULL] Ceph fixes for 5.1-rc7
From:   Jeff Layton <jlayton@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Date:   Sun, 28 Apr 2019 12:18:00 -0400
In-Reply-To: <20190428155216.GB23075@ZenIV.linux.org.uk>
References: <CAHk-=wgPBx9xPWY7obK60=RTnOF3Ln0j9XkhYbekML=Fi3bFXg@mail.gmail.com>
         <342ef35feb1110197108068d10e518742823a210.camel@kernel.org>
         <20190425200941.GW2217@ZenIV.linux.org.uk>
         <86674e79e9f24e81feda75bc3c0dd4215604ffa5.camel@kernel.org>
         <20190426165055.GY2217@ZenIV.linux.org.uk>
         <b175faae4bb98d3379a8642fe5f4e00587c3a734.camel@kernel.org>
         <20190428043801.GE2217@ZenIV.linux.org.uk>
         <7bac7ba5655a8e783a70f915853a0846e7ff143b.camel@kernel.org>
         <20190428144850.GA23075@ZenIV.linux.org.uk>
         <b875fdb47e17ab68d18c5e5e5cbd0ec70fec7ce9.camel@kernel.org>
         <20190428155216.GB23075@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, 2019-04-28 at 16:52 +0100, Al Viro wrote:
> On Sun, Apr 28, 2019 at 11:47:58AM -0400, Jeff Layton wrote:
> 
> > We could stick that in ceph_dentry_info (->d_fsdata). We have a flags
> > field in there already.
> 
> Yes, but...  You have it freed in ->d_release(), AFAICS, and without
> any delays.  So lockless accesses will be trouble.

That's easy enough to fix -- we could add a rcu_head to it and call_rcu
in ceph_d_release instead of just freeing it immediately.

I guess if we find that d_fsdata is NULL, we can just treat it like we
currently do a negative dentry?
-- 
Jeff Layton <jlayton@kernel.org>

