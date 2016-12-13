From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs_get_root shouldn't use path with tree name
Date: Tue, 13 Dec 2016 08:06:30 -0500
Message-ID: <1481634390.2630.16.camel@redhat.com>
References: <1473260003-5271-1-git-send-email-sprabhu@redhat.com>
         <1481632417.2630.13.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481632417.2630.13.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2016-12-13 at 07:33 -0500, Jeff Layton wrote:
> On Wed, 2016-09-07 at 15:53 +0100, Sachin Prabhu wrote:
> > 
> > When a server returns the optional flag SMB_SHARE_IS_IN_DFS in response
> > to a tree connect, cifs_build_path_to_root() will return a pathname
> > which includes the tree name. This causes problems with cifs_get_root()
> > which separates each component and does a lookup for each component of
> > the path.
> > 
> > We encountered a problem with dfs shares hosted by a Netapp. when
> > connecting to nodes pointed to by the DFS share. The tree connect for
> > these nodes return SMB_SHARE_IS_IN_DFS even after the DFS node is
> > resolved and the node returned doesn't contain a DFS share. Other
> > servers(tested with MS Win2012 R2) do not and hence do not face this
> > problem. A workaround for Netapp servers is to mount with the
> > nodfs flag.
> > The return flag results in cifs_build_path_to_root() using the tree name
> > in building the path which is then split into its components and
> > individual lookup done for each component in cifs_get_root(). The first
> > component of the path in this case is the hostname which results in
> > object not found errors.
> > 
> > We have tested this patch both on our internal test servers as well as
> > the user's own servers and can confirm that it fixes the problem.
> > 
> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Reported-by: Pierguido Lambri <plambri-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/cifsfs.c    | 2 +-
> >  fs/cifs/cifsproto.h | 3 ++-
> >  fs/cifs/connect.c   | 3 ++-
> >  fs/cifs/dir.c       | 4 ++--
> >  4 files changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 6bbec5e..b6f57dd 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -610,7 +610,7 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
> >  	char sep;
> >  
> >  	full_path = cifs_build_path_to_root(vol, cifs_sb,
> > -					    cifs_sb_master_tcon(cifs_sb));
> > +				cifs_sb_master_tcon(cifs_sb), 0);
> 
> Ok, sorry if I'm being dense here, but I haven't been following the
> various patches in this area closely...
> 
> cifs_get_root basically does a lookup of the dentry that we want to be
> the root of the mount on the client.
> 
> You're saying here that we need to _not_ send a DFS style path query
> when doing that lookup, even though the server is setting
> the SMB_SHARE_IS_IN_DFS flag in the tcon response?
> 
> Is this just a workaround for misbehaving servers, or is the client
> actually doing this wrong?
> 

Doh! I just needed another cup of coffee...

I get it now. We build the path to root, and then try to issue a lookup
on each component (a'la lookup_one_len_unlocked). That fails in this
case because we're trying to lookup the DFS hostname component like we
would a normal path component.

I think is this a reasonable fix for now. That said, this whole Rube
Goldberg contraption could really use a serious re-think, IMO...

You can add:

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> > 
> >  	if (full_path == NULL)
> >  		return ERR_PTR(-ENOMEM);
> >  
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index 1243bd3..52c307b 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -63,7 +63,8 @@ extern void exit_cifs_spnego(void);
> >  extern char *build_path_from_dentry(struct dentry *);
> >  extern char *cifs_build_path_to_root(struct smb_vol *vol,
> >  				     struct cifs_sb_info *cifs_sb,
> > -				     struct cifs_tcon *tcon);
> > +				     struct cifs_tcon *tcon,
> > +				     int add_treename);
> >  extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
> >  extern char *cifs_compose_mount_options(const char *sb_mountdata,
> >  		const char *fullpath, const struct dfs_info3_param *ref,
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 9878943..afca9ee 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -3649,7 +3649,8 @@ remote_path_check:
> >  		/*
> >  		 * cifs_build_path_to_root works only when we have a valid tcon
> >  		 */
> > -		full_path = cifs_build_path_to_root(volume_info, cifs_sb, tcon);
> > +		full_path = cifs_build_path_to_root(volume_info, cifs_sb, tcon,
> > +					tcon->Flags & SMB_SHARE_IS_IN_DFS);
> >  		if (full_path == NULL) {
> >  			rc = -ENOMEM;
> >  			goto mount_fail_check;
> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> > index 4716c54..4c0c62c 100644
> > --- a/fs/cifs/dir.c
> > +++ b/fs/cifs/dir.c
> > @@ -47,7 +47,7 @@ renew_parental_timestamps(struct dentry *direntry)
> >  
> >  char *
> >  cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
> > -			struct cifs_tcon *tcon)
> > +			struct cifs_tcon *tcon, int add_treename)
> >  {
> >  	int pplen = vol->prepath ? strlen(vol->prepath) + 1 : 0;
> >  	int dfsplen;
> > @@ -59,7 +59,7 @@ cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
> >  		return full_path;
> >  	}
> >  
> > -	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
> > +	if (add_treename)
> >  		dfsplen = strnlen(tcon->treeName, MAX_TREE_SIZE + 1);
> >  	else
> >  		dfsplen = 0;
> 
