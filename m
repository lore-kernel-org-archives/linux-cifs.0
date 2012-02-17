From: Andrey Chervonets <a.chervonets-WKmEczWRmnjsq35pWSNszA@public.gmane.org>
Subject: Can't download files from your site. :(
Date: Fri, 17 Feb 2012 09:12:53 +0200
Message-ID: <4F3DFDF5.9070802@cominder.eu>
References: <4F3D878A.8090306@cominder.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F3D878A.8090306-WKmEczWRmnjsq35pWSNszA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Good day!

Recently I has found the site with advanced CIFS, which looks like 
solution for my client using DFS, but need use it from Linux too.

1) But can not download some files:
     The following links are broken - at least I can  not get anything 
from there:
    a) Installation info: 
http://git.kernel.org/?p=linux/kernel/git/sfrench/cifs-backport-old-kernels.git;a=blob;f=fs/cifs/README
     shows: /pub/scm /  404 - No such project

    b) at download page (http://linux-cifs.samba.org/cifs_download.html ):
           for RHEL4...: fs/cifs src 1.34a : 
ftp://pserver.samba.org/samba/ftp/cifs-cvs/cifs-1.34-RHEL4a.tar.gz

but link to current 1.50 is OK : 
http://pserver.samba.org/samba/ftp/cifs-cvs/cifs-1.50.tar.gz

2) At start page also not clear:
     from one side -  "has been backported to compile (on 2.4 kernels, 
not just older 2.6. kernel versions)"
     from other side - "files for the fs/cifs directory which includes a 
relatively recent version of the cifs vfs which has been backported to 
build on various earlier kernels (2.6.14 or later)"

My system is:

-bash-3.00$  uname -a
Linux hostname*2.6.9*-89.0.0.0.1.ELsmp #1 SMP Tue May 19 05:31:20 EDT 
2009 x86_64 x86_64 x86_64 GNU/Linux

-bash-3.00$ cat /etc/issue
Enterprise Linux Enterprise Linux AS release 4 (October Update 8)
(this is Oracle Linux, almost 1:1 as RHEL 4.8)

So questions:
1) is it possible to make working Advanced CIFS on my platform?
2) if yes - which version of sources (or may be rpm also available) 
should I download and installed (if ot 1.50 - where can I get it)
3) Installation instructions also required.

Thanks in advance for assistance!


Best regards,

Andrey Chervonets
----------------------
CoMinder Support
http://www.cominder.eu/
GSM: +371 26517848
