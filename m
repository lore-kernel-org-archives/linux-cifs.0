From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: Intermittent file corruption problems with cifs driver?
Date: Mon, 12 Sep 2011 07:29:26 -0500
Message-ID: <CAH2r5mumMQEG57BDP3PSsx42N_51hf7_HbcSVHYy2O0LR=FVUA@mail.gmail.com>
References: <20110912083654.GA3338@cobija.connexer.com>
	<CAH2r5msrRGT+aMZw8shNRNzbQqfGo8Ba2RHBhUtXznNRvRyykQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msrRGT+aMZw8shNRNzbQqfGo8Ba2RHBhUtXznNRvRyykQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Sep 12, 2011 at 3:36 AM, sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org> wrot=
e:
>
> Hi all,
>
> Recently at $customer I've been tasked into looking into a problem th=
ey
> are intermittently having with corrupt file transfers from linux serv=
ers
> to a windows share.
>
> Little info on the servers:
>
> =A0 =A0 =A0 =A0Ubuntu Lucid 10.04
> =A0 =A0 =A0 =A0Stock and up to date Linux 2.6.32-33-server distro pac=
kage
> =A0 =A0 =A0 =A0Stock cifs-utils 4.5-2 packages
>
> Description of behavior:
>
> =A0 =A0 =A0 =A0The servers are all part of a distributed service wher=
e each server
> =A0 =A0 =A0 =A0regularly uploads 100-200MB zipfiles to the windows sh=
are. =A0Intermittently
> =A0 =A0 =A0 =A0the resulting files will be corrupted. =A0On the clien=
t that performs
> =A0 =A0 =A0 =A0the upload, the corrupted file will appear to have the=
 correct checksum,
> =A0 =A0 =A0 =A0but any other remote client will see it as corrupted.
>
> =A0 =A0 =A0 =A0The problem used to be much more frequent, and mountin=
g with -o directio
> =A0 =A0 =A0 =A0seems to have greatly reduced, but not eliminated, the=
 recurrence of the
> =A0 =A0 =A0 =A0corruption. =A0But recently (perhaps due to higher rea=
tes of uploads?),
> =A0 =A0 =A0 =A0the problem has started recurring. =A0It doesn't seem =
uniformly occuring,
> =A0 =A0 =A0 =A0but rather in spurts where a couple files will be corr=
upted in one day,
> =A0 =A0 =A0 =A0and then a week will go by with no corruptions.
>
> =A0 =A0 =A0 =A0I do see occasional errors in the kernel logs, though =
I'm not sure if
> =A0 =A0 =A0 =A0they are relevant or not (note that they're at substan=
tially different
> =A0 =A0 =A0 =A0times, and at present I have no way to correlate them =
with corruption,
> =A0 =A0 =A0 =A0though I'm working on that):
>
> =A0 =A0 =A0 =A0[170873.721023] =A0CIFS VFS: Error -104 sending data o=
n socket to server
> =A0 =A0 =A0 =A0[170873.728747] =A0CIFS VFS: Error -32 sending data on=
 socket to server
> =A0 =A0 =A0 =A0[515039.940104] =A0CIFS VFS: No response to cmd 115 mi=
d 32714
> =A0 =A0 =A0 =A0[515039.947933] =A0CIFS VFS: Send error in SessSetup =3D=
 -11
> =A0 =A0 =A0 =A0[521901.595381] =A0CIFS VFS: No response to cmd 46 mid=
 37426
> =A0 =A0 =A0 =A0[521901.603422] =A0CIFS VFS: Send error in read =3D -1=
1
> =A0 =A0 =A0 =A0[2097744.571138] =A0CIFS VFS: No response for cmd 50 m=
id 48502
> =A0 =A0 =A0 =A0[2097849.771138] =A0CIFS VFS: No response for cmd 114 =
mid 48519


With log entries like the above, the probability of having a file fail =
to copy
is high (although I would expect it more with command 47 (SMB WriteAndX=
,
but presumably if you get an error reading (command 46) you will
also have the copy fail - depending on how the application handles
such errors).

The reconnection/retry behavior is much better in more current cifs,
especially when servers are sometimes very slow (as we saw
in clustered servers during occassional operations when cluster
overhead could cause > 15 second delays).=A0=A0 If the server
is taking greater than 15 seconds or so from time to time
(or as we see here with rc 104, if the server
or network randomly drops the connection), I would expect
big improvements in 2.6.39 or later (or equivalent
backport as some of the distros have done).

Disabling unix extensions (mount option "nounix") is
only going to make a difference to Samba and similar servers,
but I would not expect it to have an effect on this problem.
mounting "forcedirectio" could have an effect though as it
1) changes i/o sizes to more closely match the application
(since the cache is not being used)
2) allows the application to get errors on writes more
quickly (since some applications forget to check errors
on fsync or close, and expect write errors on the actual write)

>
> Reading through the archives along with the rest of teh internetz I'v=
e found
> very little info. =A0Someone posted here back in february about a sim=
ilar
> sounding problem, though I do not see the wsize-len blocks of NULL by=
tes in
> the resulting files like they did.
>
> I've written a small python script that right now is running on a pai=
r of
> these servers, which with a couple dozen threads is uploading similar=
ly sized
> files of arbitrary data, and comparing the upload results of each oth=
er.
> after a few hours I haven't seen it yet, but will keep it runnign for
> a couple days to see if it shows up.
>
> I've also found a couple suggestions out there to "disable linux
> extensions" and "disable oplocks" when searching on the above kernel =
error
> messages, but am hesitant to try them unless there's a strong indicat=
ion
> that they will help, and i'm not entirely sure if/whether they will.
>
>
> does this ring a bell with anyone? =A0at this point i can't just do a
> blanket "try the latest" upgrade of these servers because they're par=
t
> of a production application, at least without any further indication =
that
> there was a fix for this problem between the current and latest versi=
ons.
> If I can repro the problem, however, and can then take it to a non-pr=
od
> machine, then I might have a bit more flexibility, but in the meantim=
e
> thought I'd field the question here on the off chance...
>
>
> thanks!
> =A0 =A0 =A0 =A0sean
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
Thanks,

Steve



--
Thanks,

Steve
