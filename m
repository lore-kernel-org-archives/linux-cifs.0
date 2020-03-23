Return-Path: <SRS0=rFey=5I=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE68C3F2CD
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Mar 2020 03:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F43620732
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Mar 2020 03:51:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HxpyOmNK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgCWDvr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 22 Mar 2020 23:51:47 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:38751 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWDvr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 22 Mar 2020 23:51:47 -0400
Received: by mail-yb1-f194.google.com with SMTP id j138so6323299ybg.5
        for <linux-cifs@vger.kernel.org>; Sun, 22 Mar 2020 20:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7O0NrVfHEmxTAaSlbIVGjlFoHJzKEuBizWFXG9ZF0Eo=;
        b=HxpyOmNKZaI7IHHvC9PaX1xD2cIiJ8zJGdSv05vvL7TN7Sy6Z0iaSgB5PJQfyFOBmT
         mvHwZhEbgZBpgJjqDQTdJeACyJvQMtV2rbGdtzFkF63nHTorsn1D/a+U9gpf0TRCGyUu
         msRf06kCd8Ph72EDavdJAzgAH1lWbUpLOqEx6hf/2qy3sNC9DsPmUKqur0flke3LjKY6
         UHY9iPUgA6Xcbeq0dMvaGd+pj7t4IkUlxa8IqXihCtIyXPQEIb6c+dTUiJq1xnI9PGPl
         rsjSkcZ4/tet79mFPec6POh4XeVh/qQq5IQJYIJ9aI1DR/yaGw0bQtMDITWTHxD30Rfo
         b1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7O0NrVfHEmxTAaSlbIVGjlFoHJzKEuBizWFXG9ZF0Eo=;
        b=FeqYHq+lp4F4fx9CxQMEvZhIy9Wd73korUwb3AWpv1S84Gy77Wvq7DeopsB7mdcH9P
         uxHPSg29WdON099rzQuf5qjRSl+dgpiGyYOoKIkQUjc4TTmCyPz+3jXm/I9ICLIMzNUn
         QBwtIDIqjST09c4sG313uSPgGMhmVZR7tzX+W0V9XGb0XD8P7g+57Ytijr6N7GHgormN
         CpXvhofT3/J8Gx1nL4AosA680aQOApeoZxesTPPkXPKT14jsMFVS1Yvyhor9/mJupcW8
         cUDph2Oe2sAWzA3PDSR3HP6Qnw5gZoK8sdwAOdbcpNvPftX5F1KbtXClk7azr2LBJs+y
         u6/g==
X-Gm-Message-State: ANhLgQ39e1JVmYgoOHK+j5eIOm/3BNyTav6idxAclJ2yoyJx2IVN4Qup
        /Ng3ckFzUzWjOSgWia8h/YdeW9qxlPN8i0ZgsAE=
X-Google-Smtp-Source: ADFU+vtihEbdNL4gBoBX30E4Or279EzXPQMhZL3buXJPeTWTwQUeHe4bBzxA8v/7PuewwID612P+O2g/kN8Txv6xRw4=
X-Received: by 2002:a25:cf85:: with SMTP id f127mr29622359ybg.167.1584935504803;
 Sun, 22 Mar 2020 20:51:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200318124659.cbxngqb4kbt2vhza@xzhoux.usersys.redhat.com>
 <CAH2r5muTx3DmGZ+ZedrNmPK8ZHq10XZ3RXxVD0H6RmEcBvnVPQ@mail.gmail.com> <20200323002428.ih7nchj5tnbuppeb@xzhoux.usersys.redhat.com>
In-Reply-To: <20200323002428.ih7nchj5tnbuppeb@xzhoux.usersys.redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 22 Mar 2020 22:51:34 -0500
Message-ID: <CAH2r5muXYLMjojCJ0nGBpTmAhGznhvkEG3KE6YE0PvaMuYqbLQ@mail.gmail.com>
Subject: Re: [PATCH v3] CIFS: check new file size when extending file by fallocate
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I also see (in cifs-2.6.git for-next)

commit 0667059d0b4ad231e7258aa571f28574b313f34f
Author: Murphy Zhou <jencce.kernel@gmail.com>
Date:   Fri Feb 21 10:30:01 2020 +0800

    cifs: allow unlock flock and OFD lock across fork

    Since commit d0677992d2af ("cifs: add support for flock") added
    support for flock, LTP/flock03[1] testcase started to fail.

On Sun, Mar 22, 2020 at 7:24 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> Hi Steve,
>
> On Wed, Mar 18, 2020 at 10:36:54PM -0500, Steve French wrote:
> > Merged into cifs-2.6.git for-next
>
> I don't see this in for-next. Is it for 5.7?
>
> So does this one:
> cifs: allow unlock flock and OFD lock across fork
>
> Thanks!
> >
> > On Wed, Mar 18, 2020, 07:48 Murphy Zhou <jencce.kernel@gmail.com> wrote:
> >
> > > xfstests generic/228 checks if fallocate respect RLIMIT_FSIZE.
> > > After fallocate mode 0 extending enabled, we can hit this failure.
> > > Fix this by check the new file size with vfs helper, return
> > > error if file size is larger then RLIMIT_FSIZE(ulimit -f).
> > >
> > > This patch has been tested by LTP/xfstests aginst samba and
> > > Windows server.
> > >
> > > Acked-by: ronnie sahlberg <ronniesahlberg@gmail.com>
> > > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > > ---
> > >
> > > v2:
> > >   Use (off+len) instead of eof for correct argument type.
> > > v3:
> > >   Fix Ronnie's email address.
> > >
> > >  fs/cifs/smb2ops.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > index c31e84ee3c39..f221a01f62bd 100644
> > > --- a/fs/cifs/smb2ops.c
> > > +++ b/fs/cifs/smb2ops.c
> > > @@ -3246,6 +3246,10 @@ static long smb3_simple_falloc(struct file *file,
> > > struct cifs_tcon *tcon,
> > >          * Extending the file
> > >          */
> > >         if ((keep_size == false) && i_size_read(inode) < off + len) {
> > > +               rc = inode_newsize_ok(inode, off + len);
> > > +               if (rc)
> > > +                       goto out;
> > > +
> > >                 if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
> > >                         smb2_set_sparse(xid, tcon, cfile, inode, false);
> > >
> > > --
> > > 2.20.1
> > >
> > >
>
> --
> Murphy



-- 
Thanks,

Steve
