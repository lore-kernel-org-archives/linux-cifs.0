From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Samba POSIX ACL behavior
Date: Thu, 14 Nov 2013 11:14:24 -0800
Message-ID: <20131114191424.GD15531@samba2>
References: <CAH2r5msH8qTago4G=-_PpAzPJaOxwPeRVL3E8qfowjqwiSo5LA@mail.gmail.com>
 <20131114181858.GC1661@samba2>
 <CAH2r5mujAzBP0N5V9qdwygWXDyeRzkkdY9SNOxZmc-CFyEVSBg@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mujAzBP0N5V9qdwygWXDyeRzkkdY9SNOxZmc-CFyEVSBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 14, 2013 at 12:32:43PM -0600, Steve French wrote:
> On Thu, Nov 14, 2013 at 12:18 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > On Thu, Nov 14, 2013 at 12:13:35PM -0600, Steve French wrote:
> >> > I recently encountered the following strange behavior as mentioned in
> >> > this post from several years ago:
> >> >
> >> > https://lists.samba.org/archive/linux-cifs-client/2009-February/004079.html
> >> >
> >> > I'm currently running Ubuntu 12.04 LTS on desktop and server, so
> >> > I took some time to try the latest packaged versions of Samba and
> >> > the kernel to make sure that the issue had not yet been fixed.
> >> >
> >> > Client:  Ubuntu 12.04 LTS with Kernel 3.11.0-13-generic
> >> > Server:  Ubuntu 12.04 LTS with Samba 3.6.20 and Kernel 3.5.0-43-generic
> >> >
> >> > I tried many other combinations and the behavior is the same.  It
> >> > looks like setting default ACLs somehow interacts with the
> >> > non-default ACLs and vice versa.
> >>
> >> I tried this here to Samba 3.6 with slightly different results:
> >> 1) If I set both a default and non-default ACL that seems to work
> >> 2) but as you and Rob saw, if I setfacl a default ACL it removes the non-
> >> default ACL
> >> 3) and if I setfacl a non-default ACL it removes the default ACL
> >>
> >> So for case 2 and 3 the behavior is different than for a local file system.
> >> This may be a server bug.
> >
> > Can you send me a wireshark trace ?
> >
> >> For Samba 4 and Samba 4.2-pre (master) - I get an error not supported on this
> >> infolevel 512 (Set POSIX ACL).
> >
> > You're running the wrong server :-). You need smbd running, not the source4
> > server.
> 
> steven@steven-GA-970A-DS3:/etc$ ps -A | grep "mbd"
>  2321 ?        00:00:00 smbd
> 19715 ?        00:00:00 smbd
> 19721 ?        00:00:00 smbd
> 
> This is smbd
> Version 4.2.0pre1-GIT-72b240f

Then I definitely need the wireshark trace. I have never seen error
not supported from smbd.
