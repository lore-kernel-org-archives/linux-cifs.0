From: Jim McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS kernel module bug
Date: Sat, 1 Oct 2011 16:22:34 -0400
Message-ID: <CAFneQcc8D7ho-Yfr2X0DxaLLX11iMU=wSgCw9daKoViZCMk6dA@mail.gmail.com>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
 <20110930140409.51c1a94c@tlielax.poochiereds.net> <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
 <20110930234711.GD14147@samba2> <alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk>
 <6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk> <20111001150730.GJ5170@giles.fritz.box>
 <6A5AB13C-F313-4BF2-A402-F41AB53493F0@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-1?Q?Lars_M=FCller?= <lmuelle-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	PWF Linux <pwf-linux-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6A5AB13C-F313-4BF2-A402-F41AB53493F0-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Oct 1, 2011 at 3:53 PM, Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org> wr=
ote:
> Hi Lars,
>
> On 1 Oct 2011, at 16:07, Lars M=C3=BCller wrote:
>> On Sat, Oct 01, 2011 at 09:48:12AM +0100, Anton Altaparmakov wrote:
>>>
>>> On 1 Oct 2011, at 01:34, J.P. King wrote:
>>>> Anton will be asleep, so I'll attempt to answer this one.
>>>>
>>>>> What server code is the OES CIFS server running ? I thought Novel=
l CIFS
>>>>> services were all Samba based.
>>>>
>>>> We have been told by the people upstairs who run the server that i=
t isn't.
>>>
>>> It is not Samba based. =C2=A0Like Apple, Novell have written their =
own since Samba decided to go GPLv3=E2=80=A6
>>
>> (Potential) FUD alert. ;)
>
> It wasn't deliberate! =C2=A0It was just a guess as until recently I a=
lso though that OES just used Samba so when I two weeks ago found out t=
hat it didn't I just assumed that Novell must have written it recently =
and then drew the parallel to Apple and just assumed that it was an ana=
logous case=E2=80=A6

I believe both are available on OES, samba and the CIFS server that
has its origins in Netware.

>
>> This Novell CIFS server existed before Novell bought SUSE. =C2=A0And=
 the
>> decission to go with it instead of Samba had nothing to do with the =
move
>> of Samba from GPL v2 to v3.
>
> I stand corrected. =C2=A0Thanks for the clarification! =C2=A0From you=
r signature I guess you would know a lot better than most. =C2=A0(-:
>
> Best regards,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Anton
>
>> Lars
>> --
>> Lars M=C3=BCller [=CB=88la=CB=90(r)z =CB=88m=CA=8Fl=C9=90]
>> Samba Team
>> SUSE Linux, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
>
> --
> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
> Linux NTFS maintainer, http://www.linux-ntfs.org/
>
>



--=20
Jim McDonough
Samba Team
SUSE labs
jmcd at samba dot org
jmcd at themcdonoughs dot org
