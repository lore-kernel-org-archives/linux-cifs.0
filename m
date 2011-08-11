From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SMB2.1 leases support for CIFS kernel client
Date: Thu, 11 Aug 2011 04:09:37 +0400
Message-ID: <CAKywueQMi2=-dDhZfbAykdc=mgzLMastq+3sVW7U_gdi_gz6JQ@mail.gmail.com>
References: <CAKywueQXSfX9bEySehuG_C_ikVnn8AK1zxuoybFx8JL9JKezGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQXSfX9bEySehuG_C_ikVnn8AK1zxuoybFx8JL9JKezGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

9 =C1=D7=C7=D5=D3=D4=C1 2011=9A=C7. 21:11 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=
=CC=D8 Pavel Shilovsky
<piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> Hi all!
>
> I implemented SMB2.1 leases support for cifs kernel module (in my
> smb2-dev branch -
> http://git.altlinux.org/people/piastry/public/?p=3Dcifs-2.6.git;a=3Ds=
hortlog;h=3Drefs/heads/smb2-dev).
> Now open and create work with leases support - it means that we can
> have several simul=C1neous opens for the same file and use cache for
> read and write operations (in the case when we use the same superbloc=
k
> for these opens).
>
> Whole list of changes since the last status update:
> 1) SMB2 oplocks support (open, breaks).
> 2) SMB2.1 leases support (open, breaks).
> 3) strictcache i/o support for SMB2.
>
> and other minor bugfixes and cleanups.
>
> Your comments are appreciated!
>
> --
> Best regards,
> Pavel Shilovsky.
>

Rebased smb2-dev branch to the current master and fixed some bugs.

I also got some performance testing results of comparison between
write on several opens of the same file into different areas and write
on several opens of different files on the same share:
1) 2 file descriptors
SMB2    : write on 2 fds of the same file =3D=3D write on 2 fds of diff=
erent files.
SMB2.1 : write on 2 fds of the same file is ~35% faster than write on
2 fds of different files (on the same share).
2) 3 file descriptors
SMB2    : write on 3 fds of the same file =3D=3D write on 3 fds of diff=
erent files.
SMB2.1 : write on 3 fds of the same file is ~50% faster than write on
3 fds of different files (on the same share).

I am going to test it more - I will inform about the results when I get=
 them.

--=20
Best regards,
Pavel Shilovsky.
