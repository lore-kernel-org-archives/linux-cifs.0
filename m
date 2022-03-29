Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96697C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Mar 2022 15:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238433AbiC2PVp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Mar 2022 11:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238389AbiC2PVm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Mar 2022 11:21:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708E07CB02
        for <linux-cifs@vger.kernel.org>; Tue, 29 Mar 2022 08:19:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 22858218F1;
        Tue, 29 Mar 2022 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648567198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ny7euaW/bzjdibnuacG4T6OfL1Jb4OOgx974weJzNTY=;
        b=JB1W5ngp33/BXwjilWVwjxRI1+371xF8AQk4nvP2V0NnZsChKqHFRqa321SUpfmsGvQyyj
        FvTThQr9xfR9Hmb3QLwdJmjNC0UNpxyHJX3eCd2x0MJyl1NwWCg3RXDKOCiuGiigE8etXt
        hJ/mkI1KQR4lp9TyHVL4PbcZnRSCkOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648567198;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ny7euaW/bzjdibnuacG4T6OfL1Jb4OOgx974weJzNTY=;
        b=WPL8GW2X7AvkUkQNgILw00UpWZ9xDjUAZRGgIg+PGgTvueo+HrEsD/1Qn8fUx9BB8MTBjT
        JVVf/azkEtuYupBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7201713AB1;
        Tue, 29 Mar 2022 15:19:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 93DCB50jQ2L6cgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 29 Mar 2022 15:19:57 +0000
Date:   Tue, 29 Mar 2022 12:19:47 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        Bharath SM <bharathsm.hsk@gmail.com>
Subject: Re: Regarding EKEYEXPIRED error during dns_query
Message-ID: <20220329151947.moon56737kryfrh3@cyberdelia>
References: <CANT5p=oU3E6v639bXKQd4ssEvWmAWEDD0qUOixcwONzJyLYgOg@mail.gmail.com>
 <CANT5p=rTosSwc3fer_dYgDFhTuEeeK5rxYxQMK+M2QuZu8fzpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANT5p=rTosSwc3fer_dYgDFhTuEeeK5rxYxQMK+M2QuZu8fzpw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 03/29, Shyam Prasad N wrote:
>David: Do you know if making frequent calls to dns_query can possibly
>prevent expired keys from being cleaned up?

The problem is that the key is being created with a permanent TTL:

2135708b I------     1 perm 1f030000     0     0 keyring   .dns_resolver: 2

But answering your question, if a request to the same key is done before
it expires, yes, it will extend its TTL. But, again, in the current
case, cifs is only doing unnecessary upcalls every 5s, while also
possibly getting outdated cached records.

I sent my patch to fix this as RFC to David, but he probably missed. I'll
re-submit it to a public ML with him on CC.


Cheers,

Enzo
