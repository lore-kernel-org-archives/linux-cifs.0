From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Enhancement needed to UNIX extensions to correctly support Linux
 EA's.
Date: Wed, 27 Mar 2013 10:04:42 -0700
Message-ID: <20130327170442.GB18534@samba2>
References: <20130326212242.GA4391@samba2>
 <CAH2r5msU86Q0_PbiqZCf729hDkX9o0e_jYh87d=T8wmQKsYHHg@mail.gmail.com>
 <20130326213301.GA16799@samba2>
 <20130327102957.4dcd9f65@tlielax.poochiereds.net>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130327102957.4dcd9f65-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 27, 2013 at 10:29:57AM -0400, Jeff Layton wrote:
> On Tue, 26 Mar 2013 14:33:01 -0700
> Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
> > On Tue, Mar 26, 2013 at 04:28:36PM -0500, Steve French wrote:
> > > Seems like a reasonable request.   What version of kernel do you want
> > > me to give you some test patches for?
> > 
> > Well first let's work out the wire format, then we
> > can look at implementations.
> > 
> > I'm assuming you'll be re-using the existing
> > EA marshalling/de-marshalling code, so let's
> > decide exactly which Windows info-level we
> > want to base it on.
> > 
> > Jeremy.
> 
> Yeah, sounds reasonable to me too. We currently only use:
> 
>     SMB_INFO_QUERY_ALL_EAS
>     SMB_SET_FILE_EA
> 
> However, the current marshalling/unmarshalling code is a bit of a mess,
> so if it makes sense to depart from how those work then we can do so.

Yeah, but we already have working server-side marshalling/unmarshalling code,
so I'd rather not invent a new mechanism, other than specify that the
EA name be in utf8 rather than DOS charset.

> Note that we ought to add a new unix capability bit for this too.

Yep, and also raise the minor version number.

Jeremy.
