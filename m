From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: Pavel's Lock cleanup
Date: Fri, 14 Oct 2011 17:12:14 -0400
Message-ID: <20111014211214.GA15319@fieldses.org>
References: <CAH2r5mtNGd-+YUXJwU2USPN_7XnQYdSaYh_HJrzyaM3g6o9szw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtNGd-+YUXJwU2USPN_7XnQYdSaYh_HJrzyaM3g6o9szw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 13, 2011 at 05:23:52PM -0500, Steve French wrote:
> I like Pavel's lock cleanup (1st patch of series) so far, am
> continuing to review it, but I also noticed a few things that we need
> to do in the future. This line of code:
> 
> 	if (flock->fl_flags & FL_LEASE)
> 		cFYI(1, "Lease on file - not implemented yet");
> 
> reminded me that we should check if we need to implement this (in cifs
> we can return yes if we have a lease already (oplock), but in smb2.1
> and later we can request a lease or an upgrade to an existing one, on
> the fly).

And you'll also need to make sure you call break_lease() when you find
out it's broken.

A description of the smb (1/2/2.1) oplock and lease semantics would be
useful--I'm curious whether they're really a good fit for the linux
vfs's lease semantics.

--b.
