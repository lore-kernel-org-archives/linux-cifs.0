From: Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org>
Subject: Re: CIFS mounts become inaccessible with "Send error in SessSetup = -128"
Date: Mon, 15 Jul 2013 12:38:18 -0700
Message-ID: <02C4F669-1C20-4F61-999C-5CF9CE63D3CC@dashbox.com>
References: <6FF853BB-C6F5-41E4-8310-04BE652F4633@dashbox.com> <1373664982.4186.5.camel@hh16.hh3.site> <2770E589-143D-4DEE-A55E-808A5A12AC5F@dashbox.com> <1373701517.1791.27.camel@hh16.hh3.site>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373701517.1791.27.camel-HkULYb+WTT7YCGPCin2YbQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

After doing some experimentation I found a workaround, but I still don't understand the underlying problem.  I put in a cron job that touches a file on the share every minute and now my other cron jobs run correctly.  I have to touch the file periodically or else the share will "go bad" until I restart autofs.


On Jul 13, 2013, at 12:45 AM, steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:

> On Fri, 2013-07-12 at 16:50 -0700, Doug Clow wrote:
>> Hi Steve,
>> 
>> Thanks for the help.  So here's where I'm at now:
>> 
>> - I already had hostname$ in my keytab and both cifs.spnego and dns_resolver in my /etc/request-key.d
>> - I tried stopping k5start but if I kdestroy and then try to connect it fails so it seems for my setup I do need to have the tgt active to connect
>> - Before I had cruid=0 so I changed that to username=hostname$ and I will see if it works when the job runs tonight
>> 
> I think the user running the cron will need tickets too. Maybe give
> hostname$ a posixAccount and uidNumber, and add him to group root? (or
> whoever runs the cron)
> 
> To mount the cifs share _you_ don't need a ticket. To access it, yes.
> e.g. if you logged in and tried to access the share but it wasn't
> mounted, it would mount using hostname$, then you would get your cifs
> ticket. I'm not sure what you mean when you say 'try to connect'. There
> seem to be 2 issues, accessing via ssh and the automounter.
> Cheers
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
