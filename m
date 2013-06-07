From: sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org
Subject: accessing windows share with trusted Mit's kerberos realm
 credentials
Date: Fri, 07 Jun 2013 12:01:17 +0200
Message-ID: <1605453035.63639.1370599277400.JavaMail.www@wwinf8305>
Reply-To: sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>





Hello everybody,
I am trying to mount windows share on a windows 2008 ad server from lin=
ux. An easy step, but ...
The Windows Domain trust a MIT Kerberos Realm
The users are mapped with a kerberos principal
The mount work with the Active Directory password , or kerberos ticket =
but NOT with MIT'password or tickets...


The Trust works well,=20
I have got no problem with Windows 7 joined domain computer for accessi=
ng the shares.
It don't work with windows 7 non domain joined computer.

The authentication work with linux with a mix of winbind and pam_krb5
Somebody does have an idea ?
Thanks !!
Regards
Serge

Here some basic information

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[root@confucius ~]# mount.cifs -V
mount.cifs version: 4.8.1

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
mount -t cifs //dc1/data/cnsxxxxa /mnt -o username=3Dcnsxxxxa=20
work with the active's directory password but not with the mit's

[root@confucius ~]# mount -t cifs //dc1/data/cnsxxxxa /mnt -o username=3D=
cnsxxxxa,domain=3DKERBEROS.REALM
do not help

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
with AD kerberos ticket :
kinit cnsxxxxa-aIalqPAc0dg@public.gmane.org
Password for cnsxxxxa-aIalqPAc0dg@public.gmane.org
[root@confucius ~]# mount -t cifs //dc1/data/cnsxxxxa /mnt -o sec=3Dkrb=
5i


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
with MIT kerberos ticket :
[root@confucius ~]# kinit cnsxxxxa
Password for cnsxxxxa-khcJi3VkZSyWBmc9DYqwOg@public.gmane.org:
[root@confucius ~]# mount -t cifs //dc1/data/cnsxxxxa /mnt -o sec=3Dkrb=
5i
mount error(5): Input/output error

I have added this to /etc/requestkey.conf
create cifs.spnego * * /usr/sbin/cifs.upcall %k
create dns_resolver * * /usr/sbin/cifs.upcall %k

Une messagerie gratuite, garantie =C3=A0 vie et des services en plus, =C3=
=A7a vous tente ?
Je cr=C3=A9e ma bo=C3=AEte mail www.laposte.net
