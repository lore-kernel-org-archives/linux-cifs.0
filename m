From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1] cifs: make shares unaccessible at root level mountable
Date: Mon, 30 Nov 2015 00:54:49 -0600
Message-ID: <CADT32eLN2gSpGR9g99j6ka8NHo_ozXdKmSnjtJP=SCtc2ca4VQ@mail.gmail.com>
References: <20151105154836.1851c30c@aaptelpc>
	<CADT32eJ_uLj4_sEhWc+O=xjOMMfNhGGH9XhiJmdDQyrL6Dzp3A@mail.gmail.com>
	<20151126140915.11349031@aaptelpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151126140915.11349031@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 26, 2015 at 7:09 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> =
wrote:
> On Mon, 16 Nov 2015 23:20:09 -0600 Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> I do not understand why you need to entertain error ENOENT on an
>> intermediate path.
>
> In cifs_get_root() @ fs/cifs/cifsfs.c when one of the intermediary pa=
th
> component access is restricted I get a NULL direntry->d_inode. Which =
is
> translated to ENOENT.
>
>                 struct inode *dir =3D d_inode(dentry);
>                 struct dentry *child;
>
>                 if (!dir) {
>                         dput(dentry);
>                         dentry =3D ERR_PTR(-ENOENT);
>                         break;
>                 }
>
>

So only time you will have NULL dir (inode) is when lookup_one_len()
in cifs_get_root() returned a negative dentry. If we call
create_root_dis_dentry()
for a path object which already has a negative dentry, we will create a=
nother
dentry (disconnected) for the same path object.  So for the same path o=
bject, we
could possibly have two (or more) dentries in the dentry cache, one
negative and one
(or more) disconnected.  So I think if we are going to call
create_root_dis_dentry()
in case error is ENONET, we should delete the (negative) dentry before =
the call.

>> I still do not understand why noserverino is in picture. Only the
>> disconnected root dentry
>> has an inode generated with an id by the cifs client.  Once this
>> disconnected root denty
>> gets spliced, the inode is filled with correct inode (fileid)
>> available from the server
>> (since that intermediate path is now accessible hence splicable).
>> You have fileid/inode available for all eligible/accessible file
>> objects under the disconnected
>> root entry.
>
> Again, the only function that adds disconneted roots
> to the linked list in the superblock is cifs_alloc_rdelem() which is
> *only called* with noserverino. This is from your patch.
>
> % grep -R cifs_alloc_rdelem fs/cifs/*.c
> fs/cifs/cifsfs.c-}
> fs/cifs/cifsfs.c-
> fs/cifs/cifsfs.c-struct cifs_rdelem *
> fs/cifs/cifsfs.c:cifs_alloc_rdelem(char *full_path, struct dentry *rd=
entry,
> fs/cifs/cifsfs.c-                               struct inode *rdinode=
)
> fs/cifs/cifsfs.c-{
> fs/cifs/cifsfs.c-       struct cifs_rdelem *rdelem;
> --
> fs/cifs/cifsfs.c-               if (!(cifs_sb->mnt_cifs_flags & CIFS_=
MOUNT_SERVER_INUM)) {
> fs/cifs/cifsfs.c-
> fs/cifs/cifsfs.c-                       rdelem =3D
> fs/cifs/cifsfs.c:                               cifs_alloc_rdelem(fpa=
th, dentry, rinode);
> fs/cifs/cifsfs.c-                       if (IS_ERR(rdelem))
> fs/cifs/cifsfs.c-                               goto rdelem_ret;
> fs/cifs/cifsfs.c-                       spin_lock(&cifs_sb->rtdislock=
);
>
> To properly build a path from a child dentry of a disconnected root y=
ou need to know the path of the disconnected root and use it as a prefi=
x. This prefix is only stored in the rdelem struct which is only used w=
ith noserverino. See above.
>
> My patch was able to fix several SUSE customers problems and people c=
ontacted me off-list to tell me it also fixed his problem. I cannot rep=
roduce the issue you're describing.
>
> We can talk on irc if you want, I'm aaptel on freenode.
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (=
AG
> N=C3=BCrnberg)
