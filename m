From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Re: connecting to windows server with SMB2
Date: Thu, 10 Jul 2014 15:51:36 +0400
Message-ID: <CAKywueSUQtL1f-36mXKeLjZXVDoQj=aPC_0rOSEGFPte=QaqQw@mail.gmail.com>
References: <23406667.1475351404991248713.JavaMail.weblogic@epv6ml04>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <23406667.1475351404991248713.JavaMail.weblogic@epv6ml04>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-07-10 15:20 GMT+04:00 Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>:
> 2014-07-10 14:26 GMT+04:00 Ashish Sangwan :
>>> I am using kernel version 3.8.13 and windows 7.
>>>
>>> The below command works successfully:
>>> Linux#> mount -t cifs //107.109.224.147/sharefolder /mnt -o user=a.sangwan -o pass=xxxx -o vers=1.0 -o sec=ntlm
>>>
>>> Other than 1.0, all are fail:
>>> Linux#> mount -t cifs //107.109.224.147/sharefolder /mnt -o user=a.sangwan -o pass=xxxx -o vers=2.0 -o sec=ntlm
>>> [ 0][   64.276000] Status code returned 0xc000006d STATUS_LOGON_FAILURE
>>> [ 0][   64.284000] CIFS VFS: Send error in SessSetup = -13
>>>
>>> Tried with sec=ntlmv2/none/lanman/krb5, none of them worked.
>>> Help please!!
>>
>>Did you tries without "sec=" option at all?
> Yes, without sec=ntlm option, I am not able to mount even with vers=1.0
> VDLinux#>  mount -t cifs //107.109.224.147/sharefolder /mnt -o user=a.sangwan -o pass=xxxx -o vers=1.0
> [ 0][ 1082.672000] selected vers 1.0
> [ 0][ 1082.680000] Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
> [ 0][ 1082.688000] CIFS VFS: Send error in SessSetup = -13
> mount: mounting //107.109.224.147/sharefolder on /mnt failed: Permission denied
>>
>>If yes, you should set "echo 1 > /proc/fs/cifs/cifsFYI', try to mount
>>and collect dmesg output and send it to the list.
> Here it is for the command:
> VDLinux#>  mount -t cifs //107.109.224.147/sharefolder /mnt -o user=a.sangwan -o pass=xxxx -o vers=1.0
>
> [ 0][ 1082.844000] fs/cifs/netmisc.c: address conversion returned 1 for 107.109.224.147\sharefolder
> [ 0][ 1082.844000] fs/cifs/connect.c: Username: a.sangwan
> [ 0][ 1082.844000] fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
> [ 0][ 1082.844000] fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 50 with uid: 0
> [ 0][ 1082.844000] fs/cifs/connect.c: UNC: \\107.109.224.147\sharefolder
> [ 0][ 1082.844000] fs/cifs/connect.c: Socket created
> [ 0][ 1082.844000] fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
> [ 0][ 1082.848000] fs/cifs/fscache.c: cifs_fscache_get_client_cookie: (0xe5b36c00/0xe5b7f230)
> [ 0][ 1082.848000] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 51 with uid: 0
> [ 0][ 1082.848000] fs/cifs/connect.c: Existing smb sess not found
> [ 0][ 1082.848000] fs/cifs/cifssmb.c: secFlags 0x81
> [ 0][ 1082.848000] fs/cifs/cifssmb.c: NTLMSSP only mechanism, enable extended security
> [ 0][ 1082.848000] fs/cifs/transport.c: For smb_command 114
> [ 0][ 1082.848000] fs/cifs/transport.c: Sending smb: smb_len=69
> [ 0][ 1082.848000] fs/cifs/connect.c: Demultiplex PID: 222
> [ 0][ 1082.848000] fs/cifs/connect.c: RFC1002 header 0x7f
> [ 0][ 1082.848000] fs/cifs/transport.c: cifs_sync_mid_result: cmd=114 mid=1 state=4
> [ 0][ 1082.848000] fs/cifs/cifssmb.c: Dialect: 2
> [ 0][ 1082.848000] fs/cifs/cifssmb.c: Max buf = 4356
> [ 0][ 1082.848000] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
> [ 0][ 1082.848000] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
> [ 0][ 1082.848000] fs/cifs/cifssmb.c: negprot rc 0
> [ 0][ 1082.848000] fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x8001e3fc TimeAdjust: -19800
> [ 0][ 1082.848000] fs/cifs/sess.c: sess setup type 3
> [ 0][ 1082.848000] fs/cifs/sess.c: ntlmssp session setup phase 1
> [ 0][ 1082.848000] fs/cifs/transport.c: For smb_command 115
> [ 0][ 1082.848000] fs/cifs/transport.c: Sending smb: smb_len=186
> [ 0][ 1082.848000] fs/cifs/connect.c: RFC1002 header 0x161
> [ 0][ 1082.848000] fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=2 state=4
> [ 0][ 1082.848000] fs/cifs/netmisc.c: Mapping smb error code 0xc0000016 to POSIX err -5
> [ 0][ 1082.848000] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [ 0][ 1082.848000] fs/cifs/sess.c: UID = 2048
> [ 0][ 1082.848000] fs/cifs/sess.c: bleft 131
> [ 0][ 1082.848000] fs/cifs/sess.c: serverOS=Windows 7 Enterprise 7601 Service Pack 1
> [ 0][ 1082.848000] fs/cifs/sess.c: serverNOS=Windows 7 Enterprise 6.1
> [ 0][ 1082.848000] fs/cifs/sess.c: ssetup freeing small buf e5bc1c00
> [ 0][ 1082.848000] fs/cifs/sess.c: ntlmssp session setup phase 3
> [ 0][ 1082.848000] fs/cifs/transport.c: For smb_command 115
> [ 0][ 1082.848000] fs/cifs/transport.c: Sending smb: smb_len=420
> [ 0][ 1082.852000] fs/cifs/connect.c: RFC1002 header 0x23
> [ 0][ 1082.852000] fs/cifs/transport.c: cifs_sync_mid_result: cmd=115 mid=3 state=4
> [ 0][ 1082.852000] Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
> [ 0][ 1082.856000] fs/cifs/netmisc.c: Mapping smb error code 0xc000006d to POSIX err -13
> [ 0][ 1082.856000] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [ 0][ 1082.856000] fs/cifs/sess.c: ssetup freeing small buf e5bc1500
> [ 0][ 1082.856000] CIFS VFS: Send error in SessSetup = -13
> [ 0][ 1082.860000] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 51) rc = -13
> [ 0][ 1082.860000] fs/cifs/fscache.c: cifs_fscache_release_client_cookie: (0xe5b36c00/0xe5b7f230)
>
> In other mail Benjamin has suggessted to additionally provide -o "domain="
> I am wondering why SMB1.0 is success as I don't provide domain in that cas too.
> Anyway, I will try suggesstion.
>
> Additionally, I am able to connect to samba server (v 4.0.2) from the same machine
> without giving any -o sec -o domain option and it is success for all 2.0, 2.1 and 3.0 versions.
>

Sorry for being unclear, I meant dmesg output of unsuccessful mount
with vers=2.0.

-- 
Best regards,
Pavel Shilovsky.
