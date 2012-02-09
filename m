From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [MAC Lion] smbclient "Open AndX Request->STATUS_NOT_SUPPORTED"
Date: Thu, 9 Feb 2012 00:07:08 -0600
Message-ID: <CADT32eLbq_oE4Eehg3qo+bwmSS2K4ZHYVb4pfHwKF=YBgNssDw@mail.gmail.com>
References: <D9F023C0-2563-4670-87C3-85CABDF8EA35@multitech.com>
	<E1Rtaas-00H0p7-IF@intern.SerNet.DE>
	<EE8750E0-F138-438E-8198-1F4B5BE5CFFF@apple.com>
	<A6E1B1277FAD3B48A3C0F38B9C12FCE182AB7D@SVMVVWPEXCH01.dc.multitech.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: George K Colley <gcolley-2kanFRK1NckAvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Darrik Spaude <dspaude-BGUGTLuWYFm1Z/+hSey0Gg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A6E1B1277FAD3B48A3C0F38B9C12FCE182AB7D-HHW3LFhzwhv3GK0kuUd8OGQCH64ISku/NA752UdN0/I@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Feb 8, 2012 at 5:28 PM, Darrik Spaude <dspaude-BGUGTLuWYFm1Z/+hSey0Gg@public.gmane.org> w=
rote:
>> You should be using cifs to connect to Lion.
>
> George,
>
> Is there a specific cifs version and list of options to use? It seems
> that there is some minimum cifs version before this problem is resolv=
ed.
> We have tried the following and both of them fail:
>
> # mount.cifs -V =A0 (Updated Embedded Server, kernel 2.6.32.28)
> mount.cifs version: 1.14-3.5.6
>
> # mount.cifs -V =A0 (Ubuntu 10.04 LTS, kernel 2.6.32-38)
> mount.cifs version: 1.12-3.4.7
>
>
> The command options we have tried (based on lots of searching) are
> 'nounix,noserverino,sec=3Dntlmssp'.
>
> The command is then:
> mount.cifs //192.168.1.2/Shared mntpoint -o
> 'guest,nounix,noserverino,sec=3Dntlmssp'
>
> Ubuntu gives a different error (-126) with the sec=3Dntlmssp. The emb=
edded
> server just gives error -22.
>
> Any help is appreciated,
> Darrik
>

I think this concerns linux cifs vfs client.  If so, a wireshark trace
would be helpful.

Regards,

Shirish
