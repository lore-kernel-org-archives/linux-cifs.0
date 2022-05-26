Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2A7C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 26 May 2022 14:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245034AbiEZO4U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 May 2022 10:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiEZO4T (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 May 2022 10:56:19 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C25D64FD
        for <linux-cifs@vger.kernel.org>; Thu, 26 May 2022 07:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=VJIo6r9khQkeAorydudTrqQA7Ba6buZW3NocEkFYuYE=; b=iNV1C3AE0RE1km98Z5TcJ5RIzc
        +iErRgzSx7hfaPJiFH5aVPiBprVlg9/xiupSB0RuvUGaAcGY5DuYPhpTA9Bv4QxBQUB5q9ULYZqDD
        UyxOJxUVW7pUYfXS/liq5YIp6dQkRcTT2ggA88+2BlkzaoNIrPls1ROupCvwniviUAsRLVXpuGj0W
        5EK9Axq3vLfyNBGOFAPhLRbCMxzLMzONftELaEdkJie1lIPjfnZgzATMur73MGtskc3/xkQsRFavM
        oV80/80pYceGR6VDYAJW0pv+7zFd3rxXyUJWtSw5mmfZ8jKY5eMDehJ5+lbOapsCFk98mbu3EoPeW
        HmlS7JBcGQGohkED6zLXBZwkSbdt8Q/oJavE9NfeqpvTMuRpw9PsxakOHAcTx33sRstfvKFfkWmh6
        XfvR55cjfz6y4xfyHhtKGXc+lLydieNOdsdtqBbWn5x6e0w7OGapzAAnqeoCmiBfGYWRe8dDuYBjI
        28EpU4i5fEnMAtXMbyGtxk3h;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nuEuM-002bbD-4E; Thu, 26 May 2022 14:56:14 +0000
Message-ID: <7841d1f6-a650-2c62-1518-baecf55cea39@samba.org>
Date:   Thu, 26 May 2022 16:56:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <b8850e44-2772-73c0-8998-a961538b9525@samba.org>
 <1922487.1653470999@warthog.procyon.org.uk>
 <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
 <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk>
 <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com>
 <1922995.1653471687@warthog.procyon.org.uk>
 <1963315.1653474049@warthog.procyon.org.uk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: RDMA (smbdirect) testing
In-Reply-To: <1963315.1653474049@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Am 25.05.22 um 12:20 schrieb David Howells:
> Stefan Metzmacher <metze@samba.org> wrote:
> 
>> Can you share the capture file?
> 
> See attached.
> 
>> What version of wireshark are you using?
> 
> wireshark-3.6.2-1.fc35.x86_64
> Wireshark 3.7.0 (v3.7.0rc0-1686-g64dfed53330f)

Works fine for me with 3.6.2-2 on ubuntu and also a recent wireshark master version.

I just fixed a minor problem with fragmented iwrap_ddp_rdma_send messages in
frames 91-96. Which seem to happen because ksmbd.ko negotiated a preferred send size of 8192,
which is accepted by the cifs.ko. Windows only uses 1364, which means each send operation fits into
a single ethernet frame...

See https://gitlab.com/wireshark/wireshark/-/merge_requests/7025

metze
