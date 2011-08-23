From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] autoconf: fix help message for --enable-cifsidmap
Date: Tue, 23 Aug 2011 11:38:17 -0500
Message-ID: <CADT32eL=DLMT0V-HR=AJfLAYLFAuaZtAbqJ7Z=AFNcMMR+_P_A@mail.gmail.com>
References: <1314104603-3941-1-git-send-email-jlayton@samba.org>
	<20110823182106.163416ro6niegbci@rozijn.ugent.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	pipping-N9AOi2cAC9ZBDgjK7y7TUQ@public.gmane.org
To: Luk Claes <Luk.Claes-Cru1EgDzd7c@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110823182106.163416ro6niegbci-e9H6qYbevPUmCttN7JqJIg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Aug 23, 2011 at 11:21 AM, Luk Claes <Luk.Claes-Cru1EgDzd7c@public.gmane.org> wrote:
> Hi Jeff
>
> Hmm, I thought it's auto as default which would only be yes if the ne=
eded
> headers and libraries are installed?
>
> Cheers
>
> Luk
>
> Quoting "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>
>> It currently says "no" is the default, but it should be "yes".
>>
>> Reported-by: Elias Pipping <pipping-N9AOi2cAC9ZBDgjK7y7TUQ@public.gmane.org>
>> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>> =A0configure.ac | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/configure.ac b/configure.ac
>> index 780abe7..6a9ad75 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -24,7 +24,7 @@ AC_ARG_ENABLE(cifscreds,
>>
>> =A0AC_ARG_ENABLE(cifsidmap,
>> =A0 =A0 =A0 =A0[AC_HELP_STRING([--enable-cifsidmap],
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [Create cifs.idmap bin=
ary @<:@default=3Dno@:>@])],
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [Create cifs.idmap bin=
ary @<:@default=3Dyes@:>@])],
>> =A0 =A0 =A0 =A0enable_cifsidmap=3D$enableval,
>> =A0 =A0 =A0 =A0enable_cifsidmap=3D"maybe")
>>
>> --
>> 1.7.6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- =
--
> Luk Claes =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0e-mail: Luk.Claes-Uy3+E7BMiTU@public.gmane.org
> Directie ICT =A0 =A0 =A0Afdeling ICT-Infrastructuur =A0 =A0 =A0 =A0 =A0=
 =A0Groep Systemen
> Universiteit Gent =A0 =A0 =A0tel: +32 9 264 96 35 =A0 =A0 =A0 =A0 fax=
: +32 9 264 4994
> Krijgslaan 281, gebouw S9, 9000 Gent, Belgie =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 www.UGent.be
> -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- =
--
>
>

I think yes would also mean auto (automatic) because you build
cifs.idmap automatically if this configure option is not specified?
That is the default and that is what configure --help is telling!

Regards,

Shirish
