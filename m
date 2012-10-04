From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Credits for session setup
Date: Thu, 4 Oct 2012 18:28:51 -0500
Message-ID: <CAH2r5mvS-Kiu9Z13Vj25WPQx=sx60M91DbUYqO7aCvHQaqE9ag@mail.gmail.com>
References: <CAH2r5mu0jFiXwvVZidJ_XTyXK=AvNVKZEby=pjmipi86VJndvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mu0jFiXwvVZidJ_XTyXK=AvNVKZEby=pjmipi86VJndvw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Trace sent to metze offline.

Client requested 3 credits on session setup phase one, but only got
one back (thus disabled plocks and echoes)

On Thu, Oct 4, 2012 at 2:26 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Samba server only grants one credit on SMB2 session setup (ntlmssp
> phase one) - we need to change linux cifs client's "change conf"
> routine to not disable oplocks and echo requests (we only exempt
> negotiate protocol response returning one credit).
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
