From: =?iso-8859-1?Q?Tobias_Doerffel?= <tobias.doerffel-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org>
Subject: =?iso-8859-1?Q?AW=3A_Question_on_Active_Directory_Authentication?=
Date: Tue, 8 Jul 2014 13:04:42 +0200
Message-ID: <zarafa.53bbd04a.78cf.1d5ae9d4134672c1@zarafa.ed-chemnitz.de>
References: <53B6A3ED.9060805@muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?iso-8859-1?Q?Christian_Lutz?= <christian.lutz-EnyPcy3oyxIb1SvskN2V4Q@public.gmane.org>,
	=?iso-8859-1?Q?linux-cifs=40vger=2Ekernel=2Eorg?=
	<linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B6A3ED.9060805-EnyPcy3oyxIb1SvskN2V4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Christian,

you could indeed use krb5 authentication (and possibly in combination w=
ith the multiuser option) so you can build whatever mechanism you like =
for getting the required kerberos ticket for the user.  Once you have t=
he ticket you should be able to access the shares independent of the ac=
count name specifications. You have to configure your AD server such th=
at it provides credentials for the UPN. Advantage: you don't have to de=
al with possible limitations in the CIFS implementation on the client s=
ide.

Best regards

Tobias Doerffel


-----Urspr=FCngliche Nachricht-----

Hi everybody,

just one simple question regarding the authentication of users in the m=
ount options: Is it possible to authenticate a user with his userPrinci=
palName attribute and a password or are there any more dependencies to =
get this to work (i. e. krb5 or other security options)?

Example: mount -t cifs //server/share /mnt -o username=3Dmy.upn.prefix@=
domain.name.tld,password=3DPASSWORD

The only working solution was with the default sAMAccountName Attribute=
=2E

Background:
We are building a new fileservice for Windows and Linux Clients. The us=
ers are stored in Active Directory. The username (sAMAccountName) is a =
random string created by the Server itself. The only login attribute th=
e user knows is his UPN (which is also the mailaddress in our case).


Thanks in advance
Christian

---------------------------------



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
