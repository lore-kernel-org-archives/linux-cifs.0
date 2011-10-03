From: Jeremy Allison <jra@samba.org>
Subject: Re: CIFS kernel module bug
Date: Sun, 2 Oct 2011 19:44:02 -0700
Message-ID: <20111003024402.GB1644@jeremy-desktop>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
	<20110930140409.51c1a94c@tlielax.poochiereds.net>
	<E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
	<20110930234711.GD14147@samba2>
	<alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk>
	<6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk>
	<20111001150730.GJ5170@giles.fritz.box>
	<6A5AB13C-F313-4BF2-A402-F41AB53493F0@cam.ac.uk>
	<CAFneQcc8D7ho-Yfr2X0DxaLLX11iMU=wSgCw9daKoViZCMk6dA@mail.gmail.com>
	<65C75335-2A74-4B00-989A-212BAC06A646@cam.ac.uk>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	LKML <linux-kernel@vger.kernel.org>, PWF Linux <pwf-linux@ucs.cam.ac.uk>,
	Steve French <sfrench@samba.org>, Jeremy Allison <jra@samba.org>,
	Jim McDonough <jmcd@samba.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <65C75335-2A74-4B00-989A-212BAC06A646@cam.ac.uk>
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

On Sun, Oct 02, 2011 at 09:16:33PM +0100, Anton Altaparmakov wrote:
>=20
> That is correct but apparently Salford Software (who handle our Netware=
 & OES site license here in the UK including providing support) have told=
 the guys running the file server that the samba server on OES is not sca=
lable, has loads of bugs, and they must stay away from it at all costs an=
d that they would not provide any support if our filestore runs that inst=
ead of the Novell CIFSd.
>=20
> You can understand why the filestore is thus running the Novell CIFSd r=
ather than Samba=E2=80=A6
>=20
> PS. Whether this is FUD or not I cannot comment on.  I am just passing =
on what I was told!

Wow. And Samba being (partly) a UK-written project too (at least
 from me :-).

I think the Samba Team members from Novell who work full time
on said Samba server in OES might have some follow-ups here,
so I think I'll let them do that.

FYI. Just for fun, try running smbtorture4 against the CIFSd
thing you're running now. I'll be (probably) grimly amused by
the results. A warning - don't do that on a production system :-).

Jeremy.
