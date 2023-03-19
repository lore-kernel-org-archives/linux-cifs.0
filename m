Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1D2C6FD1F
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Mar 2023 20:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCSUOg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 19 Mar 2023 16:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCSUOd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 19 Mar 2023 16:14:33 -0400
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C13D7EF2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Mar 2023 13:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nF3SixiYv+aGo79fhr+ujNprPNyYxmVzx+wB2jWHUrQ=; b=OrurdgXetvOburHuj4++/0fKpM
        S6LlOSlpY48Hi1pIbAFt7oK9oJ/wq3hpBC2mKhAL6yk2eyvJHbPSiYCwxcW7Bzw0zs89H1kDC4gnQ
        8ovkP5RzmIeXBMiVGj0HB7RQ5MFPnikbuwDiaoKHPVVtIa2djhboX13I8ZRK3cSw/bVL4thQIshW/
        8R5P/BbDafs9/lbGVmoYCCQQJDyKXmbQtSyctFXv6JV50BAUyV/pLvTCHyTW+mYGeJf/WCJV8oQst
        Sct1tbWFZQZV5wtYE1ZWS6ZGbXnhMZWlDJgNA4DkuSOHYKdTSb2XeAl/nUs0g3YVmi4QAbhmhiFS1
        qxgZ3jEA==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Reply-To:Message-ID:Subject:Cc:To:From:
        Date:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nF3SixiYv+aGo79fhr+ujNprPNyYxmVzx+wB2jWHUrQ=; b=3w1j7Wh4Ik1wBO/mdoPN6cGUZs
        cyFoxsa30apuWPcFQWMpPwhuyPe+0sdhzj1evby9g2Ka0Rs0w2WJbsZf1sBQ==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        id 1pdzQE-0089cc-Ij; Sun, 19 Mar 2023 21:14:30 +0100
Received: by intern.sernet.de
        id 1pdzQE-00Ff8J-8w; Sun, 19 Mar 2023 21:14:30 +0100
Date:   Sun, 19 Mar 2023 21:14:27 +0100
From:   Volker Lendecke <Volker.Lendecke@sernet.de>
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: Re: Helper functions for smb2 compound ops
Message-ID: <ZBdtI6cPNbkeFWCx@sernet.de>
Reply-To: Volker.Lendecke@sernet.de
References: <ZBdgHL3J+UVViuOI@sernet.de>
 <CAH2r5mtHRUUYCeb8SMPQhHunJvEm15EiVJcXFb+6DTsY2w4zMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtHRUUYCeb8SMPQhHunJvEm15EiVJcXFb+6DTsY2w4zMQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Steve,

the goal of struct smb2_compound_op is to make it easier to work with
compound requests. In particular the existing smb2_compound_op()
function in smb2inode.c is very hard to understand, let alone
modify. As an example it took me really a long time to get
64ce47cb1b29d7d6aab6 right, and I still see it as a very clumsy
approach. It should not be neccesary to kmemdup output deep inside
this routine, but it was the only approach I could find.

To me it would be much easier if the open/qinfo/close sequence was
flat in smb311_posix_query_path_info() and we could dissect the
results while the response is still around.

So yes, this fs/cifs/smb2compound.c is 200 lines of code, but I think
it is really simply structured code that should be easy to review.

Volker

Am Sun, Mar 19, 2023 at 02:49:09PM -0500 schrieb Steve French:
> My main worry is that it is relatively large (which can make it harder
> to review, and harder for Ronnie and Paulo et al to backport) but if
> it is the cleanest way to solve various problems, then it could be
> worth pursuing.  Otherwise, I prefer cleanup (unless relatively small
> and reasonably easy to review) when it is related to fixing other
> problems.
> 
> The biggest problems I would like to fix are:
> 1) using compounding in more places (plenty of benchmarks or simple
> examples like gunzip, tar, rsync, to go through to look for places
> where network traces show compounding not being used)
> 2) optimizing compounding better e.g.
>     - "ls -l" of directory with mfsymlinks sends multiple compound
> requests for every mfsymlink when only need one
>     - "ls" sends an extra roundtrip for 99% of cases, to send the
> final querydir (which gets no more files rc ...). We should be sending
> "open/querydir/querydir" compound not "open/querydir")
> 3) ) we need to fix a few cases when we open a file in compound ops
> when we already have an appropriate one open
> 4) we request leases where appropriate for compounding sequences (e.g.
> open/querydir) e.g. when open sent but no close and reasonable
> possibility of benefiting from deferred close.
> 5) we set the parent lease key where possible (quoting from MS-SMB2:
> "The client MUST search the GlobalFileTable for the parent directory
> of the file being opened. The name of the parent directory is obtained
> by removing the last component of the path. If any entry is found,
> ParentLeaseKey is obtained from File.LeaseKey of that entry and
> SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET bit MUST be set in the Flags
> field.")
> 6) we need to make sure we are always requesting handle leases (e.g.
> RWH or RH) - we have one case (cachiong directories) where we request
> "R" instead of "RH" and we need to make sure that we close any
> deferred opens (or cached dir opens) when we lose the 'H' on a lease
> 
> 
> On Sun, Mar 19, 2023 at 2:19 PM Volker Lendecke
> <Volker.Lendecke@sernet.de> wrote:
> >
> > Hello!
> >
> > This is not a formal patchset, more a request for comments.
> >
> > In fs/cifs when doing compound operations I see a lot of fiddly
> > boilerplate code. Attached find a little patchset that introduces a
> > struct smb2_compound_op capturing most of that boilerplate code, along
> > with a few sample uses.
> >
> > Is that worth exploring further?
> >
> > Thanks,
> >
> > Volker
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
