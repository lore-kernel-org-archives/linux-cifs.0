From: =?ISO-8859-1?Q?Sen=E9n_de_Diego?= <senen-qHrp9QoZuCS1Z/+hSey0Gg@public.gmane.org>
Subject: Re: Performance degradation with ISAM tables
Date: Sat, 15 Dec 2012 00:11:23 +0100
Message-ID: <50CBB21B.3080908@electrodh.com>
References: <50CA5C4C.60103@electrodh.com> <20121213213929.0eea2f5f@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121213213929.0eea2f5f-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

El 14/12/2012 3:39, Jeff Layton escribi=F3:
> On Thu, 13 Dec 2012 23:53:00 +0100
> Sen=E9n de Diego <senen-qHrp9QoZuCS1Z/+hSey0Gg@public.gmane.org> wrote:
>> Hello,
>> I'm executing, in a linux server, a program that reads data from dbf
>> files in a windows share. I've tried to execute the same program in =
an
>> upgraded server and I've found that it runs much much much slower.
>> These are the versions of the first (older) server:
>> kernel: 2.6.37.6-24
>> cifs.ko: 1.68
>> and of the second (newer):
>> kernel: 3.4.11-2.16
>> cifs.ko: 1.78
>> The windows machine runs windows 2000 server and has EnableOplocks
>> disabled in the LanManServer service.
>> The windows share is mounted as a cifs file system with some differe=
nces
>> in the parameters assigned by default:
>> first server: rsize=3D16384,wsize=3D57344
>> second server: sec=3Dntlm,nounix,rsize=3D61440,wsize=3D65536
>> I've captured the network traffic in both servers, and these are the
>> service response time statistics:
>> First server:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> SMB SRT Statistics:
>> Filter:
>> Commands Calls Min SRT Max SRT Avg SRT
>> Close 37 0.000140 0.001635 0.000404
>> Read AndX 11554 0.000196 0.017179 0.002099
>> Write AndX 12 0.000255 0.000657 0.000510
>> NT Create AndX 43 0.000190 0.000406 0.000237
>> Transaction2 Commands Calls Min SRT Max SRT Avg SRT
>> FIND_FIRST2 83 0.000747 0.001953 0.001735
>> FIND_NEXT2 880 0.000486 0.002885 0.001711
>> QUERY_PATH_INFO 25678 0.000170 0.005451 0.000250
>> QUERY_FILE_INFO 67 0.000169 0.000206 0.000182
>> NT Transaction Commands Calls Min SRT Max SRT Avg SRT
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> Second server:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> SMB SRT Statistics:
>> Filter:
>> Commands Calls Min SRT Max SRT Avg SRT
>> Close 118 0.000128 0.006194 0.000517
>> Trans 1 0.000872 0.000872 0.000872
>> Read AndX 3490 0.000260 0.019713 0.009729
>> Write AndX 12 0.000508 0.000522 0.000515
>> NT Create AndX 118 0.000253 0.001496 0.000342
>> Transaction2 Commands Calls Min SRT Max SRT Avg SRT
>> FIND_FIRST2 171 0.000761 0.002862 0.002404
>> FIND_NEXT2 326 0.002342 0.003058 0.002429
>> QUERY_PATH_INFO 318093 0.000168 0.041616 0.000320
>> QUERY_FILE_INFO 137 0.000235 0.002855 0.000370
>> NT Transaction Commands Calls Min SRT Max SRT Avg SRT
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> where there is a great difference in the number of calls, specially =
in
>> the number of QUERY_PATH_INFO commands executed. And the average SRT=
 are
>> also slower in the newer server.
>> I would like to know what is the cause and what can I do to correct =
this?
> The difference between those two kernel represents more than a year o=
f
> development time. The best first step you can take is to try a more
> recent kernel (like something 3.7-ish) to see if that might help.
I've tried with a 3.6.10 kernel (the last available in my distro) and=20
it's still slow:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
SMB SRT Statistics:
=46ilter:
Commands                   Calls    Min SRT    Max SRT    Avg SRT
Close                        116   0.000137   1.101347   0.009745
Trans                          3   0.000517   0.000722   0.000642
Echo                           1   0.000203   0.000203   0.000203
Read AndX                 122893   0.000206   0.154745   0.000599
Write AndX                    12   0.000253   0.005756   0.000789
NT Create AndX               118   0.000266   0.000865   0.000458

Transaction2 Commands      Calls    Min SRT    Max SRT    Avg SRT
=46IND_FIRST2                  170   0.000843   0.003413   0.002590
=46IND_NEXT2                   325   0.002373   0.006695   0.002908
QUERY_PATH_INFO           320423   0.000181   2.066630   0.000485
QUERY_FILE_INFO              135   0.000252   0.000768   0.000395

NT Transaction Commands    Calls    Min SRT    Max SRT    Avg SRT
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



> The next problem is that it's difficult for us to infer anything abou=
t
> your workload. You'll probably need to do some investigative work to
> figure out what's actually slow. In particular, if you can phrase the
> problem in terms of particular syscalls being slower, then we might b=
e
> able to help you more.
> Even better is to come up with a small reproducer program that
> demonstrates the slowdown.
The file access is done by a proprietary jdbc driver inside a jvm. I re=
ally don't know how to do what you suggest. The SMB service response ti=
me statitics are all I've got.
