Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C20FC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Mar 2022 19:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbiCaTvi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Mar 2022 15:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236600AbiCaTvh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Mar 2022 15:51:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8B749FA2
        for <linux-cifs@vger.kernel.org>; Thu, 31 Mar 2022 12:49:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3EC101F7AC;
        Thu, 31 Mar 2022 19:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648756187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5EL/WnqW5laWvmfUCycNog8Hkiu92ekliRyKz4/+yHY=;
        b=hHGZYQXJX2N/uYUoo4qTuJ0/Z0vOKx0B4WhIj0xfYvbmIfi8yqlrsUNkLNfZrYqjf1iPjR
        j2a/gds2UpGdYUmcU8HXootif5qOd9YaxL0fAyj0ruMgltAklCRgpsUzhfOExmg/YDoW1r
        pUxsLJrjT+c+ucmiikZ/0mTRBEZb+kg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648756187;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5EL/WnqW5laWvmfUCycNog8Hkiu92ekliRyKz4/+yHY=;
        b=FGie9ipXbIdsJvQMfoGpXkjBTBBB/QmOXcKTcHZlkuo2bBWUKyI189v6+AzR51J4C3f4en
        wBSW/WaXrhJEd8Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C2CCC133D4;
        Thu, 31 Mar 2022 19:49:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7KbhItoFRmLjXQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 31 Mar 2022 19:49:46 +0000
Date:   Thu, 31 Mar 2022 16:49:44 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: Re: [PATCH 2/2] cifs: force new session setup and tcon for dfs
Message-ID: <20220331194944.72cpzns6hako7lcx@cyberdelia>
References: <20220331180151.5301-1-pc@cjr.nz>
 <20220331180151.5301-2-pc@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220331180151.5301-2-pc@cjr.nz>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 03/31, Paulo Alcantara wrote:
>Do not reuse existing sessions and tcons in DFS failover as it might
>connect to different servers and shares.
>
>Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>---
> fs/cifs/connect.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
>
>diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>index 3ca06bd88b6e..3956672a11ae 100644
>--- a/fs/cifs/connect.c
>+++ b/fs/cifs/connect.c
>@@ -536,8 +536,11 @@ int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
> 		return __cifs_reconnect(server, mark_smb_session);
> 	}
> 	spin_unlock(&cifs_tcp_ses_lock);
>-
>-	return reconnect_dfs_server(server, mark_smb_session);
>+	/*
>+	 * Ignore @mark_smb_session and invalidate all sessions & tcons as we might be connecting to
>+	 * a different server or share during failover.
>+	 */
>+	return reconnect_dfs_server(server, true);

If you're ignoring @mark_smb_session, why not just leave @server for
reconnect_dfs_server()?


Cheers,

Enzo
