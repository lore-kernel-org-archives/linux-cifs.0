From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: New read logic
Date: Mon, 1 Nov 2010 14:00:19 -0400
Message-ID: <20101101140019.166be768@tlielax.poochiereds.net>
References: <AANLkTimbGk9zKbVBU+Fd-d4XwQdFyEJFzcxi84dVEjQx@mail.gmail.com>
	<20101101131930.18d35c34@tlielax.poochiereds.net>
	<AANLkTinyh5zxKsyZetpN4WwiDMWQ-Y9E-1uu9_dzDQTY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinyh5zxKsyZetpN4WwiDMWQ-Y9E-1uu9_dzDQTY-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 1 Nov 2010 12:41:31 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> My reaction is that over modern networks 1 second attribute timeout is
> probably ok and 60 seconds is too slow (certainly slowing it down
> beyond 5 seconds could be noticeable to user, not just create a higher
> data integrity risk) - but the obvious exception is over slow
> networks.   Since we can get the SMB echo times - we could base the
> value of actimeout 1 second vs 60 second based on what we estimate
> round trip delay is.
> 

I don't see any connection between the ac timeout and round trip time.
The ac timeout needs to be set according to how often you expect files
to change, and that has no real relation to the RTT between client and
server.

I think all we can reasonably do is try to set a sane default and let
people override it when they need to do so. 60s may well be too long,
but 1s is way, way too short and has significant performance impact
even without Pavel's changes.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
