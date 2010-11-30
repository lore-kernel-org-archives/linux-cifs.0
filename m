From: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Subject: Unable to access (remote) DFS links in DFS root
Date: Tue, 30 Nov 2010 22:06:02 +0100
Message-ID: <4CF5673A.9010200@exx.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi again,

I'm having problems accessing remote DFS links on our DFS root, using
mount.cifs.

We have a DFS root that has links pointing to a variety of shares on
different file servers.

>From MS Windows clients and using smbclient the shares are accessible
perfectly. Using mount.cifs however I am not able to see the contents of
the remote shares.

Surprisingly, I get a different error when mounting the DFS root with
sec=ntlm, than I get when mounting with sec=ntlmv2.

# mount -t cifs //foxdft13.fox.local/company /mnt/bla/ -o
credentials=/creds,sec=ntlm
# ls -la /mnt/bla/Global/
ls: cannot access /mnt/bla/Global/: Input/output error

# mount -t cifs //foxdft13.fox.local/company /mnt/bla/ -o
credentials=/creds,sec=ntlmv2
# ls -la /mnt/bla/Global/
ls: cannot access /mnt/bla/Global/: Permission denied

Kernel is 2.6.37-rc3. mount.cifs is 4.5. keyutils are installed and
working. DFS root is on foxdft13. The "Global" share is on foxdft08.
Note that the foxdft08 server is configured to accept NTLMv2 only (not
sure if that is relevant when using DFS links), while the DFS root
server will allow both NTLM and NTLMv2.

pcap's are available on request.

Debug log of "ls -la /mnt/bla/Global/", on sec=ntlm:

 fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 553 with uid: 0
 fs/cifs/dir.c: parent inode = 0xe289a62c name is: Global and dentry =
0xdfe25330
 fs/cifs/dir.c: NULL inode in lookup
 fs/cifs/dir.c: Full path: \\foxdft13.fox.local\company\Global inode =
0x  (null)
 fs/cifs/inode.c: Getting info on \\foxdft13.fox.local\company\Global
 fs/cifs/transport.c: For smb_command 50
 fs/cifs/transport.c: Sending smb:  total_len 148
 fs/cifs/connect.c: rfc1002 length 0x27
 fs/cifs/connect.c: invalid transact2 word count
 Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
 fs/cifs/netmisc.c: Mapping smb error code 3 to POSIX err -66
 fs/cifs/cifssmb.c: Send error in QPathInfo = -66
 fs/cifs/inode.c: creating fake fattr for DFS referral
 fs/cifs/cifssmb.c: In GetSrvInodeNum for
\\foxdft13.fox.local\company\Global
 fs/cifs/transport.c: For smb_command 50
 fs/cifs/transport.c: Sending smb:  total_len 148
 fs/cifs/connect.c: rfc1002 length 0x27
 fs/cifs/connect.c: invalid transact2 word count
 Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
 fs/cifs/netmisc.c: Mapping smb error code 3 to POSIX err -66
 fs/cifs/cifssmb.c: error -66 in QueryInternalInfo
 fs/cifs/inode.c: GetSrvInodeNum rc -66
 CIFS VFS: Autodisabling the use of server inode numbers on
\\foxdft13.fox.local\company. This server doesn't seem to support them
properly. Hardlinks will not be recognized on this mount. Consider
mounting with the "noserverino" option to silence this message.
 fs/cifs/inode.c: looking for uniqueid=58
 fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 58
 fs/cifs/inode.c: cifs_revalidate_cache: inode 58 is new
 fs/cifs/inode.c: inode 0xc63d492c old_time=0 new_time=30762153
 fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid = 553) rc = 0
 fs/cifs/cifs_dfs_ref.c: in cifs_dfs_follow_mountpoint
 fs/cifs/cifs_dfs_ref.c: CIFS VFS: in cifs_dfs_follow_mountpoint as Xid:
554 with uid: 0
 fs/cifs/transport.c: For smb_command 117
 fs/cifs/transport.c: Sending smb:  total_len 88
 fs/cifs/connect.c: rfc1002 length 0x3c
 fs/cifs/connect.c: CIFS Tcon rc = 0 ipc_tid = 14339
 fs/cifs/cifssmb.c: In GetDFSRefer the path
\foxdft13.fox.local\company\Global
 fs/cifs/transport.c: For smb_command 50
 fs/cifs/transport.c: Sending smb:  total_len 144
 fs/cifs/connect.c: rfc1002 length 0x124
 fs/cifs/cifssmb.c: Decoding GetDFSRefer response BCC: 233  Offset 56
 fs/cifs/cifssmb.c: num_referrals: 1 dfs flags: 0x2 ...

 fs/cifs/cifs_dfs_ref.c: DFS: ref path: \foxdft13.fox.local\company\Global
 fs/cifs/cifs_dfs_ref.c: DFS: node path: \foxdft08\company\Global
 fs/cifs/cifs_dfs_ref.c: DFS: fl: 2, srv_type: 0
 fs/cifs/cifs_dfs_ref.c: DFS: ref_flags: 0, path_consumed: 34
 fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved:
foxdft08 to 10.0.0.72
 fs/cifs/cifsfs.c: Devname: \\foxdft08\company flags: 0
 fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 555 with uid: 0
 fs/cifs/connect.c: prefix path /Global
 fs/cifs/connect.c: Username: vmtest
 fs/cifs/connect.c: UNC: \\foxdft08\company ip: 10.0.0.72
 fs/cifs/connect.c: Socket created
 fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
 fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 556 with uid: 0
 fs/cifs/connect.c: Existing smb sess not found
 fs/cifs/cifssmb.c: secFlags 0x2
 fs/cifs/connect.c: Demultiplex PID: 18750
 fs/cifs/transport.c: For smb_command 114
 fs/cifs/transport.c: Sending smb:  total_len 82
 fs/cifs/connect.c: rfc1002 length 0x6b
 fs/cifs/cifssmb.c: Dialect: 2
 fs/cifs/cifssmb.c: Signing disabled
 fs/cifs/cifssmb.c: negprot rc 0
 fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0xf3fd TimeAdjust: 3600
 fs/cifs/sess.c: sess setup type 1
 fs/cifs/transport.c: For smb_command 115
 fs/cifs/transport.c: Sending smb:  total_len 232
 fs/cifs/connect.c: rfc1002 length 0x27
 fs/cifs/connect.c: Reconnect after unexpected peek error 0
 fs/cifs/connect.c: Reconnecting tcp session
 fs/cifs/connect.c: State: 0x3 Flags: 0x0
 fs/cifs/connect.c: Post shutdown state: 0x3 Flags: 0x0
 fs/cifs/connect.c: Socket created
 fs/cifs/netmisc.c: Mapping smb error code 31 to POSIX err -5
 fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
 fs/cifs/sess.c: ssetup freeing small buf f71edc00
 CIFS VFS: Send error in SessSetup = -5
 fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 556) rc = -5
 fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 555) rc = -5
 CIFS VFS: cifs_mount failed w/return code = -5
 fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
 fs/cifs/transport.c: Sending smb:  total_len 72
 fs/cifs/cifs_dfs_ref.c: cifs_dfs_follow_mountpoint:
cifs_dfs_do_refmount:\foxdft08\company\Global , mnt:fffffffb
 fs/cifs/cifs_dfs_ref.c: CIFS VFS: leaving cifs_dfs_follow_mountpoint
(xid = 554) rc = -5
 fs/cifs/cifs_dfs_ref.c: leaving cifs_dfs_follow_mountpoint

Debug log of "ls -la /mnt/bla/Global/", on sec=ntlmv2:

fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 563 with uid: 0
 fs/cifs/dir.c: parent inode = 0xc394a1ac name is: Global and dentry =
0xd1e0aa18
 fs/cifs/dir.c: NULL inode in lookup
 fs/cifs/dir.c: Full path: \\foxdft13.fox.local\company\Global inode =
0x  (null)
 fs/cifs/inode.c: Getting info on \\foxdft13.fox.local\company\Global
 fs/cifs/transport.c: For smb_command 50
 fs/cifs/transport.c: Sending smb:  total_len 148
 fs/cifs/connect.c: rfc1002 length 0x27
 fs/cifs/connect.c: invalid transact2 word count
 Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
 fs/cifs/netmisc.c: Mapping smb error code 3 to POSIX err -66
 fs/cifs/cifssmb.c: Send error in QPathInfo = -66
 fs/cifs/inode.c: creating fake fattr for DFS referral
 fs/cifs/cifssmb.c: In GetSrvInodeNum for
\\foxdft13.fox.local\company\Global
 fs/cifs/transport.c: For smb_command 50
 fs/cifs/transport.c: Sending smb:  total_len 148
 fs/cifs/connect.c: rfc1002 length 0x27
 fs/cifs/connect.c: invalid transact2 word count
 Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
 fs/cifs/netmisc.c: Mapping smb error code 3 to POSIX err -66
 fs/cifs/cifssmb.c: error -66 in QueryInternalInfo
 fs/cifs/inode.c: GetSrvInodeNum rc -66
 CIFS VFS: Autodisabling the use of server inode numbers on
\\foxdft13.fox.local\company. This server doesn't seem to support them
properly. Hardlinks will not be recognized on this mount. Consider
mounting with the "noserverino" option to silence this message.
 fs/cifs/inode.c: looking for uniqueid=59
 fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 59
 fs/cifs/inode.c: cifs_revalidate_cache: inode 59 is new
 fs/cifs/inode.c: inode 0xe289a7ac old_time=0 new_time=30796734
 fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid = 563) rc = 0
 fs/cifs/cifs_dfs_ref.c: in cifs_dfs_follow_mountpoint
 fs/cifs/cifs_dfs_ref.c: CIFS VFS: in cifs_dfs_follow_mountpoint as Xid:
564 with uid: 0
 fs/cifs/transport.c: For smb_command 117
 fs/cifs/transport.c: Sending smb:  total_len 88
 fs/cifs/connect.c: rfc1002 length 0x3c
 fs/cifs/connect.c: CIFS Tcon rc = 0 ipc_tid = 20487
 fs/cifs/cifssmb.c: In GetDFSRefer the path
\foxdft13.fox.local\company\Global
 fs/cifs/transport.c: For smb_command 50
 fs/cifs/transport.c: Sending smb:  total_len 144
 fs/cifs/connect.c: rfc1002 length 0x124
 fs/cifs/cifssmb.c: Decoding GetDFSRefer response BCC: 233  Offset 56
 fs/cifs/cifssmb.c: num_referrals: 1 dfs flags: 0x2 ...

 fs/cifs/cifs_dfs_ref.c: DFS: ref path: \foxdft13.fox.local\company\Global
 fs/cifs/cifs_dfs_ref.c: DFS: node path: \foxdft08\company\Global
 fs/cifs/cifs_dfs_ref.c: DFS: fl: 2, srv_type: 0
 fs/cifs/cifs_dfs_ref.c: DFS: ref_flags: 0, path_consumed: 34
 fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved:
foxdft08 to 10.0.0.72
 fs/cifs/cifsfs.c: Devname: \\foxdft08\company flags: 0
 fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 565 with uid: 0
 fs/cifs/connect.c: prefix path /Global
 fs/cifs/connect.c: Username: vmtest
 fs/cifs/connect.c: UNC: \\foxdft08\company ip: 10.0.0.72
 fs/cifs/connect.c: Socket created
 fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
 fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 566 with uid: 0
 fs/cifs/connect.c: Existing smb sess not found
 fs/cifs/cifssmb.c: secFlags 0x4
 fs/cifs/transport.c: For smb_command 114
 fs/cifs/transport.c: Sending smb:  total_len 82
 fs/cifs/connect.c: Demultiplex PID: 18760
 fs/cifs/connect.c: rfc1002 length 0x6b
 fs/cifs/cifssmb.c: Dialect: 2
 fs/cifs/cifssmb.c: Signing disabled
 fs/cifs/cifssmb.c: negprot rc 0
 fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0xf3fd TimeAdjust: 3600
 fs/cifs/sess.c: sess setup type 2
 fs/cifs/transport.c: For smb_command 115
 fs/cifs/transport.c: Sending smb:  total_len 346
 fs/cifs/connect.c: rfc1002 length 0x27
 Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
 fs/cifs/netmisc.c: Mapping smb error code 5 to POSIX err -13
 fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
 fs/cifs/sess.c: ssetup freeing small buf f71ecfc0
 CIFS VFS: Send error in SessSetup = -13
 fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 566) rc = -13
 fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 565) rc = -13
 CIFS VFS: cifs_mount failed w/return code = -13
 fs/cifs/cifs_dfs_ref.c: cifs_dfs_follow_mountpoint:
cifs_dfs_do_refmount:\foxdft08\company\Global , mnt:fffffff3
 fs/cifs/cifs_dfs_ref.c: CIFS VFS: leaving cifs_dfs_follow_mountpoint
(xid = 564) rc = -13
 fs/cifs/cifs_dfs_ref.c: leaving cifs_dfs_follow_mountpoint

Any ideas on how to troubleshoot this further?

Best regards,
Robbert
