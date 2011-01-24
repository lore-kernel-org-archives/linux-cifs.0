From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] cifs: Invoke id mapping functions (try #3)
Date: Mon, 24 Jan 2011 15:14:28 -0600
Message-ID: <AANLkTimK-wYV8EtOk6n=mzGMadk25FMhA-K8Zc1_kzwn@mail.gmail.com>
References: <1295646269-21898-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110122074826.26e9ad03@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110122074826.26e9ad03-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Jan 22, 2011 at 6:48 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 21 Jan 2011 15:44:29 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> RB tree search and insertion routines.
>>
>> A SID which needs to be mapped, is looked up in one of the RB trees
>> depending whether SID is either owner or group SID.
>> If found in a tree, a (mapped) id from that node is assigned to
>> uid or gid as appropriated.
>>
>> Otherwise, the SID is mapped and looked-up with the help of
>> Winbind via upcall mechanism.
>>
>> To map a SID, which can be either a Owner SID or a Group SID, key
>> description starts with the string "os" or "gs" followed by SID conv=
erted
>> to a string. Without "os" or "gs", cifs.upcall does not know whether
>> SID needs to be mapped to either an uid or a gid.
>>
>> For now, cifs.upcall is only used to map a SID to an id (uid or gid)=
 but
>> it would be used to obtain an SID (string) for an id.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> [...]
>
>> +static int
>> +sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_fattr *fattr, uint sidtype)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 unsigned long id;
>> + =A0 =A0 char *sidstr, *strptr;
>> + =A0 =A0 struct key *idkey;
>> + =A0 =A0 const struct cred *saved_cred;
>> + =A0 =A0 struct cifs_sid_id *sididptr;
>> +
>> + =A0 =A0 if (sidtype =3D=3D SIDOWNER) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_sb->siduidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 id =3D id_rb_search(&cifs_sb->uidtree, psi=
d);
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_sb->siduidlock);
>> + =A0 =A0 } else if (sidtype =3D=3D SIDGROUP) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_sb->sidgidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 id =3D id_rb_search(&cifs_sb->gidtree, psi=
d);
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_sb->sidgidlock);
>> + =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOENT;
>> +
>> + =A0 =A0 if (!id) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 sidstr =3D kzalloc(SIDLEN, GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!sidstr)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 sididptr =3D kzalloc(sizeof(struct cifs_si=
d_id), GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!sididptr) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(sidstr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNER)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(sidstr, "%s", "os:=
");
>> + =A0 =A0 =A0 =A0 =A0 =A0 else if (sidtype =3D=3D SIDGROUP)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(sidstr, "%s", "gs:=
");
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 strptr =3D sidstr + strlen(sidstr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 sid_to_str(psid, strptr);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 saved_cred =3D override_creds(root_cred);
>> + =A0 =A0 =A0 =A0 =A0 =A0 idkey =3D request_key(&cifs_idmap_key_type=
, sidstr, "");
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(idkey))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Can't resolve=
 SID to an uid", __func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 id =3D *(unsigned long *)i=
dkey->payload.value;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_put(idkey);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&sididptr->sid, psi=
d, sizeof(struct cifs_sid));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sididptr->id =3D id;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNE=
R) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(=
&cifs_sb->siduidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 id_rb_inse=
rt(&cifs_sb->uidtree, sididptr, id);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unloc=
k(&cifs_sb->siduidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(=
&cifs_sb->sidgidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 id_rb_inse=
rt(&cifs_sb->gidtree, sididptr, id);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unloc=
k(&cifs_sb->sidgidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 revert_creds(saved_cred);
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(sidstr);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (sidtype =3D=3D SIDOWNER)
>> + =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_uid =3D id;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_gid =3D id;
>> +
>> + =A0 =A0 return rc;
>> +}
>> +
>
> This looks racy.
>
> You search for an entry in the rbtree and then do the upcall if it
> doesn't exist. When you get the response back you stick it in the tre=
e.

Would it work if compare_sid returns 0 (would to add a
check for it) during node insert (function id_rb_insert()), free the
allocated node and return?
=46unction id_rb_insert() is invoked within a spin lock.

>
> What if two different threads are doing this at the same time? It's
> easily possible that once the downcall comes in, another thread has
> already stuck an entry in that spot.
>
> What you should do is stick a placeholder in the tree prior to doing
> the upcall. Then, if another thread comes along and does a search you
> have it wait until the upcall is complete. See cifs_sb_tlink for an
> example of how to do that.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
