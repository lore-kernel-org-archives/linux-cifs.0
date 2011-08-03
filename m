From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: optimize mount.cifs for speed?
Date: Wed, 3 Aug 2011 10:57:22 -0500
Message-ID: <CAH2r5muMTS1nviEk++L0QebqK9NpirW3trzMd52jRE4jBL+j2g@mail.gmail.com>
References: <CALEFH9SHkdgtLeruSLbEB9HjXAa=SscbFF4C2+yj1sB6i+vMcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steffie Morris <steffie.morris-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALEFH9SHkdgtLeruSLbEB9HjXAa=SscbFF4C2+yj1sB6i+vMcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 3, 2011 at 6:52 AM, Steffie Morris <steffie.morris-Re5JQEeQqe8@public.gmane.org=
m> wrote:
> Hi, i have some questions (and problems) regarding speed in linux
> using mount -t cifs for cifs shares.
>
> I have several ubuntu 10.10 workstations and a few windows
> workstations, on wich i want to interact from one central fileshare.
> At the moment i have a fileshare on a windows7 machine, and a
> fileshare (samba) on an ubuntu machine.
> The netwerk is 1 Gbit
> From a windows client uploading/downloading to the linux samba server
> i get 115 MB/s.
> From a window client uploading/downloading to =A0a windows share i ge=
t
> around 110 MB/s.

linux cifs client may be faster than windows on LInux 3.0 and later
kernels on writes to the server, but is usually slower on large file co=
py from
the server due to lack of asynchronous dispatch of read (something
Jeff and I have been looking at adding later this year).

Even on older kernels, Linux cifs client does much better if multiple
processes are running (and against different files/directories) since
it looks like we can keep more requests in flight to the server than
most other clients - except for the large file copy from the server
(async file read) case.

> From the linux client uploading to the windows share i get 60 MB/s.
> From the linux client uploading to the linux samba =A0server i get 60=
 MB/s.

On current kernels (e.g. Linux 3.0 and 3.01-rc) this (sequential
write) should be wire
speed - I got >85% wire utilization on GigE even between low end home
systems with file copy.   (assuming your disks can keep up with this)

> From the linux client reading from the windows share i get 17 MB/s.
> From t he linux client reading from the linux samba share i get 17MB/=
s.

Reads to the same file will be single threaded on the wire (and relativ=
ely
smaller than what windows requests, 16K vs. ~60K) - if you have
a multithreaded or multiprocess file copy application - you can
increase speed of large file copy with mounting with
"forcedirectio"

> The biggest problem question i face, is why is reading thru a "mount
> -t cifs" share this slow?
> If the linux machine acts as a server the speed is really fast (in
> combination with a windows client) but when i use the linux machine a=
s
> a client, the performance is not good.
> Am i overlooking something? should i be using special options to
> optimize performance for cifs in client mode on linux ?
> I think i ruled out hardware network issue's as traffic the other way
> around works (with linux as serving share), and also via FTP, or
> testing with iperf gives me near full Gbit speeds.




--=20
Thanks,

Steve
