From: "McCall, Andy \(IT.PFMS\)" <Andy.McCall-JGeVbDYbwmjRZ1oM81ef8Q@public.gmane.org>
Subject: DFS root namespace mounting problem...
Date: Tue, 5 Aug 2014 14:11:20 +0100
Message-ID: <44E091A70C02494A806AD35E6F93AB1A32B89B@HOSMAIL2B.ho.pfgroup.provfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Folks,

I've been following some guides for mounting a DFS root namespace that
is known to work on Windows boxes on a fresh updated RHEL6.5 install.

I can mount the shares directly from each node within the DFS cluster
with no issues:

  [root@myserver ~]# mount -t cifs -v //node1.my.domain.com/myroot/
/share -o username=mydomainaccount
  Password:
  mount.cifs kernel mount options:
ip=192.168.10.1,unc=\\node1.my.domain.com\share,,ver=1,user=mydomainacco
unt,pass=********

  [root@myserver ~]# mount | grep share //node1.my.domain.com/share/ on
/share type cifs (rw)

But if I try and mount against the DFS root namespace it fails:

  mount -t cifs -v //my.domain.com/myroot /share -o username=
mydomainaccount,domain=my.domain.com
  Password:
  mount.cifs kernel mount options:
ip=192.168.1.1,unc=\\my.domain.com\myroot,,ver=1,user=mydomainaccount,do
main=my.domain.com,pass=********
  mount.cifs kernel mount options: ip=192.168.1.2,unc=\\my.domain.com
\myroot,,ver=1,user=mydomainaccount,domain=my.domain.com,pass=********
  Unable to find suitable address.

The IP addresses 192.168.1.1, 192.168.1.1 are the DNS / domain servers,
not the DFS node servers, leading me to believe I'm not getting
referrals to the underlying nodes.  A tcpdump host against my nodes
while trying to mount the share confirms this, indicating its trying to
mount /share from the domain servers - which is why it fails.

I've followed all the guides and as far as I can tell, this should be
fairly easy by configuring request-key.d files:

  [root@myserver request-key.d]# cat
/etc/request-key.d/dns_resolver.conf
  create dns_resolver * * /usr/sbin/cifs.upcall %k

  [root@myserver request-key.d]# cat /etc/request-key.d/cifs.spnego.conf
  create cifs.spnego * * /usr/sbin/cifs.upcall -t %k

Can someone give me some pointers as to where things could be going
wrong?  I'm no expert at DFS, but I'd like to know I'm at least looking
in the correct place.

Thanks,

AM
DISCLAIMER. The contents of this email and its attachments are intended solely for the original recipients and express the views of the authors and not necessarily the Company. If you are not the intended recipient please delete without copying or forwarding and inform the sender that you received it in error. 
Provident Financial Management Services Ltd, Registered in England, Company Number 328933. Interim Permissions Reference Number: 119219
Provident Personal Credit Ltd, Registered in England, Company Number 146091. Interim Permissions Reference Number: 002529
Both Provident Financial Management Services Ltd and Provident Personal Credit Ltd are authorised and regulated by the Financial Conduct Authority, see Interim Permissions numbers above. Registered Office: No.1 Godwin Street, Bradford, West Yorkshire BD1 2SU, United Kingdom.
 
Please save paper - don't print this email unless necessary
