From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 05/10] cifs: define superblock-level cache index objects and register them
Date: Wed, 23 Jun 2010 17:58:10 +0100
Message-ID: <9720.1277312290@redhat.com>
References: <1277220206-3559-1-git-send-email-sjayaraman@suse.de> <yes>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277220206-3559-1-git-send-email-sjayaraman-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> Define superblock-level cache index objects (managed by cifsTconInfo
> structs).  Each superblock object is created in a server-level index object
> and in itself an index into which inode-level objects are inserted.
> 
> Currently, the superblock objects are keyed by sharename.

Seems reasonable.  Is there any way you can check that the share you are
looking at on a server is the same as the last time you looked?  Can you
validate the root directory of the share in some way?

David
