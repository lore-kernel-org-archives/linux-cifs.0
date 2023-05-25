Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BDFC77B7A
	for <linux-cifs@archiver.kernel.org>; Thu, 25 May 2023 20:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241062AbjEYUWO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 16:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241242AbjEYUWN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 16:22:13 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D330E7
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 13:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=J5YQuBSYJ+Gmm+1sncCCJWxeublLtyJCgvShhMLeZQ8=; b=PukFwWrgaBc5X/SC+g8I8RKpFY
        xQ3ZLKWtO1NegV2D5D3XRESVApGMsmEmtCNLj0ASZvAkzpLjYF6wA6Z7Xi4DWt/eIS8nesGvt8/ld
        MrNnRryJtVRxZj+ptcqN68brSf61AubXm8LRMAPcXb2A53tvKH6/B+/iKubRUJNZCu+sxDUQ7dHTG
        +YgPDFUzfj9dAWPIwDHfe0djx31m92FfoIsfh7910SanGIVz/sZR47XyGYHr4TDTsdusw6o/xwolD
        zGNQ1KPJS7WyPASaOKY9bX2gnyXPQ+f2FI3gyedWl8EANJFPE1+B9eQvQ+ZsqToRkbucdN6DYGTgD
        sEPTnRsTzz26zKeB/icG1W50CmZCvlws8SWuz3mn2b4Hau967jn+xVlgAFlkXrCIrOLY94ALVLf5P
        WwXBcsePWzK0vmXZHRVDGB1jGhXimBs7kj/fFiv3F2aXQggyLxaRJrJZyDK4ltM/jIGVIL1+9uddY
        b1HtLL4iD+cxQiYwMVvxrNYd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1q2HTN-00CCha-0F; Thu, 25 May 2023 20:22:09 +0000
Date:   Thu, 25 May 2023 13:22:02 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@sernet.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: Displaying streams as xattrs
Message-ID: <ZG/DajG6spMO6A7v@jeremy-rocky-laptop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop>
 <20230525093900.GA261009@sernet.de>
 <CAN05THTi0BC_iwjXMiWn61fg3hRemi5Momwp3O0WGygyWLGomQ@mail.gmail.com>
 <ZG+LOKTr8B+zjQsC@jeremy-rocky-laptop>
 <CAH2r5mv7aZ8nm30oKyYpa-bd8-MqA13EcEmQWV4mOyrV-rj8Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mv7aZ8nm30oKyYpa-bd8-MqA13EcEmQWV4mOyrV-rj8Ug@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, May 25, 2023 at 03:11:13PM -0500, Steve French wrote:
>On Thu, May 25, 2023 at 11:22 AM Jeremy Allison <jra@samba.org> wrote:
>>
>> On Thu, May 25, 2023 at 08:49:47PM +1000, ronnie sahlberg wrote:
>> >>
>> >> just took a look at how the ntfs-3g module is handling this. It was an option
>> >> streams_interface=value, which allows "windows", which means that the
>> >> alternative data streams are accessable as-is like in Windows, with ":" being
>> >> the separator. This might be a nice option for cifsfs also. That option would
>> >> just be usable if no posix extensions are enabled of course.
>
>You can already open alternate data streams remotely (from cifs.ko on Linux
>as you can from Windows and Macs etc. just open "file:streamname"), but on
>Linux you have to disable the reserved character mapping ("nomapposix")
>otherwise ":" would get remapped on open in the Unicode conversion.
>
>There may be a better way to list streams in the future (e.g. to help
>backup applications
>that need to be able to save files created by Macs or Windows that need these
>e.g. Virus checkers etc. use ADS, and looking at my Windows machines, PDFs
>can have small "Zone Identifiers" saved in streams), but you can
>already list them
>with "smbinfo filestreaminfo <filename>"
>
>I was thinking mainly about backup scenarios whether this came up as
>listing them
>also via a pseudo-xattr (IIRC Macs do something similar).

I think cifsfs providing access to ADS remotely on Windows
and Samba shares is fine.

What I'm scared of is adding ADS as a generic "feature" to
the Linux VFS and other filesystems :-).
