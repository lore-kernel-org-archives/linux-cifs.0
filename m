From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Assume passwords are encoded according to iocharset
 (try #2)
Date: Thu, 20 Oct 2011 16:37:16 -0500
Message-ID: <CAH2r5mvBLi3hH2YJvMMiFSA96qW3G8ZSZMUTJv2PnFdoh5NXaQ@mail.gmail.com>
References: <1319134919-4300-1-git-send-email-shirishpargaonkar@gmail.com>
	<20111020151300.5fd507ba@tlielax.poochiereds.net>
	<CAH2r5mt4DgW-EHt+2Fh+U67cqbiUFArKRhx5XFm=ETS8cmXmOw@mail.gmail.com>
	<20111020163006.006fea2e@tlielax.poochiereds.net>
	<20111020205113.GA26966@osk.mine.nu>
	<20111020205554.GA27595@osk.mine.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111020205554.GA27595-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 20, 2011 at 3:55 PM, Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org> wrote:
> On Thursday, October 20, 2011 at 22:13, Oskar Liljeblad wrote:
>> I like the idea of opaque passwords as well, but the problem is that the
>> password needs to be in UCS-2 for smb. The password is passed through
>> _my_mbstowcs which converts the 8-bit password to 16-bit UCS-2 simply
>> by setting high byte to zero. So that makes opaque 8-bit passwords
>> impossible. One alternative would be to assume passwords in UTF-8
>> regardless of iocharset.
>
> On another note, it wouldn't surprise me if Microsoft assumes UTF-16 rather
> than UCS-2 in their CIFS implementation today...

We can ask them if we have some more specific data to question them on
(including traces).  We could probably turn off password encryption to
try this.


-- 
Thanks,

Steve
