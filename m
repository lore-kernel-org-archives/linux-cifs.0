From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Always update the dentry cache with fresh readdir()
 results
Date: Thu, 5 Jul 2012 07:24:01 -0400
Message-ID: <20120705072401.7eb1a7ee@corrin.poochiereds.net>
References: <1341477507.22307.21.camel@obed>
	<1341482567.22307.22.camel@obed>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Bill Robertson <bill_robertson-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>,
	Dion Edwards <dion_edwards-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>
To: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341482567.22307.22.camel@obed>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 05 Jul 2012 20:02:47 +1000
Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> (CCing in the original reporter)
> 
> On Thu, 2012-07-05 at 18:38 +1000, Andrew Bartlett wrote:
> > When we do a readdir() in CIFS, we are potentially efficiently
> > collecting a great deal of current, catchable stat information.
> > 
> > It is important that we always keep the dentry cache current for two
> > reasons:
> >  - the information may have changed (within the actime timeout).
> >  - if we still have a dentry cache value after that timeout, it is quite
> > expensive (1xRTT per entry) to find out if it was still correct.
> > 
> > This hits folks who are using CIFS over a WAN very badly.  For example
> > on an emulated 50ms delay I would have ls --color complete in .1
> > seconds, and a second run take 4.5 seconds, as each stat() (for the
> > colouring) would create a trans2 query_path_info query for each file,
> > right after getting the same information in the trans2 find_first2.
> > 
> > This patch implements the simplest approach, I would welcome a
> > correction on if there is a better approach than d_drop() and dput().
> > 
> > Tested on 3.4.4-3.cifsrevalidate.fc17.i686 with a 50ms WANem emulated
> > WAN against Samba 4.0 beta3.
> > 
> > Thanks,
> > 
> > Andrew Bartlett
> 

Nice work tracking that down and coding up the patch. While it's not
incorrect to drop the dentry here, we can be a little more efficient
here and just update the inode in place if the uniqueid didn't change.

Something like this (untested) patch should do it. Could you test this
and let me know if it also helps?

-------------------------[snip]--------------------------

cifs: always update the inode cache with the results from a FIND_*

When we get back a FIND_FIRST/NEXT result, we have some info about the
dentry that we use to instantiate a new inode. We were ignoring and
discarding that info when we had an existing dentry in the cache.

Fix this by updating the inode in place when we find an existing dentry
and the uniqueid is the same.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # .31.x
Reported-by: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Reported-by: Bill Robertson <bill_robertson-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>
Reported-by: Dion Edwards <dion_edwards-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/readdir.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 0a8224d..a4217f0 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -86,9 +86,12 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 
 	dentry = d_lookup(parent, name);
 	if (dentry) {
-		/* FIXME: check for inode number changes? */
-		if (dentry->d_inode != NULL)
+		inode = dentry->d_inode;
+		/* update inode in place if i_ino didn't change */
+		if (inode && CIFS_I(inode)->uniqueid == fattr->cf_uniqueid) {
+			cifs_fattr_to_inode(inode, fattr);
 			return dentry;
+		}
 		d_drop(dentry);
 		dput(dentry);
 	}
-- 
1.7.7.6
