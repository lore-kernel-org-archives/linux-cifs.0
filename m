From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Correct comment about domainname length
Date: Mon, 29 Jul 2013 14:05:43 -0400
Message-ID: <CAFB9KM04Y4H6Se_FT6NXEBJ-b2y7Xz5Oofged9k81fmfAJqYPw@mail.gmail.com>
References: <1374777285-25639-1-git-send-email-scott.lovenberg@gmail.com>
	<1374777285-25639-2-git-send-email-scott.lovenberg@gmail.com>
	<51F1C564.5070006@asianux.com>
	<CAFB9KM2zF9m4Y4vcDRkZpMfvWP8NQWYKQTeJTiwgVVVu=4M6Cw@mail.gmail.com>
	<51F5B708.4090404@asianux.com>
	<CACyXjPxffbb8VQ55mCWTCP-GDivijXVkHNwtkVTwgAmi1XMyQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>,
	"sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPxffbb8VQ55mCWTCP-GDivijXVkHNwtkVTwgAmi1XMyQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Jul 28, 2013 at 8:36 PM, Richard Sharpe
<realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Jul 28, 2013 at 5:27 PM, Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org> wr=
ote:
>> On 07/27/2013 02:12 AM, Scott Lovenberg wrote:
>>> On Thu, Jul 25, 2013 at 8:40 PM, Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org> =
wrote:
>>>> On 07/26/2013 02:34 AM, scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>>>>> From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>>
>>>>> CIFS_MAX_DOMAINNAME_LEN is the max length for a domain name, not =
a fully qualified domain name.
>>>>>
>>>>> Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>> ---
>>>>>  include/uapi/linux/cifs/cifs_mount.h | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/include/uapi/linux/cifs/cifs_mount.h b/include/uapi/=
linux/cifs/cifs_mount.h
>>>>> index a58fc6e..d2408ec 100644
>>>>> --- a/include/uapi/linux/cifs/cifs_mount.h
>>>>> +++ b/include/uapi/linux/cifs/cifs_mount.h
>>>>> @@ -17,7 +17,7 @@
>>>>>  #define _CIFS_MOUNT_H
>>>>>
>>>>>  /* Max string lengths for cifs mounting options. */
>>>>> -#define CIFS_MAX_DOMAINNAME_LEN 256 /* max fully qualified domai=
n name */
>>>>> +#define CIFS_MAX_DOMAINNAME_LEN 256 /* max domain name length */
>>>>>  #define CIFS_MAX_USERNAME_LEN   256 /* reasonable max for curren=
t servers */
>>>>>  #define CIFS_MAX_PASSWORD_LEN   512 /* Windows max seems to be 2=
56 wide chars */
>>>>>  #define CIFS_MAX_SHARE_LEN      256 /* reasonable max share name=
 length */
>>>>>
>>>>
>>>> For our kernel implementation:
>>>>
>>>>   for 'CIFS_MAX_DOMAINNAME_LEN', it counts 255 + '\0',
>>>>   for 'CIFS_MAX_USERNAME_LEN', it counts 256 (may add additional '=
\0'),
>>>>
>>>> And original mail said about 'CIFS_MAX_DOMAINNAME_LEN':
>>>>
>>>>   "The maximum length of ... the fully qualified domain name (FQDN=
) is
>>>>   63 octets per label and 255 bytes per FQDN. This maximum include=
s 254
>>>>   bytes for the FQDN and one byte for the ending dot."
>>>>
>>>> And excuse me, I do not know what 'CIFS_MAX_USERNAME_LEN' should b=
e.
>>>>
>>>> Do we also need consider about it in our definition comments ?
>>>>
>>>>
>>>> Thanks.
>>>> --
>>>> Chen Gang
>>>
>>> Sorry, I misunderstood; I figured that it had to be the domain name
>>> without the host since we were allowing a host name that's 1024
>>> characters long.  That documentation should probably be added to th=
e
>>> cifs_mount.h as well then.
>>>
>>> Still, how can we have a FQDN that's 256 characters long when the h=
ost
>>> name length can be 1024 characters long?
>>>
>>
>> Excuse me, I am not quite familiar about cifs, so can not provide
>> additional more information (I found it only by reading code).
>>
>> But I feel, it really need additional discussion and check by the
>> related experts (related members who are familiar with cifs).
>>
>> Welcome any members' suggestions and completions.
>>
>> Thanks.
>
> Come on guys, enough already. As per here:
> https://en.wikipedia.org/wiki/Domain_Name_System
>
> and a comment above the max len of the fully qualified domain name (F=
QDN) is
> 63 octets per label and 255 bytes per FQDN. This maximum includes 254
> bytes for the FQDN and one byte for the ending dot.
>
> --
> Regards,
> Richard Sharpe
> (=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=
=9C=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)

OK, I'll respin this and resubmit.

--=20
Peace and Blessings,
-Scott.
