Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE0BC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 19:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39B9361242
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 19:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhKETDH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Nov 2021 15:03:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52802 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhKETDG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Nov 2021 15:03:06 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 23F3E1FD36;
        Fri,  5 Nov 2021 19:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636138826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wH0HBOkY1UWzlj6TK34y5JOdMuGly26P7Qcm8i8hv7c=;
        b=TL0NjGyP7FgWRfMvrPDdTGlU3dQ40B9+wZ2og1sVYco9xdsarlnYlE1+xkdoKB4vOHgWaI
        CJl0plaXeiHwTjfsvIcs4NXEyJoNyVNAlTsVkbyx1nbZCiiLchRP7KYknyRV2rvdwM0ol+
        LRzeo9XDYlNKVSDMEtzk1U7x5NI4HoQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636138826;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wH0HBOkY1UWzlj6TK34y5JOdMuGly26P7Qcm8i8hv7c=;
        b=ZJFmxyC2y0OCaE/dLOqZ4FXWP3NL7RJEKdcmc49DF6KGIzmQduTOi/oWXm8rvWZcH8UvHA
        fasTvBV2cM+uDPCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ABD7C1401F;
        Fri,  5 Nov 2021 19:00:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6EpLHUl/hWHkAwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 05 Nov 2021 19:00:25 +0000
Date:   Fri, 5 Nov 2021 16:00:23 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Guillaume Castagnino <casta@xwing.info>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] ksmbd-tools: fix unit file
Message-ID: <20211105185633.emeaioitnd6aqfgp@cyberdelia>
References: <20211103162030.183975-1-casta@xwing.info>
 <CAKYAXd8vugZ3JrtteYRWvAr-Fqk8LAM59cVv33QhCiKM6h4Shw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKYAXd8vugZ3JrtteYRWvAr-Fqk8LAM59cVv33QhCiKM6h4Shw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 11/04, Namjae Jeon wrote:
>2021-11-04 1:20 GMT+09:00, Guillaume Castagnino <casta@xwing.info>:
>Cc: Enzo.
>
>I will add the below description in patch header.
>
>"Shell logic must be enclosed in shell subprocess, systemd cannot
>handle it directly, so reload will fail."
>
>> Signed-off-by: Guillaume Castagnino <casta@xwing.info>
>I will apply this patch, Enzo, Let me know if you have other opinion.

My bad, that's the right way. Please apply it.

>Thanks!
>> ---
>>  ksmbd.service | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/ksmbd.service b/ksmbd.service
>> index 5717177..3309fa9 100644
>> --- a/ksmbd.service
>> +++ b/ksmbd.service
>> @@ -10,7 +10,7 @@ Group=root
>>  RemainAfterExit=yes
>>  ExecStartPre=-/sbin/modprobe ksmbd
>>  ExecStart=/sbin/ksmbd.mountd -s
>> -ExecReload=/sbin/ksmbd.control -s && /sbin/ksmbd.mountd
>> +ExecReload=/bin/sh -c '/sbin/ksmbd.control -s && /sbin/ksmbd.mountd -s'
>>  ExecStop=/sbin/ksmbd.control -s
>>
>>  [Install]
>> --
>> 2.33.1

Cheers,

Enzo
