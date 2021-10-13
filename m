Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE49C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Oct 2021 16:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B448C61053
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Oct 2021 16:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237018AbhJMQ0v (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:26:51 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37720 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237406AbhJMQ0s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Oct 2021 12:26:48 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D97FB21A2A;
        Wed, 13 Oct 2021 16:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634142284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ceaw2yiKCsZwykFk+YqWCeVWz0lR3L3OQ9udsk+Ykkw=;
        b=JxJSVydUTvcSaJO+LGdtBxeesJ8UiSOvNB0hJH8kO5ZCxZUpnXyrRmhWk9BZIV9NOkDWZA
        nBPBREGmXWgYrVuus7PVenKHj/8n1OfbMsUHjPourJIIKJ4qjt/MD1GU7IKqFKJaemq05P
        F1ajh+Kc5VJ21OJenjppplR4vWtCnyM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634142284;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ceaw2yiKCsZwykFk+YqWCeVWz0lR3L3OQ9udsk+Ykkw=;
        b=f3oZENNBufyhxCqfSHcA0arwTr8AQoTlxc32cGHC5OP++kZCoE5nUdaellrx8mPFYSDKGU
        AmMg3fP6LbPIQqBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6A0D213D04;
        Wed, 13 Oct 2021 16:24:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id p6ywDUwIZ2HhFAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 13 Oct 2021 16:24:44 +0000
Date:   Wed, 13 Oct 2021 13:24:42 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH] ksmbd-tools: change default db file name to users.db
Message-ID: <20211013162442.fnuztfdrhf2efq6j@cyberdelia>
References: <20211006161331.4510-1-ematsumiya@suse.de>
 <CAKYAXd_WozbzSy-cVrpiMKN1a6WWa8gGSWBS8f6XJpWuJaXQpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKYAXd_WozbzSy-cVrpiMKN1a6WWa8gGSWBS8f6XJpWuJaXQpg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/08, Namjae Jeon wrote:
>Okay. When existing users upgrade ksmbd-tools, the ksmbdpwd.db file
>remains as the garbage and the user account setting must also be
>reset. How do you usually deal with this? If there is old db file, do
>we need to add code to rename it?

Thanks, I haven't thought about this TBH.

Don't you think it's better to just open and user ksmbdpwd.db and warn the
user about this change? I mean, instead of renaming the file (which can be
too intrusive IMHO).

If anyone has a better idea, please let me know.


Cheers,

Enzo
