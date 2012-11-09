From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cifs-next] fs: cifs: make smb_echo_interval tunable
Date: Fri, 9 Nov 2012 10:55:21 -0500
Message-ID: <20121109105521.00f3c291@tlielax.poochiereds.net>
References: <1352407828-23339-1-git-send-email-chris.j.arges@canonical.com>
	<20121109060017.63811198@tlielax.poochiereds.net>
	<509D23F5.3080107@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <509D23F5.3080107-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 09 Nov 2012 09:40:37 -0600
Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:

> > 
> > I'm not so sure I like making this tunable...
> > 
> Ok, I saw the 'FIXME: tunable?', and thought this was something that
> could be exposed as a parameter in the future.
> 

Yeah, when I originally wrote that code I put that comment in. Since
then I think we've figured out more about how the echo facility in CIFS
should work. Making it tunable is not really a great solution. Having
the echoes better adapt to the situation would be preferable.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
