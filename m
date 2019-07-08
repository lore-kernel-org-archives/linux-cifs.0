Return-Path: <SRS0=ZzOu=VF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53FE3C606AF
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Jul 2019 13:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28E8B2086D
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Jul 2019 13:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731264AbfGHNSF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Jul 2019 09:18:05 -0400
Received: from mail.prodrive-technologies.com ([212.61.153.67]:65471 "EHLO
        mail.prodrive-technologies.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727352AbfGHNSF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Jul 2019 09:18:05 -0400
Received: from mail.prodrive-technologies.com (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 5FAB933087_D23428CB;
        Mon,  8 Jul 2019 13:18:04 +0000 (GMT)
Received: from mail.prodrive-technologies.com (exc04.bk.prodrive.nl [10.1.1.213])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.prodrive-technologies.com", Issuer "Prodrive Technologies B.V. OV SSL Issuing CA" (verified OK))
        by mail.prodrive-technologies.com (Sophos Email Appliance) with ESMTPS id C6B4030CFA_D23428BF;
        Mon,  8 Jul 2019 13:18:03 +0000 (GMT)
Received: from [10.10.163.76] (10.10.163.76) by EXC04.bk.prodrive.nl
 (10.1.1.213) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Mon, 8
 Jul 2019 15:18:03 +0200
Subject: Re: Many processes end up in uninterruptible sleep accessing cifs
 mounts
To:     =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>
CC:     Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
References: <684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com>
 <875zojx70t.fsf@suse.com>
 <1fc4f6d0-6cdc-69a5-4359-23484d6bdfc9@prodrive-technologies.com>
 <8736jmxcwi.fsf@suse.com>
 <5d4fd393-9c6c-c407-462e-441cd46bbdd8@prodrive-technologies.com>
 <CAKywueTpgXyFMxveRj6Hm-=vuCC6xh1z0W9bqAFcpCiREe6Vwg@mail.gmail.com>
 <325128ce-6ef7-9a18-a626-ee3505037c2c@prodrive-technologies.com>
 <CAH2r5mtXc+K5AMFFRmvPwyAx1kc2eciDKsHF_Sx2p+sjtYrtCw@mail.gmail.com>
 <49b1529a-6d0e-99cc-112c-fa226ddcab1a@prodrive-technologies.com>
 <875zocwzsj.fsf@suse.com>
From:   Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Organization: Prodrive Technologies
Message-ID: <759d44e9-839b-4cc9-a535-ca17065468d0@prodrive-technologies.com>
Date:   Mon, 8 Jul 2019 15:18:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <875zocwzsj.fsf@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EXC03.bk.prodrive.nl (10.1.1.212) To EXC04.bk.prodrive.nl
 (10.1.1.213)
X-SASI-RCODE: 200
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Aurélien,

On 08-07-2019 13:06, Aurélien Aptel wrote:
> Martijn, can you give a try to the PATCH (v2) I sent?
> 
> I wrote it on top of the 4.20 stable tree. I understand the process to
> apply compile and install is not the easiest one but it would be
> extremely helpful since you can reproduce the issue.

I was able to schedule a reboot some of the servers later this evening.
Writing the patch for 4.20 is much appreciated!

Regards, Martijn

> 
> Cheers,
> 

-- 
Martijn de Gouw
Designer
Prodrive Technologies
Mobile: +31 63 17 76 161
Phone:  +31 40 26 76 200
