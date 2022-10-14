Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E95C433FE
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Oct 2022 20:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiJNUSz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Oct 2022 16:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiJNUSz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Oct 2022 16:18:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A601CEC02
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 13:18:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 06A4733824;
        Fri, 14 Oct 2022 20:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665778732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UMQpWx+R7A6Uk7rQD2R21YiS2IjDPXqs+OrAcgUtvDI=;
        b=i3rUnkjyUFuoG/5sU+DeFZiVlORVXj70vwqAadZfDO5CfX+salzDDPnkHCPcjGxxbAJICU
        HiOKjXS3wrVHjTO4+2qdcllnuidkWGICQq/7khiEGtciXXZBqs8dq8kWFC9H1Ak+2nh2i/
        XILPhYWMFocrasE/0/HpMJZ7Pag4Xhs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665778732;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UMQpWx+R7A6Uk7rQD2R21YiS2IjDPXqs+OrAcgUtvDI=;
        b=I6XZsA0Wq7LN/HIdZ6BB9MB1v9rWtyTw2HDxoreJchPjGwweiYoev5UOo2Al01SayBJvkf
        mYpQ3n5u0B//jADA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 84A0213451;
        Fri, 14 Oct 2022 20:18:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6XV6FCvESWM8aQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 14 Oct 2022 20:18:51 +0000
Date:   Fri, 14 Oct 2022 17:18:49 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: fix double-fault crash during ntlmssp
Message-ID: <20221014201849.t7qanipnrex6bdm7@suse.de>
References: <20221014201454.4456-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221014201454.4456-1-pc@cjr.nz>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/14, Paulo Alcantara wrote:
>The crash occurred because we were calling memzero_explicit() on an
>already freed sess_data::iov[1] (ntlmsspblob) in sess_free_buffer().
>
>Fix this by not calling memzero_explicit() on sess_data::iov[1] as
>it's already by handled by callers.
>
>Fixes: d867d4ae29c7 ("cifs: replace kfree() with kfree_sensitive() for sensitive data")
>Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>

Good catch! Thanks.

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>

>---
> fs/cifs/sess.c | 16 +++++++++-------
> 1 file changed, 9 insertions(+), 7 deletions(-)
>
>diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>index f1c3c6d9146c..d33a27c1af4e 100644
>--- a/fs/cifs/sess.c
>+++ b/fs/cifs/sess.c
>@@ -1213,16 +1213,18 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
> static void
> sess_free_buffer(struct sess_data *sess_data)
> {
>-	int i;
>+	struct kvec *iov = sess_data->iov;
>
>-	/* zero the session data before freeing, as it might contain sensitive info (keys, etc) */
>-	for (i = 0; i < 3; i++)
>-		if (sess_data->iov[i].iov_base)
>-			memzero_explicit(sess_data->iov[i].iov_base, sess_data->iov[i].iov_len);
>+	/*
>+	 * Zero the session data before freeing, as it might contain sensitive info (keys, etc).
>+	 * Note that iov[1] is already freed by caller.
>+	 */
>+	if (sess_data->buf0_type != CIFS_NO_BUFFER && iov[0].iov_base)
>+		memzero_explicit(iov[0].iov_base, iov[0].iov_len);
>
>-	free_rsp_buf(sess_data->buf0_type, sess_data->iov[0].iov_base);
>+	free_rsp_buf(sess_data->buf0_type, iov[0].iov_base);
> 	sess_data->buf0_type = CIFS_NO_BUFFER;
>-	kfree(sess_data->iov[2].iov_base);
>+	kfree_sensitive(iov[2].iov_base);
> }
>
> static int
>-- 
>2.37.3
>
