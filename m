From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: DFS root namespace mounting problem...
Date: Tue, 05 Aug 2014 16:14:58 +0200
Message-ID: <1407248098.1426.7.camel@hh16.hh3.site>
References: <44E091A70C02494A806AD35E6F93AB1A32B89B@HOSMAIL2B.ho.pfgroup.provfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "McCall, Andy (IT.PFMS)" <Andy.McCall-JGeVbDYbwmjRZ1oM81ef8Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <44E091A70C02494A806AD35E6F93AB1A32B89B-44HqyMtr/CW7efwRAOVE6/PBkhW9OzgPksZubNBzXmQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2014-08-05 at 14:11 +0100, McCall, Andy (IT.PFMS) wrote:
> Hi Folks,
> 
> I've been following some guides for mounting a DFS root namespace that
> is known to work on Windows boxes on a fresh updated RHEL6.5 install.
> 
> I can mount the shares directly from each node within the DFS cluster
> with no issues:
> 
>   [root@myserver ~]# mount -t cifs -v //node1.my.domain.com/myroot/
> /share -o username=mydomainaccount
>   Password:
>   mount.cifs kernel mount options:
> ip=192.168.10.1,unc=\\node1.my.domain.com\share,,ver=1,user=mydomainacco
> unt,pass=********
> 
>   [root@myserver ~]# mount | grep share //node1.my.domain.com/share/ on
> /share type cifs (rw)
> 
> But if I try and mount against the DFS root namespace it fails:
> 
>   mount -t cifs -v //my.domain.com/myroot /share -o username=
> mydomainaccount,domain=my.domain.com
>   Password:
>   mount.cifs kernel mount options:
> ip=192.168.1.1,unc=\\my.domain.com\myroot,,ver=1,user=mydomainaccount,do
> main=my.domain.com,pass=********
>   mount.cifs kernel mount options: ip=192.168.1.2,unc=\\my.domain.com
> \myroot,,ver=1,user=mydomainaccount,domain=my.domain.com,pass=********
>   Unable to find suitable address.
> 
> The IP addresses 192.168.1.1, 192.168.1.1 are the DNS / domain servers,
> not the DFS node servers, leading me to believe I'm not getting
> referrals to the underlying nodes.  A tcpdump host against my nodes
> while trying to mount the share confirms this, indicating its trying to
> mount /share from the domain servers - which is why it fails.
> 
> I've followed all the guides and as far as I can tell, this should be
> fairly easy by configuring request-key.d files:
> 
>   [root@myserver request-key.d]# cat
> /etc/request-key.d/dns_resolver.conf
>   create dns_resolver * * /usr/sbin/cifs.upcall %k
> 
>   [root@myserver request-key.d]# cat /etc/request-key.d/cifs.spnego.conf
>   create cifs.spnego * * /usr/sbin/cifs.upcall -t %k
> 
> Can someone give me some pointers as to where things could be going
> wrong?  I'm no expert at DFS, but I'd like to know I'm at least looking
> in the correct place.
> 
> Thanks,

Hi
The cifs upcall looks for the username (maybe 'user' will work) in the
keytab. However we do not seem to have any way to tell cifs that that
the unc you have specified is part of DFS and so it treats the domain
part of the unc as the host where the share is stored, which of course
it then can't find.

FWIW, we gave up on this a few weeks ago and set up a real cluster with
CTDB. A lot more effort but it solved our file server problems.

I hope you'll be able to prove us wrong and that all our work has been
for nothing and that domain DFS works fine. We were unable to get it to
work.
HTH,
Steve
