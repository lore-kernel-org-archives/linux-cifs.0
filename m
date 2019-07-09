Return-Path: <SRS0=dv7Q=VG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E87C606B0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jul 2019 07:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A162216C4
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jul 2019 07:31:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oTPPZIw/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfGIHbv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Jul 2019 03:31:51 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33342 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfGIHbu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Jul 2019 03:31:50 -0400
Received: by mail-lf1-f68.google.com with SMTP id x3so6756528lfc.0
        for <linux-cifs@vger.kernel.org>; Tue, 09 Jul 2019 00:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LsDIDgBMm2jLpRDVgjX2cydONa3j9/8hjsxCFY2/mas=;
        b=oTPPZIw/x0C1QVGfC/nJ9zydjkWUH26oszF/3L5LN9X8xRK+5y7BKn1nJY0TE14oCw
         bV3/K675w5AR81ZtHxNHxBDe7NdAc2M9+m1kOH7OSMPhTVSCj+eZ2mVO3Gfbv/ss8I/A
         sRD19bFALC0Y2QJLB38sJceUGK3Cq/DwGuAzRh2o/rC4DR9buW3q08igH6e1fP6kukU6
         YON9SZl347F0Ojw7nBX8PKAm/u9mVxUpIcGlKpjEXA+xrnyFCX3XCQqJEPOGuE0nCB47
         xZ7qksMslFuBJrMUyDXGw8avd4aFaAysjzm+eXJ912c8hUlbX8zfDaO7Z7Kren9IVAPf
         qS4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LsDIDgBMm2jLpRDVgjX2cydONa3j9/8hjsxCFY2/mas=;
        b=STMY3RenzZUz4Hw0YZSDWjjsDgTnkknYSFYMahPlIccxR3/Xy5EhO/XMhtfjO3R4z7
         KGkWBFxKCwTWx1Zr9s7euVJ8+SmDJST4as7Yus7+c3rg/lIpUEW/VdrxFHZ33E9t5QSf
         2uSiiRWCqChVvEBKlOvYM+7jLE+2MPnPVykDh/fM42ZoJMrxv+seHwFg6OiDkxl2Nct9
         M5YMaaS6/Pqavb1Yfqm/SwqWmTr6zQAZ7DJywVL9Ve2Ur5vyvNzHMGv35ixv7JyvNicM
         vfIyybKcVspNoFQRiyPrTFAToKd6x+G7T29jDvNo3IlzAQ8jKhc3PxMEmZ0YWur5xrmN
         RSrA==
X-Gm-Message-State: APjAAAXc/SjVW/KHyTDLsSFEu45m7Qd71VUn3aN56C9dzwg8v85sYTeN
        HnsfLAvN9aU+H82InX50y8nf5JOmsgG3WRAE2RvQzynhvgoW0g==
X-Google-Smtp-Source: APXvYqzKtH4RDeKTBmtxULXFxnccDypA9xhqkUcTpNs9TFA54R4XkYBBKe5si50/aevQRLvIUyjMffNDYDXCKaON0II=
X-Received: by 2002:a05:6512:c1:: with SMTP id c1mr11555357lfp.35.1562657508321;
 Tue, 09 Jul 2019 00:31:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAO3V83L1Q9jCLBsjHgFE1jw2PPi_sHtQz4geDKC4jEPWkhNYBg@mail.gmail.com>
 <CAO3V83+iZRAQRZ5YzivPS3di0QM=-dJOg8rnVK1icUuuESd+=g@mail.gmail.com> <CAH2r5muXeKhfTgovqD1uQw_yRbstqj4M9NExqmtp0ZqZ6Dx4VA@mail.gmail.com>
In-Reply-To: <CAH2r5muXeKhfTgovqD1uQw_yRbstqj4M9NExqmtp0ZqZ6Dx4VA@mail.gmail.com>
From:   Wout Mertens <wout.mertens@gmail.com>
Date:   Tue, 9 Jul 2019 09:31:37 +0200
Message-ID: <CAO3V83JUVNLWPJarq04zj2uSR246BUvuMp46SXBTGt=R7cWK0Q@mail.gmail.com>
Subject: Re: mount.cifs fails but smbclient succeeds
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Kernel is 4.19.57. I don't know what the file server is, any way I can
find out from protocol sniffing?

The system is an on-premise VM that I connect to over SSH, I'm worried
I'll kill my connectivity trying to boot it with a 5.1 kernel.

So I'll try running 5.1 locally and tunneling over SSH, and I'll report back.

Wout.

On Tue, Jul 9, 2019 at 5:05 AM Steve French <smfrench@gmail.com> wrote:
>
> What kernel version? Note that we did make a change late last year in
> how we report the server name component of the UNC name during tree
> connection so could be useful to try with reasonably recent kernel -
> perhaps 5.1 kernel if possible as an experiment
>
> What server type?
>
> On Mon, Jul 8, 2019 at 7:52 PM Wout Mertens <wout.mertens@gmail.com> wrote:
> >
> > Hi,
> >
> > I need to mount a file server that I only have credentials for and
> > know nothing about.
> >
> > I have a completely vanilla setup without /etc/smb.conf, nor any Samba
> > service running; only the samba client binaries are installed. The
> > credentials are domain, username, password; Kerberos is not being used
> > as confirmed by the smbclient debug output.
> >
> > When I connect using
> >
> >     smbclient -A credentials.txt //corp.local/mnt
> >
> > it works fine. The name corp.local resolves using DNS and I can browse
> > the datastore.
> >
> > When I mount using
> >
> >  mount -vvvvv -t cifs //corp.local/mnt --verbose
> > -overs=3,credentials=credentials.txt,sec=ntlmssp /mnt
> >
> > I see that I get a STATUS_BAD_NETWORK_NAME back. If I change the
> > credentials, I get a logon error, and if I change the mount name, I
> > get a missing file error. So it seems that the path and the
> > credentials are correct. If I change the version to 1, it fails in
> > some other way. If I change the sec to ntlm, it complains about
> > authentication.
> >
> > Any suggestions? This is driving me crazy :-/
> >
> > Many thanks!
> >
> > Wout.
>
>
>
> --
> Thanks,
>
> Steve
