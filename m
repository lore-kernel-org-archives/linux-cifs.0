From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] manpage: move SEE ALSO section in setcifsacl.1 nearer
 to bottom
Date: Tue, 18 Oct 2011 07:36:16 -0400
Message-ID: <20111018073616.0c11e657@corrin.poochiereds.net>
References: <1318936969-8475-1-git-send-email-jlayton@samba.org>
	<CADT32eLKnXnNOtYktHKhQ-jVKJ25i_w8XG_BVNS1OYWqEBxaNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLKnXnNOtYktHKhQ-jVKJ25i_w8XG_BVNS1OYWqEBxaNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 18 Oct 2011 06:31:33 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Oct 18, 2011 at 6:22 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > The convention is to have that close to the bottom of the manpage. =
In
> > this case, we want it after the EXAMPLES section.
> >
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> > =C2=A0setcifsacl.1 | =C2=A0 12 ++++++------
> > =C2=A01 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/setcifsacl.1 b/setcifsacl.1
> > index be8af0c..8957512 100644
> > --- a/setcifsacl.1
> > +++ b/setcifsacl.1
> > @@ -68,12 +68,6 @@ type: ALLOWED (0x0), DENIED (0x1), OBJECT_ALLOWE=
D (0x5), OBJECT_DENIED (0x6)
> > =C2=A0flags: OBJECT_INHERIT_FLAG (OI or 0x1), CONTAINER_INHERIT_FLA=
G (CI or 0x2), NO_PROPAGATE_INHERIT_FLAG (NI or 0x4), INHERIT_ONLY_FLAG=
 (IO or 0x8), INHERITED_ACE_FLAG (IA or 0x10) or a combination/OR of th=
ese values.
> > =C2=A0.PP
> > =C2=A0mask: Either one of FULL, CHANGE, READ, a combination of R W =
X D P O, or a hex value
> > -.SH "SEE ALSO"
> > -.PP
> > -\fBmount.cifs\fR(8),
> > -\fBwinbindd\fR(8),
> > -\fBgetcifsacl\fR(1)
> > -.PP
> > =C2=A0.SH "EXAMPLES"
> > =C2=A0.PP
> > =C2=A0Add an ACE
> > @@ -95,6 +89,12 @@ setcifsacl -S "ACL:CIFSTESTDOM\\Administrator:0x=
0/0x0/FULL,
> > =C2=A0.br
> > =C2=A0ACL:CIFSTESTDOM\\user2:0x0/0x0/FULL," <file_name>
> > =C2=A0.PP
> > +.SH "SEE ALSO"
> > +.PP
> > +\fBmount.cifs\fR(8),
> > +\fBwinbindd\fR(8),
> > +\fBgetcifsacl\fR(1)
> > +.PP
> > =C2=A0.SH "AUTHOR"
> > =C2=A0.PP
> > =C2=A0Shirish Pargaonkar wrote the setcifsacl program\&.
> > --
> > 1.7.6.4
> >
> >
>=20
> Thanks Jeff.  Looks correct.
> Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks. Committed...

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
