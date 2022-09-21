Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AE4ECAAD8
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Sep 2022 14:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiIUOKQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Sep 2022 10:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiIUOKN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Sep 2022 10:10:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1AF6B142
        for <linux-cifs@vger.kernel.org>; Wed, 21 Sep 2022 07:10:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7ED4F1F38D;
        Wed, 21 Sep 2022 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663769409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=whdiX6yHuTZiQcCorqJDT98gE2KXOMEEDxSA6+6J1cA=;
        b=uYB3XwfdOeGBBoM2UbSgrkJz7XhvZvYISXz56NIljGY2PGGWXw4hblcuDYEM2rYbx64upK
        wq2AH8K2+D1r0RWLEQ0IjaBz4GROKTfzK+W0P6haIHiwNA+KtZraU5zIxTECgBzWxXtH7F
        LWRlKMm0xH49mpibw1D8ZtF5uKXPZc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663769409;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=whdiX6yHuTZiQcCorqJDT98gE2KXOMEEDxSA6+6J1cA=;
        b=Zs76E8z5j08e+dOuymyCJYnt9E4+MxZNRlnYMLLtIesrsFIMbBIx5wD2lr9deNIag3V/cv
        06FHP3EvFSG+XaDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 006BE13A00;
        Wed, 21 Sep 2022 14:10:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vMYnLUAbK2NnTgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 21 Sep 2022 14:10:08 +0000
Date:   Wed, 21 Sep 2022 11:10:06 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        linux-cifs@vger.kernel.org, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: check if mid was deleted in async read callback
Message-ID: <20220921141006.2dzh3vwltutq63mk@suse.de>
References: <20220918235442.2981-1-ematsumiya@suse.de>
 <874jx3l8zg.fsf@cjr.nz>
 <CAH2r5mtW=tSu1YtP1xCfDUZ09ykd-ca=Wr=z0QKrH6j2xmD7Rw@mail.gmail.com>
 <49d7e40f-098b-66b0-d347-522f7c49dc71@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <49d7e40f-098b-66b0-d347-522f7c49dc71@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/20, Tom Talpey wrote:
>I guess I caught up out-of-order, replying to the other thread.
>
>Catching the race is good, but "dequeuing the MID" has nothing to
>do with signing and should not be listed as justification. If
>the message is being processed, e.g. returning the status field,
>then the payload MUST be validated per the processing in 3.2.5.1.3.
>This validation requires only a valid session, and the message itself.

Fully agreed.

>Apparently the code is storing the decryption status in the local
>mid structure. That's the root-cause bug here. The signing validation
>must not be skipped otherwise! Poking holes in security is never a
>good approach. Can the decryption boolean be stored someplace else?

This was not on a encrypted session, only mounted with sign option.
(the decryption process happens in the parent if block of the ->receive()
call, thus, taking a different route)

I think I found the problem. In smb2_readv_callback:

----
struct smb_rqst rqst = { .rq_iov = &rdata->iov[1],
                          .rq_nvec = 1,
                          .rq_pages = rdata->pages,
                          .rq_offset = rdata->page_offset,
                          .rq_npages = rdata->nr_pages,
                          .rq_pagesz = rdata->pagesz,
                          .rq_tailsz = rdata->tailsz };
----

This rqst assembling only considers the success case, where there _is_
data in rdata->pages.  Since those fields in rdata are preset and
->pages pre-allocated in send (cifs_send_async_read), there was never an
"obvious" failure here (e.g. NULL deref).

The signature verification fails because it runs over the iov (SMB2
header + read rsp error struct) *and* the pages, where the page data
is valid from the memory POV (allocated, >0 pages, etc), but it's
certainly not from the signature check POV.

I could confirm this by setting only the iov in rqst in the case of
rdata->result != 0. But I'm still evaluating the best way to go through
this
a) by using rdata->result to choose which data to pass to signature
    check, but
b) without breaking any other read scenarios, and
c) without verifying the same message twice

>Tom.
>
>On 9/20/2022 12:15 AM, Steve French wrote:
>>merged into cifs-2.6.git for-next
>>
>>On Mon, Sep 19, 2022 at 9:43 AM Paulo Alcantara <pc@cjr.nz> wrote:
>>>
>>>Enzo Matsumiya <ematsumiya@suse.de> writes:
>>>
>>>>There's a race when cifs_readv_receive() might dequeue the mid,
>>>>and mid->callback(), called from demultiplex thread, will try to
>>>>access it to verify the signature before the mid is actually
>>>>released/deleted.
>>>>
>>>>Currently the signature verification fails, but the verification
>>>>shouldn't have happened at all because the mid was deleted because
>>>>of an error, and hence not really supposed to be passed to
>>>>->callback(). There are no further errors because the mid is
>>>>effectivelly gone by the end of the callback.
>>>>
>>>>This patch checks if the mid doesn't have the MID_DELETED flag set (by
>>>>dequeue_mid()) right before trying to verify the signature. According to
>>>>my tests, trying to check it earlier, e.g. after the ->receive() call in
>>>>cifs_demultiplex_thread, will fail most of the time as dequeue_mid()
>>>>might not have been called yet.
>>>>
>>>>This behaviour can be seen in xfstests generic/465, for example, where
>>>>mids with STATUS_END_OF_FILE (-ENODATA) are dequeued and supposed to be
>>>>discarded, but instead have their signature computed, but mismatched.
>>>>
>>>>Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>>>>---
>>>>  fs/cifs/cifssmb.c | 2 +-
>>>>  fs/cifs/smb2pdu.c | 2 +-
>>>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>>Good catch!
>>>
>>>Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>

I asked to drop this one because it was the wrong solution, but I think
we'll still need to have a similar check/handling somewhere to prevent a
NULL mid or mid with bogus data from being accessed.

Will report back asap.


Cheers,

Enzo
