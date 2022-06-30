Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C792C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jun 2022 20:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbiF3UcM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jun 2022 16:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiF3UcM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jun 2022 16:32:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBE8313AD
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 13:32:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0452A1FEA4;
        Thu, 30 Jun 2022 20:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656621130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wauOW9tFxdD+h+kipSBzdbD7Mveo36HUPWhQbRxz8pk=;
        b=i8BIkkmAbKiTaexEOTfMxu+fHBIk3FLP0JI85P0pT4xXEgWEvDnncgl5FJ7cvt30yGnwgQ
        gJCUiEAjOb9ZSyHPzpZ15kX5oQoSKLvBL308NlFJ2YjUAJZ3N8SIU+rvG++j4QQ0xRsmVl
        04fl3ACTwyNxIIoTiHNyx9Qi6YJmAUM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656621130;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wauOW9tFxdD+h+kipSBzdbD7Mveo36HUPWhQbRxz8pk=;
        b=qLijiuj1oHaXhAz3AEzVmuYQ+KlV7ln8kOhLXSz4moQfNAHBf6kzNJwnDEk7kynts9IoyJ
        C2wG9kcaN8/duODQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7CDFF139E9;
        Thu, 30 Jun 2022 20:32:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mEJcEEkIvmI/aQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 30 Jun 2022 20:32:09 +0000
Date:   Thu, 30 Jun 2022 17:32:07 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Julian Sikorski <belegdol@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: kernel-5.18.8 breaks cifs mounts
Message-ID: <20220630203207.ewmdgnzzjauofgru@cyberdelia>
References: <211885e7-1823-9118-836b-169c7163d7c2@gmail.com>
 <CAN05THTbuBSF6HXh5TAThchJZycU1AwiQkA0W7hDwCwKOF+4kw@mail.gmail.com>
 <fee59438-7b4a-0a24-f116-07c2ac39a3ad@gmail.com>
 <87h7423ukh.fsf@cjr.nz>
 <10efd255-16ea-6993-5e58-2d70e452a019@gmail.com>
 <87edz63t11.fsf@cjr.nz>
 <4c28c2f8-cda6-d9b4-d80f-1ffa3a3be14c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4c28c2f8-cda6-d9b4-d80f-1ffa3a3be14c@gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 06/30, Julian Sikorski wrote:
>>>Openmediavault 6.0.30 running on top of armbian bullseye. The samba
>>>package version is 4.13.13+dfsg-1~deb11u3.

[ ... ]

>16d5d9100927 smb3: use netname when available on secondary channels
>
>initally, and reverting it did not help. Reverting
>
>ca83f50b43a0 smb3: fix empty netname context on secondary channels
>
>makes the mounts work again.

It's possible that server is not discarding/ignoring SMB2_NETNAME_NEGOTIATE_CONTEXT_ID
negotiate context as it should, and rather treating it as an error. 

I took a quick look in SLE15-SP3 samba 4.15 code and I didn't spot any
obvious mishandling there (it seems it's not supported yet). Also I
couldn't reproduce the issue with that server.

Maybe it's possible it's a vendor modification?


Cheers,

Enzo
