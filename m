From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 00/09] cifs: local caching support using FS-Cache
Date: Thu, 22 Jul 2010 14:58:49 +0530
Message-ID: <4C480F51.8070204@suse.de>
References: <1278333663-30464-1-git-send-email-sjayaraman@suse.de>	<4C3DF6BF.3070001@gmail.com> <AANLkTin2tKtkWTflrrzBMYBEd6SFr35uYUl1SmfYlj9W@mail.gmail.com> <4C3F35F7.8060408@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C3F35F7.8060408-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/15/2010 09:53 PM, Suresh Jayaraman wrote:
> On 07/14/2010 08:09 PM, Steve French wrote:
>> On Wed, Jul 14, 2010 at 12:41 PM, Scott Lovenberg
>> <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On 7/5/2010 8:41 AM, Suresh Jayaraman wrote:
>>>>
>>>> This patchset is a second try at adding persistent, local caching =
facility
>>>> for
>>>> CIFS using the FS-Cache interface.
>>>>
>>>>
>>>
>>> Just wondering, have you bench marked this at all? =EF=BF=BDI'd be =
interested to see
>>> how this compares (performance and scaling) to an oplock-centric de=
sign.
>>>
>=20
> Yes, I have done a few performance benchmarks with the cifs client (a=
nd
> not SMB2) and I'll post them early nextweek when I'm back (as I'm
> travelling now).
>=20

Here are some results from my benchmarking:

Environment
------------

I'm using my T60p laptop as the CIFS server (running Samba) and one of
my test machines as CIFS client, connected over an ethernet of reported
speed 1000 Mb/s. The TCP bandwidth as seen by a pair of netcats between
the client and the server is about 786.24 Mb/s.

Client has a 2.8 GHz Pentium D CPU with 2GB RAM
Server has a 2.33GHz Core2 CPU (T7600) with 2GB RAM


Test
-----
The benchmark involves pulling a 200 MB file over CIFS to the client
using cat to /dev/zero under `time'. The wall clock time reported was
recorded.

Note
----
   - The client was rebooted after each test, but the server was not.
   - The entire file was loaded into RAM on the server before each test
     to eliminate disk I/O latencies on that end.
   - A seperate partition of size 4GB has been dedicated for the cache.
   - There were no other CIFS client that was accessing the Server when
     the tests were performed.


=46irst, the test was run on the server twice and the second result was
recorded (noted as Server below).

Secondly, the client was rebooted and the test was run with cachefiled
not running and was recorded (noted as None below).

Next, the client was rebooted, the cache contents (if any) were erased
with mkfs.ext3 and test was run again with cachefilesd running (noted a=
s
COLD)

Next the client was rebooted, tests were run with cachefilesd running
this time with a populated cache (noted as HOT).

=46inally, the test was run again without unmounting, stopping cachefil=
ed
or rebooting to ensure pagecache is valid (noted as PGCACHE).

The benchmark was repeated twice:

Cache (state)	Run #1		Run#2
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D		=3D=3D=3D=
=3D=3D=3D=3D
Server		0.107 s		0.090 s
None		6.497 s		6.440 s
COLD		6.707 s		6.635 s
HOT		5.286 s		5.078 s
PGCACHE		0.090 s		0.091 s

As it can been seen, the performance while reading when data is cache
hot (disk) is not great as the network link is a Gigabit ethernet (with
server having working set in memory) which is mostly expected. (I could
not get access to a slower network (say 100 Mb/s) where the real
performance boost could be evident).


Thanks,


--=20
Suresh Jayaraman
