From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add missed forcemand mount option
Date: Tue, 27 Mar 2012 22:20:24 +0400
Message-ID: <CAKywueTvjM4UMsF9WG40cbM6mbbsbLg0j0OG304PdHnBPkehXg@mail.gmail.com>
References: <1332867075-3231-1-git-send-email-piastry@etersoft.ru>
	<20120327130715.39682caa@tlielax.poochiereds.net>
	<CAKywueT3Hoce-HrR14KamF2rhW4rjb-8PodejLEABNdmVZAhfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueT3Hoce-HrR14KamF2rhW4rjb-8PodejLEABNdmVZAhfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

27 =CD=C1=D2=D4=C1 2012=9A=C7. 21:17 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Pavel Shilovsky
<piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> 27 =CD=C1=D2=D4=C1 2012=9A=C7. 21:07 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=
=D8 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
>> On Tue, 27 Mar 2012 20:51:15 +0400
>> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>
>>> The 'forcemand' form of 'forcemandatorylock' mount option was misse=
d
>>> when the code moved to use the standard token parser. Return it bac=
k.
>>>
>>> Also fix a comment style in the parser.
>>>
>>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>>> ---
>>> =9Afs/cifs/connect.c | =9A =9A7 +++++--
>>> =9A1 files changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>> index 26327ea..7e4775c 100644
>>> --- a/fs/cifs/connect.c
>>> +++ b/fs/cifs/connect.c
>>> @@ -140,6 +140,7 @@ static const match_table_t cifs_mount_option_to=
kens =3D {
>>> =9A =9A =9A { Opt_nobrl, "nobrl" },
>>> =9A =9A =9A { Opt_nobrl, "nolock" },
>>> =9A =9A =9A { Opt_forcemandatorylock, "forcemandatorylock" },
>>> + =9A =9A { Opt_forcemandatorylock, "forcemand" },
>>
>> This looks fine.
>>
>>> =9A =9A =9A { Opt_setuids, "setuids" },
>>> =9A =9A =9A { Opt_nosetuids, "nosetuids" },
>>> =9A =9A =9A { Opt_dynperm, "dynperm" },
>>> @@ -1397,9 +1398,11 @@ cifs_parse_mount_options(const char *mountda=
ta, const char *devname,
>>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A break;
>>> =9A =9A =9A =9A =9A =9A =9A case Opt_nobrl:
>>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A vol->nobrl =3D =9A1;
>>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A /* turn off mandatory loc=
king in mode
>>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A /*
>>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* turn off mandatory l=
ocking in mode
>>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* if remote locking =
is turned off since the
>>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* local vfs will do ad=
visory */
>>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* local vfs will do ad=
visory
>>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A*/
>>
>> This doesn't look like it's related but just a comment cleanup?
>
> Yes - just a cleanup!
>

seems like I needed to exclude this out of the patch and respin but it
has been already merged into master.

--=20
Best regards,
Pavel Shilovsky.
