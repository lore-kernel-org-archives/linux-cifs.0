From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with
 prefixpath option
Date: Wed, 31 Aug 2011 14:41:52 -0400
Message-ID: <20110831144152.788c2543@tlielax.poochiereds.net>
References: <1314341541-2476-1-git-send-email-piastry@etersoft.ru>
	<CAKywueRzwQPROzWTNwhbSOeEanV+Pumn=vFDmYL0uuEApfsX9A@mail.gmail.com>
	<20110830085935.71e671e4@corrin.poochiereds.net>
	<CAKywueSy2tFQC4mxOBZYjiY=PyLjUZ44v+qvtNNg+zKoxJmeCw@mail.gmail.com>
	<20110831140044.5ac4a691@tlielax.poochiereds.net>
	<CAKywueTh-XVrmRH-7AwedShAhmAmFAHs9fsOALrZpkzMhemP=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTh-XVrmRH-7AwedShAhmAmFAHs9fsOALrZpkzMhemP=Q@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 31 Aug 2011 22:27:25 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/8/31 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > I think you need to make sure you're holding the i_mutex of the parent
> > for this. Most of these sorts of dentry operations require it.
> >
> 
> In the case of this patch, we can have a negative parent - so, can't
> hold i_mutex here. It seems to me that we need extra cifs mutex for
> dealing this it.
> 

In the event of a positive parent, how do you intend to ensure that the
dentry is not instantiated via other codepaths (lookup or readdir?)

It's not clear to me though that this is really a problem though in any
case. In the event that you "re-instantiate" the dentry, the old inode
will just end up being put (and likely eventually freed). Sure, the
inode number might change, but that's life with noserverino.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
