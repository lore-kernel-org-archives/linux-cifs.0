From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix kernel crash on simultaneous mount/umount calls
Date: Thu, 9 Jun 2011 20:30:20 +0400
Message-ID: <BANLkTikmfKtDxG_6qg+6JiCT2FzF1FFfQg@mail.gmail.com>
References: <1307622570-7141-1-git-send-email-piastryyy@gmail.com>
	<20110609124043.GA9621@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110609124043.GA9621-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/6/9 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>:
>> =A0static void
>> =A0cifs_put_super(struct super_block *sb)
>> =A0{
>> + =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>> + =A0 =A0 if (cifs_sb =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Empty cifs superblock info passed=
 to put_super");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 bdi_destroy(&cifs_sb->bdi);
>
> This means you have a problem with the lifetime rules in cifs_do_moun=
t.
>
> The VFS only calls ->put_super if sb->s_root is set. =A0So the rules =
for
> the mount handler are to only set s_root once the superblock is fully
> set up.
>
> Also you should never call cifs_umount from the error handling in
> cifs_do_mount. =A0Until s_root is set, please unwind manually, after
> that leave it to ->put_super.
>
>
>> +
>> +static void
>> +cifs_kill_super(struct super_block *sb)
>> +{
>
> This also seems quite broken. =A0If you fix up the mount path like
> I suggested it won't be nessecary.
>
>> =A0 =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
>>
>> =A0 =A0 =A0 cFYI(1, "In cifs_put_super");
>> =A0 =A0 =A0 cifs_sb =3D CIFS_SB(sb);
>> =A0 =A0 =A0 if (cifs_sb =3D=3D NULL) {
>
> And this check should also be removed.
>
>

It seems to me that I didn't understand your points clearly.

That's how I reproduce the problem:
1) one process does mount/umount calls in a loop;
2) another process does mount and umount calls.

As the result, kernel crashes sometimes on mount of the second
process, sometimes - on umount of the second process. The problem is
that:

one of these two processes process umount call. So, it comes to
cifs_put_super, calls cifs_umount and then calls kfree(cifs_sb).  In
the same time, another process comes into cifs_do_mount and calls
sget(). Then it appers into cifs_match_super that thinks that all
structures like server, ses, tcon and cifs_sb are valid, but it is not
true - the first process has already freed them but didn't remove
superblock from fs_supers list.

So, I simply reodered calls: now umount codepath marks a superblock as
non-active and calls kill_sb(new cifs_kill_super), it calls
kill_anon_super (that calls cifs_put_super and removes superblock from
fs_supers list) and after that kill_sb frees all cifs structures
(server, ses, tcon, cifs_sb).

As the result, when we get into cifs_match_super (in mount from
another process) we are sure that all cifs structures are valid.

If I am not right, correct me, please!

--=20
Best regards,
Pavel Shilovsky.
