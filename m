From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Why do we use a global lock when manipulating MIDs
Date: Tue, 29 May 2012 09:03:55 -0400
Message-ID: <20120529090355.673b3536@corrin.poochiereds.net>
References: <CACyXjPwtjOMispfRE1uy2jTj6oAv4CNburFirWDwDcnhmCNw2w@mail.gmail.com>
	<CAH2r5muO2JWZn_aE=tNVtuenTktrGOgXwyE0Vs8ueSRsQkPTfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muO2JWZn_aE=tNVtuenTktrGOgXwyE0Vs8ueSRsQkPTfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 28 May 2012 22:03:44 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, May 28, 2012 at 7:30 PM, Richard Sharpe
> <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > Hi folks,
> >
> > I am reading the code because I am interested in adding SMB2.2/3.0
> > support around multi-connect.
> >
> > I noticed the following code, which confuses me.
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* put it on the pending_mid_q */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&GlobalMid_Lock);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0list_add_tail(&mid->qhead, &server->pend=
ing_mid_q);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(&GlobalMid_Lock);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D cifs_sign_smb2(iov, nvec, server,=
 &mid->sequence_number);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_delete_=
mid(mid);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0*ret_mid =3D mid;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> >
> > Since MIDs are allocated on a per-server basis and the list that th=
e
> > new struct mid_q_entry is placed on is in the struct TCP_Server_Inf=
o
> > why are we using GlobalMid_Lock. It seems that we could move that
> > spinlock into struct TCP_Server_Info.
> >
> > What am I missing here?
>=20
> Yes - probably could be moved to the srv_mutex in struct
> TCP_Server_Info although it is unlikely to make a measurable
> difference.
>=20

Breaking up that global lock is long overdue, but let's not overload
the srv_mutex with that -- mutexes have much higher overhead than a
spinlock. A new per-TCP_Server_Info spinlock would be preferable.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
