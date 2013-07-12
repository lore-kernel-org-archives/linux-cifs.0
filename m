From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: CIFS mounts become inaccessible with "Send error in SessSetup =
 -128"
Date: Fri, 12 Jul 2013 23:36:22 +0200
Message-ID: <1373664982.4186.5.camel@hh16.hh3.site>
References: <6FF853BB-C6F5-41E4-8310-04BE652F4633@dashbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6FF853BB-C6F5-41E4-8310-04BE652F4633-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2013-07-12 at 13:38 -0700, Doug Clow wrote:
> Hello,
> 
> I am having some trouble with using krb5, autofs, and cifs together.  I have my credentials set to auto-renew using k5start and when I ssh to the machine I can mount the share after restarting autofs.  The principal used is the computer from Active Directory ie "hostname$".  I've verifed my tgt is always fresh.  However, my scheduled cron job to do rsync to that share always fails.  Often with the error "Key has been revoked".  In my syslog there is the message "CIFS VFS: cifs_mount failed w/return code = -128".  After doing some Googling, I found this link:
> 
> https://access.redhat.com/site/solutions/275933
> 
> I'm on CentOS (6.4) so I don't have access to the posting.  If you have an idea for a fix I would very much appreciate it.
> 
> Thanks,
> Doug

Hi
You don't need to cron your tgt requests. cifs.upcall will look for the
key as and when it needs it:
-Put hostname$ in /etc/krb5.keytab
-kill k5start
-make sure you have username=hostname$ as a cifs option in the autofs
map file
-make sure you have the line in /etc/reqest-key.conf:
create  cifs.spnego     *       *               /usr/sbin/cifs.upcall  %
k

hth,
Steve
