Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C40CC00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 19:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbiHATqg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 15:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbiHATq3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 15:46:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503DD2E9F7
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 12:46:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 01BC51F8E5;
        Mon,  1 Aug 2022 19:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659383187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3X6zT1noBI+JztfV2lLK4BzFdMeNRcOP97euz0pa39k=;
        b=kyj8mKpKT9CVbkoavg5aDyUNI8gNLl43wcw9S+ExOED1itDVkjKqq+yxuOtQ8SQmUH+nUD
        phT0IKk3ZMZEE2fJdjZeigWTT02Dh3tq6FzCBrBHnOx+0latpWrebxk3B0AQWojF3Qbpu/
        tzwBrXZ9hEo1ix7Z0gz2y4GCTAncIRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659383187;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3X6zT1noBI+JztfV2lLK4BzFdMeNRcOP97euz0pa39k=;
        b=IXDVDWQCN/MdJ1myWkY5Z8TQ1INegBch7Epe2BtVCpwioRUE52sgvsxRyJc9I2jrnAr26l
        37SKBE6JTgzfEzAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7161213A72;
        Mon,  1 Aug 2022 19:46:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ea/ZDJIt6GKZVgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 01 Aug 2022 19:46:26 +0000
Date:   Mon, 1 Aug 2022 16:46:23 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [WIP PATCH][CIFS] move legacy cifs (smb1) code to legacy ifdef
 and do not include in build when legacy disabled
Message-ID: <20220801194623.cg74c446js26nwmb@cyberdelia>
References: <CAH2r5mvX3UT0q50rmMb-WSt6eSxh1i_gcmPdDBW1x1Qn6ppDNg@mail.gmail.com>
 <CAN05THRJTvA7huZjuW-tCPZjk6Nq_8EasjP6kQ0BGMBxBCtgqg@mail.gmail.com>
 <20220801121507.zpcnz55jj2qre3kh@cyberdelia>
 <20220801123930.ltet3tadtdlf6hpq@cyberdelia>
 <f8632ab0-ddc4-ff8e-1bd1-3088cf05eb5c@talpey.com>
 <CAH2r5muP5ZgcsypLSFm1t2cE8x4n_8fmu7heoUiW5x2L6rN__Q@mail.gmail.com>
 <20220801194438.dg4yxolu2yqvrpej@cyberdelia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220801194438.dg4yxolu2yqvrpej@cyberdelia>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 08/01, Enzo Matsumiya wrote:
>Btw, AFAICS ioctl.o can also be moved to CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>without any other changes.

Nevermind, was looking at the wrong branch.

Sorry for the noise.
