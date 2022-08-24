Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D332C00140
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 13:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238573AbiHXNzN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Aug 2022 09:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238739AbiHXNys (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Aug 2022 09:54:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803E87E33D
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 06:52:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3B2041FDBC;
        Wed, 24 Aug 2022 13:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661349125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9/7+ml0BE4wOGewkgC9ejp9QRRfTq1X8UtTi24l/7sM=;
        b=baL33oGKXOmPyAo6/LGjBHN8yVtcY1JRjF+YvBEWlf7QggmBIeIXaVJkPiEQCTbyMDdZPo
        8+QYuuwGYn6a0zt0Hy+Oo+BmHgUuCh09QdCjvOs6B2hSn+gmncEV62nLhlh4s5qWLoihAP
        Wo3XQZc9UbVAXtIlpB0buNAr59eQenM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661349125;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9/7+ml0BE4wOGewkgC9ejp9QRRfTq1X8UtTi24l/7sM=;
        b=LZ4rnUi1sr8Jm+0TQ++uiRpikHqZJxVM1dL/BLHd4EM42GsR0Myl64rGnhdlCO7uI/whw+
        Kla/mH04KepaOMDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B5DCC13780;
        Wed, 24 Aug 2022 13:52:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BcoNHwQtBmMwdgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 24 Aug 2022 13:52:04 +0000
Date:   Wed, 24 Aug 2022 10:52:02 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Subject: Re: [PATCH] cifs: fix some memory leak when negotiate/session setup
 fails
Message-ID: <20220824135202.c5psaknd6gtlxh7y@cyberdelia>
References: <20220823142531.9057-1-ematsumiya@suse.de>
 <8735dmj1kj.fsf@cjr.nz>
 <CAH2r5mte6uibVvRomxnX7FuPZ8VPcrF2iNBUtS=qQWRZSkCN_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mte6uibVvRomxnX7FuPZ8VPcrF2iNBUtS=qQWRZSkCN_g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Paulo, Steve,

On 08/24, Steve French wrote:
>It does look like the first of these may fix a real leak
>
>setup_ntlmv2_rsp when called from CIFS_SessSetup doesn't seem to free
>ses->domainName
>
>sesInfoFree does free it but it is not clear whether in all paths
>sesInfoFree is called, but of course if it isn't called we have a much
>worse leak.
>
>Can you doublecheck about the memleak details.
>
>On Tue, Aug 23, 2022 at 12:45 PM Paulo Alcantara <pc@cjr.nz> wrote:
>>
>> Enzo Matsumiya <ematsumiya@suse.de> writes:
>>
>> >
>> > Fix memory leaks from some ses fields when cifs_negotiate_protocol() or
>> > cifs_setup_session() fails in cifs_get_smb_ses().
>> >
>> > A leak from ses->domainName has also been identified in setup_ntlmv2_rsp()
>> > when session setup fails.
>>
>> Those fields are already freed by sesInfoFree().
>>
>> > These has been reported by kmemleak.
>>
>> Could you please include the report in commit message?

Indeed, I was hitting some uncommon path.

This was on a particular branch of mine (i.e. not for-next), and I think
I might have fixed it now(*).

This one can be dropped, I think.


(*) - my branch didn't directly touch that get ses -> negotiate -> setup
path, but only failing on tree connect. So, yes, there might be a bigger
leak involved and I'll try to reproduce it again, and be sure to save
the kmemleak report (which I didn't originally).


Cheers,

Enzo
