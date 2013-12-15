From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: permission denied on cifs mount
Date: Sun, 15 Dec 2013 16:45:10 +0100
Message-ID: <1387122310.1886.11.camel@hh16.hh3.site>
References: <alpine.DEB.2.10.1312151029090.26597@pfr2.frenkiel-hure.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pierre Frenkiel <pierre.frenkiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1312151029090.26597-WIAL7NQ5FApO3Cpw244kghj55NUB2MVm@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 2013-12-15 at 10:33 +0100, Pierre Frenkiel wrote:
> hi everybody
> I try to mount an external disk which has a wifi network interface, and
> behaves as a cifs server: it fails on my desktop, and works on 2 other
> computers. All are running Debian/Wheezy
> 
> On 2 laptops, the following command works fine:
> 
>    ->mount -t cifs -o guest //wehd/hdd /d6
> 
> On my desktop,  where it used to work until last month , I get now:
> 
>      mount error(13): Permission denied
>      Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> 
> I'm unable to explain this difference of behaviours.
> Can anybody help me?
> 
> best regards,
> 
> PS: I also did the same post to the cifs-protocol list. I don't know
>      which list is best suited for this problem...

Hi
The answer is in /var/log/syslog just before the error message.

Are you allowed access to the log?
HTH
Steve
