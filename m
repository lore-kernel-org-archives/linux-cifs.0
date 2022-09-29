Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E57CC433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 15:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbiI2PRW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 11:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbiI2PRV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 11:17:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F6414F2A3
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 08:17:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 93EF11F855;
        Thu, 29 Sep 2022 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664464639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h3/lO8ZCfAflvc+jiR5da4csZZNVs/3tiopMaLAKLfY=;
        b=NhUvz5XDsyUzEIyw5T+ToNyo6gYRakiEDCr2ZGMxoWjSqJmnAdzcfkRbvpk/dH4BdTet0f
        zVy7vIWFqbeYK5vLmP0NmQ90U0lBIKL4D+jI0EaGceoM0XFVb/8VLJthUUgm0vKDCxH+O/
        fhAv9OsypiW/3iz55TQOxw+6vWA2Oos=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664464639;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h3/lO8ZCfAflvc+jiR5da4csZZNVs/3tiopMaLAKLfY=;
        b=hE84EK72Ang79kMXnLyVyfoc4W/YJbQYizyHTLgfiRxyiBDWB6gupPIZsdBl2gSjmlwfD5
        WqKaqE/2XLmnYzCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 023761348E;
        Thu, 29 Sep 2022 15:17:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Q4qDLf62NWPSWAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 15:17:18 +0000
Date:   Thu, 29 Sep 2022 12:17:16 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com, tom@talpey.com
Subject: Re: [PATCH v3 8/8] cifs: use MAX_CIFS_SMALL_BUFFER_SIZE-8 as padding
 buffer
Message-ID: <20220929151716.ixymn3ggvxougo7e@suse.de>
References: <20220929015637.14400-1-ematsumiya@suse.de>
 <20220929015637.14400-9-ematsumiya@suse.de>
 <c35302ad-af6b-9036-0a41-213c3d23d222@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c35302ad-af6b-9036-0a41-213c3d23d222@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/29, Stefan Metzmacher wrote:
>Am 29.09.22 um 03:56 schrieb Enzo Matsumiya:
>>AES-GMAC is more picky about buffers locality, alignment, and size, so
>>we can't use a stack-allocated buffer as padding (smb2_padding).
>>
>>This commit drops smb2_padding and "reserves" the 8 last bytes of each
>>small buffer, which are slab-allocated, as the padding buffer space.
>>
>>Introduce SMB2_PADDING_BUF(buf) macro to easily grab the padding buffer.
>>For now, only used in smb2_set_next_command().
>>
>>Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>>---
>>  fs/cifs/smb2ops.c | 7 +++++--
>>  fs/cifs/smb2pdu.c | 9 +++++----
>>  fs/cifs/smb2pdu.h | 2 --
>>  3 files changed, 10 insertions(+), 8 deletions(-)
>>
>>diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>>index 22b40d181bba..0b8497e1c747 100644
>>--- a/fs/cifs/smb2ops.c
>>+++ b/fs/cifs/smb2ops.c
>>@@ -2323,7 +2323,10 @@ smb2_set_related(struct smb_rqst *rqst)
>>  	shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
>>  }
>>-char smb2_padding[7] = {0, 0, 0, 0, 0, 0, 0};
>>+/*
>>+ * Use the last 8 bytes of the small buf as the padding buffer, when necessary
>>+ */
>>+#define SMB2_PADDING_BUF(buf) (buf + MAX_CIFS_SMALL_BUFFER_SIZE - 8)
>
>Do we need to expend the size of MAX_CIFS_SMALL_BUFFER_SIZE
>in order to avoid reusing parts of the buffer used otherwise.
>
>(But MAX_CIFS_SMALL_BUFFER_SIZE is confusing magic I don't really
>understand, for me it's really hard to prove we never overflow
>MAX_CIFS_SMALL_BUFFER_SIZE).

Yes, that was one concern I had.  This is (yet another) part of the code
that I see where using hardcoded values hides their meanings and
reasoning, and the comments doesn't really help much understanding it.

So, based on my tests, that region (last 8 bytes) seems to not be ever used.
I didn't bother checking how much is actually being used, but for the
moment I'd say this is fine.

@Steve your clarification on the value for MAX_CIFS_SMALL_BUFFER_SIZE
would be appreciated, I guess.

>
>>  void
>>  smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
>>@@ -2352,7 +2355,7 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
>>  		 * If we do not have encryption then we can just add an extra
>>  		 * iov for the padding.
>>  		 */
>>-		rqst->rq_iov[rqst->rq_nvec].iov_base = smb2_padding;
>>+		rqst->rq_iov[rqst->rq_nvec].iov_base = SMB2_PADDING_BUF(rqst->rq_iov[0].iov_base);
>>  		rqst->rq_iov[rqst->rq_nvec].iov_len = num_padding;
>>  		rqst->rq_nvec++;
>>  		len += num_padding;
>>diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>>index 6c22ead51feb..fca1b580d57d 100644
>>--- a/fs/cifs/smb2pdu.c
>>+++ b/fs/cifs/smb2pdu.c
>>@@ -362,6 +362,9 @@ fill_small_buf(__le16 smb2_command, struct cifs_tcon *tcon,
>>  	/*
>>  	 * smaller than SMALL_BUFFER_SIZE but bigger than fixed area of
>>  	 * largest operations (Create)
>>+	 *
>>+	 * Note that the last 8 bytes of the small buffer are reserved for padding when required
>>+	 * (see SMB2_PADDING_BUF in smb2ops.c)
>>  	 */
>>  	memset(buf, 0, 256);
>>@@ -2993,8 +2996,7 @@ SMB2_open_free(struct smb_rqst *rqst)
>>  	if (rqst && rqst->rq_iov) {
>>  		cifs_small_buf_release(rqst->rq_iov[0].iov_base);
>>  		for (i = 1; i < rqst->rq_nvec; i++)
>>-			if (rqst->rq_iov[i].iov_base != smb2_padding)
>>-				kfree(rqst->rq_iov[i].iov_base);
>>+			kfree(rqst->rq_iov[i].iov_base);
>>  	}
>>  }
>>@@ -3187,8 +3189,7 @@ SMB2_ioctl_free(struct smb_rqst *rqst)
>>  	if (rqst && rqst->rq_iov) {
>>  		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
>>  		for (i = 1; i < rqst->rq_nvec; i++)
>>-			if (rqst->rq_iov[i].iov_base != smb2_padding)
>>-				kfree(rqst->rq_iov[i].iov_base);
>>+			kfree(rqst->rq_iov[i].iov_base);
>
>Don't we need to check against SMB2_PADDING_BUF(rqst->rq_iov[0].iov_base) here
>and avoid passing an invalid pointer to kfree()?

Ah good catch.  Will fix it.


>metze

Cheers,

Enzo
