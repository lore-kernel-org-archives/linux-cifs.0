From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Pavel's Lock cleanup
Date: Thu, 13 Oct 2011 17:23:52 -0500
Message-ID: <CAH2r5mtNGd-+YUXJwU2USPN_7XnQYdSaYh_HJrzyaM3g6o9szw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I like Pavel's lock cleanup (1st patch of series) so far, am
continuing to review it, but I also noticed a few things that we need
to do in the future. This line of code:

	if (flock->fl_flags & FL_LEASE)
		cFYI(1, "Lease on file - not implemented yet");

reminded me that we should check if we need to implement this (in cifs
we can return yes if we have a lease already (oplock), but in smb2.1
and later we can request a lease or an upgrade to an existing one, on
the fly).

-- 
Thanks,

Steve
