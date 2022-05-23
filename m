Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC5F2C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 23 May 2022 14:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbiEWODU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 10:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbiEWODT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 10:03:19 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB0457B09
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 07:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=e5t2yH4FkrfqFx4CbBtYcdlc6QiJxk2TuWFjXCqGCeI=; b=z1mJgtwT9xSD2JTZFB7y3Ni79H
        xrtTEhuNObpiWgrgY+Z5OixZ9j4+ngTEGlec1hSCTqArqG4Erzpx3WANHEaT4O4ApmGQRCmfRlRxE
        kZ2hSfyy9kQNy/fgJWclsg868bXoL1m2ZHN1VT3WKwWnqfVWCWP5/d4LCz/DXrGDESXwd14qkat6B
        Gv2SZ9n/PkR+/0th2METVERo6bGVkFYd9Nkfjljh3peiw2HTzUkvKWFnJR0CE8J10wSzfnbG60jSK
        JKJWxvDiJEifI4p8IRO3hMg/0ZYKQzpTB3vYqrwVj4jHgUU1Y30DYw3aC2IDwHUwODBMeGFVsXxpJ
        7hnc6dtj1LT4h4DpiSKy1JOi6kgI69y3J3eObrS/XbckCLmqaUQi0QTG0kSOUnMEgTcrKYEjl5GeK
        vzoDaeN52mal31zrLhEFLdNN8flxkLZog3bVOLR/qQmeQ+5QNnZRROxZNAeMaE9bO4DsRyXQORtms
        DRBZ178q0FSFP1pPoaVwf3WB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nt8eQ-0028yU-Fd; Mon, 23 May 2022 14:03:14 +0000
Message-ID: <91acf918-e38d-a07a-ea18-0bb0052d0bde@samba.org>
Date:   Mon, 23 May 2022 16:03:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: RDMA (smbdirect) testing
Content-Language: en-US
To:     Tom Talpey <tom@talpey.com>, David Howells <dhowells@redhat.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk>
 <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Am 21.05.22 um 13:54 schrieb Tom Talpey:
> 
> On 5/20/2022 2:12 PM, David Howells wrote:
>> Tom Talpey <tom@talpey.com> wrote:
>>
>>> SoftROCE is a bit of a hot mess in upstream right now. It's
>>> getting a lot of attention, but it's still pretty shaky.
>>> If you're testing, I'd STRONGLY recommend SoftiWARP.
>>
>> I'm having problems getting that working.  I'm setting the client up with:
>>
>> rdma link add siw0 type siw netdev enp6s0
>> mount //192.168.6.1/scratch /xfstest.scratch -o rdma,user=shares,pass=...
>>
>> and then see:
>>
>> CIFS: Attempting to mount \\192.168.6.1\scratch
>> CIFS: VFS: _smbd_get_connection:1513 warning: device max_send_sge = 6 too small
>> CIFS: VFS: _smbd_get_connection:1516 Queue Pair creation may fail
>> CIFS: VFS: _smbd_get_connection:1519 warning: device max_recv_sge = 6 too small
>> CIFS: VFS: _smbd_get_connection:1522 Queue Pair creation may fail
>> CIFS: VFS: _smbd_get_connection:1559 rdma_create_qp failed -22
>> CIFS: VFS: _smbd_get_connection:1513 warning: device max_send_sge = 6 too small
>> CIFS: VFS: _smbd_get_connection:1516 Queue Pair creation may fail
>> CIFS: VFS: _smbd_get_connection:1519 warning: device max_recv_sge = 6 too small
>> CIFS: VFS: _smbd_get_connection:1522 Queue Pair creation may fail
>> CIFS: VFS: _smbd_get_connection:1559 rdma_create_qp failed -22
>> CIFS: VFS: cifs_mount failed w/return code = -2
>>
>> in dmesg.
>>
>> Problem is, I don't know what to do about it:-/
> 
> It looks like the client is hardcoding 16 sge's, and has no option to
> configure a smaller value, or reduce its requested number. That's bad,
> because providers all have their own limits - and SIW_MAX_SGE is 6. I
> thought I'd seen this working (metze?), but either the code changed or
> someone built a custom version.

No, I only tested with my smbdirect driver and there I don't have
such a problem.

I never god cifs.ko to work with smbdirect.

metze

