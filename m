From: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: RE: ALPHA: advice for a patch to CIFS
Date: Sun, 29 Jul 2012 18:46:57 +0100
Message-ID: <7CE799CC0E4DE04B88D5FDF226E18AC2CDF915AAF4@LONPMAILBOX01.citrite.net>
References: <7CE799CC0E4DE04B88D5FDF226E18AC2CDF8E31455@LONPMAILBOX01.citrite.net>,<20120728080651.305f9bab@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120728080651.305f9bab-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Content-Language: en-GB
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> 
> > Hi,
> >   I'm currently trying to support utf-16 with characters not in plane 0.
> >
> > I'm currently end up with this patch. Currently is not against latest
> > kernel but the problem still reside in last git kernel.
> >
> > wchar_t is currently 16bit so converting a utf8 encoded characters not
> > in plane 0 (>= 0x10000) to wchar_t (that is calling char2uni) lead to a
> > -EINVAL return. This patch detect utf8 in cifs_strtoUCS and add special
> > code calling directly utf8_to_utf32.
> >
> > Does it sound a good patch or just a bad hack. Perhaps would be better
> > to change char2uni converting to unicode_t (32bit) instead of wchar_t
> > but probably many code have to be checked in order to make sure it does
> > not lead to wrong conversions, overflows or other bad stuff.
> >
> > Is it worth working in this hacking way? I'd like to upstream this
> > patch.
> >
> >
> > diff -r c2325d754e8d fs/cifs/cifs_unicode.c
> > --- a/fs/cifs/cifs_unicode.c  Fri Jul 27 15:12:23 2012 +0100
> > +++ b/fs/cifs/cifs_unicode.c  Fri Jul 27 19:09:04 2012 +0100
> > @@ -192,22 +192,40 @@ cifs_strtoUCS(__le16 *to, const char *fr
> 
> That function doesn't exist anymore. You should base this on a more
> recent upstream tree.
> 
> >  {
> >       int charlen;
> >       int i;
> > -     wchar_t *wchar_to = (wchar_t *)to; /* needed to quiet sparse */
> > +     int is_utf8 = !strcmp(codepage->charset, "utf8");
> 
> Gross...there must be a better way to do that?
> 

I didn't find any way.

> 
> > +     wchar_t wchar_to; /* needed to quiet sparse */
> > +     unicode_t uni;
> >
> >       for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
> >
> >               /* works for 2.4.0 kernel or later */
> > -             charlen = codepage->char2uni(from, len, &wchar_to[i]);
> > +             if (is_utf8) {
> > +                     charlen = utf8_to_utf32(from, len, &uni);
> > +             } else {
> > +                     charlen = codepage->char2uni(from, len, &wchar_to);
> > +                     uni = wchar_to;
> > +             }
> > +
> >               if (charlen < 1) {
> >                       cERROR(1,
> >                              ("strtoUCS: char2uni of %d returned %d",
> >                               (int)*from, charlen));
> >                       /* A question mark */
> > -                     to[i] = cpu_to_le16(0x003f);
> > +                     wchar_to = 0x003f;
> >                       charlen = 1;
> > -             } else
> > -                     to[i] = cpu_to_le16(wchar_to[i]);
> > -
> > +             } else if (uni < 0x10000) {
> 
>         "uni" will be unintialized here if is_utf8 is false.
> 
> > +                     wchar_to = uni;
> > +             } else if (uni < 0x110000) {
> > +                     uni -= 0x10000;
> > +                     to[i++] = cpu_to_le16(0xD800 | (uni >> 10));
> > +                     wchar_to = 0xDC00 | (uni & 0x3FF);
> > +             } else {
> > +                     cERROR(1,
> > +                            ("strtoUCS: char2uni of %d returned %d",
> > +                             (int)*from, charlen));
> > +                     wchar_to = 0x003f;
> > +             }
> > +             to[i] = cpu_to_le16(wchar_to);
> >       }
> >
> >       to[i] = 0;
> >
> > Signed-off-by: "Frediano Ziglio" <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
> >
> > Regards,
> >   Frediano
> >
> 
> The basic idea looks ok, but I agree that this could use some more
> commenting and/or some #define'd constants. Does the conversion of on
> the wire characters to the local charset need similar work?
> 

I found a function that suite my purpose, here you are updated patch 

>From 9fbbc065e8ee1d27ce6d99be0a9c8ab885756f0d Mon Sep 17 00:00:00 2001
From: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Date: Sun, 29 Jul 2012 12:42:59 +0100
Subject: [PATCH] Convert properly UTF-8 to UTF-16

wchar_t is currently 16bit so converting a utf8 encoded characters not
in plane 0 (>= 0x10000) to wchar_t (that is calling char2uni) lead to a
-EINVAL return. This patch detect utf8 in cifs_strtoUTF16 and add special
code calling utf8s_to_utf16s.

Signed-off-by: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_unicode.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 7dab9c0..a798e01 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -203,6 +203,19 @@ cifs_strtoUTF16(__le16 *to, const char *from, int len,
 	int i;
 	wchar_t wchar_to; /* needed to quiet sparse */
 
+	if (!strcmp(codepage->charset, "utf8")) {
+		i  = utf8s_to_utf16s(from, len, UTF16_LITTLE_ENDIAN,
+				       (wchar_t *) to, len);
+		if (i >= 0)
+			goto success;
+		/*
+		 * if fails fall back to UCS encoding as this
+		 * function should not return negative values
+		 * currently can fail only if source contains
+		 * invalid encoded characters
+		 */
+	}
+
 	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
 		charlen = codepage->char2uni(from, len, &wchar_to);
 		if (charlen < 1) {
@@ -215,6 +228,7 @@ cifs_strtoUTF16(__le16 *to, const char *from, int len,
 		put_unaligned_le16(wchar_to, &to[i]);
 	}
 
+success:
 	put_unaligned_le16(0, &to[i]);
 	return i;
 }
-- 
1.7.5.4

Frediano
