From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and register them
Date: Wed, 23 Jun 2010 18:02:53 +0100
Message-ID: <9822.1277312573@redhat.com>
References: <1277220214-3597-1-git-send-email-sjayaraman@suse.de> <yes>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277220214-3597-1-git-send-email-sjayaraman-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> Define inode-level data storage objects (managed by cifsInodeInfo structs).
> Each inode-level object is created in a super-block level object and is
> itself a data storage object in to which pages from the inode are stored.
> 
> The inode object is keyed by UniqueId. The coherency data being used is
> LastWriteTime and the file size.

Isn't there a file creation time too?

I take it you don't support caching on files that are open for writing at this
time?

David
