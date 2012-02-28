From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Tue, 28 Feb 2012 11:43:41 -0500
Message-ID: <20120228114341.1629ed85@tlielax.poochiereds.net>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 27 Feb 2012 18:01:04 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> This is going to be more complicated than it seems.
> 
> Apparently (according to Chris), Windows will often allow mapmpx simultaneous
> requests per process for various handle based requests.   In addition according
> to JRA, Samba server does not care if you go beyond maxmpx (and there is
> a big performance advantage of that).   On the other hand - if the server
> sets maxmpx to less than 10, these kind of changes probably make sense
> (those servers are probably broken otherwise), but for normal servers
> this will end up restricting more than windows (for more than than the
> maxmpx per pid).   Generally, for servers like Samba that support
> simultaneous requests reasonably we have to be careful about killing
> performance especially now that with Jeff's async reads and writes
> we will frequently get up to 50 (and should probably make it easier
> to have more than 50 to servers like Samba).
> 
> Quoting JRA and Volker - "You should be able to queue
> thousands of simultaneous requests from one client to Samba"
> (as long as the client doesn't time out.  The server keeps
> responding to the earlier requests, so with our client timeout
> code weshould be fine).
> 

The problem here though is that we have to code for the lowest common
denominator. While many servers handle exceeding the maxmpx gracefully,
a lot don't. The only safe course here is to respect the MaxMpx by
default since we can't reliably predict what the effect will be if we
exceed it.

That said, if you want to add some sort of knob (mount option?) later
that allows the client to override the server-provided maxmpx, then I'd
be ok with that.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
