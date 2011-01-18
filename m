From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Lose shared network resource
Date: Tue, 18 Jan 2011 10:33:33 +0530
Message-ID: <4D351F25.7000708@suse.de>
References: <395199.61799.qm@web29510.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Francesco Alfano <edacedpa-whZMOeQn8C0@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <395199.61799.qm-TMQpk2DxdNTyX4RqAA4FmIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(good to Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org though it might not have anything
to do with cifs in this case)

On 01/13/2011 09:06 PM, Francesco Alfano wrote:
> Hello, 
> I have a problem with the (exported) sharing of network resources. 
> Initially i've used a sever with RedHat 7.3 kernel 2.4 now i've  installed 
> Scientific Linux 5.5 with kernel 2.6.18-194.32.1.el5PAE with  Samba version 
> 3.0.33-3.29.el5_5.1. 
> 
> The problem is that I lose the network connection periodically, about 10  
> minutes! 
> 

Are you using dhcp? If yes, it looks like a problem due to IPaddress not
being persistent (possibly a bug in dhcpcd).

Are you able to reproduce this problem if you use static IP?  Also, see
if the problem is persisting if you use dhclient instead of dhcpcd.


-- 
Suresh Jayaraman
