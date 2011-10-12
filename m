From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] cifs: warn about deprecation of
 /proc/fs/cifs/OplockEnabled interface
Date: Wed, 12 Oct 2011 17:52:14 -0500
Message-ID: <CAH2r5ms5QbKiwTzjTbNBrQgpe=E68jd6xhoNJ32kCdvp7UK+Kw@mail.gmail.com>
References: <4E953201.9060606@suse.com>
	<CAH2r5mub6MNsq84pCHb048KQJs8QQucUWARropbQ8nh5DgL=uQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mub6MNsq84pCHb048KQJs8QQucUWARropbQ8nh5DgL=uQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Minor clarification - the readme mentions

	/proc/module/cifs/parameters/<param>

i.e. echo "value" > /proc/module/cifs/parameters/<param>

but in my system they are under /sys/module/....  not /proc/module/....

On Wed, Oct 12, 2011 at 5:44 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> Shouldn't we note /sys/module/cifs/parameters/echo_retries in the
> message and the readme (since changing at runtime, e.g. to work aroun=
d
> a server bug temporarily, is probably more common that at module
> install time). =A0I will probably make a minor update to the readme t=
o
> note this if it is not in the patch, but not sure about the printk.
>
> On Wed, Oct 12, 2011 at 1:21 AM, Suresh Jayaraman <sjayaraman-WDPRK7U/wSs@public.gmane.org=
m> wrote:
>> The plan is to deprecate this interface by kernel version 3.4.
>>
>> Changes since v1
>> =A0 - add a '\n' to the printk.
>>
>> Reported-by: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
>> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>> ---
>> =A0fs/cifs/cifs_debug.c | =A0 =A03 +++
>> =A01 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
>> index 2fe3cf1..831fe13 100644
>> --- a/fs/cifs/cifs_debug.c
>> +++ b/fs/cifs/cifs_debug.c
>> @@ -526,6 +526,9 @@ static ssize_t cifs_oplock_proc_write(struct fil=
e *file,
>> =A0 =A0 =A0 =A0char c;
>> =A0 =A0 =A0 =A0int rc;
>>
>> + =A0 =A0 =A0 printk(KERN_WARNING "CIFS: The /proc/fs/cifs/OplockEna=
bled interface "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0"will be removed in kernel version 3.4.=
 Please migrate to "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0"using the 'enable_oplocks' module para=
meter in cifs.ko.\n");
>> =A0 =A0 =A0 =A0rc =3D get_user(c, buffer);
>> =A0 =A0 =A0 =A0if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>>
>
>
>
> --
> Thanks,
>
> Steve
>



--=20
Thanks,

Steve
