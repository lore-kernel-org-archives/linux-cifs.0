Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC743C43334
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Jul 2022 03:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiGWDft (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Jul 2022 23:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiGWDfs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Jul 2022 23:35:48 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75ABEE01
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jul 2022 20:35:46 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id y129so2827095vkg.5
        for <linux-cifs@vger.kernel.org>; Fri, 22 Jul 2022 20:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Cp9UMD5+7qemE+JawWFTiG1mLYSMzi88RWbuLwL1HE=;
        b=afWizpMkOwcTmhkFd8kIHel37hQJOZsnjrI9KwKVASBmkiurOdBS0rdWhIZHQMiUSP
         dlbOHZhRYnpVGn8T0QRdgh09di3N2LbAK+fg50nZQVg7RLYRsyYvFwfzi3VwfeXRXQ/K
         3pUzetrLy5fGBt/Jr1Mse/sQwpjF/hs3EujIneuDkCVpaO6zc/I4mKVZdrMytFEl0TrA
         cbwKhXjTQaePlOjGkYEV2tgDSvMK+k7tvlv/DKgfjTUg5bVVuUlhYqUcy0E+OaXyBE9S
         Sl89uAm5DwCBHY7Zx5i82C+VnmYlGVETFsMlyJQXlACCiFmBeeLD4QVsGLy6yBG9smUN
         Q8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Cp9UMD5+7qemE+JawWFTiG1mLYSMzi88RWbuLwL1HE=;
        b=uTMsIJb4mdPxW9L/Mtx75tLZ+YsbnEFW/qRmo7q8rA3JBV/Qrc9d9cDwQo4XjTWnU6
         Z8SsmfJL5Nmd8lr5e++O5W6/6/fmpa37DxDwCkcEXcK79Lyli7Mxk8AF2BUwD+7SSQHJ
         Z4DXMviuDx1LFbqcSOwjA77/nMDS6ZCwmc+mPtyKMAsMpzEQsf18XyYIsWhuGMvk3aKD
         M5wCpSvqtI165mF3OPxLVmXTSNSfbku+1328I5u72NsQtZCG7jqjQB18stSm5VZsZFc/
         4DPmCCn5Mf5GSPsPg75QgOnEPwp7AATk8RmbBJAi0eF7krqJG00TMHOa7ea1y0BqgNrK
         X9WA==
X-Gm-Message-State: AJIora8J/8nW9KTgoBm9BSQxvyPft/dot0U1XhlgNkfoQHR0JthlZa9x
        R2Km9CSnZCmx/4XnPaUXwiNaBksp4bgJh+OhgEg=
X-Google-Smtp-Source: AGRyM1utL0VclS38KbKbFpZv7badll3wHyZRY+oG/M8Z269jLTB8MPzE5slEOVV3Rk643/cb0yv+S1Ox5vfKagWcgwo=
X-Received: by 2002:a05:6122:16a7:b0:374:ba7f:7f15 with SMTP id
 39-20020a05612216a700b00374ba7f7f15mr851066vkl.3.1658547345594; Fri, 22 Jul
 2022 20:35:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220722224254.8738-1-ematsumiya@suse.de> <20220722224254.8738-2-ematsumiya@suse.de>
In-Reply-To: <20220722224254.8738-2-ematsumiya@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 22 Jul 2022 22:35:34 -0500
Message-ID: <CAH2r5muegxbG2E0SEYZOMOEei9GOwndOMsTkivATErsQsJ5hmw@mail.gmail.com>
Subject: Re: [PATCH 2/4] cifs: standardize SPDX header comment
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Interesting question whether one format is better than the other but
"// SPDX ..." is used more frequently.  In the fs directory

// SPDX ...   is used 1255 times
/* SPDX ... is used 480 times
and other are used 164 times

Is there any style recommendation on this in kernel Documentation
directory etc.?

On Fri, Jul 22, 2022 at 5:43 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> Use "//" comments for SPDX header since it seems to be most common (at
> least among kernel files) than the "/* ... */" variant.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/cifs_fs_sb.h   | 2 +-
>  fs/cifs/cifs_ioctl.h   | 2 +-
>  fs/cifs/cifs_spnego.h  | 2 +-
>  fs/cifs/cifs_swn.h     | 2 +-
>  fs/cifs/cifs_unicode.h | 2 +-
>  fs/cifs/cifs_uniupr.h  | 2 +-
>  fs/cifs/cifsacl.h      | 2 +-
>  fs/cifs/cifsfs.h       | 2 +-
>  fs/cifs/cifsglob.h     | 3 +--
>  fs/cifs/cifspdu.h      | 2 +-
>  fs/cifs/dfs_cache.h    | 2 +-
>  fs/cifs/dns_resolve.h  | 2 +-
>  fs/cifs/fs_context.h   | 2 +-
>  fs/cifs/fscache.h      | 2 +-
>  fs/cifs/netlink.h      | 2 +-
>  fs/cifs/nterr.h        | 2 +-
>  fs/cifs/ntlmssp.h      | 2 +-
>  fs/cifs/rfc1002pdu.h   | 2 +-
>  fs/cifs/smb2glob.h     | 2 +-
>  fs/cifs/smb2pdu.h      | 2 +-
>  fs/cifs/smb2proto.h    | 2 +-
>  fs/cifs/smb2status.h   | 2 +-
>  fs/cifs/smbdirect.h    | 2 +-
>  fs/cifs/smberr.h       | 2 +-
>  fs/cifs/trace.h        | 2 +-
>  25 files changed, 25 insertions(+), 26 deletions(-)
>
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index 013a4bd65280..7317534ac410 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *
>   *   Copyright (c) International Business Machines  Corp., 2002,2004
> diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
> index 03e6531998b0..bf2850b54f3b 100644
> --- a/fs/cifs/cifs_ioctl.h
> +++ b/fs/cifs/cifs_ioctl.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *
>   *   Structure definitions for io control for cifs/smb3
> diff --git a/fs/cifs/cifs_spnego.h b/fs/cifs/cifs_spnego.h
> index 7f102ffeb675..3819940e2ab5 100644
> --- a/fs/cifs/cifs_spnego.h
> +++ b/fs/cifs/cifs_spnego.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *   SPNEGO upcall management for CIFS
>   *
> diff --git a/fs/cifs/cifs_swn.h b/fs/cifs/cifs_swn.h
> index 8a9d2a5c9077..934cbd7bb3ce 100644
> --- a/fs/cifs/cifs_swn.h
> +++ b/fs/cifs/cifs_swn.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Witness Service client for CIFS
>   *
> diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
> index 80b3d845419f..9bad387d2bff 100644
> --- a/fs/cifs/cifs_unicode.h
> +++ b/fs/cifs/cifs_unicode.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0-or-later */
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   * cifs_unicode:  Unicode kernel case support
>   *
> diff --git a/fs/cifs/cifs_uniupr.h b/fs/cifs/cifs_uniupr.h
> index 7b272fcdf0d3..529bd690fd91 100644
> --- a/fs/cifs/cifs_uniupr.h
> +++ b/fs/cifs/cifs_uniupr.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0-or-later */
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   *   Copyright (c) International Business Machines  Corp., 2000,2002
>   *
> diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
> index f7037fd03886..6c051b3ae922 100644
> --- a/fs/cifs/cifsacl.h
> +++ b/fs/cifs/cifsacl.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *
>   *   Copyright (c) International Business Machines  Corp., 2007
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index d7f4917c191d..deef6c8d0dc3 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *
>   *   Copyright (c) International Business Machines  Corp., 2002, 2007
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 721799b9a7a9..65c7e5b55278 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1,6 +1,5 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
> - *
>   *   Copyright (C) International Business Machines  Corp., 2002,2008
>   *   Author(s): Steve French (sfrench@us.ibm.com)
>   *              Jeremy Allison (jra@samba.org)
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index d869e1ed3648..d3c5e3d23385 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *
>   *   Copyright (c) International Business Machines  Corp., 2002,2009
> diff --git a/fs/cifs/dfs_cache.h b/fs/cifs/dfs_cache.h
> index 52070d1df189..490aa28eec38 100644
> --- a/fs/cifs/dfs_cache.h
> +++ b/fs/cifs/dfs_cache.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * DFS referral cache routines
>   *
> diff --git a/fs/cifs/dns_resolve.h b/fs/cifs/dns_resolve.h
> index afc0df381246..5a617278a669 100644
> --- a/fs/cifs/dns_resolve.h
> +++ b/fs/cifs/dns_resolve.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *   DNS Resolver upcall management for CIFS DFS
>   *   Handles host name to IP address resolution
> diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
> index 5f093cb7e9b9..ec4a8af72570 100644
> --- a/fs/cifs/fs_context.h
> +++ b/fs/cifs/fs_context.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0-or-later */
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   *   Copyright (C) 2020, Microsoft Corporation.
>   *
> diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
> index aa3b941a5555..435e826fdd9a 100644
> --- a/fs/cifs/fscache.h
> +++ b/fs/cifs/fscache.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *   CIFS filesystem cache interface definitions
>   *
> diff --git a/fs/cifs/netlink.h b/fs/cifs/netlink.h
> index e2fa8ed24c54..8c4e680eb41f 100644
> --- a/fs/cifs/netlink.h
> +++ b/fs/cifs/netlink.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Netlink routines for CIFS
>   *
> diff --git a/fs/cifs/nterr.h b/fs/cifs/nterr.h
> index edd4741cab0a..0a35538dd338 100644
> --- a/fs/cifs/nterr.h
> +++ b/fs/cifs/nterr.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0-or-later */
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>     Unix SMB/Netbios implementation.
>     Version 1.9.
> diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
> index 55758b9ec877..7a00acffa6ea 100644
> --- a/fs/cifs/ntlmssp.h
> +++ b/fs/cifs/ntlmssp.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *
>   *   Copyright (c) International Business Machines  Corp., 2002,2007
> diff --git a/fs/cifs/rfc1002pdu.h b/fs/cifs/rfc1002pdu.h
> index ae1d025da294..b32940b2b2bf 100644
> --- a/fs/cifs/rfc1002pdu.h
> +++ b/fs/cifs/rfc1002pdu.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *
>   *   Protocol Data Unit definitions for RFC 1001/1002 support
> diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
> index 82e916ad167c..c240ce7bc0ed 100644
> --- a/fs/cifs/smb2glob.h
> +++ b/fs/cifs/smb2glob.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *
>   *   Definitions for various global variables and structures
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index 286044850e85..8cad2a5c516b 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *
>   *   Copyright (c) International Business Machines  Corp., 2009, 2013
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index a69f1eed1cfe..c210e1221c9a 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *
>   *   Copyright (c) International Business Machines  Corp., 2002, 2011
> diff --git a/fs/cifs/smb2status.h b/fs/cifs/smb2status.h
> index a9e958166fc5..283bef0ae839 100644
> --- a/fs/cifs/smb2status.h
> +++ b/fs/cifs/smb2status.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *
>   *   SMB2 Status code (network error) definitions
> diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
> index a87fca82a796..f7b98793c664 100644
> --- a/fs/cifs/smbdirect.h
> +++ b/fs/cifs/smbdirect.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0-or-later */
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   *   Copyright (C) 2017, Microsoft Corporation.
>   *
> diff --git a/fs/cifs/smberr.h b/fs/cifs/smberr.h
> index aeffdad829e2..1d96335a046c 100644
> --- a/fs/cifs/smberr.h
> +++ b/fs/cifs/smberr.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: LGPL-2.1 */
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   *
>   *   Copyright (c) International Business Machines  Corp., 2002,2004
> diff --git a/fs/cifs/trace.h b/fs/cifs/trace.h
> index 6b88dc2e364f..7b9a85f5b93c 100644
> --- a/fs/cifs/trace.h
> +++ b/fs/cifs/trace.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   *   Copyright (C) 2018, Microsoft Corporation.
>   *
> --
> 2.35.3
>


-- 
Thanks,

Steve
