Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA37EE49A5
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Aug 2023 22:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjHVWCf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Aug 2023 18:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjHVWCf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Aug 2023 18:02:35 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3362B11F
        for <linux-cifs@vger.kernel.org>; Tue, 22 Aug 2023 15:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=Ced1eU3mz/NRofQBy1o7NlJOWntpKCF2quI+5esplTU=; b=I+d9ISPUqhzDwMpWI29kemY7yJ
        Wb4/60gm3pntNkSA8ZDYJLn/Dm2+3dnjy17XBIzTuankTw1xP24H/9O7OvDmQF+kV3FyspTNaT+HR
        QJQfF0slUFwibqn7zCeN7IbbxqzLdFSA4d0ZsE8OYynYy4JIY0pSVNDVsKov6fm6hGw4HE/NEnvTS
        YqT+fnxdTFbZHpaeApr5VfHkwHdssuntIv/i1XT+NG77yYUmdkBaD8VSG/NcL6Y5q61EClt2fzl+Z
        ihXk0d6nftS3fYu94+vlFNEniNVuJ3AOlYtaKvupanubQ4yNAayKZoMdhAZfrZjlMW6btpJgVXHii
        LPE2zXd0HF68syv5n9ilFxGni5gGXD+fk4cCwYokvI+5ChOMvZjywmkvG9edLSBxk6Wqmaz2mB1b/
        lhbDLGl1t1863yQ97m3EivshR+iG6dReX0EqI4ClzDkY1Bxns0E2Pbaco/geStQ5QN/XzNZtvTkKj
        VXhzcoTGWIWOpNzjkWiRN4jo;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qYZSF-009TjD-2g;
        Tue, 22 Aug 2023 22:02:28 +0000
Message-ID: <1c535816-0a9c-6924-642f-508e82cd0237@samba.org>
Date:   Tue, 22 Aug 2023 17:02:26 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: where to get the patches for samba over quic support
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>, samba-technical@lists.samba.org,
        CIFS <linux-cifs@vger.kernel.org>, wedsonaf@gmail.com
References: <CADvbK_eHYFJWL3xaZeciUMPjWXqkP_Kp3DrpP-3XPyopY1yZmg@mail.gmail.com>
From:   Steven French <sfrench@samba.org>
In-Reply-To: <CADvbK_eHYFJWL3xaZeciUMPjWXqkP_Kp3DrpP-3XPyopY1yZmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I was very interested in this as well and there seems to be a logical 
use case for SMB3.1.1 mounts from the kernel client (cifs.ko) since 
multiple servers already support QUIC for SMB3.1.1 mounts (e.g. Windows 
and apparently also an embedded server that demoed at Storage Developer 
Conference last year).  Key question remains how much of the code can 
stay in userspace (so only the key socket read/write code must be in 
kernel, not necessarily the connection setup).   There are also some 
interesting points that the Microsoft QUIC (open source project in 
github) project guys mentioned including that for testing you can often 
do "unencrypted QUIC" as a first step (which also has performance 
benefits over TCP)

We can discuss more details if you want, but Wedson had some great ideas 
about doing some of this in Rust (and looks there are already 3 work in 
progress user space opensource QUIC implementations in Rust - so some of 
the code could be reused)


On 8/21/23 09:55, Xin Long wrote:
> Hi, Samba Team,
>
> I'm currently working on QUIC implementation in Linux Kernel, and thinking
> of applying it to fs/smb for SMB over QUIC in kernel. For interoperability
> testing, I'm looking for an existing userspace implementation for SMB over
> QUIC in Linux.
>
> I heard there are already some internal patches in samba for SMB over QUIC
> support, anyone knows where I can get it for this testing?
>
> Thanks.
