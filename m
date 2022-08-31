Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3AD5ECAAD1
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 16:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiHaQqJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 12:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiHaQqI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 12:46:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A181D7426
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 09:46:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E07BE220FE;
        Wed, 31 Aug 2022 16:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661964364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iO3SEQyFcIbrjgwOdqmv85ltr2pR2ft9HTj0hc97j9Q=;
        b=n3kyPH4Ag4aiLDpmscSD7OsT7gyhMUqViqi3745OuC8Y8aBpQg6gwoPQARvhCl0vIrgkTQ
        jb8PXqFMOrwIzb0HQrPnKC/K7J539vd6Crn5zNZGn6OQ9lEvBIgXZKjt0bHGK4Vk8NoAJh
        xwQjaa3G2zwdj2oaY6ceVIOlftrSdjM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661964364;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iO3SEQyFcIbrjgwOdqmv85ltr2pR2ft9HTj0hc97j9Q=;
        b=tTsLoWCkw1qOMwtP8pI/hY5uQAPrr4hCrEz/rh4LnTAGqVAGyJzEYI7cs6n7ABkceNcReS
        aLSx+53DwT0yOADA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 63AB41332D;
        Wed, 31 Aug 2022 16:46:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id slIuCkyQD2OyDQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 31 Aug 2022 16:46:04 +0000
Date:   Wed, 31 Aug 2022 13:46:01 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, dan.carpenter@oracle.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 1/3] cifs: introduce AES-GMAC signing support for SMB
 3.1.1
Message-ID: <20220831164601.v2uuy7m4ic5gyetm@cyberdelia>
References: <20220831134444.26252-1-ematsumiya@suse.de>
 <20220831134444.26252-2-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220831134444.26252-2-ematsumiya@suse.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 08/31, Enzo Matsumiya wrote:
>  - Add prototypes for smb2_get_sign_key() (not static anymore) and smb311_aes_gmac_alloc() (new)
>    to smb2proto.h (reported by kernel test robot)
> 
> ...
> 
> extern struct mid_q_entry *smb2_setup_async_request(
>+extern int smb311_aes_gmac_alloc(struct crypto_aead **);
> 			struct TCP_Server_Info *server, struct smb_rqst *rqst);

Steve pointed out an error when building v2, which I fat-finger pasted
the prototype in between smb2_setup_async_request parameters.

Fixed it.

But meanwhile I also found that, after some time copying a 5GB file, the
signatures will be miscalculated, some memory leak occurs, and then a
crash in unlink or umount.

I'm assessing those issues right now, will send v3 later.


Enzo
