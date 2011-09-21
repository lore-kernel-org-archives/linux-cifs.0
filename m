From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Add mount options for backup intent (try #3)
Date: Wed, 21 Sep 2011 16:15:40 -0400
Message-ID: <20110921161540.59726d8e@tlielax.poochiereds.net>
References: <1316630874-20518-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316630874-20518-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 21 Sep 2011 13:47:54 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Add mount options backupuid and backugid.
> 
> It allows an authenticated user to access files with the intent to back them
> up including their ACLs, who may not have access permission but has
> "Backup files and directories user right" on them (by virtue of being part
> of the built-in group Backup Operators.
> 
> When mount options backupuid is specified, cifs client restricts the
> use of backup intents to the user whose effective user id is specified
> along with the mount option.
> 
> When mount options backupgid is specified, cifs client restricts the
> use of backup intents to the users whose effective user id belongs to the
> group id specified along with the mount option.
> 
> If an authenticated user is not part of the built-in group Backup Operators
> at the server, access to such files is denied, even if allowed by the client.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifs_fs_sb.h |    3 +++
>  fs/cifs/cifsacl.c    |   18 ++++++++++++------
>  fs/cifs/cifsglob.h   |    6 +++++-
>  fs/cifs/cifsproto.h  |    1 +
>  fs/cifs/connect.c    |   14 ++++++++++++++
>  fs/cifs/dir.c        |   10 ++++++++--
>  fs/cifs/file.c       |   12 ++++++++++--
>  fs/cifs/link.c       |   17 ++++++++++++-----
>  fs/cifs/misc.c       |   13 +++++++++++++
>  9 files changed, 78 insertions(+), 16 deletions(-)
> 

[...]

> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 7c16933..a35b60d 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -676,3 +676,16 @@ void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
>  		cinode->clientCanCacheRead = false;
>  	}
>  }
> +
> +bool
> +backup_cred(struct cifs_sb_info *cifs_sb)
> +{
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUP) {
> +		if ((cifs_sb->mnt_backupuid != NO_CHANGE_32 &&
> +				cifs_sb->mnt_backupuid == current_euid()) ||
								^^^^
							This should be current_fsuid().

> +				(cifs_sb->mnt_backupgid != NO_CHANGE_32 &&
								^^^^
		I also have to wonder whether it's a good idea to
		exclude uid/gid = NO_CHANGE_32. It sometimes the case that
		certain users (nobody) get set to -1 (0xffffffff). If
		you do use that to indicate that this value is not set, then
		that should be documented in the manpage. It think it would
		probably be best though not to exclude any possible uid
		or gid here.

> +				in_group_p(cifs_sb->mnt_backupgid)))
> +			return true;
> +	}
> +	return false;
> +}

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
