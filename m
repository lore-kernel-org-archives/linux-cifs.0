Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67E9C3DA79
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 20:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbiL2UOy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 15:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbiL2UOx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 15:14:53 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B4513DE1
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 12:14:52 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8C7421F38D;
        Thu, 29 Dec 2022 20:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672344891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DFyOYzPW8zd2W3YaepKhpNcWLaL43wBfI5gq91ImqqE=;
        b=yQxabGjcxW0buBtK9d+SPkIo+RMBnN9O9PXfjashvjkwNhhZKlQClZyNn6aHoh3A3mV+X3
        blnENnzq93ZLRmsCErQ8nqCg437gOlYYpKRFTA/XJKaFrWNruxtn1JivGYUC1Zgi0XeinW
        fANnZ61JFWwTso1+3xlspSCEa1lPTt4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672344891;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DFyOYzPW8zd2W3YaepKhpNcWLaL43wBfI5gq91ImqqE=;
        b=I9aBe+X4Js1N7iKuMfiqX7ws4YMEu1ZBYrFUryn+/rdq3sq2kPCD69+pFlTEyOLQnnDkQg
        uODrKjJjFcp6jvDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 11CC413913;
        Thu, 29 Dec 2022 20:14:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oZrbMTr1rWMyOQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Dec 2022 20:14:50 +0000
Date:   Thu, 29 Dec 2022 17:14:48 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 2/2] cifs: fix race in assemble_neg_contexts()
Message-ID: <20221229201448.bzxqnsea52zcb4xw@suse.de>
References: <20221229153356.8221-1-pc@cjr.nz>
 <20221229153356.8221-2-pc@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221229153356.8221-2-pc@cjr.nz>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 12/29, Paulo Alcantara wrote:
>Serialise access of TCP_Server_Info::hostname in
>assemble_neg_contexts() by holding the server's mutex otherwise it
>might end up accessing an already-freed hostname pointer from
>cifs_reconnect() or cifs_resolve_server().
>
>Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>

Couldn't reproduce this one as easy as the other one, but it makes sense
anyway.

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>

>---
> fs/cifs/smb2pdu.c | 11 +++++++----
> 1 file changed, 7 insertions(+), 4 deletions(-)
>
>diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>index a5695748a89b..2c484d47c592 100644
>--- a/fs/cifs/smb2pdu.c
>+++ b/fs/cifs/smb2pdu.c
>@@ -541,9 +541,10 @@ static void
> assemble_neg_contexts(struct smb2_negotiate_req *req,
> 		      struct TCP_Server_Info *server, unsigned int *total_len)
> {
>-	char *pneg_ctxt;
>-	char *hostname = NULL;
> 	unsigned int ctxt_len, neg_context_count;
>+	struct TCP_Server_Info *pserver;
>+	char *pneg_ctxt;
>+	char *hostname;
>
> 	if (*total_len > 200) {
> 		/* In case length corrupted don't want to overrun smb buffer */
>@@ -574,8 +575,9 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
> 	 * secondary channels don't have the hostname field populated
> 	 * use the hostname field in the primary channel instead
> 	 */
>-	hostname = CIFS_SERVER_IS_CHAN(server) ?
>-		server->primary_server->hostname : server->hostname;
>+	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
>+	cifs_server_lock(pserver);
>+	hostname = pserver->hostname;
> 	if (hostname && (hostname[0] != 0)) {
> 		ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
> 					      hostname);
>@@ -584,6 +586,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
> 		neg_context_count = 3;
> 	} else
> 		neg_context_count = 2;
>+	cifs_server_unlock(pserver);
>
> 	build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
> 	*total_len += sizeof(struct smb2_posix_neg_context);
>-- 
>2.39.0
>
