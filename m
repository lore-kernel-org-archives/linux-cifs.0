Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD82EC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 14:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbiI2OS2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 10:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbiI2OS1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 10:18:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E640154478
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 07:18:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 40F061F8B2;
        Thu, 29 Sep 2022 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664461105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K/61HZrO0H/YvVN53cV/6eiVybwaEiNVlsQ6/oO5r3k=;
        b=y8Amp2z6VFqehEZYkGeso5Si9eXaP61JkrBENRfWNEByD21gyYOfzG6A4Kdtb9popmqEEl
        tx9ehV+o5lhPguF78Wr8W2m+SJ7v0ih8QSIIEicNKcpfQcuZkwapkfvhhm3T8Zq+1HbfLK
        ye02OyZf0btWGmpafAkC0j/oFRvkMVQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664461105;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K/61HZrO0H/YvVN53cV/6eiVybwaEiNVlsQ6/oO5r3k=;
        b=BLbddp6CSQ6WkymkNqN0O4d+mmWq0X5AOAmgawOLwxbFe8SSLT86iagZcFqgGONWH1+dr8
        OEzx1EyNPlnndiDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B79E713A71;
        Thu, 29 Sep 2022 14:18:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WAt0HjCpNWMNPgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 14:18:24 +0000
Date:   Thu, 29 Sep 2022 11:18:22 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: Re: [PATCH v3 6/8] cifs: deprecate 'enable_negotiate_signing' module
 param
Message-ID: <20220929141822.zhdeque7ny3zzvfl@suse.de>
References: <20220929015637.14400-1-ematsumiya@suse.de>
 <20220929015637.14400-7-ematsumiya@suse.de>
 <CAH2r5muptvyCo0MYZMv58V+g9DMfSbcWLSKPFSUGd22Lkg458A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5muptvyCo0MYZMv58V+g9DMfSbcWLSKPFSUGd22Lkg458A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/29, Steve French wrote:
>could you fix these minor checkpatch warnings?

Ugh, I ran checkpatch but forgot to fix things, sorry about that. Will
resubmit.


Cheers,

Enzo
