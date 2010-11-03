From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 2/2] cifs: dereferencing first then checking
Date: Wed, 3 Nov 2010 18:40:59 +0200
Message-ID: <20101103164059.GH14069@bicker>
References: <20101027212253.GL6062@bicker> <20101027195123.0a712a53@tlielax.poochiereds.net> <20101028034434.GR6062@bicker> <20101102162250.3a2aa670@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101102162250.3a2aa670-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 02, 2010 at 04:22:50PM -0400, Jeff Layton wrote:
> Here's a respun patch that should fix these problems. I chickened out
> on removing the check in find_writable_file.
> 
> It still seems like a bogus cargo-cult sort of thing. It should
> probably be a BUG() if you call that function with a NULL pointer, but
> I don't feel like tackling that just yet.
> 
> Dan, does this look ok to you? If so, I'll resend to Steve as an
> "official" patch.
> 

Looks fine to me.  Obviously, I've already said that I don't know if the
checks are needed or not.  I defer to your greater knowledge.  ;)

regards,
dan carpenter
