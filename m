Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC3CC88CB4
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Jun 2023 13:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbjFLNwl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Jun 2023 09:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjFLNwl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Jun 2023 09:52:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0681B4
        for <linux-cifs@vger.kernel.org>; Mon, 12 Jun 2023 06:52:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 26F371FFAD;
        Mon, 12 Jun 2023 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686577959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dF4f07DxaELi595EPzWOwACPsJH+CJTd/EhWk3jtiB4=;
        b=yAplS98sGy6AgXLmdPjGDF8s5KVkS59CmSKOOn1ZpVFKA04BsuBmQyzH08koi7U8BuDuMh
        vVRdAGZESOIkCE1s7xTqXBKCbQ+sqdx22gGA0N70k5F9lUpFiD432TC1iR4wK5VS3sYANa
        0zP+Nkn80QPHjVxaac7BsgNzQ60Eu0U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686577959;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dF4f07DxaELi595EPzWOwACPsJH+CJTd/EhWk3jtiB4=;
        b=4FihiknBxb9Y8s6vh2ubQbO1759jexz4f/MiniwByd/cKTwFci8JgNmA0b9D70PHui6Jxv
        mxW9f62w3GPZR4DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9FF081357F;
        Mon, 12 Jun 2023 13:52:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BMX+GCYjh2RjDwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 12 Jun 2023 13:52:38 +0000
Date:   Mon, 12 Jun 2023 10:52:14 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, tom@talpey.com,
        Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
Message-ID: <kbimjp6rcxxf6esnwov4q5t6b5tkb7fzxei4pv5jit3qzfu7ud@zp5shjx7ml6h>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

On 06/12, Shyam Prasad N wrote:

... snip ...

>Hi Enzo,
>
>Attached the updated patch. Please review.
>I had to use kernel_getsockname to get socket source details, not
>kernel_getpeername.
>
>Here's what the new output looks like:
>IP addr: dst: 192.168.10.1:445, src: 192.168.10.12:57966

Yeah, I noticed I mixed src/dst when writing the email (was dealing with
exactly this when I wrote it).

>> >         seq_print(m, "IP: src=%pISpc, dest=%pISpc", &server->dstaddr, &src);

^ is also mixed up.

Sorry for the confusion.
