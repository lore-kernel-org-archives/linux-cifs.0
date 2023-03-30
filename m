Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404CAC6FD1D
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Mar 2023 22:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjC3WUH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Mar 2023 18:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjC3WUG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Mar 2023 18:20:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77488B74B
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 15:20:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 22288219C7;
        Thu, 30 Mar 2023 22:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680214804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Z++r4UWT/1jfK7CAV8r5heQqTcGgCOe/myufRhIfbw=;
        b=gM7DFRJsoWYytbCGXTYjUOR0WbTStk7FlZeYLOyPKJ/mh3oI9TTnwBe7SV4uShEtU1SMyU
        gDCQhPoLlRRalKzgFCFbhEbmEBuYhz2PiyIBogwXmCtYr6WJWwhXUlUVNRf3/GuiprT39N
        H8atUiNWKrGc9FZftzAdpATv0hTyoBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680214804;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Z++r4UWT/1jfK7CAV8r5heQqTcGgCOe/myufRhIfbw=;
        b=GNqF6ncdp20do6oHmBjusPivMUfCDqcxBbcYenUyWNl+b4f3yiLkOCkdH3A1KL6Lb/mmeh
        fznUfU/XYtud2SDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A07F81348E;
        Thu, 30 Mar 2023 22:20:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id I9dYGRMLJmQVDgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 30 Mar 2023 22:20:03 +0000
Date:   Thu, 30 Mar 2023 19:20:01 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Volker Lendecke <vl@samba.org>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH 0/3] Simplify SMB2_open_init
Message-ID: <20230330222001.5vq5b63lnwcmczr7@suse.de>
References: <cover.1680177540.git.vl@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cover.1680177540.git.vl@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Volker,

On 03/30, Volker Lendecke wrote:
>Stitching together can be done in one place, there's no need to do
>this in every add_*_context function.
>
>This supersedes the patchet in
>
>https://www.spinics.net/lists/linux-cifs/msg28087.html.
>
>Volker Lendecke (3):
>  cifs: Simplify SMB2_open_init()
>  cifs: Simplify SMB2_open_init()
>  cifs: Simplify SMB2_open_init()
>
> fs/cifs/smb2pdu.c | 106 +++++++++++-----------------------------------
> 1 file changed, 25 insertions(+), 81 deletions(-)

Would you mind using more descriptive titles please?  To make
referencing/backporting easier.

Also IMHO patches 1/3 and 3/3 could be merged into a single patch.

Aside from that, Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers,

Enzo
