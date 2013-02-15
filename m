From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Samba mounting question
Date: Fri, 15 Feb 2013 14:04:18 -0500
Message-ID: <20130215140418.7858fdde@tlielax.poochiereds.net>
References: <1136719061.418.1360952883591.JavaMail.root@hendelman.net>
	<1298625981.428.1360953646140.JavaMail.root@hendelman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298625981.428.1360953646140.JavaMail.root-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

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
