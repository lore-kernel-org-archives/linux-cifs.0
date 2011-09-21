From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: 3.1-rc4: CIFS VFS: Received no data, expecting 4
Date: Wed, 21 Sep 2011 16:54:08 +0530
Message-ID: <4E79C958.7080702@suse.com>
References: <alpine.DEB.2.02.1109181258480.8689@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1109181258480.8689-0qmrozcXWo8bm2hyYBkBBg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Adding linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org to Cc.

On 09/18/2011 10:29 PM, Justin Piszcz wrote:
> Hello,
> 
> What does this mean and why does it occur?

This error seems to occur when we try to read from a socket and actually
read no data. Not sure when this would occur.

> (mounted a Windows 7 share)
> 
> [ 1090.606501] CIFS VFS: Received no data, expecting 4
> [ 1120.575675] CIFS VFS: Received no data, expecting 4
> [ 1150.544783] CIFS VFS: Received no data, expecting 4
> [ 1180.513925] CIFS VFS: Received no data, expecting 4
> [ 1210.483044] CIFS VFS: Received no data, expecting 4
> [ 1240.452187] CIFS VFS: Received no data, expecting 4
> [ 1270.421345] CIFS VFS: Received no data, expecting 4
> [ 1300.390432] CIFS VFS: Received no data, expecting 4
> [ 1330.359595] CIFS VFS: Received no data, expecting 4
> [ 1360.328755] CIFS VFS: Received no data, expecting 4
> [ 1390.283901] CIFS VFS: Received no data, expecting 4
> [ 1420.249492] CIFS VFS: Received no data, expecting 4
> [ 1450.218690] CIFS VFS: Received no data, expecting 4
> [ 1480.187842] CIFS VFS: Received no data, expecting 4
> [ 1510.156925] CIFS VFS: Received no data, expecting 4
> [ 1540.126080] CIFS VFS: Received no data, expecting 4
> [ 1570.095264] CIFS VFS: Received no data, expecting 4
> [ 1600.064381] CIFS VFS: Received no data, expecting 4
> [ 1630.033567] CIFS VFS: Received no data, expecting 4
> [ 1660.002595] CIFS VFS: Received no data, expecting 4
> [ 1689.971796] CIFS VFS: Received no data, expecting 4
> [ 1719.940916] CIFS VFS: Received no data, expecting 4
> [ 1749.910064] CIFS VFS: Received no data, expecting 4
> [ 1779.879160] CIFS VFS: Received no data, expecting 4
> [ 1809.848347] CIFS VFS: Received no data, expecting 4
> [ 1839.817414] CIFS VFS: Received no data, expecting 4
> [ 1869.786612] CIFS VFS: Received no data, expecting 4
> [ 1899.755742] CIFS VFS: Received no data, expecting 4
> [ 1929.724890] CIFS VFS: Received no data, expecting 4
> [ 1959.694018] CIFS VFS: Received no data, expecting 4
> [ 1989.663177] CIFS VFS: Received no data, expecting 4
> [ 2019.632306] CIFS VFS: Received no data, expecting 4
> [ 2049.601480] CIFS VFS: Received no data, expecting 4
> 
> Justin.
> 

-Suresh
