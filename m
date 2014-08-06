From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Update CreationTime on every query info request
Date: Wed, 6 Aug 2014 09:31:14 -0400
Message-ID: <20140806093114.2ec5f815@tlielax.poochiereds.net>
References: <1407323743-12381-1-git-send-email-pshilovsky@samba.org>
	<20140806072546.14dfbe07@tlielax.poochiereds.net>
	<CAKywueSdDBROX9PokZXkUxocD7aAajQFYMv=ZQfXNDVYLSHRVg@mail.gmail.com>
	<20140806080833.111cd1d4@tlielax.poochiereds.net>
	<CAKywueQJpHjDFUZbDTUhrekOPG5uRx0nv30L+gnBZSW3HbPh_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQJpHjDFUZbDTUhrekOPG5uRx0nv30L+gnBZSW3HbPh_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 6 Aug 2014 16:38:32 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> 2014-08-06 16:08 GMT+04:00 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > On Wed, 6 Aug 2014 15:59:22 +0400
> > Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >
> >> 2014-08-06 15:25 GMT+04:00 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> >> > On Wed,  6 Aug 2014 15:15:43 +0400
> >> > Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >> >
> >> >> Samba server can change a creation time of an inode in the default
> >> >> configuration. The client sets this value during the inode initialization
> >> >> only and uses it the inode search. In this case harlinked dentries may
> >> >> link to different inodes. As the results the Cthon basic test #7 fails
> >> >> on nounix Samba mounts.
> >> >>
> >> >> Fix this by making the client update the creation time on every
> >> >> query info request.
> >> >>
> >> >> Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >> >> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >> >> ---
> >> >>  fs/cifs/inode.c | 3 +++
> >> >>  1 file changed, 3 insertions(+)
> >> >>
> >> >> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> >> >> index a174605..2029e7c 100644
> >> >> --- a/fs/cifs/inode.c
> >> >> +++ b/fs/cifs/inode.c
> >> >> @@ -173,6 +173,9 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
> >> >>
> >> >>       cifs_i->cifsAttrs = fattr->cf_cifsattrs;
> >> >>
> >> >> +     /* Samba server changes this value in the default configuration */
> >> >> +     cifs_i->createtime = fattr->cf_createtime;
> >> >> +
> >> >>       if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
> >> >>               cifs_i->time = 0;
> >> >>       else
> >> >
> >> > NAK
> >> >
> >> > That really sounds more like a bug in Samba. The creation time is
> >> > supposed to be immutable, and if it changes then that means that you
> >> > have a new inode.
> >> >
> >> > We really *don't* want to go updating it like this.
> >>
> >> If it is suppose to be immutable and the server does processing right,
> >> the fix will not break things since the cifs_i->createtime value stays
> >> the same.
> >>
> >
> > Does anything prevent a server from reusing a uniqueid? If not, then
> > this is one of the only mechanisms to tell whether this is the same
> > inode as the previous one or a new one.
> 
> If server reuses a uniqueid - it is a bug in the server.
> 

Then I think that's probably another samba bug. IIRC, it generates
uniqueids using the st_ino and st_dev fields from stat(). There are
many Linux filesystems that will aggressively reuse inode numbers and
there is no API to get at the inode->i_generation field from userland.

--------------[snip]----------------
/********************************************************************
 Create a 64 bit FileIndex. If the file is on the same device as
 the root of the share, just return the 64-bit inode. If it isn't,
 mangle as we used to do.
********************************************************************/

uint64_t get_FileIndex(connection_struct *conn, const SMB_STRUCT_STAT *psbuf)
{
        uint64_t file_index;
        if (conn->base_share_dev == psbuf->st_ex_dev) {
                return (uint64_t)psbuf->st_ex_ino;
        }
        file_index = ((psbuf->st_ex_ino) & UINT32_MAX); /* FileIndexLow */
        file_index |= ((uint64_t)((psbuf->st_ex_dev) & UINT32_MAX)) << 32; /* FileIndexHigh */
        return file_index;
}
--------------[snip]----------------

> The creation time can be changed on the Windows server:
> 1) we call stat FILE - construct the inode with the recent info;
> 2) on the server another client calls SetFileTime() and updates
> CreationTime of the FILE;
> 3) we call stat FILE again, get the recent info but don't store the
> new CreationTime value and stay with the wrong CreationTime value.
> 
> Also, in this case we can't rely on CreationTime to determine if this
> is the same inode or not. I think the best thing is to *trust* the
> server that uniqueid is unique (at least for SMB 2.0 and higher
> versions).
> 
> Note, that now we use CreationTIme value for the inode search in
> iget(). The above example of changing this value on the server shows
> that we can end up with several inodes for each "creationtime" version
> of the file.
> 

Sure, it's settable and you can abuse it, but who actually does that?

It's very rare for someone to mess with the create time like that. I
imagine it's generally only done by backup utilities when restoring
and maybe rootkits. Those are both sort of outside the scope of
normal usage.

> >> But if this value was changed and we don't store this latest returned
> >> value from the server and continue to use the old one, does things go
> >> better? We'll end up relying on the value that is wrong...
> >>
> >
> > We rely on the server to send us valid information. If the server
> > doesn't do that, then it's a server bug.
> >
> >> If Samba server doesn't store the creation time attribute in xattrs
> >> (that is restricted by underlying file system and switched off by
> >> default), it can't return a right value to the client since POSIX file
> >> systems store only access, modify and change timestamps.
> >>
> >
> > Yep, faking up valid fields like this is always iffy.
> >
> >> So, in the result we have the CIFS client that doesn't work with the
> >> default configuration of Samba. If we can't fix Samba due to POSIX
> >> restrictions), we need to do something with the client, don't we?
> >>
> >
> > Well, no. The default configuration of samba has unix extensions
> > enabled, and with that the create time is ignored (since it's not
> > returned at all in that case).
> 
> The problem is that we don't have unix extensions for SMB 2.0 and
> higher protocol versions and we need to use nounix either way.
> 

Then that's a problem that will need to eventually be addressed anyway.
I don't see how this is anything but a way to paper over that fact in
the meantime.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
