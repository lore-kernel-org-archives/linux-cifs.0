From: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
Subject: Re: cifs ignores sysct setting
Date: Wed, 12 Oct 2011 09:10:52 +0200 (CEST)
Message-ID: <ad4b418d-7021-431a-a32b-4b5aaad0cd31@absint.swen.nu>
References: <CAH2r5mvqk6vjbPObEfqm+UtdLudNCfRnvLxqDmf6i4Y+syX24w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvqk6vjbPObEfqm+UtdLudNCfRnvLxqDmf6i4Y+syX24w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


> >
> >
> > ahhh. no, we are not the only users on the nas, our clientservers
> > should
> > just turn off oplocks. it is, we make backups to the nas device and
> > those
> > files grow quite big.

> If you are trying to save RAM on the client, and don't want to cache,
> and are just using the linux cifs client for backup, you could mount
> with "forcedirectio" (which turns off caching a little more easily).

Hi Steve, it was that we had i/o timeouts on our cifs mounted volume while doing rsyncs to that volume. since we disabled oplock the timeouts vanished. however, I will suggest your idea to my colleague who had that problem and he might give it a go as well.

thanks for your thoughts!
Alex

> Thanks,

> Steve
