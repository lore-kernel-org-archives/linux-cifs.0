From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS mount twice
Date: Tue, 15 Nov 2011 09:52:47 -0600
Message-ID: <CAH2r5mtf0cPXAFA6uRBztALbaWsV+K8+wyfwOq4n3zy1zJmZ_g@mail.gmail.com>
References: <20111114172138.Horde.60sJZ1wlEB5OwQDKknIWLdA@mail.linuz.in>
	<loom.20111115T070545-916@post.gmane.org>
	<20111115054504.550248e0@tlielax.poochiereds.net>
	<20111115175612.Horde.N_P5LFwlEB5Owlpkz20HVLA@mail.linuz.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111115175612.Horde.N_P5LFwlEB5Owlpkz20HVLA-i9wRM+HIrml8vCsnxnN6bQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 15, 2011 at 6:26 AM, Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org> wrote:
> Once cifs-utils was upgraded the mount -a will mount partition only once.
>
> But when i mount the same FS using command line in debian it will show twice.
>
> Why CIFS FS is mounting on already mounted mount points.

I tried a few experiments here, and although I get different errors
with /sbin/mount.cifs present vs. without, I don't see the problem
you a describing.   First obvious question ... what version of
cifs-utils are you using.   Type "/sbin/mount.cifs -V" to
see if you are using the roughly the same version on all.


--
Thanks,

Steve
