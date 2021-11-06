Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F34DC433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Nov 2021 01:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D73C8610D0
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Nov 2021 01:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhKFBlj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Nov 2021 21:41:39 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34704 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhKFBli (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Nov 2021 21:41:38 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6795F21892;
        Sat,  6 Nov 2021 01:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636162737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YgbiPkB9bW8DISAvBknITOcuboGK+jFBaoaot8mDxTE=;
        b=RpZlfVbJz5OtDpoknfaGw6rUgdMm2U4YwCSVxfVBpjCXI9E+yOkg8QIBdCs712JtdpAlhD
        eXswuCNKAo2I6+6RtnkAx24r6BvW8RqqeXio7WlWucoSMRoj9z7EH5z80gFfNY3U9JQyD9
        ZwjE8ECrSPyAMozmFw6xpFI02JHks60=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636162737;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YgbiPkB9bW8DISAvBknITOcuboGK+jFBaoaot8mDxTE=;
        b=f1AL47Ku+Z3KR4CZg+l9Zr/dQmcsDoyy+KGRaO7UtXwXmXCn1uZOVla7Kq5ZahE4cGzBMg
        62kUWz9jjvNT9bBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D427C13C71;
        Sat,  6 Nov 2021 01:38:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nFlrJLDchWFkDQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sat, 06 Nov 2021 01:38:56 +0000
Date:   Fri, 5 Nov 2021 22:38:54 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH] cifs: send workstation name during ntlmssp session setup
Message-ID: <20211106013854.6qx3tz53pvayqcgm@cyberdelia>
References: <CANT5p=rgHn59NVvH32FSKtNv_cyKi4ATSAExBmWT_qjb7km7Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANT5p=rgHn59NVvH32FSKtNv_cyKi4ATSAExBmWT_qjb7km7Fw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

I have some observations/suggestions regarding your patch:

On 11/06, Shyam Prasad N wrote:
>Hi Steve,
>
>Please review this patch, and let me know what you think.
>Having this info in the workstation field of session setup helps
>server debugging in two ways.
>1. It helps identify the client by node name.
>2. It helps get the kernel release running on the client side.
>
>https://github.com/sprasad-microsoft/smb3-kernel-client/commit/d988e704dd9170c19ff94d9421c017e65dbbaac1.patch

- AFAICS it doesn't consider runtime hostname changes. Is it important
   to keep track of it? Would changing it mid-auth steps break it
   somehow?

- I didn't understand the purpose of CIFS_DEFAULT_WORKSTATION_NAME. Why
   not simply use utsname()->nodename? Or even init_utsname()->nodename, which
   is supposed to be always valid.

- Ditto for CIFS_MAX_WORKSTATION_LEN. utsname()->nodename has at most 65
   bytes (__NEW_UTS_LEN + 1) anyway. Perhaps using MAXHOSTNAMELEN from
   <asm/param.h> would be a more generic approach.
   (btw this is because nodename is the unqualified hostname, sans-domain)

- Instead of setting workstation_name to "nodename:release", why not
   implement the VERSION structure (MS-NLMP 2.2.2.10)? Then use
   LINUX_VERSION_* from <linux/version.h> or parse utsname()->release.

>I ran some basic testing with the patch. Seems to serve the purpose.
>Please let me know if I'm missing something.

I hope I didn't miss anything.


Cheers,

Enzo
