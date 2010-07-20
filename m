From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 04/09] cifs: define superblock-level cache index objects
 and register them
Date: Tue, 20 Jul 2010 09:37:22 -0400
Message-ID: <20100720093722.4f734f03@tlielax.poochiereds.net>
References: <Yes>
	<1278333747-30651-1-git-send-email-sjayaraman@suse.de>
	<20100720085327.4d1bf9d7@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100720085327.4d1bf9d7-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 20 Jul 2010 08:53:27 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Mon,  5 Jul 2010 18:12:27 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
> > Define superblock-level cache index objects (managed by cifsTconInfo structs).
> > Each superblock object is created in a server-level index object and in itself
> > an index into which inode-level objects are inserted.
> > 
> > The superblock object is keyed by sharename. The UniqueId/IndexNumber is used to
> > validate that the exported share is the same since we accessed it last time.
> > 
> > Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> 
> Hmm...Steve started merging these already but I've just now had the
> chance to review them.
> 
> This approach may be a problem. It seems to make the assumption that
> there is only a single tcon per superblock. How exactly will this work
> when there are multiple tcons per superblock as will be the case with
> multisession mounts?
> 
> By having a cache cookie per tcon, will that mean that you'll
> potentially have multiple versions of cached inodes (one for each tcon)?
> 

Ahh nm. This shouldn't be a problem since this key is based on the
sharename only and that will be the same between the multiple tcons.

Please disregard!
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
