From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: copy chunk preliminary results
Date: Thu, 21 Nov 2013 03:20:44 -0800
Message-ID: <20131121112044.GA26664@infradead.org>
References: <CAH2r5mtoGCn-z_-Aetwaxxvn8bS19mexb7Rur3TE=RGipGCppQ@mail.gmail.com>
 <527771DA.1050701@draigBrady.com>
 <20131121114541.09f67b3f@plati.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: P??draig Brady <P@draigBrady.com>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131121114541.09f67b3f-k1XZOR0ctBLN0uC3ymp8PA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 21, 2013 at 11:45:41AM +0100, David Disseldorp wrote:
> It depends on how the SMB server interprets the copy-chunk wire request.
> On Btrfs, Samba can translate the request into a BTRFS_IOC_CLONE_RANGE
> ioctl, in which case the same CoW semantics are observed[1]. See:
> 
> https://wiki.samba.org/index.php/Server-Side_Copy#Btrfs_Enhanced_Server-Side_Copy_Offload
> 
> By default however, Samba (and Windows) will perform the copy on the
> server-side using regular reads/writes. A generic cp --offload or
> similar would probably make more sense on the client side.

I don't think it really matters what the optimal case is, it matters
what the worst case is.  Think about it - a reflink really just is
a smart shortcut for copy + dedup, which a filesystem on the server
could do anyway.

On the other hand a user of cp --reflink expects it to be a quick
operation.

So it's time folks finally get the damn copyfile system call in, use
that for CIFS, NFS and co, as well as letting btrfs optimize it.
