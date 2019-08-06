Return-Path: <SRS0=QbqR=WC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFD6C31E40
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Aug 2019 22:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FE2621880
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Aug 2019 22:00:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="icWUQXdL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfHFWA3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Aug 2019 18:00:29 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42658 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfHFWA2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Aug 2019 18:00:28 -0400
Received: by mail-ot1-f65.google.com with SMTP id l15so96423360otn.9
        for <linux-cifs@vger.kernel.org>; Tue, 06 Aug 2019 15:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wrdG+mIxY0LCe2ngyb6+rUQFcfUcp68ZRZYphhx9upM=;
        b=icWUQXdLzHTqFmvKR8Hlx7GuFmAHIslvqvvitT6Vv2AgTNN46mjn2MYSDKZOUN7BoW
         v2d3MaJQK2geBA1GVIj///uxR7Qsmqdm8kYSXozWQYBstY0K9JfjJ6xMK2H2RLWg9SZ+
         U4K76TNDQa2o/pEX++5qW6h8K9X1J+sEb69IyKTO8KsylRFeyoLuOQayfc99gVACGGN3
         INPnEu+GdW42+D6/MIqo+mnHp/ccZV+QiFF7eg/37yoyesjaxJ1CISO3pxy5vCjmbZ/V
         pLcQ00vMe4sQ66fwgGf/fQwWIM11Lfq58ee4U+x3e6GzahR+mkdF1jRMtzp52uxMmZsl
         j0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wrdG+mIxY0LCe2ngyb6+rUQFcfUcp68ZRZYphhx9upM=;
        b=Gieo7nN5PgQ73ZP7RDWhHbyMnBG5Uyc5Wp3S29hiH+tgiBVBBXzydmdOU8W+lzGJSK
         +PZsDWkz0rvjGixNpp84xPUarPs+h9UsaSqZLItX2rD29zJx3RsNMGeCfyNQRwTuHbYG
         ieA9qumMF+Qzr/FnQbM7XwpJzwVRdKWML+Jsew4vG6rc7B/JclV2xFlD5YnzstZyLauJ
         +MhGp5n5upHUR8nQcdDOMmpHVo2CAhMqSApxuq/uwjC13uleYzV8hf3aIoPBiwCS+Yjx
         +ci27VBcWbQtDjyjLKYZWO6NKN+GLsqC84Bq+PxlP1TYu8hlL1uzDY7evV58IRH2VAYS
         MZHg==
X-Gm-Message-State: APjAAAWHSpzcRO57fF0sKEiLEZJd5m1L0kz/T1H1x9KzWpgQNRFSz6Jl
        gWlyNcaWtV1JB4MzHHFa2PaVv4zI15K/Hf+Ff7E=
X-Google-Smtp-Source: APXvYqyYEGoJBRX0OHzteDlwmCu0KK1wZ4JtkzxfxPqj3ewCPkhzvqk6YTypxWSZnvkvSLjxdV5ftEz7VXVAGmPATww=
X-Received: by 2002:a6b:7017:: with SMTP id l23mr5551321ioc.159.1565128827365;
 Tue, 06 Aug 2019 15:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190805224639.2322-1-lsahlber@redhat.com> <SN4PR2101MB07334B83742BE57988263F7CA0D50@SN4PR2101MB0733.namprd21.prod.outlook.com>
In-Reply-To: <SN4PR2101MB07334B83742BE57988263F7CA0D50@SN4PR2101MB0733.namprd21.prod.outlook.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 7 Aug 2019 08:00:16 +1000
Message-ID: <CAN05THR6vjA-18S2uGUgAMfher9WBbE6OpKMFDEktGTiXL8B2Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not attempt unlink-and-retry-rename for SMB2+ mounts
To:     Tom Talpey <ttalpey@microsoft.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Aug 7, 2019 at 1:19 AM Tom Talpey <ttalpey@microsoft.com> wrote:
>
> > -----Original Message-----
> > From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org> On
> > Behalf Of Ronnie Sahlberg
> > Sent: Monday, August 5, 2019 6:47 PM
> > To: linux-cifs <linux-cifs@vger.kernel.org>
> > Cc: Steve French <smfrench@gmail.com>; Ronnie Sahlberg
> > <lsahlber@redhat.com>
> > Subject: [PATCH] cifs: do not attempt unlink-and-retry-rename for SMB2+
> > mounts
> >
> > Normally in smb you can not rename ontop of a destination that is held open
> > except in SMB1 where this is allowed IFF the delete-on-close flag is also set.
>
> The FILE_DELETE_ON_CLOSE flag doesn't really have any significance in the
> protocol, it is passed to the underlying filesystem except in one special case
> where the server validates that the DELETE or GENERIC is granted on the
> share. Did you find some reference in the documents to the contrary?
>

No but emperical testing, and xfstests, show it. It does not just
affect rename() but the same thing happens with "create and replace an
existing file".

There is definitely a conditional somewhere in the SMB server that
affects the behaviour or the delete-on-close flag.


This particular scenario is for the behaviour when we try to rename
onto an existing file that have open handles.
The process used in cifs.ko is :

1, Try to rename the file. This fails with ACCESS_DENIED if there are
open handles
if this fails, then fallback to
2, set delete-on-close
3, try the rename again

In SMB1, this works. In step 3 the file is renamed EVEN if there are
still open handles to it.
In SMB2+ this fails. If there are open handles then this fails with
DELETE_PENDING and the rename will not happen.
(then sometime later when the other process closes its handle then the
file is deleted)

This still happens in windows 2016. Delete-on-close and other similar
unlink() related operations
behave differently between SMB1 and SMB2.



> In other words, I think the fix may be ok, but the server->vals->protocol_id != 0
> conditional may need more thought.
>
> Tom.
>
> > This special case is not supported in SMB2 so should not attempt the unlink-
> > and-try-again
> > since the rename will still fail but we now also delete the destination file.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/inode.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > index 56ca4b8ccaba..fdea45267a39 100644
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -1777,6 +1777,7 @@ cifs_rename2(struct inode *source_dir, struct dentry
> > *source_dentry,
> >       FILE_UNIX_BASIC_INFO *info_buf_target;
> >       unsigned int xid;
> >       int rc, tmprc;
> > +     struct TCP_Server_Info *server;
> >
> >       if (flags & ~RENAME_NOREPLACE)
> >               return -EINVAL;
> > @@ -1786,6 +1787,7 @@ cifs_rename2(struct inode *source_dir, struct dentry
> > *source_dentry,
> >       if (IS_ERR(tlink))
> >               return PTR_ERR(tlink);
> >       tcon = tlink_tcon(tlink);
> > +     server = tcon->ses->server;
> >
> >       xid = get_xid();
> >
> > @@ -1809,6 +1811,14 @@ cifs_rename2(struct inode *source_dir, struct
> > dentry *source_dentry,
> >                           to_name);
> >
> >       /*
> > +      * Do not attempt unlink-then-try-rename-again for SMB2+.
> > +      * Renaming ontop of an existing open file IF the delete-on-close
> > +      * flag is set is only supported for SMB1.
> > +      */
> > +     if (rc == -EACCES && server->vals->protocol_id != 0)
> > +             goto cifs_rename_exit;
> > +
> > +     /*
> >        * No-replace is the natural behavior for CIFS, so skip unlink hacks.
> >        */
> >       if (flags & RENAME_NOREPLACE)
> > --
> > 2.13.6
> > This special case is not supported in SMB2 so should not attempt the unlink-
> > and-try-again
> > since the rename will still fail but we now also delete the destination file.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/inode.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > index 56ca4b8ccaba..fdea45267a39 100644
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -1777,6 +1777,7 @@ cifs_rename2(struct inode *source_dir, struct dentry
> > *source_dentry,
> >       FILE_UNIX_BASIC_INFO *info_buf_target;
> >       unsigned int xid;
> >       int rc, tmprc;
> > +     struct TCP_Server_Info *server;
> >
> >       if (flags & ~RENAME_NOREPLACE)
> >               return -EINVAL;
> > @@ -1786,6 +1787,7 @@ cifs_rename2(struct inode *source_dir, struct dentry
> > *source_dentry,
> >       if (IS_ERR(tlink))
> >               return PTR_ERR(tlink);
> >       tcon = tlink_tcon(tlink);
> > +     server = tcon->ses->server;
> >
> >       xid = get_xid();
> >
> > @@ -1809,6 +1811,14 @@ cifs_rename2(struct inode *source_dir, struct
> > dentry *source_dentry,
> >                           to_name);
> >
> >       /*
> > +      * Do not attempt unlink-then-try-rename-again for SMB2+.
> > +      * Renaming ontop of an existing open file IF the delete-on-close
> > +      * flag is set is only supported for SMB1.
> > +      */
> > +     if (rc == -EACCES && server->vals->protocol_id != 0)
> > +             goto cifs_rename_exit;
> > +
> > +     /*
> >        * No-replace is the natural behavior for CIFS, so skip unlink hacks.
> >        */
> >       if (flags & RENAME_NOREPLACE)
> > --
> > 2.13.6
