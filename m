From: David =?utf-8?b?QmFsYcW+aWM=?= <xerces9-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kernel 3.1.1 - cifs issue - ls: cannot access =?utf-8?b?L2NpZnNfbW50Og==?= Cannot allocate memory
Date: Fri, 21 Sep 2012 23:05:17 +0000 (UTC)
Message-ID: <loom.20120922T005738-960@post.gmane.org>
References: <00c001cca300$4b512b80$e1f38280$@lucidpixels.com> <4EC269FC.1060104@suse.com> <004b01cca3cc$932e4240$b98ac6c0$@lucidpixels.com> <4EC334D6.9020208@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Suresh Jayaraman <sjayaraman@...> writes:

> Ah, ok. In case if you have not figured out how to overcome this
> problem, take a look at
> 
> http://alan.lamielle.net/2009/09/03/windows-7-nonpaged-pool-srv-error-2017

(I'm not subscribed, so please CC me)

Hi!

I also encountered this error 12 accessing a shared folder on a Windows 7 Pro
SP1 64-bit "server", client being SystemRescueCd 3.0.0 with kernel version
3.2.28 32 bit. It also happens with other kernels (RipLinux 13.7, kernel 3.2.1).


I got the error when copying a single large file to the shared folder.
The registry tweaks at that URL mitigates the problem.
But I changed it back to do some research.
When accessing the same shared folder from a Windows 7 Home Premium SP1 x64
client, there is no problem.

When I tried with Linux just before posting this, I got error 12 right when
mounting, before doing any file operations.

Is this because linux-cifs does not respect the MaxReq parm that the server
sends, as suggested in this post:
http://article.gmane.org/gmane.linux.kernel.cifs/4294 ?

Regards,
David
