From: Mingming Cao <mcao@us.ibm.com>
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and
	register them
Date: Fri, 25 Jun 2010 17:52:24 -0700
Message-ID: <OFB55E8EC7.E8DD23D5-ON8725774E.0004921E-8825774E.0004CC31@us.ibm.com>
References: <20100625125306.7f9b1966@tlielax.poochiereds.net>	<4C24A606.5040001@suse.de>
	<1277220214-3597-1-git-send-email-sjayaraman@suse.de>	<9822.1277312573@redhat.com>
	<22697.1277470549@redhat.com>	<18628.1277502398@redhat.com>	<20100625182651.36800d06@tlielax.poochiereds.net>
	<AANLkTilOTrHLvLv4XWYZO6xCnYZgYT7gO2M-oKZ6VvqM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <AANLkTilOTrHLvLv4XWYZO6xCnYZgYT7gO2M-oKZ6VvqM@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org



Steve French <smfrench@gmail.com> wrote on 06/25/2010 04:05:30 PM:

> Steve French <smfrench@gmail.com>
> 06/25/2010 04:05 PM
>
> To
>
> Jeff Layton <jlayton@samba.org>, "Aneesh Kumar K.V"
> <aneesh.kumar@linux.vnet.ibm.com>, Mingming Cao/Beaverton/IBM@IBMUS
>
> cc
>
> David Howells <dhowells@redhat.com>, Suresh Jayaraman
> <sjayaraman@suse.de>, linux-cifs@vger.kernel.org, linux-
> fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, samba-
> technical@lists.samba.org, Jeff Layton <jlayton@redhat.com>
>
> Subject
>
> Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and
> register them
>
> On Fri, Jun 25, 2010 at 5:26 PM, Jeff Layton <jlayton@samba.org> wrot=
e:
> >
> > On Fri, 25 Jun 2010 22:46:38 +0100
> > David Howells <dhowells@redhat.com> wrote:
> >
> > > Jeff Layton <jlayton@samba.org> wrote:
> > >
> > > > Looks like it mostly uses the ctime. IMO, the mtime would be a
better
> > > > choice since it changes less frequently, but I don't guess that=
 it
> > > > matters very much.
> > >
> > > I'd've thought mtime changes more frequently since that's
> altered when data is
> > > written. =A0ctime is changed when attributes are changed.
> > >
> >
> > IIUC, updating mtime for a write is also an attribute change, and t=
hat
> > affects ctime. According to the stat(2) manpage:
> >
> > =A0 =A0 =A0 The field st_ctime is changed by writing or by setting
> =A0inode =A0informa-
> > =A0 =A0 =A0 tion (i.e., owner, group, link count, mode, etc.).
> >
> > > Note that Ext4 appears to have a file creation time field in its
inode
> > > (struct ext4_inode::i_crtime[_extra]). =A0Can Samba be made to us=
e
that?
> > >
> >
> > Is it exposed to userspace in any (standard) way? It would be handy=
 to
> > have that. While we're wishing...it might also be nice to have a
> > standard way to get at the i_generation from userspace too.
> >
>
> Yes - I have talked with MingMing and Aneesh about those (NFS may
> someday be able to use those too).=A0 An obstacle in the past had bee=
n
> that samba server stores its own fake creation time in an ndr encoded=

> xattr which complicates things.
>
> MingMing/Annesh -
> Xattr or other way to get at birth time?
>
>

Not yet,
 The ext4 file creation time only accesable from the kernel at the mome=
nt.
There were discussion
to make this information avaliable via xattr before, but was rejected,
since most people
agree that making this info avalibele via stat() is more standard. Howe=
ver
modifying stat() would imply
big interface change. thus no action has been taken yet.

> --
> Thanks,
>
> Steve=
