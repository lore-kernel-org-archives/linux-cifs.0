From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: cifs-utils VFS errors
Date: Tue, 28 May 2013 14:39:56 +0200
Message-ID: <1369744796.2769.8.camel@hh16.hh3.site>
References: <51A32117.5030908@steve-ss.com>
	 <20130528063525.1baeac8c@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130528063525.1baeac8c-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2013-05-28 at 06:35 -0400, Jeff Layton wrote:
> On Mon, 27 May 2013 11:02:15 +0200
> steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
> 
> > Hi
> > I have a s3 fileserver joined to a s4 DC
> > Here is smb.conf on the fileserver:
> > [global]
> > workgroup = HH3
> > realm = HH3.SITE
> > security = ADS
> > kerberos method = system keytab
> > winbind enum users = Yes
> > winbind enum groups = Yes
> > idmap config *:backend = tdb
> > idmap config *:range = 3000-4000
> > idmap config HH3:backend = ad
> > idmap config HH3:range = 20000-40000000
> > idmap config HH3:schema_mode = rfc2307
> > winbind nss info = rfc2307
> > winbind expand groups = 2
> > winbind nested groups = yes
> > winbind use default domain = Yes
> > 
> > [users]
> > path = /home/users
> > read only = No
> > 
> > getent passwd works fine and shows AD users. But cifs mount fails:
> >   sudo mount -t cifs //oliva/users --verbose /mnt -osec=krb5
> > mount.cifs kernel mount options: ip=127.0.0.1,unc=\\oliva
> > \users,sec=krb5,user=root,pass=********
> > mount error(13): Permission denied
> > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> > 
> > the log gives:
> > May 26 12:35:05 oliva cifs.upcall: key description:
> > cifs.spnego;0;0;39010000;ver=0x2;host=oliva;ip4=127.0.0.1;sec=krb5;uid=0x0;creduid=0x0;user=root;pid=0x6f3
> > May 26 12:35:05 oliva cifs.upcall: ver=2
> > May 26 12:35:05 oliva cifs.upcall: host=oliva
> > May 26 12:35:05 oliva cifs.upcall: ip=127.0.0.1
> > May 26 12:35:05 oliva cifs.upcall: sec=1
> > May 26 12:35:05 oliva cifs.upcall: uid=0
> > May 26 12:35:05 oliva cifs.upcall: creduid=0
> > May 26 12:35:05 oliva cifs.upcall: user=root
> > May 26 12:35:05 oliva cifs.upcall: pid=1779
> > May 26 12:35:05 oliva cifs.upcall: find_krb5_cc:
> > considering /tmp/krb5cc_0
> > May 26 12:35:05 oliva cifs.upcall: find_krb5_cc: FILE:/tmp/krb5cc_0 is
> > valid ccache
> > May 26 12:35:05 oliva cifs.upcall: handle_krb5_mech: getting service
> > ticket for oliva
> > May 26 12:35:05 oliva cifs.upcall: handle_krb5_mech: obtained service
> > ticket
> > May 26 12:35:05 oliva kernel: [  612.342045] Status code returned
> > 0xc000006d NT_STATUS_LOGON_FAILURE
> 
> Looks like the server doesn't like your ticket.
> 
> > May 26 12:35:05 oliva kernel: [  612.342109] CIFS VFS: Send error in
> > SessSetup = -13
> > May 26 12:35:05 oliva kernel: [  612.343323] CIFS VFS: cifs_mount failed
> > w/return code = -13
> > 
> > smbd fails with this:
> > Maximum core file size limits now 16777216(soft) -1(hard)
> > smbd version 3.6.9 started.
> > Copyright Andrew Tridgell and the Samba Team 1992-2011
> > uid=0 gid=0 euid=0 egid=0
> > lp_load_ex: refreshing parameters
> > Initialising global parameters
> > rlimit_max: increasing rlimit_max (1024) to minimum Windows limit
> > (16384)
> > params.c:pm_process() - Processing configuration file
> > "/etc/samba/smb.conf"
> > Processing section "[global]"
> > Registered MSG_REQ_POOL_USAGE
> > Registered MSG_REQ_DMALLOC_MARK and LOG_CHANGED
> > lp_load_ex: refreshing parameters
> > Initialising global parameters
> > rlimit_max: increasing rlimit_max (1024) to minimum Windows limit
> > (16384)
> > params.c:pm_process() - Processing configuration file
> > "/etc/samba/smb.conf"
> > Processing section "[global]"
> > Processing section "[users]"
> > adding IPC service
> > added interface eth0 ip=fe80::a00:27ff:fe7c:2d50%eth0
> > bcast=fe80::ffff:ffff:ffff:ffff%eth0 netmask=ffff:ffff:ffff:ffff::
> > added interface eth0 ip=192.168.1.110 bcast=192.168.1.255
> > netmask=255.255.255.0
> > loaded services
> > Initialise the svcctl registry keys if needed.
> > Closed policy
> > Closed policy
> > Closed policy
> > Closed policy
> > Closed policy
> > Closed policy
> > Closed policy
> > Closed policy
> > Closed policy
> > Initialise the eventlog registry keys if needed.
> > Closed policy
> > get_dc_list: preferred server list: "hh16.hh3.site, *"
> > Successfully contacted LDAP server 192.168.1.16
> > get_dc_list: preferred server list: "hh16.hh3.site, *"
> > get_dc_list: preferred server list: "hh16.hh3.site, *"
> > Successfully contacted LDAP server 192.168.1.16
> > Connected to LDAP server hh16.hh3.site
> > ads_sasl_spnego_bind: got OID=1.2.840.48018.1.2.2
> > ads_sasl_spnego_bind: got OID=1.2.840.113554.1.2.2
> > ads_sasl_spnego_bind: got OID=1.3.6.1.4.1.311.2.2.10
> > ads_sasl_spnego_bind: got server principal name =
> > not_defined_in_RFC4178@please_ignore
> > ads_krb5_mk_req: krb5_cc_get_principal failed (No credentials cache
> > found)
> > ads_cleanup_expired_creds: Ticket in ccache[MEMORY:prtpub_cache]
> > expiration dom, 26 may 2013 22:46:04 CEST
> > ads_krb5_mk_req: server marked as OK to delegate to, building
> > forwardable TGT
> > reloading printcap cache
> > reload status: ok
> > waiting for connections
> > Unable to connect to CUPS server localhost:631 - Transport endpoint is
> > not connected
> > failed to retrieve printer list: NT_STATUS_UNSUCCESSFUL
> > Could not find child 1808 -- ignoring
> > Allowed connection from 127.0.0.1 (127.0.0.1)
> > init_oplocks: initializing messages.
> > Linux kernel oplocks enabled
> > Transaction 0 of length 82 (0 toread)
> > switch message SMBnegprot (pid 1807) conn 0x0
> > Requested protocol [LM1.2X002]
> > Requested protocol [LANMAN2.1]
> > Requested protocol [NT LM 0.12]
> > Requested protocol [POSIX 2]
> > using SPNEGO
> > Selected protocol NT LM 0.12
> > Transaction 1 of length 1450 (0 toread)
> > switch message SMBsesssetupX (pid 1807) conn 0x0
> > wct=12 flg2=0xd801
> > setup_new_vc_session: New VC == 0, if NT4.x compatible we would close
> > all old resources.
> > Doing spnego session setup
> > NativeOS=[Linux version 3.8.0-22-generic] NativeLanMan=[CIFS VFS Client
> > for Linux] PrimaryDomain=[]
> > reply_spnego_negotiate: Got secblob of size 1227
> > libads/kerberos_verify.c:267: krb5_rd_req_return_keyblock_from_keytab
> > succeeded for principal host/oliva.hh3.site-UiqEU/D402Y@public.gmane.org
> > Found account name from PAC: Administrator []
> > Kerberos ticket principal name is [Administrator-UiqEU/D402Y@public.gmane.org]
> > Username HH3\Administrator is invalid on this system
> > error packet at smbd/sesssetup.c(359) cmd=115 (SMBsesssetupX)
> > NT_STATUS_LOGON_FAILURE
> > Server exit (failed to receive smb request)
> > 
> > Anyone please? In particular, why ntlm authentication? Why Username HH3
> > \Administrator is invalid on this system? I've tried without winbind use
> > default domain =  but nada.
> > 
> 
> I'm not sure I understand the question about NTLM auth. It doesn't look
> like it's being used here.
> 
> As far as why Administrator is being rejected, that's probaly a better
> question for one of the samba lists. If I had to guess though, maybe
> Samba doesn't know how to map Administrator to a local unix user on the
> server?
> 

Hi
Sorry if I'm a bit off topic  but I'm sure you're right about
Administrator being unknown to the filesystem.

 How does this sound?
- I make a domain user called cifsuser with rfc2307 uidNumber and
gidNumber:
uid=3000025(cifsuser) gid=20513(Domain Users) groups=20513(Domain Users)

- I mount like this:
sudo kinit cifsuser
mount -t cifs //oliva/users /mnt -osec=krb5
(just tried it: fine)

-I stick cifsuser in the keytab and kinit -k it in a cron every few
hours or so to keep it alive.

Thanks so much for your time,
Steve
