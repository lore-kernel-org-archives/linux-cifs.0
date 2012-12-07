From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/6] cifs-utils: a pile of random patches
Date: Fri, 7 Dec 2012 10:34:54 -0500
Message-ID: <20121207103454.035ace6b@tlielax.poochiereds.net>
References: <1354634204-21602-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354634204-21602-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  4 Dec 2012 10:16:38 -0500
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Here's a pile of random patches I've accumulated so for for cifs-utils.
> They should be fairly straightforward, but let me know if anyone has
> concerns with them.
> 
> Jeff Layton (6):
>   mount.cifs: treat uid=,gid=,cruid= options as name before assuming
>     they're a number
>   mount.cifs: don't pass "flag" options to the kernel
>   autotools: remove unnecessary files from distro
>   getcifsacl: use "size" instead of reconverting original field to host
>     endian
>   getcifsacl: free strings returned by wbcLookupSid
>   getcifsacl: ensure that we don't overrun the wbcDomainSid when
>     converting
> 
>  INSTALL      | 365 ----------------------------------
>  depcomp      | 630 -----------------------------------------------------------
>  getcifsacl.c |  12 +-
>  install-sh   | 520 ------------------------------------------------
>  missing      | 376 -----------------------------------
>  mount.cifs.c |  74 +++----
>  6 files changed, 40 insertions(+), 1937 deletions(-)
>  delete mode 100644 INSTALL
>  delete mode 100755 depcomp
>  delete mode 100755 install-sh
>  delete mode 100755 missing
> 

Set is now merged...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
