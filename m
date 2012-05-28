From: Dan Stromberg <strombrg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Possible CIFS bug - open one file, get another
Date: Mon, 28 May 2012 03:22:23 +0000 (UTC)
Message-ID: <loom.20120528T051852-75@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Hi folks.

I have what may be an in-kernel CIFS filesystem bug.

It seems that if I open a specific file, I get the contents of a different file 
back.

This may or may not have security implications.

Oddly, if I read the file with the same code in CPython 2.x, CPython 3.x or Pypy 
(recent trunk), I see the error.  But if I run exactly the same code on Jython 
2.5.x, it works fine.

Also, if I reboot, things work OK for a while.

And if I umount+mount, that works too.

I ran across the issue, because I have a backup program I've been writing for 
fun, and it saves the same timestamp inside a file, and in its filename.  When I 
assert that the two are the same within some smallish tolerance, the assertion 
sometimes fails, as described above.

Is there a bugtracker somewhere that such an issue should go into?

Has this already been fixed in later kernels?

I'm on Linux Mint 12, kernel 3.0.0-12-generic.

Thanks!
