From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Samba symlinks and dcache collisions
Date: Wed, 30 Sep 2015 11:18:12 -0500
Message-ID: <CAH2r5mud0ug3eJaBBNOrO7Czfe2_9MP6bCUm0+Ejk7Uzj-3qSg@mail.gmail.com>
References: <CAH2r5mutOeX--Z1Vq+VhDuHf1d38aqYhRQxA=Eetaeqt8qHGkA@mail.gmail.com>
 <20150929234409.GC18915@jeremy-acer>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150929234409.GC18915@jeremy-acer>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 29, 2015 at 6:44 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, Sep 28, 2015 at 09:48:06PM -0500, Steve French wrote:
>> directory listings of large directories on smb2/smb3 mounts to Samba
>> sometimes shows the
>>
>> "Autodisabling the use of server inode numbers ..." message in dmesg.
>>
>> I have narrowed it down to cases where Samba is displaying symlink
>> source and target with the same inode number (the client does not know
>> they are symlinks since Samba does not set that file type when Unix
>> Extensions are not available).  Interestingly small directories with
>> either symlinks or hardlinks in them don't cause the client to detect
>> the inode number collision (which causes the server inode message to
>> be displayed).
>
> Yes, that's going to happen if symlinks are within the share
> without UNIX extensions I'm afraid. We report them as the same file
> (as they are).
>
>> cifs_find_inode in fs/cifs/inode.c has the following check (after
>> making sure that the inode numbers and mode of the two are the same
>> and that they are not directories and that their creation time is the
>> same)
>>
>>     /* if it's not a directory or has no dentries, then flag it */
>>     if (S_ISDIR(inode->i_mode) && !hlist_empty(&inode->i_dentry))
>>         fattr->cf_flags |= CIFS_FATTR_INO_COLLISION;
>>
>> Not sure what causes the collision in the case of a larger directory
>> but not a smaller one.  It is puzzling because the source and target
>> look (to the SMB3 client) similar to hardlinks with the same metadata
>> except for file name (Samba server does not emulate symlinks as SMB3
>> symlink reparse points or apple style symlinks so they look more like
>> hardlinks to the client)
>
> Nothing to do with directory size. Any link is going to do this
> if it points within the share.

The Samba behavior doesn't change based on directory size but the VFS
dcache/inode behavior clearly has something to do with how many or
what additional entries are in the directory.  I easily can prove that
- I created two directories
1) one with symlinks
2) one with hardlinks

ls on those two directories did not result in the problem, while ls on
a larger directory did (when it hit the 2nd file - ie the target of
the symlink), and ls of a directory in between in size did not.

-- 
Thanks,

Steve
