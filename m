From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: smbclient fails to connect with kerberos
Date: Thu, 7 Feb 2013 21:03:33 -0500
Message-ID: <20130207210333.2c31e1b9@corrin.poochiereds.net>
References: <1360238707.5080.40.camel@ub64-mmrp-it>
	<1360239886.5080.43.camel@ub64-mmrp-it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Michael Wilke <m@1982.cc>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360239886.5080.43.camel@ub64-mmrp-it>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 07 Feb 2013 15:24:46 +0300
Michael Wilke <m@1982.cc> wrote:

> Additional I append the important smbclient -d 10 part.
> 
> I really don't know why it is sending a wrong signature?
> 
> ---
>  Doing spnego session setup (blob length=110)
> got OID=1.2.840.48018.1.2.2
> got OID=1.2.840.113554.1.2.2
> got OID=1.2.840.113554.1.2.2.3
> got OID=1.3.6.1.4.1.311.2.2.10
> got principal=gunter$@CITY.DOMAIN.ORG
> Doing kerberos session setup
> ads_cleanup_expired_creds: Ticket in ccache[FILE:/tmp/krb5cc_0]
> expiration Thu, 07 Feb 2013 21:55:16 EAT
> ads_krb5_mk_req: Ticket (gunter$@CITY.DOMAIN.ORG) in ccache
> (FILE:/tmp/krb5cc_0) is valid until: (Thu, 07 Feb 2013 21:55:16 EAT -
> 1360263316)
> ads_krb5_mk_req: server marked as OK to delegate to, building
> forwardable TGT
> krb5_fwd_tgt_creds failed (KDC can't fulfill requested option)
> Got KRB5 session key of length 16
> smb_signing_sign_pdu: sent SMB signature of
> [0000] 42 53 52 53 50 59 4C 20                            BSRSPYL  
> smb_signing_activate: user_session_key
> [0000] F5 25 18 D8 29 67 3C 30   E8 5B 12 6E 7D 0C 63
> 79   .%..)g<0 .[.n}.cy
> smb_signing_activate: NULL response_data
> smb_signing_md5: sequence number 1
> smb_signing_check_pdu: BAD SIG: wanted SMB signature of
> [0000] ED DD 62 90 40 5A 9D FF                            ..b.@Z.. 
> smb_signing_check_pdu: BAD SIG: got SMB signature of
> [0000] 42 53 52 53 50 59 4C 20                            BSRSPYL  
> smb_signing_md5: sequence number 4294967292
> smb_signing_md5: sequence number 4294967293
> smb_signing_md5: sequence number 4294967294
> smb_signing_md5: sequence number 4294967295
> smb_signing_md5: sequence number 0
> smb_signing_md5: sequence number 1
> smb_signing_md5: sequence number 2
> smb_signing_md5: sequence number 3
> smb_signing_md5: sequence number 4
> smb_signing_md5: sequence number 5
> smb_signing_good: signing negotiated but not required and peer
> isn't sending correct signatures. Turning off.
> cli_init_creds: user micha domain DOMAIN
> OS=[Windows Server 2003 R2 3790 Service Pack 2] Server=[Windows Server
> 2003 R2 5.2]
>  session setup ok
>  tconx ok
> 
> ---
> 
> 
> On Thu, 2013-02-07 at 15:05 +0300, Michael Wilke wrote:
> > Dear all,
> > 
> > I hope you could assist me in finding a problem with samba and krb
> > connects.
> > 
> > I have a samba server as a AD 2k3 domain member and the connects are
> > working well, but when I try to use krb auth to connect to another
> > Windows server in the network I get an error.
> > 
> > I would appreciate some hint in the right direction to get this working.
> > 
> > Thanks!
> > 
> > ---
> > smbclient -d 3 //gunter/software -k -o user=micha
> > lp_load_ex: refreshing parameters
> > Initialising global parameters
> > rlimit_max: increasing rlimit_max (1024) to minimum Windows limit
> > (16384)
> > params.c:pm_process() - Processing configuration file
> > "/etc/samba/smb.conf"
> > Processing section "[global]"
> > WARNING: The "idmap uid" option is deprecated
> > WARNING: The "idmap gid" option is deprecated
> > ...
> > Client started (version 3.6.3).
> > Connecting to 10.10.10.8 at port 445
> > Doing spnego session setup (blob length=110)
> > got OID=1.2.840.48018.1.2.2
> > got OID=1.2.840.113554.1.2.2
> > got OID=1.2.840.113554.1.2.2.3
> > got OID=1.3.6.1.4.1.311.2.2.10
> > got principal=gunter$@CITY.DOMAIN.ORG
> > Doing kerberos session setup
> > ads_cleanup_expired_creds: Ticket in ccache[FILE:/tmp/krb5cc_0]
> > expiration Thu, 07 Feb 2013 21:20:36 EAT
> > ads_krb5_mk_req: server marked as OK to delegate to, building
> > forwardable TGT
> > krb5_fwd_tgt_creds failed (KDC can't fulfill requested option)
> > OS=[Windows Server 2003 R2 3790 Service Pack 2] Server=[Windows Server
> > 2003 R2 5.2]
> > tree connect failed: NT_STATUS_ACCESS_DENIED
> > 
> > ---
> > 
> > 
> > As you can see kinit and klist etc works, but the connection always got
> > denied. 
> > 
> > If I use standard smbclient connection it works fine:
> > ---
> > smbclient -d 3 -U micha //gunter/software
> > ...
> > 
> > Client started (version 3.6.3).
> > Enter micha's password: 
> > Connecting to 10.10.10.8 at port 445
> > Doing spnego session setup (blob length=110)
> > got OID=1.2.840.48018.1.2.2
> > got OID=1.2.840.113554.1.2.2
> > got OID=1.2.840.113554.1.2.2.3
> > got OID=1.3.6.1.4.1.311.2.2.10
> > got principal=gunter$@CITY.DOMAIN.ORG
> > Got challenge flags:
> > Got NTLMSSP neg_flags=0x62898215
> > NTLMSSP: Set final flags:
> > Got NTLMSSP neg_flags=0x60088215
> > NTLMSSP Sign/Seal - Initialising with flags:
> > Got NTLMSSP neg_flags=0x60088215
> > Domain=[DOMAIN] OS=[Windows Server 2003 R2 3790 Service Pack 2]
> > Server=[Windows Server 2003 R2 5.2]
> > smb: \> 
> > 
> > ---
> > 
> > 
> > 
> > samba version:
> > smbd --version
> > Version 3.6.3
> > 
> > smb.conf:
> > [global]
> >         security = ads
> >         realm = CITY.DOMAIN.ORG
> >         netbios name = RESEARCH-SERVER
> >         password server = 10.10.10.17 # PDC
> >         client use spnego = yes
> >         client use spnego principal = true
> > 
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 

This mailing list is for the in-kernel CIFS filesystem for linux. You
probably want to send this question to a list like
samba-w/Ol4Ecudpk8XQGcEXnhXA@public.gmane.org

Cheers,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
