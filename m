Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5667C43334
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 16:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbiFIQRW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 12:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiFIQRW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 12:17:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D1755BE
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 09:17:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 82FD21FEB8;
        Thu,  9 Jun 2022 16:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654791439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CBZjp3nZPkVLRgn+fKiqY7sKsEwPbKVEepxzv1qFQsM=;
        b=VLl8LYJ2IAEAuF4yQyWh1KwkS8EtSGh04CwFyk+1Uo6Y0Uzgwr4av3iDtc46Z6Bmdo9B8E
        75dzQCZn+HjNCuVwHNkPAzNXIUGbq24GBrsdD1Or0tk1fecEOrJ+6iy0rjsB6znsrMD0VJ
        f5Jja39Wuyi8gf7e8cVu2/rOETuE+FQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654791439;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CBZjp3nZPkVLRgn+fKiqY7sKsEwPbKVEepxzv1qFQsM=;
        b=vFh+UXkkz93T1Xb9AUYTnn2Dthc7zEsSTHqbh/tw3srbqbFiK95hbAVEDq36TRck/qsooO
        fM0ozfIlYIV3O+Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F11C113456;
        Thu,  9 Jun 2022 16:17:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aPSMKw4domKtIAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 09 Jun 2022 16:17:18 +0000
Date:   Thu, 9 Jun 2022 13:17:16 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH 0/2] Introduce dns_interval procfs setting
Message-ID: <20220609161716.dfhsozj4p76zfznl@cyberdelia>
References: <20220608215444.1216-1-ematsumiya@suse.de>
 <df02056a-3c88-aab3-f90d-2b5ceaa5bd6f@talpey.com>
 <20220609150359.5uioqx4eccfodo6e@cyberdelia>
 <e9cceeb7-ad21-61b8-ed36-ac7820559f07@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e9cceeb7-ad21-61b8-ed36-ac7820559f07@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 06/09, Tom Talpey wrote:
>>I tried to stick to the current behaviour, while also fixing the issue
>>of getting a TTL=0 from key.dns_resolver upcall.
>>
>>A mount option looks indeed better initially, and that was also my
>>initial approach to this. But in a, e.g. multi-domain forest, with
>>multiple DFS targets, the per-mount setting starts to look irrelevant
>>again as well. So I took the "per-client" approach instead.
>
>Ok, I guess. It seems like kicking the can down the road, a little.
>I agree that rearchitecting the DNS cache might be extreme, but many
>distros consider procfs to be a user API, and they'll require it to
>be supported basically forever. That would be unfortunate...

Thanks, I didn't know that. I'll re-work on the patch and take this in
consideration then.


Cheers,

Enzo
