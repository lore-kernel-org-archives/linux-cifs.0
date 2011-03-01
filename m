From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Mon, 28 Feb 2011 22:28:09 -0500
Message-ID: <20110301032808.GA17725@fieldses.org>
References: <1298929961-5541-1-git-send-email-shirishpargaonkar@gmail.com>
 <20110228224957.GB14237@fieldses.org>
 <AANLkTimDd-m388VJTC1zJtf3Q7LkFcsvNuwcY6vRwt7K@mail.gmail.com>
 <20110228234225.GC14237@fieldses.org>
 <AANLkTikeSEYOs_nzno40eM0ZSrStMqcziPzWGRViT5M-@mail.gmail.com>
 <20110228235910.GD14237@fieldses.org>
 <AANLkTinFwcBMmPpn0_30Bjaa+0ipoJ6qrM=u1TGQ+Q8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinFwcBMmPpn0_30Bjaa+0ipoJ6qrM=u1TGQ+Q8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 28, 2011 at 08:33:08PM -0600, Steve French wrote:
> On Mon, Feb 28, 2011 at 5:59 PM, J. Bruce Fields <bfields-uC3wQj2KruMpug/h7KTFAQ@public.gmane.org=
g> wrote:
> > On Mon, Feb 28, 2011 at 05:52:09PM -0600, Steve French wrote:
> >> On Mon, Feb 28, 2011 at 5:42 PM, J. Bruce Fields <bfields@fieldses=
=2Eorg> wrote:
> >> > OK. =C2=A0Then as things stand we're stuck returning ESTALE to t=
he client
> >> > unless we happen to have the inode they're looking for in our ca=
che?
> >>
> >> Yes - that seems right and consistent with what I remember other f=
ile
> >> systems doing.
> >
> > No, other filesystems are able to look up the file on disk by inode
> > number (or by whatever identifier they use in the filehandle). =C2=A0=
They
> > don't depend on already having the inode in core.
>=20
> Grepping for ESTALE looks like there are dozens of places in various
> fs where ESTALE can get returned ...

Certainly true.

But they do have to be able to look up any inode, regardless of whether
it is currently in cache.

Otherwise applications on the client would see ESTALE after any server
reboot, or any time an inode was forced out of cache (for whatever
reason).

That would be quite painful.

--b.
