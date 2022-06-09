Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9F9C43334
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 16:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241494AbiFIQQY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 12:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiFIQQX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 12:16:23 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E04455BE
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 09:16:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C0EFF1FE95;
        Thu,  9 Jun 2022 16:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654791378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NLUEE6z115kRmVhUjyKDPwHPmy+Zmqn3f6u5SlhXLSI=;
        b=ZbDvKQPtaGFOIIuR6ZdgY+Vbu9MPjEhLTgpwxXI+1AFSOxtoQ+96PcekhMygCANAxFvWNl
        Rzts1erXB16vKSbZCU16Z/sttvVn4AS203Pv4wyCcMsa+amyJqEjI8MTqTC4zgGzYbMDXb
        WD0QFrchhxjK5ielNThuO73BnpDdyl0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654791378;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NLUEE6z115kRmVhUjyKDPwHPmy+Zmqn3f6u5SlhXLSI=;
        b=9CfDzaDkV+emOx471YAs85/zCrx5mkIyF+hDdmw0SUeYkjUDpnmo2wKmtc6Qka+l6RmOMB
        8rL61nvCLtfuA0AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 424A713456;
        Thu,  9 Jun 2022 16:16:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OTvCAdIcomJIIAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 09 Jun 2022 16:16:18 +0000
Date:   Thu, 9 Jun 2022 13:16:15 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH 0/2] Introduce dns_interval procfs setting
Message-ID: <20220609161615.2g7ktgxa3repbsc4@cyberdelia>
References: <20220608215444.1216-1-ematsumiya@suse.de>
 <87czfhx50m.fsf@cjr.nz>
 <20220609151427.nolyifmbozaoxzzk@cyberdelia>
 <87a6alx3p0.fsf@cjr.nz>
 <20220609153046.pbb6pazfsnaweayv@cyberdelia>
 <877d5px2ej.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <877d5px2ej.fsf@cjr.nz>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 06/09, Paulo Alcantara wrote:
>Enzo Matsumiya <ematsumiya@suse.de> writes:
>
>> Currently, key.dns_resolver uses getaddrinfo() to resolve names, which
>> doesn't contain the TTL for the record, hence *always* returns 0 to cifs.ko.
>> This patch is just a way to provide some flexibility to the user, in
>> case they don't want to use the currently-always-fixed 600s.
>
>It is not limited to key.dns_resolver.  The user is free to choose
>whatever program he/she wants to be upcalled for dns_resolver key.
>
>For instance, some distros might still be using cifs.upcall(8) that
>actually set record TTL, thus making it impossible for the user to
>change default via /proc/fs/cifs/dns_interval.

Ah sorry, I misunderstood.

But this patch isn't supposed to allow the user to change the _default_ TTL
value, but only to give them a chance to change the TTL value *iff* the
upcall returned 0.

In case the upcall returns TTL != 0, dns_resolve_server_name_to_ip()
will use that value instead, which, again, maintains the current behaviour.

But yes, if desired, I can adjust the patch to completely ignore the
TTL value from upcall and manage it by ourselves always, either by
procfs or by mount option.

What do you think?


Cheers,

Enzo
