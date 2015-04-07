From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: When "refer file directly", make new inode cache
 if "uniqueid is different"
Date: Tue, 7 Apr 2015 06:45:51 -0400
Message-ID: <20150407064551.36374c43@tlielax.poochiereds.net>
References: <549A249A.3080000@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <549A249A.3080000-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 24 Dec 2014 11:27:38 +0900
Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org> wrote:

> When refer file "directly" (e.g. ls -li <filename>),
>  if file is same name, old inode cache is used.
> This causes that client shows wrong(old) inode number.
> So this patch is that if uniqueid is different, return error.
> 
> ## But this patch is applicable to when Server is UNIX.
> ## When Server is Windows, we need another new patch.
> 
> 
> Reproducible sample :
> 1. create file 'a' at cifs client.
> 2. rm 'a' and touch 'b a' at server.
> 3. ls -li 'a' at client, then client shows wrong(old) inode number.
> 
> Bug link:
> https://bugzilla.kernel.org/show_bug.cgi?id=90021
> 
> 
> 
> Signed-off-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
> diff -uprN -X linux-3.18-vanilla/Documentation/dontdiff linux-3.18-vanilla/fs/cifs/inode.c linux-3.18/fs/cifs/inode.c
> --- linux-3.18-vanilla/fs/cifs/inode.c	2014-12-08 07:21:05.000000000 +0900
> +++ linux-3.18/fs/cifs/inode.c	2014-12-19 11:07:59.127000000 +0900
> @@ -402,9 +402,18 @@ int cifs_get_inode_info_unix(struct inod
>  			rc = -ENOMEM;
>  	} else {
>  		/* we already have inode, update it */
> +
> +		/* if uniqueid is different, return error */
> +		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
> +		    CIFS_I(*pinode)->uniqueid != fattr.cf_uniqueid)) {
> +			rc = -ENOENT;
> +			goto cgiiu_exit;
> +		}
> +
>  		cifs_fattr_to_inode(*pinode, &fattr);
>  	}
>  
> +cgiiu_exit:
>  	return rc;
>  }
>  

Returning ENOENT here seems like the wrong error to me. That path does
exist, it just no longer refers to the same file as before.

Maybe ESTALE would be better as it would allow the VFS layer
to revalidate the dcache and invalidate the old dentry?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
