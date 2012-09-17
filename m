From: Nicolas Lefebvre <nico.lefebvre-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs.mount: mapchars + utf8 = loop
Date: Mon, 17 Sep 2012 15:31:38 +0200
Message-ID: <CAJt13SV_DS1XQL1dar5Xpy-r-BTuZ84FgDsAE_4ggXGZoWVUwA@mail.gmail.com>
References: <CAJt13SX0yMGEQtmw2KpCG3kwiOZPB9s1961Y1Lc6VT36=3pRCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJt13SX0yMGEQtmw2KpCG3kwiOZPB9s1961Y1Lc6VT36=3pRCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I'm trying to mount a smb share with both "mapchars" and
"iocharset=utf8" options and it seems to be bogus.
I must used mapchars option because some folder names contain
non-ascii characters and I must used iocharset=utf8 because some file
names contain question marks.

I have searched on the internet and found a very simple patch for a
2.6.32 kernel (https://bugzilla.samba.org/show_bug.cgi?id=6767)

--- orig/linux-2.6.32/fs/cifs/misc.c 2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.32/fs/cifs/misc.c 2011-10-09 22:25:10.767951322 +0200
@@ -713,7 +713,7 @@
     }

 ctoUCS_out:
- return i;
+ return j;
 }

But I'm on Ubuntu 12.04 with a 3.2.0-31 kernel and there is too much
differences for me between the two misc.c files and I'm not able to
report the patch in my kernel.

Did someone have an idea ?

Thanks,
Nicolas
