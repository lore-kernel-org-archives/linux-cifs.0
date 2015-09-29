From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Samba symlinks and dcache collisions
Date: Mon, 28 Sep 2015 21:48:06 -0500
Message-ID: <CAH2r5mutOeX--Z1Vq+VhDuHf1d38aqYhRQxA=Eetaeqt8qHGkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

directory listings of large directories on smb2/smb3 mounts to Samba
sometimes shows the

"Autodisabling the use of server inode numbers ..." message in dmesg.

I have narrowed it down to cases where Samba is displaying symlink
source and target with the same inode number (the client does not know
they are symlinks since Samba does not set that file type when Unix
Extensions are not available).  Interestingly small directories with
either symlinks or hardlinks in them don't cause the client to detect
the inode number collision (which causes the server inode message to
be displayed).

cifs_find_inode in fs/cifs/inode.c has the following check (after
making sure that the inode numbers and mode of the two are the same
and that they are not directories and that their creation time is the
same)

    /* if it's not a directory or has no dentries, then flag it */
    if (S_ISDIR(inode->i_mode) && !hlist_empty(&inode->i_dentry))
        fattr->cf_flags |= CIFS_FATTR_INO_COLLISION;

Not sure what causes the collision in the case of a larger directory
but not a smaller one.  It is puzzling because the source and target
look (to the SMB3 client) similar to hardlinks with the same metadata
except for file name (Samba server does not emulate symlinks as SMB3
symlink reparse points or apple style symlinks so they look more like
hardlinks to the client)

Any ideas?
-- 
Thanks,

Steve
