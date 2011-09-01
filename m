From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: GPLv2 for cifs-utils existing?
Date: Thu, 1 Sep 2011 11:05:03 -0400
Message-ID: <20110901110503.79ae0549@barsoom.rdu.redhat.com>
References: <1473841237.231172.1314882534664.JavaMail.ngmail@webmail14.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: brennersimon-KvP5wT2u2U0@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473841237.231172.1314882534664.JavaMail.ngmail-hrWuGRo80rTYJ3RwVI/HE3/75uz/KqYjrE5yTffgRl4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 1 Sep 2011 15:08:54 +0200 (CEST)
brennersimon-KvP5wT2u2U0@public.gmane.org wrote:

> Hello there,
> 
> I'm wondering whether the cifs-utils are available licenced under the GPLv2? I only found it under GPLv3. Maybe there are specific circumstances under which the licence is changeable?
> 
> Thanks,
> 
> -Simon Brenner.

No. It's GPLv3 and up.

We do occasionally dual-license some of the patches to make it
easier to backport to older versions of the same tools in samba. The
cifs-utils package itself has always been GPLv3 however.

Can you clarify why you'd like to see it as GPLv2?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
