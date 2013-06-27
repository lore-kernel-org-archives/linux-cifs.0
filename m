From: Thomas Wolff <towo-JHPtuYzOr/0@public.gmane.org>
Subject: mount error 79 = Can not access a needed shared library
Date: Thu, 27 Jun 2013 22:50:14 +0200
Message-ID: <51CCA586.1070105@towo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

My attempt to mount with -o iocharset=utf8 fails with this message:
mount error 79 = Can not access a needed shared library

By google, I found one hint to "compile and install" nls_utf8.ko but 
without a mention of where to get that from or how to proceed anyway 
(very funny).

The system is Debian on a ppc, uname -a:
Linux MyBookLive 2.6.32.11-svn21605 #1 Fri Oct 15 17:13:23 PDT 2010 ppc 
GNU/Linux

aptitude search does not show any useful results for nls

------
Thomas
