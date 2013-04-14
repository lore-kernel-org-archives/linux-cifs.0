From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: kerberised cifs must have root krb5cc_0 cache?
Date: Sun, 14 Apr 2013 08:05:25 -0400
Message-ID: <20130414080525.4871cca2@tlielax.poochiereds.net>
References: <51696B62.7060103@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51696B62.7060103-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 13 Apr 2013 16:27:46 +0200
steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:

> Ubuntu 12.10 clients in a Samba4 domain.
> 
> Hi
> We are automounting cifs using:
> -osec=krb5,multiuser.
> 
> It seems that unless the root cache:
> /tmp/krb5cc_0
> is present, users cannot enter the share even if they have a ticket with 
> their own cache under /tmp
> 
> Is this the correct behavior?
> 
> If so, how to go about maintaining the cache alive. I thought about 
> creating s domain user, say autofs-user and extracting his keytab. I 
> would then run a script as root that calls k5start to maintain the 
> ticket cache. But then, it could be overwritten if, say, Administrator 
> logs in from a root account. Would that matter? So long as the root 
> cache is present, does it matter which principal it has?
> 
> Cheers,
> Steve

You do need a krb5 ticket somewhere to use as root's credentials. If
you set the cruid= mount option that can be a credcache owned by a
different user.

Alternately, you can set up the system-wide keytab in /etc/krb5.keytab
with the correct credentials for root.

-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
