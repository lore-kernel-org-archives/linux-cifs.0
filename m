Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCF1C433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 13:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9140765242
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 13:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhCINsz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Mar 2021 08:48:55 -0500
Received: from smtp1.axis.com ([195.60.68.17]:26741 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231366AbhCINsa (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 9 Mar 2021 08:48:30 -0500
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2021 08:48:29 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1615297710;
  x=1646833710;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IX5Ccrifhwn+TfdveaPZcVPwzE7RzbHoY8Z21/LsAAI=;
  b=MhYOhJI99KpekbU9DwCBnzGztZIYDbbJfLD0G8hreO8f5942rvbX0yHh
   aTs5n3wqJE5YTxUdHpjkhP12/ixRLUTF6UZ0/8fhEqEcRvY6DBbQNDGrR
   Z4Zq5u66JehjUURYeNycDFYPWClyRJtxXOr9DtFYUH43idfFSiXiT7lMc
   lwOkhFgFPIcKCWph+ZoiiH9kzAgcaOG2mnsHzV2Dxz8kbztyOlQXNCsn2
   DlSoG+m+C3IhpVLVBWuP0D2ofP3I8EKEejVBwY+mCyqAn3ptswqa0ZRNl
   7AFwuizTZw/Umy/kv2+D5QY9pyAj25UDbZZws353bdvuZ3Cu0AnDHJ4RU
   g==;
Date:   Tue, 9 Mar 2021 14:41:18 +0100
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
CC:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>, kernel <kernel@axis.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: Re: [PATCH] CIFS: Prevent error log on spurious oplock break
Message-ID: <20210309134118.GA31041@axis.com>
References: <20210305094107.13743-1-vincent.whitchurch@axis.com>
 <CANT5p=rB2=DvjtpmVy803emWpuzsy-C2+d4wqQ5g_9fJ8+a5Cw@mail.gmail.com>
 <CAN05THQtb5RY2ye7nkyWBjrXS+=usZCxUM7jBQG+JEpg_TQQTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAN05THQtb5RY2ye7nkyWBjrXS+=usZCxUM7jBQG+JEpg_TQQTA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Mar 09, 2021 at 01:05:11AM +0100, ronnie sahlberg wrote:
> On Sun, Mar 7, 2021 at 8:52 PM Shyam Prasad N via samba-technical
> <samba-technical@lists.samba.org> wrote:
> > The reason for rejecting the request maybe a number of things like:
> > corrupted request, stale request (for some old session), or for a
> > wrong handle.
> > I don't think we should treat any of these cases as a success.
> 
> I agree with Shyam here.
> We shouldn't change the return value to pretend success just to
> suppress a warning.

Thank you all for your comments.  I see that everyone agrees that the
error print is useful for SMB2, so I will drop this patch.

> However, if it is common to trigger with false positives we might want
> to something to prevent it from
> spamming the logs.
> These messages could be useful if we encounter bugs in our leasing
> code, or bugs in server
> lease code, so we should't throw them away completely. But if false
> positives are common ...
> 
> Some thoughts I and Stever brainstormed about could be to change the code in the
> demiltiplex thread where we currently dump the packets that were "invalid"
> to maybe:
> *  log once as VFS and then log any future ones as FYI
> * log once as VFS and then only make the others available via dynamic
> trace points
> * rate limit it so we only log it once every n minutes?  (this is overkill?)

Thank you for the suggestions.  In my case, I've only received some
reports of this error being emitted very rarely (couple of times a month
in our stability tests).  Right now it looks like the problem may only
be with a particular NAS, and we're looking into triggering oplock
breaks more often and catching the problem with some more logging.
