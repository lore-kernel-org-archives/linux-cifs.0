Return-Path: <SRS0=jgI2=DY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3CBC433DF
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Oct 2020 17:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 454A02074A
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Oct 2020 17:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438702AbgJQRI4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 17 Oct 2020 13:08:56 -0400
Received: from p3plsmtpa06-08.prod.phx3.secureserver.net ([173.201.192.109]:59152
        "EHLO p3plsmtpa06-08.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438701AbgJQRI4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 17 Oct 2020 13:08:56 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id TphPkC9IANK4ETphPkvspD; Sat, 17 Oct 2020 10:08:55 -0700
X-CMAE-Analysis: v=2.3 cv=dsSl9Go4 c=1 sm=1 tr=0
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=yMhMjlubAAAA:8 a=883P8pyGA35RRyZGnKIA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH][SMB3.1.1] do not fail if no encryption required when
 server doesn't support encryption
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
References: <CAH2r5mv_0rLQF=npjc4CVJBDhsc8Eu_sJtY6xUDbBXs7aYhSzA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <5280e8f2-0c9a-c82c-5e5e-9b2d67888da4@talpey.com>
Date:   Sat, 17 Oct 2020 13:08:55 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5mv_0rLQF=npjc4CVJBDhsc8Eu_sJtY6xUDbBXs7aYhSzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfB0sixxjN0dIxfHsPZK/HodR0Gyeyx9gSgw+pexf1atg1pYmXvV7kr8KrT5fAw3Vll2Px3GWcYcB62pv6UsNXZ3i3PxWs3nprS3cl8ycfSrpLWJx3eSJ
 UCWLswix7j0sAiTokfneow0rtNkSCkxg6Lxdf1g8a+nbC9ht87PavYSUOlKbgzB/DmBXDFmaiYGCWmLpj7QQlVpghhyXoM7MNz19/7Ufaqqkk+FsJUqxe4TQ
 JbhaUECXcTdLeNA89RM9A0h0Bbimgt3FEUPsDey/EHI=
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/17/2020 5:03 AM, Steve French wrote:
>      There are cases where the server can return a cipher type of 0 and
>      it not be an error. For example, if server only supported AES256_CCM
>      (very unlikely) or server supported no encryption types or

It seems me that the simpler statement is that there are
no ciphers supported in common between client and server.

>      had all disabled. In those cases encryption would not be supported,
>      but that can be ok if the client did not require encryption on mount.
> 
>      In the case in which mount requested encryption ("seal" on mount)

I'm confused. Doesn't "seal" mean signing?

Tom.

>      then checks later on during tree connection will return the proper
>      rc, but if seal was not requested by client, since server is allowed
>      to return 0 to indicate no supported cipher, we should not fail mount.
> 
>      Reported-by: Pavel Shilovsky <pshilov@microsoft.com>
>      Signed-off-by: Steve French <stfrench@microsoft.com>
> 
> 
