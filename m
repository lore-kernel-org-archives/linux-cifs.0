From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate errors up to the caller during get/set
 acls
Date: Mon, 8 Nov 2010 12:38:50 -0500
Message-ID: <20101108123850.055b71b0@tlielax.poochiereds.net>
References: <1289231238-15203-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101108121310.78951ec1@tlielax.poochiereds.net>
	<AANLkTi=dwS88JM422vAxSMaeuqDdu_dh2aqGc6fGSpkd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=dwS88JM422vAxSMaeuqDdu_dh2aqGc6fGSpkd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 8 Nov 2010 11:24:00 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Nov 8, 2010 at 11:13 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Mon, =A08 Nov 2010 09:47:18 -0600
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >>
> >> Modify get/set_cifs_acl* calls to reutrn error code and percolate =
the
> >> error code up to the caller.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsacl.c | =A0 84 ++++++++++++++++++++++++++++++------=
----------------
> >> =A01 files changed, 48 insertions(+), 36 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> >> index c9b4792..8c260b9 100644
> >> --- a/fs/cifs/cifsacl.c
> >> +++ b/fs/cifs/cifsacl.c
> >> @@ -552,38 +552,40 @@ static int build_sec_desc(struct cifs_ntsd *=
pntsd, struct cifs_ntsd *pnntsd,
> >> =A0 =A0 =A0 return rc;
> >> =A0}
> >>
> >> -static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info =
*cifs_sb,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 __u16 fid, u32 *pacllen)
> >> +static int
> >> +get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 __u16 fid, u32 *pacllen, struct cifs_nts=
d **pntsd)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^
> > Dealing with pointers to pointers like this is cumbersome and
> > inefficient. Why not just have it return a struct pointer like befo=
re
> > or a ERR_PTR converted error?
>=20
> I think we now have a consistent interface not only within
> various get/set_cifs_acl* functions but like most of the rest of of
> the functions
> i.e. they return error code and not a ptr to a structure when success=
ful
> or an err ptr for failure?
>=20

I'm not sure I understand your question. Can you rephrase it?

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
