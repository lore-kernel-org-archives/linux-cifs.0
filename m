From: Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: Strange O_DIRECT behaviour on non-directio mounts
Date: Wed, 16 Jul 2014 21:23:29 +0200
Message-ID: <20140716192329.GD8802@noname.redhat.com>
References: <20140627111412.GC5223@noname.redhat.com>
 <CAH2r5mtLNSVua=tHtE_-nDu93_kiwU3sJf8EsiSdvY9EUiqQZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtLNSVua=tHtE_-nDu93_kiwU3sJf8EsiSdvY9EUiqQZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Am 16.07.2014 um 20:15 hat Steve French geschrieben:
> What is the server type?  (you can view this by seeing the "NOS" field
> in /proc/fs/cifs/DebugData or checking to see if "unix" is listed in
> the mount when you do "cat /proc/mounts | grep cifs")
> 
> When mounted to Samba for example, with cifs unix extensions
> negotiated, the cifs client will send open flags (including O_DIRECT
> IIRC) to the server on open.  When mounted to Windows/NetApp etc. or
> when using "nounix" on mount, the flag is not sent on open.

As I wrote, this was another user whose problem I debugged over IRC, and
he doesn't seem to be available any more, so I can't get any new
information from him. What I do have is the line that 'mount' outputs:

[12:08:21] <veleno>    kwolf: this is what is shown by mount: //192.168.128.200/storage-cs on /var/lib/one/datastores/107 type cifs (rw,username=yy,password=xx,iocharset=utf8,file_mode=0777,dir_mode=0777)

The other information that I have is an strace snippet of the qemu
process that tried using a file with O_DIRECT, but no directio mount
option.

open("/var/lib/one//datastores/1/4131/disk.0", O_RDWR|O_DIRECT|O_CLOEXEC) = 6
[...]
pread(6, 0x7f2512bae200, 4096, 0)       = -1 EINVAL (Invalid argument)
pread(6, 0x7f2512bae400, 4096, 0)       = -1 EINVAL (Invalid argument)
pread(6, 0x7f2512bae800, 4096, 0)       = -1 EINVAL (Invalid argument)
pread(6, 0x7f2512baf000, 4096, 0)       = -1 EINVAL (Invalid argument)
pread(6, 0x7f2512badda0, 512, 0)        = -1 EINVAL (Invalid argument)
pread(6, 0x7f2512badda0, 1024, 0)       = -1 EINVAL (Invalid argument)
pread(6, 0x7f2512badda0, 2048, 0)       = -1 EINVAL (Invalid argument)
pread(6, 0x7f2512badda0, 4096, 0)       = -1 EINVAL (Invalid argument)
write(2, "qemu-system-x86_64: /build/build"..., 129qemu-system-x86_64: /build/buildd/qemu-2.0.0+dfsg/block.c:942: bdrv_open_common: Assertion `bdrv_opt_mem_align(bs) != 0' failed.
) = 129

Note that remounting with the 'cache=none' mount option, the reporter
could successfully use the file even with O_DIRECT. This and the commit
message of dca69288 made me think that this is not related to the
server, but a client side issue.

Kevin

> On Fri, Jun 27, 2014 at 6:14 AM, Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Hi Steve,
> >
> > I just discussed a problem with a qemu user on IRC, which boiled down to
> > him trying to open an image file on cifs with O_DIRECT, but not using a
> > directio mount. I understand that this probably isn't going to work
> > anytime soon (if at all), but it resulted in a rather unhelpful failure
> > mode.
> >
> > What happens is that cifs lets the open() call succeed even with the
> > unsupported O_DIRECT on that mount, but then fails any I/O on the file
> > descriptor. I believe this was introduced in commit dca69288 (which I
> > think is otherwise pretty useful).
> >
> > With the old behaviour, qemu detected what's going on and suggested to
> > use a non-O_DIRECT mode to the user, but with the new one, it got rather
> > unhappy after failing to find a working O_DIRECT alignment and ran into
> > an assertion failure...
> >
> > Now I'll certainly fix the latter in qemu, but I also think that the
> > behaviour of cifs is rather surprising. Any chance that you can make
> > open() with O_DIRECT fail again on non-directio mounts?
> >
> > Thanks,
> > Kevin
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
