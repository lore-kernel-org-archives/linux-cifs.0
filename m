From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: SMB2.1 leases support for CIFS kernel client
Date: Tue, 9 Aug 2011 14:00:04 -0400
Message-ID: <20110809180004.GC16206@fieldses.org>
References: <CAKywueQXSfX9bEySehuG_C_ikVnn8AK1zxuoybFx8JL9JKezGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKywueQXSfX9bEySehuG_C_ikVnn8AK1zxuoybFx8JL9JKezGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Aug 09, 2011 at 09:11:20PM +0400, Pavel Shilovsky wrote:
> Hi all!
>=20
> I implemented SMB2.1 leases support for cifs kernel module (in my
> smb2-dev branch -
> http://git.altlinux.org/people/piastry/public/?p=3Dcifs-2.6.git;a=3Ds=
hortlog;h=3Drefs/heads/smb2-dev).
> Now open and create work with leases support - it means that we can
> have several simul=D0=B0neous opens for the same file and use cache f=
or
> read and write operations (in the case when we use the same superbloc=
k
> for these opens).
>=20
> Whole list of changes since the last status update:
> 1) SMB2 oplocks support (open, breaks).
> 2) SMB2.1 leases support (open, breaks).
> 3) strictcache i/o support for SMB2.
>=20
> and other minor bugfixes and cleanups.
>=20
> Your comments are appreciated!

Just a trivial comment: I think that #ifdef CONFIG_CIFS_SMB2 in
cifs_oplock_beak() is a case where the Linux convention of hiding the
ifdef with a conditionally-defined function would be a lot cleaner....

--b.
