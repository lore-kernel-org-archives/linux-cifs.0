Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70522ECAAD3
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Sep 2022 16:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIQQ2d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 17 Sep 2022 12:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiIQQ2d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 17 Sep 2022 12:28:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B706D2DA83
        for <linux-cifs@vger.kernel.org>; Sat, 17 Sep 2022 09:28:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 27054227A9;
        Sat, 17 Sep 2022 16:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663432110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M/ll+t43epq9c5qP7HiGlzxOc9FvunP+IFz5r+N6WvQ=;
        b=zI3zJfpXqiLiTdZkZAJX6OrLsptNuCRhhSUnEPyRvV0ZS/yALiU6eGgg0gP0iQsDCgCRhe
        bElzdyZ99+y21vXDOu4eEJJ6Jc5hauOCyjGS7iq/ihU18k7n1nFr/l9U3XqEoL17jLyxzr
        SLzmTMlC5aFrI0TfI8+pcHItGBUBPz4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663432110;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M/ll+t43epq9c5qP7HiGlzxOc9FvunP+IFz5r+N6WvQ=;
        b=V8wllk3NoFp9y88hEmoLjazHeXn+2Iw5AuhVP2WBC61MugC91AQTlGpTRv83znbJtu3KA2
        Qr1lX72w+oyswGBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9BCE513A49;
        Sat, 17 Sep 2022 16:28:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id r+93F631JWNGLwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sat, 17 Sep 2022 16:28:29 +0000
Date:   Sat, 17 Sep 2022 13:28:27 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: verify signature only for valid responses
Message-ID: <20220917162827.g3c32bh62maw7da3@suse.de>
References: <20220917020704.25181-1-ematsumiya@suse.de>
 <bf09670b-df76-7fcc-2c8c-8b049f82d41b@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bf09670b-df76-7fcc-2c8c-8b049f82d41b@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/17, Tom Talpey wrote:
>On 9/16/2022 10:07 PM, Enzo Matsumiya wrote:
>>The signature check will always fail for a response with SMB2
>>Status == STATUS_END_OF_FILE, so skip the verification of those.
>
>Can you elaborate on this assertion? I don't see this as a protocol
>requirement:
>
>  3.2.5.1.3 Verifying the Signature
>    The client MUST skip the processing in this section if any of the
>    following is TRUE:
>    - Client implements the SMB 3.x dialect family and decryption in
>      section 3.2.5.1.1.1 succeeds
>    - MessageId is 0xFFFFFFFFFFFFFFFF
>    - Status in the SMB2 header is STATUS_PENDING
>    [goes on to discuss action if session not found, etc]

Yeah I didn't find anything in the spec either. I woke up this morning
thinking about this actually, and it might actually be a miscalculation
on our side. My initial assumption, and debugging target now, is the
1-byte cropping done on some odd-sized structs, but I haven't deepened
on that so far.

I'll reply back with my findings later.

>>Also, in async IO, it doesn't make sense to verify the signature
>>of an unsuccessful read (rdata->result != 0), as the data is
>>probably corrupt/inconsistent/incomplete. Verify only the responses
>>of successful reads.
>
>Same question. Why would we ever want to selectively skip signing
>verification? Signing protects against corrupted SMB headers, MITM,
>etc etc.

The problem here is actually different because rdata->result can
contain an internal (kernel) error code when an underlying problem
occurred (think EIO, EINTR, ECONNABORTED (not sure if possible this one),
ENOMEM maybe?). But in between "mid set with MID_RESPONSE_RECEIVED state"
and "verify the signature", the SMB2 header/message itself might be
correct/valid, but our internal processing failed somewhere, so, the
way I see it, computing the signature for such cases adds overhead and
could (*) cover up the original internal error.

(*) This actually brings to another inconsistency I'm currently looking at:

          switch (mid->mid_state) {
          case MID_RESPONSE_RECEIVED:
                  credits.value = le16_to_cpu(shdr->CreditRequest);
                  credits.instance = server->reconnect_instance;
                  /* check signature only if read was successful */
                  if (server->sign && !mid->decrypted && rdata->result == 0) {
   rc is local >>>>       int rc;

                          rc = smb2_verify_signature(&rqst, server);
                          if (rc)
                                  cifs_tcon_dbg(VFS, "SMB signature verification returned error = %d\n",
                                           rc);
   and never acted upon >>>
                  }
                  /* FIXME: should this be counted toward the initiating task? */
                  task_io_account_read(rdata->got_bytes);
                  cifs_stats_bytes_read(tcon, rdata->got_bytes);
                  break;
	}

See, the return value of smb2_verify_signature() is never (aside from
printing the error message) checked, used, or acted upon. So, even if 
server->ignore_signature is false (default), an invalid signature is
never accounted for (regardless if the message is integral or a
miscalculation on our side). Where, again IMO, the correct action would
be to discard the mid and cancel the operation, as the data could be,
intentionally or not, corrupted.

Thoughts?

>Tom.

Cheers,

Enzo

>>Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>>---
>>  fs/cifs/smb2pdu.c       | 4 ++--
>>  fs/cifs/smb2transport.c | 1 +
>>  2 files changed, 3 insertions(+), 2 deletions(-)
>>
>>diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>>index 6352ab32c7e7..9ae25ba909f5 100644
>>--- a/fs/cifs/smb2pdu.c
>>+++ b/fs/cifs/smb2pdu.c
>>@@ -4144,8 +4144,8 @@ smb2_readv_callback(struct mid_q_entry *mid)
>>  	case MID_RESPONSE_RECEIVED:
>>  		credits.value = le16_to_cpu(shdr->CreditRequest);
>>  		credits.instance = server->reconnect_instance;
>>-		/* result already set, check signature */
>>-		if (server->sign && !mid->decrypted) {
>>+		/* check signature only if read was successful */
>>+		if (server->sign && !mid->decrypted && rdata->result == 0) {
>>  			int rc;
>>  			rc = smb2_verify_signature(&rqst, server);
>>diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
>>index 1a5fc3314dbf..37c7ed2f1984 100644
>>--- a/fs/cifs/smb2transport.c
>>+++ b/fs/cifs/smb2transport.c
>>@@ -668,6 +668,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>>  	if ((shdr->Command == SMB2_NEGOTIATE) ||
>>  	    (shdr->Command == SMB2_SESSION_SETUP) ||
>>  	    (shdr->Command == SMB2_OPLOCK_BREAK) ||
>>+	    (shdr->Status == STATUS_END_OF_FILE) ||
>>  	    server->ignore_signature ||
>>  	    (!server->session_estab))
>>  		return 0;
