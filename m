Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE51C43334
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 15:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241803AbiFIPEF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 11:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344118AbiFIPEF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 11:04:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD57B1912C5
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 08:04:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5C6BC21D3F;
        Thu,  9 Jun 2022 15:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654787042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hsyK7MiMPwm5+uvoSQLzwg8ZL20pGHFEMUQJNCvxKIQ=;
        b=QBcIMEvzVpcmyQZDYPknXDsUYrDMWo2skQ2THKJb5q7DKrNz7Q8K/4W4Y/K42nvtWgWZhX
        Aft+PT+/e+zCcIU6+oz8FGVP2kHPwIswr3lTW1GowMKjV9GIUtiY2+9bB737bMBgsuApH7
        nSeHeqT93BhZLV8BqvEfz44dfD3y8Oc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654787042;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hsyK7MiMPwm5+uvoSQLzwg8ZL20pGHFEMUQJNCvxKIQ=;
        b=byP/o0uP0mVQwnWzz5nmz9uhfTSHLfCr116M6DcVdTJu3DbBVhdLTZ78869d72I+I6thGM
        dnkFjYm5EiaIspBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C779013A8C;
        Thu,  9 Jun 2022 15:04:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MfQ+IeELomIfAgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 09 Jun 2022 15:04:01 +0000
Date:   Thu, 9 Jun 2022 12:03:59 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH 0/2] Introduce dns_interval procfs setting
Message-ID: <20220609150359.5uioqx4eccfodo6e@cyberdelia>
References: <20220608215444.1216-1-ematsumiya@suse.de>
 <df02056a-3c88-aab3-f90d-2b5ceaa5bd6f@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <df02056a-3c88-aab3-f90d-2b5ceaa5bd6f@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 06/09, Tom Talpey wrote:
>On 6/8/2022 5:54 PM, Enzo Matsumiya wrote:
>>Hi,
>>
>>These 2 patches are a simple way to fix the DNS issue that
>>currently exists in cifs, where the upcall to key.dns_resolver will
>>always return 0 for the record TTL, hence, making the resolve worker
>>always use the default value SMB_DNS_RESOLVE_INTERVAL_DEFAULT
>>(currently 600 seconds).
>>
>>This also makes the new setting `dns_interval' user-configurable via
>>procfs (/proc/fs/cifs/dns_interval).
>>
>>One disadvantage here is that the interval is applied to all hosts
>>resolution. This is still how it works today, because we're always using
>>the default value anyway, but should someday this be fixed, then we can
>>go back to rely on the keys infrastructure to cache each hostname with
>>its own separate TTL.
>
>Curious, why did you choose a procfs global approach? Wouldn't it be
>more appropriate to make this a mount option, so it would be applied
>selectively per-server?

I tried to stick to the current behaviour, while also fixing the issue
of getting a TTL=0 from key.dns_resolver upcall.

A mount option looks indeed better initially, and that was also my
initial approach to this. But in a, e.g. multi-domain forest, with
multiple DFS targets, the per-mount setting starts to look irrelevant
again as well. So I took the "per-client" approach instead.


Cheers,

Enzo
