From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] FS: cifs: Fix compile warning
Date: Mon, 13 Sep 2010 11:30:27 -0500
Message-ID: <AANLkTi=q5qTNomN0VQ__9V8cbF=ygGMFkm2a3=qiaYja@mail.gmail.com>
References: <1284165942.4009.5.camel@lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Javier Martinez Canillas <martinez.javier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1284165942.4009.5.camel@lenovo>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 10, 2010 at 7:45 PM, Javier Martinez Canillas
<martinez.javier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> In today linux-next I got a compile warning due a possibly uninitiali=
zed variable
>
> This trivial patch solves the issue
>
> Thanks a lot
>
> Signed-off-by: Javier Martinez Canillas <martinez.javier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifssmb.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index c65c341..ee1bba4 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3079,7 +3079,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTco=
nInfo *tcon, __u16 fid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 parm_len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 acl_len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_com_ntransact_rsp *pSMBr;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *pdata;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *pdata =3D NULL;

This looks like a compiler problem - the variable is always
initialized by validate_ntransact except when
buf (which contains the smb) is null, when it returns -EINVAL and in
that case pdata is not used.
Setting it to null would not help anyway - if it were left as null it
would oops on the memcpy (where pdata is used).

This area of code has not changed recently.


--=20
Thanks,

Steve
