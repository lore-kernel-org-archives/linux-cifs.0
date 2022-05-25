Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D49C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 25 May 2022 10:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbiEYKAj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 May 2022 06:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiEYKAi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 May 2022 06:00:38 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E290F53B57
        for <linux-cifs@vger.kernel.org>; Wed, 25 May 2022 03:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=T58QNxUYzuSm/YpFY1NFIss2or0K21AZcRidsIqG7+A=; b=zmdKohyE5R8aBD9u9YjTPUenmF
        L3OBYcPUbzsiJ1jSzn90cPgR3qZmmBdxL8qxTmF8lRfJfZRhKYpSwYFXKD1yZ229xqacW6EjBr2dq
        ubQ0MXzIRzs0Y3efXvS25fNWIqyUMRJS5dVDKVITNjMZo5/MdL5NPG3eMKU0NPWCnNpPFnAr4S6Bo
        QVT91VSNOJmY68Y4TwJ0I2yoC7WuVQwGxY/F7dGQ6GaiMI3rIululhHfD5qL0wRBrDNYkw5ufUubK
        Wock7ZP6SUw4SXk7pC5ALzOVOEv8qXFai2Zxm8Npde6Azx0dugoodskgt7UAuEZe10jzH+RSDdCbG
        E3xTpMfEFqZrCnQAS5SWNL/XPM5jM3britVSSVwg1vr2N1yK0KNOLaHQIHlBkMhBYay+esHac60Fd
        KlWfOJjOaC5pzVfRxCdF5W2YNoZskfrXMGfsKGmDq8Au3qMYMxeqH992ceGUI501LGUVrFGAcBdWh
        gwzhDDgLCdoB/N2cqU+SYQZG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1ntnof-002QhO-NA; Wed, 25 May 2022 10:00:33 +0000
Message-ID: <b8850e44-2772-73c0-8998-a961538b9525@samba.org>
Date:   Wed, 25 May 2022 12:00:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: RDMA (smbdirect) testing
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Cc:     Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <1922487.1653470999@warthog.procyon.org.uk>
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
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <1922995.1653471687@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi David,

> Note also that whilst wireshark can decode iwarp traffic carrying NFS, it
> doesn't recognise iwarp traffic carrying cifs.

It works fine for me.

Can you share the capture file?

What version of wireshark are you using?

metze

