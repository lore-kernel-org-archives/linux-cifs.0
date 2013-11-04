From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: copy chunk preliminary results
Date: Mon, 04 Nov 2013 10:07:22 +0000
Message-ID: <527771DA.1050701@draigBrady.com>
References: <CAH2r5mtoGCn-z_-Aetwaxxvn8bS19mexb7Rur3TE=RGipGCppQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtoGCn-z_-Aetwaxxvn8bS19mexb7Rur3TE=RGipGCppQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/04/2013 06:30 AM, Steve French wrote:
> I extended my initial copy chunk kernel client patch to handle files =
>
> 1MB (repeating copychunk requests multiple times, 1 chunk at a time, =
I
> realize that this will be even faster when I send more than 1 chunk a=
t
> a time)
>=20
> Preliminary results local loopback mount of current cifs kernel code
> (vers=3D3.0) to Samba (master branch, running on Fedora 19 with btrfs=
):
>=20
> File size of test file (vmlinux.o) was 373987044 bytes
>=20
> Over the network Copychunk (refcopy) was about six times faster than =
without.
> ane even local copy (no reflink) is slower than remote copy with
> reflink.  Copychunk would look even better except that the server dis=
k
> is SSD.
>=20
>=20
> [sfrench@pc-on-right cifs-2.6]$ time cp vmlinux.o ~/trgt-1-local
> real    0m0.769s
> user    0m0.002s
> sys    0m0.502s
>=20
> (Local copy with reflink is amazingly fast on btrfs)
> [sfrench@pc-on-right cifs-2.6]$ time cp --reflink vmlinux.o
> ~/trgt-2-local-reflink
> real    0m0.004s
> user    0m0.001s
> sys    0m0.002s
>=20
> (remote copy with reflink to Samba was six times faster than remote
> with no reflink, similar results when repeated)
> [sfrench@pc-on-right cifs-2.6]$ time cp --reflink
> /mnt/cifs-2.6/vmlinux.o /mnt/trgt-3-remote-reflink
> real    0m0.416s
> user    0m0.000s
> sys    0m0.029s
>=20
>=20
> [sfrench@pc-on-right cifs-2.6]$ time cp  /mnt/cifs-2.6/vmlinux.o
> /mnt/trgt-3-no-reflink
> real    0m2.596s
> user    0m0.007s
> sys    0m0.860s

So cp --reflink has CoW semantics and so probably not an
appropriate interface for this.  Unless I'm misunderstanding,
this SMB copy offload does result in a normal copy on the server right?
So that would imply that cp should try to use the "smb_copy_offload"
ioctl unconditionally after a little introspection, or preferentially
this would be encapsulated in the recently mooted copyfile() level
kernel call, which cp etc. could just call to do the operation.

thanks,
P=E1draig.
