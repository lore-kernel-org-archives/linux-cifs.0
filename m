From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix oops while traversing open file list (try #3)
Date: Mon, 21 May 2012 08:04:46 -0400
Message-ID: <20120521080446.053453a5@corrin.poochiereds.net>
References: <1337574279-28730-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	<stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337574279-28730-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 20 May 2012 23:24:39 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> While traversing the linked list of open file handles, if the identfied
> file handle is invalid, a reopen is attempted and if it fails, we
> resume traversing where we stopped and cifs can oops while accessing
> invalid next element, for list might have changed.
> 
> So mark the invalid file handle and attempt reopen if no
> valid file handle is found in rest of the list.
> If reopen fails, move the invalid file handle to the end of the list
> and start traversing the list again from the begining.
> Repeat this four times before giving up and returning an error if
> file reopen keeps failing.
> 
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> ---
>  fs/cifs/cifsglob.h |    1 +
>  fs/cifs/file.c     |   55 +++++++++++++++++++++++++++++----------------------
>  2 files changed, 32 insertions(+), 24 deletions(-)
> 

[...]

> +
> +	if (inv_file) {
> +		rc = cifs_reopen_file(inv_file, false);
> +		if (!rc)
> +			return inv_file;
> +		else {
> +			list_move_tail(&inv_file->flist,
> +					&cifs_inode->openFileList);


You're modifying this list w/o holding the spinlock. You need to do
this while holding the spinlock.

> +			cifsFileInfo_put(inv_file);
> +			spin_lock(&cifs_file_list_lock);
> +			++refind;
> +			goto refind_writable;
> +		}
> +	}
> +
>  	return NULL;
>  }
>  


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
