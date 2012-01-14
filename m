From: Mirko Scholz <mscholz5-2/1ofaGcC4w@public.gmane.org>
Subject: Re: file truncation on newer linux-cifs versions
Date: Sat, 14 Jan 2012 14:50:58 +0100
Message-ID: <20120114135057.GA4197@gwdu05.gwdg.de>
References: <20120113230701.GA3100@gwdu05.gwdg.de> <CAOhYWN+dLLKXs6MU3W88oHzyFgi1KV+7oh1qPh61ZEqUA-Jw8w@mail.gmail.com>
Reply-To: mscholz5-2/1ofaGcC4w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOhYWN+dLLKXs6MU3W88oHzyFgi1KV+7oh1qPh61ZEqUA-Jw8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


> Does the problem go away if you mount with wsize=65535? If so, I guess we
> can add bluearc to the list of servers that can't handle writes larger than
> windows sends.
yes it does.  Thanks for pointing it out, as it is clearly mentioned
in mount.cifs(8).  But it says, that this size is negotiated...?

> Steve is right though that a capture would be helpful to confirm what's
> happening.

You'll find it at http://www.gwdg.de/~mscholz5/cifs-problem/v3.1.0-1

Thank you both for the quick reply.  I noticed this problem a while ago,
but hasitated to report it, since cifs is not officially supported
at my site.

Steve, do you still need the bug-report?

Mirko
