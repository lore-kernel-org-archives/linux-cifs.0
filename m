From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH][CIFS] Workaround MacOS server problem with SMB2.1 write response
Date: Thu, 14 Aug 2014 16:15:21 -0500
Message-ID: <CAH2r5mtE5efZKnroxXerfWLEgGdx-6Wry4788HiPKUaa+bhhLg@mail.gmail.com>
References: <CAH2r5msWAcy41S85b5eN5QBZSqwXDnQU07yHS0gnKE+zaaXw4A@mail.gmail.com>
 <20140814153015.030657f7@tlielax.poochiereds.net> <20140814193519.GB325@samba2>
 <CAH2r5muwftfpt2kjvf4fM78X6JZ5H-Kt415+Z2AojTDUkPrArA@mail.gmail.com>
 <20140814164014.36023859@tlielax.poochiereds.net> <20140814204424.GE325@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140814204424.GE325@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Aug 14, 2014 at 3:44 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, Aug 14, 2014 at 04:40:14PM -0400, Jeff Layton wrote:
>>
>> Failing here won't change the buffer allocation. That buffer has
>> already been allocated, and the receive is complete at this point. So
>> any "damage" has already been done.
>
> Yep. You've got to have read the data to know it's too much !
>
>> So, I just don't get why you'd bother with an arbitrary limit at all.
>> The error checking is _simpler_ if you don't bother with this limit. Or
>> am I missing something here?
>
> Nope. The server has to deal with the same problem
> as well. We just accept what the client sends inside
> the NetBIOS length limit, and ignore anything after
> the "useful" data within the packet.
>
> Doesn't matter *what* is in the extra bits, code
> data, whatever. We don't look at it.
>
> Steve, what is the problem with just ignoring the
> extra data ? If it offends you - log a warning
> message is the rfc1001 length is too long and
> ignore it.

It does bug me that the server would send
arbitrary amount of junk since it can slow
down the client.

I looked at the printk ratelimit stuff but
it looked like it was not worth the trouble
to avoid the log floods.

Perhaps just log if the length is off by
more than 3? So if some server is
off by more than the Mac write response
we can tell them.  Is it even worth the
trouble to ratelimit the log message if
we don't know of any server's that are off
by that much.


-- 
Thanks,

Steve
