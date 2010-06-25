From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and register them
Date: Fri, 25 Jun 2010 13:55:49 +0100
Message-ID: <22697.1277470549@redhat.com>
References: <4C24A606.5040001@suse.de> <1277220214-3597-1-git-send-email-sjayaraman@suse.de> <yes> <9822.1277312573@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C24A606.5040001-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> I think the creation time is currently being ignored as we won't be able
> to accomodate in POSIX stat struct.

The FS-Cache interface doesn't use the POSIX stat struct, but it could be
really useful to save it and use it for cache coherency inside the kernel.

Out of interest, what does Samba do when it comes to generating a creation time
for UNIX where one does not exist?

David
