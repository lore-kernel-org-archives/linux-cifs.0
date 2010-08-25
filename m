From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/15] cifs: eliminate redundant xdev check in
 cifs_rename
Date: Wed, 25 Aug 2010 13:55:14 -0400
Message-ID: <20100825135514.7234ab6a@corrin.poochiereds.net>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
	<1282332731-17444-2-git-send-email-jlayton@redhat.com>
	<AANLkTikVRKBA-sv3F8cJMFV3nfqfu4AYXXJ9E4Ja+Qv+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikVRKBA-sv3F8cJMFV3nfqfu4AYXXJ9E4Ja+Qv+-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 25 Aug 2010 11:34:07 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Aug 20, 2010 at 2:31 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > The VFS always checks that the source and target of a rename are on the
> > same vfsmount, and hence have the same superblock. So, this check is
> > redundant. Remove it and simplify the error handling.
> 
> I looked more closely at this, and although EXDEV is checked for in one
> place (early in the rename syscall), there are other paths to iop->cifs_rename
> (nfs server and cachefiles for example call vfs_rename directly)
> which do not check this, so it looks like the cifs EXDEV check
> is not redundant and should be kept.
> 
> 
> 

(cc'ing linux-fsdevel)

The nfs server checks for it. In nfsd_rename:

        host_err = -EXDEV;
        if (ffhp->fh_export->ex_path.mnt != tfhp->fh_export->ex_path.mnt)
                goto out_dput_new;


I don't think cachefiles would work if you split the cache directory
across multiple filesystems. Most filesystems don't check for this on
their own, so I'm not sure why we need to have cifs do this in a
special fashion.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
