From: Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org>
Subject: Re: CIFS mounts become inaccessible with "Send error in SessSetup = -128"
Date: Fri, 12 Jul 2013 16:50:16 -0700
Message-ID: <2770E589-143D-4DEE-A55E-808A5A12AC5F@dashbox.com>
References: <6FF853BB-C6F5-41E4-8310-04BE652F4633@dashbox.com> <1373664982.4186.5.camel@hh16.hh3.site>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373664982.4186.5.camel-HkULYb+WTT7YCGPCin2YbQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

Thanks for the help.  So here's where I'm at now:

- I already had hostname$ in my keytab and both cifs.spnego and dns_resolver in my /etc/request-key.d
- I tried stopping k5start but if I kdestroy and then try to connect it fails so it seems for my setup I do need to have the tgt active to connect
- Before I had cruid=0 so I changed that to username=hostname$ and I will see if it works when the job runs tonight

There was one other odd thing I noticed.  There is a strange looking service principal when I klist after connecting to the share.  Its a dfs share so after connecting I have the following service principals active:

cifs/dfs-server.domain.com@
cifs/dfs-server.domain.-Cx6ELD3zwl1XrIkS9f7CXA@public.gmane.org
cifs/cifs-server.domain.@
cifs/cifs-server.domain.-Cx6ELD3zwl1XrIkS9f7CXA@public.gmane.org

Should I be getting those principals with the blank realm?

It does work now if I access the share, but just not when the cron jobs run which is strange.

Regards,
Doug


On Jul 12, 2013, at 2:36 PM, steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:

> On Fri, 2013-07-12 at 13:38 -0700, Doug Clow wrote:
>> Hello,
>> 
>> I am having some trouble with using krb5, autofs, and cifs together.  I have my credentials set to auto-renew using k5start and when I ssh to the machine I can mount the share after restarting autofs.  The principal used is the computer from Active Directory ie "hostname$".  I've verifed my tgt is always fresh.  However, my scheduled cron job to do rsync to that share always fails.  Often with the error "Key has been revoked".  In my syslog there is the message "CIFS VFS: cifs_mount failed w/return code = -128".  After doing some Googling, I found this link:
>> 
>> https://access.redhat.com/site/solutions/275933
>> 
>> I'm on CentOS (6.4) so I don't have access to the posting.  If you have an idea for a fix I would very much appreciate it.
>> 
>> Thanks,
>> Doug
> 
> Hi
> You don't need to cron your tgt requests. cifs.upcall will look for the
> key as and when it needs it:
> -Put hostname$ in /etc/krb5.keytab
> -kill k5start
> -make sure you have username=hostname$ as a cifs option in the autofs
> map file
> -make sure you have the line in /etc/reqest-key.conf:
> create  cifs.spnego     *       *               /usr/sbin/cifs.upcall  %
> k
> 
> hth,
> Steve
> 
> 
