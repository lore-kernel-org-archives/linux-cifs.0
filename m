Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82ABC433DB
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jan 2021 06:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 679F4221EC
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jan 2021 06:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbhAAGBj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Jan 2021 01:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbhAAGBj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Jan 2021 01:01:39 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDA4C061573
        for <linux-cifs@vger.kernel.org>; Thu, 31 Dec 2020 22:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=olcpllrnDpJpxDNEbWl///p/trRno4ECZCntLhEm/mo=; b=RgsCtALdN7VoRey/j/TCf4xcUe
        +ZJ2NzaOnck75bobdrpScDFHGttmBV+O/hfizGDFpUz0xgD8iAP6gitPyyyOve1+QzjOyNO0RivB+
        h4FOwHIglm2LTK/Y08XkM23vi3SCDJ0++5QFzIEsgpY8da4XSbeErsO/GBvS2IlAKGF4A8wdkZcAc
        oXKW129KLq0bHWXIc3sBLcnz7970Cx+G0FHKCYGTekaWiQO9iGfp3dd0lENgm6m+0jgVsoib27eR9
        0S6+uSTH3buCsoTrTJx3c5fiaeP70S0qeMksM8a6FWIN5TwLkQb5UsjG28lvtI1QwMAuMnpvQ4uw8
        xYLDLZ79zblETmc1WV3TXUQFB+szKyO4MuyG2LFIF71Fk20y7NYBCb2+eqnraZDTgzJcJRdv6YdiW
        PU/rOn0leh8tz60C1wrLYwbTNZYY+9erd7MhQARy2XuYpj5HKqKWsJ8nBneP+jodMC0MhT58azrb4
        cDnvPIyIR/utoxaUGvtvjUp1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kvDUb-0001k6-3w; Fri, 01 Jan 2021 06:00:53 +0000
Date:   Thu, 31 Dec 2020 22:00:50 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Xiaoli Feng <xifeng@redhat.com>, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH][SMB3] allow files to be created with backslash in file
 name
Message-ID: <20210101060050.GA1892237@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5msH3LZuF69UFcfgtG7XXurMDc=-Ab7Ct4XwfARR8d+wRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5msH3LZuF69UFcfgtG7XXurMDc=-Ab7Ct4XwfARR8d+wRA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Dec 31, 2020 at 09:35:23PM -0600, Steve French via samba-technical wrote:
>
>This patch may be even more important to Samba, as alternative ways of
>storing these files can create more problems. Interestingly Samba
>server reports local files with backslashes in them over the wire
>without remapping, even though these are illegal in SMB3 which would
>cause confusion on the client(s).  Has anyone tried Windows mounting

Samba should mangle names containing '\' to 8.3 names.

The code in is_legal_name() should catch names containing
'\' and report them as needing mapping to 8.3.

Indeed if I check this locally with smbclient I get
(for a share containing a file created with:

$ touch 'file with \ in it'

I see the file:

FI32YH~P

listed from smbclient -mSMB3

Check how you have Samba configured Steve.
