Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A9FC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 16:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240190AbiERQ0c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 12:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240086AbiERQ0C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 12:26:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0787915A25
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 09:25:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BB7F621B95;
        Wed, 18 May 2022 16:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652891157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fLhi2QrDO1aNue1DbzYA/GZPBVHJTWtmb8ZxIcofUqA=;
        b=G1LCRqcYVUT74lYnRfzgtUFb5lV4Xfb/rHJJLgXOWlKQf8BNDxJHQq/o2PeFnJ25wCmNBF
        hyZg2qXgRbEF9BEj10cO/w2wCf5yh+R8eL6hLHyUqTtSMmrjPgGOMF0bwQ4DQaoUq49Zzl
        kipDtOkHAEDqsPhPIfduUqPqRaSvMS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652891157;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fLhi2QrDO1aNue1DbzYA/GZPBVHJTWtmb8ZxIcofUqA=;
        b=U6ns6J3aRerBxB/4AVWadK7FMEbmV2gXPybU7i6FdAhTYmhir/2g2IYivtvzqnEWUwHON/
        PzTt49sMLj4NMLAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3849713A6D;
        Wed, 18 May 2022 16:25:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uwQROxQehWLEZwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 18 May 2022 16:25:56 +0000
Date:   Wed, 18 May 2022 13:24:59 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: don't call cifs_dfs_query_info_nonascii_quirk() if
 nodfs was set
Message-ID: <20220518162459.o3g3qixh7h4wc2c4@cyberdelia>
References: <20220518144105.21913-1-ematsumiya@suse.de>
 <87ee0q3j9k.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87ee0q3j9k.fsf@cjr.nz>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 05/18, Paulo Alcantara wrote:
>You can get rid of !nodfs check since it is useless.  The comment might
>be kept, though.

Right. That was a left over from my previous tests. I'll remove and
re-send.

>Other than that,
>
>Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>
>Steve, please mark it for stable.

Thanks.


Cheers,

Enzo
