From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: copy chunk preliminary results
Date: Thu, 21 Nov 2013 06:31:56 -0600
Message-ID: <CAH2r5mu6umOEdWutZtoE74+2h_m5QVfX_J4KeCEYNjzyZu7gPA@mail.gmail.com>
References: <CAH2r5mtoGCn-z_-Aetwaxxvn8bS19mexb7Rur3TE=RGipGCppQ@mail.gmail.com>
	<527771DA.1050701@draigBrady.com>
	<20131121114541.09f67b3f@plati.site>
	<20131121112044.GA26664@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	"P??draig Brady" <P@draigbrady.com>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131121112044.GA26664-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 21, 2013 at 5:20 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Thu, Nov 21, 2013 at 11:45:41AM +0100, David Disseldorp wrote:
>> It depends on how the SMB server interprets the copy-chunk wire request.
>> On Btrfs, Samba can translate the request into a BTRFS_IOC_CLONE_RANGE
>> ioctl, in which case the same CoW semantics are observed[1]. See:
>>
>> https://wiki.samba.org/index.php/Server-Side_Copy#Btrfs_Enhanced_Server-Side_Copy_Offload
>>
>> By default however, Samba (and Windows) will perform the copy on the
>> server-side using regular reads/writes. A generic cp --offload or
>> similar would probably make more sense on the client side.

On copychunk Windows server is clearly doing the equivalent of reflink
internally,
so this isn't just Samba/btrfs.  I was getting performance more than 100 times
better using copychunk to Windows than doing copy with sending
reads/writes over the network.

> I don't think it really matters what the optimal case is, it matters
> what the worst case is.  Think about it - a reflink really just is
> a smart shortcut for copy + dedup, which a filesystem on the server
> could do anyway.
>
> On the other hand a user of cp --reflink expects it to be a quick
> operation.

My tests show that in every case the copychunk over SMB2/SMB3 mount is
much faster even in the worst case where it is emulated in Samba.

> So it's time folks finally get the damn copyfile system call in, use
> that for CIFS, NFS and co, as well as letting btrfs optimize it.

I agree that the copyfile system call would be a big help.

-- 
Thanks,

Steve
