From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Enhancement needed to UNIX extensions to correctly support Linux
 EA's.
Date: Tue, 26 Mar 2013 14:33:01 -0700
Message-ID: <20130326213301.GA16799@samba2>
References: <20130326212242.GA4391@samba2>
 <CAH2r5msU86Q0_PbiqZCf729hDkX9o0e_jYh87d=T8wmQKsYHHg@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msU86Q0_PbiqZCf729hDkX9o0e_jYh87d=T8wmQKsYHHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 26, 2013 at 04:28:36PM -0500, Steve French wrote:
> Seems like a reasonable request.   What version of kernel do you want
> me to give you some test patches for?

Well first let's work out the wire format, then we
can look at implementations.

I'm assuming you'll be re-using the existing
EA marshalling/de-marshalling code, so let's
decide exactly which Windows info-level we
want to base it on.

Jeremy.
