Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181E6C28D13
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Aug 2022 04:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiHYEWJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Aug 2022 00:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHYEWJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Aug 2022 00:22:09 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D84533360
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 21:22:08 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id a22so24514891edj.5
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 21:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Mt8p4LDPdC2u3nxJ9397WclUh7TBMUypVVLvZ8I54Pc=;
        b=XaY5x72Dt8WIvG8O9Mt2e8urlWi1TXCRVHXHB9jmLKceQMPwBVn4/AE079fEKxIpD8
         GlJo0OwlVQ+sTnYR/K0DiltMWhj7WXFkavweN//H9SPyXZpyW0yD8uFJt+oinFMGpHuD
         FDFs3uICTYzdlIIVx6FIRAmLziGQXVlPLqGIpjNGr16mjjfXzTQrlnHgEaUDN6oTZ78L
         r+YRem6er/c7MogyiTqQvhoA5wfw+vS6lGyfQON/LY1k/woUvXPqv8BcLpxhlEXCmUHt
         9pNXShkHcseon6pCGRDR7ucjaq2KBAqbcPMDFfhqujg7UgtiDNiGon074hvQkzVlsPjx
         gTzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Mt8p4LDPdC2u3nxJ9397WclUh7TBMUypVVLvZ8I54Pc=;
        b=tGDhWd+lvFjj5BoC5kdmum7aQGCpkgg50mmlE5KzOu+rqZsZWbEeRgSEG7jlGale2W
         3a7jt3Tug0pn1ehoQVFbw1OMgglWgzwxKcLgwKAJG0VJS8PyrVY2hZRXhbZ0KiEs1WY7
         OmgqyMMU0VLemTVzH8m7C8c07JzkqAXE/d3L9KNaztylfkVtSE5Vq3UvkNXd5ArvasDF
         3RPVUntqYpwBlfgeQoO2mErku7Va8jtnjNsnqroMWONwy4Di5VE3Fd5cqk9/8llXjDvb
         OyI7yMOhOtOGsWAXny3ka6xtyhjrT200xAS0qlniSkPi2UgyN9aaNzb65Rd6OcqMwQZ2
         Tw7Q==
X-Gm-Message-State: ACgBeo12qcGO2a+kbGMbzJEbimN34qiGr4KumhbeASSz34Z5aBZQjOQz
        9QLwyFb9BO60eJHVpGHPyI+GAp4R/tsV0R2CPUU=
X-Google-Smtp-Source: AA6agR61MxBNXJ++4QBkLCVZQffRptfKFnJx0SUTDeiBZF0ul9P63cz/o6+4G6+29g3/ZpMkMRK8YFe0PQRaCfzCnOs=
X-Received: by 2002:a05:6402:1d4e:b0:43d:9822:b4d1 with SMTP id
 dz14-20020a0564021d4e00b0043d9822b4d1mr1659293edb.212.1661401326877; Wed, 24
 Aug 2022 21:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220824002756.3659568-1-lsahlber@redhat.com> <20220824002756.3659568-6-lsahlber@redhat.com>
 <3c4e4b94-0807-0d58-c443-3ab9784b69be@talpey.com>
In-Reply-To: <3c4e4b94-0807-0d58-c443-3ab9784b69be@talpey.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 25 Aug 2022 14:21:53 +1000
Message-ID: <CAN05THQnCRwN=Mmqnt2DdP_QrjBf1xD=NJuNXb5sVZu1U73r4g@mail.gmail.com>
Subject: Re: [PATCH 5/6] cifs: find and use the dentry for cached non-root
 directories also
To:     Tom Talpey <tom@talpey.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 24 Aug 2022 at 23:51, Tom Talpey <tom@talpey.com> wrote:
>
> On 8/23/2022 8:27 PM, Ronnie Sahlberg wrote:
> > This allows us to use cached attributes for the entries in a cached
> > directory for as long as a lease is held on the directory itself.
> > Previously we have always allowed "used cached attributes for 1 second"
> > but this extends this to the lifetime of the lease as well as making the
> > caching safer.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >   fs/cifs/cached_dir.c | 70 +++++++++++++++++++++++++++++++++++---------
> >   1 file changed, 56 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> > index 8732903aea03..f4d7700827b3 100644
> > --- a/fs/cifs/cached_dir.c
> > +++ b/fs/cifs/cached_dir.c
> > @@ -5,6 +5,7 @@
> >    *  Copyright (c) 2022, Ronnie Sahlberg <lsahlber@redhat.com>
> >    */
> >
> > +#include <linux/namei.h>
> >   #include "cifsglob.h"
> >   #include "cifsproto.h"
> >   #include "cifs_debug.h"
> > @@ -113,6 +114,50 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
> >       return cfid;
> >   }
> >
> > +static struct dentry *
> > +path_to_dentry(struct cifs_sb_info *cifs_sb, const char *full_path)
> > +{
> > +     struct dentry *dentry;
> > +     char *path = NULL;
> > +     char *s, *p;
> > +     char sep;
> > +
> > +     path = kstrdup(full_path, GFP_ATOMIC);
> > +     if (path == NULL)
> > +             return ERR_PTR(-ENOMEM);
>
> Why make a copy of the path? I don't see anything in the code
> below that modifies its contents...

Thanks!
You are right. I have fixed it.

>
> > +
> > +     sep = CIFS_DIR_SEP(cifs_sb);
> > +     dentry = dget(cifs_sb->root);
> > +     s = path;
> > +
> > +     do {
> > +             struct inode *dir = d_inode(dentry);
> > +             struct dentry *child;
> > +
> > +             if (!S_ISDIR(dir->i_mode)) {
> > +                     dput(dentry);
> > +                     dentry = ERR_PTR(-ENOTDIR);
> > +                     break;
> > +             }
> > +
> > +             /* skip separators */
> > +             while (*s == sep)
> > +                     s++;
> > +             if (!*s)
> > +                     break;
> > +             p = s++;
> > +             /* next separator */
> > +             while (*s && *s != sep)
> > +                     s++;
> > +
> > +             child = lookup_positive_unlocked(p, dentry, s - p);
> > +             dput(dentry);
> > +             dentry = child;
> > +     } while (!IS_ERR(dentry));
> > +     kfree(path);
> > +     return dentry;
> > +}
> > +
> >   /*
> >    * Open the and cache a directory handle.
> >    * If error then *cfid is not initialized.
> > @@ -139,7 +184,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >       struct dentry *dentry = NULL;
> >       struct cached_fid *cfid;
> >       struct cached_fids *cfids;
> > -
> >
> >       if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
> >           is_smb1_server(tcon->ses->server))
> > @@ -155,13 +199,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >       if (cifs_sb->root == NULL)
> >               return -ENOENT;
> >
> > -     /*
> > -      * TODO: for better caching we need to find and use the dentry also
> > -      * for non-root directories.
> > -      */
> > -     if (!strlen(path))
> > -             dentry = cifs_sb->root;
>
> Test path[0] instead of calling strlen?

Done.

>
> > -
> >       utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> >       if (!utf16_path)
> >               return -ENOMEM;
> > @@ -253,12 +290,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >       oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
> >   #endif /* CIFS_DEBUG2 */
> >
> > -     cfid->tcon = tcon;
> > -     if (dentry) {
> > -             cfid->dentry = dentry;
> > -             dget(dentry);
> > -     }
> > -     /* BB TBD check to see if oplock level check can be removed below */
> >       if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
> >               goto oshr_free;
> >       }
> > @@ -277,6 +308,17 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> >                               &rsp_iov[1], sizeof(struct smb2_file_all_info),
> >                               (char *)&cfid->file_all_info))
> >               cfid->file_all_info_is_valid = true;
> > +
> > +     if (!strlen(path)) {
> > +             dentry = dget(cifs_sb->root);
> > +             cfid->dentry = dentry;
> > +     } else{
> > +             dentry = path_to_dentry(cifs_sb, path);
> > +             if (IS_ERR(dentry))
> > +                     goto oshr_free;
> > +             cfid->dentry = dentry;
> > +     }
>
> Pull cfid->dentry = dentry out of the above conditionals and
> just set it here for both cases.

Of course.  done.
Thanks.
>
> > +     cfid->tcon = tcon;
> >       cfid->time = jiffies;
> >       cfid->is_open = true;
> >       cfid->has_lease = true;
