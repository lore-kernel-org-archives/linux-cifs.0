From: Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
Subject: Problem with Samba re-share of a CIFS mount
Date: Tue, 11 Feb 2014 10:30:13 +0100
Message-ID: <52F9EDA5.1020004@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,
I have a strange problem trying to re-share, via Samba, a CIFS mount.

Let first explain my network topology:

Win2008R2 w/SMB share -> low speed link -> Linux Box -> WIN7 clients

In short, a Win2008 R2 share is being accessed by some W7 clients over a 
slow (~8 Mb/s downstream, ~1 Mb/s upstream) ADSL link. To speed up read 
operation on the branch office, I thought to use a Linux Box with 
cachefilesd and a CONFIG_CIFS_FSCACHE enabled kernel. The Linux box will 
mount the Win2008R2 share and, thanks to cachefilesd, it will maintain 
an "hot cache" of the read data. This CIFS mount is then shared, via 
Samba, to the other client Win7 PCs.

However, the problem is that when re-sharing the CIFS mount, the Win7 
clients often see the many directories inside the mount as a regular 
files, and not directories! In other words, if I have a directory "test" 
inside the mount, the client PC will see a _file_ called "test". When 
double-clicking on that "file", the Win7 client even ask to select the 
application to open it.

The strange this is that this problem happen with some Linux kernel 
version, but not with others. These are my results:

1) Stock CentOS 6.5 x86-64 system (kernel 2.6.32-431.1.2.0.1, cifs-utils 
4.8.1-19, samba 3.6.9-167): no problem here, but this kernel does not 
have CONFIG_CIFS_FSCACHE, so I can not use it for speeding up read access;

2) CentOS 6.5 x86-64 with ElRepo updates (kernel 3.10.28-1): here 
CONFIG_CIFS_FSCACHE is enabled, but I have the problem described above;

3) Debian 7 amd64 with latest updates (kernel 3.2.54-2, cifs-utils 
2:5.5-1): CONFIG_CIFS_FSCACHE is enabled, problem happens;

4) Fedora 20 x86-64 (kernel 3.12.8-300, cifs-utils 6.3-1, samba 
4.1.3-2): CONFIG_CIFS_FSCACHE is enabled and problem does _not_ happen, 
however this is a client distro and I am not so comfortable to put it 
into production.

Anyone has any explanation of what is happening here?
Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org - info-N44kj/XGErOonA0d6jMUrA@public.gmane.org
GPG public key ID: FF5F32A8
