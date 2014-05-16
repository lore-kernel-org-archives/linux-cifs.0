From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Mounting network share on Linux as SMB2
Date: Fri, 16 May 2014 15:21:05 -0400
Message-ID: <20140516152105.15ed223a@samba.org>
References: <CF97FF07.3A16%mhatch@ldschurch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Hatch <mhatch-8ZevDSuycMcdYYaOPf09RA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF97FF07.3A16%mhatch-8ZevDSuycMcdYYaOPf09RA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 13 May 2014 22:55:36 +0000
Mark Hatch <mhatch-8ZevDSuycMcdYYaOPf09RA@public.gmane.org> wrote:

> Jeffrey-
>=20
> I have been reading and reading for the last few days trying to figur=
e out how to mount a network share on our RHEL 6.4 servers using smb2. =
 The main reason we need to do this is so that the linux machine can se=
e (and follow) symbolic links.  I have tried to do this with the =E2=80=
=9Cmount =E2=80=93t cifs=E2=80=9D command and it doesn=E2=80=99t seem t=
o work.
>=20
> I=E2=80=99m not very familiar with Linux, though I have dabbled a bit=
 in it.  In all of my searching, I haven=E2=80=99t found any info that =
makes sense to me.  Do you know or can you point me to a resource that =
explains where to start in fairly simple terms?
>=20
> I ran across your name and address several times as I=E2=80=99ve been=
 looking into this.
>=20
> Thanks.
>=20
> Mark Hatch | System Support
> Publishing Services Department
> Office 801.240.9467 | Cell 801.599.9721
> mhatch-8ZevDSuycMcdYYaOPf09RA@public.gmane.org<mailto:mhatch14-8ZevDSuycMcdYYaOPf09RA@public.gmane.org>
>=20
>=20
>  NOTICE: This email message is for the sole use of the intended recip=
ient(s) and may contain confidential and privileged information. Any un=
authorized review, use, disclosure or distribution is prohibited. If yo=
u are not the intended recipient, please contact the sender by reply em=
ail and destroy all copies of the original message.
>=20

(cc'ing linux-cifs mailing list)

Hi Mark,

Your best bet is to email linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org with some info
about what you're trying to do.

I'm a little unclear from the description above. Are you trying to
mount RHEL servers that are exporting filesystems via smb2, or are you
trying to mount filesystems from another server (windows?) using smb2?

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
