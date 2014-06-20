From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: cifs SRV record
Date: Fri, 20 Jun 2014 14:14:29 +0200
Message-ID: <1403266469.4713.13.camel@hh16.hh3.site>
References: <1403101167.9166.6.camel@hh16.hh3.site>
	 <0a840b51be30d5535ae0b7f59f83e5c1.squirrel@mail.balsover.com>
	 <CAH2r5ms5sf=vuv4QmiX6Kn6PB147M84RKKWxaEALOc-gkjHW7A@mail.gmail.com>
	 <1403177645.2624.22.camel@hh16.hh3.site>
	 <ade7375f4969bf94f8cd295fd8582175.squirrel@192.168.10.1>
	 <1403197075.3512.15.camel@hh16.hh3.site>
	 <1f2c7d0562b364b3e0cb64cfff542572.squirrel@192.168.10.1>
	 <1403198451.3996.2.camel@hh16.hh3.site>
	 <95bba2d5bdc8bace63767403f26e4c79.squirrel@mail.balsover.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Bob Balsover <cifs-MPfZBXey4klWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <95bba2d5bdc8bace63767403f26e4c79.squirrel-vQd1aa0lCeAC/Zx7Cl00UAC/G2K4zDHf@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2014-06-19 at 12:17 -0700, Bob Balsover wrote:
> Steve, you appear to be beating a dead horse. Assuming you are using a
> somewhat current kernel just place the DFS share in your client's
> configuration file and try it. I am currently working with this kernel
> code and it works fine.

OK, here's our first attempt:

[global]
workgroup = HH3
realm = HH3.SITE
security = ADS
kerberos method = system keytab
host msdfs = yes

[users]
path = /home/users
read only = No

[dfs]
path = /home/samba/dfs
msdfs root = yes
- - -

alfaz:/home/samba/dfs # ls -l
total 0
lrwxrwxrwx 1 root root 17 Jun 20 13:57 users -> msdfs:alfaz\users
- - -

klist -k
Keytab name: FILE:/etc/krb5.keytab
KVNO Principal
----
--------------------------------------------------------------------------
   1 host/alfaz.hh3.site-UiqEU/D402Y@public.gmane.org
   1 host/alfaz.hh3.site-UiqEU/D402Y@public.gmane.org
   1 host/alfaz.hh3.site-UiqEU/D402Y@public.gmane.org
   1 host/alfaz.hh3.site-UiqEU/D402Y@public.gmane.org
   1 host/alfaz.hh3.site-UiqEU/D402Y@public.gmane.org
   1 host/alfaz-UiqEU/D402Y@public.gmane.org
   1 host/alfaz-UiqEU/D402Y@public.gmane.org
   1 host/alfaz-UiqEU/D402Y@public.gmane.org
   1 host/alfaz-UiqEU/D402Y@public.gmane.org
   1 host/alfaz-UiqEU/D402Y@public.gmane.org
   1 ALFAZ$@HH3.SITE
   1 ALFAZ$@HH3.SITE
   1 ALFAZ$@HH3.SITE
   1 ALFAZ$@HH3.SITE
   1 ALFAZ$@HH3.SITE
   1 cifsuser-UiqEU/D402Y@public.gmane.org


This works fine:
 mount -t cifs //alfaz/dfs/users /mnt
-osec=krb5,username=cifsuser,multiuser

cifsuser gets a ticket:
klist
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: cifsuser-UiqEU/D402Y@public.gmane.org

Valid starting       Expires              Service principal
06/20/2014 13:20:31  06/20/2014 23:20:31  krbtgt/HH3.SITE-UiqEU/D402Y@public.gmane.org
	renew until 06/21/2014 13:20:31
06/20/2014 13:35:32  06/20/2014 23:20:31  cifs/alfaz@
	renew until 06/21/2014 13:20:31
06/20/2014 13:35:32  06/20/2014 23:20:31  cifs/alfaz-UiqEU/D402Y@public.gmane.org
	renew until 06/21/2014 13:20:31

And the share is mounted:
ls /mnt
Administrator  br2  cifsuser  julie  julie2  lynn2  steve2  steve3 
However, there's no advantage in using dfs for that becaause we've had
to specify the server.

But that's not what we want. So, after some googling, we include the
domain:
mount -t cifs //hh3.site/dfs/users /mnt
-osec=krb5,username=cifsuser,multiuser
mount error(126): Required key not available
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
It doesn't mount.

And the KDC responds:
Kerberos: TGS-REQ cifsuser-UiqEU/D402Y@public.gmane.org from ipv4:192.168.1.102:51585 for
cifs/hh3.site-UiqEU/D402Y@public.gmane.org [canonicalize, renewable]
Kerberos: Searching referral for hh3.site
Kerberos: Returning a referral to realm SITE for server
cifs/hh3.site-UiqEU/D402Y@public.gmane.org that was not found
Failed find a single entry for
(&(objectClass=trustedDomain)(|(flatname=SITE)(trustPartner=SITE))): got
0
Kerberos: samba_kdc_fetch: could not find principal in DB
Kerberos: Server not found in database: krbtgt/SITE-UiqEU/D402Y@public.gmane.org: no such
entry found in hdb
Kerberos: Failed building TGS-REP to ipv4:192.168.1.102:51585
Terminating connection - 'kdc_tcp_call_loop:
tstream_read_pdu_blob_recv() - NT_STATUS_CONNECTION_DISCONNECTED'
single_terminate: reason[kdc_tcp_call_loop: tstream_read_pdu_blob_recv()
- NT_STATUS_CONNECTION_DISCONNECTED]
Kerberos: TGS-REQ cifsuser-UiqEU/D402Y@public.gmane.org from ipv4:192.168.1.102:51586 for
krbtgt/SITE-UiqEU/D402Y@public.gmane.org [renewable]
Failed find a single entry for
(&(objectClass=trustedDomain)(|(flatname=SITE)(trustPartner=SITE))): got
0
Kerberos: samba_kdc_fetch: could not find principal in DB
Kerberos: Server not found in database: krbtgt/SITE-UiqEU/D402Y@public.gmane.org: no such
entry found in hdb
Kerberos: Failed building TGS-REP to ipv4:192.168.1.102:51586

How do we tell cifs to look in the domain for a dfs share server?

Samba4 DC running samba with Samba4 file server running smbd all on
openSUSE 13.1

Thanks for your patience.
Steve
