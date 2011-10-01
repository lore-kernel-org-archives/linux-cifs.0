From: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: Re: CIFS  kernel module bug
Date: Sat, 1 Oct 2011 09:48:12 +0100
Message-ID: <6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk> <20110930140409.51c1a94c@tlielax.poochiereds.net> <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk> <20110930234711.GD14147@samba2> <alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk>
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	PWF Linux <pwf-linux-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.00.1110010122210.15683-rNEEB5iaIwQgWVoWv9+vLtDNj2e20MGE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

On 1 Oct 2011, at 01:34, J.P. King wrote:
> Anton will be asleep, so I'll attempt to answer this one.
>=20
>> What server code is the OES CIFS server running ? I thought Novell C=
IFS
>> services were all Samba based.
>=20
> We have been told by the people upstairs who run the server that it i=
sn't.

It is not Samba based.  Like Apple, Novell have written their own since=
 Samba decided to go GPLv3=85

> I have a recollection that it may be a forked version of the samba co=
de, but don't rely on my recollections.

It is not.  Or it better not be given the license is binary only!!!  It=
 would have to be GPL if it were forked.

> Either way it is sitting on top of NSS, a Novell filesystem, which is=
 significantly different to "normal" Linux filesystem.  I don't know th=
at
> this is the issue, but it is a difference which may affect things reg=
ardless of the fileserver code.


I had a quick google and Novell's own OES documentation for CIFS has a =
section titled:

	"Comparing Novell CIFS and Novell Samba"

If you care, it is on page 77 of this PDF:

	http://www.novell.com/documentation/oes2/pdfdoc/file_cifs_lx/file_cifs=
_lx.pdf

And our filestore is running the Novell CIFS server, not the Novell Sam=
ba one in case that wasn't obvious from previous discussion=85

Best regards,

	Anton
--=20
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
