From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v0 1/4] vfs: add copy_range syscall and vfs entry point
Date: Wed, 15 May 2013 12:50:13 -0500
Message-ID: <CAH2r5ms0P8Hgv1mUpyHA32Er38iiaC1HHC4fhxvz2SBFy6Sucw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Doesn't the new syscall have to invalidate the page cache pages that
the server is about to overwrite as btrfs does with the following line
in fs/btrfs/ioctl.c

	truncate_inode_pages_range(&inode->i_data, destoff,
				   PAGE_CACHE_ALIGN(destoff + len) - 1);

(and doesn't truncate_inode_pages_range handle page cache alignment
anyway - and also why did btrfs use truncate_inode_pages_range instead
of invalidate?)

Does nfs client ever have the case where two different superblocks map
to the same nfs export (and thus the check below is restricting the
ability to do server side copy)?

+	if (inode_in->i_sb != inode_out->i_sb ||
+	    file_in->f_path.mnt != file_out->f_path.mnt)
+		return -EXDEV;

I am working on cifs client patches for the ioctl, and the new syscall
also looks pretty easy.   Some popular cifs servers (like Windows)
have supported smb/cifs copy offload for many, many years - and now
Samba with the support that David Disseldorp added for the clone range
ioctl has been supporting copychunk (server side copy from Windows to
Samba) so about time to finish the cifs client equivalent.

-- 
Thanks,

Steve
