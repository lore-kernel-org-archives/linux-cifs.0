Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0912C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 17:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355490AbiEDRML (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 May 2022 13:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356127AbiEDRJD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 May 2022 13:09:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A697352B18
        for <linux-cifs@vger.kernel.org>; Wed,  4 May 2022 09:54:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 37595210E3;
        Wed,  4 May 2022 16:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651683292; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NjN/lUtV32poi40Mde6s1+Ego1F2aRYyyKZNQkMdBn0=;
        b=U7ray3+cmCDyaAMLS8bR0tWB4ZknsuvqmXOl95CGsh02bvv7F2jtkUeU9yJGzGxv2aeJHs
        04WI3OCdemBzpvYwyWOQS6WNnyfJImkjDBmWU4O+rIFEAH8ftCLzGtHDFd1yfAUrvjU7Ko
        GoqKRuIRbHAarl9qSNthRPX3ykkkG84=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651683292;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NjN/lUtV32poi40Mde6s1+Ego1F2aRYyyKZNQkMdBn0=;
        b=i4iKn3sB1PI22fRvgEUo+bIVhpi7HNjaG4s23uMwTfTK9JxPQcp4ZJm3tkHRTNWUjkO2Oo
        Zf5HXKQm+R44YZBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A5FCE131BD;
        Wed,  4 May 2022 16:54:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GsFNGduvcmK4VAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 04 May 2022 16:54:51 +0000
Date:   Wed, 4 May 2022 13:54:30 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: cache dirent names for cached directories
Message-ID: <20220504165430.xptspu37vmhwwesj@cyberdelia>
References: <20220504014407.2301906-1-lsahlber@redhat.com>
 <20220504014407.2301906-2-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220504014407.2301906-2-lsahlber@redhat.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 05/04, Ronnie Sahlberg wrote:
>+struct cached_dirents {
>+	bool is_valid:1;
>+	bool is_failed:1;

Does it make sense to have both? Do you expect a situation where
is_valid && is_failed happens? From the patch, I don't see such case and
the code could be adjusted to use !is_valid where appropriate.
But let me know if I missed something.

This is just a cosmetic nitpick, but other than that,

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers,

Enzo
