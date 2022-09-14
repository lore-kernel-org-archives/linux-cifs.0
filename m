Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C122FC6FA82
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 14:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiINOsP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Sep 2022 10:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiINOsH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Sep 2022 10:48:07 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C327330C
        for <linux-cifs@vger.kernel.org>; Wed, 14 Sep 2022 07:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=iE/ShEPk6wg9KNeYBg6gGwKzvIEaCIhdT27wGu88Q10=; b=FwIjHQVYAEtq/9rOw02lb6huSJ
        YOwZJWn14vD4NZx4ZvKiVwkRwEIGqqvNiP/BUgePFNzwTrx3xRAh9vaaDuAnufLFEJdDYhH0Og/JN
        BPMmsQ3n4/ji+cVioTOM2KhzLCK5R130UaHUHsopm0oP6vNceWT0qKdwYuvOsVfSOYtJil5JT37v7
        DwFq599BFS8evBrafn1ibj2xKB4PfowNaSgf7+ZvLNcQlLegVuw63Ymw5hb8+YUCLj9+10Gp8iv+6
        JOmJU5QGwdJd5M4McoVYaTNY0Nppg9K6/crWLtwlwfyARG+f9kd5lDwBy3YuiJNUTa+Fuv7A9xfHO
        9R2JK7QZOQl5wT/FkZhU8qQaD6kiChnxzNvKuv+s2al10dda2v5NmeSegnvOkpZ/IU2BzVU7p6fxb
        +5I7aZ9S0ASqnsYWN626nHA/oVcCkkP4coJPcuKW3Nu27OkQyJVCYMqre8IqO46xgWsyXCo/cZMoQ
        YOqLKcZbg/NtwHpBjPTC/tVS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oYTgH-000N3x-1j; Wed, 14 Sep 2022 14:48:01 +0000
Message-ID: <59df1da8-a40e-3dfd-c071-e06c517972d4@samba.org>
Date:   Wed, 14 Sep 2022 16:47:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
References: <20220829213354.2714-1-ematsumiya@suse.de>
 <20220829213354.2714-2-ematsumiya@suse.de>
 <0f2d41bf-f0da-aa10-76a3-ced2a3cebba3@samba.org>
 <20220914143214.nsrssywog7xwtfv5@suse.de>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC PATCH v2 1/3] cifs: introduce AES-GMAC signing support for
 SMB 3.1.1
In-Reply-To: <20220914143214.nsrssywog7xwtfv5@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hi Enzo,

> You mean as copying crypt_message() and adapt for AES-GMAC signing,
> instead of having the common parts in a separate function? I'll change
> that on v3, I just thought it'd be better to have less duplicate code.
> 
..

>> Why wasting time to allocate/free a 12 byte buffer for every pdu?
>>
>> Can't we have a named structure and pass in a reference from the
>> caller, which has it on the stack?

> Got it. I'll fix this for v3.
For both just see this from line 624 up to 963.

> https://git.samba.org/sfrench/cifs-2.6.git/?p=sfrench/cifs-2.6.git;a=blob;f=fs/cifs/smb2transport.c;h=4b912c75caa32d8f66a21286c5c28b982ea8efa1;hb=4b912c75caa32d8f66a21286c5c28b982ea8efa1#l624

I think smb2_sg_set_buf() should be moved to a header in order to avoid having it twice.

The verify argument to smb311_calc_aes_gmac should be renamed to allocate_crypto
in order match smb3_calc_aes_cmac(), and the logic related to allocate_crypto
if most likely the fix, as you mentioned in the other mail.

And all the huge comments should be removed, as it's now no longer mixed with signing and
is relatively simple to follow...

metze
