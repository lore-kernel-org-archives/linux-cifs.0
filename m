From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Enhancement needed to UNIX extensions to correctly support
 Linux EA's.
Date: Wed, 27 Mar 2013 10:29:57 -0400
Message-ID: <20130327102957.4dcd9f65@tlielax.poochiereds.net>
References: <20130326212242.GA4391@samba2>
	<CAH2r5msU86Q0_PbiqZCf729hDkX9o0e_jYh87d=T8wmQKsYHHg@mail.gmail.com>
	<20130326213301.GA16799@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130326213301.GA16799@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 26 Mar 2013 14:33:01 -0700
Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Tue, Mar 26, 2013 at 04:28:36PM -0500, Steve French wrote:
> > Seems like a reasonable request.   What version of kernel do you want
> > me to give you some test patches for?
> 
> Well first let's work out the wire format, then we
> can look at implementations.
> 
> I'm assuming you'll be re-using the existing
> EA marshalling/de-marshalling code, so let's
> decide exactly which Windows info-level we
> want to base it on.
> 
> Jeremy.

Yeah, sounds reasonable to me too. We currently only use:

    SMB_INFO_QUERY_ALL_EAS
    SMB_SET_FILE_EA

However, the current marshalling/unmarshalling code is a bit of a mess,
so if it makes sense to depart from how those work then we can do so.

Note that we ought to add a new unix capability bit for this too.
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
