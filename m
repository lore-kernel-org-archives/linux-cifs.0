Return-Path: <SRS0=rFey=5I=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8C1C10F26
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Mar 2020 05:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D7102070A
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Mar 2020 05:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JMCeECso"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgCWFNj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Mar 2020 01:13:39 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37173 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgCWFNj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 Mar 2020 01:13:39 -0400
Received: by mail-pj1-f65.google.com with SMTP id o12so1806140pjs.2
        for <linux-cifs@vger.kernel.org>; Sun, 22 Mar 2020 22:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Th9W0EaiLIVvYcRbnOksHq4H6phzE6m+bCwBGNH053Y=;
        b=JMCeECso1bLRunNv4wIj0IJCRdE4wTIgilOfhK8IFs9WALcsvpQtKt+VmMVkEPhnHx
         vCbJYoDOM6yCqbPxwcT6Wos0BWu2w+dyWdH+8FagjzL0ZflOyoyF+x0FAYy0kTMDj77p
         f/AVZrRZwGz3lNhafQ6vMClBjOGOc54eJTwulgARJbXf99kVOAasE01BkD3zCWVojLFp
         LOn4GkqIP9K7gwkZschnku5DtBxF6UBjie/0wyxt0t6sjgrn1gepeD33+7MLrwcvO6jG
         OEWHw4hEjShKqW1BOdgW/rhNzQzK0SIb3/WUoqKJ7LB52hWEpj1+CO6t05uatS3Z38O4
         3VNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Th9W0EaiLIVvYcRbnOksHq4H6phzE6m+bCwBGNH053Y=;
        b=typBLjyIzeK1OKW94E3o5+XAo9H4tMiVDimCqjZQJV8g1ZRyEd6CLmpMEbiULBl02r
         UVKWU4Ytj5jJDm+z4E7ZKw6zOZ4Vj763ClBxKKu9O93EImw5laFyYa1XwPH+eAMimEmU
         yn4Ou8IGBzqCxAQaQNQd84JCVNqG9sFDnhZEGjRz4uW0uFbk9M830Ooe68FF5ikPbyzK
         iLNruslGzo2RHw92etQU+JqUeZw0QAaGfIL3Ps0ed1lT9qd4TK1SGk535296nZRKJLL8
         dyKLeQWHTm5L/gQbsLMsJ5vxvfeKqbMximLUM6rNeh/Oxp0+/635MOWhiGXPR4MqLZHI
         98bQ==
X-Gm-Message-State: ANhLgQ2LIMG3rlCVvRjCyBukr3VXRQbT3/ce3u1D1bfNcIqh0cnHsgmg
        IT748SV3TB5h9s4kRGqFR5DPMNGV
X-Google-Smtp-Source: ADFU+vsiJmEO3vMqZtcf6JiNyLYvVSXLGXKVxY81Od6qsZVrpBsDfmabM0Mtd2Oro0QQ1E+ld8144g==
X-Received: by 2002:a17:902:82c2:: with SMTP id u2mr15416866plz.125.1584940417610;
        Sun, 22 Mar 2020 22:13:37 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e24sm12019756pfi.200.2020.03.22.22.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2020 22:13:37 -0700 (PDT)
Date:   Mon, 23 Mar 2020 13:13:29 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>
Subject: Re: [PATCH v3] CIFS: check new file size when extending file by
 fallocate
Message-ID: <20200323051329.hqxyoxj3cp3h2wet@xzhoux.usersys.redhat.com>
References: <20200318124659.cbxngqb4kbt2vhza@xzhoux.usersys.redhat.com>
 <CAH2r5muTx3DmGZ+ZedrNmPK8ZHq10XZ3RXxVD0H6RmEcBvnVPQ@mail.gmail.com>
 <20200323002428.ih7nchj5tnbuppeb@xzhoux.usersys.redhat.com>
 <CAH2r5muXYLMjojCJ0nGBpTmAhGznhvkEG3KE6YE0PvaMuYqbLQ@mail.gmail.com>
 <CAH2r5msCX8_0pDhZ71=RqBPEHSq_Q4u6H8dnXFx3xxx-NtCNzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msCX8_0pDhZ71=RqBPEHSq_Q4u6H8dnXFx3xxx-NtCNzg@mail.gmail.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Mar 22, 2020 at 10:52:27PM -0500, Steve French wrote:
> If you see any patches missing for 5.7 in for-next (or any urgent
> patches missing needed for 5.6) let me know ASAP

Oh sorry I was checking the github url.. Updated.

Now I see it's all good. No patch is missing.

Thanks!
> 
> On Sun, Mar 22, 2020 at 10:51 PM Steve French <smfrench@gmail.com> wrote:
> >
> > I also see (in cifs-2.6.git for-next)
> >
> > commit 0667059d0b4ad231e7258aa571f28574b313f34f
> > Author: Murphy Zhou <jencce.kernel@gmail.com>
> > Date:   Fri Feb 21 10:30:01 2020 +0800
> >
> >     cifs: allow unlock flock and OFD lock across fork
> >
> >     Since commit d0677992d2af ("cifs: add support for flock") added
> >     support for flock, LTP/flock03[1] testcase started to fail.
> >
> > On Sun, Mar 22, 2020 at 7:24 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> > >
> > > Hi Steve,
> > >
> > > On Wed, Mar 18, 2020 at 10:36:54PM -0500, Steve French wrote:
> > > > Merged into cifs-2.6.git for-next
> > >
> > > I don't see this in for-next. Is it for 5.7?
> > >
> > > So does this one:
> > > cifs: allow unlock flock and OFD lock across fork
> > >
> > > Thanks!
> > > >
> > > > On Wed, Mar 18, 2020, 07:48 Murphy Zhou <jencce.kernel@gmail.com> wrote:
> > > >
> > > > > xfstests generic/228 checks if fallocate respect RLIMIT_FSIZE.
> > > > > After fallocate mode 0 extending enabled, we can hit this failure.
> > > > > Fix this by check the new file size with vfs helper, return
> > > > > error if file size is larger then RLIMIT_FSIZE(ulimit -f).
> > > > >
> > > > > This patch has been tested by LTP/xfstests aginst samba and
> > > > > Windows server.
> > > > >
> > > > > Acked-by: ronnie sahlberg <ronniesahlberg@gmail.com>
> > > > > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > > > > ---
> > > > >
> > > > > v2:
> > > > >   Use (off+len) instead of eof for correct argument type.
> > > > > v3:
> > > > >   Fix Ronnie's email address.
> > > > >
> > > > >  fs/cifs/smb2ops.c | 4 ++++
> > > > >  1 file changed, 4 insertions(+)
> > > > >
> > > > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > > > index c31e84ee3c39..f221a01f62bd 100644
> > > > > --- a/fs/cifs/smb2ops.c
> > > > > +++ b/fs/cifs/smb2ops.c
> > > > > @@ -3246,6 +3246,10 @@ static long smb3_simple_falloc(struct file *file,
> > > > > struct cifs_tcon *tcon,
> > > > >          * Extending the file
> > > > >          */
> > > > >         if ((keep_size == false) && i_size_read(inode) < off + len) {
> > > > > +               rc = inode_newsize_ok(inode, off + len);
> > > > > +               if (rc)
> > > > > +                       goto out;
> > > > > +
> > > > >                 if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
> > > > >                         smb2_set_sparse(xid, tcon, cfile, inode, false);
> > > > >
> > > > > --
> > > > > 2.20.1
> > > > >
> > > > >
> > >
> > > --
> > > Murphy
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> 
> 
> 
> -- 
> Thanks,
> 
> Steve

-- 
Murphy
