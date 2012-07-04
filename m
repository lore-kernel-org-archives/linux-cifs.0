From: Milan =?UTF-8?Q?Kn=C3=AD=C5=BEek?= <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mount.cifs multiuser w/o krb5? How?
Date: Wed, 04 Jul 2012 20:52:17 +0200
Message-ID: <1341427937.3252.6.camel@athlon.garagome>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I would like to have a single cifs mount accessible by multiple users
allowing them to create files with their respective uid.

Having spent some time on RTFM and Google search on this mailing list,
it seems that the "multiuser" option of mount.cifs could make me happy.
And it should work now also for systems w/o krb5.


My intention is to avoid use of any directory services or domain (small
network of mainly linux clients). The test platform (both server and
client) are Arch linux, kernel 3.4.4-2-ARCH x86-64, cifs-utils 5.4-1.

The smb.conf on the server has
security = user
client ntlmv2 auth = yes

I can post full smb.conf, if needed. Users have the same uid on both
client and server.

>From the client, I am able to mount - as root - //server/share with
credentials of user1 and user1 can access the share. Mounting and
accessing works also for user2.

[root@client /]$ mount
//server/share on /mnt type cifs (rw,relatime,sec=ntlmv2,unc=\\server
\share,username=user1,domain=WORKGROUP,uid=0,noforceuid,gid=0,
noforcegid,addr=192.168.1.3,unix,posixpaths,serverino,acl,
rsize=1048576,wsize=65536,actimeo=1

To move on for multiuser: adding the credentials to the keyring:
[user1@client /]$ cifscreds add server
and typing in the password.

(Similarly for user2.)

When I remount the same share with "multiuser" option with the
credentials of user1, the share is accessible only by the root user, the
users user1 and user2 cannot list the mount point (cannot access /mnt:
Permission denied)

What do I do wrong?

Adding cifscreds has exit code 0. Running "cifscreds clearall" results
in "You have no stashed cifs credentials. If you want to add them use:
cifscreds add" and exit code 1. That's weird.

The manpage of cifscreds reads "The cifscreds utility requires a kernel
built with support for the login key type." What is the name of kernel
config option to check?

Further it reads "When a cifs filesystem is mounted with the "multiuser"
option, and does not use krb5 authentication, it needs to be able to get
the credentials for each user from somewhere. The cifscreds program is
the tool used to provide these credentials to the kernel."

However, man page of mount.cifs mentions "Because the kernel cannot
prompt for passwords, multiuser mounts are limited to mounts using sec=
options that don't require passwords." Does that include NTLMv2 or its
variants? Do I have to do something extra to let the kernel know about
the credentials?

Thanks for any hints.

Regards,
Milan
-- 
http://milan-knizek.net
About linux and photography (Czech only)
