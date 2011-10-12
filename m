From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs ignores sysct setting
Date: Wed, 12 Oct 2011 07:45:02 -0400
Message-ID: <20111012074502.046de480@tlielax.poochiereds.net>
References: <CAH2r5mvqk6vjbPObEfqm+UtdLudNCfRnvLxqDmf6i4Y+syX24w@mail.gmail.com>
	<ad4b418d-7021-431a-a32b-4b5aaad0cd31@absint.swen.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
To: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ad4b418d-7021-431a-a32b-4b5aaad0cd31-VJN6hnAnNNsoZRmjwiK4Kw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 12 Oct 2011 09:10:52 +0200 (CEST)
Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org> wrote:

> 
> > >
> > >
> > > ahhh. no, we are not the only users on the nas, our clientservers
> > > should
> > > just turn off oplocks. it is, we make backups to the nas device and
> > > those
> > > files grow quite big.
> 
> > If you are trying to save RAM on the client, and don't want to cache,
> > and are just using the linux cifs client for backup, you could mount
> > with "forcedirectio" (which turns off caching a little more easily).
> 
> Hi Steve, it was that we had i/o timeouts on our cifs mounted volume while doing rsyncs to that volume. since we disabled oplock the timeouts vanished. however, I will suggest your idea to my colleague who had that problem and he might give it a go as well.
> 

The 2.6.32 kernel you're using also doesn't support async writes,
unless the debian maintainers backported that work, which they don't
typically do. If you move to a newer kernel you may get better
performance as well...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
