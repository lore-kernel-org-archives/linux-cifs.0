From: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Subject: [PATCH 0/8] replace memset by memzero_explicit
Date: Sun, 30 Nov 2014 18:03:41 +0100
Message-ID: <1417367029-32762-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Memset on a local variable may be removed when it is called just before the
variable goes out of scope.  Using memzero_explicit defeats this
optimization.  The complete semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
local idexpression e;
type T,T1;
@@

{
... when any
T x[...];
... when any
    when exists
(
e = (T1)x
|
e = (T1)&x[0]
)
... when any
    when exists
- memset
+ memzero_explicit
  (x,
-0,
  ...)
... when != x
    when != e
    when strict
}

@@
identifier i,x;
local idexpression e;
type T;
@@

{
... when any
struct i x;
... when any
    when exists
e = (T)&x
... when any
    when exists
- memset
+ memzero_explicit
  (&x,
-0,
  ...)
... when != x
    when != e
    when strict
}

// ------------------------------------------------------------------------

@@
identifier x;
type T,T1;
expression e;
@@

{
... when any
T x[...];
... when any
    when exists
    when != e = (T1)x
    when != e = (T1)&x[0]
- memset
+ memzero_explicit
  (x,
-0,
  ...)
... when != x
    when strict
}

@@
identifier i,x;
expression e;
type T;
@@

{
... when any
struct i x;
... when any
    when exists
    when != e = (T)&x
- memset
+ memzero_explicit
  (&x,
-0,
  ...)
... when != x
    when strict
}
// </smpl>
