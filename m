Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E58C433DB
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Jan 2021 01:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2745D2078E
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Jan 2021 01:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbhACBWE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Jan 2021 20:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbhACBWE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Jan 2021 20:22:04 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24043C061573
        for <linux-cifs@vger.kernel.org>; Sat,  2 Jan 2021 17:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=AmrtMhwOE08jj+9ACyWNKhbh+Veh3K5d8FAJN7NwnDs=; b=C9H+ijbMp4XiAzhFLjzf1mGgq9
        lRyTDY/wt9MTYJ30lai9hGem7MV59yklm0TX21ir1sTUSX64w8DazHCYz9UKeAfHkmvVNxwBy4i4n
        9durNxZiDnP6eSRJley2DwuA97UaLzeUDUcyCKtC0MAwka12V4wwoQ7mJit8cz1i9sCzSiGLxiGdU
        hScwdePOMjSaok9Um2/mP83U9NAwZXCKvIK8fAVF+fMbHGF/VEvSw2iPo4BG0ZTi/MmRcxwanZGWf
        tb2r/wqldkXdyud41CHWFKOnCQxJenWDxTyWCRedPpacHdG9YHcJcumZqJXlL2ROfVs+0XYTmkiVX
        SiJPF4dcrvxVpz7ONn34lTgyQpKSbbj0PVXe0WcqrhksbkAoZWdDsPCUAtbCOGTqcu8DXL6flc/GI
        ZcRvxItYylS7QxVqQwu3cE/muoB0yTdGbg5zo7v+gq27kHmm3VK0Ow8uwWJIpRhwGexa1Vc+EOqUn
        jUH03KPzwyFv1n0SP9thMeE7;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kvs58-00052J-Tp; Sun, 03 Jan 2021 01:21:19 +0000
Date:   Sat, 2 Jan 2021 17:21:16 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Xiaoli Feng <xifeng@redhat.com>, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH][SMB3] allow files to be created with backslash in file
 name
Message-ID: <20210103012116.GA117067@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5msH3LZuF69UFcfgtG7XXurMDc=-Ab7Ct4XwfARR8d+wRA@mail.gmail.com>
 <20210101060050.GA1892237@jeremy-acer>
 <CAH2r5mt+5LQB59w0SPEp2Q-9ZZ2PV=XDMtGpy2pedhF8eKif0A@mail.gmail.com>
 <20210101195821.GA41555@jeremy-acer>
 <CAH2r5mvt_cHDbT0xaeLNQn=5cQ0T2-wPgpMkYEGQNdtDZ3kP=A@mail.gmail.com>
 <20210102025837.GA61433@jeremy-acer>
 <CAH2r5ms1V2KKb6T3ELQ-JsQ3fniOScTE2654_xLwnPruiekzEw@mail.gmail.com>
 <20210102052524.GA67422@jeremy-acer>
 <CAH2r5msZt0UZG5r5Z7=_jQf=-xgNz8zW7fZOnqncqeJHB=mOmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5msZt0UZG5r5Z7=_jQf=-xgNz8zW7fZOnqncqeJHB=mOmA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Jan 02, 2021 at 06:19:39PM -0600, Steve French wrote:
>I agree with the idea of being safe (in the smbclient in this case),
>and not returning potentially dangerous file names (even if a very
>remote danger to the tool, smbclient in this case), but I am not
>convinced that the "user friendly" behavior is to reject the names
>with the rather confusing message - especially as it would mean that
>inserting a single file with an odd name into a server could make the
>whole share unusable for smbclient (e.g. in a backup scenario).  I
>agree with rejecting (or perhaps better skipping) it, but ... not sure
>any user would understand what SMBecho has to do with a server file
>name.

Dropping the connection on receipt of an invalid
name is the only safe response. We know the server
is insane and dangerous at that point and sending
invalid protocol responses.

Safer not to continue.

>"NT_STATUS_INVALID_NETWORK_RESPONSE listing \*
>smb: \> SMBecho failed (NT_STATUS_CONNECTION_DISCONNECTED). The
>connection is disconnected now"

The SMBecho is due to the keepalive failing once
the connection was dropped.
