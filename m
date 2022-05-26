Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1019C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 26 May 2022 19:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348719AbiEZTTi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 May 2022 15:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348826AbiEZTTh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 May 2022 15:19:37 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090E5DFF5C
        for <linux-cifs@vger.kernel.org>; Thu, 26 May 2022 12:19:32 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id j7so2307619vsj.7
        for <linux-cifs@vger.kernel.org>; Thu, 26 May 2022 12:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6H8M+dJbLsg681gd4VFEXYdOUk9KLH/hekrsqfZRUYo=;
        b=Rt3EwTmu2t/0Ib8cH1GzDaRddXX6iJQUmWNyj20YRxulU3SzPi5soIlEWLAKcXm0Z8
         zt/aVvk3GRglqEdGeegcQ9qNgWAe26RQRxDRtRlNRw+OCq99DlKlGEA9r+Sl6tCH9irM
         SWoP9rxbuuHaH2nGJaQ+sHO4NhOvFHNREO9BraK9rSj85T+oYqvjb+CZW8pOIpN0HcqK
         LFsX2qaDk0mvt9N2TNFthIYRKZUZnPkKJDpUYEAog4CcavM1OVpK2tEjhhgx0EusXUbR
         hoWtH+8fN/ZenTO3tLIsRGVhwwxPtakY9zncZOCjCiv0Pya2yXRaqli1/8ajANO/MMr4
         2ywg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6H8M+dJbLsg681gd4VFEXYdOUk9KLH/hekrsqfZRUYo=;
        b=kGdN0P3sELqCHDTNDeSNE5PlnShcUaIgqF2iyG6EkFuKhl94ZKQwM9pDbBSXFcDmnG
         avaaBMCai0O+P7TG2qSzYDGGsmkLXHaqj1PP4/2cVGwnOz8zufZVg45dR/X2hu4aivEI
         leZODFY9WEFjnoGoAlohMxf6dxffrZ6JJj00GEII+ediZ320SL3iSlsgKRwdLsZXmCcN
         RMeCLfNrwHDXOBhdPbPOxHHGCHc7ie6z04SxO3HhsmYJgHyalsR6VOWhNUL7Qq55cPUs
         hztwUTj85C0c96vBQ2OYYP+5Rd50ssoP4ILfR9Cz4ZU91uO+yAEa3Wdsm+eG6JEgKd7A
         7JTA==
X-Gm-Message-State: AOAM533ZqVQXt9+33z9TVsR4PpPR7wwvNPBpsOQidjb1mnUL/mj3fVoX
        YY9+hslALqXvTTpBQktT8gvcA0T6wcLkO5VwjL8=
X-Google-Smtp-Source: ABdhPJyn3+n2wizgqSGd290hZkOaBPzmYVSPFd3sNM8d5LscsX7OdxZ4NwQbkskNJvpPeYe7N3ea0qtmBwsQOtODtMQ=
X-Received: by 2002:a67:fe57:0:b0:335:ef50:1b94 with SMTP id
 m23-20020a67fe57000000b00335ef501b94mr14575071vsr.6.1653592771604; Thu, 26
 May 2022 12:19:31 -0700 (PDT)
MIME-Version: 1.0
References: <Yo9UiM/eFdyd3HZk@kili>
In-Reply-To: <Yo9UiM/eFdyd3HZk@kili>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 26 May 2022 14:19:20 -0500
Message-ID: <CAH2r5mt1WQ1aKBpv5Yus3TK3+EobknU=MOCbAieTsG3JZCYWxQ@mail.gmail.com>
Subject: Re: [bug report] cifs: cache the dirents for entries in a cached directory
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

That should be an unneeded check that causes that - had already fixed
this yesterday though

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=9f114d7bfc6c35ca23a82efce60e0db535a186f1

On Thu, May 26, 2022 at 1:31 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Ronnie Sahlberg,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch d87c48ce4d89: "cifs: cache the dirents for entries in a
> cached directory" from May 10, 2022, leads to the following Smatch
> complaint:
>
>     fs/cifs/readdir.c:1108 cifs_readdir()
>     warn: variable dereferenced before check 'cfid' (see line 1093)
>
> fs/cifs/readdir.c
>   1092           */
>   1093          if (cfid->dirents.is_valid) {
>   1094                  if (!dir_emit_dots(file, ctx)) {
>   1095                          mutex_unlock(&cfid->dirents.de_mutex);
>   1096                          goto rddir2_exit;
>   1097                  }
>   1098                  emit_cached_dirents(&cfid->dirents, ctx);
>   1099                  mutex_unlock(&cfid->dirents.de_mutex);
>   1100                  goto rddir2_exit;
>   1101          }
>   1102          mutex_unlock(&cfid->dirents.de_mutex);
>                              ^^^^^^^^
> The patch introduces these dereferences
>
>   1103
>   1104          /* Drop the cache while calling initiate_cifs_search and
>   1105           * find_cifs_entry in case there will be reconnects during
>   1106           * query_directory.
>   1107           */
>   1108          if (cfid) {
>                     ^^^^
> and the NULL check.
>
>   1109                  close_cached_dir(cfid);
>   1110                  cfid = NULL;
>
> regards,
> dan carpenter



-- 
Thanks,

Steve
