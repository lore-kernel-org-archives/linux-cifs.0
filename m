Return-Path: <SRS0=xLh5=AN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9CBC433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jul 2020 18:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D3832084C
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jul 2020 18:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgGBSJp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jul 2020 14:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgGBSJp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jul 2020 14:09:45 -0400
Received: from mail.darkrain42.org (o-chul.darkrain42.org [IPv6:2600:3c01::f03c:91ff:fe96:292c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0ADC08C5C1
        for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2020 11:09:44 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature ED25519)
        (Client CN "otters", Issuer "otters" (not verified))
        by o-chul.darkrain42.org (Postfix) with ESMTPS id 7EC4180F1;
        Thu,  2 Jul 2020 11:09:44 -0700 (PDT)
Received: by haley.home.arpa (Postfix, from userid 1000)
        id 1ACAA35B20; Thu,  2 Jul 2020 11:09:44 -0700 (PDT)
Date:   Thu, 2 Jul 2020 11:09:43 -0700
From:   Paul Aurich <paul@darkrain42.org>
To:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: memory leak of auth_key.response in multichannel establishment
Message-ID: <20200702180943.GA3886@haley.home.arpa>
Mail-Followup-To: =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <20200630033452.GA1859435@haley.home.arpa>
 <87r1tvxsrd.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r1tvxsrd.fsf@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

They're the stack trace of where the allocations occurred, for objects that 
are lost.  (I won't pretend to understand kmemleak's algorithm for determining 
lost objects.)

In this case, I was mounting a server with max_channels=4, which generates 
three leak reports (one for the initial session, and two with the same stack 
trace, cifs_try_adding_channels -> cifs_ses_add_channel).  (With 
max_channels=8, I get 7 leak reports)

With

     CONFIG_HAVE_DEBUG_KMEMLEAK=y
     CONFIG_DEBUG_KMEMLEAK=y
     CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE=16000
     CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y

To reproduce:

     - mount -t cifs -o multichannel,max_channels=4,... ...
     - echo scan > /sys/kernel/debug/kmemleak
       or wait long enough for the kmemleak periodic scan to pick it up
     - cat /sys/kernel/debug/kmemleak

~Paul

On 2020-07-01 15:35:34 +0200, Aurélien Aptel wrote:
>Hi Paul,
>
>These stack traces are where printed when the object is lost right?
>
>Cheers,
>-- 
>Aurélien Aptel / SUSE Labs Samba Team
>GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
>SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
>GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
>

