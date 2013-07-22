From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Correct max string lengths
Date: Mon, 22 Jul 2013 11:30:11 -0400
Message-ID: <CAFB9KM37eod2avETEq1KPCcGK5kF7dmikPhdR9MHaDM8KKKXgg@mail.gmail.com>
References: <1374269172-4964-1-git-send-email-scott.lovenberg@gmail.com>
	<CAH2r5msAt8ZuXYdNzufB3BOah7f2ywyi3EgbS14ahESWe1BMRw@mail.gmail.com>
	<C1A22AEB-8028-4D35-9924-83C9D0DD2D5D@gmail.com>
	<CAH2r5msVGjeJss9vXd-8H3yn58=8q=njTgWjBrssov_MBT-XLg@mail.gmail.com>
	<8FB3EB95-C367-4DE7-935C-37C7295F7D53@gmail.com>
	<20130720064344.42d73b04@tlielax.poochiereds.net>
	<6D61AEAF-9EE2-4F99-BA76-F186A76312E0@gmail.com>
	<51EC8D09.1020504@asianux.com>
	<20130722065317.11cd4ffd@corrin.poochiereds.net>
	<CAFB9KM1XE0hw5yFjyL0DP_6MHCYgXqtKPySTgWV1xpX+J9f6Jg@mail.gmail.com>
	<20130722111258.1ac02e22@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130722111258.1ac02e22-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jul 22, 2013 at 11:12 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 22 Jul 2013 11:07:47 -0400
> Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, Jul 22, 2013 at 6:53 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Mon, 22 Jul 2013 09:38:17 +0800
>> > Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org> wrote:
>> >
>> >> On 07/20/2013 11:24 PM, Scott Lovenberg wrote:
>> >> >
>> >> >
>> >> > Sent from my iPod
>> >> >
>> >> > On Jul 20, 2013, at 6:43, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >> >
>> >> >> On Fri, 19 Jul 2013 22:44:22 -0400
>> >> >> Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> >>
>> >> >>> On Jul 19, 2013, at 22:34, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> >>>
>> >> >>>> Leaving Max share length at 256 is fine with me
>> >> >>> Works for me. Should this be fixed kernel side?
>> >> >>
>> >> >> Yes, I think that would make sense. Scott, I assume you'll send a v2 of
>> >> >> this patch that preserves the share length at 256?
>> >> >>
>> >> >> Once that's done, the ideal thing here would be to move these
>> >> >> definitions in the kernel to a separate header file that lives under
>> >> >> include/linux. Then we could have autoconf in cifs-utils look for that
>> >> >> header and use the #defines from that instead if it's present.
>> >> >>
>> >> >> That way we won't be so reliant on keeping the kernel and cifs-utils in
>> >> >> sync...
>> >> >
>> >> > Yeah. I'll respin and send tomorrow. I have a wedding to attend this afternoon.  Using autoconf would be terrific and I'm completely on board with that idea.
>> >> >
>> >>
>> >> Is it better to let the new header file in "include/uapi/linux" ? It
>> >> belongs to the interface between user mode and kernel mode.
>> >>
>> >
>> > That's more of a long-term fix. We'll still need to build cifs-utils
>> > against kernel headers that don't contain that header file, so fixing
>> > the lengths here is needed anyway.
>> >
>> > Once this patch goes in, adding a header in include/uapi/linux that
>> > holds these lengths (and any others that the mount helper and cifs.ko
>> > need to share) would be helpful. Then we could simply look for that
>> > file at autoconf time, and conditionally include it if it exists.
>> >
>> > --
>> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>>
>> Since we're doing that we might as well standardize on the variable
>> names.  Should we just make the mount helper use the same variable
>> names as the kernel to avoid confusion?  That will be an external
>> change (ie, changing a non-static variable) if anyone linked to the
>> mount helper (doubtful, but possible) and it will break their code.
>>
>
> The variable names aren't terribly important, so I wouldn't go making
> any sort of change like that for "cleanup". What matters here is the
> names of the preprocessor constants. Those will need to be unified
> between userland and kernel in order to make such a scheme work.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Sorry, I articulated that terribly.  I was referring to the
preprocessor constants such that we can just wrap our current
definitions in #ifndef/#endif.  We're on the same page.

--
Peace and Blessings,
-Scott.
