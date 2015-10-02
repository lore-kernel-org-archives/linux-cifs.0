From: Florian Bruhin <me-J2duszcpOy900TDglC2tyg@public.gmane.org>
Subject: Hangs when accessing cifs mounts since Windows Server upgrade
Date: Fri, 2 Oct 2015 09:24:54 +0200
Message-ID: <20151002072454.GL22874@tonks>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256; protocol="application/pgp-signature"; boundary="=_mehl.schokokeks.org-6575-1443770696-0001-2"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_mehl.schokokeks.org-6575-1443770696-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Since my workplace updated their file share from Windows server 2003
to 2012, I'm getting frequent hangs of utilities trying to access the
share. I have two shares mounted (from the same server):

    //<servername>/data /i  cifs    credentials=3D/etc/cifspass,uid=3D1000 =
 0   0
    //<servername>/user/<username> /j  cifs    credentials=3D/etc/cifspass,=
uid=3D1000  0   0

Sometimes, I can't access either of them. Sometimes I can access one
but not the other. "Can't access" means any userspace tool I'm trying
to use to access e.g. /j hangs. This also affects tab completion in
zsh, vim, etc. (I think because they try to access / which also hangs
because of my unorthodox mountpoints).

When this happens, I see this in my dmesg:

    INFO: task ls:11158 blocked for more than 120 seconds.
          Tainted: G           O  3.16.0-4-amd64 #1
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
    ls              D ffff8800c570cff8     0 11158   9390 0x00000004
     ffff8800c570cba0 0000000000000082 0000000000012f00 ffff88031e997fd8
     0000000000012f00 ffff8800c570cba0 ffff88031de74420 ffff88031e997b70
     ffff88031de74424 ffff8800c570cba0 00000000ffffffff ffff88031de74428
    Call Trace:
     [<ffffffff8150e225>] ? schedule_preempt_disabled+0x25/0x70
     [<ffffffff8150fcd3>] ? __mutex_lock_slowpath+0xd3/0x1c0
     [<ffffffff8150fddb>] ? mutex_lock+0x1b/0x2a
     [<ffffffffa0655dd3>] ? cifs_reconnect_tcon+0x153/0x2e0 [cifs]
     [<ffffffff810a7624>] ? __wake_up+0x34/0x50
     [<ffffffffa0655ff5>] ? smb_init+0x25/0x80 [cifs]
     [<ffffffffa065be3c>] ? CIFSSMBQPathInfo+0x5c/0x260 [cifs]
     [<ffffffffa067ef53>] ? cifs_query_path_info+0x63/0x180 [cifs]
     [<ffffffff811b2ea1>] ? link_path_walk+0x71/0x8c0
     [<ffffffff811b1dca>] ? lookup_fast+0xaa/0x2b0
     [<ffffffffa0671360>] ? cifs_get_inode_info+0x230/0x6c0 [cifs]
     [<ffffffffa0666e3e>] ? build_path_from_dentry+0xae/0x290 [cifs]
     [<ffffffffa0673198>] ? cifs_revalidate_dentry_attr+0xf8/0x1c0 [cifs]
     [<ffffffff810eb57e>] ? from_kgid_munged+0xe/0x20
     [<ffffffff811ace3a>] ? cp_new_stat+0x13a/0x160
     [<ffffffffa067330f>] ? cifs_getattr+0x4f/0x120 [cifs]
     [<ffffffff811ac9f7>] ? vfs_fstatat+0x57/0x90
     [<ffffffff811acebd>] ? SYSC_newlstat+0x1d/0x40
     [<ffffffff8151164d>] ? system_call_fast_compare_end+0x10/0x15

This is on a Debian Jessie, with a 3.16.0-4-amd64 kernel and
mount.cifs 6.4.

The contents of /proc/fs/cifs/DebugData:

    Display Internal CIFS Data Structures for Debugging
    ---------------------------------------------------
    CIFS Version 2.03
    Features: dfs fscache lanman posix spnego xattr acl
    Active VFS Requests: 5
    Servers:
    1) entry for <ip> not fully displayed
        TCP status: 4
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 1
        Shares:
        1) \\<servername>\data Mounts: 1 Type: NTFS DevInfo: 0x60020 Attrib=
utes: 0xc700ff
        PathComponentMax: 255 Status: 0x1 type: DISK    DISCONNECTED=20

        MIDs:
        State: 2 com: 114 pid: 11094 cbdata: ffff8800c640a2d0 mid 30

    2) entry for <ip> not fully displayed
        TCP status: 1
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
        Shares:
        1) \\<servername>\user Mounts: 1 Type: NTFS DevInfo: 0x60020 Attrib=
utes: 0xc700ff
        PathComponentMax: 255 Status: 0x1 type: DISK=20

        MIDs:

After a process hung for ~10 minutes, it seems some kind of timeout
happened. One of the shares got unmounted (without anything in dmesg),
the process continued, and it's not listed in DebugData anymore.

With Windows Server 2003 this worked like a charm, and I don't see any
problems when accessing the share from Windows 7.

If there's any other information you need, please let me know!

Thanks,

Florian

--=20
http://www.the-compiler.org | me-J2duszcpOy900TDglC2tyg@public.gmane.org (Mail/XMPP)
   GPG: 916E B0C8 FD55 A072 | http://the-compiler.org/pubkey.asc
         I love long mails! | http://email.is-not-s.ms/

--=_mehl.schokokeks.org-6575-1443770696-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWDjFGAAoJEJFusMj9VaBy6TYP/2kLk9YlOGos2QGrI0sEngtJ
UnlULBAy2N1LBhpW653bwM169lypPqmuTNbsVbzNm9+R/Jj9Cc8wS6ymns3n7x/j
FpbrbqW4puxC2UGwqyrjnrpjUM/z9P8Fwv2UL4XP/TGcz3AkXOxIRiT1q9vjbwVU
1hYxLS3p416V/v7X+jgcq5S6KUmaSpJGtkfPhCETQY0LBbfKJUw1agES03Z/LIoM
YGNbzBAKMP/VsOXviDkgrCc/EEC7/tEgIvy36ahv5GOty0RQhlk7VBCcsTjT+EsX
lvH2TpYwWF2Uqdin6jEdPXoYXVyMpebAP2+p2681s9qTUPwyue9a87ZrJ/UI1x02
s1lmrSOpEoNzNt4MRJumBX97uV7C9zNzE/giIZ+vzWaI8Ja3Oc9gE3qwyLMEmys6
zpgaZGuMYsJpUbL4R4SKmRsU+EpYYkn3bQgzkKale1Wd3qrcBXZmPyjVOPHjNIGO
wEbdYpH6shpjieT+KSfW83A9242OCWXuCIBxbLkwcHpdvo3NVh09ZAGR2iiCuuF/
YZy3RipLJrvt6ZZLx5zaPxUtclLpXzTsiG3jorrOgPzsRf2tqzXhyttx4gYBlxEv
anRRcEpVsi0WQvu6mMRuhpBXBPnmUZFxEVN8Jvs+qOmpQi3EeZEDZl1EkLum/2Dv
Da7Q4uaA8+74rBpT9ZeW
=uYWv
-----END PGP SIGNATURE-----

--=_mehl.schokokeks.org-6575-1443770696-0001-2--
