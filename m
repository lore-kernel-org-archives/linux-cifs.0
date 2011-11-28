From: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: problem mounting under Xubuntu
Date: Mon, 28 Nov 2011 03:35:22 +0000
Message-ID: <4ED3017A.9030502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

hi,

started using Xubuntu (11.10) and cannot get the mount.cifs to the NAS 
working.

the following command works from my slackware system:
   mount.cifs //nas/public /mnt -o guest

the same command (except added option ro) executed on Xubuntu gives error
   CIFS VFS: Send error in SessSetup = -13

I can access the NAS via smbclient.

after days of googling I'm still no wiser.  below is a listing of the 
dmesg output.  help, please.


[92841.000417] /build/buildd/linux-3.0.0/fs/cifs/cifsfs.c: Devname: 
//nas/public flags: 1
[92841.000428] /build/buildd/linux-3.0.0/fs/cifs/connect.c: null user
[92841.000434] /build/buildd/linux-3.0.0/fs/cifs/connect.c: file mode: 
0x1ed  dir mode: 0x1ed
[92841.000506] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS: in 
cifs_mount as Xid: 52 with uid: 0
[92841.000510] /build/buildd/linux-3.0.0/fs/cifs/connect.c: UNC: 
\\nas\public ip: 192.168.0.10
[92841.000530] /build/buildd/linux-3.0.0/fs/cifs/connect.c: Socket created
[92841.000534] /build/buildd/linux-3.0.0/fs/cifs/connect.c: sndbuf 16384 
rcvbuf 87380 rcvtimeo 0x6d6
[92841.001152] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS: in 
cifs_get_smb_ses as Xid: 53 with uid: 0
[92841.001157] /build/buildd/linux-3.0.0/fs/cifs/connect.c: Existing smb 
sess not found
[92841.001165] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: secFlags 0x7
[92841.001170] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For 
smb_command 114
[92841.001174] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending 
smb:  total_len 82
[92841.001194] /build/buildd/linux-3.0.0/fs/cifs/connect.c: Demultiplex 
PID: 6045
[92841.243749] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 
length 0x65
[92841.243770] /build/buildd/linux-3.0.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=114 mid=1 state=4
[92841.243777] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: Dialect: 2
[92841.243783] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: negprot rc 0
[92841.243787] /build/buildd/linux-3.0.0/fs/cifs/connect.c: Security 
Mode: 0x3 Capabilities: 0xe3fd TimeAdjust: 0
[92841.243791] /build/buildd/linux-3.0.0/fs/cifs/sess.c: sess setup type 1
[92841.243828] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For 
smb_command 115
[92841.243832] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending 
smb:  total_len 232
[92841.247606] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 
length 0x66
[92841.247623] /build/buildd/linux-3.0.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=115 mid=2 state=4
[92841.247628] /build/buildd/linux-3.0.0/fs/cifs/misc.c: Null buffer 
passed to cifs_small_buf_release
[92841.247632] /build/buildd/linux-3.0.0/fs/cifs/sess.c: Guest login
[92841.247635] /build/buildd/linux-3.0.0/fs/cifs/sess.c: UID = 100
[92841.247638] /build/buildd/linux-3.0.0/fs/cifs/sess.c: bleft 56
[92841.247642] /build/buildd/linux-3.0.0/fs/cifs/sess.c: serverOS=Unix
[92841.247646] /build/buildd/linux-3.0.0/fs/cifs/sess.c: serverNOS=Samba 
3.0.34
[92841.247650] /build/buildd/linux-3.0.0/fs/cifs/sess.c: 
serverDomain=WORKGROUP
[92841.247654] /build/buildd/linux-3.0.0/fs/cifs/sess.c: ssetup freeing 
small buf f1f32540
[92841.247657] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS Session 
Established successfully
[92841.247662] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS: 
leaving cifs_get_smb_ses (xid = 53) rc = 0
[92841.247667] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS: in 
cifs_get_tcon as Xid: 54 with uid: 0
[92841.247673] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For 
smb_command 117
[92841.247677] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending 
smb:  total_len 90
[92841.248606] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 
length 0x27
[92841.248620] /build/buildd/linux-3.0.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=117 mid=3 state=4
[92841.248625] Status code returned 0xc0000022 NT_STATUS_ACCESS_DENIED
[92841.248630] /build/buildd/linux-3.0.0/fs/cifs/netmisc.c: Mapping smb 
error code 0xc0000022 to POSIX err -13
[92841.248635] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS: 
leaving cifs_get_tcon (xid = 54) rc = -13
[92841.248639] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS Tcon rc 
= -13
[92841.248643] /build/buildd/linux-3.0.0/fs/cifs/connect.c: 
build_unc_path_to_root: full_path=\\nas\public
[92841.248648] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For 
smb_command 117
[92841.248652] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending 
smb:  total_len 94
[92841.251461] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 
length 0x3c
[92841.251473] /build/buildd/linux-3.0.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=117 mid=4 state=4
[92841.251478] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS Tcon rc 
= 0 ipc_tid = 1
[92841.251482] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: In 
GetDFSRefer the path \nas\public
[92841.251487] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For 
smb_command 50
[92841.251490] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending 
smb:  total_len 108
[92841.252726] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 
length 0x27
[92841.252731] /build/buildd/linux-3.0.0/fs/cifs/connect.c: invalid 
transact2 word count
[92841.252743] /build/buildd/linux-3.0.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=50 mid=5 state=4
[92841.252748] Status code returned 0xc0000002 NT_STATUS_NOT_IMPLEMENTED
[92841.252752] /build/buildd/linux-3.0.0/fs/cifs/netmisc.c: Mapping smb 
error code 0xc0000002 to POSIX err -22
[92841.252756] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: Send error 
in GetDFSRefer = -22
[92841.252760] /build/buildd/linux-3.0.0/fs/cifs/connect.c: 
cifs_put_smb_ses: ses_count=1
[92841.252762]
[92841.252765] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS: in 
cifs_put_smb_ses as Xid: 55 with uid: 0
[92841.252769] /build/buildd/linux-3.0.0/fs/cifs/cifssmb.c: In SMBLogoff 
for session disconnect
[92841.252773] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For 
smb_command 116
[92841.252776] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending 
smb:  total_len 43
[92841.253503] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 
length 0x2b
[92841.253515] /build/buildd/linux-3.0.0/fs/cifs/transport.c: 
cifs_sync_mid_result: cmd=116 mid=6 state=4
[92841.256596] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS: 
leaving cifs_mount (xid = 52) rc = -13
[92841.256600] CIFS VFS: cifs_mount failed w/return code = -13
