From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cifs: file: initialize oparms.reconnect before using
 it
Date: Mon, 29 Jul 2013 16:20:16 -0400
Message-ID: <20130729162016.3299ead3@tlielax.poochiereds.net>
References: <20130729093241.437315e1@corrin.poochiereds.net>
	<1375121075-11239-1-git-send-email-andi@etezian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikko.rapeli-X3B1VOXEql0@public.gmane.org,
	pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Andi Shyti <andi-ahk0KpmfxKRAfugRpC6u6w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375121075-11239-1-git-send-email-andi-ahk0KpmfxKRAfugRpC6u6w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 29 Jul 2013 20:04:35 +0200
Andi Shyti <andi-ahk0KpmfxKRAfugRpC6u6w@public.gmane.org> wrote:

> In the cifs_reopen_file function, if the following statement is
> asserted:
> 
> (tcon->unix_ext && cap_unix(tcon->ses) &&
>             (CIFS_UNIX_POSIX_PATH_OPS_CAP &
>             (tcon->fsUnixInfo.Capability)))
> 
> and we succeed to open with cifs_posix_open, the function jumps
> to the label reopen_success and checks for oparms.reconnect
> which is not initialized.
> 
> This issue has been reported by scan.coverity.com
> 
> Signed-off-by: Andi Shyti <andi-ahk0KpmfxKRAfugRpC6u6w@public.gmane.org>
> ---
>  fs/cifs/file.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 1e57f36..7e36ae3 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -647,6 +647,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
>  				     oflags, &oplock, &cfile->fid.netfid, xid);
>  		if (rc == 0) {
>  			cifs_dbg(FYI, "posix reopen succeeded\n");
> +			oparms.reconnect = true;
>  			goto reopen_success;
>  		}
>  		/*

Still doesn't do much to improve this code, but that fix shouldn't
break anything.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
