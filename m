Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90393C00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 17:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiHARLc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiHARLb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 13:11:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E668327B16
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 10:11:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 991DA2081E;
        Mon,  1 Aug 2022 17:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659373889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7sfMWsSOPO2eb/RUWWzS3bFF7Motfyb3nWa4JCRKN8Y=;
        b=gje/klB2pfRd3/rPbG6/0YpdzQCIBc8t0leYxVcfoB6tz2+LKtKvHF39Q0upikKCEXFf0v
        EOKxCODiLUhwqkArd4UzzRft1S779lAbfHoXJfDiNtsTveQNKfuElsyRdgdxQb7iH6g8Qs
        w702hM6kTptNyyorXmLpQPatGfShLqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659373889;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7sfMWsSOPO2eb/RUWWzS3bFF7Motfyb3nWa4JCRKN8Y=;
        b=dF7+kdH3XnVaM9F37kBCKOiBvCA0ooIe+oGR+b6k8FhdH7T9G02ZcEPIt+Heew3iQh4uaS
        TG1gkFOJYiboQtBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1F23713AAE;
        Mon,  1 Aug 2022 17:11:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mNYsNUAJ6GJgIAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 01 Aug 2022 17:11:28 +0000
Date:   Mon, 1 Aug 2022 14:11:26 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [WIP PATCH][CIFS] move legacy cifs (smb1) code to legacy ifdef
 and do not include in build when legacy disabled
Message-ID: <20220801171126.wotyb4mibyvrttio@cyberdelia>
References: <CAH2r5mvX3UT0q50rmMb-WSt6eSxh1i_gcmPdDBW1x1Qn6ppDNg@mail.gmail.com>
 <CAN05THRJTvA7huZjuW-tCPZjk6Nq_8EasjP6kQ0BGMBxBCtgqg@mail.gmail.com>
 <20220801121507.zpcnz55jj2qre3kh@cyberdelia>
 <20220801123930.ltet3tadtdlf6hpq@cyberdelia>
 <f8632ab0-ddc4-ff8e-1bd1-3088cf05eb5c@talpey.com>
 <CAH2r5muP5ZgcsypLSFm1t2cE8x4n_8fmu7heoUiW5x2L6rN__Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5muP5ZgcsypLSFm1t2cE8x4n_8fmu7heoUiW5x2L6rN__Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 08/01, Steve French wrote:
>On Mon, Aug 1, 2022 at 10:49 AM Tom Talpey <tom@talpey.com> wrote:
>>
>> I think a big chunk of cifsfs.c, and a boatload of module params,
>> can be similarly conditionalized.
>
>Good point - and will make it easier to read as well.  Perhaps I can
>move most of cifsfs.c to smbfs.c and just leave smb1 specific
>things in cifsfs.c so it can be optionally compiled out?

I'd suggest "core.c" (but smbfs.h) so it doesn't conflict with module name,
e.g.:

Makefile:
----
...
obj-$(CONFIG_SMBFS) += smbfs.o

smbfs-y := smbfs.o ...
...
----
