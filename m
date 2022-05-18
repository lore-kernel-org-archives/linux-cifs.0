Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66BFEC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 16:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240042AbiERQXm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 12:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240035AbiERQXk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 12:23:40 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFAA1F0DEE
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 09:23:39 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id A26137FD1E;
        Wed, 18 May 2022 16:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1652891018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4a5gtfO1gabBvJ5tqhytPYjW7E8bORm8M0RcoX6J13Y=;
        b=a7ICQ9BHSi6ShGESyJ/Jotq4bieNMG99vqRPXM5zOP5B8JQmBwIJZaPlK+UjqQb+bpIrfF
        PynIBG448vzJ50sFEg0UFz9TnMEEvDFUT3WyG9x/j4/BqoS5FQykUdJivdHBpJ6F4YoO+Y
        wJM80THBskxZMrFChN5qsCCcW1Owtrk/DMOXe2pwLMzXohzk+0vSoLhEFDwp2kTcKhgm7B
        Hmj9/4OMyfB1cTYYE3KzGfZAW8VI3wWrKtVKgF25512ehZMfDZTQMW4izSzQfpdszLN+F2
        QgVDF8RenHhJOENcLoFnoMqw8dzdzeZ4BLafaMEulbA6Rf8yU4qM4kqBV3OE8g==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: Re: [PATCH] cifs: return ENOENT for DFS lookup_cache_entry()
In-Reply-To: <20220518144105.21913-3-ematsumiya@suse.de>
References: <20220518144105.21913-1-ematsumiya@suse.de>
 <20220518144105.21913-3-ematsumiya@suse.de>
Date:   Wed, 18 May 2022 13:23:34 -0300
Message-ID: <877d6i3j3t.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

> EEXIST didn't make sense to use when dfs_cache_find() couldn't find a
> cache entry nor retrieve a referral target.
>
> It also doesn't make sense cifs_dfs_query_info_nonascii_quirk() to
> emulate ENOENT anymore.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/connect.c   | 6 ++++--
>  fs/cifs/dfs_cache.c | 6 +++---
>  fs/cifs/misc.c      | 6 +-----
>  3 files changed, 8 insertions(+), 10 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
