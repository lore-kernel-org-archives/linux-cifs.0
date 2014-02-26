From: "Ross, Matt" <m.g.ross-OfppCuUFkUX10XsdtD+oqA@public.gmane.org>
Subject: Using PAM module without Kerberos
Date: Wed, 26 Feb 2014 15:53:52 +0000
Message-ID: <BC8B39086BF9F141A4EB3AAF7D7AAF2E026E5E69D5@UH-MAILSTOR.herts.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I am trying to add credentials to a multiuser mounted CIFS share using the new PAM module. We do not have Kerberos (and I suspect that's the problem). Our users are in an Edirectory LDAP server. I have compiled from source cifs-utils 6.3, keyutils 1.5.8 and Linux kernel 3.13.3 with all CIFS features enabled. This is an x64 Debian Jessie installation.

Currently I can mount the volume successfully at system boot using:

//cifsserver/share1   /mnt1   cifs    sec=ntlmv2,noserverino,multiuser,user=user1,pass=user1pass

The 'user1' user has limited read rights. When a user logs in I am hoping 'pam_cifscreds' can add their credentials. These are the relevant PAM files:

common-account:
account sufficient      pam_unix.so
account required        pam_ldap.so use_first_pass

common-auth:
auth    sufficient      pam_unix.so nullok_secure
auth    required        pam_ldap.so use_first_pass
auth    required        pam_cifscreds.so debug

common-password:
password        sufficient      pam_unix.so nullok obscure min=4 max=8 md5
password        required        pam_ldap.so use_first_pass

common-session:
session optional        pam_keyinit.so force revoke debug
session sufficient      pam_unix.so
session required        pam_ldap.so use_first_pass
session optional        pam_cifscreds.so cifsserver.ourdomain debug

Login succeeds for the user but access to their home directory fails:

Could not chdir to home directory /mnt1/user1: Permission denied
cp: failed to access '/mnt1/user1/Desktop': Permission denied
-bash: /mnt1/user1/.bash_profile: Permission denied

At this point the logged in user can manually run 'cifscreds add -u user1 cifsserver' and after entering the password access is granted to their home directory. From then on everything appears to work correctly.

Syslog contains:

Feb 26 15:13:06 pc1 kernel: [   53.466080] type=1006 audit(1393427586.425:2): pid=3370 uid=0 old auid=4294967295 new auid=2471 old ses=4294967295 new ses=1 res=1
Feb 26 15:13:06 pc1 cifs.upcall: key description: logon;2471;12742;3d010000;cifs:a:192.168.1.15
Feb 26 15:13:06 pc1 cifs.upcall: unable to get necessary params from key description (0x0)
Feb 26 15:13:06 pc1 cifs.upcall: Exit status 1

As a failed experiment I tried creating '/etc/request-key.d/logon.conf' containing:

create  logon    * * /usr/sbin/cifs.upcall %k


So my question is this: can the pam_cifscreds module be used without Kerberos? If not how could I add the manual 'cifscreds add ...' command into a PAM module to do this without the user having to run that command once logged in?

Thanks,

Matt Ross
