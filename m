From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/6] Add strict cache mode (try #4)
Date: Mon, 29 Nov 2010 14:00:21 +0300
Message-ID: <AANLkTinLbS7V=Ok_Eje=mnrBOkZEJJo9iQ9SYwHsbsag@mail.gmail.com>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
	<4CF3864E.50901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF3864E.50901-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/29 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
> On 11/28/2010 01:42 PM, Pavel Shilovsky wrote:
>> Re-posting the whole set of strict cache patches.
>
> I try to explain here the "strict cache" semantics as I'm not sure
> whether I understand it clearly. Please correct me if I'm wrong.
>
> Strict cache semantics
>
> =A0o provides stricter cache coherency among cifs clients that access
> =A0 =A0the same files.
> =A0o The clients will read data from the Server always, except when t=
hey
> =A0 =A0hold read oplock or Level II oplock on the file.
> =A0o The clients will write data to the Server always, except when th=
ey
> =A0 =A0hold exclusive oplock on the file.
> =A0o When we close the last filehandle of the inode, file should be
> =A0 =A0marked for revalidation as it is possible for the client to ac=
cess
> =A0 =A0stale data from the cache when we open it again with a read
> =A0 =A0oplock.
> =A0o On fsync/mmap, invalidate inode if read oplock has not been set.
>
>
> Is this the semantics being proposed? Did I miss anything?

Yes, you are right - it is exactly what I mean.

--=20
Best regards,
Pavel Shilovsky.
