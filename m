From: "Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Subject: Re: Samba mounting question
Date: Tue, 19 Feb 2013 13:37:34 -0600 (CST)
Message-ID: <426095708.5327.1361302654087.JavaMail.root@hendelman.net>
References: <381865006.5263.1361300690375.JavaMail.root@hendelman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <381865006.5263.1361300690375.JavaMail.root-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I forgot to check syslog and include the cifs.upcall info here....

====
cifs.upcall: key description: cifs.spnego;0;0;3f000000;ver=0x2;host=cifserver.mydomain.com;ip4=10.1.5.16;sec=krb5;uid=0x0;creduid=0x0;user=SERVERNAME$;pid=0x2c7
cifs.upcall: ver=2
cifs.upcall: host=cifserver.mydomain.com
cifs.upcall: ip=10.1.5.16
cifs.upcall: sec=1
cifs.upcall: uid=0
cifs.upcall: creduid=0
cifs.upcall: user=SERVERNAME$
cifs.upcall: pid=711
cifs.upcall: krb5_get_init_creds_keytab: -1765328347
cifs.upcall: handle_krb5_mech: getting service ticket for cifs/cifserver.mydomain.com
cifs.upcall: cifs_krb5_get_req: unable to resolve (null) to ccache
cifs.upcall: handle_krb5_mech: failed to obtain service ticket (-1765328245)
cifs.upcall: handle_krb5_mech: getting service ticket for host/cifserver.mydomain.com
cifs.upcall: cifs_krb5_get_req: unable to resolve (null) to ccache
cifs.upcall: handle_krb5_mech: failed to obtain service ticket (-1765328245)

My guess is that it's trying to get cifs/host service tickets for the remote CIFS server when the network may not yet be up.

Does that look correct?

Robert

----- Original Message -----
From: "Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Tuesday, February 19, 2013 1:04:50 PM
Subject: Re: Samba mounting question

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
--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
