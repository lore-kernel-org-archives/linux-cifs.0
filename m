From: Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Use mkstemp instead of mktemp
Date: Wed, 2 May 2012 18:40:05 +0200
Message-ID: <CA+EOSB=O=jeSgoTfMuLoxOgJW3bjw4TsxLv0YQ6HW6w12TPjgA@mail.gmail.com>
References: <1335539568-32024-1-git-send-email-gitter.spiros@gmail.com>
	<20120428071454.011adbda@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120428071454.011adbda-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/4/28 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Fri, 27 Apr 2012 11:12:48 -0400
> Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>
> Looks like you're still setting the umask to 0077 here?
I am sorry for the long delay.


=46or the umask yes, it was my bad, sorry.
>
>> + =A0 =A0 if (close(mkstemp(mtabtmpfile)) =3D=3D -1 ) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "del_mtab:=
 cannot setup tmp file destination");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void)umask(mode);
>
> You probably don't really need to reset the umask on error, but I gue=
ss
> it doesn't really hurt...
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D EX_FILEIO;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto del_mtab_exit;
>> =A0 =A0 =A0 }
>> + =A0 =A0 (void)umask(mode);
>>
>> =A0 =A0 =A0 mntmtab =3D setmntent(MOUNTED, "r");
>> =A0 =A0 =A0 if (!mntmtab) {
>
> Now that I look at that us-cert page though, I'm not sure you're real=
ly
> making anything safer with this patch...
>
> AFAICT, the thing that makes mkstemp safer than mktemp is the fact th=
at
> the filename generation and open are atomic. If you use mkstemp here
> and then just close the file afterward, aren't you still subject to t=
he
> same set of races that you are with mktemp?
>
> In fact, it seems like this is even worse, really. With this, you're
> creating the file and then reopening it. Within that window of time,
> an attacker now has some idea of what file you plan to use here
> whereas he didn't really before...
>
> I think what might be better is to continue to use mktemp, but do the
> setmntent call with a type value of "wx" to make it use an exclusive
> open. If that fails with EEXIST, we should call mktemp again and try
> again until it succeeds. Of course, not all libc's will take "x" as a=
n
> arg there, so you may need an autoconf test to verify that that will
> work...
>
> An alternate approach might be to use mkstemp and fdopen, and then
> simply use the resulting FILE pointer in the addmntent calls. From a
> quick look at glibc, it looks like setmntent is basically a wrapper
> around fopen anyway, but that may not be universally true in all
> libc's. Hmm...now that I look though, glibc extends the fopen mode wi=
th
> "ce" too and you'd probably want to do the same. So you might still
> need an autoconf test for that anyway...
>
> Either way, this code should probably be moved to a separate helper
> function that does this for del_mtab instead of open-coding it there.
>
I agree with your analisys. The simple patch was only a standard way
to get rid of a compiler warn
of the use of mktemp, but in this case the technique is not correct.

What is more, I am reasonably sure that these days del_mtab in linux
cifs util it is no longer called anymore, and perhaps it would be best
to drop the
code all together. Opinions ?

Best regards
