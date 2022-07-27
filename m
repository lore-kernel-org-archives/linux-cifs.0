Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967F8C04A68
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jul 2022 15:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiG0Pfa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jul 2022 11:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiG0Pf3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jul 2022 11:35:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795DB1BE9B
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jul 2022 08:35:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3589A20576;
        Wed, 27 Jul 2022 15:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658936127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xM7hPSvlyfcX/jseHualbP8b7yEnyYjQYdUxP+wodbM=;
        b=a1+DnJ+7tFKSWXPKK+/L0dXyLs4iKlfta3WHONpsIxO4Mh3tzmkAE7/f6p8uL67QmtrHkv
        Xk8DCqq+amxW93HeHlLtIUADSqyYgsc9uSArjVDlARuf7IFH4oRywn3ekftgDriUlRklvp
        EaftliFHe/QonqE2cAL4PH6kIj2HwAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658936127;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xM7hPSvlyfcX/jseHualbP8b7yEnyYjQYdUxP+wodbM=;
        b=WLaPmPFlbolrjl4wdM9/dy0Ckxc0+Tk1kylbLU4Pv6qhVQxZIQOuw3DUzTwb8+tMl0dxpA
        2TMISWsyW1m7PDAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ACDD913A8E;
        Wed, 27 Jul 2022 15:35:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PXUEHD5b4WLtcQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 27 Jul 2022 15:35:26 +0000
Date:   Wed, 27 Jul 2022 12:35:24 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: Re: [RFC PATCH v2 05/10] cifs: convert server info vars to snake_case
Message-ID: <20220727153524.25n65rl4ob5f5oxj@cyberdelia>
References: <20220725223707.14477-1-ematsumiya@suse.de>
 <20220725223707.14477-6-ematsumiya@suse.de>
 <CAH2r5mvTHwz2cxbcHFoFm8B6Q-H+V-iVesU05jiL78kT42pRRw@mail.gmail.com>
 <20220727151706.wxqowyibon5h3huz@cyberdelia>
 <CAH2r5msf=Tm9MEmxqvOsWxv=VJP_uKQAtKhnphymhKiBOi6azQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5msf=Tm9MEmxqvOsWxv=VJP_uKQAtKhnphymhKiBOi6azQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 07/27, Steve French wrote:
>On Wed, Jul 27, 2022 at 10:17 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>
>> On 07/27, Steve French wrote:
>> >I doubt that renaming tcpStatus to "status" helps much.  If it has to
>> >do with the socket, included tcp or socket or connection in the name
>> >seems plausible/helpful.  I don't mind removing the came cause (e.g.
>> >"tcp_status" or something similar) but prefer other types of cleanup
>> >to be the focus (moving smb1 code out of mixed smb1/smb2/smb3 c files
>> >into smb1 specific ones that are compiled out when legacy is disabled
>> >etc.
>>
>> Steve, the way I see it is, if we have a struct names "server_info" or
>> similar, there's no need to include a prefix in its fields' names,
>> especially when there's only one "status" variable for that struct
>> (which should always be the case), e.g. "server->server_status" looks
>> ugly and one might assume that "server" holds another different status,
>
>That point makes sense - but these kind of renames are lower priority
>than getting the features/bugfixes cleaned up for the merge window.
>
>Lots of interesting things to work on relating to multichannel,
>leases, compression support, signing negotation (helps perf),
>fixing the swapfile feature, sparse file improvements,
>more testing of posix extensions etc.

I understand that, my changes were more to "lay the ground" for such
fixes/features :) also, sent as RFC because I don't think this is for
this merge window.
