Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DAFC43334
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Jul 2022 20:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiGUUra (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Jul 2022 16:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiGUUr3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Jul 2022 16:47:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F230F8F510
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 13:47:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8A4851FD9B;
        Thu, 21 Jul 2022 20:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658436447; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=73lzAwXRSv0ZF6TFI5a9UkyHtnxsNhLwNEDLV+y9pTw=;
        b=d5CTtu9+FbsqaBl8PWKWw78oPWsO6aVvtie3agg+F58NR8FvwhSygiZ1O28CXPiJeXa3oq
        56TUHDOE/2GNlqD9+Ub4srsbxS7Ibzw8EMB/j+ZTyCHeUWf5Q0QGTpnB7S8SarA9w+VNfd
        oJ4Q2ofPt4FYW5csB+8ynyPlIDuQKP4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658436447;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=73lzAwXRSv0ZF6TFI5a9UkyHtnxsNhLwNEDLV+y9pTw=;
        b=FBNvopexkYuTisW3mxh5K3jyh2I6jqeMnrVWia83TWQuuhDuuHjEovVWMgIqGBnkGx0sx9
        ktlCpG3ddsEyTfCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0C2B513A1B;
        Thu, 21 Jul 2022 20:47:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SOMvMF672WICVQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 21 Jul 2022 20:47:26 +0000
Date:   Thu, 21 Jul 2022 17:47:24 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Subject: Re: [PATCH] smb2: small refactor in smb2_check_message()
Message-ID: <20220721204548.vkuxqyx3qpyruvme@cyberdelia>
References: <20220719173151.12068-1-ematsumiya@suse.de>
 <20220719173151.12068-2-ematsumiya@suse.de>
 <CAH2r5msRkJLLL2my8PstV=MatuY-6dWmqmEZFEuJq-mfRDz7qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5msRkJLLL2my8PstV=MatuY-6dWmqmEZFEuJq-mfRDz7qQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 07/20, Steve French wrote:
>I don't have any objections to this but wondering what prompted the
>patch? Did you see an error logged with ioctls? You mention:
>
>"SMB2_IOCTL, OutputLength and OutputContext are optional and can be zero"

No errors, it's just that when the IOCTL have a 0 len, there can be
several messages printed when debugging. It wasn't that much, but enough
to get me confused several times.

Since they were completely unnecessary, I thought it was ok to not print it.

>And did you want to change the pr_warn_once to a pr_warn on the
>mismatch since you had a case where server was frequently returning
>frame with bad length and you want to debug it?

Yes. I'm always getting a lot of those mismatched length calculations
(Windows Server 2019). After investigating, I found that they were not
real mismatches (see below).

>I am a little worried that it could cause log spam if some server has
>a bug in smb3 response length.

Yes, it could, but as I mention in the commit message, this would only
happen on the *real* mismatched cases, i.e. after passing all the checks
inside the "if (len != calc_len)" check. In those cases, I'd prefer to
really be aware of them then risk it getting lost in dmesg.


Cheers,

Enzo
