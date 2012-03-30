From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: sync/fsync issues on cifs drives
Date: Fri, 30 Mar 2012 16:03:17 -0400
Message-ID: <20120330160317.74e2570f@corrin.poochiereds.net>
References: <4F75F1BF.3050604@innominate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F75F1BF.3050604-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 30 Mar 2012 19:47:43 +0200
Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org> wrote:

> Greetings,
> 
> 
> I am using an older kernel (2.6.27.57). I have made the following 
> observations:
> 
> Let S be a windows shared drive that maps to the local directory s (on 
> Windows) and let Q be another shared drive on the same machine, such 
> that Q maps to the local directory q and that s is the parent of q.
> 
> On my machine, I am mounting both S and Q separately, so that S is 
> mounted read-only and Q is mounted with read/write access. I have also 
> mounted S and Q using a different user for each as well as using the 
> same user for both. This does not seem to make a difference (even though 
> at least once it seemed to matter, but I could not reproduce it.)
> 
> Scenario 1:
> When I finish my operations, I write the results to Q and perform a 
> fsync system call on each one of the written files.
> 
> I have observed that, under Windows NT4 this leads to an error condition:
> 
>    fsync failed (11): Resource temporarily unavailable
> 
> Also showing LOG entries similar to:
> 
>    kernel:  CIFS VFS: Write2 ret -11, wrote 9370
>    kernel:  CIFS VFS: No response to cmd 46 mid 58582
> 
> Scenario 2:
> On a separated process that has nothing to do with the shared drives, a 
> sync system calls stalls for a very long time (possibly hours) before 
> returning.
> 
> I observed this behavior on NT4, I have reports of this happening with 
> Windows 2008 R2 Server, but I could *not* reproduce it with Windows XP 
> PRO nor with Windows Server 2003.
> 
> ---- END of observations ----
> 
> Question 1: why does this happen?
> 
> Question 2: Is this fixed in a newer kernel release?
> 
> Question 3: Is there any way to limit a sync call to a single filesystem?
> 
> ---- END of questions -----
> 
> I went ahead and looked at the kernel code, and the reason for this is 
> clearly that on fs/cifs/file.c:162
> 
>          if (n_iov) {
>              /* Search for a writable handle every time we call
>               * CIFSSMBWrite2.  We can't rely on the last handle
>               * we used to still be valid
>               */
>              open_file = find_writable_file(CIFS_I(mapping->host));
>              if (!open_file) {
>                  cERROR(1, ("No writable handles for inode"));
>                  rc = -EBADF;
>              } else {
>                  rc = CIFSSMBWrite2(xid, cifs_sb->tcon, 
> 
>                             open_file->netfid,
>                             bytes_to_write, offset,
>                             &bytes_written, iov, n_iov,
>                             CIFS_LONG_OP);
>                  atomic_dec(&open_file->wrtPending);
>                  if (rc || bytes_written < bytes_to_write) {
>                      cERROR(1, ("Write2 ret %d, wrote %d",
>                            rc, bytes_written));
>                      /* BB what if continued retry is
>                         requested via mount flags? */
>                      if (rc == -ENOSPC)
>                          set_bit(AS_ENOSPC, &mapping->flags);
>                      else
>                          set_bit(AS_EIO, &mapping->flags);
>                  } else {
>                      cifs_stats_bytes_written(cifs_sb->tcon,
>                                   bytes_written);
>                  }
>              }
> 
> The call to CIFSSMBWrite2 is never checked for an EAGAIN condition 
> (which is what is returned in those cases.) I have not experimented with 
> this yet (it may very well be that any number of retries end of in the 
> same situation,) but wanted to know whether modiying this would make 
> sense at all or not. I am fairly new to this portion of the kernel code.
> 

I think you might want to look at commit
941b853d779de3298e39f1eb4e252984464eaea8, though that has never really
had much testing in isolation from the conversion to async writes.

> Note: I am not suggesting making a patch out of that idea, I just want 
> to check whether the idea makes sense.
> 
> Thanks in advance for your kind support!
> 
> 
> Cheers,
> 

2.6.27 is really old at this point...

The short answer here is that the behavior in more recent kernels
(3.x-ish) should be much better. The cifs client now does asynchronous
writes which speeds things up tremendously. It's also more tolerant of
network problems during writeback.
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
