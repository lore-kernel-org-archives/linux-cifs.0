From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: GPLv2 for cifs-utils existing?
Date: Fri, 2 Sep 2011 06:40:23 -0400
Message-ID: <20110902064023.51a3c945@tlielax.poochiereds.net>
References: <240043230.241860.1314945935851.JavaMail.ngmail@webmail12.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: brennersimon-KvP5wT2u2U0@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <240043230.241860.1314945935851.JavaMail.ngmail-hrWuGRo80rQUOsVZMWqyoH/75uz/KqYjrE5yTffgRl4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2 Sep 2011 08:45:35 +0200 (CEST)
brennersimon-KvP5wT2u2U0@public.gmane.org wrote:

> > Can you clarify why you'd like to see it as GPLv2?
> 
> At the moment, I'm just trying to learn and understand more about the GPLv3. So for several Linux programs I've been seeing what licence they've got. I've heard that GPLv3 is quite virulent. That could prevent a manufacturer (say of routers, receivers or similar things) from using cifs-utils if he didn't want to be all of his code opened. Is that right?

(re-cc'ing linux-cifs and Jeremy who is better versed in this sort of
thing than I am)

That's nonsense. It's certainly fine to ship GPLv3 software alongside
closed source code. You'll need to provide source for the GPL'ed parts
of course, but providing a set of self-contained GPLv3 programs
shouldn't force a vendor to open anything else.

The problems that you describe typically come in with linking GPL
libraries against closed source code, which is a bit more murky. That
shouldn't be a problem with cifs-utils as it doesn't ship any libraries.

That said, I'm not a lawyer and you may want to consult yours before
doing anything.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
