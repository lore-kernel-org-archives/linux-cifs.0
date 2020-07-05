Return-Path: <SRS0=fV/L=AQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF3DC433DF
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Jul 2020 20:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22FC02073E
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Jul 2020 20:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgGEUZH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 Jul 2020 16:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbgGEUZH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 5 Jul 2020 16:25:07 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F3AC061794;
        Sun,  5 Jul 2020 13:25:07 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 309A42E4;
        Sun,  5 Jul 2020 20:25:07 +0000 (UTC)
Date:   Sun, 5 Jul 2020 14:25:06 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace HTTP links with HTTPS ones: CIFS
Message-ID: <20200705142506.1f26a7e0@lwn.net>
In-Reply-To: <20200627103125.71828-1-grandmaster@al2klimov.de>
References: <20200627103125.71828-1-grandmaster@al2klimov.de>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, 27 Jun 2020 12:31:25 +0200
"Alexander A. Klimov" <grandmaster@al2klimov.de> wrote:

> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
>           If both the HTTP and HTTPS versions
>           return 200 OK and serve the same content:
>             Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>

Applied but...

> ---
>  If there are any URLs to be removed completely or at least not HTTPSified:
>  Just clearly say so and I'll *undo my change*.
>  See also https://lkml.org/lkml/2020/6/27/64
> 
>  If there are any valid, but yet not changed URLs:
>  See https://lkml.org/lkml/2020/6/26/837
> 
>  Documentation/admin-guide/cifs/todo.rst            | 2 +-
>  Documentation/admin-guide/cifs/usage.rst           | 6 +++---
>  Documentation/admin-guide/cifs/winucase_convert.pl | 2 +-
>  fs/cifs/cifsacl.c                                  | 4 ++--
>  fs/cifs/cifsglob.h                                 | 2 +-
>  fs/cifs/winucase.c                                 | 2 +-
>  6 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cifs/todo.rst b/Documentation/admin-guide/cifs/todo.rst
> index 084c25f92dcb..25f11576e7b9 100644
> --- a/Documentation/admin-guide/cifs/todo.rst
> +++ b/Documentation/admin-guide/cifs/todo.rst
> @@ -98,7 +98,7 @@ x) Finish support for SMB3.1.1 compression
>  Known Bugs
>  ==========
>  
> -See http://bugzilla.samba.org - search on product "CifsVFS" for
> +See https://bugzilla.samba.org - search on product "CifsVFS" for
>  current bug list.  Also check http://bugzilla.kernel.org (Product = File System, Component = CIFS)
>  
>  1) existing symbolic links (Windows reparse points) are recognized but
> diff --git a/Documentation/admin-guide/cifs/usage.rst b/Documentation/admin-guide/cifs/usage.rst
> index d3fb67b8a976..4abaea40dfd1 100644
> --- a/Documentation/admin-guide/cifs/usage.rst
> +++ b/Documentation/admin-guide/cifs/usage.rst
> @@ -17,7 +17,7 @@ standard for interoperating between Macs and Windows and major NAS appliances.
>  Please see
>  MS-SMB2 (for detailed SMB2/SMB3/SMB3.1.1 protocol specification)
>  http://protocolfreedom.org/ and

...it only took a cursory check to see that this is a spam site.  A patch
that claims to improve security should surely take something like that
out.  I guess I'll add a patch doing that now...

jon
