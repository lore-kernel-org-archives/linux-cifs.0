From: Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: cifs: Strange O_DIRECT behaviour on non-directio mounts
Date: Fri, 27 Jun 2014 13:14:12 +0200
Message-ID: <20140627111412.GC5223@noname.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

I just discussed a problem with a qemu user on IRC, which boiled down to
him trying to open an image file on cifs with O_DIRECT, but not using a
directio mount. I understand that this probably isn't going to work
anytime soon (if at all), but it resulted in a rather unhelpful failure
mode.

What happens is that cifs lets the open() call succeed even with the
unsupported O_DIRECT on that mount, but then fails any I/O on the file
descriptor. I believe this was introduced in commit dca69288 (which I
think is otherwise pretty useful).

With the old behaviour, qemu detected what's going on and suggested to
use a non-O_DIRECT mode to the user, but with the new one, it got rather
unhappy after failing to find a working O_DIRECT alignment and ran into
an assertion failure...

Now I'll certainly fix the latter in qemu, but I also think that the
behaviour of cifs is rather surprising. Any chance that you can make
open() with O_DIRECT fail again on non-directio mounts?

Thanks,
Kevin
