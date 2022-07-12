Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BF1C43334
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Jul 2022 04:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiGLEgZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Jul 2022 00:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGLEgY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Jul 2022 00:36:24 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8712C6111E
        for <linux-cifs@vger.kernel.org>; Mon, 11 Jul 2022 21:36:23 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id 189so6787806vsh.2
        for <linux-cifs@vger.kernel.org>; Mon, 11 Jul 2022 21:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zg71DT+CtPAYRZHwxiYX7QhCy5jOMJpa6qh2mWWf8Xc=;
        b=auzCWdpdv1QDYXLr4Nlmeue79WVoX3vZYqZIfdYV3szvgIHNNUsmZhzVMO8EjPzkZS
         Df0i0gOCxZBmnlh90GvIa4+bAtFi+3hwOdIziJyaHcykrOp3FclAQe8RdSBXgSjPVrFJ
         9IkQ7zXCTGnX+oLKdfn+ei7szHIDL41iT5o4H8+5dsYC+SAufS8OFsUj2ZaAKdOnLqib
         2XPFLXoUnDcVxGspaLZGqXYRrbzRvQq4lCPTRPQ85uZ7/hFN49/2IA8ZOhk6QqCeX4yC
         Ctnmjf0ZSl0VV0c1UlJdxYTa5XS9Boe/UUvM5oWkRiYpyA91yjitKF/VOBukmVI7hjSu
         dHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zg71DT+CtPAYRZHwxiYX7QhCy5jOMJpa6qh2mWWf8Xc=;
        b=0JOGEWFag5+rUMj0Lz07NkXJVMSpdP6zCmWKYMsENNwNH28c9cIqJ+H6EyWLFax67Y
         1SSV3lRSbdlSmaOBEPkNTIpazpdcoTQbAIVHCr4ypowZK8kwMTAdSDU3z44wcZkJ4sHq
         TTbkGjylJe5j3O32UvPiHCDBC6DSEVDJ9byBNvzVQo3g3Sz8Peg/ji0tW87EttJJYGIr
         wDbK6ERWGXottyNcdSR77RguKjv7zhV6yIpvga0fvahIleRcar7VjsbDIkxUks+RqL3E
         P5UldTf6CFkFTp6sb1GR9YrYpBGbX9cU9U8NmY+amdnKqogz14SsA4gk7V7nbYRv7Amr
         imIw==
X-Gm-Message-State: AJIora94OOTdxxf5mskeuZAa4+ukX/ZnLXLKNw9yZSuBIFSmMjYTaAH+
        XLwKC3T5pxCQGbRCuppTt65klXUvw2CHQUuf13JgVkgULo0=
X-Google-Smtp-Source: AGRyM1vORKBLp9BaEtBDWZ5ippGl9FKsKKvUQawvX2NV/CexjaFtLVqOXeKWUyxOTD42ug6tLG6DChW+Q4VHAjoiDcg=
X-Received: by 2002:a67:6d86:0:b0:357:3d99:ec77 with SMTP id
 i128-20020a676d86000000b003573d99ec77mr6852993vsc.6.1657600582202; Mon, 11
 Jul 2022 21:36:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAARpZ=_WCZhEZ2DzR3jRNLNLx28duH2iSn7WwRVezGKpjX0LDA@mail.gmail.com>
 <CAH2r5mtYzhd9EpzJAFLH+AHvKB0CaUtVBTP+UP4PDgg686-SFA@mail.gmail.com>
In-Reply-To: <CAH2r5mtYzhd9EpzJAFLH+AHvKB0CaUtVBTP+UP4PDgg686-SFA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 11 Jul 2022 23:36:11 -0500
Message-ID: <CAH2r5mueC4gXgjq7wN9S+y2-=_vqmGKai_4DWWy7CJ1s4m0J0Q@mail.gmail.com>
Subject: Re: mount.cifs broken after update, advice?
To:     Brian Caine <brian.d.caine@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I was able to reproduce it to older Samba server (4.12.5) and could
workaround the Samba server bug by using mount option "compress" on
the client (which won't do anything different since it is not
supported but  interestingly it avoids the problem by adding another
context at the end).

On Sun, Jul 10, 2022 at 11:08 PM Steve French <smfrench@gmail.com> wrote:
>
> This looks like the Samba server bug pointed out in an earlier email
> thread by Metze (fixed by
> https://git.samba.org/?p=samba.git;a=commitdiff;h=147dd9d58a429695a3b6c6e45c8b0eaafc67908a)
>
> I had trouble reproducing it on my systems but it looks like (based on
> Julian Sikorski's testing) when we fixed the netname context to not be
> null in some multichannel cases, the reordering of the contexts
> (putting netname context after the posix negotiate context) triggered
> this bug in some versions of Samba (which was fixed earlier by the
> Samba server commit above).
>
> On Sun, Jul 10, 2022 at 10:35 PM Brian Caine <brian.d.caine@gmail.com> wrote:
> >
> > Hey all,
> >
> > So I recently updated my kernel and my previously-working CIFS
> > mountpoints are broken. The server hasn't changed.
> >
> > I can successfully access it via smbclient. Only mount.cifs is broken.
> >
> > On the server:
> >
> > % /usr/local/sbin/smbd --version
> > Version 4.12.15
> >
> > On the client:
> >
> > $ mount.cifs --version
> > mount.cifs version: 6.15
> >
> > $ smbclient --version
> > Version 4.16.2
> >
> > $ uname -r
> > 5.18.9-arch1-1
> >
> > (I know it's not a vanilla kernel, so I wanted to ask for advice here
> > before making a bug report.)
> >
> > As mentioned, smbclient still works:
> >
> > $ smbclient -U brian //192.168.1.131/backup -c ls
> > Password for [WORKGROUP\brian]:
> >   .                                   D        0  Sat Apr 24 16:01:23 2021
> >   ..                                  D        0  Tue Dec  1 20:18:28 2020
> >   brian                               D        0  Sat Apr 24 16:09:46 2021
> >
> > 15119769681 blocks of size 1024. 12418540722 blocks available
> >
> > This doesn't though:
> >
> > # mount.cifs --verbose --verbose -o username=brian
> > //192.168.1.131/backup /tmp/foo
> > Password for brian@//192.168.1.131/backup:
> > mount error(22): Invalid argument
> > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and
> > kernel log messages (dmesg)
> >
> > I attached my kernel output. Is there anything there that jumps out at
> > anyone? Any easy fixes or should I look into opening a bug report?
> > Anything else I can provide, just ask.
> >
> > Thanks,
> > Brian
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
