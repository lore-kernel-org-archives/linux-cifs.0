From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH] Fix Bug#31092: Unable to mount DFS filesystems from
	Windows 2008 servers
Date: Thu, 24 Mar 2011 15:30:46 +0100
Message-ID: <20110324143046.GA17270@cobija.connexer.com>
References: <20110321082927.8ECF830009@cobija.connexer.com> <20110324085854.36f8c3ec@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110324085854.36f8c3ec-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff,

On Thu, Mar 24, 2011 at 08:58:54AM -0400, Jeff Layton wrote:
 >  	if (!rc && cifs_sb->prepathlen && tcon) {
> >  		/* build_path_to_root works only when we have a valid tcon */
> 
> 		^^^^
> Have you tested a kernel with commit 4388d8eb? Does it make any
> difference in behavior here? If not, then might it be more reasonable
> to consolidate some of this code?

I've just double checked, and the patches seem to cover orthogonal problems.
The above patch works with or without this commit, and the bug is seen when
the commit is cherry-picked but the patch not applied.

> Over the last year or two, we've been whittling down cifs_mount to a
> smaller function by breaking out pieces of it into separate functions.
> It would be good to couple this fix with a similar cleanup of the DFS
> referral walking code if possible.

Yeah, I had an urge to do the same but thought I would refrain from doing
so unless asked specifically...  I'll do a tiny bit of re-factoring and
come back with something that puts the almost duplicate code into a single
function.  I don't know the code well enough to try for something more
daring though :)


	sean
