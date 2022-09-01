Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4743ECAAD2
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 21:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiIAVs7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 17:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbiIAVs4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 17:48:56 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C365E7A506
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 14:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=WLSTeSHg8wUjzoSKRGIBKPiauwGoF4zOR0rkYtxmwsU=; b=pPK4u8/XlmNehSI3ulluL0KqBH
        uPlGojrD+Npvm+MEkIDMPkdDchM2RS8jAeJXsZY8Vo2ERb1oGTg+tD7ToA5lL2vUD9boNZcWDuk8n
        PHXnBGCRn9D3brYRWMOA+ffqUU//pWgIgAt/hr99vdpe4mkPPoZztV7vc4PvJ6T6Li1en6Z8/3qOf
        kmQcRHdYOFbE6AJk534e9LV1KYHu2tVIGV04ht+OLYZm5Z+ZONWS49FqC/TkhdDnFzKMA6YhvViNt
        vosm4ituLBkEjrjeu4TvSbktd4azHDHEHkB+xDjHCcMTXEFOb8MNsbLCrzUSS1PTS0oFYEIKI/TXM
        xIexy9PW9hheQS3Tcl9SNG1mww5IpMS8i/joof2TYVI3Wa4shaLLarL9MY8P/NDxMvUfDbsygG18x
        PXdValPlumKofS0wFDjn/DGore4/bfb4weSQYrnD+HHCwuXZQXgHErUExAvBfS7+J2VGxKLz3LFW3
        njzbTwo9SO+Qyjlu0itFHZWR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oTs3I-002hZK-Uu; Thu, 01 Sep 2022 21:48:45 +0000
Date:   Thu, 1 Sep 2022 14:48:39 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        atheik <atteh.mailbox@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Message-ID: <YxEot6I5d4PWtrz9@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <YxDaZxljVqC/4Riu@jeremy-acer>
 <20220901174108.24621-1-atteh.mailbox@gmail.com>
 <YxD6SEN9/3rEWaNR@jeremy-acer>
 <CAN05THRgWMEejOMTozrf0F4sENxJEQYu2i-9CKWO+Qh0kvjveg@mail.gmail.com>
 <CAH2r5mvUzbp8RcM7+XFbJsoiba964vpKQiMRmGeQovGabe+j=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mvUzbp8RcM7+XFbJsoiba964vpKQiMRmGeQovGabe+j=Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 01, 2022 at 04:37:21PM -0500, Steve French wrote:
>
>I do like that Namjae et al made the format of the .conf file very similar
>to the format of Samba's smb.conf file though.   I realize there some
>users complain that there are too many smb.conf parameters for Samba,
>but he seemed to pick a reasonably subset of them for ksmbd.
>Samba is a much larger project with many more smb.conf parameters
>but it does reduce confusion making the parameter names similar
>where possible e.g. "workgroup", "guest account", (share) path, read only, etc.
>and fortunately the default directories for the two smb.conf files are
>different so at least the daemons don't use the same file.

Sure, I think the formats and parameter names being as close
as possible is a great idea to allow users to move between
servers as they wish. But making the files the same name
is not a good idea.
