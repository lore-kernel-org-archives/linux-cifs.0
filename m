From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/6] CIFS: Make cifsFileInfo_put work with strict cache mode
Date: Fri, 19 Nov 2010 14:55:57 +0300
Message-ID: <AANLkTi=WzPB6o_f0KL2Sxgdv0Ve4jqK22w8qzdSUTfOj@mail.gmail.com>
References: <1289459222-8210-1-git-send-email-piastryyy@gmail.com>
	<20101115073430.2254b19c@tlielax.poochiereds.net>
	<AANLkTi=SDMQfw4+rZSA_nvW-bq8hsH4ycVa6MXU+vSz=@mail.gmail.com>
	<AANLkTi=e=ExtiYwkWm0tNFVFJWT9nv7HZZB_7PphFKLS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=e=ExtiYwkWm0tNFVFJWT9nv7HZZB_7PphFKLS-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/19 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> 2010/11/19 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> 2010/11/15 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>>>
>>> Not directly related to your patch, but what exactly is the purpose=
 of
>>> the "open_inode_helper"? It looks like "pile o' random junk that we=
 do
>>
>> I agree that we can replace it with simply calling get_query_info fr=
om
>> cifs_open.
>>
>>> for non-posix opens". Maybe it would be best to eliminate that func=
tion
>>> altogether and further unify the posix and non-posix open code. Ste=
ve,
>>> care to comment?
>>>
>>> Now that I'm done ranting, I don't think the invalidate mapping cal=
l
>>> here is unnecessary. We will likely have already invalidated the ca=
che
>>> during the d_revalidate phase, and you're going to do it again belo=
w in
>>> cifs_new_fileinfo.
>>>
>>
>> I investigated it - you was right about unnecessary calling
>> cifs_invalidate_mapping from open_inode_helper and cifs_new_fileinfo=
=2E
>> But I found the following problem:
>>
>> When we execute script close2_problem.py (see in attachment) several
>> times (e.x. for i in `seq 1 20`; do ./close2_problem.py; done) with
>> (!) cifsFYI switched off it shows 'a' instead of 'x' (about 1-2 time=
s
>> for 20 runs). If we switch cifsFYI on it is almost always 'x' (true)=
 -
>> I have caught 'a' in this case one or two times for many-many runs.
>> What do you think about it?
>
> I continued the investigation and discovered that if we use
> invalidate_inode_pages2 instead of invalidate_remote_inode - the
> problem disappears! So, this is the patch we should apply to solve it
> (I don't post it as a separate patch? because I think it needs more
> discussing):
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 53cce8c..f20f200 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1591,7 +1591,10 @@ cifs_invalidate_mapping(struct inode *inode)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_i->write_behind_r=
c =3D rc;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 invalidate_remote_inode(inode);
> +
> + =A0 =A0 =A0 if (inode->i_mapping)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 invalidate_inode_pages2(inode->i_mappin=
g);
> +
> =A0 =A0 =A0 =A0cifs_fscache_reset_inode_cookie(inode);
> =A0}
>

Sorry, "invalidate" patch above was based on v2.6.36 git tree. Here
are the version from cifs master branch:
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ff7d299..66d3ba3 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1679,12 +1679,16 @@ cifs_invalidate_mapping(struct inode *inode)

        cifs_i->invalid_mapping =3D false;

-       /* write back any cached data */
-       if (inode->i_mapping && inode->i_mapping->nrpages !=3D 0) {
-               rc =3D filemap_write_and_wait(inode->i_mapping);
-               mapping_set_error(inode->i_mapping, rc);
+       if (inode->i_mapping) {
+               /* write back any cached data */
+               if (inode->i_mapping->nrpages !=3D 0) {
+                       rc =3D filemap_write_and_wait(inode->i_mapping)=
;
+                       mapping_set_error(inode->i_mapping, rc);
+               }
+
+               invalidate_inode_pages2(inode->i_mapping);
        }
-       invalidate_remote_inode(inode);
+
        cifs_fscache_reset_inode_cookie(inode);
 }


If everything is ok with it I will post it as a separate patch in right=
 format.

--=20
Best regards,
Pavel Shilovsky.
