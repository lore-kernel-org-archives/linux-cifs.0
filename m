From: "McCall, Andy \(IT.PFMS\)" <Andy.McCall-JGeVbDYbwmjRZ1oM81ef8Q@public.gmane.org>
Subject: RE: Kerberized mount.cifs with SMB>1?
Date: Wed, 20 Aug 2014 15:44:57 +0100
Message-ID: <44E091A70C02494A806AD35E6F93AB1A32B8E3@HOSMAIL2B.ho.pfgroup.provfin.com>
References: <53F4ABCD.5040909@rug.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "Jurjen Bokma" <j.bokma-39IHFo8E5E0@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <53F4ABCD.5040909-39IHFo8E5E0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I had a problem that might be similar and I believe there is another
user on the mailing list (steve?) with the same issue.

In my case, ws.mydomain.com was the domain and during the mount process
was being resolved as the IP address of the DNS/domains servers. The DFS
referral was not taking place despite DFS being configured for DNS
within Active Directory.  CIFS was trying to be mounting ydrive from the
DNS/domain servers not the back end server with the share on, thus was
getting a permission denied error.

I wasn't able to find a solution and reverted to plain nfs mounts for my
solution.


-----Original Message-----
From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jurjen Bokma
Sent: 20 August 2014 15:08
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Kerberized mount.cifs with SMB>1?

Hi,

could anyone please tell me whether the combination
mount.cifs+Kerberos+SMB2/SMB3 is supposed to work?

>From what I see, Linux doesn't even consider Kerberos when speaking SMB2
or SMB3. After the Negotiate Protocol Response from the server, the
client sends an ACK and then follows up with an NTLMSSP_NEGOTIATE. There
is no Kerberos at all in the conversation. At least not that Wireshark
finds.

These are the commands that fail with mount error(13): Permission denied

mount.cifs  //ws.mydomain.com/ydrive  /mnt/y
-omultiuser,sec=krb5,noexec,nosuid,vers=3.0
and
kinit n123456 mount -t cifs -overs=3.0,sec=krb5
//ws.mydomain.com/homedrive/staff/user3/N123456 /mnt/x -o
uid=10123456,gid=10123456


Particularities:
- Cifs.upcall is set to run with the option '-t' (because Kerberized
NFS4 breaks without it). Removing the option doesn't help.
- These are DFS shares (if that is a correct term) with several
referrals. (Simpler shares cannot be accessed either.)
- The Kerberos server is Microsoft Server 2012 AD. Msktutil (not
winbind) was used to join the host to the AD domain.
- /proc/fs/cifs/SecurityFlags is set to 0x8009. (The default 0x85
doesn't work either.)

Things that do help:
- Use vers=1.0.
- Leave out the sec=krb5. (Get asked for a password, NTLM* works.)

So this is the status:
           SMB1 SMB2    SMB3
ntlm*   work    work    work
krb5*   work    fail        fail

Versions:
Kernel  3.17.0
Mount.cifs  6.4

I'll happily provide wireshark captures or try other situations.

FWIW, this is what the kernel ringbuffer says (after the first mount
command above):
[   75.119448] /home/apw/COD/linux/fs/cifs/cifsfs.c: Devname:
//ws.mydomain.com/ydrive flags: 0
[   75.119465] /home/apw/COD/linux/fs/cifs/connect.c: Username: root
[   75.137511] /home/apw/COD/linux/fs/cifs/connect.c: file mode: 0x1ed 
dir mode: 0x1ed
[   75.137541] /home/apw/COD/linux/fs/cifs/connect.c: CIFS VFS: in
cifs_mount as Xid: 0 with uid: 0
[   75.137543] /home/apw/COD/linux/fs/cifs/connect.c: UNC:
\\ws.mydomain.com\ydrive
[   75.137548] /home/apw/COD/linux/fs/cifs/connect.c: Socket created
[   75.137549] /home/apw/COD/linux/fs/cifs/connect.c: sndbuf 16384
rcvbuf 87380 rcvtimeo 0x6d6
[   75.137964] /home/apw/COD/linux/fs/cifs/connect.c: Demultiplex PID:
1823
[   75.137966] /home/apw/COD/linux/fs/cifs/fscache.c:
cifs_fscache_get_client_cookie: (0xffff8800c3060000/0xffff8800c3f0f000)
[   75.137969] /home/apw/COD/linux/fs/cifs/connect.c: CIFS VFS: in
cifs_get_smb_ses as Xid: 1 with uid: 0
[   75.137970] /home/apw/COD/linux/fs/cifs/connect.c: Existing smb sess
not found
[   75.137972] /home/apw/COD/linux/fs/cifs/smb2pdu.c: Negotiate protocol
[   75.137977] /home/apw/COD/linux/fs/cifs/transport.c: Sending smb:
smb_len=102
[   75.138745] /home/apw/COD/linux/fs/cifs/connect.c: RFC1002 header
0xf8
[   75.138748] /home/apw/COD/linux/fs/cifs/smb2misc.c:
smb2_check_message length: 0xfc, smb_buf_length: 0xf8
[   75.138749] /home/apw/COD/linux/fs/cifs/smb2misc.c: SMB2 data length
120 offset 128
[   75.138750] /home/apw/COD/linux/fs/cifs/smb2misc.c: SMB2 len 252
[   75.138780] /home/apw/COD/linux/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=0 mid=0 state=4
[   75.138782] /home/apw/COD/linux/fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release
[   75.138784] /home/apw/COD/linux/fs/cifs/smb2pdu.c: mode 0x3
[   75.138785] /home/apw/COD/linux/fs/cifs/smb2pdu.c: negotiated smb3.0
dialect
[   75.138786] /home/apw/COD/linux/fs/cifs/connect.c: Security Mode: 0x3
Capabilities: 0x300007 TimeAdjust: 0
[   75.138787] /home/apw/COD/linux/fs/cifs/smb2pdu.c: Session Setup
[   75.138789] /home/apw/COD/linux/fs/cifs/transport.c: Sending smb:
smb_len=120
[   75.139346] /home/apw/COD/linux/fs/cifs/connect.c: RFC1002 header
0x142
[   75.139350] /home/apw/COD/linux/fs/cifs/smb2misc.c:
smb2_check_message length: 0x146, smb_buf_length: 0x142
[   75.139351] /home/apw/COD/linux/fs/cifs/smb2misc.c: SMB2 data length
250 offset 72
[   75.139352] /home/apw/COD/linux/fs/cifs/smb2misc.c: SMB2 len 326
[   75.139381] /home/apw/COD/linux/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=1 mid=1 state=4
[   75.139384] /home/apw/COD/linux/fs/cifs/smb2maperror.c: Mapping SMB2
status code -1073741802 to POSIX err -5
[   75.139385] /home/apw/COD/linux/fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release
[   75.156277] /home/apw/COD/linux/fs/cifs/transport.c: Sending smb:
smb_len=416
[   75.157777] /home/apw/COD/linux/fs/cifs/connect.c: RFC1002 header
0x49
[   75.157781] /home/apw/COD/linux/fs/cifs/smb2misc.c:
smb2_check_message length: 0x4d, smb_buf_length: 0x49
[   75.157782] /home/apw/COD/linux/fs/cifs/smb2misc.c: SMB2 data length
0 offset 0
[   75.157783] /home/apw/COD/linux/fs/cifs/smb2misc.c: SMB2 len 77
[   75.157803] /home/apw/COD/linux/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=1 mid=2 state=4
[   75.157806] Status code returned 0xc000006d STATUS_LOGON_FAILURE
[   75.157810] /home/apw/COD/linux/fs/cifs/smb2maperror.c: Mapping SMB2
status code -1073741715 to POSIX err -13
[   75.157811] /home/apw/COD/linux/fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release
[   75.157812] CIFS VFS: Send error in SessSetup = -13
[   75.157815] /home/apw/COD/linux/fs/cifs/connect.c: CIFS VFS: leaving
cifs_get_smb_ses (xid = 1) rc = -13
[   75.157817] /home/apw/COD/linux/fs/cifs/fscache.c:
cifs_fscache_release_client_cookie:
(0xffff8800c3060000/0xffff8800c3f0f000)
[   75.157864] /home/apw/COD/linux/fs/cifs/connect.c: CIFS VFS: leaving
cifs_mount (xid = 0) rc = -13
[   75.157866] CIFS VFS: cifs_mount failed w/return code = -13

Many thanks!
Jurjen Bokma


--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
DISCLAIMER. The contents of this email and its attachments are intended solely for the original recipients and express the views of the authors and not necessarily the Company. If you are not the intended recipient please delete without copying or forwarding and inform the sender that you received it in error. 
Provident Financial Management Services Ltd, Registered in England, Company Number 328933. Interim Permissions Reference Number: 119219
Provident Personal Credit Ltd, Registered in England, Company Number 146091. Interim Permissions Reference Number: 002529
Both Provident Financial Management Services Ltd and Provident Personal Credit Ltd are authorised and regulated by the Financial Conduct Authority, see Interim Permissions numbers above. Registered Office: No.1 Godwin Street, Bradford, West Yorkshire BD1 2SU, United Kingdom.
 
Please save paper - don't print this email unless necessary
