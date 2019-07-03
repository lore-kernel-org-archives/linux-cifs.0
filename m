Return-Path: <SRS0=Wa1n=VA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE0EC0650E
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 18:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 187192080C
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 18:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfGCSVE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Jul 2019 14:21:04 -0400
Received: from mail.prodrive-technologies.com ([212.61.153.67]:49241 "EHLO
        mail.prodrive-technologies.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbfGCSVE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Jul 2019 14:21:04 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jul 2019 14:21:03 EDT
Received: from mail.prodrive-technologies.com (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 30BF7330A2_D1CEFF2B
        for <linux-cifs@vger.kernel.org>; Wed,  3 Jul 2019 18:12:02 +0000 (GMT)
Received: from mail.prodrive-technologies.com (exc03.bk.prodrive.nl [10.1.1.212])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.prodrive-technologies.com", Issuer "Prodrive Technologies B.V. OV SSL Issuing CA" (verified OK))
        by mail.prodrive-technologies.com (Sophos Email Appliance) with ESMTPS id 156E731064_D1CEFF2F
        for <linux-cifs@vger.kernel.org>; Wed,  3 Jul 2019 18:12:02 +0000 (GMT)
Received: from [10.10.164.15] (10.10.164.15) by EXC03.bk.prodrive.nl
 (10.1.1.212) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Wed, 3
 Jul 2019 20:12:01 +0200
To:     <linux-cifs@vger.kernel.org>
From:   Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Subject: Many processes end up in uninterruptible sleep accessing cifs mounts
Organization: Prodrive Technologies
Message-ID: <684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com>
Date:   Wed, 3 Jul 2019 20:12:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EXC03.bk.prodrive.nl (10.1.1.212) To EXC03.bk.prodrive.nl
 (10.1.1.212)
X-SASI-RCODE: 200
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

On our production servers, we have a lot of issues with cifs mounts.
All mounts are mounted via the dfs shares on our domain controller.
We have mounts using sec=krb5, sec=ntlmssp and sec=krb5,multiuser

All mounts are vers=3.0.

One of the symptoms is that our monitoring system complains about not 
being able to stat() every now and then, the next scraping cycle, stat() 
works again. Even when the mounts are not accesses at all.

Also, lot of applications get stuck on either accessing data on the 
mounts, or performing stat() like operations on the mounts.

For us, the worst part is that applications end up in 'D'. The number of 
'D' processes pile up really quickly, blocking users from performing 
their work.

We are running Linux 4.20.17 SMP PREEMPT on all machines. We tried 
upgrading to > 5.x, but caused even more problems and kernel hangs.

I do not really have a clue where to start debugging. I enabled kernel 
debug options suggested on the wiki, but the amount of logging is 
immense now.

Can you provide any pointers where to look or start debugging?
Or any help on how to kill those D processes and get our Linux servers 
stable again?

Regards, Martijn de Gouw
-- 
Martijn de Gouw
Designer
Prodrive Technologies
Mobile: +31 63 17 76 161
Phone:  +31 40 26 76 200
