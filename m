From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Source for winucase.c
Date: Fri, 18 Oct 2013 02:04:29 +0100
Message-ID: <1382058269.2794.11.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BfMq3NFut1snoKL5beFp"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--=-BfMq3NFut1snoKL5beFp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

fs/cifs/winucase.c is commented as:

 * The const tables in this file were converted from the following info
 * provided by Microsoft:
 *
 * 3.1.5.3 Mapping UTF-16 Strings to Upper Case:
 *
 * http://msdn.microsoft.com/en-us/library/hh877830.aspx
 * http://www.microsoft.com/en-us/download/details.aspx?displaylang=3Den&id=
=3D10921
 *
 * In particular, the table in "Windows 8 Upper Case Mapping Table.txt" was
 * post-processed using the winucase_convert.pl script.

Isn't "Windows 8 Upper Case Mapping Table.txt" then the preferred form
for modification of the tables?  In which case, it should be included in
the kernel sources.

Also, shouldn't this file acknowledge Microsoft's copyright, if it's a
derivative work of their file?

Ben.

--=20
Ben Hutchings
Horngren's Observation:
                   Among economists, the real world is often a special case=
.


--=-BfMq3NFut1snoKL5beFp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUmCJHee/yOyVhhEJAQrdmxAApKlS6r/R8SHzdfyjHwf2OpSwcuRSRh47
p2Bxj71vcBEGOqEAux9gwu1xVDz7yU7Y/26lsV+rE+Yk/BaqIl3PmL8h1JDgzUj2
Gk6k3dqfcwgg48r0glBw5He5R7Ct8PD0ji+hK7YJ27CI8ZbXsbTnujDjZBhSz94T
vP0Q2lPjJfxyiPx6YHUahC97Czp/kGDTbwWKTpgCfIFuD4JqZMU2b2Dysy7yzSVA
dB9aQHjGCdJj6sJ4W07ir/k030ZCak624SI1Qna1KKBjFv8aVsqbWmS1/0gF50el
+OFbYoWHXxAvow9bPzbVtKeV7EMddMwXwNfQdkn1N9NE6wB4pZtvXgpps5ipP2Iw
jEAWh61xFG6rVtltv2ixITTHcm9AITCPyhmHuQWSvb9k91TjlIzwBCpIrHDLdIpZ
oy5m+2C4KIJRJ0Tg8lhm2M4u8e6IxLBmzQasHSoa9x+HngZ2S2MNyzj3aHoKghBz
df14XXsFoewrdTcKg7j6V0eA6mV9+l/iiO+fYC+4iKrD2H5+dUGgmh3YnzLf5Kfl
OXjnZZ1yAJsCUlM3r0ezDsr3bxussm2Zvt0ycD2+KfRyGcJygTqtHxowjVMCeCTp
HJWKw38e0jqMkqxn5pLCWtAF/zYR4QQQQBCufgFGUq54OiJ2H3JFicSLjl5Ex1eA
LSL6MT9WBYo=
=tt3+
-----END PGP SIGNATURE-----

--=-BfMq3NFut1snoKL5beFp--
