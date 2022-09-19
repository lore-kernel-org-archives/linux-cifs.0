Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E7FC6FA86
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Sep 2022 15:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiISPQt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Sep 2022 11:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiISPQc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Sep 2022 11:16:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9057B25C46
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 08:15:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5EA021F8B5;
        Mon, 19 Sep 2022 15:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663600539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p7E8YgzPMDyW/FM2BIlKTEfoopTCrt0e4nOX37/ZEn8=;
        b=fEwxPio38iI4HM8SiIak8dfo+DyuRfCzhXai1VbFAw9OaRFja3TXfrbGuB4qaedDHqTRMo
        kdJEp/zK83opkIoI0mXAMZrADO0h6Eslwvkso4hHdWNFnf8xvZ7DIM5fIYCZsh4KvCIPez
        f06cbPPcPiQLNvQe4VgNwvrR0QrOVjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663600539;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p7E8YgzPMDyW/FM2BIlKTEfoopTCrt0e4nOX37/ZEn8=;
        b=GxvIueIE9Vy0+PuwY4eOgiWQ9QLmoT8B56mpfhbkRfAFrPXkngmPPYHcCOFgCS4Kx4ut9X
        eqO6NMYYV7nvPlCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D4F3613A96;
        Mon, 19 Sep 2022 15:15:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GOngJZqHKGNZdAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 19 Sep 2022 15:15:38 +0000
Date:   Mon, 19 Sep 2022 12:15:36 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: verify signature only for valid responses
Message-ID: <20220919151536.rqwodfkrzuf4hzte@suse.de>
References: <20220917020704.25181-1-ematsumiya@suse.de>
 <bf09670b-df76-7fcc-2c8c-8b049f82d41b@talpey.com>
 <20220917162827.g3c32bh62maw7da3@suse.de>
 <3e03b3ec-f733-06b1-3023-592801414ae8@talpey.com>
 <20220919002158.wgta4konh6c4wfjr@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220919002158.wgta4konh6c4wfjr@suse.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/18, Enzo Matsumiya wrote:
> but if we consider that other messages with status !=
>STATUS_SUCCESS have their signatures correctly computed (apparently),
>then I'd guess there's something wrong with computing signatures for
>STATUS_END_OF_FILE responses.

Correcting myself here: messages with status != STATUS_SUCCESS and !=
STATUS_END_OF_FILE take different path that never reaches ->calc_signature().

>Sent this just now:
>https://lore.kernel.org/linux-cifs/20220918235442.2981-1-ematsumiya@suse.de/T/#u

So I guess this patch is sufficient for now.


Cheers,

Enzo
