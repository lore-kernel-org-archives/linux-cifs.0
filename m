From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs: Fix inability to write files >2GB to SMB2/3 shares (THIS
 TIME I GOT IT RIGHT, PROMISE!)
Date: Sun, 6 Oct 2013 19:03:11 -0500
Message-ID: <CAH2r5mvyCduRWcC=wgDFXZfUH-ojSKWY25mwQQ6k5zyy7E1TqA@mail.gmail.com>
References: <5251B524.3000101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: Jan Klos <honza.klos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5251B524.3000101-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks good.

Will plan to merge into cifs-2..6.git soon.

Probably should also go to stable kernels

On Sun, Oct 6, 2013 at 2:08 PM, Jan Klos <honza.klos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> When connecting to SMB2/3 shares, maximum file size is set to non-LFS maximum in superblock. This is due to cap_large_files bit being different for SMB1 and SMB2/3 (where it is just an internal flag that is not negotiated and the SMB1 one corresponds to multichannel capability, so maybe LFS works correctly if server sends 0x08 flag) while capabilities are checked always for the SMB1 bit in cifs_read_super().
>
> The patch fixes this by checking for the correct bit according to the protocol version.
>
> Sorry for the TWO reposts, Gmail messed up the first mail, Thunderbird added spaces to the patch part in the second. I am really sorry! I think I fixed a quite significant bug, so have mercy on me...
>
>
> Signed-off-by: Jan Klos <honza.klos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> ---
>
> diff -uprN a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> --- a/fs/cifs/cifsfs.c  2013-10-05 16:18:07.000000000 +0200
> +++ b/fs/cifs/cifsfs.c  2013-10-06 16:18:13.488378000 +0200
> @@ -120,14 +120,16 @@ cifs_read_super(struct super_block *sb)
>  {
>         struct inode *inode;
>         struct cifs_sb_info *cifs_sb;
> +       struct cifs_tcon *tcon;
>         int rc = 0;
>
>         cifs_sb = CIFS_SB(sb);
> +       tcon = cifs_sb_master_tcon(cifs_sb);
>
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
>                 sb->s_flags |= MS_POSIXACL;
>
> -       if (cifs_sb_master_tcon(cifs_sb)->ses->capabilities & CAP_LARGE_FILES)
> +       if (tcon->ses->capabilities & tcon->ses->server->vals->cap_large_files)
>                 sb->s_maxbytes = MAX_LFS_FILESIZE;
>         else
>                 sb->s_maxbytes = MAX_NON_LFS;
> @@ -147,7 +149,7 @@ cifs_read_super(struct super_block *sb)
>                 goto out_no_root;
>         }
>
> -       if (cifs_sb_master_tcon(cifs_sb)->nocase)
> +       if (tcon->nocase)
>                 sb->s_d_op = &cifs_ci_dentry_ops;
>         else
>                 sb->s_d_op = &cifs_dentry_ops;



-- 
Thanks,

Steve
