From: "Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Subject: kernel: CIFS VFS: Send error in Flush/Close = -9
Date: Fri, 22 Feb 2013 08:14:44 -0600 (CST)
Message-ID: <106758567.419.1361542484469.JavaMail.root@hendelman.net>
References: <1633991966.227.1361541137779.JavaMail.root@hendelman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1633991966.227.1361541137779.JavaMail.root-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'm getting some strange error messages in /var/log/kern.log.

 kernel: [66276.873095] CIFS VFS: Send error in Flush = -9
 kernel: [66287.828329] CIFS VFS: Send error in Flush = -9
 kernel: [66287.829180] CIFS VFS: Send error in Flush = -9
 kernel: [66289.243979] CIFS VFS: Send error in Flush = -9

My desktop is Ubuntu 12.10 and has kernel 3.5.0-24-generic w/ cifs module version 1.78 (as per modinfo cifs).

I've mounted a test server share (Ubuntu 12.04) with the following options as per "cat /etc/fstab"

//cifserver/data	/data	cifs	noauto,strictcache,sec=krb5i,multiuser,acl,username=MYDESKTOP$	0	2

Other than this, the share seems to work fine.

Is this something I should be concerned with or is it more informational?

Robert
