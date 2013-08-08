From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: don't instantiate new dentries in readdir for
 inodes that need to be revalidated immediately
Date: Thu, 8 Aug 2013 10:22:36 -0400
Message-ID: <20130808102236.44424bf3@tlielax.poochiereds.net>
References: <51F92F0B.7030504@cam.ac.uk>
	<1375880647-22512-1-git-send-email-jlayton@redhat.com>
	<20130807090616.6ba44d6c@tlielax.poochiereds.net>
	<52024EC3.2070504@cam.ac.uk>
	<5203A5B8.80600@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5203A5B8.80600-OI3hZJvNYWs@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 08 Aug 2013 16:05:44 +0200
Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org> wrote:

> Am 07.08.2013 15:42, schrieb David McBride:
> > On 07/08/13 14:06, Jeff Layton wrote:
> >
> >> This patch is untested (other than for compilation), but I think it'll
> >> do the right thing. Metze, David could you test it and let us know if
> >> it helps?
> 
> Just to verify: could it be that mfsymlink is already broken in 
> 3.9.6-301.fc19? At least links created with fedora 18 are no longer 
> readable there. Newly created links seems to work fine (at least till now).
> 
> Greets
> Marcus
> 

Yes, 3.9.6 has the patch that broke it.

What matters is how the (in memory) inode is created after mounting. If
you first run across an mfsymlink with a readdir() call, then you'll
get an inode that's "stuck" as a regular file. If you instead do
something like stat() it before ever running a readdir over the
containing directory, it should work just fine.

This patch probably is probably reasonable for stable, given that the
original one also went there.

Steve, want to mark as such?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
