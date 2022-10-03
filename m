Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8175C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 14:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiJCOxg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 10:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJCOxb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 10:53:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C713A17B
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 07:53:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8507F1F942;
        Mon,  3 Oct 2022 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664808809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UtPJbqUiYvv88Md85hEGuFZBfByl+Xwah9dvDxxRZpA=;
        b=tcyzzSxpPbTOJkwgGdXh1IGI3uz+Jo0dFtzlVfBIp1oaDmPd/C4q7vz990tf0xmGNld8j9
        miFgbXGjp5i/Hpmf+vFCzufX5LYc8P0msSgwGGkEzNLeVOyBAVedyEvkGFKwQg3zd+lvBI
        v/D9Aeg5PAeEbfM7cJYjct3OX95iqew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664808809;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UtPJbqUiYvv88Md85hEGuFZBfByl+Xwah9dvDxxRZpA=;
        b=lC0vbK4Q+9D/1PK3Z9cAUS7RzQfxMJtJnrwhM3xUlbd3x4fI3SCKsK+ohPg1JF/6DDStZv
        x+L8tv178siD7aCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 08E7013522;
        Mon,  3 Oct 2022 14:53:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Rgd8L2j3OmM/cQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 03 Oct 2022 14:53:28 +0000
Date:   Mon, 3 Oct 2022 11:53:26 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][smb311 client] fix oops in smb3_calc_signature
Message-ID: <20221003145326.nx2hjsugeiweb2uy@suse.de>
References: <CAH2r5mtzWgXbod2tdZsRvZuhBZsv=H9Vf2GA3Q_bQe0nHhjfiQ@mail.gmail.com>
 <93bf9e29-32b6-7def-3595-598e59c8c46e@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <93bf9e29-32b6-7def-3595-598e59c8c46e@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/03, Tom Talpey wrote:
>On 10/2/2022 11:54 PM, Steve French wrote:
>>shash was not being initialized in one place in smb3_calc_signature
>>
>>Suggested-by: Enzo Matsumiya <ematsumiya@suse.de>
>>Signed-off-by: Steve French <stfrench@microsoft.com>
>>
>
>I don't see the issue. The shash pointer is initialized in both
>arms of the "if (allocate_crypto)" block.

True, but cifs_alloc_hash() returns 0 if *sdesc is not NULL, so
crypto_shash_setkey() got stack garbage as sdesc.

>But if you do want to add this, them smb2_calc_signature has
>the same code.

True.  Steve will you add it to this patch please?

>Tom.

Cheers,

Enzo
