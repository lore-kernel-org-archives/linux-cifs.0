Return-Path: <SRS0=rFey=5I=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEA6C1975A
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Mar 2020 03:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 840CD20732
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Mar 2020 03:37:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WR9RAwQ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCWDhA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 22 Mar 2020 23:37:00 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37918 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWDg7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 22 Mar 2020 23:36:59 -0400
Received: by mail-yb1-f194.google.com with SMTP id j138so6310608ybg.5
        for <linux-cifs@vger.kernel.org>; Sun, 22 Mar 2020 20:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jHK24BN+AuBbJZHdcRcPM+QuLcdvcjj7dGqoUBOB60g=;
        b=WR9RAwQ1BL9bm9ryCj7AgvnGPfxOnfiL19BgFIck1zFxaBIX0AM5CfZxk3MiBsnO3K
         uLfUfkN1cJI/YJd3Peo/0IBjWyHIcZPvIZNWqklQay2OzkT9F0ooNqmyl6v1VnDdBpjf
         HYmdHL6u1o94u0VZmMYXllcdw1ILHqtzv/hx3sp+IthnWMu/iKZOM7n4ZRrdMWqVSbeE
         2izX2lZpoY6J+bQE1lbv0/MApMq7OTGkr6nNML6iyDyfu7qGFArRoIsXfXglAmbkU38b
         LOJn60zQP8M01WveoMa1/KMFj7fauM63v9nOyCQ6Nnd8b4U36092YdIe+lRoGO2uAtsi
         ZKaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jHK24BN+AuBbJZHdcRcPM+QuLcdvcjj7dGqoUBOB60g=;
        b=KmtNiXSz2ueLIP/TNU0qkZawHRs5Q13aF4xJwYboyli0wSBjtJKeHyvlRvEi+uOG4N
         afd2/gNOZ96BSUik5/MWb3QuThF9Md/91FqzrIAs5YcvZRZ6J1/PGlNWOnTmtZzrF923
         JqHmDa064N+kJC8BsDQsMuG0dfHY6/GWxzU7r6kG3j6oVvQjFYhOp5e1/8mqlzJyXwR6
         Vmt2iQF5RwJJqq37u3zch2WA1GqKxXuS/wR76wAqB6ar+dnZnBN83RayDiT5xGf8t6Yo
         Uue37lEveUXkfvMcFefsS87HyzaMXQMdmCQk+6X/Y0vUqqseXGre1yQSHLVJI8PrnmHD
         i1eQ==
X-Gm-Message-State: ANhLgQ03BXn7f0xBCwPQ/IUcYHwpBnwc8+aiKrJxFgsC0aU61CyR+3rJ
        a+WnzPibSk+myuH75idDWND08vDBrD9ZBG27MBScCVkcV60=
X-Google-Smtp-Source: ADFU+vtObF22eRoF215nc5cKVIDdUe30ASeh8QM+6SmyjIzwphGXUtNZPd7hnJj1S5x1mmL7RQA1PqPVTYgZd4q5nqM=
X-Received: by 2002:a25:f20f:: with SMTP id i15mr22052262ybe.364.1584934616882;
 Sun, 22 Mar 2020 20:36:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200318124659.cbxngqb4kbt2vhza@xzhoux.usersys.redhat.com>
 <CAH2r5muTx3DmGZ+ZedrNmPK8ZHq10XZ3RXxVD0H6RmEcBvnVPQ@mail.gmail.com> <20200323002428.ih7nchj5tnbuppeb@xzhoux.usersys.redhat.com>
In-Reply-To: <20200323002428.ih7nchj5tnbuppeb@xzhoux.usersys.redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 22 Mar 2020 22:36:46 -0500
Message-ID: <CAH2r5msZBvN9+dBLeqpZff2yu21j+TN=B8X72Xs8j-V9Rmqcig@mail.gmail.com>
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

Isn't this it: https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=4f6257b7d092b84ba8a62769ad6c6fb6ebe89d70

It has been in there 4 days (although I will be updating the branch soon)

CIFS: check new file size when extending file by fallocate
authorMurphy Zhou <jencce.kernel@gmail.com>
Wed, 18 Mar 2020 07:43:38 -0500 (20:43 +0800)
committerSteve French <stfrench@microsoft.com>
Wed, 18 Mar 2020 16:28:10 -0500 (16:28 -0500)
commit4f6257b7d092b84ba8a62769ad6c6fb6ebe89d70
tree7faad4e1799cf4bbb3287c8cb93c9fe6cf8ffabf

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
