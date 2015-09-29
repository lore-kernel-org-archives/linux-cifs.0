From: Jeremy Allison <jra@samba.org>
Subject: Re: Samba symlinks and dcache collisions
Date: Tue, 29 Sep 2015 16:44:09 -0700
Message-ID: <20150929234409.GC18915@jeremy-acer>
References: <CAH2r5mutOeX--Z1Vq+VhDuHf1d38aqYhRQxA=Eetaeqt8qHGkA@mail.gmail.com>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mutOeX--Z1Vq+VhDuHf1d38aqYhRQxA=Eetaeqt8qHGkA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Sep 28, 2015 at 09:48:06PM -0500, Steve French wrote:
> directory listings of large directories on smb2/smb3 mounts to Samba
> sometimes shows the
> 
> "Autodisabling the use of server inode numbers ..." message in dmesg.
> 
> I have narrowed it down to cases where Samba is displaying symlink
> source and target with the same inode number (the client does not know
> they are symlinks since Samba does not set that file type when Unix
> Extensions are not available).  Interestingly small directories with
> either symlinks or hardlinks in them don't cause the client to detect
> the inode number collision (which causes the server inode message to
> be displayed).

Yes, that's going to happen if symlinks are within the share
without UNIX extensions I'm afraid. We report them as the same file
(as they are).

> cifs_find_inode in fs/cifs/inode.c has the following check (after
> making sure that the inode numbers and mode of the two are the same
> and that they are not directories and that their creation time is the
> same)
> 
>     /* if it's not a directory or has no dentries, then flag it */
>     if (S_ISDIR(inode->i_mode) && !hlist_empty(&inode->i_dentry))
>         fattr->cf_flags |= CIFS_FATTR_INO_COLLISION;
> 
> Not sure what causes the collision in the case of a larger directory
> but not a smaller one.  It is puzzling because the source and target
> look (to the SMB3 client) similar to hardlinks with the same metadata
> except for file name (Samba server does not emulate symlinks as SMB3
> symlink reparse points or apple style symlinks so they look more like
> hardlinks to the client)

Nothing to do with directory size. Any link is going to do this
if it points within the share.
