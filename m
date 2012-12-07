From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Date: Fri, 7 Dec 2012 11:16:02 -0500
Message-ID: <20121207161602.GA17710@infradead.org>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1354818391-7968-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Dec 06, 2012 at 10:26:28PM +0400, Pavel Shilovsky wrote:
> Network filesystems CIFS, SMB2.0, SMB3.0 and NFSv4 have such flags - this change can benefit cifs and nfs modules. While this change is ok for network filesystems, itsn't not targeted for local filesystems due security problems (e.g. when a user process can deny root to delete a file).
> 
> Share flags are used by Windows applications and WINE have to deal with them too. While WINE can process open share flags itself on local filesystems, it can't do it if a file stored on a network share and is used by several clients. This patchset makes it possible for CIFS/SMB2.0/SMB3.0.

I don't think introducing user visible flags that are only supported on
a single network filesystem is a good idea.

I'm not even sure adding these flags does make a lot of sense, but
assuming we'd actually want this (and I'd like some more detailed
explanation) I think we'd at least need to make sure that:

 a) opening files with the new modes gives a proper error message if not
    supported
 b) there needs to be local support for them as well
 c) we need to think really hard when they should be supported, and need
    a good rational for it.  I can't see how we could do it
    unconditionally for all users as that would introduce easy denial
    of services attacks the way I understand the semantics (correct me
    if I'm wrong).  So a mount option like you currently do probably is
    the least bad even if don't fell overly happy about that version.

What is the reason your special wine use case can't simply use a
userspace cifs client?  Given that wine uses windows filesystem
semantics and cifs does as well tunnelling it through a Posix-like API
inbetween is never going to be perfect.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
