From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Performance degradation with ISAM tables
Date: Thu, 13 Dec 2012 21:39:29 -0500
Message-ID: <20121213213929.0eea2f5f@corrin.poochiereds.net>
References: <50CA5C4C.60103@electrodh.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?B?U2Vu6W4=?= de Diego <senen-qHrp9QoZuCS1Z/+hSey0Gg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50CA5C4C.60103-qHrp9QoZuCS1Z/+hSey0Gg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 13 Dec 2012 23:53:00 +0100
Sen=E9n de Diego <senen-qHrp9QoZuCS1Z/+hSey0Gg@public.gmane.org> wrote:

> Hello,
>=20
> I'm executing, in a linux server, a program that reads data from dbf=20
> files in a windows share. I've tried to execute the same program in a=
n=20
> upgraded server and I've found that it runs much much much slower.
>=20
> These are the versions of the first (older) server:
> kernel: 2.6.37.6-24
> cifs.ko: 1.68
>=20
> and of the second (newer):
> kernel: 3.4.11-2.16
> cifs.ko: 1.78
>=20
> The windows machine runs windows 2000 server and has EnableOplocks=20
> disabled in the LanManServer service.
>=20
> The windows share is mounted as a cifs file system with some differen=
ces=20
> in the parameters assigned by default:
> first server: rsize=3D16384,wsize=3D57344
> second server: sec=3Dntlm,nounix,rsize=3D61440,wsize=3D65536
>=20
> I've captured the network traffic in both servers, and these are the=20
> service response time statistics:
>=20
> First server:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> SMB SRT Statistics:
> Filter:
> Commands                   Calls    Min SRT    Max SRT    Avg SRT
> Close                         37   0.000140   0.001635   0.000404
> Read AndX                  11554   0.000196   0.017179   0.002099
> Write AndX                    12   0.000255   0.000657   0.000510
> NT Create AndX                43   0.000190   0.000406   0.000237
>=20
> Transaction2 Commands      Calls    Min SRT    Max SRT    Avg SRT
> FIND_FIRST2                   83   0.000747   0.001953   0.001735
> FIND_NEXT2                   880   0.000486   0.002885   0.001711
> QUERY_PATH_INFO            25678   0.000170   0.005451   0.000250
> QUERY_FILE_INFO               67   0.000169   0.000206   0.000182
>=20
> NT Transaction Commands    Calls    Min SRT    Max SRT    Avg SRT
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Second server:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> SMB SRT Statistics:
> Filter:
> Commands                   Calls    Min SRT    Max SRT    Avg SRT
> Close                        118   0.000128   0.006194   0.000517
> Trans                          1   0.000872   0.000872   0.000872
> Read AndX                   3490   0.000260   0.019713   0.009729
> Write AndX                    12   0.000508   0.000522   0.000515
> NT Create AndX               118   0.000253   0.001496   0.000342
>=20
> Transaction2 Commands      Calls    Min SRT    Max SRT    Avg SRT
> FIND_FIRST2                  171   0.000761   0.002862   0.002404
> FIND_NEXT2                   326   0.002342   0.003058   0.002429
> QUERY_PATH_INFO           318093   0.000168   0.041616   0.000320
> QUERY_FILE_INFO              137   0.000235   0.002855   0.000370
>=20
> NT Transaction Commands    Calls    Min SRT    Max SRT    Avg SRT
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> where there is a great difference in the number of calls, specially i=
n=20
> the number of QUERY_PATH_INFO commands executed. And the average SRT =
are=20
> also slower in the newer server.
>=20
> I would like to know what is the cause and what can I do to correct t=
his?
>=20
>=20

The difference between those two kernel represents more than a year of
development time. The best first step you can take is to try a more
recent kernel (like something 3.7-ish) to see if that might help.

The next problem is that it's difficult for us to infer anything about
your workload. You'll probably need to do some investigative work to
figure out what's actually slow. In particular, if you can phrase the
problem in terms of particular syscalls being slower, then we might be
able to help you more.

Even better is to come up with a small reproducer program that
demonstrates the slowdown.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
