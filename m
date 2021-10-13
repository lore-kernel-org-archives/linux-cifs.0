Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4119C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Oct 2021 16:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCF3160D42
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Oct 2021 16:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhJMQUn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:20:43 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37222 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235372AbhJMQUc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Oct 2021 12:20:32 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 615441FEFC;
        Wed, 13 Oct 2021 16:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634141908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0BOJPdFDTAkL0wTqXMiDKT3k23y8wxMbldPzgicVkiY=;
        b=vmKZTmnAkUZkcTyjnqYoDYEd9b0ZzwiqeDdtdCGRDH+iJPs33qphxbnQ0q8VHvQEMOn6j+
        Ooha1LK6R689QDhkMwt0zCLxxXAMV+Q0Qu9jX8j1A6e8El9hHzL2Jeuqx0hUf1tQ+FFk99
        kaW0R7/ylU6IjJ1W1hg0m7yiwbn5/eg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634141908;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0BOJPdFDTAkL0wTqXMiDKT3k23y8wxMbldPzgicVkiY=;
        b=5pU9TIF9159mf4vAXE8Zj/maxyMeyGUip9BFQEjM0zx84Ecm+VRZ5qUIwMDrwP0UJiBaPF
        vqyXAh6TqNw2z7Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E66F413ED0;
        Wed, 13 Oct 2021 16:18:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3uC4K9MGZ2HGEQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 13 Oct 2021 16:18:27 +0000
Date:   Wed, 13 Oct 2021 13:18:25 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH] ksmbd-tools: update README
Message-ID: <20211013161825.jwkygjjyqpxloedr@cyberdelia>
References: <20211006161442.4724-1-ematsumiya@suse.de>
 <CAKYAXd-NF1VuCoRX54bd7SEBoY0uO+sOf0-mmye_YpP7xyjF0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKYAXd-NF1VuCoRX54bd7SEBoY0uO+sOf0-mmye_YpP7xyjF0A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/08, Namjae Jeon wrote:
>> +##### Stopping and restarting the daemon:
>> +
>> +- Kill user and kernel space daemon
>> +  - `ksmbd.control -s`
>> +- To restart user space daemon
>> +  - `ksmbd.mountd`
>> +- To shut it down
>> +  - `rmmod ksmbd`
>It is unclear to me. ksmbd.mountd is still alive.
>If session is still opening, We need to call "ksmbd.control -s" first
>to kill server(both ksmbd.mountd and ksmbd kernel thread).

Hm I don't understand your concern actually. What is said is that to
both restart and shutdown the server, you need to run "ksmbd.control -s"
before.

Then, to restart you run "ksmbd.mountd" again. To shut it down, run
"rmmod ksmbd".

I'll try coming up with better wording.

>> +		
>ERROR: trailing whitespace
>#263: FILE: README.md:70:
>+^I^I$

Thanks, will fix!


Cheers,

Enzo
