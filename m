Return-Path: <SRS0=pODE=33=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD4AC352A2
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Feb 2020 08:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE75121741
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Feb 2020 08:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgBGIMh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Feb 2020 03:12:37 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:58988 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgBGIMh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Feb 2020 03:12:37 -0500
Received: from ramsan ([84.195.182.253])
        by baptiste.telenet-ops.be with bizsmtp
        id zkCb2100B5USYZQ01kCbur; Fri, 07 Feb 2020 09:12:35 +0100
Received: from geert (helo=localhost)
        by ramsan with local-esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1izykd-0006Uw-5k; Fri, 07 Feb 2020 09:12:35 +0100
Date:   Fri, 7 Feb 2020 09:12:35 +0100 (CET)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     Steve French <smfrench@gmail.com>
cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        kbuild test robot <lkp@intel.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        =?ISO-8859-15?Q?Aur=E9lien_Aptel?= <aaptel@suse.com>,
        samba-technical <samba-technical@lists.samba.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [cifs:for-next 10/11] fs/cifs/smb2pdu.c:1985:38: error: macro
 "memcmp" passed 18 arguments, but takes just 3
In-Reply-To: <CAH2r5mvtYcc+=bKApMsb=Cg2VgiwPoEfV92cncfhFswjBmkKFw@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2002070904270.23274@ramsan.of.borg>
References: <202002070617.AbeYy9qc%lkp@intel.com> <CAH2r5mtHY6OGMpMdpLcxZ_xyjzZHANhqr_NoeGERiFiQyfc-PQ@mail.gmail.com> <CAN05THQ8ajLM58-dyQA0teD56Hkt7wmJMRtHB8DW1Yh5qKBrjg@mail.gmail.com> <CAH2r5mvtYcc+=bKApMsb=Cg2VgiwPoEfV92cncfhFswjBmkKFw@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

 	Hi Steve,

On Thu, 6 Feb 2020, Steve French wrote:
> ok - changed as suggested. Tested out ok

> From ab3459d8f0ef52c38119ed58c4c29139efc7022c Mon Sep 17 00:00:00 2001
> From: Steve French <stfrench@microsoft.com>
> Date: Thu, 6 Feb 2020 17:31:56 -0600
> Subject: [PATCH 1/2]  smb3: print warning once if posix context returned on
>  open
> 
> SMB3.1.1 POSIX Context processing is not complete yet - so print warning
> (once) if server returns it on open.
> 
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/smb2pdu.c | 22 ++++++++++++++++++++++
>  fs/cifs/smb2pdu.h |  8 ++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 47cce0bd1afe..1234f9ccab03 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1950,6 +1960,9 @@ smb2_parse_contexts(struct TCP_Server_Info *server,
>  	unsigned int next;
>  	unsigned int remaining;
>  	char *name;
> +	const char smb3_create_tag_posix[] = {0x93, 0xAD, 0x25, 0x50, 0x9C,
> +					0xB4, 0x11, 0xE7, 0xB4, 0x23, 0x83,
> +					0xDE, 0x96, 0x8B, 0xCD, 0x7C};

Given this data is used in 2 other places, you may want to make it
global, and use it in build_posix_ctxt() and create_posix_buf(), too.

> On Thu, Feb 6, 2020 at 5:16 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>>
>> It is probably that m68k lage quite behind in GCC versions and
>> probably that compiler can not handle this construct:
>>> 1983                          if (memcmp(name, (char []) {0x93, 0xAD, 0x25, 0x50,
>>   1984                                  0x9C, 0xB4, 0x11, 0xE7, 0xB4,
>> 0x23, 0x83,
>>> 1985                                  0xDE, 0x96, 0x8B, 0xCD, 0x7C}, 16) == 0)
>> and you would probably need something like this:
>>      const char foo[] = {0x93, 0xAD, 0x25, 0x50, 0x9C, 0xB4, 0x11,
>> 0xE7, 0xB4, 0x23, 0x83, 0xDE, 0x96, 0x8B, 0xCD, 0x7C};
>>      if (memcmp(name, foo, sizeof(foo)) == 0)
>> ...

This is not related to compiler version (I can trigger it with a small
test program on gcc-7 and gcc-8 on amd64), but due to the use of a
macro in arch/m68k/include/asm/string.h for providing memset():

     #define memset(d, c, n) __builtin_memset(d, c, n)

As several other architectures do to the same (even x86, depending on
config options and other parameters), I guess it can be triggered there
as well.

>> On Fri, Feb 7, 2020 at 8:48 AM Steve French <smfrench@gmail.com> wrote:
>>>
>>> It compiled and tested ok.  Is this warning a limitation of the kbuild robot?
>>>
>>> On Thu, Feb 6, 2020 at 4:26 PM kbuild test robot <lkp@intel.com> wrote:
>>>>
>>>> tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
>>>> head:   58b322cfd219fd570d4fcc2e2eb8b5d945389d46
>>>> commit: 3d9d8c48232a668ada5f680f70c8b3d366629ab6 [10/11] smb3: print warning once if posix context returned on open
>>>> config: m68k-multi_defconfig (attached as .config)
>>>> compiler: m68k-linux-gcc (GCC) 7.5.0
>>>> reproduce:
>>>>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>>>         chmod +x ~/bin/make.cross
>>>>         git checkout 3d9d8c48232a668ada5f680f70c8b3d366629ab6
>>>>         # save the attached .config to linux build tree
>>>>         GCC_VERSION=7.5.0 make.cross ARCH=m68k
>>>>
>>>> If you fix the issue, kindly add following tag
>>>> Reported-by: kbuild test robot <lkp@intel.com>
>>>>
>>>> All errors (new ones prefixed by >>):
>>>>
>>>>    fs/cifs/smb2pdu.c: In function 'smb2_parse_contexts':
>>>>>> fs/cifs/smb2pdu.c:1985:38: error: macro "memcmp" passed 18 arguments, but takes just 3
>>>>         0xDE, 0x96, 0x8B, 0xCD, 0x7C}, 16) == 0)
>>>>                                          ^
>>>>>> fs/cifs/smb2pdu.c:1983:8: error: 'memcmp' undeclared (first use in this function); did you mean 'memchr'?
>>>>        if (memcmp(name, (char []) {0x93, 0xAD, 0x25, 0x50,
>>>>            ^~~~~~
>>>>            memchr
>>>>    fs/cifs/smb2pdu.c:1983:8: note: each undeclared identifier is reported only once for each function it appears in


Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
