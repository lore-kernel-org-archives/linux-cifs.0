Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A17C00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 12:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiHAMtI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 08:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiHAMsx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 08:48:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC77491C7
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 05:39:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E82504DD90;
        Mon,  1 Aug 2022 12:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659357573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ZXhS5b5jbK3Byx3GUOxpZygKpW2qIDcb0ZwjXzUfQA=;
        b=Xn4OtIUZFUQ9Khe8/mo9KnK1BK1vsYTjmiLXSBlz4gdCxRUHTDhNiD/MkUwbHEkoM8xl9B
        xRquwtkCaRZnVzt9MAfWjZvI+dln1CceZU6yncmgTqAGs/5WCidmQYIOgETOdJv7uGnYTj
        1KXtWpA4Z//88XxGufrYiw3veScFnjY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659357573;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ZXhS5b5jbK3Byx3GUOxpZygKpW2qIDcb0ZwjXzUfQA=;
        b=HU87N8QsjqcGOA92qK9YsY8PwZgSnYjfq3Y0wvqsGJjXCQqF3GmzNKdjunoAf3RSRPAgi9
        K93Wfzp0ZKzYYnDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6889D13AAE;
        Mon,  1 Aug 2022 12:39:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EOckC4XJ52INJQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 01 Aug 2022 12:39:33 +0000
Date:   Mon, 1 Aug 2022 09:39:30 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>
Subject: Re: [WIP PATCH][CIFS] move legacy cifs (smb1) code to legacy ifdef
 and do not include in build when legacy disabled
Message-ID: <20220801123930.ltet3tadtdlf6hpq@cyberdelia>
References: <CAH2r5mvX3UT0q50rmMb-WSt6eSxh1i_gcmPdDBW1x1Qn6ppDNg@mail.gmail.com>
 <CAN05THRJTvA7huZjuW-tCPZjk6Nq_8EasjP6kQ0BGMBxBCtgqg@mail.gmail.com>
 <20220801121507.zpcnz55jj2qre3kh@cyberdelia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220801121507.zpcnz55jj2qre3kh@cyberdelia>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 08/01, Enzo Matsumiya wrote:
>On 08/01, ronnie sahlberg wrote:
>>Small nit : in cifssmb.c  why comment out smb2proto.h,  just delete the line.
>
>Agreed.
>
>@Steve also, why ifdef everything instead of putting everything in a
>"smb1" dir and just use Kconfig to build that dir? IOW like I did in in
>my branch https://github.com/ematsumiya/linux/commits/refactor

Just to be clear on the advantages of this: clean code (reduce those
ifdefs by a lot), move shared code to module top-level and fixes to
those code gets higher priority to the newer protocol versions, proper
isolation of smb1 code (separate dir) instead of a "virtual" one (ifdefs),
all that while we can also maintain history if using "git mv" to move
SMB1 specific files.
