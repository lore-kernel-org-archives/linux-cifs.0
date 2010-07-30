From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: document 'fsc' mount option
Date: Fri, 30 Jul 2010 15:19:14 +0530
Message-ID: <4C52A01A.4090408@suse.de>
References: <4C4EE408.7070109@suse.de>	<20100727103313.4b730ea8@tlielax.poochiereds.net>	<AANLkTina2EyHkrgNAcrY8ZRK=fXQS71dekWc+kOA0+mz@mail.gmail.com>	<20100727111517.4fe0859e@tlielax.poochiereds.net>	<AANLkTik9JqtqAtKJQsaQR8aC8s0kwmrcU=_=QQei7U07@mail.gmail.com>	<4C4F0A71.8020908@suse.de> <AANLkTi=+Y1XdFCT1UfWZW==qusXfs6t-vxa_CYo03TTT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=+Y1XdFCT1UfWZW==qusXfs6t-vxa_CYo03TTT-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/27/2010 10:08 PM, Steve French wrote:
> On Tue, Jul 27, 2010 at 11:33 AM, Suresh Jayaraman <sjayaraman@suse.d=
e> wrote:
>> On 07/27/2010 08:51 PM, Steve French wrote:
>>> scripts/extract-ikconfig could be run against the image (or look at
>>> /proc/config.gz) - but unless there is an easier way to view kernel
>>> config options on particular distros via distro specific tools -
>>> probably easier just to note that CONFIG_FSCACHE must be selected i=
n
>>> the kernel build (since it forces dependencies on the other kernel
>>> options being set)
>>
>> Does something like
>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD$zcat /proc/config.gz | grep =
CONFIG_CIFS_FSCACHE
>>
>> might work on all distros?
>>
>> But, Jeff's idea of having a features file in /proc sounds good. Apa=
rt
>> from using them as a reference to check in documentation, it could b=
e a
>> useful information while collecting debugging output as well..?
>=20
> Seems reasonable - but wondering if other file systems have run into =
the same
> problem - how to view their build/config options - and how they have
> solved it (if at all) so ccing fsdevel
>=20

I just checked some of the other filesystems. Most of them just mention
the CONFIG_XXX option has to be set/enabled.

=46or e.g.

(1) Mount options for jfs

iocharset=3Dname
	...
	This requires CONFIG_NLS_UTF8 to be set in the kernel .config
file.

(2) Mount options for tmpfs

mpol=3D[default|prefer:Node|bind:NodeList|interleave|interleave:NodeLis=
t]
	Set the NUMA  memory  allocation  policy  for  all  files  in  that
instance  (if  the  kernel  CONFIG_NUMA  is enabled) ...


Thanks,

--=20
Suresh Jayaraman
