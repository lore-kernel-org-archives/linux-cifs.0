Return-Path: <SRS0=zgNb=YW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B549DCA9EAE
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Oct 2019 18:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FF58208E3
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Oct 2019 18:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfJ2SiF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Oct 2019 14:38:05 -0400
Received: from mail.prodrive-technologies.com ([212.61.153.67]:61810 "EHLO
        mail.prodrive-technologies.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725962AbfJ2SiF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 29 Oct 2019 14:38:05 -0400
Received: from mail.prodrive-technologies.com (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id A3A6232EC4_DB8870AB;
        Tue, 29 Oct 2019 18:38:02 +0000 (GMT)
Received: from mail.prodrive-technologies.com (exc04.bk.prodrive.nl [10.1.1.213])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.prodrive-technologies.com", Issuer "Prodrive Technologies B.V. OV SSL Issuing CA" (verified OK))
        by mail.prodrive-technologies.com (Sophos Email Appliance) with ESMTPS id 34EEC3048E_DB8870AF;
        Tue, 29 Oct 2019 18:38:02 +0000 (GMT)
Received: from [10.10.240.93] (10.1.249.1) by EXC04.bk.prodrive.nl
 (10.1.1.213) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1779.2; Tue, 29
 Oct 2019 19:38:01 +0100
Subject: Re: Kernel hangs in cifs_reconnect
To:     Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        <linux-cifs@vger.kernel.org>
References: <56d13db4-62ed-99c0-90b8-bb332143cece@prodrive-technologies.com>
 <871rveaurv.fsf@suse.com> <87a7a2ynxg.fsf@cjr.nz>
 <68a58b8e-3cab-093b-3098-6ee4a6dd3117@prodrive-technologies.com>
 <9c5eeb76-7895-5938-355f-f5d43c5affe5@prodrive-technologies.com>
 <87pnif4nfd.fsf@cjr.nz>
From:   Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Organization: Prodrive Technologies
Message-ID: <d677bf01-422a-92b7-6c44-dd858a3212b2@prodrive-technologies.com>
Date:   Tue, 29 Oct 2019 19:38:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87pnif4nfd.fsf@cjr.nz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EXC03.bk.prodrive.nl (10.1.1.212) To EXC04.bk.prodrive.nl
 (10.1.1.213)
X-SASI-RCODE: 200
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Paulo

On 29-10-2019 15:49, Paulo Alcantara wrote:
> Hi Martijn,
> 
> Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
> 
>> Anybody any idea on what goes wrong here?
> 
> Looks like an use-after-free bug in cifs_reconnect(). cifs superblock
> gets freed due to automount expiration and then we dereference it in
> dfs_cache_noreq_find().
> 
>> Is any of the recently posted patches related to my issue, because I'm
>> more that willing to test out patches if needed.
> 
> Could you please test it again with below patch?

It's running the same version+your patch now, will let you know within a 
couple of days!

Thanks, Martijn

> 
> cheers,
> Paulo
> 

-- 
Martijn de Gouw
Designer
Prodrive Technologies
Mobile: +31 63 17 76 161
Phone:  +31 40 26 76 200
