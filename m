From: Elias Pipping <pipping-N9AOi2cAC9ZBDgjK7y7TUQ@public.gmane.org>
Subject: --enable-cifsidmap [default=no]
Date: Sun, 21 Aug 2011 17:40:50 +0200 (CEST)
Message-ID: <20110821.174050.349078853015387924.pipping@lavabit.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

configure.ac from cifs-utils 5.0 contains

  AC_ARG_ENABLE(cifsidmap,
          [AC_HELP_STRING([--enable-cifsidmap],
                          [Create cifs.idmap binary @<:@default=no@:>@])],
          enable_cifsidmap=$enableval,
          enable_cifsidmap="maybe")

>From my understanding, this should either be

  AC_ARG_ENABLE(cifsidmap,
          [AC_HELP_STRING([--enable-cifsidmap],
                          [Create cifs.idmap binary @<:@default=no@:>@])],
          enable_cifsidmap=$enableval,
          enable_cifsidmap="no")

or

  AC_ARG_ENABLE(cifsidmap,
          [AC_HELP_STRING([--enable-cifsidmap],
                          [Create cifs.idmap binary @<:@default=yes@:>@])],
          enable_cifsidmap=$enableval,
          enable_cifsidmap="maybe")


Best regards,

Elias Pipping
