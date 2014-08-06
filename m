From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Update CreationTime on every query info request
Date: Wed, 6 Aug 2014 08:08:33 -0400
Message-ID: <20140806080833.111cd1d4@tlielax.poochiereds.net>
References: <1407323743-12381-1-git-send-email-pshilovsky@samba.org>
	<20140806072546.14dfbe07@tlielax.poochiereds.net>
	<CAKywueSdDBROX9PokZXkUxocD7aAajQFYMv=ZQfXNDVYLSHRVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSdDBROX9PokZXkUxocD7aAajQFYMv=ZQfXNDVYLSHRVg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 6 Aug 2014 15:59:22 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> 2014-08-06 15:25 GMT+04:00 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > On Wed,  6 Aug 2014 15:15:43 +0400
> > Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >
> >> Samba server can change a creation time of an inode in the default
> >> configuration. The client sets this value during the inode initialization
> >> only and uses it the inode search. In this case harlinked dentries may
> >> link to different inodes. As the results the Cthon basic test #7 fails
> >> on nounix Samba mounts.
> >>
> >> Fix this by making the client update the creation time on every
> >> query info request.
> >>
> >> Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >> ---
> >>  fs/cifs/inode.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> >> index a174605..2029e7c 100644
> >> --- a/fs/cifs/inode.c
> >> +++ b/fs/cifs/inode.c
> >> @@ -173,6 +173,9 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
> >>
> >>       cifs_i->cifsAttrs = fattr->cf_cifsattrs;
> >>
> >> +     /* Samba server changes this value in the default configuration */
> >> +     cifs_i->createtime = fattr->cf_createtime;
> >> +
> >>       if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
> >>               cifs_i->time = 0;
> >>       else
> >
> > NAK
> >
> > That really sounds more like a bug in Samba. The creation time is
> > supposed to be immutable, and if it changes then that means that you
> > have a new inode.
> >
> > We really *don't* want to go updating it like this.
> 
> If it is suppose to be immutable and the server does processing right,
> the fix will not break things since the cifs_i->createtime value stays
> the same.
> 

Does anything prevent a server from reusing a uniqueid? If not, then
this is one of the only mechanisms to tell whether this is the same
inode as the previous one or a new one.

> But if this value was changed and we don't store this latest returned
> value from the server and continue to use the old one, does things go
> better? We'll end up relying on the value that is wrong...
> 

We rely on the server to send us valid information. If the server
doesn't do that, then it's a server bug.

> If Samba server doesn't store the creation time attribute in xattrs
> (that is restricted by underlying file system and switched off by
> default), it can't return a right value to the client since POSIX file
> systems store only access, modify and change timestamps.
> 

Yep, faking up valid fields like this is always iffy.

> So, in the result we have the CIFS client that doesn't work with the
> default configuration of Samba. If we can't fix Samba due to POSIX
> restrictions), we need to do something with the client, don't we?
> 

Well, no. The default configuration of samba has unix extensions
enabled, and with that the create time is ignored (since it's not
returned at all in that case).

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
