From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: add mount option to handle stat() failures by
 32-bit apps
Date: Tue, 11 Jan 2011 07:14:40 -0500
Message-ID: <20110111071440.23fdb226@tlielax.poochiereds.net>
References: <4D2C33A5.9000801@suse.de>
	<20110111105337.GA23753@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110111105337.GA23753-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 11 Jan 2011 05:53:37 -0500
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Tue, Jan 11, 2011 at 04:10:37PM +0530, Suresh Jayaraman wrote:
> > ..compiled without LFS support, but running on 64-bit kernel.
> > 
> > Currently, when a broken (compiled without LFS support) 32-bit application on
> > a 64-bit kernel tries to do a stat(), it fails with -EOVERFLOW error. This
> > problem happens because the 32-bit application is unable to fit the huge
> > 64-bit inode number in its target structure field.
> 
> This is nothing cifs specific.  Please do it in a generic way (e.g.
> sysctl) in the VFS.
> 

I also think a system-wide knob would be preferable. You could get rid
of the module parm for NFS, and change iunique and get_next_ino to
allow 64-bit inode numbers based on its setting.

The only problem I see with a sysctl is that you can change the value
at any time. What happens if you have a bunch of inodes in cache with
large i_ino numbers and then change that setting? Something settable
only at boot time might be better.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
