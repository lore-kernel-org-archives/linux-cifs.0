From: Robert Euhus <euhus-liste1-RRsrufEBJWcjwdJHFrQ6C0zuTB+3w3uf@public.gmane.org>
Subject: Can't mount domain share any more -> "mount error(112): Host is down"
 ; smbclient works with '-m SMB3'
Date: Wed, 10 Jun 2015 16:14:04 +0200
Message-ID: <5578462C.6030104@rrzn.uni-hannover.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I have a strange problem: Suddenly I can not mount our domain shares any
more, but browsing with smbclient works, if I specify '-m SMB3'.

After an update to out domain controller (Windosw Server 2012) which
also serves the shares, I can not mount the shares anymore. I am usually
using Kerberos-Tickets to mount the shares.

If I do not use Kerberos-Authentification I was able to mount the shares
explicitly specifying 'vers=2.0'.

I also had problems authenticating against the AD with Winbind, which
went away when I specified the following in /etc/samba/smb.conf:

> client max protocol = smb3_00

Even though from the man page this should be the default anyway.


Here is an overview over what works and what does not:

This does not work:

> mount.cifs //mydom-dc1.mydom.intern/groups /mnt/groups -o sec=krb5i,multiuser
> mount error(112): Host is down

The same result without the 'multiuser' option.

> mount.cifs //mydom-dc1.mydom.intern/groups /mnt/groups -o username=myuser
> Password for myuser@//mydom-dc1.mydom.intern/groups:  ***********
> mount error(112): Host is down

But this works:

> mount.cifs //mydom-dc1.mydom.intern/groups /mnt/groups -o username=myuser,vers=2.0
> Password for myuser@//mydom-dc1.mydom.intern/groups:  ***********

In short: mounting with Kerberos is completely broken, without Kerberos
it can be made to work again. I really need the Kerberos multiuser mount.


The same pattern with smbclient: if no max-protocol is specified, then
the command fails:

> smbclient -U myuser //mydom-dc1.mydom.intern/groups 
> Enter myuser's password: 
> protocol negotiation failed: NT_STATUS_CONNECTION_RESET

But this works:

> smbclient -U myuser //mydom-dc1.mydom.intern/groups -m SMB3
> Enter myuser's password: 
> Domain=[MYDOM] OS=[] Server=[]
> smb: \> 

The smbclient command works as well, if 'client max protocol = smb3' is
specified in /etc/samba/smb.conf.

Strangely specifying the '-m SMB3' before the share, as listed in the
man page does not work:

> smbclient -m SMB3 -U myuser //mydom-dc1.mydom.intern/groups
> Enter myuser's password: 
> session setup failed: NT_STATUS_LOGON_FAILURE

We also had a problem with one OSX-client, which had explicitly
specified to use SMB1 only, but this problem went away, after removing
this non-default option.

The problems mentioned above were occurred on a Debian Jessie and an
Ubuntu 14.04 install. On a Debian-Squeeze I could not get Winbind to
work again by specifying a 'client max protocol'.


I would be grateful for any hint on what to look for, since I am
completely out of ideas.

Thanks a lot,
Robert Euhus
