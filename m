From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: cifs-utils VFS errors
Date: Wed, 29 May 2013 17:52:25 +0200
Message-ID: <1369842745.3123.9.camel@hh16.hh3.site>
References: <51A32117.5030908@steve-ss.com>
	 <20130528063525.1baeac8c@corrin.poochiereds.net>
	 <1369744796.2769.8.camel@hh16.hh3.site>
	 <20130528090142.36d5076e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130528090142.36d5076e-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2013-05-28 at 09:01 -0400, Jeff Layton wrote:
> >  How does this sound?
> > - I make a domain user called cifsuser with rfc2307 uidNumber and
> > gidNumber:
> > uid=3000025(cifsuser) gid=20513(Domain Users) groups=20513(Domain Users)
> > 
> > - I mount like this:
> > sudo kinit cifsuser
> > mount -t cifs //oliva/users /mnt -osec=krb5
> > (just tried it: fine)
> > 
> > -I stick cifsuser in the keytab and kinit -k it in a cron every few
> > hours or so to keep it alive.
> > 
> > Thanks so much for your time,
> > Steve
> > 
> 
> That sounds reasonable. Assuming that you don't actually do anything on
> the mount as root, then you can give "cifsuser" very limited privileges
> here too, essentially acting as a "squashed" user like under NFS.
> 
> Also, there's no need to do this crontab stuff either. If you mount
> with "-o sec=krb5,username=cifsuser" then cifs.upcall will be able to
> just use /etc/krb5.keytab without you needing to do anything special.
> 


Hi
OK. Nearly done. I now have the automounter working:
/etc/auto.users
* -fstype=cifs,rw,sec=krb5,username=cifsuser,multiuser ://oliva/users/&

It works fine except I have 2 keytabs per client.
 /etc/krb5.keytab
produced by
 net ads join
It contains the host/client and MACHINE$ keys 
and 
 /etc/cifs.keytab
produced the DC and copied to the clients which contains the cifsuser
keys.

Question: will cifs only look in /etc/krb5.keytab? Can I get it to look
at /etc/cifs.keytab instead? OK, I can ktutil merge them but. . .

Thanks for your patience.
