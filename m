Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9534C88CB2
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Jun 2023 15:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjFLPaD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239682AbjFLPaA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Jun 2023 11:30:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA855E57
        for <linux-cifs@vger.kernel.org>; Mon, 12 Jun 2023 08:29:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6464122824;
        Mon, 12 Jun 2023 15:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686583798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ihnY9QiZDCn7C+DUAJYynKe4MHu2YYQkgFvwKV0ypjk=;
        b=gAThEswIKP5kH+/YsYUNvxKQ3EzdLz9uxlWzx8ablfmeRPbe8OArbyKQ/nZiPw/72988Bm
        366PbyB87xCjY5mNolseOfOdoAUsaYQso4QzpmTiqSv2WMe9ykrWMBFSaV/NPBmuVqem9T
        z/MdUbVLdRCXcwLSsGnQYZ3Q8pzkOjk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686583798;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ihnY9QiZDCn7C+DUAJYynKe4MHu2YYQkgFvwKV0ypjk=;
        b=tlBXFPs0Sj31xzUjqR4NdsKbX+cRp81xnTnVs0MBCNR0UACuyOaIi7l2MM8Ol6ibbiiiuP
        aEtjyHaji9Y1k0Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DC8A9138EC;
        Mon, 12 Jun 2023 15:29:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iHiyJ/U5h2RkOwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 12 Jun 2023 15:29:57 +0000
Date:   Mon, 12 Jun 2023 12:29:33 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, tom@talpey.com,
        Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
Message-ID: <g6yidp2mk3sseniwodvdz6d3svgq2kt6jzsbuiuh4gb2zmj3g3@yl6cqh37q7bx>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
 <a38028f0fbc7d6abb1f118f110537f21.pc@manguebit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a38028f0fbc7d6abb1f118f110537f21.pc@manguebit.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 06/12, Paulo Alcantara wrote:
>Shyam Prasad N <nspmangalore@gmail.com> writes:
>
>> I had to use kernel_getsockname to get socket source details, not
>> kernel_getpeername.
>
>Why can't you use @server->srcaddr directly?

That's only filled if explicitly passed through srcaddr= mount option
(to bind it later in bind_socket()).

Otherwise, it stays zeroed through @server's lifetime.
