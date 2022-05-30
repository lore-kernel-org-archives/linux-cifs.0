Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBDAC43217
	for <linux-cifs@archiver.kernel.org>; Mon, 30 May 2022 13:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238581AbiE3Nwc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 May 2022 09:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238784AbiE3Nuv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 May 2022 09:50:51 -0400
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC8BAFB21
        for <linux-cifs@vger.kernel.org>; Mon, 30 May 2022 06:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1653917708;
  x=1685453708;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FMMMt5kRuClSe3/A/m7K7zXLosMlSbUOozVze5gZS08=;
  b=hVatIC5PWKbywwfvceiD6kXxzp6IfOmcwi4Cmh02RFNRlvLXXGDaFFg7
   JUVAY9Wn/vE8yA6HsdrBj5scOjdYIiAxCFNovLEUo6/rNN16WHZtyezBr
   Wh7BebYw05Y3kQGIbylylMxjV77C3f23SudLNDtSV0JAEv1EPszJo7cpN
   nuLpdyHtgiAKjDtwgFnM+dTM08KyyAIQHiO2eXCMOGGfL/9+ZU9dfZ2wD
   wrkVrX2YsB1Wmjuew/c7bpswt/MQ+PjSNWBw8EJ6DjQtbMSe5Q6uosMux
   9SMc9+bxhnqerqskw7OpmqspYqSMzzLkguLpfLedP2pMb2k6FAicGuINL
   g==;
Date:   Mon, 30 May 2022 15:34:48 +0200
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
CC:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: lockdep deadlock warning
Message-ID: <20220530133443.GA3563@axis.com>
References: <CANT5p=rqcYfYMVHirqvdnnca4Mo+JQSw5Qu12v=kPfpk5yhhmg@mail.gmail.com>
 <20220523123755.GA13668@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220523123755.GA13668@axis.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, May 23, 2022 at 02:38:02PM +0200, Vincent Whitchurch wrote:
> On Mon, Feb 14, 2022 at 10:19:30PM +0530, Shyam Prasad N wrote:
> > It's about a circular dependency locking fs_reclaim lock with srv_mutex held.
> > Does someone here understand this dependency?
> 
> The crypto shash allocation does allocations with GFP_KERNEL (i.e.,
> GFP_NOFS is not set and so fs reclaim can be triggered) and this is
> called under the CIFS srv_mutex.  However, the CIFS srv_mutex is also
> used in the reclaim path as the splat shows.  This is the dependency
> which lockdep is complaining about.
> 
> A way to remove this particular dependency is to make CIFS do a
> memalloc_nofs_save/restore() around the places it takes the srv_mutex.
> However, doing this does not solve the lockdep splats completely since
> there is another dependency via some internal locks in crypto, see the
> log below.

I have now sent out a patch to use memalloc_nofs_*.  There are other
GFP_KERNEL allocations in CIFS done under the srv_mutex (such as the one
in SMB2_sess_auth_rawntlmssp_negotiate()) besides the shash allocations,
so that patch is needed even if something is done later to move the
crypto shash allocations out of that mutex.

 https://lore.kernel.org/linux-cifs/20220530132155.4019006-1-vincent.whitchurch@axis.com/
