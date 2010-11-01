From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] CIFS: Add strictcache mount option
Date: Mon, 1 Nov 2010 13:09:39 -0400
Message-ID: <20101101130939.4ada6d84@tlielax.poochiereds.net>
References: <AANLkTi=04ko7zXRaXvgEBzXFfhhL3QU64gnZOXMPoNOD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=04ko7zXRaXvgEBzXFfhhL3QU64gnZOXMPoNOD-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 31 Oct 2010 22:42:12 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Use for switching on strict cache mode. In this mode the
> client read from the cache all the time it has Oplock Level II,
> otherwise - read from the server. All written data are stored
> in the cache, but if the client doesn't have Exclusive Oplock,
> it writes the data to the server.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/README       |    5 +++++
>  fs/cifs/cifs_fs_sb.h |    1 +
>  fs/cifs/connect.c    |    5 +++++
>  3 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/README b/fs/cifs/README
> index ee68d10..8fb6192 100644
> --- a/fs/cifs/README
> +++ b/fs/cifs/README
> @@ -443,6 +443,11 @@ A partial list of the supported mount options follows:
>  		if oplock (caching token) is granted and held. Note that
>  		direct allows write operations larger than page size
>  		to be sent to the server.
> +  strictcache   Use for switching on strict cache mode. In this mode the
> +		client read from the cache all the time it has Oplock Level II,
> +		otherwise - read from the server. All written data are stored
> +		in the cache, but if the client doesn't have Exclusive Oplock,
> +		it writes the data to the server.
>    acl   	Allow setfacl and getfacl to manage posix ACLs if server
>  		supports them.  (default)
>    noacl 	Do not allow setfacl and getfacl calls on this mount
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index 525ba59..b7b8b45 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -40,6 +40,7 @@
>  #define CIFS_MOUNT_FSCACHE	0x8000 /* local caching enabled */
>  #define CIFS_MOUNT_MF_SYMLINKS	0x10000 /* Minshall+French Symlinks enabled */
>  #define CIFS_MOUNT_MULTIUSER	0x20000 /* multiuser mount */
> +#define CIFS_MOUNT_STRICT_IO	0x40000 /* strict cache behavior */
> 
>  struct cifs_sb_info {
>  	struct radix_tree_root tlink_tree;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 7e73176..11125fb 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -84,6 +84,7 @@ struct smb_vol {
>  	bool no_xattr:1;   /* set if xattr (EA) support should be disabled*/
>  	bool server_ino:1; /* use inode numbers from server ie UniqueId */
>  	bool direct_io:1;
> +	bool strict_io:1; /* strict cache behavior */
>  	bool remap:1;      /* set to remap seven reserved chars in filenames */
>  	bool posix_paths:1; /* unset to not ask for posix pathnames. */
>  	bool no_linux_ext:1;
> @@ -1343,6 +1344,8 @@ cifs_parse_mount_options(char *options, const
> char *devname,
>  			vol->direct_io = 1;
>  		} else if (strnicmp(data, "forcedirectio", 13) == 0) {
>  			vol->direct_io = 1;
> +		} else if (strnicmp(data, "strictcache", 11) == 0) {
> +			vol->strict_io = 1;
>  		} else if (strnicmp(data, "noac", 4) == 0) {
>  			printk(KERN_WARNING "CIFS: Mount option noac not "
>  				"supported. Instead set "
> @@ -2582,6 +2585,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
>  	if (pvolume_info->multiuser)
>  		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_MULTIUSER |
>  					    CIFS_MOUNT_NO_PERM);
> +	if (pvolume_info->strict_io)
> +		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_STRICT_IO;
>  	if (pvolume_info->direct_io) {
>  		cFYI(1, "mounting share using direct i/o");
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;


It might be better to add the mount flag when you first need to use it and
then add the option last (after the rest of the series).

Consider that git-bisect might cause someone to build a kernel with
only part of the set applied.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
