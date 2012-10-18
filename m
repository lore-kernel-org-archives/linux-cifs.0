From: Jeff Layton <jlayton@redhat.com>
Subject: Re: mount.cifs: regular freezes with s3fs
Date: Thu, 18 Oct 2012 05:48:12 -0400
Message-ID: <20121018054812.7a1ef6dd@tlielax.poochiereds.net>
References: <507FBB3D.70203@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "samba@lists.samba.org" <samba@lists.samba.org>, linux-cifs@vger.kernel.org
To: steve <steve@steve-ss.com>
Return-path: <samba-bounces@lists.samba.org>
In-Reply-To: <507FBB3D.70203@steve-ss.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba>,
	<mailto:samba-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba>
List-Post: <mailto:samba@lists.samba.org>
List-Help: <mailto:samba-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba>,
	<mailto:samba-request@lists.samba.org?subject=subscribe>
Sender: samba-bounces@lists.samba.org
Errors-To: samba-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 18 Oct 2012 10:18:05 +0200
steve <steve@steve-ss.com> wrote:

> cifs-utils-5.6
> samba Version 4.0.0rc3
> openSUSE 12.2
> LAN of XP, w7 and Linux clients under Samba4 DC and s3fs fileserver
> 
> Hi
> I am testing the possibility of migrating from nfs to cifs to serve our 
> Linux clients.
> 
> Currently we mount the samba shares, e.g. the home directory, using nfs.
> 
> The test setup is that instead of:
> mount -t nfs hh1:/home2 /home2 -osec=rw,krb5
> I changed to:
> mount -t cifs //hh1/home2 /home2 -osec=rw,sec=krb5,multiuser
> 
> This works fine for console logins, but is very slow (unusable) for 
> graphical logins to either LXDE or XFCE.
> 
> The login sometimes works:
> Kerberos: AS-REQ steve3@HH3.SITE from ipv4:192.168.1.41:57380 for 
> krbtgt/HH3.SITE@HH3.SITE
> Kerberos: Client sent patypes: 149
> Kerberos: Looking for PKINIT pa-data -- steve3@HH3.SITE
> Kerberos: Looking for ENC-TS pa-data -- steve3@HH3.SITE
> Kerberos: No preauth found, returning PREAUTH-REQUIRED -- steve3@HH3.SITE
> Kerberos: AS-REQ steve3@HH3.SITE from ipv4:192.168.1.41:41237 for 
> krbtgt/HH3.SITE@HH3.SITE
> Kerberos: Client sent patypes: encrypted-timestamp, 149
> Kerberos: Looking for PKINIT pa-data -- steve3@HH3.SITE
> Kerberos: Looking for ENC-TS pa-data -- steve3@HH3.SITE
> Kerberos: ENC-TS Pre-authentication succeeded -- steve3@HH3.SITE using 
> arcfour-hmac-md5
> Kerberos: AS-REQ authtime: 2012-10-18T09:57:33 starttime: unset endtime: 
> 2012-10-18T19:57:33 renew till: 2012-10-19T09:55:48
> Kerberos: Client supported enctypes: aes256-cts-hmac-sha1-96, 
> aes128-cts-hmac-sha1-96, des3-cbc-sha1, arcfour-hmac-md5, using 
> arcfour-hmac-md5/arcfour-hmac-md5
> Kerberos: Requested flags: renewable, forwardable
> Kerberos: TGS-REQ steve3@HH3.SITE from ipv4:192.168.1.41:50790 for 
> host/hh7.hh3.site@HH3.SITE [canonicalize, renewable, forwardable]
> Kerberos: TGS-REQ authtime: 2012-10-18T09:57:33 starttime: 
> 2012-10-18T09:57:33 endtime: 2012-10-18T10:02:33 renew till: 
> 2012-10-19T09:55:48
> Kerberos: TGS-REQ steve3@HH3.SITE from ipv4:192.168.1.41:44350 for 
> cifs/hh1@HH3.SITE [canonicalize, renewable, forwardable]
> Kerberos: TGS-REQ authtime: 2012-10-18T09:57:33 starttime: 
> 2012-10-18T09:57:33 endtime: 2012-10-18T19:57:33 renew till: 
> 2012-10-19T09:55:48
> 
> But then as soon as we open the file manager (or do anything else) it 
> freezes for as long as 5 minutes, before it makes another cifs request 
> and comes alive for a while:
> 
> Terminating connection - 'wbsrv_call_loop: tstream_read_pdu_blob_recv() 
> - NT_STATUS_CONNECTION_DISCONNECTED'
> single_terminate: reason[wbsrv_call_loop: tstream_read_pdu_blob_recv() - 
> NT_STATUS_CONNECTION_DISCONNECTED]
> Kerberos: TGS-REQ steve3@HH3.SITE from ipv4:192.168.1.41:58872 for 
> cifs/hh1@HH3.SITE [canonicalize, renewable, forwardable]
> Kerberos: TGS-REQ authtime: 2012-10-18T09:57:33 starttime: 
> 2012-10-18T09:59:58 endtime: 2012-10-18T19:57:33 renew till: 
> 2012-10-19T09:55:48
> 
> It is then OK for a few minutes more until it freezes again until the 
> next cifs request etc etc. . .
> 
> This sometimes occurs in the samba log but with different files each time:
> usr/local/samba/sbin/smbd: Oplock break failed for file 
> home/steve3/.cache/openbox/openbox.log -- replying anyway
> 
> Here is the test smb.conf:
> 
> # Global parameters
> [global]
>          workgroup = MARINA
>          realm = hh3.site
>          netbios name = HH1
>          server role = active directory domain controller
>          dns forwarder = 192.168.1.1
>          idmap_ldb:use rfc2307 = Yes
>          unix extensions = Yes
>          panic action = /home/steve/samba-master/selftest/gdb_backtrace %d
> 
> [netlogon]
>          path = /usr/local/samba/var/locks/sysvol/hh3.site/scripts
>          read only = No
> 
> [sysvol]
>          path = /usr/local/samba/var/locks/sysvol
>          read only = No
> 
> [home2]
>          path = /home2
>          read only = No
> 
> Here is the wireshark of a login and a 'cifs freeze'.
> https://dl.dropbox.com/u/45150875/cifs-freeze
> 
> Please note that this works fine for the same user and data with both 
> nfs3 and nfs4.
> 

I think you probably want send this sort of thing to
linux-cifs@vger.kernel.org (cc'ed here), and not to me directly.

What kernel is the client running here?

-- 
Jeff Layton <jlayton@redhat.com>
-- 
To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba
