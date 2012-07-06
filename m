From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Always update the dentry cache with fresh readdir()
 results
Date: Sat, 07 Jul 2012 08:42:03 +1000
Message-ID: <1341614523.22307.42.camel@obed>
References: <1341477507.22307.21.camel@obed>
	 <1341482567.22307.22.camel@obed>
	 <20120705072401.7eb1a7ee@corrin.poochiereds.net>
	 <1341556212.22307.34.camel@obed>
	 <20120706071123.2563c615@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Bill Robertson <bill_robertson-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>,
	Dion Edwards <dion_edwards-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120706071123.2563c615-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2012-07-06 at 07:11 -0400, Jeff Layton wrote:
> On Fri, 06 Jul 2012 16:30:12 +1000
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
> > Yes, same behaviour as as per my patch.  Thanks you very much, it seems
> > we are on our way to solving this!
> > 
> 
> Thanks for testing it. I've gone ahead and sent that off to Steve for
> inclusion. If there is anything else required wrt serializing the inode
> attribute updates, then we can deal with that in a separate patch since
> that's really a separate problem.

Indeed.  Thanks!

Andrew Bartlett

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
