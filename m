From: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: Re: CIFS  kernel module bug
Date: Sat, 1 Oct 2011 20:53:28 +0100
Message-ID: <6A5AB13C-F313-4BF2-A402-F41AB53493F0@cam.ac.uk>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk> <20110930140409.51c1a94c@tlielax.poochiereds.net> <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk> <20110930234711.GD14147@samba2> <alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk> <6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk> <20111001150730.GJ5170@giles.fritz.box>
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	PWF Linux <pwf-linux-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: =?iso-8859-1?Q?Lars_M=FCller?= <lmuelle-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111001150730.GJ5170-jzW0CqpAA0Me6aEkudXLsA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Lars,

On 1 Oct 2011, at 16:07, Lars M=C3=BCller wrote:
> On Sat, Oct 01, 2011 at 09:48:12AM +0100, Anton Altaparmakov wrote:
>>=20
>> On 1 Oct 2011, at 01:34, J.P. King wrote:
>>> Anton will be asleep, so I'll attempt to answer this one.
>>>=20
>>>> What server code is the OES CIFS server running ? I thought Novell=
 CIFS
>>>> services were all Samba based.
>>>=20
>>> We have been told by the people upstairs who run the server that it=
 isn't.
>>=20
>> It is not Samba based.  Like Apple, Novell have written their own si=
nce Samba decided to go GPLv3=E2=80=A6
>=20
> (Potential) FUD alert. ;)

It wasn't deliberate!  It was just a guess as until recently I also tho=
ugh that OES just used Samba so when I two weeks ago found out that it =
didn't I just assumed that Novell must have written it recently and the=
n drew the parallel to Apple and just assumed that it was an analogous =
case=E2=80=A6

> This Novell CIFS server existed before Novell bought SUSE.  And the
> decission to go with it instead of Samba had nothing to do with the m=
ove
> of Samba from GPL v2 to v3.

I stand corrected.  Thanks for the clarification!  From your signature =
I guess you would know a lot better than most.  (-:

Best regards,

	Anton

> Lars
> --=20
> Lars M=C3=BCller [=CB=88la=CB=90(r)z =CB=88m=CA=8Fl=C9=90]
> Samba Team
> SUSE Linux, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany

--=20
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
