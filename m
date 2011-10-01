From: Steve French <smfrench@gmail.com>
Subject: Re: CIFS kernel module bug
Date: Sat, 1 Oct 2011 18:14:35 -0500
Message-ID: <CAH2r5mty7nqQWzv5ummBqq7tF4cknzc_f8hW9WmbOkDUKVap+Q@mail.gmail.com>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
	<20110930140409.51c1a94c@tlielax.poochiereds.net>
	<E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
	<20110930234711.GD14147@samba2>
	<alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk>
	<6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk>
	<20111001150730.GJ5170@giles.fritz.box>
	<6A5AB13C-F313-4BF2-A402-F41AB53493F0@cam.ac.uk>
	<CAFneQcc8D7ho-Yfr2X0DxaLLX11iMU=wSgCw9daKoViZCMk6dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	LKML <linux-kernel@vger.kernel.org>, PWF Linux <pwf-linux@ucs.cam.ac.uk>,
	Steve French <sfrench@samba.org>, Anton Altaparmakov <aia21@cam.ac.uk>,
	Jeremy Allison <jra@samba.org>
To: Jim McDonough <jmcd@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAFneQcc8D7ho-Yfr2X0DxaLLX11iMU=wSgCw9daKoViZCMk6dA@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Sat, Oct 1, 2011 at 3:22 PM, Jim McDonough <jmcd@samba.org> wrote:
> On Sat, Oct 1, 2011 at 3:53 PM, Anton Altaparmakov <aia21@cam.ac.uk> wrot=
e:
>> Hi Lars,
>>
>> On 1 Oct 2011, at 16:07, Lars M=C3=BCller wrote:
>>> On Sat, Oct 01, 2011 at 09:48:12AM +0100, Anton Altaparmakov wrote:
>>>>
>>>> On 1 Oct 2011, at 01:34, J.P. King wrote:
>>>>> Anton will be asleep, so I'll attempt to answer this one.
>>>>>
>>>>>> What server code is the OES CIFS server running ? I thought Novell C=
IFS
>>>>>> services were all Samba based.
>>>>>
>>>>> We have been told by the people upstairs who run the server that it i=
sn't.
>>>>
>>>> It is not Samba based. =C2=A0Like Apple, Novell have written their own=
 since Samba decided to go GPLv3=E2=80=A6
>>>
>>> (Potential) FUD alert. ;)
>>
>> It wasn't deliberate! =C2=A0It was just a guess as until recently I also=
 though that OES just used Samba so when I two weeks ago found out that it =
didn't I just assumed that Novell must have written it recently and then dr=
ew the parallel to Apple and just assumed that it was an analogous case=E2=
=80=A6
>
> I believe both are available on OES, samba and the CIFS server that
> has its origins in Netware.
>
>>
>>> This Novell CIFS server existed before Novell bought SUSE. =C2=A0And th=
e
>>> decission to go with it instead of Samba had nothing to do with the mov=
e
>>> of Samba from GPL v2 to v3.
>>
>> I stand corrected. =C2=A0Thanks for the clarification! =C2=A0From your s=
ignature I guess you would know a lot better than most. =C2=A0(-:
>>
>> Best regards,
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Anton
>>
>>> Lars
>>> --
>>> Lars M=C3=BCller [=CB=88la=CB=90(r)z =CB=88m=CA=8Fl=C9=90]
>>> Samba Team
>>> SUSE Linux, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
>>
>> --
>> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
>> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
>> Linux NTFS maintainer, http://www.linux-ntfs.org/

Key point is - we will fix the Linux cifs kernel client to make
reasonable workarounds for server bugs for something like this -
especially if the server is easy to download and/or test against (and
assuming it supports reasonable security - ntlmv2 and/or kerberos)


--=20
Thanks,

Steve
