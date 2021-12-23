Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA3CC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Dec 2021 20:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245098AbhLWUdc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Dec 2021 15:33:32 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:58692 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245049AbhLWUdb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Dec 2021 15:33:31 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CDC74210FC;
        Thu, 23 Dec 2021 20:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640291610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iX1sJKmPUmgZodiyG/FL0wXuEw06S9GFb0HmfJ2z/QM=;
        b=SZkOKcg1jMJ6itDAFyqpXL0L3DTyeJeBKoH3OkfRg0Fe9RQattvjHE0Hy90bEv6rXQocyV
        ICW60V2vTie0pqVRz/X3yjA57sNDuWuDy4ByhuGxVylUZ8uLstp5m/Ra+WbNg/43AJyF7a
        NBbjj5aZF18+5mEcQshT+fvP0SlFTLA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640291610;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iX1sJKmPUmgZodiyG/FL0wXuEw06S9GFb0HmfJ2z/QM=;
        b=dlryhZIdC5RPyMKAlXt+KvMd0goSfvj7CJ5/rK0cGyy56Bub8DYlU82cdQ+lqV6Ra5oWir
        DMgkCoaQeB9o97Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4D25613C84;
        Thu, 23 Dec 2021 20:33:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dGAPBBrdxGHqcwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 23 Dec 2021 20:33:30 +0000
Date:   Thu, 23 Dec 2021 17:33:27 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     David Howells <dhowells@redhat.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: invalidate dns resolver keys after use
Message-ID: <20211223203327.mvzmj3mtlpke3wxn@cyberdelia>
References: <CANT5p=rE+Yr_xybEQ7T+guZXTt4Ddyx0ekhd-t2r89R5Ob5QNA@mail.gmail.com>
 <CANT5p=rxedYesnqitKypJ3X9YU6eANo4zSDid_aKjk7EBCDStg@mail.gmail.com>
 <20211219222214.zetr4d26qqumqgub@cyberdelia>
 <674860.1640248947@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <674860.1640248947@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 12/23, David Howells wrote:
>Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
>> Having such an option is useful. Although, getting the right TTL is
>> important.
>
>That is the real trick as the libc interface you're supposed to use these days
>doesn't give you that information - and, indeed, might draw from a source that
>doesn't have such information.

I'm not sure I understand. I'm using res_nquery() on my to-be-proposed
patch and it works fine.
