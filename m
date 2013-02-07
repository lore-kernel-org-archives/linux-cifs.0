From: Michael Wilke <m@1982.cc>
Subject: smbclient fails to connect with kerberos
Date: Thu, 07 Feb 2013 15:05:07 +0300
Message-ID: <1360238707.5080.40.camel@ub64-mmrp-it>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dear all,

I hope you could assist me in finding a problem with samba and krb
connects.

I have a samba server as a AD 2k3 domain member and the connects are
working well, but when I try to use krb auth to connect to another
Windows server in the network I get an error.

I would appreciate some hint in the right direction to get this working.

Thanks!

---
smbclient -d 3 //gunter/software -k -o user=micha
lp_load_ex: refreshing parameters
Initialising global parameters
rlimit_max: increasing rlimit_max (1024) to minimum Windows limit
(16384)
params.c:pm_process() - Processing configuration file
"/etc/samba/smb.conf"
Processing section "[global]"
WARNING: The "idmap uid" option is deprecated
WARNING: The "idmap gid" option is deprecated
...
Client started (version 3.6.3).
Connecting to 10.10.10.8 at port 445
Doing spnego session setup (blob length=110)
got OID=1.2.840.48018.1.2.2
got OID=1.2.840.113554.1.2.2
got OID=1.2.840.113554.1.2.2.3
got OID=1.3.6.1.4.1.311.2.2.10
got principal=gunter$@CITY.DOMAIN.ORG
Doing kerberos session setup
ads_cleanup_expired_creds: Ticket in ccache[FILE:/tmp/krb5cc_0]
expiration Thu, 07 Feb 2013 21:20:36 EAT
ads_krb5_mk_req: server marked as OK to delegate to, building
forwardable TGT
krb5_fwd_tgt_creds failed (KDC can't fulfill requested option)
OS=[Windows Server 2003 R2 3790 Service Pack 2] Server=[Windows Server
2003 R2 5.2]
tree connect failed: NT_STATUS_ACCESS_DENIED

---


As you can see kinit and klist etc works, but the connection always got
denied. 

If I use standard smbclient connection it works fine:
---
smbclient -d 3 -U micha //gunter/software
...

Client started (version 3.6.3).
Enter micha's password: 
Connecting to 10.10.10.8 at port 445
Doing spnego session setup (blob length=110)
got OID=1.2.840.48018.1.2.2
got OID=1.2.840.113554.1.2.2
got OID=1.2.840.113554.1.2.2.3
got OID=1.3.6.1.4.1.311.2.2.10
got principal=gunter$@CITY.DOMAIN.ORG
Got challenge flags:
Got NTLMSSP neg_flags=0x62898215
NTLMSSP: Set final flags:
Got NTLMSSP neg_flags=0x60088215
NTLMSSP Sign/Seal - Initialising with flags:
Got NTLMSSP neg_flags=0x60088215
Domain=[DOMAIN] OS=[Windows Server 2003 R2 3790 Service Pack 2]
Server=[Windows Server 2003 R2 5.2]
smb: \> 

---



samba version:
smbd --version
Version 3.6.3

smb.conf:
[global]
        security = ads
        realm = CITY.DOMAIN.ORG
        netbios name = RESEARCH-SERVER
        password server = 10.10.10.17 # PDC
        client use spnego = yes
        client use spnego principal = true
