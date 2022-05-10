Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632DDC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 10 May 2022 22:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiEJW5i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 May 2022 18:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiEJW5h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 May 2022 18:57:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE0F60053
        for <linux-cifs@vger.kernel.org>; Tue, 10 May 2022 15:57:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C3F261F8E5;
        Tue, 10 May 2022 22:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652223452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fup5FzGqCa+noLq9OQCXdoudYE3msbwsn7FOvlbso/A=;
        b=jc+vaSJJVOnjChe81s40OGFypLan7TaHCpPqNHryF4NGhV7L0JcNCMOhFnSgPMuk39SpfN
        9Gujmo9B8+nDsa2oG9m/xU5uQFO9QznIRSt8zkHJXt/THtshHMToFfX7TK9JN21pCiFr9z
        63zIq79rGVM7D4QHNLauT2XHQP47lhg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652223452;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fup5FzGqCa+noLq9OQCXdoudYE3msbwsn7FOvlbso/A=;
        b=WDEQBW5+BF8YrXbLMOuQzNTkpbHKiYXoh/bTWUoknUDx8DPDFVrnsdSoyEHLmV/YyBryC8
        mT4ObZ8nJXDCk0Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3AE4E13AA5;
        Tue, 10 May 2022 22:57:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5UI7OtvtemLKDgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 10 May 2022 22:57:31 +0000
Date:   Tue, 10 May 2022 19:57:05 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 4/4] cifs: cache the dirents for entries in a cached
 directory
Message-ID: <20220510225705.vf7ibmpdjqdeq72v@cyberdelia>
References: <20220509234207.2469586-1-lsahlber@redhat.com>
 <20220509234207.2469586-5-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220509234207.2469586-5-lsahlber@redhat.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ronnie,

On 05/10, Ronnie Sahlberg wrote:
>+struct cached_dirents {
>+	bool is_valid:1;
>+	bool is_failed:1;

Just as I commented in the other thread, having both fields above confuses me.
Shouldn't using is_valid/!is_valid be enough?


Cheers,

Enzo
