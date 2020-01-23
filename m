Return-Path: <SRS0=O+hx=3M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C901C2D0DB
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jan 2020 17:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2ABF21569
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Jan 2020 17:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgAWRBh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Jan 2020 12:01:37 -0500
Received: from smtp2.axis.com ([195.60.68.18]:21115 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729864AbgAWRBh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Jan 2020 12:01:37 -0500
IronPort-SDR: S1xBIINes4rYQOWXvHo11AAvQuOHJkBXP73CB3RCaETCezvL4WtzUtDrdG1MfAtGGJK2e99WO7
 4uU3uWeM/9lNTo1xMvn+kPY5aEkwJ+dswmajbZm3UbMRDjM1xRez1sJgz2BiXU6O54suQg1IWP
 Kb5fegkJTCzrjEeXxMWaRr0vI1JBKAJK9ZFJZ/VGievXFWeq5Ck26uLHpR+py57Jdy0FU/mnI1
 aQd2r76RvODmfpVDPL2hB+gHF/7EUFIObmAmPfOGqY1Jv7iAffd4apXwNNFf9/2jGxZm7T+HFY
 1C8=
X-IronPort-AV: E=Sophos;i="5.70,354,1574118000"; 
   d="scan'208";a="4581573"
Date:   Thu, 23 Jan 2020 18:01:36 +0100
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Steve French <smfrench@gmail.com>
CC:     <linux-cifs@vger.kernel.org>, <kernel@axis.com>,
        <pshilov@microsoft.com>
Subject: Re: [PATCH] CIFS: Fix task struct use-after-free on reconnect
Message-ID: <20200123170136.wnujtew76wwhpbmh@axis.com>
References: <20200123160906.28498-1-vincent.whitchurch@axis.com>
 <CAH2r5mtGMGSPoOKtGK1+DqRswV=k7B05L6SSm02CUamDw2=0ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAH2r5mtGMGSPoOKtGK1+DqRswV=k7B05L6SSm02CUamDw2=0ew@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jan 23, 2020 at 05:35:16PM +0100, Steve French wrote:
> On Thu, Jan 23, 2020, 10:17 Vincent Whitchurch <vincent.whitchurch@axis.com> wrote:
> > This can be reliably reproduced by adding the below delay to
> > cifs_reconnect(), running find(1) on the mount, restarting the samba
> > server while find is running, and killing find during the delay:
> > 
> >         spin_unlock(&GlobalMid_Lock);
> >         mutex_unlock(&server->srv_mutex);
> > 
> >  +      msleep(10000);
> >  +
> >         cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
> >         list_for_each_safe(tmp, tmp2, &retry_list) {
> >                 mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> > 
> > Fix this by holding a reference to the task struct until the MID is
> > freed.
> 
> Cc:stable as well?

Yes, I think this bug has been there for a while.

Note that the test described above usually triggers a different crash on
kernels earlier than v5.4 because abe57073d08c13b95a46ccf48c ("CIFS: Fix
retry mid list corruption on reconnects") has not (yet?) been backported
to those stable kernels.
