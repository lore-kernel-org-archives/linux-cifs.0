From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: broken mandatory locking behavior
Date: Sun, 25 Sep 2011 15:39:34 +0400
Message-ID: <CAKywueSgXNhmoA7V82U5Y0=N+DQWysekAwDdsiLMPt6L0OV55Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonk
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all!

Now I have been working on lock cache capability for cifs module and
simplification of lock code. So, I faced with a such an interesting
place - mandatory style unlock code.

The problem is that mandatory semantic doesn't allow to specify a
range and remove all locks from there. But cifs module allows it. The
reason why it is so can be that cifs module tries to follow posix
semantic for mandatory locks. I think it's not what we want at all.

We have two lock mode for cifs module: posix and mandatory. And as for
me, we should follow posix semantic for posix locks and mandatory for
mandatory locks. If we mix these two semantic for mandatory lock mode,
we reach nothing: no posix (because mandatory locks doesn't allow to
perform io ops on the locked region by other processes) and no
mandatory (because we can setup unlock from 0 to infinity and remove
all locks at once).

The another problem is that this 'broken' code lives on kernel for a
long time. So, I suggest to discuss it now - while I am here I can
include this fix into my patchset as well.

Thoughts?

-- 
Best regards,
Pavel Shilovsky.
