Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF75CC3DA7D
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 20:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbiL2UKh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 15:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiL2UKf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 15:10:35 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614B2FCC8
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 12:10:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F13D71F381;
        Thu, 29 Dec 2022 20:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672344632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ulbKQS28zlnVXhJm5PMLNuNN7o/HnJkk8eB3amJDoAg=;
        b=pZomhluS2YctH3MT+A6RabzbfU7jc56Ks4MKHmcJzkuCN6FMKDrbGJxj03JBTbdb3Auy//
        bh8Vc251C/1V5PuPUr/FCkCz2zeJwS/yBj6JQsenx9KhXr2OODcf6hnAEH5kCKr1toVFnj
        HTT+Rl7EcBGTD+9c184kfs+YuxV2Nug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672344632;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ulbKQS28zlnVXhJm5PMLNuNN7o/HnJkk8eB3amJDoAg=;
        b=JANB/KoDd+ytBsU5Fd6Ni12/jj+Bl1fcYlQcOMwn5Inprt/iiKlrF1kUuqUjOL3JPG/6XL
        /M2vpweHxHF5fICQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6267B13913;
        Thu, 29 Dec 2022 20:10:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9XoBCTj0rWPRNwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Dec 2022 20:10:32 +0000
Date:   Thu, 29 Dec 2022 17:10:29 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] cifs: ignore ipc reconnect failures during dfs
 failover
Message-ID: <20221229201029.lajhejwbbtca6poc@suse.de>
References: <20221229153356.8221-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221229153356.8221-1-pc@cjr.nz>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 12/29, Paulo Alcantara wrote:
>If it failed to reconnect ipc used for getting referrals, we can just
>ignore it as it is not required for reconnecting the share.  The worst
>case would be not being able to detect or chase nested links as long
>as dfs root server is unreachable.
>
>Before patch:
>
>  $ mount.cifs //root/dfs/link /mnt -o echo_interval=10,...
>    -> target share: /fs0/share
>
>  disconnect root & fs0
>
>  $ ls /mnt
>  ls: cannot access '/mnt': Host is down
>
>  connect fs0
>
>  $ ls /mnt
>  ls: cannot access '/mnt': Resource temporarily unavailable
>
>After patch:
>
>  $ mount.cifs //root/dfs/link /mnt -o echo_interval=10,...
>    -> target share: /fs0/share
>
>  disconnect root & fs0
>
>  $ ls /mnt
>  ls: cannot access '/mnt': Host is down
>
>  connect fs0
>
>  $ ls /mnt
>  bar.rtf  dir1  foo
>
>Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>

>---
> fs/cifs/dfs.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
>index b541e68378f6..30086f2060a1 100644
>--- a/fs/cifs/dfs.c
>+++ b/fs/cifs/dfs.c
>@@ -401,8 +401,7 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
> 		if (ipc->need_reconnect) {
> 			scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
> 			rc = ops->tree_connect(xid, ipc->ses, tree, ipc, cifs_sb->local_nls);
>-			if (rc)
>-				break;
>+			cifs_dbg(FYI, "%s: reconnect ipc: %d\n", __func__, rc);
> 		}
>
> 		scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
>-- 
>2.39.0
>
