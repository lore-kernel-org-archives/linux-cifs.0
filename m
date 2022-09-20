Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECED0C54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 20:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiITUoI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 16:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiITUoH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 16:44:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D717697F
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 13:44:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F115621B1A;
        Tue, 20 Sep 2022 20:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663706643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=To1B4ZxiR1XIDQYb59tidOuSny5oUKSlFto4/i1ssbg=;
        b=hMr9pjuBoG1KOWHZQy4fPYII74uGGP65lax5uPaZ0OXfuk6mnOEDkzzIhZr1jb1FtQd0ie
        3R220pEY+wP8hS1Yfklo95EKmoVGrMAVkGcbY+RpTyrLq22HCEfXp/HVdrHF0apQregltO
        NoN4gUOE9fhBf8S48MfXktnh2MDAweo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663706643;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=To1B4ZxiR1XIDQYb59tidOuSny5oUKSlFto4/i1ssbg=;
        b=5EA0UDE2DdRwfti950gB7IdUl/Xnk0HNDzx8UXKOkAwetQozeqMu1Ga1qzMxqk1bQf+hYL
        lGJZ46AorupR+DAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 65A141346B;
        Tue, 20 Sep 2022 20:44:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2a3RCBMmKmP/KwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 20 Sep 2022 20:44:03 +0000
Date:   Tue, 20 Sep 2022 17:44:00 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: check if mid was deleted in async read callback
Message-ID: <20220920204400.2dqjpoh2wxjtst3m@suse.de>
References: <20220918235442.2981-1-ematsumiya@suse.de>
 <874jx3l8zg.fsf@cjr.nz>
 <CAH2r5mtW=tSu1YtP1xCfDUZ09ykd-ca=Wr=z0QKrH6j2xmD7Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mtW=tSu1YtP1xCfDUZ09ykd-ca=Wr=z0QKrH6j2xmD7Rw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/19, Steve French wrote:
>merged into cifs-2.6.git for-next

Steve, please drop this one, I was wrong :(

I'll send a new patch later today.

>
>On Mon, Sep 19, 2022 at 9:43 AM Paulo Alcantara <pc@cjr.nz> wrote:
>>
>> Enzo Matsumiya <ematsumiya@suse.de> writes:
>>
>> > There's a race when cifs_readv_receive() might dequeue the mid,
>> > and mid->callback(), called from demultiplex thread, will try to
>> > access it to verify the signature before the mid is actually
>> > released/deleted.
>> >
>> > Currently the signature verification fails, but the verification
>> > shouldn't have happened at all because the mid was deleted because
>> > of an error, and hence not really supposed to be passed to
>> > ->callback(). There are no further errors because the mid is
>> > effectivelly gone by the end of the callback.
>> >
>> > This patch checks if the mid doesn't have the MID_DELETED flag set (by
>> > dequeue_mid()) right before trying to verify the signature. According to
>> > my tests, trying to check it earlier, e.g. after the ->receive() call in
>> > cifs_demultiplex_thread, will fail most of the time as dequeue_mid()
>> > might not have been called yet.
>> >
>> > This behaviour can be seen in xfstests generic/465, for example, where
>> > mids with STATUS_END_OF_FILE (-ENODATA) are dequeued and supposed to be
>> > discarded, but instead have their signature computed, but mismatched.
>> >
>> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>> > ---
>> >  fs/cifs/cifssmb.c | 2 +-
>> >  fs/cifs/smb2pdu.c | 2 +-
>> >  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> Good catch!
>>
>> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>
>
>
>-- 
>Thanks,
>
>Steve
