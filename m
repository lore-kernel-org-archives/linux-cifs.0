From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [CIFS] ls on mounts to WindowsCE failing with invalid
 level message
Date: Wed, 24 Aug 2011 15:08:52 -0400
Message-ID: <20110824150852.5a9f911f@tlielax.poochiereds.net>
References: <CAH2r5mvmVNySCiSMc9Bz=yi4Zhzg=sYwxLSpiwapAyn6-HEqDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvmVNySCiSMc9Bz=yi4Zhzg=sYwxLSpiwapAyn6-HEqDQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 23 Aug 2011 22:16:54 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> From 9b7b518633fd3187c7efe260fe20a0961e4a5f0b Mon Sep 17 00:00:00 2001
> From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> Date: Tue, 23 Aug 2011 22:00:26 -0500
> Subject: [CIFS] ls on mounts to WindowsCE failing with invalid level message
> 
> Mount succeeds to WindowsCE but when user tries
> to access the contents of the directory gets "NT Status:
> STATUS_INVALID_LEVEL" according to wireshark.
> 
> This server does not support the common windows
> readdir (Findfirst) level 257 nor level 258, so "fall back"
> to level 260 if get an EOPNOTSUPP on level FIND_FILE_DIRECTORY_INFO
> and while we are at it fall back to level 1 (FILE_INFO_STANDARD)
> for very old servers if we get an EOPNOTSUPP on level 260.
> (Note that the server returned errors on queries for inode
> numbers via QueryPathInfo so we don't use the infolevel
> SMB_FIND_FILE_ID_FULL_DIR_INFO)
> 
> Reported-and-tested-by: Bryan James <Bryan.James.Krone-EXT-zES+1Ur7hjI@public.gmane.org>
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/readdir.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 5de03ec..ed29706 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -270,6 +270,7 @@ ffirst_retry:
>  		cifsFile->srch_inf.info_level = SMB_FIND_FILE_DIRECTORY_INFO;
>  	}
> 
> +ffirst_retry_with_std_level:
>  	rc = CIFSFindFirst(xid, pTcon, full_path, cifs_sb->local_nls,
>  		&cifsFile->netfid, &cifsFile->srch_inf,
>  		cifs_sb->mnt_cifs_flags &
> @@ -283,7 +284,23 @@ ffirst_retry:
>  		(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
>  		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
>  		goto ffirst_retry;
> +	} else if ((rc == -EOPNOTSUPP) && (cifsFile->srch_inf.info_level ==
> +					SMB_FIND_FILE_DIRECTORY_INFO)) {

		^^^^ there's no need for the extra sets of parenthesis
		here. That violates kernel coding conventions and makes this
		harder to read.

> +		/* Windows CE can return EOPNOTSUPP on FILE_DIRECTORY_INFO */
> +		cifsFile->srch_inf.info_level =
> +				SMB_FIND_FILE_BOTH_DIRECTORY_INFO;
				^^^^
			The code doesn't currently use
			BOTH_DIRECTORY_INFO anywhere. Would it be
			better to skip this step?
 
> +		goto ffirst_retry_with_std_level;
> +	} else if ((rc == -EOPNOTSUPP) && (cifsFile->srch_inf.info_level ==
> +					SMB_FIND_FILE_BOTH_DIRECTORY_INFO)) {
> +		cifsFile->srch_inf.info_level =
> +				SMB_FIND_FILE_FULL_DIRECTORY_INFO;

				^^^^
			Ditto here. Would it be best to just fall back
			to the lowest common denominator here? I'm not sure
			I see a lot of benefit in using any of these
			other infolevels. We'll basically get the same
			info out of SMB_FIND_FILE_INFO_STANDARD and it's
			more widely supported.

> +		goto ffirst_retry_with_std_level;
> +	} else if ((rc == -EOPNOTSUPP) && (cifsFile->srch_inf.info_level ==
> +					SMB_FIND_FILE_FULL_DIRECTORY_INFO)) {
> +		cifsFile->srch_inf.info_level = SMB_FIND_FILE_INFO_STANDARD;
> +		goto ffirst_retry_with_std_level;
>  	}
> +
>  error_exit:
>  	kfree(full_path);
>  	cifs_put_tlink(tlink);


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
