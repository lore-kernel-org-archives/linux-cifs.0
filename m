Return-Path: <SRS0=9U06=D6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65065C4363A
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 03:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0539720719
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 03:15:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dfaSF0bP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460332AbgJWDPH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Oct 2020 23:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S460330AbgJWDPH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Oct 2020 23:15:07 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19944C0613CE
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 20:15:07 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u19so200864ion.3
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 20:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7PzakwHfQTWhtL06XjXf5GbEZM4bdpOgEHF4utsyP/Y=;
        b=dfaSF0bP/teBvUOvcm3K6e8ZwRy5y2819A2zrUzxYHZhIFIEWTyrnoSM3bA0wZgbt8
         fTJGfxlwibps9mBucgNXI/efmJXGnwLBwVJvaY3UyOU13MMwUpEvsWs15fI7Mi/rHMnB
         RDcLnPoEP4szOGl3JuYbecPbcIksSzA8/DrBp7vaUBxl80MMEB30ymXhbB9FsVK8nYsL
         Jy9VRUc+e/ZWebXDtjzrA/igdwhBjIBJOX3QXZJenxaU+UZe4LiqtaYbQkVEPror29dx
         vwi+PS6O8uotWXCY9RyuK/+/SYGH3amTokVnIpEDNG/7bbZOBra/fq4yxKiBYCJH+eGL
         zLLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7PzakwHfQTWhtL06XjXf5GbEZM4bdpOgEHF4utsyP/Y=;
        b=SjhzHRYPyYKrcgPUFSw/hBuu5gvGA4BrTcKkcmuwMsChzrII6ay678n7ctIE+J1dvJ
         3yh+mCM8F29AC9chqHhD1V734fTXBme96OKoygTjLywrVdux4yqoOiTxeHmBfS7FXNSh
         KcRBJXr/npJIRJK0RHFnPrcPKDuA2rrD3Nj09nHxsN80B+kFu7RnDrO1LCYA+jtCC/Fg
         8ljI9nboGv5vjxgSDOlbmuI1rDCN0F048p6vJaN9eR8IpRawYmVpQI6yS4v5lxD4W8Nh
         YQLVOo2NJnYB8/iABpzRntZy8GPEodxgKO0iE0Wi9cKb3bnLnriepsj2Fvr5kbtmx5Fu
         jCTg==
X-Gm-Message-State: AOAM532EssbdfDtvj1GTPEVfs+0nQzRWjF3RzM1FuC/wKCo3cJFooOga
        EfS5nctGcGdOczvkCOBLBMqBefAU8K3kvsbGWPA=
X-Google-Smtp-Source: ABdhPJwzx2gsPC2sSvxmnXvqWi53Ls9oHA9X+xyH6xFILPIFZK/WhH/Ip08a3xkGL+nvRg0CqwSG6kQJTCoj/Y0Tz0Q=
X-Received: by 2002:a05:6638:20a:: with SMTP id e10mr399276jaq.20.1603422906501;
 Thu, 22 Oct 2020 20:15:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvWqz2bMX9ut0bT4ZQH8WQNAc8Cjg3bM1TKeXgzupOZMQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvWqz2bMX9ut0bT4ZQH8WQNAc8Cjg3bM1TKeXgzupOZMQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 23 Oct 2020 13:14:54 +1000
Message-ID: <CAN05THQyNC1N4Y6oZ84RgAfmBQ+2RE8+ppv4XaJxUQW_T-ZzNA@mail.gmail.com>
Subject: Re: [PATCH]SMB3] Add support for WSL reparse tags
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by me

Very good.

On Thu, Oct 22, 2020 at 3:02 PM Steve French via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> The IO_REPARSE_TAG_LX_ tags originally were used by WSL but they
> are preferred by the Linux client in some cases since, unlike
> the NFS reparse tag (or EAs), they don't require an extra query
> to determine which type of special file they represent.
>
> Add support for readdir to recognize special file types of
> FIFO, SOCKET, CHAR, BLOCK and SYMLINK.  This can be tested
> by creating these special files in WSL Linux and then
> sharing that location on the Windows server and mounting
> to the Windows server to access them.
>
> Prior to this patch all of the special files would show up
> as being of type 'file' but with this patch they can be seen
> with the correct file type as can be seen below:
>
>   brwxr-xr-x 1 root root 0, 0 Oct 21 17:10 block
>   crwxr-xr-x 1 root root 0, 0 Oct 21 17:46 char
>   drwxr-xr-x 2 root root    0 Oct 21 18:27 dir
>   prwxr-xr-x 1 root root    0 Oct 21 16:21 fifo
>   -rwxr-xr-x 1 root root    0 Oct 21 15:48 file
>   lrwxr-xr-x 1 root root    0 Oct 21 15:52 symlink-to-file
>
> TODO: go through all documented reparse tags to see if we can
> reasonably map some of them to directories vs. files vs. symlinks
>
> --
> Thanks,
>
> Steve
