From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Unable to mount CIFS shares
Date: Mon, 31 Jan 2011 19:10:59 +0530
Message-ID: <4D46BBEB.2080204@suse.de>
References: <4D469AA6.7060401@suse.de> <AANLkTimZXHzm04htXOPXuUySxzEBofiyP5ZxN=5aqj2m@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimZXHzm04htXOPXuUySxzEBofiyP5ZxN=5aqj2m-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 01/31/2011 07:05 PM, Shirish Pargaonkar wrote:
> On Mon, Jan 31, 2011 at 5:19 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>> After updating my tree to HEAD^1, I'm unable to mount CIFS Shares.
>>
>> The topmost commit is:
>>
>> commit d804d41d163c0975d2890c82d7135ada7a2f23a4
>> Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Date:   Fri Jan 28 15:05:43 2011 -0500
>>
>>    cifs: don't pop a printk when sending on a socket is interrupted
>>
>> mount -t cifs //164.99.140.8/share /mnt/cifs/ -o user=vguest
>> Password:
>> mount error(2): No such file or directory
>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>
>> Looks like an error caused due to recent crypto changes.
>> Shirish: any clues?
>>
>> dmesg o/p
>> ----------
>>
>> [ 1079.934780] CIFS VFS: mdfour: Crypto md4 allocation error -2
>> [ 1079.934781]
>> [ 1079.934783] CIFS VFS: Error -2 during NTLM authentication
>> [ 1079.934785] CIFS VFS: Send error in SessSetup = -2
>> [ 1079.934802] CIFS VFS: cifs_mount failed w/return code = -2
>>
>> dmesg with cFYI
>> ----------------
>>
>> [ 1121.620509] fs/cifs/cifsfs.c: Devname: //164.99.140.8/share/ flags: 0
>> [ 1121.620637] fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 24 with uid: 0
>> [ 1121.620649] fs/cifs/connect.c: Username: vguest
>> [ 1121.623357] fs/cifs/connect.c: UNC: \\164.99.140.8\share ip: 164.99.140.8
>> [ 1121.623382] fs/cifs/connect.c: Socket created
>> [ 1121.623770] fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
>> [ 1121.623804] fs/cifs/fscache.c: CIFS: get client cookie (0xffff88001a202800/0xffff88001ceb6588)
>> [ 1121.623809] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 25 with uid: 0
>> [ 1121.623811] fs/cifs/connect.c: Existing smb sess not found
>> [ 1121.623819] fs/cifs/cifssmb.c: secFlags 0x7
>> [ 1121.623824] fs/cifs/transport.c: For smb_command 114
>> [ 1121.623826] fs/cifs/transport.c: Sending smb:  total_len 82
>> [ 1121.623961] fs/cifs/connect.c: Demultiplex PID: 2768
>> [ 1121.625001] fs/cifs/connect.c: rfc1002 length 0x65
>> [ 1121.625007] fs/cifs/misc.c: Calculated size 81 vs length 101 mismatch for mid 1
>> [ 1121.625015] fs/cifs/transport.c: sync_mid_result: cmd=114 mid=1 state=4
>> [ 1121.625018] fs/cifs/cifssmb.c: Dialect: 2
>> [ 1121.625020] fs/cifs/cifssmb.c: negprot rc 0
>> [ 1121.625022] fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x80f3fd TimeAdjust: -19800
>> [ 1121.625024] fs/cifs/sess.c: sess setup type 1
>> [ 1121.627043] CIFS VFS: mdfour: Crypto md4 allocation error -2
>> [ 1121.627044]
>> [ 1121.627046] fs/cifs/smbencrypt.c: SMBNTencrypt Can't generate NT hash, error: -2
>> [ 1121.627048] fs/cifs/cifsencrypt.c: setup_ntlm_response Can't generate NTLM response, error: -2
>> [ 1121.627049] CIFS VFS: Error -2 during NTLM authentication
>> [ 1121.627051] fs/cifs/sess.c: ssetup freeing small buf ffff88001d348140
>> [ 1121.627052] CIFS VFS: Send error in SessSetup = -2
>> [ 1121.627055] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 25) rc = -2
>> [ 1121.627060] fs/cifs/fscache.c: CIFS: release client cookie (0xffff88001a202800/0xffff88001ceb6588)
>> [ 1121.627066] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 24) rc = -2
>> [ 1121.627068] CIFS VFS: cifs_mount failed w/return code = -2
> 
> Suresh, looks like plaintext authentication is failing?
> Does the mount succeed with any of sec options such as
> sec=ntlm or sec=ntlmv2 or sec=ntlmssp?

Seems the issue is due to missing MD4 module. After I enabled
CONFIG_CRYPTO_MD4 as suggested by Jeff, the issue went away.

Jeff, would send the fix in a bit.


-- 
Suresh Jayaraman
