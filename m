From: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS
Date: Mon, 15 Aug 2011 15:31:01 -0400
Message-ID: <20110815193101.GA7295@redhat.com>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
 <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
 <20110815064734.403b630f@corrin.poochiereds.net>
 <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
 <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1108151357200.32349-0qmrozcXWo8bm2hyYBkBBg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 15, 2011 at 02:01:12PM -0400, Justin Piszcz wrote:
 > It crashed again with the patches, this time I got a picture:
 > http://home.comcast.net/~jpiszcz/20110815/26030-kernel-crash-when-cifs-mount.jpg
 > 
 > The machine is up no issues until you try and mount a CIFS share, then
 > the problem occurs, every time (and with the patches as well).

This looks like you oopsed in cache_alloc_refill, and then after that
the watchdog kicked in, and spewed traces, scrolling the backtrace for
the actual oops off the screen.

Might be worth trying to reproduce it with CONFIG_LOCKUP_DETECTOR disabled.

We frequently see this sort of thing reported in Fedora. It would be
nice if we had a means of either reading scrollback when we lockup,
or buffering the output so we pause between dumping traces.

	Dave
