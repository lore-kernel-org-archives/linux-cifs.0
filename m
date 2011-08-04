From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: regression with prefixpath mounts
Date: Thu, 4 Aug 2011 10:29:32 -0400
Message-ID: <20110804102932.4adf33bf@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Pavel,

We have a bit of a problem...

    https://bugzilla.redhat.com/show_bug.cgi?id=727834

The shared superblock patches seem to have broken the ability to mount
directories that live under other directories to which the mounting
user doesn't have permissions.

IOW, suppose we have this shared out:

    /share/dir1/dir2

...if the permissions on dir1 don't allow the mounting user to access
it, then cifs_get_root will fail. We'll need to come up with a new
scheme for handling this that doesn't require access to every component
of the prefixpath.

I'm not sure what the right fix is here...we may need to come up with a
scheme more like NFS does. It will alter the tree when it discovers
that a root dir that it previously was working on is actually a subdir
of another mount.

Thoughts?
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
