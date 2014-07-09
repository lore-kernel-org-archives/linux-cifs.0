From: =?iso-8859-1?Q?Tobias_Doerffel?= <tobias.doerffel-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org>
Subject: =?iso-8859-1?Q?AW=3A_Question_on_Active_Directory_Authentication?=
Date: Wed, 9 Jul 2014 13:13:56 +0200
Message-ID: <zarafa.53bd23f4.13c0.46a6a8115b51d1f3@zarafa.ed-chemnitz.de>
References: <53B6A3ED.9060805@muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?iso-8859-1?Q?Christian_Lutz?= <christian.lutz-EnyPcy3oyxIb1SvskN2V4Q@public.gmane.org>,
	=?iso-8859-1?Q?linux-cifs=40vger=2Ekernel=2Eorg?=
	<linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BD2217.1030304-EnyPcy3oyxIb1SvskN2V4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Christian,

I never used the NTLM security options but I would guess that they woul=
dn't work that way as they still require usernames and passwords. Krb5 =
is the only security method where you can use an existing credential in=
formation in form of a Kerberos ticket.

Best regards

Tobias Doerffel


--
Dipl.-Inf. Tobias Doerffel

-----------------------------------------------
EDC Electronic Design Chemnitz GmbH
Technologie-Campus 4, 09126 Chemnitz

Gesch=E4ftsf=FChrer: Dr.-Ing. Steffen Heinz
                 Dipl.-Ing. Andr=E9 Lange
Tel.:            +49 371 52 45 90
=46ax.:            +49 371 52 45 910
E-Mail:          info-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org

Sitz der Gesellschaft: Chemnitz
HRB 23986, Amtsgericht Chemnitz
USTID: DE258181725
-----------------------------------------------
