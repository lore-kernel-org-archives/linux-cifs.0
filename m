From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS is slooow, gvfs is fast
Date: Fri, 22 Oct 2010 11:06:31 -0500
Message-ID: <AANLkTikooXeGZPMTRXT=T+Fve3z-8Cy9RzxMqDxQRoOd@mail.gmail.com>
References: <20101022013544.0fdab0e0@werewolf.home>
	<4CC16B1E.4060709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jamagallon-sh/6fXdz2Rs@public.gmane.org, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC16B1E.4060709-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 22, 2010 at 5:44 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> =
wrote:
>
> (Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>
> On 10/22/2010 05:05 AM, J.A. Magall=F3n wrote:
> > Problem: speed is _VERY_ different.
> > R/W through the automount point (CIFS fs), is roughly 7-8 MB/s (rid=
iculous
> > for gigabit speeds).
> > R/W through Gnome/gvfs (kind of fuse) goes around 35 - 40 MB/s (400=
 Mbits/s),
> > that look much better.
>
> What is the kernel version In which you are seeing the problem? I'm n=
ot
> seeing this on 2.6.36-rc4. Do you have a wired interface as well? Are
> you sure that both are using the same network path?
>
> > I have tried with different rsize/wsize in mount, but speed is the =
same
> > (perhaps I did not get the right values...).
>

Read sizes for cifs are relatively small at 16K (unless you change the
maximum buffer sizes at insmod time), and cifs write size is 56K.
This relatively smaller read size and the serializing of relatively
small reads in cifs_readpages can cause slower speeds than you might
expect reading files over gigabit if only one process is using the
network especially if long network latency (lots of dead time on the
network leading to low network utilizations).=A0=A0 cifs will perform
relatively well compared to other options as the number of processes
accessing the network increases, because a lot of work has gone into
locking.=A0 dbench results will often show 50 simultaneous requests to
each Samba server (50 is the traditional maximum number of
simultaneous requests that smb/cifs servers support).=A0=A0 For workloa=
ds
other than sequential read workloads - cifs does relatively better as
well.

In the future with smb2 the maximum number of requests can vary, and
the maximum read size is larger which helps, as does the parallelized
smb2 write code which Pavel wrote over the summer for Google Summer of
Code.

--
Thanks,

Steve
