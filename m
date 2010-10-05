From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 10/14] cifs: convert GlobalSMBSeslock from a rwlock to
 regular spinlock
Date: Tue, 5 Oct 2010 06:58:42 -0400
Message-ID: <20101005065842.41124df3@tlielax.poochiereds.net>
References: <1286214781-626-1-git-send-email-jlayton@redhat.com>
	<1286214781-626-11-git-send-email-jlayton@redhat.com>
	<4CAAFE45.6070803@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CAAFE45.6070803-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 05 Oct 2010 16:00:29 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 10/04/2010 11:22 PM, Jeff Layton wrote:
> > To prevent races we need to be able to do an atomic_dec_and_lock with
> > it, and that won't work with a rwlock.
> 
> It's not clear to me where a potential race window is. Could you please
> elaborate?
> 
> 
> Thanks,
> 

The specific race window that I was thinking about doesn't exist today
as such, but that's just because the way that filehandles are managed
is so different.

When we do refcounting with atomic_t's though we need to take care that
we don't act on them without taking steps to prevent races. For
instance, suppose I had left the code using an rwlock_t and did this in
cifsFileInfo_put:

if (atomic_dec_and_test(&open_file->count))
	return;
write_lock(&GlobalSMBSeslock)

...and then tear down the cifsFileInfo. There would always be a
possibility that the count increased after I checked it but before
taking the lock, which could result in a use-after-free.

Now that I think about this though...it might be better to just make the
count non-atomic, and simply move it under the protection of the lock.
You generally need the lock anyway when you're searching for a file so
there's little benefit to using an atomic here.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
