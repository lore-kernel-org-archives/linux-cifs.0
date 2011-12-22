From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Thu, 22 Dec 2011 07:02:59 -0500
Message-ID: <20111222070259.2c5de94e@tlielax.poochiereds.net>
References: <4ED2FD48.7060108@gmail.com>
	<CADT32e+RMW_oT=g9OMpy29OHQ731Du7_XaT=xOeMyYGWOofAEg@mail.gmail.com>
	<jbit2d$ikm$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <jbit2d$ikm$1@dough.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 05 Dec 2011 16:55:42 +0000
jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On 05/12/11 16:00, Shirish Pargaonkar wrote:
> >>
> >> the following command works from my slackware system:
> >>   mount.cifs //server/share /mnt -o guest
> >
> > Would be interesting to compare the tcpdump/wireshark trace
> > for a successful anonymous login from slackware but failing
> > anonymous login from a xubuntu box.
> >
> 
> ok, I've attached file generated on slackware, only difference to the 
> command above is the mountpoint (/mnt/store).
> 
> the xubuntu one, same tcpdump command-line and mount.cifs invokation, 
> was posted on 2nd Dec.
> 
> >
> > Is there something setup in the stanza of this share on the Samba
> > server that is specific to Xubuntu machine/address?
> >
> 
> not to my knowledge, NAS has never been set-up in this sense, all 
> defaults.  on the two respective clients I use exact same smb.conf's 
> (except hostname) but in any case, mount.cifs ignores smb.conf, 
> according to its man page.

Ok, I had a look at both captures. The main difference (as Shirish
pointed out earlier) is that the server is requesting share mode
security in some cases and user mode in another.

It does this early on, during the NEGOTIATE PROTOCOL phase, so the user
you're authenticating as and the actual tree you're connecting to
probably don't matter here.

What does matter is the info that the client is sending in the
NEGOTIATE PROTOCOL request. There's some key difference here that's
causing the server to behave differently.

The main differences I can see are:

1/ The older client (slackware) doesn't set the NT error codes bit in
   flags2.

2/ The older client sends a smaller list of dialects than the newer one

...and that's really it as far as I can tell. What might be interesting
is a test patch that makes the negprot request from the newer client
look like the older one.

Either way, this is almost certainly a server bug and it's doubtful we
can reasonably fix this from the client side.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
