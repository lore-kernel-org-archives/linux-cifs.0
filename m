From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH][CIFS] Workaround MacOS server problem with SMB2.1 write response
Date: Thu, 14 Aug 2014 15:26:41 -0500
Message-ID: <CAH2r5muwftfpt2kjvf4fM78X6JZ5H-Kt415+Z2AojTDUkPrArA@mail.gmail.com>
References: <CAH2r5msWAcy41S85b5eN5QBZSqwXDnQU07yHS0gnKE+zaaXw4A@mail.gmail.com>
 <20140814153015.030657f7@tlielax.poochiereds.net> <20140814193519.GB325@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140814193519.GB325@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Aug 14, 2014 at 2:35 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, Aug 14, 2014 at 03:30:15PM -0400, Jeff Layton wrote:
>>
>> Not directly related to this patch, but...
>>
>> What's the story behind the check above? Allowing the server to overrun
>> the rfc1001 length by one byte seems dangerous...
>
> I vaguely remember a NetApp bug :-).
>
>> I don't understand the rationale for the arbitrary 15 byte limit. At
>> this point, you've already received the data. If there's extra junk at
>> the end, do you really care? I'd just ensure that clc_len fits within
>> the rfc1001 len and leave it at that.
>
> +1 on this. No arbitrary limits please. If you're going
> to ignore data after the valid packet, ignore everything
> up to the rfc1001 length please. Only ignoring 15 bytes
> doesn't make sense. Why 15 ? Why not 27 ?

Mac is the only one with the length problem for SMB2 (actually SMB2.1), and
is 3 bytes over and only on one frame.  I am ok with doing the safest,
smallest fix (3 bytes) that gets it working.

But I don't like the idea of arbitrary screwed up RFC1001 length,
at worst I would prefer that we stay well within

MAX_SMB2_HDR_SIZE which is 0x78 (or about 0x30 bytes for a minimum
SMB2 response)

and certainly should never allow a RFC1001 length error to cause us to
alloc out of the
large buffer pool (although that would require a huge rounding error).
I also don't
like the idea of unverified data being sent to the client kernel (in
the space between
the end of the SMB3 response and the end of the TCP data).  Don't want
someone creative sticking code there.

I am fine with increasing it to only address the mac bug (ie 3 bytes)
or anything up to
0x30 bytes, but it complicates error checking if the RFC1001 length
can be off by
arbitrary amounts.  Realistically it is hard to imagine rounding
errors more than
sizeof(double) or 8 bytes.

The safest change is to only address the mac server bug (allow 3 bytes off).



-- 
Thanks,

Steve
