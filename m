From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: document 'fsc' mount option
Date: Tue, 27 Jul 2010 10:21:51 -0500
Message-ID: <AANLkTik9JqtqAtKJQsaQR8aC8s0kwmrcU=_=QQei7U07@mail.gmail.com>
References: <4C4EE408.7070109@suse.de>
	<20100727103313.4b730ea8@tlielax.poochiereds.net>
	<AANLkTina2EyHkrgNAcrY8ZRK=fXQS71dekWc+kOA0+mz@mail.gmail.com>
	<20100727111517.4fe0859e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100727111517.4fe0859e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

scripts/extract-ikconfig could be run against the image (or look at
/proc/config.gz) - but unless there is an easier way to view kernel
config options on particular distros via distro specific tools -
probably easier just to note that CONFIG_FSCACHE must be selected in
the kernel build (since it forces dependencies on the other kernel
options being set)

On Tue, Jul 27, 2010 at 10:15 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Tue, 27 Jul 2010 10:13:14 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Yes - I agree with Jeff, need to add the mention of the config optio=
n
>> and perhaps how to tell if fsc feature is available in kernel.
>>
>
> How would one tell? :)
>
>> On Tue, Jul 27, 2010 at 9:33 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > On Tue, 27 Jul 2010 19:20:00 +0530
>> > Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>> >
>> >> Document the newly added local caching feature using FS-Cache. Th=
is patch
>> >> could be queued and considered once the local caching patches get=
s merged
>> >> upstream.
>> >>
>> >> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> >> ---
>> >> =A0doc/mount.cifs.8.xml | =A0 17 +++++++++++++++++
>> >> =A01 files changed, 17 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/doc/mount.cifs.8.xml b/doc/mount.cifs.8.xml
>> >> index 4937550..2200746 100644
>> >> --- a/doc/mount.cifs.8.xml
>> >> +++ b/doc/mount.cifs.8.xml
>> >> @@ -534,6 +534,23 @@ permissions in memory that can't be stored o=
n the server. This information can d
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0maximum wsize currently allowe=
d by CIFS is 57344 (fourteen
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A04096 byte pages)</para></listi=
tem>
>> >> =A0 =A0 =A0 </varlistentry>
>> >> + =A0 =A0 <varlistentry>
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 <term>fsc</term>
>> >> +
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 <listitem><para>Enable local disk cachi=
ng using FS-Cache
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 for cifs. This option could be useful t=
o improve performance
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 on a slow link, heavily loaded server a=
nd/or network
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 where reading from the disk is faster t=
han reading from the
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 server (over the network). This could a=
lso impact the
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 scalability positively as the number of=
 calls to the server
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 are reduced. But, be warned that local =
caching is not suitable
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 for all workloads, for e.g., read-once =
type workloads. So
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 you need to consider carefully the situ=
ation/workload before
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 using this option.
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 NOTE: You also need to have cachefilesd=
 daemon installed and
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 running to make the cache operational.
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0</para></listitem>
>> >> + =A0 =A0 </varlistentry>
>> >
>> > You may want to mention somewhere that this is only available in r=
ecent
>> > kernels that have been built with fsc turned on.
>> >
>> > Other than that, this and the mount.cifs patch look fine and I'll =
plan
>> > to commit them before the upcoming 4.6 release.
>> >
>> >> =A0 =A0 =A0 =A0<varlistentry>
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0<term>--verbose</term>
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0<listitem><para>Print addition=
al debugging information for the mount. Note that this parameter must b=
e specified before the -o. For example:</para><para>mount -t cifs //ser=
ver/share /mnt --verbose -o user=3Dusername</para></listitem>
>> >
>> > --
>> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >
>>
>>
>>
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
