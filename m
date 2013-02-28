From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: FIPS mode in the kernel break CIFS mounts?
Date: Thu, 28 Feb 2013 07:02:45 -0800
Message-ID: <20130228070245.6152ab77@corrin.poochiereds.net>
References: <512F027E.2030902@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <512F027E.2030902-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 28 Feb 2013 12:38:46 +0530
Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org> wrote:

> Hi all,
> 
> I was told that (haven't checked myself, yet) that booting in FIPS
> (Federal Information Processing Standard) mode by adding "fips=1" to
> grub.conf breaks CIFS mounts by returning -ENOENT.
> 
> I thought I'd ask if this is a known problem before I spend more time on
> this.
> 
> 
> Thanks
> 

Yep, known problem. We try to load several crypto routines during the
mount process, and that fails in FIPS mode since they aren't allowed.
The fix is to only load those routines once we know that we actually
need them and only fail in those cases. There are no patches for that
yet, AFAIK.

Note that enabling FIPS mode will almost certainly break both NTLMv1
and NTLMv2 auth, since those require md4 and md5. It might be nice to
update the manpage with what sec= options actually work after enabling
FIPS mode once the main problem is fixed.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
