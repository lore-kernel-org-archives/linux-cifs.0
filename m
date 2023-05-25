Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5BCC77B7A
	for <linux-cifs@archiver.kernel.org>; Thu, 25 May 2023 10:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbjEYKBA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 06:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjEYKA7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 06:00:59 -0400
X-Greylist: delayed 1312 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 May 2023 03:00:58 PDT
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8BEE7
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 03:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2eScKpZxoXDh3xxTRAiQLkkHyVvDSOCYqzTERqwCI/M=; b=njka6TQCM8Syu4Uzn6ctWK/kVQ
        J+JRtKroCV9NPEh8jgkCW5/KNmgpB2e9IbVvAp9YufwAcpHulT39zFOwtAy7EAs5BbklxyhxnH60K
        zIq9QK0DUqB40c1S+oUJlOQbCfu4Xw5ma84iJUabzDpdrhNLBXyHBr5ARfOZJs/+5DszuQvTFNAot
        Q4kYYoaKtFwYyzvwClGUpwmlvN+/EHGY3UAX0CmoemqAp61VBsQdd+ZojUutyBmoG8RxttZqNj7oT
        kELNmk8JLHshrtVEOj7b6tE4PQZEbeprk7ICIPUnprRgPbYqj4CM+SrsQYP7vBx1HAACqJJMPMNsL
        OFPFloxw==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2eScKpZxoXDh3xxTRAiQLkkHyVvDSOCYqzTERqwCI/M=; b=GqBjzHDm9IjhH5AXW0rRGVt2qO
        cxkJNjtRxhAC0PWT/IQpvvFjR4Vx2pu5UK6J8c9UbX/0hlR31cqNVia67XBg==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        id 1q27R0-008LaW-EP; Thu, 25 May 2023 11:39:02 +0200
Received: by intern.sernet.de
        id 1q27R0-004gyJ-3c; Thu, 25 May 2023 11:39:02 +0200
Received: from bjacke by pell.sernet.de with local (Exim 4.93)
        (envelope-from <bjacke@sernet.de>)
        id 1q27Qy-0019If-G9; Thu, 25 May 2023 11:39:00 +0200
Date:   Thu, 25 May 2023 11:39:00 +0200
From:   =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@SerNet.DE>
To:     Jeremy Allison <jra@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: Displaying streams as xattrs
Message-ID: <20230525093900.GA261009@sernet.de>
Mail-Followup-To: Jeremy Allison <jra@samba.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZGuWhzP98U9Niog+@jeremy-rocky-laptop>
X-Q:    Die Schriftsteller koennen nicht so schnell schreiben, wie die
 Regierungen Kriege machen; denn das Schreiben verlangt Denkarbeit. - Brecht
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2023-05-22 at 09:21 -0700 Jeremy Allison via samba-technical sent off:
> On Mon, May 22, 2023 at 01:39:50AM -0500, Steve French wrote:
> > On Sun, May 21, 2023 at 11:33 PM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> > > 
> > > A problem  we have with xattrs today is that we use EAs and these are
> > > case insensitive.
> > > Even worse I think windows may also convert the names to uppercase :-(
> > > And there is no way to change it in the registry :-(
> > 
> > But for alternate data streams if we allowed them to be retrieved via xattrs,
> > would case sensitivity matter?  Alternate data streams IIRC are already
> > case preserving.   Presumably the more common case is for a Linux user
> > to read (or backup) an existing alternate data stream (which are usually
> > created by Windows so case sensitivity would not be relevant).
> 
> Warning Will Robinson ! Mixing ADS and xattrs on the client side is a receipe for
> confusion and disaster IMHO.
> 
> They really are different things. No good will come of trying to mix
> the two into one client namespace.
> 

just took a look at how the ntfs-3g module is handling this. It was an option
streams_interface=value, which allows "windows", which means that the
alternative data streams are accessable as-is like in Windows, with ":" being
the separator. This might be a nice option for cifsfs also. That option would
just be usable if no posix extensions are enabled of course.

Björn
