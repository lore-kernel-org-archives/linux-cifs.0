From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mounts to Windows 7 and "out of memory" or "insufficient server resources"
Date: Wed, 28 Sep 2011 20:22:18 -0500
Message-ID: <CAH2r5mvhLCPpMa3Q4fbXQmMqKKC8aopix0LrQDtCR1-22KTP-Q@mail.gmail.com>
References: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ@mail.gmail.com>
	<CADT32eLk5N4WJCMdtcd3MTgR39fCTn4_gQqqobYsxkpcPnfuDQ@mail.gmail.com>
	<CAH2r5msGzs65HO_YuuUzhp3RNo+rJEB=ey8Hx5=1r=bpWpjWLA@mail.gmail.com>
	<20110928155648.09c19e8c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110928155648.09c19e8c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 28, 2011 at 2:56 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Wed, 28 Sep 2011 13:28:38 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Wed, Sep 28, 2011 at 4:30 AM, Shirish Pargaonkar
>> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > On Tue, Sep 27, 2011 at 4:36 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
>> >> FYI - The cifs async write in 3.0 seems to exacerbate problems ru=
nning
>> >> out of memory (apparently) on the Windows 7 system (running as a
>> >> server) after a large file copy to the server completes. =A0 I ha=
ve been
>> >> able to reproduce the same problem on Windows Vista Service Pack =
2

=46or servers other than Windows 7 and Windows Vista, we have
not been able to reproduce the problem, so Windows 2003 and Windows 200=
8
are probably ok.  I was also unable to reproduce this to Samba or Windo=
ws XP

But for mounts to Windows 7 or Windows Vista from Linux cifs for 3.0
kernel or later,
two workarounds for this Windows problem have been found:

1) As Pavel discovered, increasing MaxWorkItems to 4096 in the Windows
registry solves this.
2) Or to workaround this on the Linux client, load the cifs kernel
module with a lower limit on the simultaneous requests per connection
ie
     "modprobe cifs cifs_max_pending=3D10"
(it would default to 50)





--=20
Thanks,

Steve
