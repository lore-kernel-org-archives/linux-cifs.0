Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0360C4708C
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Dec 2022 14:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbiLFO7v (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Dec 2022 09:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiLFO6l (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Dec 2022 09:58:41 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805D72FFF7
        for <linux-cifs@vger.kernel.org>; Tue,  6 Dec 2022 06:51:54 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id x11so17484597ljh.7
        for <linux-cifs@vger.kernel.org>; Tue, 06 Dec 2022 06:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+c8r9/oIt50HC1wYqsQEflGL3D83a+hq7Wa/m7aZeeY=;
        b=DqAQCaMBLr8JlEoTNR3xKiOTqEYAXX1FVcPv7Out7W5CzTaZC72nCKbMe9DWKB/V/p
         yM1gntmsSEMFMz3phuGvPPDRWw2EagzvKGzjBbL+e6KwBnEZaQCSNFAlcHnYXhzLEo4P
         OoBrjAeKfeHbmJO4nElGme+U/ZbedJaI1tPw3crfIOf7GkmLJn5n1xnLXCUihZsm5vN8
         nz0WJvohlmKP0wMcoImPZurmBbsp3Jqlp8eJqB3pt0eyfAY1LZrTfPcVHjnPZWIMpR1U
         uIMljITRcL1Cn6Wm6V1NcYMOnWDLQdxu1Em0QK33QkVOeRnCTcqDlpJN1nDxC1FcAuJH
         3HNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+c8r9/oIt50HC1wYqsQEflGL3D83a+hq7Wa/m7aZeeY=;
        b=1+frP0YHcjF57DiBPneG54GnKmLq4hWyXrQFC/xuf1bqjiwZw6y9BJL3ixRdEFCNuL
         7k6PuegOAThMfJeYRzlLirsAr0IVmq8OtMJGIOKbUAmvCCgzJ9kiTQeyDcRuYGn1gXFB
         4VoNEYpsw6kO/rkvxxVii1212tLy4zOOwIf5IF03pg8v7yFy2MqVuRGz7gMOsVgdY4eO
         2RyPXJyRQ4yLKfN4F0UF9XN2hiybIN/N2O628cjLmgmSLSVEGVNbWnvkgXfk36cjEsmI
         vRooFjXQjYfiVjPKPUyXKqes5I0xmPZgJOIwTg3XgOS97MoP6iHfEfeAV7Ms9HjiXhaW
         VJ7Q==
X-Gm-Message-State: ANoB5pl1Ir5FzFhbercoMIXpjlwscrrma/+2tfvH3WaP13o3VOdGFYOV
        mcweWoKhenL1Efm7H/GxUcxP2RyhAogqWILrVDU=
X-Google-Smtp-Source: AA0mqf5mxr0kaG2P9ih3iG5KC/btRmXOc8R7RI0wvfkVEv5gxA9Ug7a5PA4i9/JLGTi7sE76Ji09E5ARVqV7qPs0p2s=
X-Received: by 2002:a05:651c:12c1:b0:277:2fd5:482 with SMTP id
 1-20020a05651c12c100b002772fd50482mr23681476lje.194.1670338312401; Tue, 06
 Dec 2022 06:51:52 -0800 (PST)
MIME-Version: 1.0
References: <184e5d5c395.e6da05c53387741.2839551941271541423@elijahpepe.com>
In-Reply-To: <184e5d5c395.e6da05c53387741.2839551941271541423@elijahpepe.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 6 Dec 2022 08:51:40 -0600
Message-ID: <CAH2r5mvhP=Sh1Y0YKwHbChdu-oisfT05D6_XF95kGtfE+Vcaaw@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: add ipv6 parsing
To:     Elijah Conners <business@elijahpepe.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        lsalhber <lsalhber@redhat.com>, tom <tom@talpey.com>,
        pc <pc@cjr.nz>, sfrench <sfrench@samba.org>,
        sprasad <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Can you fix the whitespace error and make sure it merges (cifsroot.c
hasn't changed in over a year so should be easy). I got this error
when trying to apply the patch.

Applying: cifs: add ipv6 parsing
.git/rebase-apply/patch:26: trailing whitespace.
{
error: fs/cifs/cifsroot.c: does not match index
Patch failed at 0001 cifs: add ipv6 parsing

On Mon, Dec 5, 2022 at 11:25 PM Elijah Conners <business@elijahpepe.com> wrote:
>
> CIFS currently lacks IPv6 parsing, presenting complications for CIFS
> over IPv6.
>
> To parse both IPv4 and IPv6 addresses, the parse_srvaddr() function
> was altered; parse_srvaddr() now returns void. To retrieve the IP
> address from parse_srvaddr(), the parameters *out6 and *out32, an
> in6_addr and a __be32 respectively, are provided. The value of
> root_server_addr is determined by if those parameters are set or not.
>
> The parsing in parse_srvaddr() was updated slightly. The character addr
> can hold up to 46 characters, the longest a possible IPv6 address can
> be. In the while loop, isdigit() has been replaced with isxdigit() to
> account for letters present in IPv6 addresses, and *start is also
> checked for being a colon. Finally, the function uses inet_pton() to
> determine if the address is an IPv6 address; if so, *out6 is equal to
> in6, set by inet_pton, otherwise, *out32 is set to in_aton(addr).
>
> Signed-off-by: Elijah Conners <business@elijahpepe.com>
> ---
>  fs/cifs/cifsroot.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
>
> diff --git a/fs/cifs/cifsroot.c b/fs/cifs/cifsroot.c
> index 9e91a5a40aae..0246e0792d8e 100644
> --- a/fs/cifs/cifsroot.c
> +++ b/fs/cifs/cifsroot.c
> @@ -14,6 +14,7 @@
>  #include <linux/in.h>
>  #include <linux/inet.h>
>  #include <net/ipconfig.h>
> +#include <arpa/inet.h>
>
>  #define DEFAULT_MNT_OPTS \
>         "vers=1.0,cifsacl,mfsymlinks,rsize=1048576,wsize=65536,uid=0,gid=0," \
> @@ -22,19 +23,24 @@
>  static char root_dev[2048] __initdata = "";
>  static char root_opts[1024] __initdata = DEFAULT_MNT_OPTS;
>
> -static __be32 __init parse_srvaddr(char *start, char *end)
> -{
> -       /* TODO: ipv6 support */
> -       char addr[sizeof("aaa.bbb.ccc.ddd")];
> +static void __init parse_srvaddr(char *start, char *end, struct in6_addr *out6, __be32 *out32)
> +{
> +       char addr[INET6_ADDRSTRLEN];
> +       struct in6_addr in6;
>         int i = 0;
>
>         while (start < end && i < sizeof(addr) - 1) {
> -               if (isdigit(*start) || *start == '.')
> +               if (isxdigit(*start) || *start == '.' || *start == ':')
>                         addr[i++] = *start;
>                 start++;
>         }
>         addr[i] = '\0';
> -       return in_aton(addr);
> +
> +       if (inet_pton(AF_INET6, addr, &in6) > 0) {
> +               *out6 = in6;
> +       } else {
> +               *out32 = in_aton(addr);
> +       }
>  }
>
>  /* cifsroot=//<server-ip>/<share>[,options] */
> @@ -42,7 +48,8 @@ static int __init cifs_root_setup(char *line)
>  {
>         char *s;
>         int len;
> -       __be32 srvaddr = htonl(INADDR_NONE);
> +       struct in6_addr addr6;
> +       __be32 addr32;
>
>         ROOT_DEV = Root_CIFS;
>
> @@ -60,7 +67,7 @@ static int __init cifs_root_setup(char *line)
>                         return 1;
>                 }
>                 strlcpy(root_dev, line, len);
> -               srvaddr = parse_srvaddr(&line[2], s);
> +               parse_srvaddr(&line[2], s, &addr6, &addr32);
>                 if (*s) {
>                         int n = snprintf(root_opts,
>                                          sizeof(root_opts), "%s,%s",
> @@ -73,7 +80,11 @@ static int __init cifs_root_setup(char *line)
>                 }
>         }
>
> -       root_server_addr = srvaddr;
> +       if (addr6.is_set) {
> +               root_server_addr = addr6;
> +       } else if (addr32.is_set) {
> +               root_server_addr = addr32;
> +       }
>
>         return 1;
>  }
> --
> 2.29.2.windows.2
>
>


-- 
Thanks,

Steve
