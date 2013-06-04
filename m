From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v1 11/11] locks: give the blocked_hash its own spinlock
Date: Tue, 04 Jun 2013 16:19:53 +0200
Message-ID: <51ADF789.70906@samba.org>
References: <1370056054-25449-1-git-send-email-jlayton@redhat.com> <1370056054-25449-12-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDC06D3B97CE85A15870C7A9B"
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, matthew-Ztpu424NOJ8@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370056054-25449-12-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDC06D3B97CE85A15870C7A9B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

> There's no reason we have to protect the blocked_hash and file_lock_lis=
t
> with the same spinlock. With the tests I have, breaking it in two gives=

> a barely measurable performance benefit, but it seems reasonable to mak=
e
> this locking as granular as possible.

as file_lock_{list,lock} is only used for debugging (/proc/locks) after t=
his
change, I guess it would be possible to use RCU instead of a spinlock.

@others: this was the related discussion on IRC
(http://irclog.samba.org/) about this:

16:02 < metze> jlayton: do you have time to discuss your file_lock_lock
changes?
16:02 < jlayton> metze: sure, what's up?
16:03 < jlayton> metze: note that it won't help vl's thundering herd
problems...
16:03 < metze> is it correct that after your last patch file_lock_lock
is only used for /proc/locks?
16:03 < jlayton> well, it's only used to protect the list that is used
for /proc/locks
16:04 < jlayton> it still gets taken whenever a lock is acquired or
released in order to manipulate that list
16:04 < metze> would it be a good idea to use rcu instead of a spin lock?=

16:04 < jlayton> I tried using RCU, but it turned out to slow everything
down
16:04 < jlayton> this is not a read-mostly workload unfortunately
16:04 < jlayton> so doing it with mutual exclusion turns out to be faster=

16:04 < metze> ok
16:05 < jlayton> I might play around with it again sometime, but I don't
think it really helps. What we need to ensure is
                 that we optimize the code that manipulates that list,
and RCU list manipulations have larger overhead
16:06 < jlayton> metze: that's a good question though so if you want to
ask it on the list, please do
16:06 < jlayton> others will probably be wondering the same thing
16:08 < metze> maybe it's worth a comment in commit message and the code
16:08 < metze> btw, why don't you remove the ' /* Protects the
file_lock_list and the blocked_hash */' comment?

metze


--------------enigDC06D3B97CE85A15870C7A9B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlGt95EACgkQm70gjA5TCD9rgACdFM0jvnKV/2vYwljAJGQjabIq
YwgAoJeaqln0qY27+IkCDBaB/2+fGAtT
=T0cN
-----END PGP SIGNATURE-----

--------------enigDC06D3B97CE85A15870C7A9B--
