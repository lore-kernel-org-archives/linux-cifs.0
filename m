Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C14F1D319B;
	Mon,  7 Oct 2024 18:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728326218; cv=none; b=spFKu3lTS8ZeJmrJQh+hFTlFyd19sxC4ZKJrGGIQnNlMxg7ZYQoQtavXnRE8IFJ02zrrw6r5zmadgkVF3SKqhvaYrvu2mRaegv6mvad//AZ0o40qX011lWz6xyPdVZdgSZSSGsVVp4Afhrs49fpXc5Q04cF8bHNlYbii+SbYfpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728326218; c=relaxed/simple;
	bh=oTQz3u/GKVtS8UazqB6xHbFPuhZCc/aFaBZTg3bQ4gQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HYQi7Wtbq3WXpmjZmBcvtAirogWNrAxQHtQcGRzZTS22RRf0epSYidUcjBVq5byRad6yYN+K+9XECea/rVEteDHSuGEKj9wVq+2G8yxOqG2UOcbiEGzyjZ1Sphz4K77+feytaPNqmt4El94bUoTPGBfOGwOhONCUYJ84TkOGnCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSgsAWvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSgsAWvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190B2C4CEC6;
	Mon,  7 Oct 2024 18:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728326217;
	bh=oTQz3u/GKVtS8UazqB6xHbFPuhZCc/aFaBZTg3bQ4gQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MSgsAWvV2JpmjDeAG30lAiZF9boxNX3ZGqiM7yc7rT+b57CbnqxrtkCK/PLftP3sF
	 +Bc8AoLVahlXXqfMz+agYv4La04htewPw4Q+ofkkoid1lFGe6gaPTw43Y0jxspkfim
	 XPTWcbmxq3TD7Ck4WYdtYMsldIVYTjqi5upCsxEMHBJL2gCWCb0/1BQvJDZHU3MY2p
	 WaO6Z8ado5q/PsByrT95rxPR0r6XksX2UeMkYaxAlSoIsJ4YeMYcKetWx7T0V2OYGb
	 HURbdMv7Hd5oWXwO/u+zNR/X11IxL080T5h49c/AEkAaOCIjkzc6rQLrbAwOGfmFo9
	 1aBMtDYHYP1gA==
Received: by pali.im (Postfix)
	id 77EE5792; Mon,  7 Oct 2024 20:36:50 +0200 (CEST)
Date: Mon, 7 Oct 2024 20:36:50 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] cifs: Add mount option -o reparse=native
Message-ID: <20241007183650.aw3skuztljpgk2bs@pali>
References: <20241006100046.30772-1-pali@kernel.org>
 <20241006100046.30772-2-pali@kernel.org>
 <CAH2r5muLa_0L5LL4ipQkzEHOUdtYtJVAD29AAjQOaun9dWmK0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5muLa_0L5LL4ipQkzEHOUdtYtJVAD29AAjQOaun9dWmK0g@mail.gmail.com>
User-Agent: NeoMutt/20180716

Currently choosing how new symlinks are created is quite complicated.

Without these patch series, by default new symlinks are created via
native reparse points, even when reparse=nfs or reparse=wsl is
specified. There is no possibility to create a NFS-style or WSL-style
symlink yet, and this patch series address this missing functionality.
When option -o sfu is specified then all new symlinks are created in
SFU-style, independently of -o reparse option. And when -o mfsymlinks is
specified then all new symlinks are created in mf style, independently
of -o reparse and -o sfu options.

This patch series does not change -o sfu and -o mfsymlinks overrides, it
just changes the way how -o reparse is handled.

I think that we have too many mount options which specify ability to
choose symlink format and complicated overrides, which option has higher
priority than other.

What about rather introducing a new option like:

-o symlinkformat=native|nfs|wsl|sfu|mf|unix|none

which explicitly say which format will be chosen when creating a new
symlink?

IIRC in SMB we can create a new symlink via:
- ioctl with native symlink reparse point
- ioctl with nfs reparse point
- ioctl with wsl symlink reparse point
- create sfu system file
- create mf file
- SMB1 unix create symlink command
(have I forgot for something?)

On Sunday 06 October 2024 23:28:29 Steve French wrote:
> This is a good point about how to override the "native" symlink format
> when using reparse=nfs  (a similar question could come up, if for
> security reasons you use "mfsymlinks" for symlinks - ie "client side
> symlinks" (which are safer) - but use reparse=nfs for everything else.
>   But ... there is probably a better way to handle the mount option
> for default symlink creation format more clearly (perhaps use of
> "nativesymlinks" (default) or "mfsymlinks" if specified, overrides
> "reparse=wsl" or "reparse=nfs" for symlink format only.   User can
> specify "nativesymlinks=no" if they want to use the "reparse=" format
> for symlinks.   For the sfu case it might be trickier but could fall
> back to sfu symlinks if "nativesymlinks=no" or if they fail?!
> Thoughts?
> 
> On Sun, Oct 6, 2024 at 5:01 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > Currently the default option is -o reparse=default which is same as
> > -o reparse=nfs. Currently mount option -o reparse=nfs does not create
> > symlink in NFS reparse point style, which is misleading.
> >
> > Add new -o reparse= options "native", "native+nfs" and "native+wsl" to make
> > it more clear and allow to choose the expected reparse point types.
> >
> > "native" would mean to create new special files only with reparse point
> > tags which are natively supported by SMB or Windows. Types which are not
> > natively supported cannot be created.
> >
> > "native+nfs" would mean same as native, but fallback to "nfs" for
> > unsupported types.
> >
> > "native+wsl" would mean to fallback to "wsl".
> >
> > Change also meaning of "nfs" and "wsl" to always create special types with
> > nfs / wsl style.
> >
> > And change also the default option to "native+nfs", so the default behavior
> > stay same as without this change. Without this change were all symlinks
> > created in native Windows/SMB form and this stay same with this change too.
> >
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/cifsglob.h   | 15 ++++++++--
> >  fs/smb/client/fs_context.c | 12 ++++++++
> >  fs/smb/client/fs_context.h |  3 ++
> >  fs/smb/client/reparse.c    | 58 +++++++++++++++++++++++++++++++-------
> >  fs/smb/client/reparse.h    |  2 ++
> >  5 files changed, 77 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index 260b553283ef..367f0ac6400d 100644
> > --- a/fs/smb/client/cifsglob.h
> > +++ b/fs/smb/client/cifsglob.h
> > @@ -154,14 +154,23 @@ enum securityEnum {
> >  };
> >
> >  enum cifs_reparse_type {
> > -       CIFS_REPARSE_TYPE_NFS,
> > -       CIFS_REPARSE_TYPE_WSL,
> > -       CIFS_REPARSE_TYPE_DEFAULT = CIFS_REPARSE_TYPE_NFS,
> > +       CIFS_REPARSE_TYPE_NATIVE, /* native symlinks only */
> > +       CIFS_REPARSE_TYPE_NATIVE_NFS, /* native for symlinks, nfs for others */
> > +       CIFS_REPARSE_TYPE_NATIVE_WSL, /* native for symlinks, wsl for others */
> > +       CIFS_REPARSE_TYPE_NFS, /* nfs for everything */
> > +       CIFS_REPARSE_TYPE_WSL, /* wsl for everything */
> > +       CIFS_REPARSE_TYPE_DEFAULT = CIFS_REPARSE_TYPE_NATIVE_NFS,
> >  };
> >
> >  static inline const char *cifs_reparse_type_str(enum cifs_reparse_type type)
> >  {
> >         switch (type) {
> > +       case CIFS_REPARSE_TYPE_NATIVE:
> > +               return "native";
> > +       case CIFS_REPARSE_TYPE_NATIVE_NFS:
> > +               return "native+nfs";
> > +       case CIFS_REPARSE_TYPE_NATIVE_WSL:
> > +               return "native+wsl";
> >         case CIFS_REPARSE_TYPE_NFS:
> >                 return "nfs";
> >         case CIFS_REPARSE_TYPE_WSL:
> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > index 22b550860cc8..e5de84912e3d 100644
> > --- a/fs/smb/client/fs_context.c
> > +++ b/fs/smb/client/fs_context.c
> > @@ -303,6 +303,9 @@ cifs_parse_cache_flavor(struct fs_context *fc, char *value, struct smb3_fs_conte
> >
> >  static const match_table_t reparse_flavor_tokens = {
> >         { Opt_reparse_default,  "default" },
> > +       { Opt_reparse_native,   "native" },
> > +       { Opt_reparse_native_nfs, "native+nfs" },
> > +       { Opt_reparse_native_wsl, "native+wsl" },
> >         { Opt_reparse_nfs,      "nfs" },
> >         { Opt_reparse_wsl,      "wsl" },
> >         { Opt_reparse_err,      NULL },
> > @@ -317,6 +320,15 @@ static int parse_reparse_flavor(struct fs_context *fc, char *value,
> >         case Opt_reparse_default:
> >                 ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
> >                 break;
> > +       case Opt_reparse_native:
> > +               ctx->reparse_type = CIFS_REPARSE_TYPE_NATIVE;
> > +               break;
> > +       case Opt_reparse_native_nfs:
> > +               ctx->reparse_type = CIFS_REPARSE_TYPE_NATIVE_NFS;
> > +               break;
> > +       case Opt_reparse_native_wsl:
> > +               ctx->reparse_type = CIFS_REPARSE_TYPE_NATIVE_WSL;
> > +               break;
> >         case Opt_reparse_nfs:
> >                 ctx->reparse_type = CIFS_REPARSE_TYPE_NFS;
> >                 break;
> > diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> > index 8dd12498ffd8..1011176ba3b7 100644
> > --- a/fs/smb/client/fs_context.h
> > +++ b/fs/smb/client/fs_context.h
> > @@ -43,6 +43,9 @@ enum {
> >
> >  enum cifs_reparse_parm {
> >         Opt_reparse_default,
> > +       Opt_reparse_native,
> > +       Opt_reparse_native_nfs,
> > +       Opt_reparse_native_wsl,
> >         Opt_reparse_nfs,
> >         Opt_reparse_wsl,
> >         Opt_reparse_err
> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > index 6e9d914bac41..38fe0a710c65 100644
> > --- a/fs/smb/client/reparse.c
> > +++ b/fs/smb/client/reparse.c
> > @@ -14,6 +14,20 @@
> >  #include "fs_context.h"
> >  #include "reparse.h"
> >
> > +static int mknod_nfs(unsigned int xid, struct inode *inode,
> > +                    struct dentry *dentry, struct cifs_tcon *tcon,
> > +                    const char *full_path, umode_t mode, dev_t dev,
> > +                    const char *symname);
> > +
> > +static int mknod_wsl(unsigned int xid, struct inode *inode,
> > +                    struct dentry *dentry, struct cifs_tcon *tcon,
> > +                    const char *full_path, umode_t mode, dev_t dev,
> > +                    const char *symname);
> > +
> > +static int create_native_symlink(const unsigned int xid, struct inode *inode,
> > +                                struct dentry *dentry, struct cifs_tcon *tcon,
> > +                                const char *full_path, const char *symname);
> > +
> >  static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
> >                                            const unsigned int xid,
> >                                            const char *full_path,
> > @@ -23,6 +37,26 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
> >  int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
> >                                 struct dentry *dentry, struct cifs_tcon *tcon,
> >                                 const char *full_path, const char *symname)
> > +{
> > +       struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
> > +
> > +       switch (ctx->reparse_type) {
> > +       case CIFS_REPARSE_TYPE_NATIVE:
> > +       case CIFS_REPARSE_TYPE_NATIVE_NFS:
> > +       case CIFS_REPARSE_TYPE_NATIVE_WSL:
> > +               return create_native_symlink(xid, inode, dentry, tcon, full_path, symname);
> > +       case CIFS_REPARSE_TYPE_NFS:
> > +               return mknod_nfs(xid, inode, dentry, tcon, full_path, S_IFLNK, 0, symname);
> > +       case CIFS_REPARSE_TYPE_WSL:
> > +               return mknod_wsl(xid, inode, dentry, tcon, full_path, S_IFLNK, 0, symname);
> > +       default:
> > +               return -EOPNOTSUPP;
> > +       }
> > +}
> > +
> > +static int create_native_symlink(const unsigned int xid, struct inode *inode,
> > +                                struct dentry *dentry, struct cifs_tcon *tcon,
> > +                                const char *full_path, const char *symname)
> >  {
> >         struct reparse_symlink_data_buffer *buf = NULL;
> >         struct cifs_open_info_data data = {};
> > @@ -363,6 +397,7 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
> >         case NFS_SPECFILE_SOCK:
> >                 dlen = 0;
> >                 break;
> > +       case NFS_SPECFILE_LNK: /* TODO: add support for NFS symlinks */
> >         default:
> >                 return -EOPNOTSUPP;
> >         }
> > @@ -381,7 +416,8 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
> >
> >  static int mknod_nfs(unsigned int xid, struct inode *inode,
> >                      struct dentry *dentry, struct cifs_tcon *tcon,
> > -                    const char *full_path, umode_t mode, dev_t dev)
> > +                    const char *full_path, umode_t mode, dev_t dev,
> > +                    const char *symname)
> >  {
> >         struct cifs_open_info_data data;
> >         struct reparse_posix_data *p;
> > @@ -421,6 +457,7 @@ static int wsl_set_reparse_buf(struct reparse_data_buffer *buf,
> >         case IO_REPARSE_TAG_LX_FIFO:
> >         case IO_REPARSE_TAG_AF_UNIX:
> >                 break;
> > +       case IO_REPARSE_TAG_LX_SYMLINK: /* TODO: add support for WSL symlinks */
> >         default:
> >                 return -EOPNOTSUPP;
> >         }
> > @@ -518,7 +555,8 @@ static int wsl_set_xattrs(struct inode *inode, umode_t _mode,
> >
> >  static int mknod_wsl(unsigned int xid, struct inode *inode,
> >                      struct dentry *dentry, struct cifs_tcon *tcon,
> > -                    const char *full_path, umode_t mode, dev_t dev)
> > +                    const char *full_path, umode_t mode, dev_t dev,
> > +                    const char *symname)
> >  {
> >         struct cifs_open_info_data data;
> >         struct reparse_data_buffer buf;
> > @@ -563,17 +601,17 @@ int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
> >                        const char *full_path, umode_t mode, dev_t dev)
> >  {
> >         struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
> > -       int rc = -EOPNOTSUPP;
> >
> >         switch (ctx->reparse_type) {
> > +       case CIFS_REPARSE_TYPE_NATIVE_NFS:
> >         case CIFS_REPARSE_TYPE_NFS:
> > -               rc = mknod_nfs(xid, inode, dentry, tcon, full_path, mode, dev);
> > -               break;
> > +               return mknod_nfs(xid, inode, dentry, tcon, full_path, mode, dev, NULL);
> > +       case CIFS_REPARSE_TYPE_NATIVE_WSL:
> >         case CIFS_REPARSE_TYPE_WSL:
> > -               rc = mknod_wsl(xid, inode, dentry, tcon, full_path, mode, dev);
> > -               break;
> > +               return mknod_wsl(xid, inode, dentry, tcon, full_path, mode, dev, NULL);
> > +       default:
> > +               return -EOPNOTSUPP;
> >         }
> > -       return rc;
> >  }
> >
> >  /* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
> > @@ -848,7 +886,7 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
> >         return rc;
> >  }
> >
> > -static int parse_reparse_symlink(struct reparse_symlink_data_buffer *sym,
> > +static int parse_reparse_native_symlink(struct reparse_symlink_data_buffer *sym,
> >                                  u32 plen, bool unicode,
> >                                  struct cifs_sb_info *cifs_sb,
> >                                  const char *full_path,
> > @@ -936,7 +974,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
> >                 return parse_reparse_posix((struct reparse_posix_data *)buf,
> >                                            cifs_sb, data);
> >         case IO_REPARSE_TAG_SYMLINK:
> > -               return parse_reparse_symlink(
> > +               return parse_reparse_native_symlink(
> >                         (struct reparse_symlink_data_buffer *)buf,
> >                         plen, unicode, cifs_sb, full_path, data);
> >         case IO_REPARSE_TAG_LX_SYMLINK:
> > diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
> > index eb6854e65e08..a6bdf20ce1b0 100644
> > --- a/fs/smb/client/reparse.h
> > +++ b/fs/smb/client/reparse.h
> > @@ -61,6 +61,7 @@ static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
> >  static inline u64 reparse_mode_nfs_type(mode_t mode)
> >  {
> >         switch (mode & S_IFMT) {
> > +       case S_IFLNK: return NFS_SPECFILE_LNK;
> >         case S_IFBLK: return NFS_SPECFILE_BLK;
> >         case S_IFCHR: return NFS_SPECFILE_CHR;
> >         case S_IFIFO: return NFS_SPECFILE_FIFO;
> > @@ -72,6 +73,7 @@ static inline u64 reparse_mode_nfs_type(mode_t mode)
> >  static inline u32 reparse_mode_wsl_tag(mode_t mode)
> >  {
> >         switch (mode & S_IFMT) {
> > +       case S_IFLNK: return IO_REPARSE_TAG_LX_SYMLINK;
> >         case S_IFBLK: return IO_REPARSE_TAG_LX_BLK;
> >         case S_IFCHR: return IO_REPARSE_TAG_LX_CHR;
> >         case S_IFIFO: return IO_REPARSE_TAG_LX_FIFO;
> > --
> > 2.20.1
> >
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
