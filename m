From: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Assume passwords are encoded according to
 iocharset (try #2)
Date: Thu, 20 Oct 2011 21:41:24 -0400
Message-ID: <1319161284.3105.1250.camel@pico.li.ssimo.org>
References: <1319134919-4300-1-git-send-email-shirishpargaonkar@gmail.com>
	 <20111020151300.5fd507ba@tlielax.poochiereds.net>
	 <CAH2r5mt4DgW-EHt+2Fh+U67cqbiUFArKRhx5XFm=ETS8cmXmOw@mail.gmail.com>
	 <20111020163006.006fea2e@tlielax.poochiereds.net>
	 <20111020205113.GA26966@osk.mine.nu> <20111020205554.GA27595@osk.mine.nu>
	 <CADT32e+1A_xcCQzd86OX1v6G1vG5QHG0AYjXurS8S1=BMMxreQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+1A_xcCQzd86OX1v6G1vG5QHG0AYjXurS8S1=BMMxreQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2011-10-20 at 16:01 -0500, Shirish Pargaonkar wrote: 
> On Thu, Oct 20, 2011 at 3:55 PM, Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org> wrote:
> > On Thursday, October 20, 2011 at 22:13, Oskar Liljeblad wrote:
> >> I like the idea of opaque passwords as well, but the problem is that the
> >> password needs to be in UCS-2 for smb. The password is passed through
> >> _my_mbstowcs which converts the 8-bit password to 16-bit UCS-2 simply
> >> by setting high byte to zero. So that makes opaque 8-bit passwords
> >> impossible. One alternative would be to assume passwords in UTF-8
> >> regardless of iocharset.
> >
> > On another note, it wouldn't surprise me if Microsoft assumes UTF-16 rather
> > than UCS-2 in their CIFS implementation today...
> >
> > Oskar
> >
> >
> 
> codepage to unicode conversion does not come into picture during
> authentication.  codepage to unicode conversion comes into picture
> once you are sending ntlm response blob over.
> I do not know if ntlm response on machines with different charsets
> can have that charset specific characters e.g. whether ntlm
> response blob on a machine with German character set can
> have an umlaut as part of ntlm response.

Passwords are UTF-16, I do not think it makes any sense in 2011 to
support anything else but UTF-8 to be honest.
If you are using codepages on the filesystem for some legacy reason that
should still not change the fact the kernel should get a password in
UTF-8. If your charset does not allow you to type the correct charcter
for your password you are screwed anyways it doesn't matter if before or
after the conversion to URF-16

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Principal Software Engineer at Red Hat, Inc. <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
