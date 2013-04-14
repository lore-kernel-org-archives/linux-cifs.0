From: "Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Subject: Re: kerberised cifs must have root krb5cc_0 cache?
Date: Sun, 14 Apr 2013 07:44:44 -0500 (CDT)
Message-ID: <1933147666.1014.1365943484239.JavaMail.root@hendelman.net>
References: <20130414080525.4871cca2@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130414080525.4871cca2-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The other option which worked for me was using the KRB5 credentials of the machine account to do the mount.

A few months ago Mr. Layton point this out to me and I did eventually end up getting it to work fairly well.  If you are root & need to browse around, you'll need to kinit as somebody (unless root is not just a local account but a domain user as well).  

My setup is samba 3.6.3 connected to AD, but I imagine it should work the same if you have a samba4 DC.

My fstab looks something like:

//server/share /localmntpoint cifs cache=strict,sec=krb5i,multiuser,acl,username=MACHINENAME$ 0 2

THis is in ubuntu 12.10.

The only 2 issues I've found are: 

1) Wwhen logging in via xfce I have to log-in twice.  I login/logout so infrequently it doesn't matter much to me.  I'm not sure why this is, but it only happens when I have my homedir on a samba mount using the above mounting line.

2) Just after setting up this mountpoint, I experienced it not mounting at startup, however logging in with a localuser and doing "mount -a", it would then work & things would work normally.  This no longer happens (or doesn't happen regularly - race condition in ubuntu startup?) so I mostly had forgotten about it until I started typing this out.

For #2 I've opened a bug on launchpad:
https://bugs.launchpad.net/ubuntu/+source/upstart/+bug/1130781

Thanks,

Robert



----- Original Message -----
From: "Jeff Layton" <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
To: "steve" <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Sunday, April 14, 2013 7:05:25 AM
Subject: Re: kerberised cifs must have root krb5cc_0 cache?

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
--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
