Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC58C04A95
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 16:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbiI1Qbb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 12:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiI1QbJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 12:31:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CC4B5E65
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 09:30:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8D9291F9B0;
        Wed, 28 Sep 2022 16:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664382640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2aWIv7ky1ERS8JOZB4S3wY0BvCb2GkkDbFvNKMA1Ucc=;
        b=T/ltuzFVvu+4x0oigaB5dNM8yOPkqmkXctrlqyzKdbmlJENMRApo9eTkv7Qmcp/Blk32Ja
        2F2bljBuGKlsyYfDbo5SvMcbA9yiB3CsNoaUvlZZ5cSvbkmutGJX6JJcAp2cOudpcN99xL
        8eIPLkjxRLj84gy5pGqq0+dEI7y77qw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664382640;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2aWIv7ky1ERS8JOZB4S3wY0BvCb2GkkDbFvNKMA1Ucc=;
        b=3IuPDHO0Tf3xbOcgqtuMPJL5TPELW7zxsiM+K/OUlpH2Cw4VfMfPxWVYuFLZlt5uTOScgB
        lNhguFHvH6XvZ4DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 107EA13677;
        Wed, 28 Sep 2022 16:30:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3pbyMa92NGO3KgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 28 Sep 2022 16:30:39 +0000
Date:   Wed, 28 Sep 2022 13:30:37 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [RFC PATCH] cifs: fix signature check for error responses
Message-ID: <20220928163037.q5lhvszdguewvwi7@suse.de>
References: <20220922223216.4730-1-ematsumiya@suse.de>
 <2cbf804b-a692-ad45-4ec4-4676f15d48f2@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2cbf804b-a692-ad45-4ec4-4676f15d48f2@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/28, Tom Talpey wrote:
>On 9/22/2022 6:32 PM, Enzo Matsumiya wrote:
>>Hi all,
>>
>>This patch is the (apparent) correct way to fix the issues regarding some
>>messages with invalid signatures. My previous patch
>>https://lore.kernel.org/linux-cifs/20220918235442.2981-1-ematsumiya@suse.de/
>>was wrong because a) it covered up the real issue (*), and b) I could never
>>again "reproduce" the "race" -- I had other patches in place when I tested it,
>>and (thus?) the system memory was not in "pristine" conditions, so it's very
>>likely that there's no race at all.
>>
>>(*) Thanks a lot to Tom Talpey for pointing me to the right direction here.
>>
>>Since it sucks to be wrong twice, I'm sending this one as RFC because I
>>wanted to confirm some things:
>>
>>   1) Can I rely on the fact that status != STATUS_SUCCESS means no variable
>>      data in the message?  I could only infer from the spec, but not really
>>      confirm.
>
>Technically, I think the answer is "no" but practically speaking maybe
>"yes".
>
>Not all errors are actually errors however, e.g. STOPPED_ON_SYMLINK and
>the additional error contexts which accompany it. We definitely don't
>want to skip validation of those.
>
>There's also STATUS_PENDING, but that's special because it isn't actually
>a response, it's just a "hang on I'm busy" that carries no other
>data.
>
>Finally, MS-SMB2 lists a few others in section 2.2.2.2, all of which
>need validation I think.

Sorry, I might have not been clear.  By "variable data" I actually meant
data that's not going to be allocated in the requests' iovs, but rather
in rqst->rq_pages.

The variable buffers that are already expected (by PDU/spec), are AFAICS
always allocated either through cifs*buf_get() or some kmalloc() variant,
i.e. non-HIGHMEM.

async IO, though, is the only place I can see that allocates
rqst->rq_pages through iov_iter_get_pages_alloc2(), which is the source
of my concern, and the reason of my patch.  Particularly, on async read
cases, the page data is pre-allocated with the size we *expect* to
receive/read from the server, but if there's an error in a READ
response, the response itself will contain no/incomplete data in the page
data, but since those pages are allocated, the signature computation will
account for it, and generate a mismatching signature.

I'm running more tests now and I'll make sure to test the other possible
errors in 2.2.2.2.

>>   2) (probably only in async cases) When the signature fails, for whatever
>>      reason, we don't take any action.  This doesn't seem right IMHO,
>>      e.g. if the message is spoofed, we show a warning that the signatures
>>      doesn't match, but I would expect at least for the operation to stop,
>>      or maybe even a complete dis/reconnect.
>
>I don't think so. The spec calls for dropping the message, and after
>all it could have been simple packet corruption. The retries will sort
>it out.
>
>Absolutely positively do not print a message for each received packet,
>good or bad.

For the good messages ok, of course, but for bad? Why not? Otherwise, e.g.,
spotting the misvalidation mentioned above would've taken much longer.

(btw I spotted that misvalidation while debugging my AES-GMAC series,
but the same behaviuour happens with AES-CMAC i.e. in current code)

>>   3) For SMB1, I couldn't really use generic/465 as a real confirmation for
>>      this because it says "O_DIRECT is not supported".  From reading the
>>      code and 'man mount.cifs' I understood that this is supported, so what
>>      gives?  Worth noting that I don't follow/use/test SMB1 too much.
>>      The patch does work for other cases I tried though.
>
>Honestly, I don't think we care. No amount of patching can possibly
>save SMB1.

Ack :)

>Tom.


Cheers,

Enzo

>>I hope someone can address my questions/concerts above, and please let me
>>know if the patch is technically and semantically correct.
>>
>>Patch follows.
>>
>>
>>Enzo
>>
>>--------
>>When verifying a response's signature, the computation will go through
>>the iov buffer (header + response structs) and the over the page data, to
>>verify any dynamic data appended to the message (usually on an SMB2 READ
>>response).
>>
>>When the response is an error, however, specifically on async reads,
>>the page data is allocated before receiving the expected data.  Being
>>"valid" data (from the signature computation POV; non-NULL, >0 pages),
>>it's included in the parsing and generates an invalid signature for the
>>message.
>>
>>Fix this by checking if the status is non-zero, and skip the page data
>>if it is.  The issue happens in all protocol versions, and this fix
>>applies to all.
>>
>>This issue can be observed with xfstests generic/465.
>>
>>Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>>---
>>  fs/cifs/cifsencrypt.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>>diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>>index 46f5718754f9..e3260bb436b3 100644
>>--- a/fs/cifs/cifsencrypt.c
>>+++ b/fs/cifs/cifsencrypt.c
>>@@ -32,15 +32,28 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
>>  	int rc;
>>  	struct kvec *iov = rqst->rq_iov;
>>  	int n_vec = rqst->rq_nvec;
>>+	bool has_error = false;
>>  	/* iov[0] is actual data and not the rfc1002 length for SMB2+ */
>>  	if (!is_smb1(server)) {
>>+		struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
>>+
>>  		if (iov[0].iov_len <= 4)
>>  			return -EIO;
>>+
>>+		if (shdr->Status != 0)
>>+			has_error = true;
>>+
>>  		i = 0;
>>  	} else {
>>+		struct smb_hdr *hdr = (struct smb_hdr *)iov[1].iov_base;
>>+
>>  		if (n_vec < 2 || iov[0].iov_len != 4)
>>  			return -EIO;
>>+
>>+		if (hdr->Status.CifsError != 0)
>>+			has_error = true;
>>+
>>  		i = 1; /* skip rfc1002 length */
>>  	}
>>@@ -61,6 +74,9 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
>>  		}
>>  	}
>>+	if (has_error)
>>+		goto out_final;
>>+
>>  	/* now hash over the rq_pages array */
>>  	for (i = 0; i < rqst->rq_npages; i++) {
>>  		void *kaddr;
>>@@ -81,6 +97,7 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
>>  		kunmap(rqst->rq_pages[i]);
>>  	}
>>+out_final:
>>  	rc = crypto_shash_final(shash, signature);
>>  	if (rc)
>>  		cifs_dbg(VFS, "%s: Could not generate hash\n", __func__);
