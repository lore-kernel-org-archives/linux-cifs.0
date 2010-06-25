From: Steve French <smfrench@gmail.com>
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and
	register them
Date: Fri, 25 Jun 2010 18:05:30 -0500
Message-ID: <AANLkTilOTrHLvLv4XWYZO6xCnYZgYT7gO2M-oKZ6VvqM@mail.gmail.com>
References: <20100625125306.7f9b1966@tlielax.poochiereds.net>
	<4C24A606.5040001@suse.de>
	<1277220214-3597-1-git-send-email-sjayaraman@suse.de>
	<9822.1277312573@redhat.com>
	<22697.1277470549@redhat.com>
	<18628.1277502398@redhat.com>
	<20100625182651.36800d06@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells@redhat.com>,
	Suresh Jayaraman <sjayaraman@suse.de>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
	Jeff Layton <jlayton@redhat.com>
To: Jeff Layton <jlayton@samba.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100625182651.36800d06@tlielax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, Jun 25, 2010 at 5:26 PM, Jeff Layton <jlayton@samba.org> wrote:
>
> On Fri, 25 Jun 2010 22:46:38 +0100
> David Howells <dhowells@redhat.com> wrote:
>
> > Jeff Layton <jlayton@samba.org> wrote:
> >
> > > Looks like it mostly uses the ctime. IMO, the mtime would be a be=
tter
> > > choice since it changes less frequently, but I don't guess that i=
t
> > > matters very much.
> >
> > I'd've thought mtime changes more frequently since that's altered w=
hen data is
> > written. =A0ctime is changed when attributes are changed.
> >
>
> IIUC, updating mtime for a write is also an attribute change, and tha=
t
> affects ctime. According to the stat(2) manpage:
>
> =A0 =A0 =A0 The field st_ctime is changed by writing or by setting =A0=
inode =A0informa-
> =A0 =A0 =A0 tion (i.e., owner, group, link count, mode, etc.).
>
> > Note that Ext4 appears to have a file creation time field in its in=
ode
> > (struct ext4_inode::i_crtime[_extra]). =A0Can Samba be made to use =
that?
> >
>
> Is it exposed to userspace in any (standard) way? It would be handy t=
o
> have that. While we're wishing...it might also be nice to have a
> standard way to get at the i_generation from userspace too.
>

Yes - I have talked with MingMing and Aneesh about those (NFS may
someday be able to use those too).=A0 An obstacle in the past had been
that samba server stores its own fake creation time in an ndr encoded
xattr which complicates things.

MingMing/Annesh -
Xattr or other way to get at birth time?


--
Thanks,

Steve
