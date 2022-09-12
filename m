Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CAC0ECAAD5
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Sep 2022 05:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiILFvn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Sep 2022 01:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiILFvl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Sep 2022 01:51:41 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A121F2529A
        for <linux-cifs@vger.kernel.org>; Sun, 11 Sep 2022 22:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=Pa2tM8kQKr8724t5VPraRwpy8UCxXWndh5kdpjMinLs=; b=KGEEi9/ta6VFfr3JYxWlM88Q8p
        szOKdHqxb+aC5k28SkEQuTulJ7R9lSMXwbFKLzI+1Db88r+fXICqam2lSZBlGkTkC6lFvy3P37E9Q
        VoCnwZEtSlAbEHgFlSmv3QSbg+z88j0Kjsiquw5ykQnfPfHEGEdU1yeIdaUYDJet4ZQ3KY0133V9S
        cNRbileC9CF/cnkXRpD5+zcQundcv88WMy9yTejeiHqHnnYWaliP2me7X68CCvTzjIO2LazvJkLJh
        dprVy44GW9612EIgmKapw0a3KFrkEFMAD0v5QEpp/0QVa76/2VM/Uyhc8Az9fVaRKUPol56mwNJo/
        dMzequq2KUmk4ic7n8me2/OcBD0ASVMD2S1AWgpaoIiC6WitLOdn8TcwSsrXE8T33gtsGrvs2Udpf
        bE3CDSQ/T/OGYGhDpKVzY5VZs/1wjjor52Pbn2JMPAbvzqpwsq5v+VID9x6aiUSdqr5FazEz+iBAM
        fLdUBNyTxS8iMMDFAyfUmyi/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oXcM2-0000UY-18; Mon, 12 Sep 2022 05:51:34 +0000
Message-ID: <f19d2bf6-6b05-f782-fcfa-1c09c867dcb2@samba.org>
Date:   Mon, 12 Sep 2022 07:51:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH][SMB3.1.1 client] fallback to query fs all info if posix
 query fs not supported
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mvC5sqwuLyLt=3PXYvPegOm-8rqSMYcCpjM3+T64fv2sg@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAH2r5mvC5sqwuLyLt=3PXYvPegOm-8rqSMYcCpjM3+T64fv2sg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Am 12.09.22 um 07:36 schrieb Steve French via samba-technical:
> A version of Samba that I was testing, supported POSIX extensions, but
> not the query fs info
> level.  Fall back to query fs all info if POSIX query fs info not
> supported.
> 
> Also fixes the problem that compounding wasn't being used for posix
> qfs info in this path (statfs) but was being used in others, so
> improves performance of posix query fs info.

I don't think having hacks to work with work in progress branches should be
added, instead the server should be fixed.

metze

