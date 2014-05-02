From: =?UTF-8?B?R8O8bnRlciBLdWtrdWtr?= <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Subject: Re: character-problems
Date: Fri, 02 May 2014 04:41:03 +0200
Message-ID: <536305BF.1060201@kukkukk.com>
References: <53620CE9.10301@gmx.de>	<CAOhYWNKp1QqsebugYqM2yAqOef4yw=t9tNyUmH-9ds59pjygqw@mail.gmail.com>	<53622687.9030306@gmx.de> <CAOhYWN+PNtQ8HMyi3OFyv3KQ-bbvOKcGFNLZw5Jx2zHNdRJ1LQ@mail.gmail.com> <53622BD7.7030005@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Creutz <thomas.creutz-Mmb7MZpHnFY@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53622BD7.7030005-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Am 01.05.2014 13:11, schrieb Thomas Creutz:
>=20
> Am 01.05.2014 12:54, schrieb Jeff Layton:
>> Maybe...
>>
>> For your kernel, what is CONFIG_NLS_DEFAULT set to? I know that ubun=
tu
>> used to set that to iso9959-1, but I think they recently moved to
>> using utf8. If it's set to iso8559-1 then that may be related to the
>> problem.
>=20
> No, its not a charset problem.
>=20
> grep CONFIG_NLS_DEFAULT /boot/config-$(uname -r)
> CONFIG_NLS_DEFAULT=3D"utf8"
>=20
> because I also told, that the file names have the same problem on the
> server (uploaded over php-scripts). Some scripts use utf-8 others
> iso8...., thats why you will never see all chars right on console/sam=
ba
> client.
> But, this problem should get handelt by samba/cifs... the files are a=
lso
> useable with a windows client (so the access problem is in the cifs
> client, not the samba server)

i've tested this on clients running
   opensuse-12.3 - kernel 3.7.10-1.28-desktop
   opensuse-13.1 - kernel 3.11.10-7-desktop
samba server Version 3.6.12-59.19.1-3208-SUSE-SL12.3-x86_64
is running on opensuse-12.3.

Here i don't see that
    Kost?me1.jpg  (i really used a question mark here)
on the server is changed to
    Kost_me1.jpg
on the client.

But in fact i really can't test that sanely here, because what is reall=
y
byte coded for "?" in Kost?me1.jpg on the server?
Can you get a hex-representation of that file name?

In addition it could also help when you post your samba server's smb.co=
nf.

Cheers, G=C3=BCnter

--=20
