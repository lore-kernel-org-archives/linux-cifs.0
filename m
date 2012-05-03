From: Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Use mkstemp instead of mktemp
Date: Thu, 3 May 2012 10:16:35 +0200
Message-ID: <CA+EOSB=ZEMDj3z=_EbCZTnyojczhg24T2KSQbjX=_z3sbysFKg@mail.gmail.com>
References: <1335539568-32024-1-git-send-email-gitter.spiros@gmail.com>
	<20120428071454.011adbda@tlielax.poochiereds.net>
	<CA+EOSB=O=jeSgoTfMuLoxOgJW3bjw4TsxLv0YQ6HW6w12TPjgA@mail.gmail.com>
	<20120502134737.2d7684ee@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120502134737.2d7684ee-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/2 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Wed, 2 May 2012 18:40:05 +0200
> Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2012/4/28 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> > On Fri, 27 Apr 2012 11:12:48 -0400
>> > Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >
>> > Looks like you're still setting the umask to 0077 here?
>> I am sorry for the long delay.
>>
>>
>> For the umask yes, it was my bad, sorry.
>> >
>> >> + =A0 =A0 if (close(mkstemp(mtabtmpfile)) =3D=3D -1 ) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "del_mt=
ab: cannot setup tmp file destination");
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void)umask(mode);
>> >
>> > You probably don't really need to reset the umask on error, but I =
guess
>> > it doesn't really hurt...
>> >
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D EX_FILEIO;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto del_mtab_exit;
>> >> =A0 =A0 =A0 }
>> >> + =A0 =A0 (void)umask(mode);
>> >>
>> >> =A0 =A0 =A0 mntmtab =3D setmntent(MOUNTED, "r");
>> >> =A0 =A0 =A0 if (!mntmtab) {
>> >
>> > Now that I look at that us-cert page though, I'm not sure you're r=
eally
>> > making anything safer with this patch...
>> >
>> > AFAICT, the thing that makes mkstemp safer than mktemp is the fact=
 that
>> > the filename generation and open are atomic. If you use mkstemp he=
re
>> > and then just close the file afterward, aren't you still subject t=
o the
>> > same set of races that you are with mktemp?
>> >
>> > In fact, it seems like this is even worse, really. With this, you'=
re
>> > creating the file and then reopening it. Within that window of tim=
e,
>> > an attacker now has some idea of what file you plan to use here
>> > whereas he didn't really before...
>> >
>> > I think what might be better is to continue to use mktemp, but do =
the
>> > setmntent call with a type value of "wx" to make it use an exclusi=
ve
>> > open. If that fails with EEXIST, we should call mktemp again and t=
ry
>> > again until it succeeds. Of course, not all libc's will take "x" a=
s an
>> > arg there, so you may need an autoconf test to verify that that wi=
ll
>> > work...
>> >
>> > An alternate approach might be to use mkstemp and fdopen, and then
>> > simply use the resulting FILE pointer in the addmntent calls. From=
 a
>> > quick look at glibc, it looks like setmntent is basically a wrappe=
r
>> > around fopen anyway, but that may not be universally true in all
>> > libc's. Hmm...now that I look though, glibc extends the fopen mode=
 with
>> > "ce" too and you'd probably want to do the same. So you might stil=
l
>> > need an autoconf test for that anyway...
>> >
>> > Either way, this code should probably be moved to a separate helpe=
r
>> > function that does this for del_mtab instead of open-coding it the=
re.
>> >
>> I agree with your analisys. The simple patch was only a standard way
>> to get rid of a compiler warn
>> of the use of mktemp, but in this case the technique is not correct.
>>
>> What is more, I am reasonably sure that these days del_mtab in linux
>> cifs util it is no longer called anymore, and perhaps it would be be=
st
>> to drop the
>> code all together. Opinions ?
>>
>
> I haven't seen a compiler warning from this. What compiler are you
> using and with what options?
Hello. See below

gcc -DHAVE_CONFIG_H -I.    -Wall -Wextra -Werror -D_FORTIFY_SOURCE=3D2
-g -O2 -MT mount.cifs.o -MD -MP -MF .deps/mount.cifs.Tpo -c -o
mount.cifs.o mount.cifs.c
mv -f .deps/mount.cifs.Tpo .deps/mount.cifs.Po
gcc -Wall -Wextra -Werror -D_FORTIFY_SOURCE=3D2 -g -O2   -o mount.cifs
mount.cifs.o mtab.o resolve_host.o util.o  -lcap-ng -lrt
mount.cifs.o: In function `del_mtab':
/home/machbuild/proj/cifs-utils/mount.cifs.c:1655: warning: the use of
`mktemp' is dangerous, better use `mkstemp'
make[2]: Leaving directory `/home/machbuild/proj/cifs-utils'
make[1]: Leaving directory `/home/machbuild/proj/cifs-utils'
[root@esil231 cifs-utils]# gcc --version
gcc (GCC) 4.5.1 20100924 (Red Hat 4.5.1-4)
Copyright (C) 2010 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is=
 NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURP=
OSE.

[root@esil231 cifs-utils]# ls -l /etc/mtab
-rw-r--r--. 1 root root 386 2012-05-03 09:40 /etc/mtab

This is a old FC12. del_mtab was introduced by commit  id
f46dd7661cfb87257c95081fc2071c934bfbbb16

commit f46dd7661cfb87257c95081fc2071c934bfbbb16
Author: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Mon Jan 16 12:29:49 2012 -0500

    mount.cifs: Properly update mtab during remount

    During a remount of a cifs filesystem, the mtab file is not properl=
y
    updated, which leads to a doubled entry of the same filesystem in t=
he
    /etc/mtab file.  This patch adds a new function del_mtab() which is
    called before the add_mtab() in case the fs is being remounted.

In fact del_mtab it is only called by mount(8), or mount.cifs, in a
remount phase(i was wrong when i have told that it is not used
anymore, sorry).

So, to get rid of this warning, i have to do a better patch. Thanks







>
> It's correct that it's not called when /etc/mtab is a symlink and a l=
ot
> of distros are doing that these days. But, people can and do use this
> on older distros that have a real mtab, so I wouldn't be comfortable
> removing that code outright.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
