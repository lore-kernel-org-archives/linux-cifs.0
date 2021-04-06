Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628C5C433B4
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 16:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DB38613D0
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 16:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbhDFQed (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Apr 2021 12:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhDFQed (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Apr 2021 12:34:33 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B87C06174A
        for <linux-cifs@vger.kernel.org>; Tue,  6 Apr 2021 09:34:25 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l4so22927410ejc.10
        for <linux-cifs@vger.kernel.org>; Tue, 06 Apr 2021 09:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YKS6alNHIcGRHWMGEwT/HoX91jmJ9Qiduv4jhB8XiYw=;
        b=NqZU1dpTuYbsdCJhVBfJCE2jEC+oWgzpspTmkwsdEJJupekWuFsnJwQtoBw7bOsLHZ
         hWFy3VZwI4aJGoHeDgJFvypGAXfLhe0ytjlthSAaBDQS/EeeZc29RcUqaPYtd1t4OLXI
         61Y9UlKhYp4nKJeYCERsroDdk4FTCfk+D84SPB/SYxMWdC9My1Xw5ClqMMeFVvfHPCaQ
         obsMR+bnhxFtBaae5GEnRe1p7NI/9OWCwsb6yKzEyRHlkPUt+/uwWknGtcsQhIYt7X0k
         kstMRkfcVYRUW6A/nb4ibQ3HxH8oeInf5DXniw0UDEERbZIqmUN1kYXyPrheVnIEwE2/
         3EAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YKS6alNHIcGRHWMGEwT/HoX91jmJ9Qiduv4jhB8XiYw=;
        b=DYOAT057KR1ZqECqucTUG887toSIIs1584b6C2LXTi0/RdWdEv9CAlKWyXV6c4XSl8
         EK81qtYfmXZalOkSc6HRpLuxNbv8p8IBEF83H3MIpC6VrGryUC3K/5qDKryy5Z0ccpBs
         14m7mhDVWxjz2vIuksAKH9qjSDSHpbsLdnO5Qez9VD47ShYd83tTKTLyVlwpTThM8n2J
         vDiDSbB2MWYlZZIOe/Y/uqYKK/HPM6jnegVV/4emNLgkBYha5FMQ7Y4xG2arxRG2z5bT
         RjeT6v7eltm6cjHTSXqD2d1EGo991PxQcz4EQUPdhJGLz6KB/odu2+hkFpiFxSZiONp+
         NsAg==
X-Gm-Message-State: AOAM532qsg6BYjJRyK6FVDVe2OHZEhFXGexZ3NqOdjzJz0fDEzP1JF2W
        /PMrzbn0I0LoVady799J0RSIKVQ8XVB1s7WSVytJbygrZg==
X-Google-Smtp-Source: ABdhPJzlcRFRwEDv/p+fsHoAq52r8DCvNmQrNYcqlqaa7wYH6XSOWGZHpWEH2ykWyDeCV6bTeF8OSaF9xfugIR6Bm6w=
X-Received: by 2002:a17:907:c16:: with SMTP id ga22mr35049586ejc.120.1617726863745;
 Tue, 06 Apr 2021 09:34:23 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qWyYCD_gSw-AzvxOgzTzWkBK1uUz-16YougX5No8jjgQ@mail.gmail.com>
 <87im50vi9v.fsf@cjr.nz> <CANT5p=pHPPwf8H1ZbBT+yr4CP17+BB2evDBxPVjYrvr+kdF1FQ@mail.gmail.com>
In-Reply-To: <CANT5p=pHPPwf8H1ZbBT+yr4CP17+BB2evDBxPVjYrvr+kdF1FQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 6 Apr 2021 09:34:11 -0700
Message-ID: <CAKywueSCF-ZgmJZif=kkspk_b8Xp3ARUGHD64nnc5ZbVk3EcxA@mail.gmail.com>
Subject: Re: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

CC: <stable@vger.kernel.org> # 5.11+

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 5 =D0=B0=D0=BF=D1=80. 2021 =D0=B3. =D0=B2 19:07, Shyam Prasad=
 N <nspmangalore@gmail.com>:
>
> Hi Paulo,
>
> Thanks for the quick review. And nice catch about CONFIG_CIFS_DFS_UPCALL.
> Fixed it, added CC for stable.
> Attached updated patch.
>
> Regards,
> Shyam
>
> On Mon, Apr 5, 2021 at 9:24 PM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> >
> > > Please consider the attached patch for performing the DNS query again
> > > on reconnect.
> > > This is important when connecting to Azure file shares. The UNC
> > > generally contains the server name as a FQDN, and the IP address whic=
h
> > > the name resolves to can change over time.
> > >
> > > After our last conversation about this, I discovered that for the
> > > non-DFS scenario, we never do DNS resolutions in cifs.ko, since
> > > mount.cifs already resolves the name and passes the "addr=3D" arg dur=
ing
> > > mount.
> >
> > Yeah, this should happen for both cases.  Good catch!
> >
> > > I noticed that you had a patch for this long back. But I don't see
> > > that call happening in the latest code. Any idea why that was done?
> >
> > I don't know.  Maybe some other patch broke it.
> >
> > We should probably mark it for stable as well.
> >
> > > From 289f7f0fa229ea181094821c309a2ba9358791a3 Mon Sep 17 00:00:00 200=
1
> > > From: Shyam Prasad N <sprasad@microsoft.com>
> > > Date: Wed, 31 Mar 2021 14:35:24 +0000
> > > Subject: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
> > >
> > > On cifs_reconnect, make sure that DNS resolution happens again.
> > > It could be the cause of connection to go dead in the first place.
> > >
> > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > ---
> > >  fs/cifs/connect.c | 15 +++++++++++++++
> > >  1 file changed, 15 insertions(+)
> >
> > This patch breaks when CONFIG_CIFS_DFS_UPCALL isn't set.
> >
> > Please declare reconn_set_ipaddr_from_hostname() outside the "#ifdef
> > CONFIG_CIFS_DFS_UPCALL" in connect.c.
> >
> > Otherwise,
> >
> > Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>
>
>
> --
> Regards,
> Shyam
