From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Samba server bug: CopyChunk from one share to a different share
 on same server
Date: Mon, 9 Nov 2015 13:46:13 +0100
Message-ID: <20151109134613.4ae8148c@plati>
References: <CAH2r5mvf87XmR_VwiHa6B0LV0WDRb8Ro=cRzQbUDV-9yHAjW3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Mohammad Samian Yusuf <s.yusuf91-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvf87XmR_VwiHa6B0LV0WDRb8Ro=cRzQbUDV-9yHAjW3A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 8 Nov 2015 20:52:16 -0600, Steve French wrote:

> Tried a quick experiment using cloner (David's tool - xfstests/src/cloner)
> to copy a file from share1 to share2 on the same target server (using
> CopyChunk and SMB3).  Works fine for Windows (tried Windows 8.1) but failed
> for Samba 4.2.
> 
> This is one of the more important cases to support (copying a file from one
> share to another)
> 
> Samba returns STATUS_OBJECT_NAME_NOT_FOUND on FSCTL_SRV_COPYCHUNK_WRITE
> unless source and target are on the same share.  I didn't try it with
> vfs_btrfs (the test system was running ext4, and both exports are on the
> same volume on the server).

It's no different across Samba VFS modules - this behaviour is intended.
The persistent/volatile handle is used to generate the copy-chunk resume
key. file_fsp_get() is currently used to lookup the source fsp using the
destination file connection context.

> Was testing the change below where I relax the copy offload check as
> follows (to allow cross share copy chunk as Windows does)
> 
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 28a77bf..35cf990 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -85,9 +85,14 @@ static long cifs_ioctl_clone(unsigned int xid, struct
> file *dst_file,
>      src_tcon = tlink_tcon(smb_file_src->tlink);
>      target_tcon = tlink_tcon(smb_file_target->tlink);
> 
> -    /* check if source and target are on same tree connection */
> -    if (src_tcon != target_tcon) {
> -        cifs_dbg(VFS, "file copy src and target on different volume\n");
> +    /* check source and target on same server (or volume if dup_extents) */
> +    if (dup_extents && (src_tcon != target_tcon)) {
> +        cifs_dbg(VFS, "source and target of copy not on same share\n");
> +        goto out_fput;
> +    }
> +
> +    if (!dup_extents && (src_tcon->ses != target_tcon->ses)) {
> +        cifs_dbg(VFS, "source and target of copy not on same server\n");
>          goto out_fput;
>      }
> 
> 

This change looks fine to me.
Reviewed-by: David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Cheers, David
