From: Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org>
Subject: Re: CIFS mounts become inaccessible with "Send error in SessSetup = -128"
Date: Mon, 15 Jul 2013 13:35:52 -0700
Message-ID: <AEDA51D7-8442-478A-8905-97EA52A8DB5E@dashbox.com>
References: <6FF853BB-C6F5-41E4-8310-04BE652F4633@dashbox.com> <1373664982.4186.5.camel@hh16.hh3.site> <2770E589-143D-4DEE-A55E-808A5A12AC5F@dashbox.com> <1373701517.1791.27.camel@hh16.hh3.site> <02C4F669-1C20-4F61-999C-5CF9CE63D3CC@dashbox.com> <1373919660.1668.13.camel@hh16.hh3.site>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373919660.1668.13.camel-HkULYb+WTT7YCGPCin2YbQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

I guess my system is not behaving as it is supposed to.  Here is what I have in /etc/request-key.d/cifs.spnego.conf

create  cifs.spnego    * * /usr/sbin/cifs.upcall %k

However, I definitely must kinit -k and get a tgt in order to connect.  It doesn't seem to work automatically as you described.  That's not a problem, I can just kinit automatically.  But the problem I'm having is that without periodically accessing the share, CIFS stops being able to access the share and I get "Key has been revoked" and "CIFS VFS: cifs_mount failed w/return code = -128".  

So maybe the issue is related to what you say, CIFS is not doing the kinit/getting the service principal on its own except right when autofs is started.  It doesn't seem to renew its service principals.

Thanks,
Doug



On Jul 15, 2013, at 1:21 PM, steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:

> On Mon, 2013-07-15 at 12:38 -0700, Doug Clow wrote:
>> After doing some experimentation I found a workaround, but I still don't understand the underlying problem.  I put in a cron job that touches a file on the share every minute and now my other cron jobs run correctly.  I have to touch the file periodically or else the share will "go bad" until I restart autofs.
>> 
> Hi
> cifs.upcall should take care of that without the cron. If you have
> sec=krb5 it will automatically look for the key of the user specified
> for the mount in the keytab so that even if the ticket has expired 'gone
> bad', it refreshes it for you when you need to access the mounted share.
> 
> I too thought that I had to keep a root cache alive for cifs until I had
> a long conversation about this on the cifs list. I even suggested they
> add a switch to cifs.upcall to specify a keytab other
> than /etc/krb5.keytab. It's the -d option to cifs.upcall included as of
> cifs-utils 6.1
> 
> Maybe I've not understood your problem but it certainly is not necessary
> to use cron to keep tickets alive for cifs as you are doing at present.
> Do let me have any details which you don't understand as it really has
> made our domain a lot easier to maintain.
> Cheers,
> Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
