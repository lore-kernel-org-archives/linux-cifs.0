Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A42C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Jul 2022 15:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiGWPqT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Jul 2022 11:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbiGWPqT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 23 Jul 2022 11:46:19 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C6312AFF
        for <linux-cifs@vger.kernel.org>; Sat, 23 Jul 2022 08:46:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 901145BF8A;
        Sat, 23 Jul 2022 15:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658591175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7usc1IbAVaQNYVLjfAjsOjqNK0s5aK65jFI8LBjNSdk=;
        b=rhnQO0pa+b05lEd0Hc+e/CZFN4W+pqfGdrVgQjKpw4ihkvt6CdrLUwsl6TbzwFA+/JWi8f
        8DstGwr+tu+YganiEnKKOR8ZE65waqzRZKTDNRCU1XAyEzZLtiSlq5tcIFGA8Z17RbB9Jz
        0PngB/grGY9jYpaZxJyZr3B19sKfTK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658591175;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7usc1IbAVaQNYVLjfAjsOjqNK0s5aK65jFI8LBjNSdk=;
        b=S4uyK2YuxQqasq4ke5D6fRuVSaSGLnY5jg/+x/h9RncjGa/dTn8RKKksDRZOjJ+b17MOZu
        HaTtEIARaPqymUCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0D66B13A92;
        Sat, 23 Jul 2022 15:46:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vpbNL8YX3GL2GgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sat, 23 Jul 2022 15:46:14 +0000
Date:   Sat, 23 Jul 2022 12:46:12 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Subject: Re: [PATCH 2/4] cifs: standardize SPDX header comment
Message-ID: <20220723154612.wje2ob6h5dev7tsl@cyberdelia>
References: <20220722224254.8738-1-ematsumiya@suse.de>
 <20220722224254.8738-2-ematsumiya@suse.de>
 <CAH2r5muegxbG2E0SEYZOMOEei9GOwndOMsTkivATErsQsJ5hmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5muegxbG2E0SEYZOMOEei9GOwndOMsTkivATErsQsJ5hmw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 07/22, Steve French wrote:
>Interesting question whether one format is better than the other but
>"// SPDX ..." is used more frequently.  In the fs directory
>
>// SPDX ...   is used 1255 times
>/* SPDX ... is used 480 times
>and other are used 164 times
>
>Is there any style recommendation on this in kernel Documentation
>directory etc.?

Now that I looked it up, the recommendation [0] is to use "//" for .c
and "/* ... */" for .h, but I followed what I observed from experience.

[0] https://www.kernel.org/doc/html/v5.16/process/license-rules.html

Should I make a v2 following the official recommendation?

