From: =?iso-8859-1?Q?=22Gr=F6tzner=2C_Frank=22?= <Frank.Groetzner-R0rMR074xlY@public.gmane.org>
Subject: cifs mount with krb5 and keytab
Date: Mon, 5 Jul 2010 09:21:52 +0200
Message-ID: <56FD80EC8AC18D4285D6A4C76A79529F08D755E8@srv-os01-12.buw.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I hope I'm on the right list for this question. I'm using debian lenny and have to mount
a W2k3 share with kerberos and read the user credentials from a keytab.
I found this patch for the old cifs.spnego, but it doesn't seem to be implemented in any
version of cifs.upcall: http://fixunix.com/samba/374582-keytab-support-cifs-spnego-helper.html

If I get my credentials with "kinit foo" and mount the share afterwards using
"mount -t cifs -o sec=krb5,guest ..." it works fine. But if I try something like
"mount -t cifs -o username=foo,password=fake,sec=krb5 ..." I get "mount error 126 = Required
key not available"

My /etc/request-keys.conf looks like this:
#OP		TYPE			DESCRIPTION		CALLOUT INFO	PROGRAM ARG1 ARG2 ARG3 ...
#======	===============	===============	===============	===============================
create	cifs.spnego		*			*			/usr/sbin/cifs.upcall -c %k
create	dns_resolver	*			*			/usr/sbin/cifs.upcall %k

So what's the right way to to this? If there is no possibility, will it be sufficient to
have the credentials only at mount-time or do I have to renew them all the time the mount
exists?

Regards,
 Frank
