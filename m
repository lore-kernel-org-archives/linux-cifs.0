From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Fix number parsing in cifs_parse_mount_options
Date: Fri, 13 Apr 2012 10:03:59 -0500
Message-ID: <CAH2r5msNa-2m4nXgtzvrpN65pUbktwZtBFYu8WJikkpZxs7ZUg@mail.gmail.com>
References: <201204130712.51693.chris2553@googlemail.com>
	<1334322272.2308.1.camel@localhost>
	<20120413091753.60dccc93@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120413091753.60dccc93-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged

On Fri, Apr 13, 2012 at 8:17 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, 13 Apr 2012 14:04:32 +0100
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> The function kstrtoul() used to parse number strings in the mount
>> option parser is set to expect a base 10 number . This treats the oc=
tal
>> numbers passed for mount options such as file_mode as base10 numbers
>> leading to incorrect behavior.
>>
>> Change the 'base' argument passed to kstrtoul from 10 to 0 to
>> allow it to auto-detect the base of the number passed.
>>
>> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Reported-by: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
>>
>> ---
>> =A0fs/cifs/connect.c | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 6a86f3d..f31dc9a 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -1123,7 +1123,7 @@ static int get_option_ul(substring_t args[], u=
nsigned long *option)
>> =A0 =A0 =A0 string =3D match_strdup(args);
>> =A0 =A0 =A0 if (string =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> - =A0 =A0 rc =3D kstrtoul(string, 10, option);
>> + =A0 =A0 rc =3D kstrtoul(string, 0, option);
>> =A0 =A0 =A0 kfree(string);
>>
>> =A0 =A0 =A0 return rc;
>
> Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
