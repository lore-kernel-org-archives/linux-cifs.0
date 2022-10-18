Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4FBC433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Oct 2022 23:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiJRXr1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Oct 2022 19:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiJRXr1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Oct 2022 19:47:27 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDE5CD5C3
        for <linux-cifs@vger.kernel.org>; Tue, 18 Oct 2022 16:47:25 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r14so22828358edc.7
        for <linux-cifs@vger.kernel.org>; Tue, 18 Oct 2022 16:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rsByzxwZBbNt+aiTS5mO93KQQ/vNF2uz+dDrBXn2I2M=;
        b=fe3bEEex7c5vfRT1Px3oRjaoV8HvK4/cFPb4YLY/JlBuyEFbMMX3vQt0eclRZZtKX8
         f1o+hA5D6wI3BsGoFRmeIzqm95sItVXrBTf7L2yNmw9Ym7DQ32YVXDUPdPPX2np/+yn2
         Ybdc0eauGGsjrqXeJfq+lzEIxZlHUq+CQHel1oW2ePPh2JWU3zPLRyKU1K170jNTqf0S
         Yl5G0BY6IPtKR+tfghX8aeICzx6M2taei/pd37fXG4iOfGO+XayEPog6yLXvPIpPAapo
         NJNNv7vddnsyqgpCR+SViIla8dDYX2nPQV3OTHlx1b7dN8VEebE6ExEW1muhj9LhXBHK
         a5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rsByzxwZBbNt+aiTS5mO93KQQ/vNF2uz+dDrBXn2I2M=;
        b=AAvErWTr2PMAlXeo/om0n6yyg986yvI28RWja04fGXO2cgSnFhhU2fkIVWQhkmPZUz
         +xZu7lwN3m4m9M2x6aeyYH+qkJPC83SOqqlPXCJh3spQd2NzrUK///UvL6gimsR/dznk
         yVLVMUL29aVjNRHMehq3s1Qlks7HRUJM9ESDUOcW93u3a33FaV52YvMTNJ0OtML7lGNN
         35ChJXzm2mhBCqE1YGjTIwFlubsc/WfpKsGXdEsuF32EhQq3GvciAwtFxFnQOCVO+7Gh
         D7NpEFQPrNg8IdPo1B2WERK3XRAZNTRCoCFUwfvWFS/SfFYbNThewUO1ywBtxJWDFsXK
         y27Q==
X-Gm-Message-State: ACrzQf2aJc8dob+rirnJuqV/QR2iEmuGedBBqP8D1cdHSMl7IyHlvsQF
        aJskXgEZ4V6JSz7XO2TeZj+WacjXcyPYoapUW9o=
X-Google-Smtp-Source: AMsMyM4xCEYkHl9wlAf63cSZo+AFFi2XNuIL+9RV7BLYxG8oNYvIgy1GmD5cEijDH4+TAnNftEtuhP+u60irkzTIWmA=
X-Received: by 2002:a05:6402:298b:b0:44f:20a:2db2 with SMTP id
 eq11-20020a056402298b00b0044f020a2db2mr4895892edb.138.1666136844303; Tue, 18
 Oct 2022 16:47:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221018073910.1732992-1-lsahlber@redhat.com> <20221018073910.1732992-2-lsahlber@redhat.com>
 <b1454884-cc28-9de5-8dc2-b96f92f1d8e4@talpey.com>
In-Reply-To: <b1454884-cc28-9de5-8dc2-b96f92f1d8e4@talpey.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 19 Oct 2022 09:47:12 +1000
Message-ID: <CAN05THTtZhkN-MVefP5Q4Z2GBsX_-xU2K4WCFfvjJogJSp0kFQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: drop the lease for cached directories on rmdir or rename
To:     Tom Talpey <tom@talpey.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 19 Oct 2022 at 00:27, Tom Talpey <tom@talpey.com> wrote:
>
> On 10/18/2022 3:39 AM, Ronnie Sahlberg wrote:
> > When we delete or rename a directory we must also drop any cached lease we have
> > on the directory.
>
> Just curious, why drop the lease on rename? I guess this is related
> to setting ReplaceIfExists, but that would apply to a lease on the
> existing (replaced) directory, which would then become deleted?

You might be right in that, but I think the lease will be broken by
the rename anyway
so by deliberately closing it saves half a roundtrip for the rename to complete.
(you get a lease break both for the directory you rename and also for
the parent directory as far as I can see in traces)

>
> I'm probably undercaffeinated, if not.
>
> Tom.
>
> > Fixes: a350d6e73f5e ("cifs: enable caching of directories for which a lease
> > is held")
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >   fs/cifs/cached_dir.c | 21 +++++++++++++++++++++
> >   fs/cifs/cached_dir.h |  4 ++++
> >   fs/cifs/smb2inode.c  |  2 ++
> >   3 files changed, 27 insertions(+)
> >
> > diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> > index ffc924296e59..6e689c4c8d1b 100644
> > --- a/fs/cifs/cached_dir.c
> > +++ b/fs/cifs/cached_dir.c
> > @@ -340,6 +340,27 @@ smb2_close_cached_fid(struct kref *ref)
> >       free_cached_dir(cfid);
> >   }
> >
> > +void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
> > +                          const char *name, struct cifs_sb_info *cifs_sb)
> > +{
> > +     struct cached_fid *cfid = NULL;
> > +     int rc;
> > +
> > +     rc = open_cached_dir(xid, tcon, name, cifs_sb, true, &cfid);
> > +     if (rc) {
> > +             cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
> > +             return;
> > +     }
> > +     spin_lock(&cfid->cfids->cfid_list_lock);
> > +     if (cfid->has_lease) {
> > +             cfid->has_lease = false;
> > +             kref_put(&cfid->refcount, smb2_close_cached_fid);
> > +     }
> > +     spin_unlock(&cfid->cfids->cfid_list_lock);
> > +     close_cached_dir(cfid);
> > +}
> > +
> > +
> >   void close_cached_dir(struct cached_fid *cfid)
> >   {
> >       kref_put(&cfid->refcount, smb2_close_cached_fid);
> > diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
> > index e536304ca2ce..2f4e764c9ca9 100644
> > --- a/fs/cifs/cached_dir.h
> > +++ b/fs/cifs/cached_dir.h
> > @@ -69,6 +69,10 @@ extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
> >                                    struct dentry *dentry,
> >                                    struct cached_fid **cfid);
> >   extern void close_cached_dir(struct cached_fid *cfid);
> > +extern void drop_cached_dir_by_name(const unsigned int xid,
> > +                                 struct cifs_tcon *tcon,
> > +                                 const char *name,
> > +                                 struct cifs_sb_info *cifs_sb);
> >   extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
> >   extern void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
> >   extern int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
> > diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> > index a6640e6ea58b..68e08c85fbb8 100644
> > --- a/fs/cifs/smb2inode.c
> > +++ b/fs/cifs/smb2inode.c
> > @@ -655,6 +655,7 @@ int
> >   smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
> >          struct cifs_sb_info *cifs_sb)
> >   {
> > +     drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
> >       return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
> >                               CREATE_NOT_FILE, ACL_NO_MODE,
> >                               NULL, SMB2_OP_RMDIR, NULL, NULL, NULL);
> > @@ -698,6 +699,7 @@ smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
> >   {
> >       struct cifsFileInfo *cfile;
> >
> > +     drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
> >       cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
> >
> >       return smb2_set_path_attr(xid, tcon, from_name, to_name,
