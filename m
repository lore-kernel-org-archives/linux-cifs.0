Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE273C13E2
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 10:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776855560; cv=none; b=Ez+ym4lAukHCuJUNLbcjUNwNtpMu7bHy+khH9q9kothb0kLnEu62LKTjbByv/bGTd8ES1AZbOCluDQMZjcRtD+pu70J1GOiYD6GBcpQKSoVs8rUPid2TqxmINJ6Vo65WlIQuaO4LvwUYf868XjrJX5dTZurFQqbgsG6zBjf8a3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776855560; c=relaxed/simple;
	bh=fmI1LE/7ouZ+T6zgVX97t848L2T3YbV0wMRnT3P6XTk=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=gTjh94EEVc54DAAUfPcOmYWS5FChHZGoj4I/7+Zuse8g04sveH5M7vJFJNziQ1AvOcgpRHcYYmtWPwQK9NyBtxHNvfcjdPlGZTR9P5ZyxHe5JVxzWRBJEglltvA/WsH9BC6M1YHq5DW8I/e6slEX8c96Vv5STQ7HwD5p0wisKVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=iTPI6XYP; arc=none smtp.client-ip=195.121.94.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="iTPI6XYP"
X-KPN-MessageId: 4a4b0fca-3e3a-11f1-afdd-005056994fde
Received: from mta.kpnmail.nl (unknown [10.31.161.188])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 4a4b0fca-3e3a-11f1-afdd-005056994fde;
	Wed, 22 Apr 2026 12:59:10 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.189])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 4a5521df-3e3a-11f1-80f3-00505699693e;
	Wed, 22 Apr 2026 12:59:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=vcllORq6duUusvXfjvMJ+rNXZ13ip/Bca/9oQnX5iVw=;
	b=iTPI6XYPOZmLV5JJupGXLtiPrb133R+RI24MirLKoLOUhLfDF6ZMU6Ie9rhCYID38D10yIYztZA+p
	 gO3IwcvVQgxIQBClHvGVQRXNaN38eVfURd/NS8ND62MfN1AzkhAZEvi+iF9hop+JvB2MmUdO1P1EfW
	 APX/KdROQHOrUAGgplQ2zWyOzjtpHUCfl7YVVsoo/ugw653XC6MR4dGw+N6ztqO1aJC9jxoGf8bBI3
	 QW4SUW0SWnUSL21KTZpQPeYUs8m2Oqn0i9KIdSgcF9jl2zcb3/dDC6vdFtrihsmGrpTzypQw1R7Vy5
	 IhrHxkWxVDUjYW9d+aR5a51C3xdPcNA==
X-KPN-MID: 33|LapmFKO7ER9iNGgpfHKbXxPiTPk1aJEXdRlxxN05ixQG0u0q2cLgq6e63D5lXLz
 YvAUdzJEaYFXttdVemuEeQ1D2cIK844eLVgxmHejWdFI=
X-CMASSUN: 33|dPpvh8M7Ocb7f7BhCWXZZq52eZmto7GGFzsqb3fDAnadmyCOJKA77sCJaQ1I2A8
 YsdyRUie3dv0WX+aJTlX9eQ==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh08 (cpxoxapps-mh08.personalcloud.so.kpn.org [10.128.135.214])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 4a4622fa-3e3a-11f1-94b1-00505699eff2;
	Wed, 22 Apr 2026 12:59:10 +0200 (CEST)
Date: Wed, 22 Apr 2026 12:59:10 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>,
	"open list:FILESYSTEMS (VFS and infrastructure)"
 <linux-fsdevel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
	"open list:KERNEL SMB3 SERVER (KSMBD)" <linux-cifs@vger.kernel.org>
Message-ID: <358172838.1020532.1776855550028@kpc.webmail.kpnmail.nl>
In-Reply-To: <CAOQ4uxhh1kGnuY7sKTqti12tjFD4t1vCJ0qQrGngU2+0idXtpQ@mail.gmail.com>
References: <20260419161620.564854-1-jkoolstra@xs4all.nl>
 <CAOQ4uxhh1kGnuY7sKTqti12tjFD4t1vCJ0qQrGngU2+0idXtpQ@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: replace ints with enum component_type for
 LAST_XXX
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal


> Op 20-04-2026 12:29 CEST schreef Amir Goldstein <amir73il@gmail.com>:
> 
> Please update documentation entry for last_type in
> Documentation/filesystems/path-lookup.rst
> 

Yes, thanks for the reminder!

> > -       unsigned        depth;
> > -       int             total_link_count;
> > +       struct path             path;
> > +       struct qstr             last;
> > +       struct path             root;
> > +       struct inode            *inode; /* path.dentry.d_inode */
> > +       unsigned int            flags, state;
> > +       unsigned                seq, next_seq, m_seq, r_seq;
> > +       enum component_type     last_type;
> 
> I really dislike all this white space churn just because the enum name
> is so long. If it was long for a good reason - increasing readability -
> I may have conceded, but I don't think that is the case.
> 
> I do not think that 'component_type' is more clear than 'last_type'
> for a developer passing by reading the code.
> If anything, the opposite, because 'last_type' or 'type' variables always
> appear in the same function with 'last' variable, so it is more clear WHICH
> object the type is referring to and matches the LAST_ enum prefix.

OK, I see your point. I have changed it back. The reason I preferred
component_type is that the whole "last" thing is just incidental. There is
nothing dependent on these components being "last", it's just that the
enum values are only used in that context. It would make more sense to
restrict the enum to namei.c and use NORMAL, DOT, or something like that.
But I do agree that isn't worth the churn :) 

> 
> > +       unsigned                depth;
> > +       int                     total_link_count;
> >         struct saved {
> >                 struct path link;
> >                 struct delayed_call done;
> > @@ -2221,7 +2221,7 @@ static struct dentry *follow_dotdot(struct nameidata *nd)
> >         return dget(nd->path.dentry);
> >  }
> >
> > -static const char *handle_dots(struct nameidata *nd, int type)
> > +static const char *handle_dots(struct nameidata *nd, enum component_type type)
> >  {
> >         if (type == LAST_DOTDOT) {
> >                 const char *error = NULL;
> > @@ -2869,7 +2869,7 @@ static int path_parentat(struct nameidata *nd, unsigned flags,
> >  /* Note: this does not consume "name" */
> >  static int __filename_parentat(int dfd, struct filename *name,
> >                                unsigned int flags, struct path *parent,
> > -                              struct qstr *last, int *type,
> > +                              struct qstr *last, enum component_type *type,
> >                                const struct path *root)
> >  {
> >         int retval;
> > @@ -2894,7 +2894,7 @@ static int __filename_parentat(int dfd, struct filename *name,
> >
> >  static int filename_parentat(int dfd, struct filename *name,
> >                              unsigned int flags, struct path *parent,
> > -                            struct qstr *last, int *type)
> > +                            struct qstr *last, enum component_type *type)
> >  {
> >         return __filename_parentat(dfd, name, flags, parent, last, type, NULL);
> >  }
> > @@ -2963,7 +2963,8 @@ static struct dentry *__start_removing_path(int dfd, struct filename *name,
> >         struct path parent_path __free(path_put) = {};
> >         struct dentry *d;
> >         struct qstr last;
> > -       int type, error;
> > +       enum component_type type;
> > +       int error;
> >
> >         error = filename_parentat(dfd, name, 0, &parent_path, &last, &type);
> >         if (error)
> > @@ -3009,7 +3010,8 @@ struct dentry *kern_path_parent(const char *name, struct path *path)
> >         CLASS(filename_kernel, filename)(name);
> >         struct dentry *d;
> >         struct qstr last;
> > -       int type, error;
> > +       enum component_type type;
> > +       int error;
> >
> >         error = filename_parentat(AT_FDCWD, filename, 0, &parent_path, &last, &type);
> >         if (error)
> > @@ -3057,7 +3059,7 @@ EXPORT_SYMBOL(kern_path);
> >   * @root: pointer to struct path of the base directory
> >   */
> >  int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
> > -                          struct path *parent, struct qstr *last, int *type,
> > +                          struct path *parent, struct qstr *last, enum component_type *type,
> >                            const struct path *root)
> >  {
> >         return  __filename_parentat(AT_FDCWD, filename, flags, parent, last,
> > @@ -4903,7 +4905,7 @@ static struct dentry *filename_create(int dfd, struct filename *name,
> >         bool want_dir = lookup_flags & LOOKUP_DIRECTORY;
> >         unsigned int reval_flag = lookup_flags & LOOKUP_REVAL;
> >         unsigned int create_flags = LOOKUP_CREATE | LOOKUP_EXCL;
> > -       int type;
> > +       enum component_type type;
> >         int error;
> >
> >         error = filename_parentat(dfd, name, reval_flag, path, &last, &type);
> > @@ -5365,7 +5367,7 @@ int filename_rmdir(int dfd, struct filename *name)
> >         struct dentry *dentry;
> >         struct path path;
> >         struct qstr last;
> > -       int type;
> > +       enum component_type type;
> >         unsigned int lookup_flags = 0;
> >         struct delegated_inode delegated_inode = { };
> >  retry:
> > @@ -5383,6 +5385,7 @@ int filename_rmdir(int dfd, struct filename *name)
> >         case LAST_ROOT:
> >                 error = -EBUSY;
> >                 goto exit2;
> > +       case LAST_NORM: ; // OK
> 
> I was not aware that the compiler warns about missing cases for enums -
> cool feature.
> but that needs to be a break; rather than fallthough the end
> and as a matter of taste, I would put the valid case first - not critical.
> 
> >         }
> >
> >         error = mnt_want_write(path.mnt);
> > @@ -5507,7 +5510,7 @@ int filename_unlinkat(int dfd, struct filename *name)
> >         struct dentry *dentry;
> >         struct path path;
> >         struct qstr last;
> > -       int type;
> > +       enum component_type type;
> >         struct inode *inode;
> >         struct delegated_inode delegated_inode = { };
> >         unsigned int lookup_flags = 0;
> > @@ -6074,7 +6077,7 @@ int filename_renameat2(int olddfd, struct filename *from,
> >         struct renamedata rd;
> >         struct path old_path, new_path;
> >         struct qstr old_last, new_last;
> > -       int old_type, new_type;
> > +       enum component_type old_type, new_type;
> >         struct delegated_inode delegated_inode = { };
> >         unsigned int lookup_flags = 0;
> >         bool should_retry = false;
> > diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> > index d08973b288e5..b12d481f5ba9 100644
> > --- a/fs/smb/server/vfs.c
> > +++ b/fs/smb/server/vfs.c
> > @@ -56,7 +56,8 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
> >  {
> >         struct qstr last;
> >         const struct path *root_share_path = &share_conf->vfs_path;
> > -       int err, type;
> > +       int err;
> > +       enum component_type type;
> >         struct dentry *d;
> >
> >         if (pathname[0] == '\0') {
> > @@ -668,7 +669,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
> >         struct renamedata rd;
> >         struct ksmbd_share_config *share_conf = work->tcon->share_conf;
> >         struct ksmbd_file *parent_fp;
> > -       int new_type;
> > +       enum component_type new_type;
> >         int err, lookup_flags = LOOKUP_NO_SYMLINKS;
> >
> >         if (ksmbd_override_fsids(work))
> > diff --git a/include/linux/namei.h b/include/linux/namei.h
> > index 58600cf234bc..fa3ae87762b7 100644
> > --- a/include/linux/namei.h
> > +++ b/include/linux/namei.h
> > @@ -16,7 +16,7 @@ enum { MAX_NESTED_LINKS = 8 };
> >  /*
> >   * Type of the last component on LOOKUP_PARENT
> >   */
> > -enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
> > +enum component_type {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
> 
> Please use last_type to match the LAST_ prefix.
> 
> TBH, the thing that bothers me most is why is this enum exposed
> outside of namei.c
> in the first place?
> 
> >
> >  /* pathwalk mode */
> >  #define LOOKUP_FOLLOW          BIT(0)  /* follow links at the end */
> > @@ -70,7 +70,7 @@ static inline void end_removing_path(const struct path *path , struct dentry *de
> >         end_creating_path(path, dentry);
> >  }
> >  int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
> > -                          struct path *parent, struct qstr *last, int *type,
> > +                          struct path *parent, struct qstr *last, enum component_type *type,
> >                            const struct path *root);
> 
> As your patch demonstrates, the only use of enum last_type outside of namei.c is
> in ksmbd calls to vfs_path_parent_lookup().
> 
> This is an "internal" lookup helper that was exposed by commit
> 74d7970febf7e ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
> 
> This commit appears to be using the helper inconsistently in
> its two call sites, because ksmbd_vfs_rename(), is not checking the
> unlikely(type != LAST_NORM) case.
> 
> Perhaps it would be wiser not to expose enum last_type at all and move
> the unlikely(type != LAST_NORM) check into the helper itself in namei.c.
> 
> WDYT?
> 

Agreed. See my email to Al in this thread.

> Thanks,
> Amir.

Thanks,
Jori.
