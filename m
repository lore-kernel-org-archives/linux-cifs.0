Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C89C433E1
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 17:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C4DA61A2D
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 17:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhCZRBZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Mar 2021 13:01:25 -0400
Received: from gateway33.websitewelcome.com ([192.185.145.23]:34992 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230381AbhCZRBR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 26 Mar 2021 13:01:17 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Mar 2021 13:01:17 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 41A98857A4E
        for <linux-cifs@vger.kernel.org>; Fri, 26 Mar 2021 11:13:18 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Pp5Kl91KAMGeEPp5KlogLi; Fri, 26 Mar 2021 11:13:18 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sXBjgLTu76uTaWX0R7809lCSyGgsc8Sygcl8kzPa31g=; b=E5CtBqHdRp4mzdp86hktOocKt8
        WY9zbVHvS5zhockEiVBSkSbs4iEkzjA60vDhqa6SML2weLBlfRjnJYaIects8zHLUZit820pDFxGe
        eKlHU3+92pJ8zn/8Im0NU7WPtSTWFTx5UMIrkmIY/iyUW0nwPBEUyKzv7xc5NwCE4V9V5DuDrcKxz
        yZ0HMrrYoby8V/wuHopk+wwUg36od/0PpXJ1LV5mOOfQoV6bcc9ucRGMoBJwSOxwmZ1uqAUJ9u0Tw
        0OePSMB/Ytcpm2FqJzXG2VRv+1l6NShDEiBNDLGvS6VijYEh97T/M0wWRMFAMxDtv8g9zHusHnb41
        crH73K6w==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:35424 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lPp5J-004Js4-TR; Fri, 26 Mar 2021 11:13:17 -0500
Subject: Re: [PATCH][next] cifs: cifspdu.h: Replace one-element array with
 flexible-array member
To:     =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210326011117.GA46303@embeddedor> <877dltrjue.fsf@suse.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <4def044f-4529-9e73-6d01-1a9751f6b09a@embeddedor.com>
Date:   Fri, 26 Mar 2021 10:13:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <877dltrjue.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lPp5J-004Js4-TR
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:35424
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



On 3/26/21 10:54, Aurélien Aptel wrote:
> "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
>> There is a regular need in the kernel to provide a way to declare having
>> a dynamically sized set of trailing elements in a structure. Kernel code
>> should always use “flexible array members”[1] for these cases. The older
>> style of one-element or zero-length arrays should no longer be used[2].
> 
> I've checked the usages of the struct, looks OK (we don't allocate it
> directly, we use memory from the small/big buff pools).

Awesome. :)

> Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Thank you, Aurelien.
--
Gustavo
