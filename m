From: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: Re: CIFS kernel module bug
Date: Sun, 2 Oct 2011 21:16:33 +0100
Message-ID: <65C75335-2A74-4B00-989A-212BAC06A646@cam.ac.uk>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk> <20110930140409.51c1a94c@tlielax.poochiereds.net> <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk> <20110930234711.GD14147@samba2> <alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk> <6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk> <20111001150730.GJ5170@giles.fritz.box> <6A5AB13C-F313-4BF2-A402-F41AB53493F0@cam.ac.uk> <CAFneQcc8D7ho-Yfr2X0DxaLLX11iMU=wSgCw9daKoViZCMk6dA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?Q?Lars_M=FCller?= <lmuelle-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	PWF Linux <pwf-linux-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jim McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFneQcc8D7ho-Yfr2X0DxaLLX11iMU=wSgCw9daKoViZCMk6dA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

On 1 Oct 2011, at 21:22, Jim McDonough wrote:
> On Sat, Oct 1, 2011 at 3:53 PM, Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org> =
wrote:
>> On 1 Oct 2011, at 16:07, Lars M=FCller wrote:
>>> On Sat, Oct 01, 2011 at 09:48:12AM +0100, Anton Altaparmakov wrote:
>>>>=20
>>>> On 1 Oct 2011, at 01:34, J.P. King wrote:
>>>>> Anton will be asleep, so I'll attempt to answer this one.
>>>>>=20
>>>>>> What server code is the OES CIFS server running ? I thought Nove=
ll CIFS
>>>>>> services were all Samba based.
>>>>>=20
>>>>> We have been told by the people upstairs who run the server that =
it isn't.
>>>>=20
>>>> It is not Samba based.  Like Apple, Novell have written their own =
since Samba decided to go GPLv3=85
>>>=20
>>> (Potential) FUD alert. ;)
>>=20
>> It wasn't deliberate!  It was just a guess as until recently I also =
though that OES just used Samba so when I two weeks ago found out that =
it didn't I just assumed that Novell must have written it recently and =
then drew the parallel to Apple and just assumed that it was an analogo=
us case=85
>=20
> I believe both are available on OES, samba and the CIFS server that
> has its origins in Netware.

That is correct but apparently Salford Software (who handle our Netware=
 & OES site license here in the UK including providing support) have to=
ld the guys running the file server that the samba server on OES is not=
 scalable, has loads of bugs, and they must stay away from it at all co=
sts and that they would not provide any support if our filestore runs t=
hat instead of the Novell CIFSd.

You can understand why the filestore is thus running the Novell CIFSd r=
ather than Samba=85

PS. Whether this is FUD or not I cannot comment on.  I am just passing =
on what I was told!

Best regards,

	Anton
--=20
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
