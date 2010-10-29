From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Strange hardlink behavior with CIFS
Date: Fri, 29 Oct 2010 07:19:41 -0400
Message-ID: <20101029071941.7883bf98@tlielax.poochiereds.net>
References: <1287428685.16450.282.camel@calx>
	<4CBD6843.3060702@suse.de>
	<1288200686.3764.55.camel@calx>
	<20101027163230.28591971@tlielax.poochiereds.net>
	<4CC959AC.10301@suse.de>
	<20101028074650.3e035241@tlielax.poochiereds.net>
	<4CCAA73D.80009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CCAA73D.80009-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 29 Oct 2010 16:21:41 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 10/28/2010 05:16 PM, Jeff Layton wrote:
> > On Thu, 28 Oct 2010 16:38:28 +0530
> > Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> > 
> >> On 10/28/2010 02:02 AM, Jeff Layton wrote:
> >>> On Wed, 27 Oct 2010 12:31:26 -0500
> >>> Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org> wrote:
> >>>
> >>>> On Tue, 2010-10-19 at 15:13 +0530, Suresh Jayaraman wrote:
> >>>>> On 10/19/2010 12:34 AM, Matt Mackall wrote:
> >>>>>> With Linux 2.6.32-35 and either Windows or Samba in nounix mode,
> >>>>>> hardlink counts can mysteriously disappear:
> >>>>>>
> >>>>>> - create hardlink pair foo,bar
> >>>>>> - stat foo -> nlink = 2
> >>>>>> - open foo
> >>>>>> - stat foo -> nlink = 1
> >>>>>> - close
> >>>>>> - wait or sync
> >>>>>> - ls -l -> nlink = 2
> >>>>>>
> 
> > 
> > I think we ought to not have CIFSSMBOpen try to fake up values since
> > it's clearly incorrect. The easiest way is just to get rid of the
> > places that try to do that (like this one).
> > 
> > If we feel that it's important to try and use the values that are
> > returned from this call (and others that fake up a QPathInfo response
> > like this), then they ought to changed so that they put the info into a
> > cifs_fattr struct and then update the inode values from that.
> > 
> > To do that however, you'll need to fix cifs_fattr_to_inode to only
> > update the values that have been set in the cifs_fattr so that you're
> > not faking up other values. That may mean adding a "valid" field of
> > some sort and setting flags that show which fields should be copied to
> > the inode.
> > 
> 
> Great idea, Thanks.
> 
> Looks like we could overload fattr->cf_flags. Something like this?
> (Only compile tested as I screwed up my VM setup)
> 
> 
>  fs/cifs/cifsglob.h |    1 +
>  fs/cifs/cifssmb.c  |    2 +-
>  fs/cifs/inode.c    |    8 ++++++--
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f259e4d..bdb508f 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -558,6 +558,7 @@ struct dfs_info3_param {
>  #define CIFS_FATTR_DELETE_PENDING	0x2
>  #define CIFS_FATTR_NEED_REVAL		0x4
>  #define CIFS_FATTR_INO_COLLISION	0x8
> +#define CIFS_FATTR_NLINK_NOT_SET	0x10	/* number of hardlinks unknown */
>  
>  struct cifs_fattr {
>  	u32		cf_flags;
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 2f2632b..6a5455f 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1326,7 +1326,7 @@ openRetry:
>  			/* the file_info buf is endian converted by caller */
>  			pfile_info->AllocationSize = pSMBr->AllocationSize;
>  			pfile_info->EndOfFile = pSMBr->EndOfFile;
> -			pfile_info->NumberOfLinks = cpu_to_le32(1);
> +			pfile_info->NumberOfLinks = 0; /* not known */
>  			pfile_info->DeletePending = 0;
>  		}
>  	}
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 39869c3..7ab9a62 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -128,7 +128,8 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
>  	inode->i_mtime = fattr->cf_mtime;
>  	inode->i_ctime = fattr->cf_ctime;
>  	inode->i_rdev = fattr->cf_rdev;
> -	inode->i_nlink = fattr->cf_nlink;
> +	if (!(fattr->cf_flags & CIFS_FATTR_NLINK_NOT_SET))
> +		inode->i_nlink = fattr->cf_nlink;
>  	inode->i_uid = fattr->cf_uid;
>  	inode->i_gid = fattr->cf_gid;
>  
> @@ -531,7 +532,10 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
>  			fattr->cf_mode &= ~(S_IWUGO);
>  	}
>  
> -	fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
> +	if (info->NumberOfLinks)
> +		fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
> +	else
> +		fattr->cf_flags |= CIFS_FATTR_NLINK_NOT_SET;
>  
>  	fattr->cf_uid = cifs_sb->mnt_uid;
>  	fattr->cf_gid = cifs_sb->mnt_gid;

No, I don't think that's going to do it...

With that you're basically just saying "when the server reports zero
nlinks, just ignore it". That not really correct, at least not with
samba. I'm not sure how that would work with windows semantics, but
it's probably best not to do this.

Suppose I hold a file open and something unlinks the dentry. Then I
do a QFileInfo against the open filehandle. The file will still exist,
but it'll have 0 nlinks. This approach will also make the metadata
wrong.

What you really want to do is fix CIFSSMBOpen to take a cifs_fattr
pointer instead of a buffer, populate that with the values from the open
response, and set flags to make cifs_fattr_to_inode ignore everything
else.

You'll then want to make cifs_open just call cifs_fattr_to_inode
directly instead of calling cifs_get_inode_info. You can probably also
eliminate cifs_open_inode_helper in the process, though you'll need to
look at the logic carefully and may need to move some of it into
cifs_open.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
