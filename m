Return-Path: <SRS0=rFey=5I=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C15EC3F2CD
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Mar 2020 03:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 403232070A
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Mar 2020 03:52:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GScvpaoG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgCWDwk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 22 Mar 2020 23:52:40 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:42526 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWDwj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 22 Mar 2020 23:52:39 -0400
Received: by mail-yb1-f195.google.com with SMTP id s17so6330597ybk.9
        for <linux-cifs@vger.kernel.org>; Sun, 22 Mar 2020 20:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h5IEX1kx3V3r3qhQVo6n7tesypfSaEbN3UFciB59f2Q=;
        b=GScvpaoGQ+h7SD1Rh9gINDQYMvlDmypiFIKEazRzBVQkc5qeJU9lh0WryKlkCfjWhx
         QxYeSfKMfCNQgm34iguqk7jC4BtjfsQDrrHgWVwwPtqcKfPkVJMI6hOr907B/Z5r6/u3
         U/tI3mVYZHB1Wa646vCWmbaY9QlwFzQuRQIcvTIGzndqztEa3+ilyAA9dWylgMmWAMew
         nqNFI/OZ2znZpGOXxH+1XLLIBqfdKPzCbpTn7oLm7vZ7pTzqpg8NpVS0Ix7uKEPc04Lr
         EJcjQ8aEcEViNPf5x+UKT/R1iaY04+dmBnmHVacjHnfhEUz0qCPlfC3JxTqWkbheWU8A
         VZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h5IEX1kx3V3r3qhQVo6n7tesypfSaEbN3UFciB59f2Q=;
        b=T6Q4NinPMEVJPjXJydBw4WOe+Ly6fCDCLUD7xPjfUMqgdGbTs5DPXuTUPlhqEJIxIq
         mtErzk9aW4pt8oCB+e9AYVsVKnrQjwWMZSx1rFk3VxlScE+RzEZnIma4CnnHHw47c4OY
         E7c+CtWzjeQXaF2V4KYU8Q3iRZl+3C7sA6oN9Fiql7vZK9zlSc+nUob+wZaLzT8szMQs
         TK+gpAsgvd4QMZVX5S4IeFKKLQs09v+hsOIkBZLjeS/tTbtYG0qaUaKCYXkS6PQ7Wo6G
         ovWZe0lKwB2ar0dDnaeCAni/Bw1rI6OzmU6a3BcD07ChdmxWDUhsEwF+i45rkSGXyCdi
         l5KA==
X-Gm-Message-State: ANhLgQ31MQV+E9Qb6fntdMxVCx6Dq9FkPIOBGKdkzOE1O+J6FYIL6eEj
        oxUC2VwTuKlNYAZNzv3l7lZxXsQslKgapzrXmrCWj7/z
X-Google-Smtp-Source: ADFU+vtO+0PCWLwGN/OkWR7Lp2kD5WSmMm/QQBwXD0HH2ne4cNopmDT+nYQxlGYAaCZ7hfX7tvo3zrq3dRh3FhLNwqE=
X-Received: by 2002:a25:e805:: with SMTP id k5mr31274125ybd.14.1584935558534;
 Sun, 22 Mar 2020 20:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200318124659.cbxngqb4kbt2vhza@xzhoux.usersys.redhat.com>
 <CAH2r5muTx3DmGZ+ZedrNmPK8ZHq10XZ3RXxVD0H6RmEcBvnVPQ@mail.gmail.com>
 <20200323002428.ih7nchj5tnbuppeb@xzhoux.usersys.redhat.com> <CAH2r5muXYLMjojCJ0nGBpTmAhGznhvkEG3KE6YE0PvaMuYqbLQ@mail.gmail.com>
In-Reply-To: <CAH2r5muXYLMjojCJ0nGBpTmAhGznhvkEG3KE6YE0PvaMuYqbLQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 22 Mar 2020 22:52:27 -0500
Message-ID: <CAH2r5msCX8_0pDhZ71=RqBPEHSq_Q4u6H8dnXFx3xxx-NtCNzg@mail.gmail.com>
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

If you see any patches missing for 5.7 in for-next (or any urgent
patches missing needed for 5.6) let me know ASAP

On Sun, Mar 22, 2020 at 10:51 PM Steve French <smfrench@gmail.com> wrote:
>
> I also see (in cifs-2.6.git for-next)
>
> commit 0667059d0b4ad231e7258aa571f28574b313f34f
> Author: Murphy Zhou <jencce.kernel@gmail.com>
> Date:   Fri Feb 21 10:30:01 2020 +0800
>
>     cifs: allow unlock flock and OFD lock across fork
>
>     Since commit d0677992d2af ("cifs: add support for flock") added
>     support for flock, LTP/flock03[1] testcase started to fail.
>
> On Sun, Mar 22, 2020 at 7:24 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> >
> > Hi Steve,
> >
> > On Wed, Mar 18, 2020 at 10:36:54PM -0500, Steve French wrote:
> > > Merged into cifs-2.6.git for-next
> >
> > I don't see this in for-next. Is it for 5.7?
> >
> > So does this one:
> > cifs: allow unlock flock and OFD lock across fork
> >
> > Thanks!
> > >
> > > On Wed, Mar 18, 2020, 07:48 Murphy Zhou <jencce.kernel@gmail.com> wrote:
> > >
> > > > xfstests generic/228 checks if fallocate respect RLIMIT_FSIZE.
> > > > After fallocate mode 0 extending enabled, we can hit this failure.
> > > > Fix this by check the new file size with vfs helper, return
> > > > error if file size is larger then RLIMIT_FSIZE(ulimit -f).
> > > >
> > > > This patch has been tested by LTP/xfstests aginst samba and
> > > > Windows server.
> > > >
> > > > Acked-by: ronnie sahlberg <ronniesahlberg@gmail.com>
> > > > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > > > ---
> > > >
> > > > v2:
> > > >   Use (off+len) instead of eof for correct argument type.
> > > > v3:
> > > >   Fix Ronnie's email address.
> > > >
> > > >  fs/cifs/smb2ops.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > >
> > > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > > index c31e84ee3c39..f221a01f62bd 100644
> > > > --- a/fs/cifs/smb2ops.c
> > > > +++ b/fs/cifs/smb2ops.c
> > > > @@ -3246,6 +3246,10 @@ static long smb3_simple_falloc(struct file *file,
> > > > struct cifs_tcon *tcon,
> > > >          * Extending the file
> > > >          */
> > > >         if ((keep_size == false) && i_size_read(inode) < off + len) {
> > > > +               rc = inode_newsize_ok(inode, off + len);
> > > > +               if (rc)
> > > > +                       goto out;
> > > > +
> > > >                 if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
> > > >                         smb2_set_sparse(xid, tcon, cfile, inode, false);
> > > >
> > > > --
> > > > 2.20.1
> > > >
> > > >
> >
> > --
> > Murphy
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
