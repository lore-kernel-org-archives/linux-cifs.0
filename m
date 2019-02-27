Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1790FC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 20:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D610C213A2
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 20:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfB0UV5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 15:21:57 -0500
Received: from fieldses.org ([173.255.197.46]:60838 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727240AbfB0UV5 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 27 Feb 2019 15:21:57 -0500
Received: by fieldses.org (Postfix, from userid 2815)
        id E5E111E19; Wed, 27 Feb 2019 15:21:56 -0500 (EST)
Date:   Wed, 27 Feb 2019 15:21:56 -0500
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     lsf-pc@lists.linux-foundation.org,
        linux-cifs <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [LSF/MM TOPIC] Using buildbot for automated testing of CIFS.KO
Message-ID: <20190227202156.GB23505@fieldses.org>
References: <CAN05THSpSLnGF84S0a0+qu=UHw8HArKbuChmP7usRqKNChNC8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN05THSpSLnGF84S0a0+qu=UHw8HArKbuChmP7usRqKNChNC8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From:   bfields@fieldses.org (J. Bruce Fields)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 27, 2019 at 05:22:07PM +1000, ronnie sahlberg wrote:
> Hi Folks,
> 
> I am Ronnie Sahlberg, CIFS.KO developer at RedHat.
> I want to come to LSF/MM to talk CIFS and network protocols with
> colleagues in the FS world.
> 
> I have an idea for an informal talk I would like to give:
> "Automated testing of kernel fs modules using buildbot. Experiences so
> far in CIFS land."
> 
> This would be a practical presentation showing examples of a system we
> implemented recently
> for cifs.ko to have a standard set of tests to run to ensure quality
> and (hopefully) avoidance
> of regressions for the patches that are sent to Linus for the CIFS.KO module.
> 
> At this point we are starting to see very promising results on fixing
> bugs before they hit Linus tree.
> I would like to show and talk about how we set this up and why we did
> it this way.
> 
> To see what it looks like right now, this is what I think will go as a
> pull request when the next merge window opens:
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/137
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/98

Am I reading right--did one of those tests take twice as long as the
other?  I wonder why?

Just curious.  Always happy to hear about other folks' test setups.

--b.

> 
> We have already started to add these kind of links in the pull
> requests we send upstream.
> 
> 
> I would like to talk about how this is set up, what our experiences
> are so far, has it improved out quality and our confidence that the
> patches are good?
> An it would be trivial to reuse for other filesystems if you want to use it.
> 
> regards
> Ronnie Sahlberg
