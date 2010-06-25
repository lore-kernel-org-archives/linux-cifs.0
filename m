From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and
 register them
Date: Fri, 25 Jun 2010 12:53:06 -0400
Message-ID: <20100625125306.7f9b1966@tlielax.poochiereds.net>
References: <4C24A606.5040001@suse.de>
	<1277220214-3597-1-git-send-email-sjayaraman@suse.de>
	<yes>
	<9822.1277312573@redhat.com>
	<22697.1277470549@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <22697.1277470549-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 25 Jun 2010 13:55:49 +0100
David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
> > I think the creation time is currently being ignored as we won't be able
> > to accomodate in POSIX stat struct.
> 
> The FS-Cache interface doesn't use the POSIX stat struct, but it could be
> really useful to save it and use it for cache coherency inside the kernel.
> 
> Out of interest, what does Samba do when it comes to generating a creation time
> for UNIX where one does not exist?
> 

(cc'ing samba-technical since we're talking about the create time)

Looks like it mostly uses the ctime. IMO, the mtime would be a better
choice since it changes less frequently, but I don't guess that it
matters very much.

I have a few patches that make the cifs_iget code do more stringent
checks. One of those makes it use the create time like an i_generation
field to guard against matching inodes that have the same number but
that have undergone a delete/create cycle. They need a bit more testing
but I'm planning to post them in time for 2.6.36.

Because of how samba generates this number, it could be somewhat
problematic to do this. What may save us though is that Linux<->Samba
mostly uses unix extensions unless someone has specifically disabled
them on either end. The unix extension calls don't generally send any
sort of create time field, so we can't rely on it in those codepaths
anyway.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
