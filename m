From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs.mount: mapchars + utf8 = loop
Date: Mon, 17 Sep 2012 17:39:19 -0700
Message-ID: <20120917173919.54319010@corrin.poochiereds.net>
References: <CAJt13SX0yMGEQtmw2KpCG3kwiOZPB9s1961Y1Lc6VT36=3pRCw@mail.gmail.com>
	<CAJt13SV_DS1XQL1dar5Xpy-r-BTuZ84FgDsAE_4ggXGZoWVUwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/M=RLYEK8mf3Sr8u+vv.jRtT"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Lefebvre <nico.lefebvre-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJt13SV_DS1XQL1dar5Xpy-r-BTuZ84FgDsAE_4ggXGZoWVUwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--MP_/M=RLYEK8mf3Sr8u+vv.jRtT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 17 Sep 2012 15:31:38 +0200
Nicolas Lefebvre <nico.lefebvre-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hello,
> 
> I'm trying to mount a smb share with both "mapchars" and
> "iocharset=utf8" options and it seems to be bogus.
> I must used mapchars option because some folder names contain
> non-ascii characters and I must used iocharset=utf8 because some file
> names contain question marks.
> 
> I have searched on the internet and found a very simple patch for a
> 2.6.32 kernel (https://bugzilla.samba.org/show_bug.cgi?id=6767)
> 
> --- orig/linux-2.6.32/fs/cifs/misc.c 2009-12-03 04:51:21.000000000 +0100
> +++ linux-2.6.32/fs/cifs/misc.c 2011-10-09 22:25:10.767951322 +0200
> @@ -713,7 +713,7 @@
>      }
> 
>  ctoUCS_out:
> - return i;
> + return j;
>  }
> 
> But I'm on Ubuntu 12.04 with a 3.2.0-31 kernel and there is too much
> differences for me between the two misc.c files and I'm not able to
> report the patch in my kernel.
> 
> Did someone have an idea ?
> 

Looks like Baldvin never sent that patch to the list. This should be a
forward port of it. Does it work for you?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

--MP_/M=RLYEK8mf3Sr8u+vv.jRtT
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-cifs-fix-return-value-in-cifsConvertToUCS.patch

>From 3e61f98c4553276ef9187975a00721b6e6f4140d Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Mon, 17 Sep 2012 20:36:23 -0400
Subject: [PATCH] cifs: fix return value in cifsConvertToUCS

Reported-by: Baldvin Kovacs <baldvin.kovacs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Nicolas Lefebvre <nico.lefebvre-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_unicode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 1b2e180..667776e 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -327,6 +327,6 @@ cifsConvertToUCS(__le16 *target, const char *source, int srclen,
 	}
 
 ctoUCS_out:
-	return i;
+	return j;
 }
 
-- 
1.7.11.4


--MP_/M=RLYEK8mf3Sr8u+vv.jRtT--
