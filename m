Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB58C77B75
	for <linux-cifs@archiver.kernel.org>; Tue, 16 May 2023 19:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjEPTzR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 May 2023 15:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEPTzQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 May 2023 15:55:16 -0400
X-Greylist: delayed 1702 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 May 2023 12:55:14 PDT
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE974C2E
        for <linux-cifs@vger.kernel.org>; Tue, 16 May 2023 12:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=1bvVwfiEzxcnCPrb8quhPeRFyiotgkIIcOf58sHlh+k=; b=tkVwtMu5fNf2YN9QCjPBh1hRHC
        pLrIPPUfE/gJ+bpsrUaTqGH9TN1JsDlm9sRfM/Mpvz0+MTEEhaF+gcNKnoWmRgCPP8WGgc4m6ruFK
        TevNZX52PiZJ4FjxFqm0tiiSJK4xeWCHYqCuyOLIIrf2PGUkn/AZyKArDJ/iB0IcvZx2KLhyhXrEW
        +EL3wCjXQX/63ejmO+3zEbBO9FMjJN4NUg+8jjCoUnve4rdHS6yhFrNGjHR8KB8qYb0t4fkUzBog0
        Up8GSTlTabpojhgoHNEAG9gH5ZdoUCPVCBzKunHKYbyczGaVFtfLjzYGxOSnPGPWs4sG8pav5nLyX
        1AU46zm8ykSvy5tHeM20lpkR8eUxM4SElzWi60ZiFexJuusPJIMNFIBcICpgxf6Occ8Y19PnROwe7
        W/oqIm7sAl2gJDg380mLwsCdQARGhVCWGP8soul+9RZdt2rAmvi4VCAPhriij34zORTIYGgqZLWUs
        zZfu1twU9cVgmlSIhGbp0rLE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pz0Js-009Ho7-Bv; Tue, 16 May 2023 19:26:48 +0000
Date:   Tue, 16 May 2023 12:26:42 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Tom Talpey <tom@talpey.com>
Cc:     Ross Lagerwall <ross.lagerwall@citrix.com>,
        linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>,
        Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Rohith Surabattula <rohiths@microsoft.com>
Subject: Re: [PATCH] cifs: Close deferred files that may be open via hard
 links
Message-ID: <ZGPY8kuw/v2TD71X@jeremy-rocky-laptop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20230516150153.1864023-1-ross.lagerwall@citrix.com>
 <55740ab3-e020-df8c-07bc-02386486539f@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <55740ab3-e020-df8c-07bc-02386486539f@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, May 16, 2023 at 02:41:06PM -0400, Tom Talpey wrote:
>On 5/16/2023 11:01 AM, Ross Lagerwall wrote:
>>Windows Server (tested with 2016) disallows opening the same inode via
>>two different hardlinks at the same time. With deferred closes, this can
>>result in unexpected behaviour as the following Python snippet shows:
>>
>>The final open returns EINVAL due to the server returning
>>STATUS_INVALID_PARAMETER.
>
>Good sleuthing. The hardlink behavior is slightly surprising, but
>it is certainly the case that certain incompatible combinations of
>open/create flags can conflict with other handles, including
>cached opens.

That certainly sounds like implementation-dependent behavior,
probably due to running into the same dev/ino numbers via
a new path :-).

>>This is kind of an RFC. Is the server doing the wrong thing? Is it
>>correct to work around this in the client?
>
>By definition the server is doing what it does, and it's a moot
>question whether it's appropriate to work around it. However, I don't
>see this behavior explicitly stated in MS-FSA. And INVALID_PARAMETER
>is a strange error code to return for this. Do you have a packet
>trace? We should ask Microsoft.

A packet trace of this would be really interesting :-).
