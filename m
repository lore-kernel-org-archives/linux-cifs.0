Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A86AC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 27 May 2022 13:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351547AbiE0NqD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 May 2022 09:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbiE0NqC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 May 2022 09:46:02 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBF15AA4A
        for <linux-cifs@vger.kernel.org>; Fri, 27 May 2022 06:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=LoJkDtqsg3x5Yd4TVVP+f2TwF5w3WDLFCaoPxLRg+NE=; b=HI3gQMzHUvt2fnYJx8u+hxGkZK
        9+CgN362Tx+aWp8i26Ertozr45HmrvS2ZxVhlGWfkjSrTJI8v9Q1lkZGgEBOh5qC2lqOygYc28A0D
        Xr7ko6xDaECUb1M8Sv5/5u1Z8GUCKtJAM1QZcfgBfSbOJ/dU/kqij8gmsqZOSx+ihZfjA7l+F4r0E
        99vff+LRmk3LeT/La+FvVL8ZM2Jt5Ug5OhAnZt1b3iMCGBBIrupBpTZVxiyZxaGkaA5iiyPZzMIxM
        jf6znLx0CdcTanWsoG6Be20VmrmjsIbLCaAIEW869iAvx0j+nTanH9wrDkIDnw3rCUEmzUlLfCIR8
        xpvCHpLEXZ3fZsVqRip4ohZ/4rhZYfwyGlh16hP2+EHM7vsFi+tBwNYM2Ovd3JV6tegPT5xtOIEMS
        j5sUafN/l9S6ZtlxEI45p1rPG+KWvShIaPrxEskP1c/4hab9eI3r0xNtTi58gm1/1/eG3zQOKWjkx
        nTuTMQ+9e7c1AGdf8wfi/2pE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nuaHu-002lUg-3P; Fri, 27 May 2022 13:45:58 +0000
Message-ID: <33483e99-a127-02e9-aee4-0d6690a6d934@samba.org>
Date:   Fri, 27 May 2022 15:45:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>
Cc:     Tom Talpey <tom@talpey.com>, Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <69922c7e-d463-1f98-d0a0-7c7822fae1dc@samba.org>
 <b8850e44-2772-73c0-8998-a961538b9525@samba.org>
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
 <3505924.1653651977@warthog.procyon.org.uk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: RDMA (smbdirect) testing
In-Reply-To: <3505924.1653651977@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Am 27.05.22 um 13:46 schrieb David Howells:
> Stefan Metzmacher <metze@samba.org> wrote:
> 
>> Does https://gitlab.com/wireshark/wireshark/-/merge_requests/7025.patch
> 
> I tried applying it (there appear to be two patches therein), but it doesn't
> seem to have any effect when viewing the pcap file I posted.  It says it
> should decode the port as Artemis.

I found that it's needed to set the
tcp.try_heuristic_first preference to TRUE

Check this:

grep '^tcp' preferences
tcp.try_heuristic_first: TRUE

For ~/.config/wireshark/ (or ~/.wireshark/' as fallback)

metze
