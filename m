From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 6/9] CIFS: Separate filling pages from iovec write
Date: Thu, 26 Jun 2014 16:39:37 +0400
Message-ID: <CAKywueR3DFJSx8wJnavOMe_fbYY6uQvy-uPBRnhu2bRxrqdiwg@mail.gmail.com>
References: <1403535517-8301-1-git-send-email-pshilovsky@samba.org>
	<1403535517-8301-7-git-send-email-pshilovsky@samba.org>
	<CAH2r5mvK-co524mw8yEsA3-EbzpeRG2rO+FurGJ5CThbwQdLYg@mail.gmail.com>
	<CAKywueQao8-Oqi_OwM8yKu63LcYUL8jCd4h7kTt6y8_ZJ7YPwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQao8-Oqi_OwM8yKu63LcYUL8jCd4h7kTt6y8_ZJ7YPwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-06-26 13:33 GMT+04:00 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> 2014-06-26 9:46 GMT+04:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> FYI - merge conflict in current cifs-2.6.git for-next (and current
>> mainline kernel) due to Al Viro's read_iter and write_iter changes.
>>
>> Presumably due to changeset
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/cifs?id=16b9057804c02e2d351e9c8f606e909b43cbd9e7
>>
>> Would you rebase on current cifs-2.6.git or current mainline from this patch on?
>
> Yes, I started to do it but noticed that the existing code (without my
> patches) has data coherency problem on reconnect during reading when
> mounting with cache=none. Now, I am investigating this.

Figured it out:

started to receive read data (16 iovs are expected):
Jun 26 14:46:03 adventure kernel: [11874.820889]
/home/piastry/git/cifs-2.6/fs/cifs/cifssmb.c: cifs_readv_receive:
mid=4938 offset=25308416 bytes=65536
Jun 26 14:46:03 adventure kernel: [11874.820893]
/home/piastry/git/cifs-2.6/fs/cifs/cifssmb.c: cifs_readv_receive:
total_read=84 data_offset=84
Jun 26 14:46:03 adventure kernel: [11874.820895]
/home/piastry/git/cifs-2.6/fs/cifs/cifssmb.c: 0: iov_base=f43e5340
iov_len=84
Jun 26 14:46:03 adventure kernel: [11874.820898]
/home/piastry/git/cifs-2.6/fs/cifs/file.c: 0: iov_base=ffd10000
iov_len=4096
Jun 26 14:46:03 adventure kernel: [11874.821739]
/home/piastry/git/cifs-2.6/fs/cifs/file.c: 1: iov_base=ffd11000
iov_len=4096
Jun 26 14:46:03 adventure kernel: [11874.821745]
/home/piastry/git/cifs-2.6/fs/cifs/file.c: 2: iov_base=ffd12000
iov_len=4096
Jun 26 14:46:03 adventure kernel: [11874.821750]
/home/piastry/git/cifs-2.6/fs/cifs/file.c: 3: iov_base=ffd13000
iov_len=4096
Jun 26 14:46:03 adventure kernel: [11874.823222]
/home/piastry/git/cifs-2.6/fs/cifs/file.c: 4: iov_base=ffd14000
iov_len=4096
Jun 26 14:46:03 adventure kernel: [11874.823229]
/home/piastry/git/cifs-2.6/fs/cifs/file.c: 5: iov_base=ffd15000
iov_len=4096
Jun 26 14:46:03 adventure kernel: [11874.850629]
/home/piastry/git/cifs-2.6/fs/cifs/file.c: 6: iov_base=ffd16000
iov_len=4096
Jun 26 14:46:03 adventure kernel: [11874.850647]
/home/piastry/git/cifs-2.6/fs/cifs/file.c: 7: iov_base=ffd17000
iov_len=4096
Jun 26 14:46:03 adventure kernel: [11874.850653]
/home/piastry/git/cifs-2.6/fs/cifs/file.c: 8: iov_base=ffd18000
iov_len=4096

stop the link here (got only 8 iovs) ...

Jun 26 14:47:26 adventure kernel: [11957.724068]
/home/piastry/git/cifs-2.6/fs/cifs/smb2pdu.c: In echo request
Jun 26 14:47:26 adventure kernel: [11957.724078]
/home/piastry/git/cifs-2.6/fs/cifs/transport.c: Sending smb:
smb_len=68
Jun 26 14:48:09 adventure kernel: [12000.850119] CIFS VFS: Server
192.168.1.34 has not responded in 120 seconds. Reconnecting...
Jun 26 14:48:09 adventure kernel: [12000.850125]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: Reconnecting tcp session
Jun 26 14:48:09 adventure kernel: [12000.850128]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: cifs_reconnect: marking
sessions and tcons for reconnect
Jun 26 14:48:09 adventure kernel: [12000.850131]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: cifs_reconnect: tearing
down socket
Jun 26 14:48:09 adventure kernel: [12000.850133]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: State: 0x3 Flags: 0x0
Jun 26 14:48:09 adventure kernel: [12000.850186]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: Post shutdown state: 0x3
Flags: 0x0
Jun 26 14:48:09 adventure kernel: [12000.850195]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: cifs_reconnect: moving
mids to private list
Jun 26 14:48:09 adventure kernel: [12000.850197]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: cifs_reconnect: issuing
mid callbacks
Jun 26 14:48:09 adventure kernel: [12000.850219]
/home/piastry/git/cifs-2.6/fs/cifs/smb2pdu.c: smb2_readv_callback:
mid=4938 state=8 result=0 bytes=65536

state=8 means -EAGAIN error that is set to rdata->result

Jun 26 14:49:09 adventure kernel: [12060.888067]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: Socket created
Jun 26 14:49:09 adventure kernel: [12060.888074]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: sndbuf 16384 rcvbuf
87380 rcvtimeo 0x6d6
Jun 26 14:49:12 adventure kernel: [12063.898765]
/home/piastry/git/cifs-2.6/fs/cifs/cifssmb.c: total_read=32852
buflen=65620 remaining=65536
Jun 26 14:49:12 adventure kernel: [12063.898811]
/home/piastry/git/cifs-2.6/fs/cifs/smb2pdu.c: Negotiate protocol
Jun 26 14:49:12 adventure kernel: [12063.898819]
/home/piastry/git/cifs-2.6/fs/cifs/transport.c: Sending smb:
smb_len=102
Jun 26 14:49:47 adventure kernel: [12098.271408]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: Received no data or
error: expecting 16052
Jun 26 14:49:47 adventure kernel: [12098.271408] got -104
Jun 26 14:49:47 adventure kernel: [12098.271413]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: Reconnecting tcp session
Jun 26 14:49:47 adventure kernel: [12098.271417]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: cifs_reconnect: marking
sessions and tcons for reconnect
Jun 26 14:49:47 adventure kernel: [12098.271420]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: cifs_reconnect: tearing
down socket
Jun 26 14:49:47 adventure kernel: [12098.271422]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: State: 0x3 Flags: 0x0
Jun 26 14:49:47 adventure kernel: [12098.271425]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: Post shutdown state: 0x3
Flags: 0x0
Jun 26 14:49:47 adventure kernel: [12098.271436]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: cifs_reconnect: moving
mids to private list
Jun 26 14:49:47 adventure kernel: [12098.271439]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: cifs_reconnect: issuing
mid callbacks
Jun 26 14:49:47 adventure kernel: [12098.271456]
/home/piastry/git/cifs-2.6/fs/cifs/transport.c: cifs_sync_mid_result:
cmd=0 mid=0 state=8
Jun 26 14:49:47 adventure kernel: [12098.271458]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: Socket created
Jun 26 14:49:47 adventure kernel: [12098.271461]
/home/piastry/git/cifs-2.6/fs/cifs/connect.c: sndbuf 16384 rcvbuf
87380 rcvtimeo 0x6d6
Jun 26 14:49:47 adventure kernel: [12098.271465]
/home/piastry/git/cifs-2.6/fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release
Jun 26 14:49:47 adventure kernel: [12098.271491]
/home/piastry/git/cifs-2.6/fs/cifs/smb2pdu.c: smb2_async_readv:
offset=25439488 bytes=65536
Jun 26 14:49:57 adventure kernel: [12108.268065]
/home/piastry/git/cifs-2.6/fs/cifs/smb2pdu.c: Negotiate protocol
Jun 26 14:49:57 adventure kernel: [12108.268075]
/home/piastry/git/cifs-2.6/fs/cifs/transport.c: Sending smb:
smb_len=102

Then connection is establed and we resend read request ...

Jun 26 14:49:58 adventure kernel: [12108.958891]
/home/piastry/git/cifs-2.6/fs/cifs/smb2pdu.c: smb2_async_readv:
offset=25308416 bytes=32768 (!!!!!!!!!!!!!!!!!!!!)
Jun 26 14:49:58 adventure kernel: [12108.958897]
/home/piastry/git/cifs-2.6/fs/cifs/transport.c: Sending smb:
smb_len=113

... with wrong length (32768 instead of 65536 as it was before). The
rdata->bytes field is set to this value here:
1515 >-------length = rdata->read_into_pages(server, rdata, data_len);
1516 >-------if (length < 0)
1517 >------->-------return length;
1518
1519 >-------server->total_read += length;
1520 >-------rdata->bytes = length;

So, we got short read, update rdata->bytes and then retry the request
with this new length value. I suggest we need to add a check like this
(tested and ok):

if (rdata->result != -EAGAIN)
        rdata->bytes = length;

Thoughts?

-- 
Best regards,
Pavel Shilovsky.
