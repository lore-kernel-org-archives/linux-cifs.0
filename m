From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: cifs client lease logic
Date: Fri, 8 Jul 2011 17:45:41 -0400
Message-ID: <20110708214541.GF13886@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I was just looking at the cifs client lease code, and I think there's a
problem:

Leases can be broken at any time, but all that does is notify the
lease-holder.  They shouldn't be removed until the lease holder gets a
chance to do whatever cleanup they need to do and issues an F_UNLCK.
(Or until a tiemout expires and we give up on the lease holder.)

(NFSv4 delegations and oplocks work the same way, as I understand it, in
the sense that delegations and oplocks have to be explicitly given up by
whoever holds them (or until there's a timeout).)

But it looks like F_UNLCK is a no-op for the cifs client.  Without
understanding the code at all, it looks to me like cifs is doing
whatever it normally does on losing an oplock--flushing out dirty pages,
etc.--and is sending a lease break notification, but isn't waiting on
the application that holds the lease to give the lease up.

Note that calling break_lease on its own doesn't wait for that, it
*only* notifies the lease holder of the break.

Am I missing something?

--b.
