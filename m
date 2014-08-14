From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH][CIFS] Workaround MacOS server problem with SMB2.1 write
 response
Date: Thu, 14 Aug 2014 14:21:50 -0700
Message-ID: <20140814212150.GF325@samba2>
References: <CAH2r5msWAcy41S85b5eN5QBZSqwXDnQU07yHS0gnKE+zaaXw4A@mail.gmail.com>
 <20140814153015.030657f7@tlielax.poochiereds.net>
 <20140814193519.GB325@samba2>
 <CAH2r5muwftfpt2kjvf4fM78X6JZ5H-Kt415+Z2AojTDUkPrArA@mail.gmail.com>
 <20140814164014.36023859@tlielax.poochiereds.net>
 <20140814204424.GE325@samba2>
 <CAH2r5mtE5efZKnroxXerfWLEgGdx-6Wry4788HiPKUaa+bhhLg@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtE5efZKnroxXerfWLEgGdx-6Wry4788HiPKUaa+bhhLg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Aug 14, 2014 at 04:15:21PM -0500, Steve French wrote:
> 
> It does bug me that the server would send
> arbitrary amount of junk since it can slow
> down the client.

Well yes, it's definitely a server problem,
but there's nothing you can do about it unless
you decide you won't talk to servers that do
that :-).

> I looked at the printk ratelimit stuff but
> it looked like it was not worth the trouble
> to avoid the log floods.
> 
> Perhaps just log if the length is off by
> more than 3? So if some server is
> off by more than the Mac write response
> we can tell them.  Is it even worth the
> trouble to ratelimit the log message if
> we don't know of any server's that are off
> by that much.

More than 3 sounds good to me :-).
