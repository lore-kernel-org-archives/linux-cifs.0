From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Correct max string lengths
Date: Sat, 20 Jul 2013 11:24:21 -0400
Message-ID: <6D61AEAF-9EE2-4F99-BA76-F186A76312E0@gmail.com>
References: <1374269172-4964-1-git-send-email-scott.lovenberg@gmail.com> <CAH2r5msAt8ZuXYdNzufB3BOah7f2ywyi3EgbS14ahESWe1BMRw@mail.gmail.com> <C1A22AEB-8028-4D35-9924-83C9D0DD2D5D@gmail.com> <CAH2r5msVGjeJss9vXd-8H3yn58=8q=njTgWjBrssov_MBT-XLg@mail.gmail.com> <8FB3EB95-C367-4DE7-935C-37C7295F7D53@gmail.com> <20130720064344.42d73b04@tlielax.poochiereds.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org" <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130720064344.42d73b04-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



Sent from my iPod

On Jul 20, 2013, at 6:43, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Fri, 19 Jul 2013 22:44:22 -0400
> Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> On Jul 19, 2013, at 22:34, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> 
>>> Leaving Max share length at 256 is fine with me
>> Works for me. Should this be fixed kernel side?
> 
> Yes, I think that would make sense. Scott, I assume you'll send a v2 of
> this patch that preserves the share length at 256?
> 
> Once that's done, the ideal thing here would be to move these
> definitions in the kernel to a separate header file that lives under
> include/linux. Then we could have autoconf in cifs-utils look for that
> header and use the #defines from that instead if it's present.
> 
> That way we won't be so reliant on keeping the kernel and cifs-utils in
> sync...

Yeah. I'll respin and send tomorrow. I have a wedding to attend this afternoon.  Using autoconf would be terrific and I'm completely on board with that idea. 

> -- 
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
