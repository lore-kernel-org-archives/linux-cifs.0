From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate errors up to the caller during get/set acls
Date: Mon, 8 Nov 2010 11:24:00 -0600
Message-ID: <AANLkTi=dwS88JM422vAxSMaeuqDdu_dh2aqGc6fGSpkd@mail.gmail.com>
References: <1289231238-15203-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101108121310.78951ec1@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101108121310.78951ec1-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Nov 8, 2010 at 11:13 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, =A08 Nov 2010 09:47:18 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Modify get/set_cifs_acl* calls to reutrn error code and percolate th=
e
>> error code up to the caller.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsacl.c | =A0 84 ++++++++++++++++++++++++++++++--------=
--------------
>> =A01 files changed, 48 insertions(+), 36 deletions(-)
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index c9b4792..8c260b9 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -552,38 +552,40 @@ static int build_sec_desc(struct cifs_ntsd *pn=
tsd, struct cifs_ntsd *pnntsd,
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *c=
ifs_sb,
>> - =A0 =A0 =A0 =A0 =A0 =A0 __u16 fid, u32 *pacllen)
>> +static int
>> +get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 __u16 fid, u32 *pacllen, struct cifs_ntsd =
**pntsd)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^
> Dealing with pointers to pointers like this is cumbersome and
> inefficient. Why not just have it return a struct pointer like before
> or a ERR_PTR converted error?

I think we now have a consistent interface not only within
various get/set_cifs_acl* functions but like most of the rest of of
the functions
i.e. they return error code and not a ptr to a structure when successfu=
l
or an err ptr for failure?

>
>> =A0{
>> - =A0 =A0 struct cifs_ntsd *pntsd =3D NULL;
>> - =A0 =A0 int xid, rc;
>> + =A0 =A0 int xid;
>> + =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
>>
>> =A0 =A0 =A0 if (IS_ERR(tlink))
>> - =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 PTR_ERR(tlink);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bug?
>
>>
>> =A0 =A0 =A0 xid =3D GetXid();
>> - =A0 =A0 rc =3D CIFSSMBGetCIFSACL(xid, tlink_tcon(tlink), fid, &pnt=
sd, pacllen);
>> + =A0 =A0 rc =3D CIFSSMBGetCIFSACL(xid, tlink_tcon(tlink), fid, pnts=
d, pacllen);
>> =A0 =A0 =A0 FreeXid(xid);
>>
>> =A0 =A0 =A0 cifs_put_tlink(tlink);
>>
>> =A0 =A0 =A0 cFYI(1, "GetCIFSACL rc =3D %d ACL len %d", rc, *pacllen)=
;
>> - =A0 =A0 return pntsd;
>> + =A0 =A0 return rc;
>> =A0}
>>
>> -static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *=
cifs_sb,
>> - =A0 =A0 =A0 =A0 =A0 =A0 const char *path, u32 *pacllen)
>> +static int
>> +get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path=
,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 *pacllen, struct cifs_=
ntsd **pntsd)
>> =A0{
>> - =A0 =A0 struct cifs_ntsd *pntsd =3D NULL;
>> =A0 =A0 =A0 int oplock =3D 0;
>> - =A0 =A0 int xid, rc;
>> + =A0 =A0 int xid;
>> + =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 __u16 fid;
>> =A0 =A0 =A0 struct cifsTconInfo *tcon;
>> =A0 =A0 =A0 struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
>>
>> =A0 =A0 =A0 if (IS_ERR(tlink))
>> - =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(tlink);
>>
>> =A0 =A0 =A0 tcon =3D tlink_tcon(tlink);
>> =A0 =A0 =A0 xid =3D GetXid();
>> @@ -596,32 +598,34 @@ static struct cifs_ntsd *get_cifs_acl_by_path(=
struct cifs_sb_info *cifs_sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D CIFSSMBGetCIFSACL(xid, tcon, fid, &pntsd, pacllen);
>> + =A0 =A0 rc =3D CIFSSMBGetCIFSACL(xid, tcon, fid, pntsd, pacllen);
>> =A0 =A0 =A0 cFYI(1, "GetCIFSACL rc =3D %d ACL len %d", rc, *pacllen)=
;
>>
>> =A0 =A0 =A0 CIFSSMBClose(xid, tcon, fid);
>> =A0 out:
>> =A0 =A0 =A0 cifs_put_tlink(tlink);
>> =A0 =A0 =A0 FreeXid(xid);
>> - =A0 =A0 return pntsd;
>> + =A0 =A0 return rc;
>> =A0}
>>
>> =A0/* Retrieve an ACL from the server */
>> -static struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 struct inode *inode, const char *path,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 u32 *pacllen)
>> +static int
>> +get_cifs_acl(struct cifs_sb_info *cifs_sb, struct inode *inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 const char *path, u32 *pacllen, struct cif=
s_ntsd **pntsd)
>> =A0{
>> - =A0 =A0 struct cifs_ntsd *pntsd =3D NULL;
>> + =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 struct cifsFileInfo *open_file =3D NULL;
>>
>> =A0 =A0 =A0 if (inode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 open_file =3D find_readable_file(CIFS_I(=
inode), true);
> =A0 =A0 =A0 =A0^^^^^^^^^^
> =A0 =A0 =A0 =A0This predates your patch, but under what conditions wo=
uld we
> =A0 =A0 =A0 =A0call this function without an inode? If you're cleanin=
g up the
> =A0 =A0 =A0 =A0prototype for this function, then I think there are so=
me
> =A0 =A0 =A0 =A0unneeded arguments here.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
