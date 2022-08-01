Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564E8C00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 12:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiHAMgN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 08:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiHAMf6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 08:35:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B68D9E
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 05:15:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2381666DB0;
        Mon,  1 Aug 2022 12:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659356110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HLXErS2lZlrj2U4i0KROp5tQ1qTPN6xvm+K+0JusI0U=;
        b=tgiMs1yj9IK7spNXTZEgErERV2noQL26Q6sdHruwyFZyhIAFjr+yKOZuUOKpI8iJ56o3eO
        2EaaP0UpTSPLOZqjrPuVPG1hLpHq3MyQi0zrWEvhKu6gQDGEhQQjp1ucdIBqqMlwUesSDG
        0ZPpUXDuOmvWn8uHNPjTZizcbeOiiIk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659356110;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HLXErS2lZlrj2U4i0KROp5tQ1qTPN6xvm+K+0JusI0U=;
        b=fc2S4sD/zZZP79/HdzaR1eiSXw0y9v/FUpVbkQB2r4x2h+uBWX/lDneA5H6jvgvhhUder/
        DUxZyw+54aLhl8Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9982813AAE;
        Mon,  1 Aug 2022 12:15:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DeAaF83D52LmGAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 01 Aug 2022 12:15:09 +0000
Date:   Mon, 1 Aug 2022 09:15:07 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>
Subject: Re: [WIP PATCH][CIFS] move legacy cifs (smb1) code to legacy ifdef
 and do not include in build when legacy disabled
Message-ID: <20220801121507.zpcnz55jj2qre3kh@cyberdelia>
References: <CAH2r5mvX3UT0q50rmMb-WSt6eSxh1i_gcmPdDBW1x1Qn6ppDNg@mail.gmail.com>
 <CAN05THRJTvA7huZjuW-tCPZjk6Nq_8EasjP6kQ0BGMBxBCtgqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAN05THRJTvA7huZjuW-tCPZjk6Nq_8EasjP6kQ0BGMBxBCtgqg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 08/01, ronnie sahlberg wrote:
>Small nit : in cifssmb.c  why comment out smb2proto.h,  just delete the line.

Agreed.

@Steve also, why ifdef everything instead of putting everything in a
"smb1" dir and just use Kconfig to build that dir? IOW like I did in in
my branch https://github.com/ematsumiya/linux/commits/refactor
