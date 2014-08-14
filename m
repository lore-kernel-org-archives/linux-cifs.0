From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH][CIFS] Workaround MacOS server problem with SMB2.1 write
 response
Date: Thu, 14 Aug 2014 12:35:19 -0700
Message-ID: <20140814193519.GB325@samba2>
References: <CAH2r5msWAcy41S85b5eN5QBZSqwXDnQU07yHS0gnKE+zaaXw4A@mail.gmail.com>
 <20140814153015.030657f7@tlielax.poochiereds.net>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140814153015.030657f7-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Aug 14, 2014 at 03:30:15PM -0400, Jeff Layton wrote:
> 
> Not directly related to this patch, but...
> 
> What's the story behind the check above? Allowing the server to overrun
> the rfc1001 length by one byte seems dangerous...

I vaguely remember a NetApp bug :-).

> I don't understand the rationale for the arbitrary 15 byte limit. At
> this point, you've already received the data. If there's extra junk at
> the end, do you really care? I'd just ensure that clc_len fits within
> the rfc1001 len and leave it at that.

+1 on this. No arbitrary limits please. If you're going
to ignore data after the valid packet, ignore everything
up to the rfc1001 length please. Only ignoring 15 bytes
doesn't make sense. Why 15 ? Why not 27 ?
