Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9AC9C54EE9
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Sep 2022 14:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiISOoG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Sep 2022 10:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiISOnx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Sep 2022 10:43:53 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A10101F7
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 07:43:50 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 5FBFD7FC6E;
        Mon, 19 Sep 2022 14:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1663598628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G7zlPe5q+exfsnE8d9priQdMyzpzIKHD5wvhoSBBPtw=;
        b=LTUaLOXOfSOCuPwaotMg4aoUfsyEoUejopf+Fi+ZNFCsFQ7nDfwni6cDUoz3lnGViSRWAr
        9S2xm/1S9XymLisUOYdcPtFg+y4OOHN3SLxoSx9ZyXKgJ24FdHtf9RwvLjOERixSphp6Q2
        sPjG+NSi1U8CH8zyf/GDvnDTtDTxEeg0J4SR5KZykBPtu1yac+7PpBdZVVoq4hYYS1dVjd
        qJI2YIGoJL93+7Bbpos1Gt3sL4y0V3YQXZTa8+S3HTcv1hqiT2mCUbyfNeH26/82ADolBc
        ZFxbJKHc1N5VVjqFyVSiRPSQoXE0bdrBwCwxso4rTHYveY/iKnhwbk1fnLIDgw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: check if mid was deleted in async read callback
In-Reply-To: <20220918235442.2981-1-ematsumiya@suse.de>
References: <20220918235442.2981-1-ematsumiya@suse.de>
Date:   Mon, 19 Sep 2022 11:44:19 -0300
Message-ID: <874jx3l8zg.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

> There's a race when cifs_readv_receive() might dequeue the mid,
> and mid->callback(), called from demultiplex thread, will try to
> access it to verify the signature before the mid is actually
> released/deleted.
>
> Currently the signature verification fails, but the verification
> shouldn't have happened at all because the mid was deleted because
> of an error, and hence not really supposed to be passed to
> ->callback(). There are no further errors because the mid is
> effectivelly gone by the end of the callback.
>
> This patch checks if the mid doesn't have the MID_DELETED flag set (by
> dequeue_mid()) right before trying to verify the signature. According to
> my tests, trying to check it earlier, e.g. after the ->receive() call in
> cifs_demultiplex_thread, will fail most of the time as dequeue_mid()
> might not have been called yet.
>
> This behaviour can be seen in xfstests generic/465, for example, where
> mids with STATUS_END_OF_FILE (-ENODATA) are dequeued and supposed to be
> discarded, but instead have their signature computed, but mismatched.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/cifssmb.c | 2 +-
>  fs/cifs/smb2pdu.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Good catch!

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
