Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF074C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 17:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244827AbiDARnj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Apr 2022 13:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238038AbiDARnj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Apr 2022 13:43:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9188411436C
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 10:41:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3EA0D210EC;
        Fri,  1 Apr 2022 17:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648834908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YffL2htPiHircpdKU3GEGMdIgTCPBYrAI/HK81ZuL8k=;
        b=DftZ8Q6Ktb8EBQRsWn/Tgj89I/il0igI1qOZ46BYKKzdKrYnl6VTtsdsdEfEoq1xGu82LL
        Ijxj80qM7uhXSxrXjjUCSoAKdBmngXLWSxphcQbAJQU4ANmK5ae/doJ+kc6NbwHOyb69Gn
        oC7BwIFjWtQ9YaCVLqD70VVOpT1FsGQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648834908;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YffL2htPiHircpdKU3GEGMdIgTCPBYrAI/HK81ZuL8k=;
        b=Me7r3L9cwb5vg91RVHmT20I8Oo+s0d4lkY4SRSFT9TmoOF99Eiufj2bAtGxIX5iTXFCH0/
        8IqcrZVF5wWFsgBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BD3A5132C1;
        Fri,  1 Apr 2022 17:41:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VrjtIFs5R2KWUwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 01 Apr 2022 17:41:47 +0000
Date:   Fri, 1 Apr 2022 14:41:45 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, pshilovsky@samba.org,
        smfrench@gmail.com, pc@cjr.nz
Subject: Re: [PATCH] mount.cifs.rst: add FIPS information
Message-ID: <20220401174145.6x443h555ch7kspd@cyberdelia>
References: <20220331235251.4753-1-ematsumiya@suse.de>
 <efb1d822-4fcf-dc3b-2861-8394f50aedbe@talpey.com>
 <20220401152508.edovgwz5pxn6gnhn@cyberdelia>
 <d5648e12-c5b9-07de-a20b-afd49adc5f56@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d5648e12-c5b9-07de-a20b-afd49adc5f56@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 04/01, Tom Talpey wrote:
>On 4/1/2022 11:25 AM, Enzo Matsumiya wrote:
>>On 04/01, Tom Talpey wrote:
>>>Is SMB2 really FIPS compliant? Even if it is, a server that doesn't
>>>support anything higher is obviously far out of date.
>>
>>It's more that the crypto stuff used by SMB1 is *not* compliant.
>
>Sure, but that's not the point here. It's time to simply state
>"don't use SMB1".

I 100% agree.

But, actually, that's the whole point of my commit. I just wanted to add
what will work with mount.cifs on a FIPS compliant environment. Nothing
else.

Stating "don't use SMB1" (either FIPS or not) could come in a different
commit.

(Personally, I would've nuked all SMB1 from the kernel altogether :P)

>I don't think the crypto algorithm is enough. SMB2 is vulnerable
>to man-in-the-middle attacks and therefore the crypto type is
>only a part of the picture. SMB3 is much stronger, even with the
>same crypto algs.

Again, I agree. But I'd say it's up to FIPS to mandate that. Even
because their requirements only cover the crypto modules, not
filesystems and/or versions as a whole AFAIK.

>The Microsoft FIPS statement only refers to SMB3, for example:
>
>
>https://docs.microsoft.com/en-us/windows/security/threat-protection/fips-140-validation
>
>  Is SMB3 (Server Message Block) FIPS 140 compliant in Windows?
>
>  SMB3 can be FIPS 140 compliant, if Windows is configured to operate in
>  FIPS 140 mode on both client and server. In FIPS mode, SMB3 relies on
>  the underlying Windows FIPS 140 validated cryptographic modules for
>  cryptographic operations.

But that's on a product (OS) level. We're preparing similar
documentation for SUSE as well, for example.

>I think anyone who is serious enough to want FIPS should darn well
>be advised that the best security means running the strongest version
>of the protocol, and the doc should not waffle around with discussion
>of SMB1 or SMB2.

And again, I also agree. My intent was to rather have specified in the
docs what's supported in FIPS mode. Suggesting/enforcing a particular
version or security mode was out of scope of my patch.


Cheers,

Enzo
