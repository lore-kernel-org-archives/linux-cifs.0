From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix kernel crash on simultaneous mount/umount calls
Date: Thu, 9 Jun 2011 08:40:43 -0400
Message-ID: <20110609124043.GA9621@infradead.org>
References: <1307622570-7141-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1307622570-7141-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>  static void
>  cifs_put_super(struct super_block *sb)
>  {
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
> +	if (cifs_sb == NULL) {
> +		cFYI(1, "Empty cifs superblock info passed to put_super");
> +		return;
> +	}
> +
> +	bdi_destroy(&cifs_sb->bdi);

This means you have a problem with the lifetime rules in cifs_do_mount.

The VFS only calls ->put_super if sb->s_root is set.  So the rules for
the mount handler are to only set s_root once the superblock is fully
set up.

Also you should never call cifs_umount from the error handling in
cifs_do_mount.  Until s_root is set, please unwind manually, after
that leave it to ->put_super.


> +
> +static void
> +cifs_kill_super(struct super_block *sb)
> +{

This also seems quite broken.  If you fix up the mount path like
I suggested it won't be nessecary.

>  	int rc = 0;
>  	struct cifs_sb_info *cifs_sb;
>  
>  	cFYI(1, "In cifs_put_super");
>  	cifs_sb = CIFS_SB(sb);
>  	if (cifs_sb == NULL) {

And this check should also be removed.
