From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mount cifs using SMB2 - Invalid argument
Date: Mon, 9 Jun 2014 09:41:35 -0500
Message-ID: <CADT32e+eSjr88xoFDSV7cXs+fJdNkXwgPM5CDE4Fj_UUt+Ld3g@mail.gmail.com>
References: <A612847CFE53224C91B23E3A5B48BAC7A7A2BE7F5E@xmail3.se.axis.com>
	<CADT32eKz57t-HSadM26EQQtO0u=H02vY9MktMhyu5X+93Vn9FQ@mail.gmail.com>
	<A612847CFE53224C91B23E3A5B48BAC7A7A2BE80A8@xmail3.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Karin Hedlund <karin.hedlund-VrBV9hrLPhE@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A612847CFE53224C91B23E3A5B48BAC7A7A2BE80A8-qSO7W+xaCpBHog8JR6emWdBPR1lH4CV8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

vers=2.0 does not work?

On Mon, Jun 9, 2014 at 8:24 AM, Karin Hedlund <karin.hedlund-VrBV9hrLPhE@public.gmane.org> wrote:
> What I said about wireshark was all wrong! So sorry, my bad!
> (I had another device connected also, and it was that device's SMB protocol negotiation I saw now that I look at it again).
>
> For this specific problem and device I get only one request and one response, and yes, it's indeed SMB protocol version 2 they're trying to negotiate. But I get
> NegotiateProcotol Response, Error: STATUS_INVALID_PARAMETER.
>
> On Mon, Jun 9, 2014 at 2:18 PM, Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>Is it possible to attach wireshark trace here?
>>
>>Regards,
>>
>>Shirish
>
> No, unfortunately I can't post the wireshark trace. Sorry about that. I've attached wireshark screenshots for the SMB request and response packets though, hopefully it's better than nothing.
>
>>>On Mon, Jun 9, 2014 at 4:50 AM, Karin Hedlund <karin.hedlund-VrBV9hrLPhE@public.gmane.org> wrote:
>>> From an embedded device, I'm trying to mount a samba share using SMB2, with the 'vers=2.1' mount option, but I don't seem to get it to work, so I was hoping somebody could maybe shed some light.
>>>
>>> mount -t cifs //192.168.0.1/networkshare /tmp/nas -o
>>> username=,password=,vers=2.1,nounix,noserverino,uid=123,gid=123,nobrl,
>>> file_mode=0770,dir_mode=0770,iocharset=utf8
>>> mount: mounting //192.168.0.1/networkshare on /tmp/nas failed: Invalid
>>> argument
>>>
>>>Client: Embedded device with Linux 3.14 kernel, BusyBox version
>>> v1.20.2p3 I have enabled and built the embedded device's kernel with CONFIG_CIFS_SMB2.
>>> /proc/fs/cifs/DebugData:
>>> CIFS Version 2.02
>>> Features:
>>> Active VFS Requests: 0
>>> Servers:
>>>
>>> dmesg:
>>> <7>[ 3937.470000] fs/cifs/cifsfs.c: Devname:
>>> //192.168.0.1/networkshare flags: 32768 <7>[ 3937.470000]
>>> fs/cifs/connect.c: iocharset set to utf8 <7>[ 3937.470000]
>>> fs/cifs/connect.c: Anonymous login <7>[ 3937.470000]
>>> fs/cifs/connect.c: file mode: 0x1f8  dir mode: 0x1f8 <7>[ 3937.470000]
>>> fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 2 with uid: 0 <7>[
>>> 3937.470000] fs/cifs/connect.c: UNC: \\192.168.0.1\networkshare <7>[
>>> 3937.470000] fs/cifs/connect.c: Socket created <7>[ 3937.470000]
>>> fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x2bc <7>[
>>> 3937.470000] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid:
>>> 3 with uid: 0 <7>[ 3937.470000] fs/cifs/connect.c: Existing smb sess
>>> not found <7>[ 3937.470000] fs/cifs/smb2pdu.c: Negotiate protocol <7>[
>>> 3937.470000] fs/cifs/transport.c: Sending smb: smb_len=102 <7>[
>>> 3937.470000] fs/cifs/connect.c: Demultiplex PID: 3359 <7>[
>>> 3937.480000] fs/cifs/connect.c: RFC1002 header 0x49 <7>[ 3937.480000]
>>> fs/cifs/smb2misc.c: smb2_check_message length: 0x4d, smb_buf_length:
>>> 0x49 <7>[ 3937.480000] fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
>>> <7>[ 3937.480000] fs/cifs/smb2misc.c: SMB2 len 77 <7>[ 3937.480000]
>>> fs/cifs/transport.c: cifs_sync_mid_result: cmd=0 mid=0 state=4 <7>[
>>> 3937.480000] fs/cifs/smb2maperror.c: Mapping SMB2 status code
>>> -1073741811 to POSIX err -22 <7>[ 3937.480000] fs/cifs/misc.c: Null
>>> buffer passed to cifs_small_buf_release <7>[ 3937.480000]
>>> fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 3) rc =
>>> -22 <7>[ 3937.480000] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount
>>> (xid = 2) rc = -22
>>>
>>> Server: Samba 3.6.6 on Debian Wheezy
>>> I do have the max protocol = SMB2 under my [global] section in my samba.conf, and have restarted samba.
>>>
>>> I've also tried to look at the communication over wireshark, and I do see several SMB Negotiate Protocol requests and responses, but in all of the requests there's just "Requested Dialects: Dialect: NT LM 0.12, and in all the responses same thing, Dialect Index:0 NT LM 0.12 - which, as far as I know corresponds to SMB version 1 (?), not the 2.1 version I was hoping for...
>>>
>>> I'm lost here. I thought this was all one needed to do. So, any thoughts, insights or ideas would make me very happy. Thanks you guys!
>>>
>>> Kind regards,
>>> Karin
