From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix some unused variable warnings in id_rb_search
Date: Wed, 4 May 2011 13:02:07 -0500
Message-ID: <BANLkTinL6SxRmngOyZmvoHpqhHk5TzBZnw@mail.gmail.com>
References: <1304510899-30360-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304510899-30360-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, May 4, 2011 at 7:08 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> fs/cifs/cifsacl.c: In function =91id_rb_search=92:
> fs/cifs/cifsacl.c:215:19: warning: variable =91linkto=92 set but not =
used
> [-Wunused-but-set-variable]
> fs/cifs/cifsacl.c:214:18: warning: variable =91parent=92 set but not =
used
> [-Wunused-but-set-variable]
>
> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsacl.c | =A0 =A05 -----
> =A01 files changed, 0 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index a4aa0f0..bfb5ba5 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -211,19 +211,14 @@ id_rb_search(struct rb_root *root, struct cifs_=
sid *sidptr)
> =A0{
> =A0 =A0 =A0 =A0int rc;
> =A0 =A0 =A0 =A0struct rb_node *node =3D root->rb_node;
> - =A0 =A0 =A0 struct rb_node *parent =3D NULL;
> - =A0 =A0 =A0 struct rb_node **linkto =3D &(root->rb_node);
> =A0 =A0 =A0 =A0struct cifs_sid_id *lsidid;
>
> =A0 =A0 =A0 =A0while (node) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lsidid =3D rb_entry(node, struct cifs_=
sid_id, rbnode);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 parent =3D node;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D compare_sids(sidptr, &((lsidid)=
->sid));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 linkto =3D &(node->rb_l=
eft);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0node =3D node->rb_left=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (rc < 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 linkto =3D &(node->rb_r=
ight);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0node =3D node->rb_righ=
t;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else /* node found */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return lsidid;
> --
> 1.7.4.4
>
>

Looks correct.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
