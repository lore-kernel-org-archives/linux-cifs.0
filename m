From: "Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Subject: Re: Samba mounting question
Date: Tue, 19 Feb 2013 13:04:50 -0600 (CST)
Message-ID: <381865006.5263.1361300690375.JavaMail.root@hendelman.net>
References: <20130215140418.7858fdde@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130215140418.7858fdde-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I've tried this but with only partial success.  "mount /data" works (see definition of /data below), but not at startup.

I'm not sure exactly why it's failing at system startup, but if I ssh into my machine as root using ssh keys (no kerberos tickets) and then do "mount /mountpoint" it works as expected.  root user is granted the default prinicpal: SERVERNAME$@DOMAIN.COM (confirmed with klist).  I get a krbtgt ticket & cifs ticket.

Since it works when I try it as root AFTER system startup but not at statup, I'm guessing this is an Ubuntu issue of some sort (Ubuntu server 12.04).  I know at startup I get

CIFS VFS: Send error in SessSetup = -126
CIFS VFS: cifs_mount failed w/return code = -126

My fstab mount line looks as follows:

//CIFSERVER.MYDOMAIN.COM/data /data cifs nobootwait,strictcache,sec=krb5,multiuser,acl,username=SERVER$

I'm half-wondering if I need to escape the $ sign in "SERVER$" somehow (I've tried with single quotes, $$ and \$ without success).

With that being said, is this still something that is valid for discussion on linux-cifs or should I move it to an ubuntu specific list?  I have not yet tried with any other distributions yet.

Thanks,

Robert

----- Original Message -----
From: "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: "Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Friday, February 15, 2013 1:04:18 PM
Subject: Re: Samba mounting question

On Fri, 15 Feb 2013 12:40:46 -0600 (CST)
"Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org> wrote:

> Hi,
> 
> I've been working on getting this working for almost 4 days straight now, and am wondering if you can tell me what I'm missing:
> 
> I've got two samba4 (4.0.3) servers with cifs-utils 5.9 up & working.   I can mount with sec=krb5,multiuser & it works as expected (as long as I have already done kinit user@domain).
> 
> I can even kinit -kt /etc/krb5.keytab SERVER$@MYDOMAIN.COM (although kinit -kt /etc/krb5.keytab fails).
> 
> However, I can't figure out the proper way to setup the share in fstab so the system boots & uses the keytab to mount the share (System is ubuntu 12.04, although I'm using self compiled samba/cifs-tools packages)
> 
> What I'm hoping not to do is writing or modifying anything outside of fstab/config file to do this, as I'm hoping there is a "correct" way to do this.
> 
> Do I need to add a line to /etc/request-key.conf to call cifs.upcall with different parameters to get the mount in /etc/fstab working?
> 
> Is there another way?  
> 
> I'm sure I'm missing something obvious.
> 
> Thank you for any help you can provide.
> 
> Best regards,
> 
> Robert

I don't generally do 1:1 support, unless you're paying me ;). In the
future, these kinds of questions should go to
linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (cc'ed here)...

In any case, cifs.upcall doesn't know about machine credentials. When
it goes to get a tgt using a keytab, it generally does so using a
principal name of the user performing the mount (probably
root-7RAbkED+uC1Wk0Htik3J/w@public.gmane.org).

You might be able to work around that by passing in 'username=SERVER$'
on the mount options, but I haven't tested that so I'm not sure. Note
too that cifs.upcall will log to daemon.debug facility in syslog, so
you might be able to get some extra info about what's going wrong from
that.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
