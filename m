Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF61C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Dec 2021 15:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhLOPAN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Dec 2021 10:00:13 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:43554 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhLOPAM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Dec 2021 10:00:12 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C22D41F387;
        Wed, 15 Dec 2021 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639580411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UjHU9eeARh2nsvFFi8bFZ0PXwreU2H+07/gPf3/32Y0=;
        b=QOimXr3b4nzClydgVlLZKrZk9idiEqTala8HwyLdgQX0rLFucH+ovKrCOhKNJ+a6n5V0Ac
        bok/EqPooRNTYF2L6F3E/L7OdqLq8yNHLWVQy3nYOrMxfaOI6LgXMZ5/lNJf+jmjmu8UzS
        A5NsP8+eb9UBN+rNklnYWF9SKcfh738=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639580411;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UjHU9eeARh2nsvFFi8bFZ0PXwreU2H+07/gPf3/32Y0=;
        b=xqOldk1vxUbRIw0bgIqzZBlplK8yxzrYDR3fdGsLbFOnsH1zx86T2nCVC7/cdJoaQ2x/SC
        CrrAJkB+G2qyBaCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 443681330B;
        Wed, 15 Dec 2021 15:00:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /6NIAvsCumHyeAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 15 Dec 2021 15:00:11 +0000
Date:   Wed, 15 Dec 2021 12:00:08 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>
Subject: Re: [RFC] Unify all programs into a single 'ksmbdctl' binary
Message-ID: <20211215150008.u26snbaml5amlaep@cyberdelia>
References: <20211130184710.r7dzzfhak4w3eoi6@cyberdelia>
 <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

On 12/01, Namjae Jeon wrote:
>2021-12-01 3:47 GMT+09:00, Enzo Matsumiya <ematsumiya@suse.de>:
>> Hi Namjae, list,
>Hi Enzo,
>
>First, Thanks for your work!
>Cc: other maintainers.
>
>>
>> I've been working on the unification of all ksmbd-tools programs into a
>> single 'ksmbdctl' binary, and I would like to invite everyone to test
>> and/or provide me feedback on the implementation.
>While checking this out, I'd love to hear from other maintainers.
>>
>> Since this a big-ish refactor, for now I'm sharing the code via my
>> GitHub repo:
>>
>> https://github.com/ematsumiya/ksmbd-tools/tree/ksmbdctl
>>
>> I can split it into smaller commits later on, if approved for merge.
>Great.
>>
>> Commit message below, for a better explanation.
>I will check it and give feedback soon.
>Thanks!

Any feedback on this proposal? Should I focus on polishing + splitting
into meaningful commits?


Cheers,

Enzo
