From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] on 2nd try mount.cifs must also uppercase "orig_dev" -
 recent kernels now ignore "unc=..." mount option
Date: Thu, 3 Jul 2014 16:06:32 -0400
Message-ID: <20140703160632.1ffbdf29@tlielax.poochiereds.net>
References: <53B2EA59.8090404@kukkukk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?B?R/xudGVy?= Kukkukk <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B2EA59.8090404-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 01 Jul 2014 19:05:29 +0200
G=FCnter Kukkukk <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org> wrote:

> userland mount helper mount.cifs.
>=20
> Also uppercase the now used (kernel) "orig_dev" parameter, to get the
> mount retry working again.
>=20
> Cheers, G=FCnter

Patch merged into master.

Thanks!
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
