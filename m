From: Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: [Samba] cifs and Netapp DFS-shares problems
Date: Fri, 10 Dec 2010 12:52:59 +0100
Message-ID: <E1PR1i2-002xBc-Uw@intern.SerNet.DE>
References: <1291855039.11237.49.camel@kramer>
 <1291976746.8971.24.camel@kramer>
 <20101210063449.5ab06c5f@tlielax.poochiereds.net>
Reply-To: Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lists-dLPT46B32WUjnolme5KbmQ@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date: Fri, 10 Dec 2010 12:52:59 +0100
Content-Disposition: inline
In-Reply-To: <20101210063449.5ab06c5f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Dec 10, 2010 at 06:34:49AM -0500, Jeff Layton wrote:
> You're welcome to open a bug at bugzilla.samba.org, cc me, and I'll
> take a look when I have time. Gathering wire captures during one of
> these events and attaching them to the bug would help to track down the
> problem. It's likely to be Netapp's bug however...

NetApp explicitly refuses to fix anything that is outside
their supported client matrix. I've heard that from NetApp
reps responsible for my customers. cifsfs is outside that
matrix. NetApp's fix is to tell people to use NFS when
coming from Linux.

Volker
