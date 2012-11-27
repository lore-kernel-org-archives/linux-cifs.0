From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mounting SMB2 fails with -EINVAL on 3.7-rc7
Date: Tue, 27 Nov 2012 10:27:45 -0600
Message-ID: <CAH2r5msNJSdS5Pq3+PY0Lndg0C22GR-27HNA8vzBVfT50x3uQA@mail.gmail.com>
References: <50B48601.6070000@suse.com>
	<CAKywueT-Wi_gS8SNOQ+Ac-MNFNSuN_ni1BA8neQsy0836w6BvA@mail.gmail.com>
	<50B4B972.8070604@suse.com>
	<CAKywueSm5K_H870mvQED02fqKoY8FTR=T+RhAo6hk3VzN3Jd4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSm5K_H870mvQED02fqKoY8FTR=T+RhAo6hk3VzN3Jd4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have a patch for 2.0 support that was in my for-next branch for a
little bit but I decided was too late for 3.7

On Tue, Nov 27, 2012 at 7:21 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2012/11/27 Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>:
>> On 11/27/2012 06:26 PM, Pavel Shilovsky wrote:
>>> 2012/11/27 Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>:
>>>> When I try to mount a Samba (3.6.7) share via SMB2, the mount is failing.
>>>>
>>>>    mount -t cifs -o vers=2.1,user=joe //server/share /mnt
>>>>    mount error (22): Invalid Argument
>>>>
>>>> Looks like Negotiate Protocol is failing but not sure why.
>>>>
>>>> Here's the cFYI snip:
>>>>
>>>> [ 2895.256899] CIFS VFS: cifs_mount failed w/return code = -22
>>>> [ 2904.421947] fs/cifs/cifsfs.c: Devname: //164.99.140.187/local/ flags: 0
>>>> [ 2904.421999] fs/cifs/connect.c: Username: cg
>>>> [ 2904.427252] fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
>>>> [ 2904.427434] fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 15 with uid: 0
>>>> [ 2904.427439] fs/cifs/connect.c: UNC: \\164.99.140.187\local ip: 164.99.140.187
>>>> [ 2904.427489] fs/cifs/connect.c: Socket created
>>>> [ 2904.427493] fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x1b58
>>>> [ 2904.428276] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 16 with uid: 0
>>>> [ 2904.428281] fs/cifs/connect.c: Existing smb sess not found
>>>> [ 2904.428288] fs/cifs/smb2pdu.c: Negotiate protocol
>>>> [ 2904.428295] fs/cifs/smb2pdu.c: sec_flags 0x87
>>>> [ 2904.428301] fs/cifs/transport.c: Sending smb: smb_len=102
>>>> [ 2904.428460] fs/cifs/connect.c: Demultiplex PID: 1899
>>>> [ 2904.429585] fs/cifs/connect.c: RFC1002 header 0x49
>>>> [ 2904.429593] fs/cifs/smb2misc.c: smb2_check_message length: 0x4d, smb_buf_length: 0x49
>>>> [ 2904.429596] fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
>>>> [ 2904.429597] fs/cifs/smb2misc.c: SMB2 len 77
>>>> [ 2904.429648] fs/cifs/transport.c: cifs_sync_mid_result: cmd=0 mid=0 state=4
>>>> [ 2904.429654] Status code returned 0xc000000d STATUS_INVALID_PARAMETER
>>>> [ 2904.429661] fs/cifs/smb2maperror.c: Mapping SMB2 status code -1073741811 to POSIX err -22
>>>> [ 2904.429663] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
>>>> [ 2904.429667] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 16) rc = -22
>>>> [ 2904.429883] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 15) rc = -22
>>>> [ 2904.429885] CIFS VFS: cifs_mount failed w/return code = -22
>>>>
>>>>
>>>> Is this a known issue?
>>>>
>>> Samba doesn't support SMB2.1 protocol - 2.0 only. We need to add a
>>> mount option vers=2.0 to enable Samba support.
>>>
>>
>> Ah, ok. I see
>>
>> enum smb_version {
>>         Smb_1 = 1,
>>         Smb_21,
>>         Smb_30,
>> };
>>
>> So, at the current state we won't be able to use smb2 client with Samba
>> server, right?
>
> Yes. Steve, any plans on returning SMB2.0 support to the client? (it
> was removed after we decide that vers=2.1 mount option should
> negotiate 2.1 protocol only).
>
> --
> Best regards,
> Pavel Shilovsky.



-- 
Thanks,

Steve
