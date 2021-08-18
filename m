Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F13C432BE
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 13:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA7A6108E
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 13:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhHRNSk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Aug 2021 09:18:40 -0400
Received: from p3plsmtpa07-04.prod.phx3.secureserver.net ([173.201.192.233]:43909
        "EHLO p3plsmtpa07-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233634AbhHRNSi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 18 Aug 2021 09:18:38 -0400
Received: from [192.168.0.100] ([68.239.50.225])
        by :SMTPAUTH: with ESMTPSA
        id GLSEmBkPn80fFGLSEmTbhD; Wed, 18 Aug 2021 06:18:03 -0700
X-CMAE-Analysis: v=2.4 cv=VNQYI/DX c=1 sm=1 tr=0 ts=611d088b
 a=Rhw2r8FBodfaBxRKvGSZLA==:117 a=Rhw2r8FBodfaBxRKvGSZLA==:17
 a=IkcTkHD0fZMA:10 a=ERYGcR1Jba4K_bR2ZcYA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: Disable key exchange if ARC4 is not available
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
References: <20210818041021.1210797-1-lsahlber@redhat.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <815daf08-7569-59ce-0318-dfe2b16e1d96@talpey.com>
Date:   Wed, 18 Aug 2021 09:18:02 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210818041021.1210797-1-lsahlber@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfH2V7bEh6VA1aco1hxVsZJNA9AWzISSJ61Tmv4p8e/HzwTFZQz5DheqWjOparI8ZI3CzhR+WcEnrENcZ4Wb5cI//aqCEidsrZYiNFUrlKO7+VU99mRFj
 HtV9SM6yNi2LZDB14cr2Jda3H9c5aaJ1mgi80XxHfiLj4ttKFfAcbT5KznxTX1c9sguYVteZhl6Y7ZEwiC4JE8LP3i98F/ckA0E20Bnj34PKPCPc5PVkA8ew
 xREEMzSVSQjAvUMJJ83erQ==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/18/2021 12:10 AM, Ronnie Sahlberg wrote:
> Steve,
> 
> We depend on ARC4 for generating the encrypted session key in key exchange.
> This patch disables the key exchange/encrypted session key for ntlmssp
> IF the kernel does not have any ARC4 support.
> 
> This allows to build the cifs module even if ARC4 has been removed
> though with a weaker type of NTLMSSP support.

It's a good goal but it seems wrong to downgrade the security
so silently. Wouldn't it be a better approach to select ARC4,
and thereby force the build to succeed or fail? Alternatively,
change the #ifndef ARC4 to a positive option named (for example)
DOWNGRADED_NTLMSSP or something equally foreboding?

Tom.
