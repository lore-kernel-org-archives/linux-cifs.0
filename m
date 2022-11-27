Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE8AC47089
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Nov 2022 10:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiK0KhK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 27 Nov 2022 05:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiK0KhJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 27 Nov 2022 05:37:09 -0500
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBB5E0EB
        for <linux-cifs@vger.kernel.org>; Sun, 27 Nov 2022 02:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=In-Reply-To:Content-Type:MIME-Version:References:Reply-To:
        Message-ID:Subject:Cc:To:From:Date:Sender:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mu/0oRnxy+qsIyu8M181DOxqLaQ4oMfEmKMVLTWJ5Rw=; b=NzE1OFgnLrRmz3G5oG0z0KqjWZ
        jLCyVYnCOFoqz0uI0ZMDnoCGVyh8Cs4/Ejwjo9vMQMU4DJqJN5oFNGF9UkMKvjInERGdeRwJg64yv
        ba+M/06LAjiEPjR7qXR0wkXPMlolJ1cqmGmMxKL+RXa4QHm1YX6J7OYdkNmeC6a95rnT7M4Bs+5kg
        cEPq+bQ6i2POVcreXoh0kMeamThFnMXQvjan+LL1qFvz36USt/g7f7/ZO5a4NkfbQoNA59S655rOs
        UGaUDJBE7FFNV1UkKQnnu1EgOR1EtOSC1QSXy7V8+oybdbWXrAfa3NEsxZNOi4csJWt2EMfOIjb0q
        TSZ7o6tQ==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Type:MIME-Version:
        References:Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mu/0oRnxy+qsIyu8M181DOxqLaQ4oMfEmKMVLTWJ5Rw=; b=+4iI/SMkB/iB6pkf4Y+qjkdf/d
        PolZXs/ln3rPRLUYs1Ou7lCxNBhVjC4hoFWdHXyGDWYuWKdpAV0HMKg0lnBQ==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        id 1ozF21-008l2F-D6; Sun, 27 Nov 2022 11:37:05 +0100
Received: by intern.sernet.de
        id 1ozF21-001iG5-4B; Sun, 27 Nov 2022 11:37:05 +0100
Date:   Sun, 27 Nov 2022 11:37:00 +0100
From:   Volker Lendecke <Volker.Lendecke@sernet.de>
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: Parse owner and group sids from smb311 posix extension qfileinfo
 call
Message-ID: <Y4M9zBp3iLw1vtfo@sernet.de>
Reply-To: Volker.Lendecke@sernet.de
References: <Y4DJ2o6w+SxIH7Yl@sernet.de>
 <CAH2r5mscUWuAbsSjw1DOFT=yG3dDZhcmCtAVLNhoH-5hrby-tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mscUWuAbsSjw1DOFT=yG3dDZhcmCtAVLNhoH-5hrby-tg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I've used the same routines that 9934430e2178 adds to readdir, so now
stat() should be consistent with "ls -l". What do you think needs
adding to make it easier for non-S-1-22 SIDs? We could change Samba to
always return the S-1-22- SIDs when a posix client requests the owner
and group.

Am Sat, Nov 26, 2022 at 06:31:51PM -0600 schrieb Steve French:
> Looks like this does help the group information returned by stat, but
> will need to make it easier to translate the owner sid to UID (GID was
> an easier mapping since gid was returned as "S-1-22-"... but SID for
> uid owner has to be looked up)
> 
> On Fri, Nov 25, 2022 at 8:19 AM Volker Lendecke
> <Volker.Lendecke@sernet.de> wrote:
> >
> > Hi!
> >
> > Attached find a patch that aligns "stat /mnt/file"'s owner and group
> > info with the readdir call.
> >
> > Fixes a TODO from 6a5f6592a0b60.
> >
> > Volker
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
