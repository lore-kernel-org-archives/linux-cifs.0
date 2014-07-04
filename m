From: Christian Lutz <christian.lutz-EnyPcy3oyxIb1SvskN2V4Q@public.gmane.org>
Subject: Question on Active Directory Authentication
Date: Fri, 04 Jul 2014 14:54:05 +0200
Message-ID: <53B6A3ED.9060805@muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi everybody,

just one simple question regarding the authentication of users in the=20
mount options: Is it possible to authenticate a user with his=20
userPrincipalName attribute and a password or are there any more=20
dependencies to get this to work (i. e. krb5 or other security options)=
?

Example: mount -t cifs //server/share /mnt -o=20
username=3Dmy.upn.prefix-d7gQ9grfmP4pBLzJVN3leg@public.gmane.org,password=3DPASSWORD

The only working solution was with the default sAMAccountName Attribute=
=2E

Background:
We are building a new fileservice for Windows and Linux Clients. The=20
users are stored in Active Directory. The username (sAMAccountName) is =
a=20
random string created by the Server itself. The only login attribute th=
e=20
user knows is his UPN (which is also the mailaddress in our case).


Thanks in advance
Christian

--=20

Christian Lutz

Landeshauptstadt Muenchen
it@M - Dienstleister fuer Informations- und Telekommunikationstechnik
Gesch=E4ftsbereich Werkzeuge und Infrastruktur
Servicebereich Security und Netzwerkinfrastruktur
Serviceteam ID-Management
Komponentenverantwortlicher Active Directory

Buero: Herzog-Wilhelm-Stra=DFe 22, M=FCnchen
Postanschrift: Herzogspitalstr. 24, 80331 M=FCnchen

Telefon: +49 89 233-25596
=46ax.: +49 89 233-98925596
E-Mail:	christian.lutz-EnyPcy3oyxIb1SvskN2V4Q@public.gmane.org

--------------------------------------------------------------------
Elektronische Kommunikation mit der Landeshauptstadt Muenchen - siehe:
http://www.muenchen.de/ekomm
--------------------------------------------------------------------
