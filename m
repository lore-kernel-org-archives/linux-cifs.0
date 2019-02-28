Return-Path: <SRS0=HnFe=RD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D111AC4360F
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 16:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F4C62184A
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 16:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733236AbfB1Qvt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:51:49 -0500
Received: from fieldses.org ([173.255.197.46]:33614 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733202AbfB1Qvs (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 28 Feb 2019 11:51:48 -0500
Received: by fieldses.org (Postfix, from userid 2815)
        id 510251C98; Thu, 28 Feb 2019 11:51:48 -0500 (EST)
Date:   Thu, 28 Feb 2019 11:51:48 -0500
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-cifs <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [LSF/MM TOPIC] Using buildbot for automated testing of CIFS.KO
Message-ID: <20190228165148.GA2707@fieldses.org>
References: <CAN05THSpSLnGF84S0a0+qu=UHw8HArKbuChmP7usRqKNChNC8w@mail.gmail.com>
 <20190227202156.GB23505@fieldses.org>
 <CAH2r5mud5qLQqww6p18VoUmRPdoxibrrtfPEA1NuZ+=Xo7nG=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mud5qLQqww6p18VoUmRPdoxibrrtfPEA1NuZ+=Xo7nG=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 27, 2019 at 11:49:35PM -0600, Steve French wrote:
> On Wed, Feb 27, 2019 at 2:22 PM J. Bruce Fields <bfields@fieldses.org> wrote:
> >
> > On Wed, Feb 27, 2019 at 05:22:07PM +1000, ronnie sahlberg wrote:
> > > To see what it looks like right now, this is what I think will go as a
> > > pull request when the next merge window opens:
> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/137
> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/98
> >
> > Am I reading right--did one of those tests take twice as long as the
> > other?  I wonder why?
> >
> > Just curious.  Always happy to hear about other folks' test setups.
> 
> No - these runs were quite different - two distinct groups of tests.
> "cifs-testing" group is longer and tests to three types of server
> targets, while the "azure" target tests 67 of the xfstests to Azure
> server target (albeit with different configurations for some of the
> tests).

Oh, got it, thanks.

> There is an additional test group for "DFS" (Global Name
> Space) and we will probably add more.
> 
> A big hole right now is lack of RDMA ("SMBDirect") tests - in part due
> to lack of good options for emulated RDMA in virtual machines.

Yes, I'm currently just assuming Chuck and others are covering this for
me....

--b.
