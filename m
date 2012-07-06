From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Always update the dentry cache with fresh readdir()
 results
Date: Fri, 06 Jul 2012 16:20:47 +1000
Message-ID: <1341555647.22307.33.camel@obed>
References: <1341477507.22307.21.camel@obed>
	 <1341482567.22307.22.camel@obed>
	 <20120705072401.7eb1a7ee@corrin.poochiereds.net>
	 <1341531067.22307.26.camel@obed>
	 <20120705214608.2a3a681b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Bill Robertson <bill_robertson-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>,
	Dion Edwards <dion_edwards-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120705214608.2a3a681b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2012-07-05 at 21:46 -0400, Jeff Layton wrote:
> On Fri, 06 Jul 2012 09:31:07 +1000
> Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
> > On Thu, 2012-07-05 at 07:24 -0400, Jeff Layton wrote:
> > > On Thu, 05 Jul 2012 20:02:47 +1000
> > > Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > > 
> > > > (CCing in the original reporter)
> > > > 
> > > > On Thu, 2012-07-05 at 18:38 +1000, Andrew Bartlett wrote:
> > > > > When we do a readdir() in CIFS, we are potentially efficiently
> > > > > collecting a great deal of current, catchable stat information.
> > > > > 
> > > > > It is important that we always keep the dentry cache current for two
> > > > > reasons:
> > > > >  - the information may have changed (within the actime timeout).
> > > > >  - if we still have a dentry cache value after that timeout, it is quite
> > > > > expensive (1xRTT per entry) to find out if it was still correct.
> > > > > 
> > > > > This hits folks who are using CIFS over a WAN very badly.  For example
> > > > > on an emulated 50ms delay I would have ls --color complete in .1
> > > > > seconds, and a second run take 4.5 seconds, as each stat() (for the
> > > > > colouring) would create a trans2 query_path_info query for each file,
> > > > > right after getting the same information in the trans2 find_first2.
> > > > > 
> > > > > This patch implements the simplest approach, I would welcome a
> > > > > correction on if there is a better approach than d_drop() and dput().
> > > > > 
> > > > > Tested on 3.4.4-3.cifsrevalidate.fc17.i686 with a 50ms WANem emulated
> > > > > WAN against Samba 4.0 beta3.
> > > > > 
> > > > > Thanks,
> > > > > 
> > > > > Andrew Bartlett
> > > > 
> > > 
> > > Nice work tracking that down and coding up the patch. While it's not
> > > incorrect to drop the dentry here, we can be a little more efficient
> > > here and just update the inode in place if the uniqueid didn't change.
> > > 
> > > Something like this (untested) patch should do it. Could you test this
> > > and let me know if it also helps?
> > 
> > Is it really safe to update so much without getting a lock over all the
> > updates?
> > 
> 
> What's your worry, specifically?
> 
> The vfs only requires that you hold the lock over i_size updates. I
> suppose it's possible that you could have racing updates to an inode,
> but in practice, the last one will generally "win".

Writes are a worry, and I'm not sure I like the idea of parallel updates
being able to leave it in a undefined state, but I was more worried
about a read, that is someone reading just between:

	inode->i_uid = fattr->cf_uid;
	inode->i_gid = fattr->cf_gid;

and

	/* if dynperm is set, don't clobber existing mode */
	if (inode->i_state & I_NEW ||
	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM))
		inode->i_mode = fattr->cf_mode;

Imagine that this file was changing owner, and was setuid.  Don't we
have a race here were a very lucky caller could get the entry from the
dentry cache between the uid change and the permission change (setuid
removal)?

The race is very narrow, and most of the worries are much more mundane,
but isn't this why you would lock the inode for the whole update?

I'm not fully up on kernel locking rules, which is why I looked to NFS
for the example I mentioned. 

Thanks,

Andrew Bartlett 

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
