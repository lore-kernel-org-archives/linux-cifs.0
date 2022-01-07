Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70DEC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jan 2022 22:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiAGWq2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jan 2022 17:46:28 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:48372 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiAGWq2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jan 2022 17:46:28 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9A9201F388;
        Fri,  7 Jan 2022 22:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641595586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3IFcHqJyIw2u2G8/u0mVo9GltSvCJxoIKI8svhxeqCY=;
        b=wAfMw4yv93uML4c/FqtF39Ne2IIxtLdHUw3Yq0XRzJVfPNNDgAX2w3L9mFmkWtsCf6EkHX
        hrG8fZWxoIdpmNmYgtjfqCqnk5CNAt16aBeGxYFp+/18zrgr5ZzHk2fABNw8eZfQEyTOUu
        gP7J6iaVJ2J6HnCE6GppHZbWjfKlSNU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641595586;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3IFcHqJyIw2u2G8/u0mVo9GltSvCJxoIKI8svhxeqCY=;
        b=KR3WoYc0TkQFG7ltXfKQpAScdPP+WF0PT6MaAcE0k2It3BxO10OjtB7YYAuKX/pkIEyNE5
        SgFLxotkbHJU4fBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2933813D42;
        Fri,  7 Jan 2022 22:46:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SK5rOcHC2GEQMAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 07 Jan 2022 22:46:25 +0000
Date:   Fri, 7 Jan 2022 19:46:23 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Subject: Re: SMB1 regression with multichannel patches in for-next
Message-ID: <20220107224623.gmhcvn7h2xwzo6gk@cyberdelia>
References: <CAH2r5msWYcefntP4Dks69W+Oq3DKc8qHp5mow07g49TN7fV50w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5msWYcefntP4Dks69W+Oq3DKc8qHp5mow07g49TN7fV50w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 01/07, Steve French wrote:
>but failed for SMB1 related tests in the DFS test group when run with
>the next patch: 220c5bc25d87 cifs: take cifs_tcp_ses_lock for status
>checks
>
>http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/3/builds/136
>
>Let me know if you spot anything obvious wrong with that patch.

'reconnect' is uninitialized (stack junk == not false). Easily
reproducible.

I'm sending a patch for this now.


Cheers,

Enzo
