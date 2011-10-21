From: Terrence Shipclark <terrence.shipclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs and win2k8
Date: Fri, 21 Oct 2011 07:18:20 -0400
Message-ID: <4EA154FC.3090601@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030703020509020506000600"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030703020509020506000600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

This is my first time posting to this list, and I hope I am not breaking 
any rules.

I have been attempting to get the cifs kernel modules to mount the 
win2k8 dfs at my workplace.   I did finally manage to get
the dfs to mount after modifying the kernel module with this small patch

@@ -3109,6 +3112,7 @@
                                                cifs_sb, false);
                if (!refrc) {
                        referral_walks_count++;
+                       rc=0;
                        goto try_mount_again;
                }
        }

Although I dont 100% understand what I did, as I had a hard time 
following the goto statements, I have a feeling that on initial setup it 
would follow the DFS referral, however ultimately fail as it exited 
because rc was still set to -6.

So now For my second problem.

Within the dfs tree there is a referral to //server/share$/folder.  My 
user has access to //server/share$/folder, however do not have access to
//server/$share.  While following the referral the cifs module does a
QUERY_PATH_INFO on \\server\share$\folder, and then is followed up by a 
QUERY_PATH_INFO on \\server\share$\ which rightfully returns a 
STATUS_ACCESS_DENIED from the server.

Traversing the same path with smbclient  \\server\share$ is never 
queried.Perhaps I am doing something wrong?

I have been attempting to connect to this dfs from linux for about 2 
years,and this is the closest I have gotten, so any help would be 
appreciated.

terry

--------------030703020509020506000600
Content-Type: text/plain;
 name="dmesg-output.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-output.txt"

[ 2642.002554] fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry_attr as Xid: 1253 with uid: 1000
[ 2642.002558] fs/cifs/inode.c: Update attributes: \\FIRE\Shares inode 0xffff8800b0178048 count 2 dentry: 0xffff8800b627b300 d_time 0 jiffies 4295552796
[ 2642.002560] fs/cifs/inode.c: Getting info on \\FIRE\Shares
[ 2642.002566] fs/cifs/transport.c: For smb_command 50
[ 2642.002568] fs/cifs/transport.c: Sending smb:  total_len 104
[ 2642.003593] fs/cifs/connect.c: rfc1002 length 0xa8
[ 2642.003604] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=1042 state=4
[ 2642.003610] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 5066549580883428
[ 2642.003612] fs/cifs/inode.c: cifs_revalidate_cache: inode 5066549580883428 is unchanged
[ 2642.003615] fs/cifs/inode.c: inode 0xffff8800b0178048 old_time=4295528240 new_time=4295552796
[ 2642.003619] fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry_attr (xid = 1253) rc = 0
[ 2642.003626] fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry_attr as Xid: 1254 with uid: 1000
[ 2642.003630] fs/cifs/inode.c: Update attributes: \\FIRE\Shares\Departmental inode 0xffff8800b0179008 count 1 dentry: 0xffff8800366e7300 d_time 4294936195 jiffies 4295552796
[ 2642.003633] fs/cifs/inode.c: Getting info on \\FIRE\Shares\Departmental
[ 2642.003636] fs/cifs/transport.c: For smb_command 50
[ 2642.003638] fs/cifs/transport.c: Sending smb:  total_len 130
[ 2642.004542] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.004546] fs/cifs/connect.c: invalid transact2 word count
[ 2642.004554] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=1043 state=4
[ 2642.004560] Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
[ 2642.004563] fs/cifs/netmisc.c: Mapping smb error code 0xc0000257 to POSIX err -66
[ 2642.004566] fs/cifs/cifssmb.c: Send error in QPathInfo = -66
[ 2642.004568] fs/cifs/inode.c: creating fake fattr for DFS referral
[ 2642.004571] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 21
[ 2642.004573] fs/cifs/inode.c: cifs_revalidate_cache: invalidating inode 21 mapping
[ 2642.004576] fs/cifs/inode.c: inode 0xffff8800b0179008 old_time=4295528241 new_time=4295552797
[ 2642.004579] fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry_attr (xid = 1254) rc = 0
[ 2642.004584] fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry_attr as Xid: 1255 with uid: 1000
[ 2642.004588] fs/cifs/inode.c: Update attributes: \\FIRE\Departments$ inode 0xffff8800b0179548 count 1 dentry: 0xffff8800366e7a80 d_time -131940482123136 jiffies 4295552797
[ 2642.004591] fs/cifs/inode.c: Getting info on \\FIRE\Departments$
[ 2642.004594] fs/cifs/transport.c: For smb_command 50
[ 2642.004596] fs/cifs/transport.c: Sending smb:  total_len 116
[ 2642.005480] fs/cifs/connect.c: rfc1002 length 0xb4
[ 2642.005488] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=1044 state=4
[ 2642.005492] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 562949953513329
[ 2642.005495] fs/cifs/inode.c: cifs_revalidate_cache: inode 562949953513329 is unchanged
[ 2642.005497] fs/cifs/inode.c: inode 0xffff8800b0179548 old_time=4295551216 new_time=4295552797
[ 2642.005500] fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry_attr (xid = 1255) rc = 0
[ 2642.005507] fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry_attr as Xid: 1256 with uid: 1000
[ 2642.005511] fs/cifs/inode.c: Update attributes: \\FIRE\Departments$\folder inode 0xffff8800b01b9a88 count 1 dentry: 0xffff88009979a0c0 d_time 4295528259 jiffies 4295552797
[ 2642.005514] fs/cifs/inode.c: Getting info on \\FIRE\Departments$\folder
[ 2642.005517] fs/cifs/transport.c: For smb_command 50
[ 2642.005519] fs/cifs/transport.c: Sending smb:  total_len 124
[ 2642.006297] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.006300] fs/cifs/connect.c: invalid transact2 word count
[ 2642.006307] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=1045 state=4
[ 2642.006311] Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
[ 2642.006313] fs/cifs/netmisc.c: Mapping smb error code 0xc0000257 to POSIX err -66
[ 2642.006316] fs/cifs/cifssmb.c: Send error in QPathInfo = -66
[ 2642.006318] fs/cifs/inode.c: creating fake fattr for DFS referral
[ 2642.006320] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 1656
[ 2642.006322] fs/cifs/inode.c: cifs_revalidate_cache: invalidating inode 1656 mapping
[ 2642.006325] fs/cifs/inode.c: inode 0xffff8800b01b9a88 old_time=4295528259 new_time=4295552797
[ 2642.006328] fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry_attr (xid = 1256) rc = 0
[ 2642.006336] fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 1257 with uid: 1000
[ 2642.006339] fs/cifs/dir.c: parent inode = 0xffff8800b0179548 name is: folder and dentry = 0xffff880080c13c00
[ 2642.006342] fs/cifs/dir.c: NULL inode in lookup
[ 2642.006344] fs/cifs/dir.c: Full path: \\FIRE\Departments$\folder inode = 0x          (null)
[ 2642.006346] fs/cifs/inode.c: Getting info on \\FIRE\Departments$\folder
[ 2642.006349] fs/cifs/transport.c: For smb_command 50
[ 2642.006351] fs/cifs/transport.c: Sending smb:  total_len 124
[ 2642.007216] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.007219] fs/cifs/connect.c: invalid transact2 word count
[ 2642.007225] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=1046 state=4
[ 2642.007229] Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
[ 2642.007232] fs/cifs/netmisc.c: Mapping smb error code 0xc0000257 to POSIX err -66
[ 2642.007235] fs/cifs/cifssmb.c: Send error in QPathInfo = -66
[ 2642.007237] fs/cifs/inode.c: creating fake fattr for DFS referral
[ 2642.007240] fs/cifs/inode.c: looking for uniqueid=1657
[ 2642.007243] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 1657
[ 2642.007245] fs/cifs/inode.c: cifs_revalidate_cache: inode 1657 is new
[ 2642.007248] fs/cifs/inode.c: inode 0xffff8800b01b9d28 old_time=0 new_time=4295552797
[ 2642.007252] fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid = 1257) rc = 0
[ 2642.007255] fs/cifs/cifs_dfs_ref.c: in cifs_dfs_d_automount
[ 2642.007256] fs/cifs/cifs_dfs_ref.c: in cifs_dfs_do_automount
[ 2642.007259] fs/cifs/cifs_dfs_ref.c: CIFS VFS: in cifs_dfs_do_automount as Xid: 1258 with uid: 1000
[ 2642.007262] fs/cifs/cifssmb.c: In GetDFSRefer the path \FIRE\Departments$\folder
[ 2642.007265] fs/cifs/transport.c: For smb_command 50
[ 2642.007267] fs/cifs/transport.c: Sending smb:  total_len 120
[ 2642.007994] fs/cifs/connect.c: rfc1002 length 0xe2
[ 2642.008132] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=1047 state=4
[ 2642.008134] fs/cifs/cifssmb.c: Decoding GetDFSRefer response BCC: 167  Offset 56
[ 2642.008135] fs/cifs/cifssmb.c: num_referrals: 1 dfs flags: 0x2 ...
[ 2642.008136] 
[ 2642.008140] fs/cifs/cifs_dfs_ref.c: CIFS VFS: leaving cifs_dfs_do_automount (xid = 1258) rc = 0
[ 2642.008141] fs/cifs/cifs_dfs_ref.c: DFS: ref path: \FIRE\Departments$\folder
[ 2642.008142] fs/cifs/cifs_dfs_ref.c: DFS: node path: \server\share$\folder
[ 2642.008144] fs/cifs/cifs_dfs_ref.c: DFS: fl: 2, srv_type: 0
[ 2642.008145] fs/cifs/cifs_dfs_ref.c: DFS: ref_flags: 0, path_consumed: 22
[ 2642.008153] fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: server to 10.10.10.157
[ 2642.008164] fs/cifs/cifsfs.c: Devname: \\server\share$ flags: 0 
[ 2642.008169] fs/cifs/connect.c: Domain name set
[ 2642.008171] fs/cifs/connect.c: prefix path /folder
[ 2642.008172] fs/cifs/connect.c: Username: shipclar
[ 2642.008175] fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
[ 2642.008229] fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 1259 with uid: 1000
[ 2642.008231] fs/cifs/connect.c: UNC: \\server\share$ ip: 10.10.10.157
[ 2642.008242] fs/cifs/connect.c: Socket created
[ 2642.008243] fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
[ 2642.008879] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1260 with uid: 1000
[ 2642.008881] fs/cifs/connect.c: Demultiplex PID: 4387
[ 2642.008882] fs/cifs/connect.c: Existing smb sess not found
[ 2642.008885] fs/cifs/cifssmb.c: secFlags 0x7
[ 2642.008887] fs/cifs/transport.c: For smb_command 114
[ 2642.008888] fs/cifs/transport.c: Sending smb:  total_len 82
[ 2642.015194] fs/cifs/connect.c: rfc1002 length 0x67
[ 2642.015205] fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
[ 2642.015209] fs/cifs/cifssmb.c: Dialect: 2
[ 2642.015212] fs/cifs/cifssmb.c: negprot rc 0
[ 2642.015214] fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x1e3fd TimeAdjust: 14400
[ 2642.015216] fs/cifs/sess.c: sess setup type 1
[ 2642.015241] fs/cifs/transport.c: For smb_command 115
[ 2642.015243] fs/cifs/transport.c: Sending smb:  total_len 260
[ 2642.017881] fs/cifs/connect.c: rfc1002 length 0xef
[ 2642.017893] fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
[ 2642.017896] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2642.017899] fs/cifs/sess.c: UID = 57346 
[ 2642.017901] fs/cifs/sess.c: bleft 193
[ 2642.017904] fs/cifs/sess.c: serverOS=Windows Server (R) 2008 Standard 6001 Service Pack 1
[ 2642.017908] fs/cifs/sess.c: serverNOS=Windows Server (R) 2008 Standard 6.0
[ 2642.017911] fs/cifs/sess.c: serverDomain=TURTLE
[ 2642.017913] fs/cifs/sess.c: ssetup freeing small buf ffff880129c83480
[ 2642.017915] fs/cifs/connect.c: CIFS Session Established successfully
[ 2642.017917] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1260) rc = 0
[ 2642.017921] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 1261 with uid: 1000
[ 2642.017924] fs/cifs/transport.c: For smb_command 117
[ 2642.017926] fs/cifs/transport.c: Sending smb:  total_len 80
[ 2642.018359] fs/cifs/connect.c: rfc1002 length 0x42
[ 2642.018368] fs/cifs/transport.c: cifs_sync_mid_result: cmd=117 mid=3 state=4
[ 2642.018371] fs/cifs/connect.c: disk share connection
[ 2642.018373] fs/cifs/connect.c: nativeFileSystem=NTFS
[ 2642.018375] fs/cifs/connect.c: Tcon flags: 0x1 
[ 2642.018377] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 1261) rc = 0
[ 2642.018379] fs/cifs/connect.c: CIFS Tcon rc = 0
[ 2642.018381] fs/cifs/cifssmb.c: In QFSDeviceInfo
[ 2642.018384] fs/cifs/transport.c: For smb_command 50
[ 2642.018386] fs/cifs/transport.c: Sending smb:  total_len 72
[ 2642.018605] fs/cifs/connect.c: rfc1002 length 0x44
[ 2642.018613] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=4 state=4
[ 2642.018616] fs/cifs/cifssmb.c: In QFSAttributeInfo
[ 2642.018619] fs/cifs/transport.c: For smb_command 50
[ 2642.018621] fs/cifs/transport.c: Sending smb:  total_len 72
[ 2642.018842] fs/cifs/connect.c: rfc1002 length 0x50
[ 2642.018849] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=5 state=4
[ 2642.018853] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\server\share$\folder
[ 2642.018856] fs/cifs/transport.c: For smb_command 117
[ 2642.018858] fs/cifs/transport.c: Sending smb:  total_len 98
[ 2642.019058] fs/cifs/connect.c: rfc1002 length 0x3c
[ 2642.019065] fs/cifs/transport.c: cifs_sync_mid_result: cmd=117 mid=6 state=4
[ 2642.019068] fs/cifs/connect.c: CIFS Tcon rc = 0 ipc_tid = 43014
[ 2642.019070] fs/cifs/cifssmb.c: In GetDFSRefer the path \server\share$
[ 2642.019073] fs/cifs/transport.c: For smb_command 50
[ 2642.019075] fs/cifs/transport.c: Sending smb:  total_len 98
[ 2642.019229] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.019232] fs/cifs/connect.c: invalid transact2 word count
[ 2642.019239] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=7 state=4
[ 2642.019243] Status code returned 0xc000019c NT_STATUS_FS_DRIVER_REQUIRED
[ 2642.019247] fs/cifs/netmisc.c: Mapping smb error code 0xc000019c to POSIX err -5
[ 2642.019250] fs/cifs/cifssmb.c: Send error in GetDFSRefer = -5
[ 2642.019253] fs/cifs/transport.c: For smb_command 50
[ 2642.019255] fs/cifs/transport.c: Sending smb:  total_len 86
[ 2642.019529] fs/cifs/connect.c: rfc1002 length 0x9c
[ 2642.019537] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=8 state=4
[ 2642.019541] fs/cifs/connect.c: SPOT#2
[ 2642.019543] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 1259) rc = 0
[ 2642.019559] fs/cifs/inode.c: CIFS VFS: in cifs_root_iget as Xid: 1262 with uid: 1000
[ 2642.019561] fs/cifs/inode.c: Getting info on 
[ 2642.019563] fs/cifs/transport.c: For smb_command 50
[ 2642.019565] fs/cifs/transport.c: Sending smb:  total_len 78
[ 2642.019859] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.019862] fs/cifs/connect.c: invalid transact2 word count
[ 2642.019869] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=9 state=4
[ 2642.019871] Status code returned 0xc0000022 NT_STATUS_ACCESS_DENIED
[ 2642.019875] fs/cifs/netmisc.c: Mapping smb error code 0xc0000022 to POSIX err -13
[ 2642.019878] fs/cifs/cifssmb.c: Send error in QPathInfo = -13
[ 2642.019880] CIFS VFS: cifs_read_super: get root inode failed
[ 2642.019886] fs/cifs/connect.c: cifs_put_tcon: tc_count=1
[ 2642.019887] 
[ 2642.019889] fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 1263 with uid: 1000
[ 2642.019891] fs/cifs/cifssmb.c: In tree disconnect
[ 2642.019894] fs/cifs/transport.c: For smb_command 113
[ 2642.019896] fs/cifs/transport.c: Sending smb:  total_len 39
[ 2642.020059] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.020063] fs/cifs/transport.c: cifs_sync_mid_result: cmd=113 mid=10 state=4
[ 2642.020066] fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
[ 2642.020067] 
[ 2642.020068] fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 1264 with uid: 1000
[ 2642.020070] fs/cifs/cifssmb.c: In SMBLogoff for session disconnect
[ 2642.020072] fs/cifs/transport.c: For smb_command 116
[ 2642.020073] fs/cifs/transport.c: Sending smb:  total_len 43
[ 2642.020508] fs/cifs/connect.c: rfc1002 length 0x2b
[ 2642.020630] fs/cifs/transport.c: cifs_sync_mid_result: cmd=116 mid=11 state=4
[ 2642.040025] fs/cifs/cifs_dfs_ref.c: cifs_dfs_do_automount: cifs_dfs_do_refmount:\server\share$\folder , mnt:fffffffffffffff3
[ 2642.040029] fs/cifs/cifs_dfs_ref.c: leaving cifs_dfs_do_automount
[ 2642.040031] fs/cifs/cifs_dfs_ref.c: leaving cifs_dfs_d_automount [automount failed]
[ 2642.040048] fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 1265 with uid: 1000
[ 2642.040051] fs/cifs/dir.c: parent inode = 0xffff8800b0179548 name is: folder and dentry = 0xffff880080c13a80
[ 2642.040054] fs/cifs/dir.c: NULL inode in lookup
[ 2642.040057] fs/cifs/dir.c: Full path: \\FIRE\Departments$\folder inode = 0x          (null)
[ 2642.040059] fs/cifs/inode.c: Getting info on \\FIRE\Departments$\folder
[ 2642.040063] fs/cifs/transport.c: For smb_command 50
[ 2642.040065] fs/cifs/transport.c: Sending smb:  total_len 124
[ 2642.040920] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.040924] fs/cifs/connect.c: invalid transact2 word count
[ 2642.040931] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=1048 state=4
[ 2642.040936] Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
[ 2642.040939] fs/cifs/netmisc.c: Mapping smb error code 0xc0000257 to POSIX err -66
[ 2642.040942] fs/cifs/cifssmb.c: Send error in QPathInfo = -66
[ 2642.040944] fs/cifs/inode.c: creating fake fattr for DFS referral
[ 2642.040947] fs/cifs/inode.c: looking for uniqueid=1658
[ 2642.040950] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 1658
[ 2642.040952] fs/cifs/inode.c: cifs_revalidate_cache: inode 1658 is new
[ 2642.040955] fs/cifs/inode.c: inode 0xffff8800b01b9a88 old_time=0 new_time=4295552806
[ 2642.040958] fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid = 1265) rc = 0
[ 2642.040961] fs/cifs/cifs_dfs_ref.c: in cifs_dfs_d_automount
[ 2642.040963] fs/cifs/cifs_dfs_ref.c: in cifs_dfs_do_automount
[ 2642.040966] fs/cifs/cifs_dfs_ref.c: CIFS VFS: in cifs_dfs_do_automount as Xid: 1266 with uid: 1000
[ 2642.040968] fs/cifs/cifssmb.c: In GetDFSRefer the path \FIRE\Departments$\folder
[ 2642.040971] fs/cifs/transport.c: For smb_command 50
[ 2642.040973] fs/cifs/transport.c: Sending smb:  total_len 120
[ 2642.041656] fs/cifs/connect.c: rfc1002 length 0xe2
[ 2642.041665] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=1049 state=4
[ 2642.041668] fs/cifs/cifssmb.c: Decoding GetDFSRefer response BCC: 167  Offset 56
[ 2642.041670] fs/cifs/cifssmb.c: num_referrals: 1 dfs flags: 0x2 ...
[ 2642.041671] 
[ 2642.041676] fs/cifs/cifs_dfs_ref.c: CIFS VFS: leaving cifs_dfs_do_automount (xid = 1266) rc = 0
[ 2642.041679] fs/cifs/cifs_dfs_ref.c: DFS: ref path: \FIRE\Departments$\folder
[ 2642.041680] fs/cifs/cifs_dfs_ref.c: DFS: node path: \server\share$\folder
[ 2642.041683] fs/cifs/cifs_dfs_ref.c: DFS: fl: 2, srv_type: 0
[ 2642.041684] fs/cifs/cifs_dfs_ref.c: DFS: ref_flags: 0, path_consumed: 22
[ 2642.041692] fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: server to 10.10.10.157
[ 2642.041703] fs/cifs/cifsfs.c: Devname: \\server\share$ flags: 0 
[ 2642.041709] fs/cifs/connect.c: Domain name set
[ 2642.041712] fs/cifs/connect.c: prefix path /folder
[ 2642.041714] fs/cifs/connect.c: Username: shipclar
[ 2642.041717] fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
[ 2642.041760] fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 1267 with uid: 1000
[ 2642.041763] fs/cifs/connect.c: UNC: \\server\share$ ip: 10.10.10.157
[ 2642.041774] fs/cifs/connect.c: Socket created
[ 2642.041776] fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
[ 2642.042090] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1268 with uid: 1000
[ 2642.042092] fs/cifs/connect.c: Demultiplex PID: 4388
[ 2642.042094] fs/cifs/connect.c: Existing smb sess not found
[ 2642.042098] fs/cifs/cifssmb.c: secFlags 0x7
[ 2642.042100] fs/cifs/transport.c: For smb_command 114
[ 2642.042101] fs/cifs/transport.c: Sending smb:  total_len 82
[ 2642.042309] fs/cifs/connect.c: rfc1002 length 0x67
[ 2642.042317] fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
[ 2642.042321] fs/cifs/cifssmb.c: Dialect: 2
[ 2642.042323] fs/cifs/cifssmb.c: negprot rc 0
[ 2642.042325] fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x1e3fd TimeAdjust: 14400
[ 2642.042327] fs/cifs/sess.c: sess setup type 1
[ 2642.042348] fs/cifs/transport.c: For smb_command 115
[ 2642.042354] fs/cifs/transport.c: Sending smb:  total_len 260
[ 2642.044669] fs/cifs/connect.c: rfc1002 length 0xef
[ 2642.044682] fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
[ 2642.044683] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2642.044685] fs/cifs/sess.c: UID = 36866 
[ 2642.044686] fs/cifs/sess.c: bleft 193
[ 2642.044688] fs/cifs/sess.c: serverOS=Windows Server (R) 2008 Standard 6001 Service Pack 1
[ 2642.044691] fs/cifs/sess.c: serverNOS=Windows Server (R) 2008 Standard 6.0
[ 2642.044692] fs/cifs/sess.c: serverDomain=TURTLE
[ 2642.044694] fs/cifs/sess.c: ssetup freeing small buf ffff880129c80e00
[ 2642.044695] fs/cifs/connect.c: CIFS Session Established successfully
[ 2642.044696] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1268) rc = 0
[ 2642.044698] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 1269 with uid: 1000
[ 2642.044702] fs/cifs/transport.c: For smb_command 117
[ 2642.044703] fs/cifs/transport.c: Sending smb:  total_len 80
[ 2642.045074] fs/cifs/connect.c: rfc1002 length 0x42
[ 2642.045080] fs/cifs/transport.c: cifs_sync_mid_result: cmd=117 mid=3 state=4
[ 2642.045082] fs/cifs/connect.c: disk share connection
[ 2642.045084] fs/cifs/connect.c: nativeFileSystem=NTFS
[ 2642.045085] fs/cifs/connect.c: Tcon flags: 0x1 
[ 2642.045086] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 1269) rc = 0
[ 2642.045087] fs/cifs/connect.c: CIFS Tcon rc = 0
[ 2642.045088] fs/cifs/cifssmb.c: In QFSDeviceInfo
[ 2642.045090] fs/cifs/transport.c: For smb_command 50
[ 2642.045091] fs/cifs/transport.c: Sending smb:  total_len 72
[ 2642.045242] fs/cifs/connect.c: rfc1002 length 0x44
[ 2642.045250] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=4 state=4
[ 2642.045254] fs/cifs/cifssmb.c: In QFSAttributeInfo
[ 2642.045256] fs/cifs/transport.c: For smb_command 50
[ 2642.045258] fs/cifs/transport.c: Sending smb:  total_len 72
[ 2642.045426] fs/cifs/connect.c: rfc1002 length 0x50
[ 2642.045434] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=5 state=4
[ 2642.045438] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\server\share$\folder
[ 2642.045441] fs/cifs/transport.c: For smb_command 117
[ 2642.045443] fs/cifs/transport.c: Sending smb:  total_len 98
[ 2642.045608] fs/cifs/connect.c: rfc1002 length 0x3c
[ 2642.045616] fs/cifs/transport.c: cifs_sync_mid_result: cmd=117 mid=6 state=4
[ 2642.045619] fs/cifs/connect.c: CIFS Tcon rc = 0 ipc_tid = 6148
[ 2642.045621] fs/cifs/cifssmb.c: In GetDFSRefer the path \server\share$
[ 2642.045624] fs/cifs/transport.c: For smb_command 50
[ 2642.045625] fs/cifs/transport.c: Sending smb:  total_len 98
[ 2642.045776] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.045779] fs/cifs/connect.c: invalid transact2 word count
[ 2642.045786] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=7 state=4
[ 2642.045790] Status code returned 0xc000019c NT_STATUS_FS_DRIVER_REQUIRED
[ 2642.045793] fs/cifs/netmisc.c: Mapping smb error code 0xc000019c to POSIX err -5
[ 2642.045796] fs/cifs/cifssmb.c: Send error in GetDFSRefer = -5
[ 2642.045799] fs/cifs/transport.c: For smb_command 50
[ 2642.045801] fs/cifs/transport.c: Sending smb:  total_len 86
[ 2642.046044] fs/cifs/connect.c: rfc1002 length 0x9c
[ 2642.046051] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=8 state=4
[ 2642.046055] fs/cifs/connect.c: SPOT#2
[ 2642.046057] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 1267) rc = 0
[ 2642.046069] fs/cifs/inode.c: CIFS VFS: in cifs_root_iget as Xid: 1270 with uid: 1000
[ 2642.046071] fs/cifs/inode.c: Getting info on 
[ 2642.046073] fs/cifs/transport.c: For smb_command 50
[ 2642.046075] fs/cifs/transport.c: Sending smb:  total_len 78
[ 2642.046271] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.046274] fs/cifs/connect.c: invalid transact2 word count
[ 2642.046280] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=9 state=4
[ 2642.046283] Status code returned 0xc0000022 NT_STATUS_ACCESS_DENIED
[ 2642.046287] fs/cifs/netmisc.c: Mapping smb error code 0xc0000022 to POSIX err -13
[ 2642.046289] fs/cifs/cifssmb.c: Send error in QPathInfo = -13
[ 2642.046291] CIFS VFS: cifs_read_super: get root inode failed
[ 2642.046297] fs/cifs/connect.c: cifs_put_tcon: tc_count=1
[ 2642.046298] 
[ 2642.046300] fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 1271 with uid: 1000
[ 2642.046302] fs/cifs/cifssmb.c: In tree disconnect
[ 2642.046305] fs/cifs/transport.c: For smb_command 113
[ 2642.046307] fs/cifs/transport.c: Sending smb:  total_len 39
[ 2642.046465] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.046470] fs/cifs/transport.c: cifs_sync_mid_result: cmd=113 mid=10 state=4
[ 2642.046472] fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
[ 2642.046472] 
[ 2642.046474] fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 1272 with uid: 1000
[ 2642.046475] fs/cifs/cifssmb.c: In SMBLogoff for session disconnect
[ 2642.046476] fs/cifs/transport.c: For smb_command 116
[ 2642.046478] fs/cifs/transport.c: Sending smb:  total_len 43
[ 2642.046817] fs/cifs/connect.c: rfc1002 length 0x2b
[ 2642.046824] fs/cifs/transport.c: cifs_sync_mid_result: cmd=116 mid=11 state=4
[ 2642.084017] fs/cifs/cifs_dfs_ref.c: cifs_dfs_do_automount: cifs_dfs_do_refmount:\server\share$\folder , mnt:fffffffffffffff3
[ 2642.084021] fs/cifs/cifs_dfs_ref.c: leaving cifs_dfs_do_automount
[ 2642.084023] fs/cifs/cifs_dfs_ref.c: leaving cifs_dfs_d_automount [automount failed]
[ 2642.084033] fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 1273 with uid: 1000
[ 2642.084035] fs/cifs/dir.c: parent inode = 0xffff8800b0179548 name is: folder and dentry = 0xffff880080c13300
[ 2642.084038] fs/cifs/dir.c: NULL inode in lookup
[ 2642.084040] fs/cifs/dir.c: Full path: \\FIRE\Departments$\folder inode = 0x          (null)
[ 2642.084043] fs/cifs/inode.c: Getting info on \\FIRE\Departments$\folder
[ 2642.084047] fs/cifs/transport.c: For smb_command 50
[ 2642.084049] fs/cifs/transport.c: Sending smb:  total_len 124
[ 2642.084908] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.084912] fs/cifs/connect.c: invalid transact2 word count
[ 2642.084919] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=1050 state=4
[ 2642.084924] Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
[ 2642.084927] fs/cifs/netmisc.c: Mapping smb error code 0xc0000257 to POSIX err -66
[ 2642.084930] fs/cifs/cifssmb.c: Send error in QPathInfo = -66
[ 2642.084932] fs/cifs/inode.c: creating fake fattr for DFS referral
[ 2642.084935] fs/cifs/inode.c: looking for uniqueid=1659
[ 2642.084937] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 1659
[ 2642.084940] fs/cifs/inode.c: cifs_revalidate_cache: inode 1659 is new
[ 2642.084942] fs/cifs/inode.c: inode 0xffff8800b01b9d28 old_time=0 new_time=4295552817
[ 2642.084946] fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid = 1273) rc = 0
[ 2642.084949] fs/cifs/cifs_dfs_ref.c: in cifs_dfs_d_automount
[ 2642.084950] fs/cifs/cifs_dfs_ref.c: in cifs_dfs_do_automount
[ 2642.084953] fs/cifs/cifs_dfs_ref.c: CIFS VFS: in cifs_dfs_do_automount as Xid: 1274 with uid: 1000
[ 2642.084955] fs/cifs/cifssmb.c: In GetDFSRefer the path \FIRE\Departments$\folder
[ 2642.084958] fs/cifs/transport.c: For smb_command 50
[ 2642.084960] fs/cifs/transport.c: Sending smb:  total_len 120
[ 2642.085631] fs/cifs/connect.c: rfc1002 length 0xe2
[ 2642.085640] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=1051 state=4
[ 2642.085643] fs/cifs/cifssmb.c: Decoding GetDFSRefer response BCC: 167  Offset 56
[ 2642.085646] fs/cifs/cifssmb.c: num_referrals: 1 dfs flags: 0x2 ...
[ 2642.085647] 
[ 2642.085652] fs/cifs/cifs_dfs_ref.c: CIFS VFS: leaving cifs_dfs_do_automount (xid = 1274) rc = 0
[ 2642.085654] fs/cifs/cifs_dfs_ref.c: DFS: ref path: \FIRE\Departments$\folder
[ 2642.085656] fs/cifs/cifs_dfs_ref.c: DFS: node path: \server\share$\folder
[ 2642.085658] fs/cifs/cifs_dfs_ref.c: DFS: fl: 2, srv_type: 0
[ 2642.085660] fs/cifs/cifs_dfs_ref.c: DFS: ref_flags: 0, path_consumed: 22
[ 2642.085667] fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: server to 10.10.10.157
[ 2642.085678] fs/cifs/cifsfs.c: Devname: \\server\share$ flags: 0 
[ 2642.085683] fs/cifs/connect.c: Domain name set
[ 2642.085686] fs/cifs/connect.c: prefix path /folder
[ 2642.085688] fs/cifs/connect.c: Username: shipclar
[ 2642.085691] fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
[ 2642.085729] fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 1275 with uid: 1000
[ 2642.085732] fs/cifs/connect.c: UNC: \\server\share$ ip: 10.10.10.157
[ 2642.085742] fs/cifs/connect.c: Socket created
[ 2642.085744] fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
[ 2642.085962] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1276 with uid: 1000
[ 2642.085964] fs/cifs/connect.c: Existing smb sess not found
[ 2642.085967] fs/cifs/cifssmb.c: secFlags 0x7
[ 2642.085968] fs/cifs/transport.c: For smb_command 114
[ 2642.085969] fs/cifs/transport.c: Sending smb:  total_len 82
[ 2642.085983] fs/cifs/connect.c: Demultiplex PID: 4389
[ 2642.086143] fs/cifs/connect.c: rfc1002 length 0x67
[ 2642.086152] fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
[ 2642.086155] fs/cifs/cifssmb.c: Dialect: 2
[ 2642.086158] fs/cifs/cifssmb.c: negprot rc 0
[ 2642.086161] fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x1e3fd TimeAdjust: 14400
[ 2642.086163] fs/cifs/sess.c: sess setup type 1
[ 2642.086182] fs/cifs/transport.c: For smb_command 115
[ 2642.086184] fs/cifs/transport.c: Sending smb:  total_len 260
[ 2642.088296] fs/cifs/connect.c: rfc1002 length 0xef
[ 2642.088308] fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
[ 2642.088309] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2642.088311] fs/cifs/sess.c: UID = 49152 
[ 2642.088312] fs/cifs/sess.c: bleft 193
[ 2642.088314] fs/cifs/sess.c: serverOS=Windows Server (R) 2008 Standard 6001 Service Pack 1
[ 2642.088316] fs/cifs/sess.c: serverNOS=Windows Server (R) 2008 Standard 6.0
[ 2642.088318] fs/cifs/sess.c: serverDomain=TURTLE
[ 2642.088319] fs/cifs/sess.c: ssetup freeing small buf ffff880129c80e00
[ 2642.088320] fs/cifs/connect.c: CIFS Session Established successfully
[ 2642.088322] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1276) rc = 0
[ 2642.088324] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 1277 with uid: 1000
[ 2642.088326] fs/cifs/transport.c: For smb_command 117
[ 2642.088327] fs/cifs/transport.c: Sending smb:  total_len 80
[ 2642.088714] fs/cifs/connect.c: rfc1002 length 0x42
[ 2642.088722] fs/cifs/transport.c: cifs_sync_mid_result: cmd=117 mid=3 state=4
[ 2642.088726] fs/cifs/connect.c: disk share connection
[ 2642.088729] fs/cifs/connect.c: nativeFileSystem=NTFS
[ 2642.088730] fs/cifs/connect.c: Tcon flags: 0x1 
[ 2642.088733] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 1277) rc = 0
[ 2642.088735] fs/cifs/connect.c: CIFS Tcon rc = 0
[ 2642.088737] fs/cifs/cifssmb.c: In QFSDeviceInfo
[ 2642.088740] fs/cifs/transport.c: For smb_command 50
[ 2642.088742] fs/cifs/transport.c: Sending smb:  total_len 72
[ 2642.088906] fs/cifs/connect.c: rfc1002 length 0x44
[ 2642.088914] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=4 state=4
[ 2642.088917] fs/cifs/cifssmb.c: In QFSAttributeInfo
[ 2642.088919] fs/cifs/transport.c: For smb_command 50
[ 2642.088921] fs/cifs/transport.c: Sending smb:  total_len 72
[ 2642.089074] fs/cifs/connect.c: rfc1002 length 0x50
[ 2642.089082] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=5 state=4
[ 2642.089085] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\server\share$\folder
[ 2642.089093] fs/cifs/transport.c: For smb_command 117
[ 2642.089094] fs/cifs/transport.c: Sending smb:  total_len 98
[ 2642.089263] fs/cifs/connect.c: rfc1002 length 0x3c
[ 2642.089271] fs/cifs/transport.c: cifs_sync_mid_result: cmd=117 mid=6 state=4
[ 2642.089274] fs/cifs/connect.c: CIFS Tcon rc = 0 ipc_tid = 24581
[ 2642.089276] fs/cifs/cifssmb.c: In GetDFSRefer the path \server\share$
[ 2642.089279] fs/cifs/transport.c: For smb_command 50
[ 2642.089280] fs/cifs/transport.c: Sending smb:  total_len 98
[ 2642.089424] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.089427] fs/cifs/connect.c: invalid transact2 word count
[ 2642.089434] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=7 state=4
[ 2642.089438] Status code returned 0xc000019c NT_STATUS_FS_DRIVER_REQUIRED
[ 2642.089441] fs/cifs/netmisc.c: Mapping smb error code 0xc000019c to POSIX err -5
[ 2642.089443] fs/cifs/cifssmb.c: Send error in GetDFSRefer = -5
[ 2642.089447] fs/cifs/transport.c: For smb_command 50
[ 2642.089448] fs/cifs/transport.c: Sending smb:  total_len 86
[ 2642.089693] fs/cifs/connect.c: rfc1002 length 0x9c
[ 2642.089701] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=8 state=4
[ 2642.089705] fs/cifs/connect.c: SPOT#2
[ 2642.089707] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 1275) rc = 0
[ 2642.089718] fs/cifs/inode.c: CIFS VFS: in cifs_root_iget as Xid: 1278 with uid: 1000
[ 2642.089720] fs/cifs/inode.c: Getting info on 
[ 2642.089722] fs/cifs/transport.c: For smb_command 50
[ 2642.089724] fs/cifs/transport.c: Sending smb:  total_len 78
[ 2642.090253] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.090256] fs/cifs/connect.c: invalid transact2 word count
[ 2642.090263] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=9 state=4
[ 2642.090265] Status code returned 0xc0000022 NT_STATUS_ACCESS_DENIED
[ 2642.090269] fs/cifs/netmisc.c: Mapping smb error code 0xc0000022 to POSIX err -13
[ 2642.090271] fs/cifs/cifssmb.c: Send error in QPathInfo = -13
[ 2642.090273] CIFS VFS: cifs_read_super: get root inode failed
[ 2642.090278] fs/cifs/connect.c: cifs_put_tcon: tc_count=1
[ 2642.090279] 
[ 2642.090281] fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 1279 with uid: 1000
[ 2642.090283] fs/cifs/cifssmb.c: In tree disconnect
[ 2642.090285] fs/cifs/transport.c: For smb_command 113
[ 2642.090287] fs/cifs/transport.c: Sending smb:  total_len 39
[ 2642.090462] fs/cifs/connect.c: rfc1002 length 0x27
[ 2642.090467] fs/cifs/transport.c: cifs_sync_mid_result: cmd=113 mid=10 state=4
[ 2642.090469] fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
[ 2642.090469] 
[ 2642.090470] fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 1280 with uid: 1000
[ 2642.090472] fs/cifs/cifssmb.c: In SMBLogoff for session disconnect
[ 2642.090473] fs/cifs/transport.c: For smb_command 116
[ 2642.090474] fs/cifs/transport.c: Sending smb:  total_len 43
[ 2642.090815] fs/cifs/connect.c: rfc1002 length 0x2b
[ 2642.090823] fs/cifs/transport.c: cifs_sync_mid_result: cmd=116 mid=11 state=4
[ 2642.124026] fs/cifs/cifs_dfs_ref.c: cifs_dfs_do_automount: cifs_dfs_do_refmount:\server\share$\folder , mnt:fffffffffffffff3
[ 2642.124030] fs/cifs/cifs_dfs_ref.c: leaving cifs_dfs_do_automount
[ 2642.124032] fs/cifs/cifs_dfs_ref.c: leaving cifs_dfs_d_automount [automount failed]


--------------030703020509020506000600--
