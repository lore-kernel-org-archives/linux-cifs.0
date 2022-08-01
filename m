Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DB4C00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 19:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbiHATop (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 15:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbiHAToo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 15:44:44 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3734E17040
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 12:44:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 980501F8E5;
        Mon,  1 Aug 2022 19:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659383081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U7oHnTveK3zmiZ70X5WRu1jCdBwVMGT7993zeDUvs2A=;
        b=CZaFSv5KY7XLSKzMU4keVY7U0w5YTFUGtyUsn8P/4N7RI+bO6avcO6OT+mW0TanNUE/JKH
        XDoxOAGlsfYhMesBky/N7XzrQx26zDoeZruTNkBhKg/TdIzFV3HKy1LtP5htJIKypSdWbV
        QWbyx5la/8tqcJmt66fvBGSi9p+WDyQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659383081;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U7oHnTveK3zmiZ70X5WRu1jCdBwVMGT7993zeDUvs2A=;
        b=UfQKncjJ2TK2eWyocsa2IE1dGGFzqtO9xFPIBfy3lM1KH04nzhsk3aUIXVqk7HbpnAOW9k
        gN5pUoJhUTS8eFDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0AD9B13A72;
        Mon,  1 Aug 2022 19:44:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /K+BLygt6GLyVQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 01 Aug 2022 19:44:40 +0000
Date:   Mon, 1 Aug 2022 16:44:38 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [WIP PATCH][CIFS] move legacy cifs (smb1) code to legacy ifdef
 and do not include in build when legacy disabled
Message-ID: <20220801194438.dg4yxolu2yqvrpej@cyberdelia>
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

Btw, AFAICS ioctl.o can also be moved to CONFIG_CIFS_ALLOW_INSECURE_LEGACY
without any other changes.
