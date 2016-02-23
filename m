From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Interop Issue: SMB2+ async replies, and the kernel, Samba side
 fix enclosed.
Date: Tue, 23 Feb 2016 08:54:12 -0800
Message-ID: <20160223165412.GD39067@jra3>
References: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfrench <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Ira Cooper <ira-mA6sH8tAw6XR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Feb 23, 2016 at 07:55:59AM -0500, Ira Cooper wrote:
> If the server sends an interim response, then the real response, the real
> response, is handled by standard_receive3() in the kernel, instead of the
> proper function, and this causes a disconnect.  If there isn't a
> disconnect, I believe the reply will just be discarded if I understand the
> code correctly.  (That is a big if here ;) )
> 
> I've written a patch for Samba to stop sending interim replies on SMB2_READ
> and SMB2_WRITE, when non-compounded to stop the impact of this issue.  We
> may want to add SMB2_CREATE to the list of ops we don't send async replies
> for non-compounded, but I'm not sold either way, I know we CAN go async
> there!  I want some opinions here.
> 
> This is not hidden behind a flag because compatibility issues that don't
> impact protocol correctness usually aren't.
> 
> Setting req->async_te = talloc_new(NULL); is just ugly, though it works.
> If you have a cleaner approach, I welcome it.
> 
> I request you please ASK me before pushing this one, yes, that means you
> jra!

Actually I wasn't planning on pushing at all :-).

I don't think we should stop sending interim replies on SMB2_READ
or SMB2_WRITE, those replies have effects on the client timers
on properly functioning clients.

Linux client needs fixing here I'm afraid (and I know that's
not fun, sorry :-( ).

Jeremy.
