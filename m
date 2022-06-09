Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A079DC43334
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 15:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbiFIPaw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 11:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbiFIPav (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 11:30:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BA4237CC
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 08:30:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C760321F5A;
        Thu,  9 Jun 2022 15:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654788649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c90UNZPdk85s/9QS+0IvfCml4+tfdQWMzK3iSYrBEZ8=;
        b=kKpt+ZpHF5raRTdxOf+ZnTInhBt3UkOhk3kmq2PefR+MvxsUd4ktvVgr9ju4zspVLuXiMn
        IxY96otMJyx8vDkkCtBZ0ZYH7JX5yK8qpse5BkfYBwBT2TNBM3mfuZafJICrV8OIQnBBPb
        kGI3erMPPAAIWpp+64t4FdXteyjvyek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654788649;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c90UNZPdk85s/9QS+0IvfCml4+tfdQWMzK3iSYrBEZ8=;
        b=fB695MS5oxJi+kwi6IXnng3qbWM8igRTU9EptJJUf9vGxP+/RXoTD/1w+CLvbHZr8OoQ4N
        f04vDE3GKuDnTBAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4618813456;
        Thu,  9 Jun 2022 15:30:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ROxqAikSomKQDQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 09 Jun 2022 15:30:49 +0000
Date:   Thu, 9 Jun 2022 12:30:46 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH 0/2] Introduce dns_interval procfs setting
Message-ID: <20220609153046.pbb6pazfsnaweayv@cyberdelia>
References: <20220608215444.1216-1-ematsumiya@suse.de>
 <87czfhx50m.fsf@cjr.nz>
 <20220609151427.nolyifmbozaoxzzk@cyberdelia>
 <87a6alx3p0.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87a6alx3p0.fsf@cjr.nz>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 06/09, Paulo Alcantara wrote:
>Enzo Matsumiya <ematsumiya@suse.de> writes:
>
>> The initial value is the same as before (SMB_DNS_RESOLVE_INTERVAL_DEFAULT, 600s).
>>
>> The user don't need to know a value to be used, unless they know the
>> value the server uses (either manually set by themselves or by some
>> external script) and then they can use that same value for this new
>> dns_interval setting.
>>
>> A very simple example on how one could do it, if there's no desire to
>> use the default 600s:
>>
>> # TTL=$(dig +noall +answer my.server.domain | awk '{ print $2 }')
>> # echo $TTL > /proc/fs/cifs/dns_interval
>
>That's not what I meant.  Sorry if I was unclear.
>
>If the upcalled program sets the record TTL (key's expire time), then
>any values set in /proc/fs/cifs/dns_interval will not work.  The user
>might expect it to work, though.

Exactly.

Currently, key.dns_resolver uses getaddrinfo() to resolve names, which
doesn't contain the TTL for the record, hence *always* returns 0 to cifs.ko.
This patch is just a way to provide some flexibility to the user, in
case they don't want to use the currently-always-fixed 600s.

As we discussed, this is supposed to be fixed in key.dns_resolver, but
my proposed patch for that never got ack'd, or even replied to. I might
try again at some point.


Cheers,

Enzo
