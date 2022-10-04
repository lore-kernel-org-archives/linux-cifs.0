Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75C7C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Oct 2022 18:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiJDStX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Oct 2022 14:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiJDStS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Oct 2022 14:49:18 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C856A4B4
        for <linux-cifs@vger.kernel.org>; Tue,  4 Oct 2022 11:49:13 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id B8D888079F;
        Tue,  4 Oct 2022 18:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1664909351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CJxv3GXPgX4GgZvIZjt1b7bshmGkwvyEYNAudvVw2WY=;
        b=bAFG7GHsLfYkMeSt3G7r9elXZkZqA45JO6FfrHKItFE1m77hSlvcT3eBFUhsvwdDxIm1L6
        uIX/US54ZrjaPnxAfjxz12ix7eZly0Zzgr8PW/uHroVXENU/psyfZTRHWTVOe7BEndoOwS
        Y/YMZ1bzJex7m0OvXPD/ZeB39G/V0iN2lLZfr+CikCykUGRqAakSzuJW0ud+9/sD1vMhNk
        NWQvVdDyXh+tWyq0mbYbMjyGnXQm572F21JMkscbLOJe9KN7iYclxjAmir+bfEGwkWi5l/
        MhIG+oXfYD3I3J9xNrzigW06wousmb6T1Jo32AwN4BD2GQjgbuqu59pc3SDg/g==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: Re: [PATCH v4 2/8] cifs: secmech: use shash_desc directly, remove
 sdesc
In-Reply-To: <20220929203652.13178-3-ematsumiya@suse.de>
References: <20220929203652.13178-1-ematsumiya@suse.de>
 <20220929203652.13178-3-ematsumiya@suse.de>
Date:   Tue, 04 Oct 2022 15:50:02 -0300
Message-ID: <87v8oz4e5h.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

> The struct sdesc is just a wrapper around shash_desc, with exact same
> memory layout. Replace the hashing TFMs with shash_desc as it's what's
> passed to the crypto API anyway.
>
> Also remove the crypto_shash pointers as they can be accessed via
> shash_desc->tfm (and are actually only used in the setkey calls).
>
> Adapt cifs_{alloc,free}_hash functions to this change.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/cifsencrypt.c   | 86 +++++++++++++----------------------------
>  fs/cifs/cifsglob.h      | 26 ++++---------
>  fs/cifs/cifsproto.h     |  5 +--
>  fs/cifs/link.c          | 13 +++----
>  fs/cifs/misc.c          | 49 ++++++++++++-----------
>  fs/cifs/smb2misc.c      | 13 +++----
>  fs/cifs/smb2transport.c | 72 +++++++++++++---------------------
>  7 files changed, 98 insertions(+), 166 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
