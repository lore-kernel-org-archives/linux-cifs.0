From: Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Subject: FIPS mode in the kernel break CIFS mounts?
Date: Thu, 28 Feb 2013 12:38:46 +0530
Message-ID: <512F027E.2030902@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

I was told that (haven't checked myself, yet) that booting in FIPS
(Federal Information Processing Standard) mode by adding "fips=1" to
grub.conf breaks CIFS mounts by returning -ENOENT.

I thought I'd ask if this is a known problem before I spend more time on
this.


Thanks

-- 
Suresh Jayaraman
