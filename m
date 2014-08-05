From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: DFS root namespace mounting problem...
Date: Tue, 05 Aug 2014 17:12:59 +0200
Message-ID: <1407251579.2941.8.camel@hh16.hh3.site>
References: <44E091A70C02494A806AD35E6F93AB1A32B89B@HOSMAIL2B.ho.pfgroup.provfin.com>
	 <1407248098.1426.7.camel@hh16.hh3.site>
	 <44E091A70C02494A806AD35E6F93AB1A32B89C@HOSMAIL2B.ho.pfgroup.provfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "McCall, Andy (IT.PFMS)" <Andy.McCall-JGeVbDYbwmjRZ1oM81ef8Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <44E091A70C02494A806AD35E6F93AB1A32B89C-44HqyMtr/CW7efwRAOVE6/PBkhW9OzgPksZubNBzXmQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2014-08-05 at 15:26 +0100, McCall, Andy (IT.PFMS) wrote:
> >> I've been following some guides for mounting a DFS root namespace =
that=20
> >> is known to work on Windows boxes on a fresh updated RHEL6.5 insta=
ll.
> >>
> >> I can mount the shares directly from each node within the DFS clus=
ter=20
> >> with no issues:
> >>=20
> >>   [root@myserver ~]# mount -t cifs -v //node1.my.domain.com/myroot=
/=20
> >> /share -o username=3Dmydomainaccount
> >>   Password:
> >>   mount.cifs kernel mount options:
> >> ip=3D192.168.10.1,unc=3D\\node1.my.domain.com\share,,ver=3D1,user=3D=
mydomainac
> >> co
> >> unt,pass=3D********
> >>=20
> >>   [root@myserver ~]# mount | grep share //node1.my.domain.com/shar=
e/=20
> >> on /share type cifs (rw)
> >>=20
> >> But if I try and mount against the DFS root namespace it fails:
> >>=20
> >>   mount -t cifs -v //my.domain.com/myroot /share -o username=3D=20
> >> mydomainaccount,domain=3Dmy.domain.com
> >>   Password:
> >>   mount.cifs kernel mount options:
> >> ip=3D192.168.1.1,unc=3D\\my.domain.com\myroot,,ver=3D1,user=3Dmydo=
mainaccount,
> >> do
> >> main=3Dmy.domain.com,pass=3D********
> >>   mount.cifs kernel mount options: ip=3D192.168.1.2,unc=3D\\my.dom=
ain.com
> >> \myroot,,ver=3D1,user=3Dmydomainaccount,domain=3Dmy.domain.com,pas=
s=3D********
> >>   Unable to find suitable address.
> >>=20
> >> The IP addresses 192.168.1.1, 192.168.1.1 are the DNS / domain=20
> >> servers, not the DFS node servers, leading me to believe I'm not=20
> >> getting referrals to the underlying nodes.  A tcpdump host against=
 my=20
> >> nodes while trying to mount the share confirms this, indicating it=
s=20
> >> trying to mount /share from the domain servers - which is why it f=
ails.
> >>=20
> >> I've followed all the guides and as far as I can tell, this should=
 be=20
> >> fairly easy by configuring request-key.d files:
> >>=20
> >>   [root@myserver request-key.d]# cat
> >> /etc/request-key.d/dns_resolver.conf
> >>   create dns_resolver * * /usr/sbin/cifs.upcall %k
> >>=20
> >>   [root@myserver request-key.d]# cat /etc/request-key.d/cifs.spneg=
o.conf
> >>   create cifs.spnego * * /usr/sbin/cifs.upcall -t %k
> >>=20
> >> Can someone give me some pointers as to where things could be goin=
g=20
> >> wrong?  I'm no expert at DFS, but I'd like to know I'm at least=20
> >> looking in the correct place.
>=20
> > The cifs upcall looks for the username (maybe 'user' will work) in =
the keytab.
> > However we do not seem to have any way to tell cifs that that the u=
nc you have
> > specified is part of DFS and so it treats the domain part of the un=
c as the host
> > where the share is stored, which of course it then can't find.
> >
> > FWIW, we gave up on this a few weeks ago and set up a real cluster =
with CTDB. A
> > lot more effort but it solved our file server problems.
> >
> > I hope you'll be able to prove us wrong and that all our work has b=
een for nothing
> > and that domain DFS works fine. We were unable to get it to work.
>=20
> I've just swapped /usr/sbin/cifs.upcall out for a script that echo's =
test to /tmp/text.txt
> and cifs.upcall isn't actually being called at all in my case.

You may already have a ticket.
>=20
> Other people seem to be able to mount root namespaces with no issues?=
  Is this a RHEL bug?
>=20
> Thanks,
>=20
> AM
> DISCLAIMER. The contents of this email and its attachments are intend=
ed solely for the original recipients and express the views of the auth=
ors and not necessarily the Company. If you are not the intended recipi=
ent please delete without copying or forwarding and inform the sender t=
hat you received it in error.=20
> Provident Financial Management Services Ltd, Registered in England, C=
ompany Number 328933. Interim Permissions Reference Number: 119219
> Provident Personal Credit Ltd, Registered in England, Company Number =
146091. Interim Permissions Reference Number: 002529
> Both Provident Financial Management Services Ltd and Provident Person=
al Credit Ltd are authorised and regulated by the Financial Conduct Aut=
hority, see Interim Permissions numbers above. Registered Office: No.1 =
Godwin Street, Bradford, West Yorkshire BD1 2SU, United Kingdom.
> =20
> Please save paper - don't print this email unless necessary
> NrybX=C7=A7v^)=DE=BA{.n+{r'{ay=1D=CA=87=DA=99,j=07fhz=1Ew=0Cj:+vwjm=07=
zZ+=DD=A2j"!
