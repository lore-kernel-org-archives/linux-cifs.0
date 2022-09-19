Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0653C54EE9
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Sep 2022 00:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiISAWH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 18 Sep 2022 20:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiISAWG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 18 Sep 2022 20:22:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD484AE5A
        for <linux-cifs@vger.kernel.org>; Sun, 18 Sep 2022 17:22:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7D555221B7;
        Mon, 19 Sep 2022 00:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663546921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uFZF6HYAGhWCnJz5eg+fvgoGzpVDEfWl7ILnqYwTdRM=;
        b=Ua+YK51tUrskj1pBAhxhUj2hWsPuBYQ0uJq7wSvsItP0jucKdNB1FkpWx+gnM2AZBEyyBB
        rGdiLcxldTqe5lze1JBgdmjsm149mm3kdtpVB0NKwRDLlZ3lRNAA0e7ZrMNJW9aoHzw3vf
        JJ7qSYqH5O7A9lhytUHgtjEAN1tZAWA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663546921;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uFZF6HYAGhWCnJz5eg+fvgoGzpVDEfWl7ILnqYwTdRM=;
        b=1/eigTDtW4EjfuQgov6na+8s+pt2xO3hOahhVrjmhHniDJOAO+2G7R1zuEnJBNwb6immfr
        u2SEwLCOp7+Xj4Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EB68013A96;
        Mon, 19 Sep 2022 00:22:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4UCoKii2J2OZLgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 19 Sep 2022 00:22:00 +0000
Date:   Sun, 18 Sep 2022 21:21:58 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: verify signature only for valid responses
Message-ID: <20220919002158.wgta4konh6c4wfjr@suse.de>
References: <20220917020704.25181-1-ematsumiya@suse.de>
 <bf09670b-df76-7fcc-2c8c-8b049f82d41b@talpey.com>
 <20220917162827.g3c32bh62maw7da3@suse.de>
 <3e03b3ec-f733-06b1-3023-592801414ae8@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3e03b3ec-f733-06b1-3023-592801414ae8@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Tom,

On 09/17, Tom Talpey wrote:
<snip>
>Wait, we process the message *before* we check the signature??? Apart
>from inspecting the MID and verifying it's a response to a request we
>made, there isn't a lot to cause such an error. See 3.2.5.1.3.

You're right. By processing I actually meant "parsing" done right after
receive, but even that doesn't have many failure spots.

I found that the mids with STATUS_END_OF_FILE are being discarded,
apparently as per 3.2.5.11:

   If the Status field of the SMB2 header of the response indicates an
   error, the client MUST return the received status code to the calling
   application.

What I found is that mid->callback() (smb2_readv_callback()) was being
called from another thread, so even though the mid had been dequeued by
mid->receive() earlier, smb2_readv_callback() was treating it as a
valid (non-NULL), existing (mid_state == MID_RESPONSE_RECEIVED) mid.

 From this perspective, it makes sense to me to skip the signature
verification when the mid wasn't supposed to be there in the first
place, but if we consider that other messages with status !=
STATUS_SUCCESS have their signatures correctly computed (apparently),
then I'd guess there's something wrong with computing signatures for
STATUS_END_OF_FILE responses.

Sent this just now:
https://lore.kernel.org/linux-cifs/20220918235442.2981-1-ematsumiya@suse.de/T/#u

I'd appreciate your, and Cc'd folks', feedback.


Cheers,

Enzo
