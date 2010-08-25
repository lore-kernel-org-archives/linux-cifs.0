From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/15] cifs: eliminate redundant xdev check in cifs_rename
Date: Wed, 25 Aug 2010 11:34:07 -0500
Message-ID: <AANLkTikVRKBA-sv3F8cJMFV3nfqfu4AYXXJ9E4Ja+Qv+@mail.gmail.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
	<1282332731-17444-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282332731-17444-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Aug 20, 2010 at 2:31 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The VFS always checks that the source and target of a rename are on the
> same vfsmount, and hence have the same superblock. So, this check is
> redundant. Remove it and simplify the error handling.

I looked more closely at this, and although EXDEV is checked for in one
place (early in the rename syscall), there are other paths to iop->cifs_rename
(nfs server and cachefiles for example call vfs_rename directly)
which do not check this, so it looks like the cifs EXDEV check
is not redundant and should be kept.



-- 
Thanks,

Steve
