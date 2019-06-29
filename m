Return-Path: <SRS0=BNJn=U4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492BDC5B57A
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Jun 2019 09:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 298B4215EA
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Jun 2019 09:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfF2JaX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 29 Jun 2019 05:30:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:49808 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726888AbfF2JaW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 29 Jun 2019 05:30:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3C40CAF04;
        Sat, 29 Jun 2019 09:30:20 +0000 (UTC)
Date:   Sat, 29 Jun 2019 11:30:18 +0200
From:   Jean Delvare <jdelvare@suse.de>
To:     Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc:     Harald Hoyer <harald@redhat.com>, linux-modules@vger.kernel.org,
        Pavel Shilovsky <pshilov@microsoft.com>,
        linux-cifs@vger.kernel.org
Subject: Re: multiple softdeps
Message-ID: <20190629113018.22c9c95c@endymion>
In-Reply-To: <20190628162517.GA24484@ldmartin-desk1>
References: <0bfb6f60-0042-f6be-24ed-7803b6ac759c@redhat.com>
        <20190628162517.GA24484@ldmartin-desk1>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Lucas, Harald,

On Fri, 28 Jun 2019 09:25:17 -0700, Lucas De Marchi wrote:
> +cifs, +Jean, +Pavel
> 
> On Fri, Jun 28, 2019 at 03:16:35PM +0200, Harald Hoyer wrote:
> >Hi,
> >
> >could you please enlighten me about kernel module softdeps?
> >
> >$ modinfo cifs | grep soft
> >softdep:        pre: ccm
> >softdep:        pre: aead2
> >softdep:        pre: sha512
> >softdep:        pre: sha256
> >softdep:        pre: cmac
> >softdep:        pre: aes
> >softdep:        pre: nls
> >softdep:        pre: md5
> >softdep:        pre: md4
> >softdep:        pre: hmac
> >softdep:        pre: ecb
> >softdep:        pre: des
> >softdep:        pre: arc4
> >
> >$ grep cifs /lib/modules/$(uname -r)/modules.softdep
> >softdep cifs pre: ccm
> >softdep cifs pre: aead2
> >softdep cifs pre: sha512
> >softdep cifs pre: sha256
> >softdep cifs pre: cmac
> >softdep cifs pre: aes
> >softdep cifs pre: nls
> >softdep cifs pre: md5
> >softdep cifs pre: md4
> >softdep cifs pre: hmac
> >softdep cifs pre: ecb
> >softdep cifs pre: des
> >softdep cifs pre: arc4  
> 
> this is your bug. Multiple softdeps are not additive to the previous
> configuration, we never supported that. Commit b9be76d585d4 ("cifs: Add

That's my fault then, sorry about that. At the time I submitted the
patch, there was no occurrence of module having multiple softdeps, so I
didn't know how it should be done. It was some time ago and I don't
remember the details though, and I have no trace of why I worked on
this in the first place.

Apparently I'm not the only one confused as I see driver
pcengines-apuv2 has exactly the same problem. I'll send a patch for
that one.

If multiple softdep statements are not supported then shouldn't we
prevent them from happening, either with a link-time check, or with a
checkpatch test? I have no idea how to implement such a check though.

> soft dependencies") added it for the wrong reasons actually. A sotfdep
> means kmod will actually load those dependencies before loading the
> module (or fail to load it if those dependencies don't exist).

That's my definition of a regular (not soft) dependency. If failing
soft pre dependencies are fatal, how do they differ from regular
dependencies? Only because they are listed explicitly instead of being
determined from symbol use?

FWIW modprobe.d(5) mentions "optional modules" and insists that the
main module is still usable without them, so my understanding was that
a modprobe would be attempted on soft deps but a failure would be
ignored.

> Besides the wrong commit message, if that is indeed what is desired, the
> fix would be:

The commit message may sound wrong to you but the (fixed version of the
patch) still solves the problem (including all potentially needed
modules in initrd even when there are no hard dependencies) at least as
a side effect. If you think that softdeps are not how the problem
should be solved, then how do you think it should be solved? I
understand that pre-loading all cipher and hash modules is not
efficient, but we still need to ensure that they all make it to the
initrd in case they are needed.

Or we could decide that cifs in initrd is not supported? To be honest
I'm not sure why people would do that. Samba mounts do not seem
appropriate for system or home partitions anyway... So maybe I tried to
solve a problem which nobody had in the first place. Can the CIFS
people please share their views on that? That's also a question for
Harald: Harald, what were you doing with the cifs driver which led you
to discovering this bug?

> --------8<--------------
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 65d9771e49f9..4f1f744ea3cd 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1591,18 +1591,6 @@ MODULE_DESCRIPTION
>  	("VFS to access SMB3 servers e.g. Samba, Macs, Azure and Windows (and "
>  	"also older servers complying with the SNIA CIFS Specification)");
>  MODULE_VERSION(CIFS_VERSION);
> -MODULE_SOFTDEP("pre: arc4");
> -MODULE_SOFTDEP("pre: des");
> -MODULE_SOFTDEP("pre: ecb");
> -MODULE_SOFTDEP("pre: hmac");
> -MODULE_SOFTDEP("pre: md4");
> -MODULE_SOFTDEP("pre: md5");
> -MODULE_SOFTDEP("pre: nls");
> -MODULE_SOFTDEP("pre: aes");
> -MODULE_SOFTDEP("pre: cmac");
> -MODULE_SOFTDEP("pre: sha256");
> -MODULE_SOFTDEP("pre: sha512");
> -MODULE_SOFTDEP("pre: aead2");
> -MODULE_SOFTDEP("pre: ccm");
> +MODULE_SOFTDEP("pre: arc4 des ecb hmac md4 md5 nls aes cmac sha256 sha512 aead2 ccm");
>  module_init(init_cifs)
>  module_exit(exit_cifs)
> --------8<--------------
> 
> I guess we could actually implement additive deps, e.g. by using
> "pre+:" or something else. But I think the right thing to do for now is
> to apply something like above to cifs and propagate it to stable.

Patch looks sane, thanks.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

Are you going to submit it or should I?

Alternatively the initial patch could be reverted, depending on the
answer to my question above.

-- 
Jean Delvare
SUSE L3 Support
