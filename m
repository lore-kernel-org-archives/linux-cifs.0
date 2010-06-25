From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and register them
Date: Sat, 26 Jun 2010 00:04:28 +0100
Message-ID: <20123.1277507068@redhat.com>
References: <20100625182651.36800d06@tlielax.poochiereds.net> <20100625125306.7f9b1966@tlielax.poochiereds.net> <4C24A606.5040001@suse.de> <1277220214-3597-1-git-send-email-sjayaraman@suse.de> <yes> <9822.1277312573@redhat.com> <22697.1277470549@redhat.com> <18628.1277502398@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100625182651.36800d06-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> IIUC, updating mtime for a write is also an attribute change, and that
> affects ctime. According to the stat(2) manpage:

You're right.  Okay, ctime is the more frequently changed.

> > Note that Ext4 appears to have a file creation time field in its inode
> > (struct ext4_inode::i_crtime[_extra]).  Can Samba be made to use that?
> 
> Is it exposed to userspace in any (standard) way? It would be handy to
> have that. While we're wishing...it might also be nice to have a
> standard way to get at the i_generation from userspace too.

Not at present, but it's something that could be exported by ioctl() or
getxattr().

David
