From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3
Date: Sat, 02 Sep 2017 17:22:50 +1200
Message-ID: <1504329770.3249.61.camel@samba.org>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info>
         <bf90b119-1e94-131b-d7b6-c35934d8d1bf@leemhuis.info>
         <CA+55aFwUdX3wNYCuWjUTLQGPMCw3peeKeSBfwXb+HuV36OwE+g@mail.gmail.com>
         <59A9A59E.6040205@tlinx.org>
         <CA+55aFzKhz=xLZNin4OR6DzUXiJMJ0EA=r4W9vN7WiaH7fY8UA@mail.gmail.com>
         <CAH2r5muHqSn=nJ42rwt7r6Mp4hvbNaPYJqEoqvqUS+rDFbxLMg@mail.gmail.com>
         <CA+55aFwUHLxBhOh7DxtjSSnKX6KBj+k+p=_CzE8i_xgq-LNj0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "L. A. Walsh" <linux-cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>,
        Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>,
        Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFwUHLxBhOh7DxtjSSnKX6KBj+k+p=_CzE8i_xgq-LNj0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2017-09-01 at 20:56 -0700, Linus Torvalds wrote:
> On Fri, Sep 1, 2017 at 7:16 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 
> > The default was SMB1 (CIFS) and was recently changed to SMB3.
> > The dialect still can be overridden by specifying "vers=1.0" or "vers=2.1"
> > etc. on mount.
> > 
> > We just put together a patch to better explain the default changes
> > (with additional warning messages) as suggested.
> > 
> > SMB3 is significantly better than SMB2.1 (supporting encrypted shares
> > and sessions for example, and requiring support for "secure negotiate")
> > and some servers require SMB3 minimum as a result,
> 
> The default shouldn't be about "best and most secure", but "most
> convenient, while still not actively *IN*secure"
> 
> So "some servers require 3.0" may be true, but if it's also the case
> that "most servers still don't do 3.0 at all", then it's a "some" vs
> "most".
> 
> Which is the most common one? That should be the default.
> 
> I realize that eventually we'll have auto-negotiation, but that's
> clearly not for 4.13. So in the meantime the only issue is what the
> right default should be without auto-negotiation.
> 
> So it should be about what the failure rate is. If trying for smb3 has
> a high failure rate because people simply don't have that yet, then
> making that the default was clearly the wrong choice.
> 
> Because being "better" is immaterial if it doesn't work.

My quick research shows:

SMB 2.1 but not SMB3 is on:
 Windows 7
 Windows 8
 Windows 2008
 Windows 2012
 Samba 3.6 and earlier (SMB1 only by default)

SMB3 is on:
 Windows 8.1
 Windows 2012 R2
 Windows 10
 Windows 2016 
 Samba 4.0 and above (released 2012)

I'm not sure exactly which Mac versions.  

Some breakage will be old (and quite recent) NAS and routers that use
SMB1 and often very old Samba, but most of those only do SMB1. 

In terms of 'actively *IN*secure', it really depends what you mean by
that.  

That is, like all big changes, the movement against SMB1 has had
multiple motivations:
 - a desire no longer to expose really old code in Windows (recently
exploited)
 - a desire to retire an old and complex protocol
 - SMB3 having proper secure negotiation (I'll leave it to Steve to
explain the difference between SMB2 and 3 in that respect, I'm not so
current on the details). 

I hope this help,

Andrew Bartlett

-- 
Andrew Bartlett                       http://samba.org/~abartlet/
Authentication Developer, Samba Team  http://samba.org
Samba Developer, Catalyst IT          http://catalyst.net.nz/services/samba
