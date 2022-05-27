Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85307C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 27 May 2022 08:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343699AbiE0I1X (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 May 2022 04:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiE0I1W (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 May 2022 04:27:22 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34FC13E09
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 01:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=wA+QRPwWDL8TeBSlWF8Ks8D9x4+BRwtPICLxu7fcMkE=; b=xMNe4UriHHeGOAN+c9CWmyz9j1
        WIwPgItTNNDDe/aigt62MetopcHi1vG6U2mAAuVvrCa+RKZLzC8AkYaStsi/upn17bhdgbsFSFhbF
        z0i69b0+TwWThUA37u/RmpXd6ARnh4emcJZYO1uE5Ara/5w6dok9FiMMjGa1pB4F3h1zcR8tK8Rla
        K8AKtrjJ+5vHtZky38nstdQjlPltgcWBDpZfs7f4jbhjhyp7Hwnm8tNLBJj+XbMmAIvCbzFDE6oSw
        PabgJTYAeND5wA8CBFT2z3tWgf3Va9qJ3bU/IPCliMkM+FGECG5D6ODNb78/lLPhzYf5hJz/s1MZH
        YDX/PltwmQUjEIULBHoLBsPBd82bA6SV2qDAgbXQ5N1IuvwzISVCPVoAHToxUlzBXspb/R8rTIcMK
        KJ6JCmyk7ihiUl/dwOU8s7+k1iICqx3pOE8tZIaq+L2Vi+a8eUkxdpr6WqksvoFZyTCklUp58vJee
        sdr1056wvLDK/6KUVhrZjsmn;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nuVJW-002j0T-G0; Fri, 27 May 2022 08:27:18 +0000
Message-ID: <69922c7e-d463-1f98-d0a0-7c7822fae1dc@samba.org>
Date:   Fri, 27 May 2022 10:27:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Tom Talpey <tom@talpey.com>, David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Long Li <longli@microsoft.com>,
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
 <7841d1f6-a650-2c62-1518-baecf55cea39@samba.org>
 <3d0f1538-629e-d4a7-8ac4-500f908b0c2a@talpey.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: RDMA (smbdirect) testing
In-Reply-To: <3d0f1538-629e-d4a7-8ac4-500f908b0c2a@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hi Tom,

>>>> Can you share the capture file?
>>>
>>> See attached.
>>>
>>>> What version of wireshark are you using?
>>>
>>> wireshark-3.6.2-1.fc35.x86_64
>>> Wireshark 3.7.0 (v3.7.0rc0-1686-g64dfed53330f)
>>
>> Works fine for me with 3.6.2-2 on ubuntu and also a recent wireshark master version.
>>
>> I just fixed a minor problem with fragmented iwrap_ddp_rdma_send messages in
>> frames 91-96. Which seem to happen because ksmbd.ko negotiated a preferred send size of 8192,
>> which is accepted by the cifs.ko. Windows only uses 1364, which means each send operation fits into
>> a single ethernet frame...
> 
> That was not an accident. :)
> 
> There's a talk somewhere in which I mentioned how we tried to optimize
> the smbdirect fragment size and always landed back on 1364.

Yes, I remember 4096/3 :-)

> However, this is only an implementation choice, the protocol supports a wide
> range. So it's appropriate for wireshark to be accommodating.

Yes, but the past 20 years showed more than once that, everything but matching
Windows just leads to bugs, because of untested code paths.

>> See https://gitlab.com/wireshark/wireshark/-/merge_requests/7025
> 
> I get a blank frame when I view both changes on this link. Do I need
> a gitlab account??

I don't think so, I'm seeing it even without being logged in.

Does https://gitlab.com/wireshark/wireshark/-/merge_requests/7025.patch
or https://gitlab.com/wireshark/wireshark/-/merge_requests/7025/diffs
work?

metze
