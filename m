Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A8EC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 15:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240876AbiFIPOf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 11:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343959AbiFIPOd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 11:14:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D8FC038D
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 08:14:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E67D21FEA5;
        Thu,  9 Jun 2022 15:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654787670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ieBnxT4vwycAoHtmqE7TzMgYnpfATXGblh1IkU4nq98=;
        b=dB/V0MyrwlLxXFSKaDl+NWODmz53L0OjsdVV6b/m6+qH/2yElnfZ6YtFhuer9zQkkais8g
        gFshOLfKZthbeyUJG0OIkWzm5mUaSGvVyoDUCeACp3598YJQQfrSiIP7x/pqYHwtke0GJM
        pxBDOB1RH61/bZvPvMsWw37iaXUSzp0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654787670;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ieBnxT4vwycAoHtmqE7TzMgYnpfATXGblh1IkU4nq98=;
        b=qGJcEbSH15onkwqC5jonLNb9Hun6xybSm//pJXXmjBh3801ZVcPYOxeQqZOpFpUHPqSuzX
        +wD+KIvtA43Li+AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6444113A8C;
        Thu,  9 Jun 2022 15:14:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sEKmCVYOomKlBgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 09 Jun 2022 15:14:30 +0000
Date:   Thu, 9 Jun 2022 12:14:27 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH 0/2] Introduce dns_interval procfs setting
Message-ID: <20220609151427.nolyifmbozaoxzzk@cyberdelia>
References: <20220608215444.1216-1-ematsumiya@suse.de>
 <87czfhx50m.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87czfhx50m.fsf@cjr.nz>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Paulo,

On 06/09, Paulo Alcantara wrote:
>Hi Enzo,
>
>Enzo Matsumiya <ematsumiya@suse.de> writes:
>
>> These 2 patches are a simple way to fix the DNS issue that
>> currently exists in cifs, where the upcall to key.dns_resolver will
>> always return 0 for the record TTL, hence, making the resolve worker
>> always use the default value SMB_DNS_RESOLVE_INTERVAL_DEFAULT
>> (currently 600 seconds).
>>
>> This also makes the new setting `dns_interval' user-configurable via
>> procfs (/proc/fs/cifs/dns_interval).
>
>How is the user supposed to know which TTL value will be used?  If the
>expire time is set by either key.dns_resolver or any other program used
>for dns_resolver key, the above setting would no longer work and users
>might get confused.

The initial value is the same as before (SMB_DNS_RESOLVE_INTERVAL_DEFAULT, 600s).

The user don't need to know a value to be used, unless they know the
value the server uses (either manually set by themselves or by some
external script) and then they can use that same value for this new
dns_interval setting.

A very simple example on how one could do it, if there's no desire to
use the default 600s:

# TTL=$(dig +noall +answer my.server.domain | awk '{ print $2 }')
# echo $TTL > /proc/fs/cifs/dns_interval


Cheers,

Enzo
