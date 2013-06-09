From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: cifs-utils VFS errors
Date: Sun, 09 Jun 2013 10:45:01 +0200
Message-ID: <1370767501.3112.9.camel@hh16.hh3.site>
References: <51A32117.5030908@steve-ss.com>
	 <20130528063525.1baeac8c@corrin.poochiereds.net>
	 <1369744796.2769.8.camel@hh16.hh3.site>
	 <20130528090142.36d5076e@corrin.poochiereds.net>
	 <1369842745.3123.9.camel@hh16.hh3.site>
	 <20130529144555.595ee5a4@tlielax.poochiereds.net>
	 <1369860007.2278.19.camel@hh16.hh3.site>
	 <20130608090820.1f3bb0e2@tlielax.poochiereds.net>
	 <1370701706.6104.3.camel@hh16.hh3.site>
	 <1370702975.6763.1.camel@hh16.hh3.site>
	 <20130608202342.6e191950@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130608202342.6e191950-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2013-06-08 at 20:23 -0400, Jeff Layton wrote:
> On Sat, 08 Jun 2013 16:49:35 +0200
> steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:

> > > Hi
> > > Brilliant.
> > > I applied the patch, well, I edited cifs.upcall.c with the -'s and +'s
> > > at least. I then, make clean, build and make install. I now have:
> > >  cifs.upcall
> > > Usage: cifs.upcall [ -d /path/to/keytab] [-k /path/to/krb5.conf] [-t]
> > > [-v] [-l] key_serial
> > > 
> > > Looks good. Where do I put the -d in:
> > >  mount -t cifs //altea/users /mnt -osec=krb5,multiuser,username=cifsuser
> > > or don't I?
> > > Cheers,
> > > Steve
> > 
> > Here is /etc/request-key.conf:
> > 
> > create	cifs.spnego	*	*		/usr/sbin/cifs.upcall -c %k
> > 
> > 
> 
> Yes, you'll need to add the new argument there.
> 

Hi
Here is the keytab:
 klist -ke /etc/cifs.keytab
Keytab name: FILE:/etc/cifs.keytab
KVNO Principal
----
--------------------------------------------------------------------------
   1 cifsuser-UiqEU/D402Y@public.gmane.org (arcfour-hmac) 
create	cifs.spnego * * /usr/sbin/cifs.upcall -d /etc/cifs.keytab -c %k

Unfortunately we are back to having to have a root cache in /tmp:
 mount -t cifs //altea/shared /home/shared
-osec=krb5,multiuser,username=cifsuser
mount error(126): Required key not available

/var/log/messages for the failed key:
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
2013-06-09T10:36:34.566409+02:00 catral cifs.upcall: user=cifsuser
2013-06-09T10:36:34.580279+02:00 catral cifs.upcall: pid=1396
2013-06-09T10:36:34.587159+02:00 catral cifs.upcall: find_krb5_cc:
scandir error on directory '/run/user/0': No such file or directory
2013-06-09T10:36:34.588382+02:00 catral cifs.upcall:
krb5_get_init_creds_keytab: -1765328174
2013-06-09T10:36:34.595349+02:00 catral cifs.upcall: handle_krb5_mech:
getting service ticket for altea
2013-06-09T10:36:34.596593+02:00 catral cifs.upcall: cifs_krb5_get_req:
unable to resolve (null) to ccache
2013-06-09T10:36:34.607253+02:00 catral cifs.upcall: handle_krb5_mech:
failed to obtain service ticket (-1765328245)
2013-06-09T10:36:34.608787+02:00 catral cifs.upcall: handle_krb5_mech:
getting service ticket for altea.hh3.site
2013-06-09T10:36:34.612720+02:00 catral cifs.upcall: cifs_krb5_get_req:
unable to resolve (null) to ccache
2013-06-09T10:36:34.614176+02:00 catral cifs.upcall: handle_krb5_mech:
failed to obtain service ticket (-1765328245)
2013-06-09T10:36:34.620231+02:00 catral cifs.upcall: Unable to obtain
service ticket
2013-06-09T10:36:34.621737+02:00 catral cifs.upcall: Exit status
-1765328245

If I now kinit cifsuser as root, it mounts fine:
 kinit cifsuser
Password for cifsuser-UiqEU/D402Y@public.gmane.org: 
catral:/home/steve # mount -t cifs //altea/shared /home/shared
-osec=krb5,multiuser,username=cifsuser
catral:/home/steve # mount | grep altea/shared
//altea/shared on /home/shared type cifs
(rw,relatime,vers=1.0,sec=krb5,cache=strict,unc=\\altea
\shared,multiuser,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.1.100,unix,posixpaths,serverino,acl,noperm,rsize=1048576,wsize=65536,actimeo=1)
ticket

/var/log/messages for the successful mount:
2013-06-09T10:36:34.621737+02:00 catral cifs.upcall: Exit status
-1765328245
2013-06-09T10:40:06.705799+02:00 catral cifs.upcall: key description:
cifs.spnego;0;0;3f000000;ver=0x2;host=altea;ip4=192.168.1.100;sec=krb5;uid=0x0;creduid=0x0;user=cifsuser;pid=0x587
2013-06-09T10:40:06.710173+02:00 catral cifs.upcall: ver=2
2013-06-09T10:40:06.721488+02:00 catral cifs.upcall: host=altea
2013-06-09T10:40:06.725720+02:00 catral cifs.upcall: ip=192.168.1.100
2013-06-09T10:40:06.733396+02:00 catral cifs.upcall: sec=1
2013-06-09T10:40:06.742668+02:00 catral cifs.upcall: uid=0
2013-06-09T10:40:06.744518+02:00 catral cifs.upcall: creduid=0
2013-06-09T10:40:06.746116+02:00 catral cifs.upcall: user=cifsuser
2013-06-09T10:40:06.747900+02:00 catral cifs.upcall: pid=1415
2013-06-09T10:40:06.749599+02:00 catral cifs.upcall: find_krb5_cc:
scandir error on directory '/run/user/0': No such file or directory
2013-06-09T10:40:06.751559+02:00 catral cifs.upcall: find_krb5_cc:
considering /tmp/krb5cc_0
2013-06-09T10:40:06.755205+02:00 catral cifs.upcall: find_krb5_cc:
FILE:/tmp/krb5cc_0 is valid ccache
2013-06-09T10:40:06.756825+02:00 catral cifs.upcall: handle_krb5_mech:
getting service ticket for altea
2013-06-09T10:40:06.758426+02:00 catral cifs.upcall: handle_krb5_mech:
obtained service ticket
2013-06-09T10:40:06.760770+02:00 catral cifs.upcall: Exit status 0

It seems that cifs.upcall ignores /etc/reqestkey.conf Unless there is a
root cache, nothing gets mounted. I've tested without the patch and
having the key in the defaul keytab instead. The same. 

This is nothing to do with the patch. cifs will not mount unless there
is a root cache available no matter which keytab is used: default keytab
or -d patch keytab.

Stuck.
