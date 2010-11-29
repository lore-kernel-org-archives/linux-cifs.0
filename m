From: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Subject: Can't mount Windows DFS root using NTLMv2
Date: Mon, 29 Nov 2010 13:33:48 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1011291143280.21269@awakenings.cable.ziggo.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

I am trying to mount our DFS root using NTLMv2, but this fails when 
resolving the DFS target. Surprisingly, when I use NTLM, it does work.

This fails:

# mount -t cifs //sox.local/company /mnt/bla/ -o 
username=kouprie,dom=sox,sec=ntlmv2

This works:

# mount -t cifs //sox.local/company /mnt/bla/ -o
username=kouprie,dom=sox,sec=ntlm

I am using linux kernel 2.6.37-rc3 and cifs-utils 4.5-2.
I have keyutils 1.4  installed and configured correctly (obviously, since 
it works when using sec=ntlm).
The domain is configured to "Send NTLMv2 response only. Refuse LM".

# cat /proc/fs/cifs/DebugData
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 1.68
Features: dfs lanman posix spnego xattr
Active VFS Requests: 0
Servers:

Log exempt:

  fs/cifs/cifsfs.c: Devname: //sox.local/company/ flags: 64
  fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 6 with uid: 0
  fs/cifs/connect.c: Domain name set
  fs/cifs/connect.c: Username: kouprie
  fs/cifs/connect.c: UNC: \\sox.local\company ip: 10.0.0.11
  fs/cifs/connect.c: Socket created
  fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
  fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 7 with uid: 0
  fs/cifs/connect.c: Existing smb sess not found
  fs/cifs/cifssmb.c: secFlags 0x4
  fs/cifs/connect.c: Demultiplex PID: 1395
  fs/cifs/transport.c: For smb_command 114
  fs/cifs/transport.c: Sending smb:  total_len 82
  fs/cifs/connect.c: rfc1002 length 0x6b
  fs/cifs/cifssmb.c: Dialect: 2
  fs/cifs/cifssmb.c: Signing disabled
  fs/cifs/cifssmb.c: negprot rc 0
  fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x1f3fd TimeAdjust: 
-3600
  fs/cifs/sess.c: sess setup type 2
  fs/cifs/transport.c: For smb_command 115
  fs/cifs/transport.c: Sending smb:  total_len 316
  fs/cifs/connect.c: rfc1002 length 0xb5
  fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
  fs/cifs/sess.c: UID = 8192
  fs/cifs/sess.c: bleft 135
  fs/cifs/sess.c: serverOS=Windows Server 2003 3790 Service Pack 2
  fs/cifs/sess.c: serverNOS=Windows Server 2003 5.2
  fs/cifs/sess.c: serverDomain=SOX
  fs/cifs/sess.c: ssetup freeing small buf f0c40000
  fs/cifs/connect.c: CIFS Session Established successfully
  fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 7) rc = 0
  fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
  fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 8 with uid: 0
  fs/cifs/transport.c: For smb_command 117
  fs/cifs/transport.c: Sending smb:  total_len 94
  fs/cifs/connect.c: rfc1002 length 0x27
  Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
  fs/cifs/netmisc.c: Mapping smb error code 3 to POSIX err -66
  fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 8) rc = -66
  fs/cifs/connect.c: CIFS Tcon rc = -66
  fs/cifs/connect.c: Getting referral for: \\sox.local\company
  fs/cifs/transport.c: For smb_command 117
  fs/cifs/transport.c: Sending smb:  total_len 88
  fs/cifs/connect.c: rfc1002 length 0x3c
  fs/cifs/connect.c: CIFS Tcon rc = 0 ipc_tid = 4100
  fs/cifs/cifssmb.c: In GetDFSRefer the path \sox.local\company
  fs/cifs/transport.c: For smb_command 50
  fs/cifs/transport.c: Sending smb:  total_len 112
  fs/cifs/connect.c: rfc1002 length 0x11c
  fs/cifs/cifssmb.c: Decoding GetDFSRefer response BCC: 225  Offset 56
  fs/cifs/cifssmb.c: num_referrals: 2 dfs flags: 0x3 ...

  cifs.upcall: key description: dns_resolver;0;0;3f000000;SOXSRV03\C
  cifs.upcall: unable to resolve hostname: SOXSRV03\C [Name or service not 
known]

  CIFS VFS: dns_resolve_server_name_to_ip: unable to resolve: SOXSRV03\C
  CIFS VFS: cifs_compose_mount_options: Failed to resolve server part of 
\\SOXSRV03\Company to IP: -126
  fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1

  fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 9 with uid: 0
  fs/cifs/cifssmb.c: In SMBLogoff for session disconnect
  fs/cifs/transport.c: For smb_command 116
  fs/cifs/transport.c: Sending smb:  total_len 43
  fs/cifs/connect.c: rfc1002 length 0x2b
  fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 6) rc = -126
  CIFS VFS: cifs_mount failed w/return code = -126

As you can see above, upcall tries to resolve "SOXSRV03\C", which is 
obviously the hostname including the first letter of the share.

Does anyone know how I can fix this?

Best regards,

-- 
Robbert
