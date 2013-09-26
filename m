From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC] extending splice for copy offloading
Date: Thu, 26 Sep 2013 21:34:51 +0200
Message-ID: <20130926213451.33570dc4@linux-y6zt.site>
References: <CAH2r5muBuTK7ZZ+aKGC4q35gqaSWF4o07eoHypLKiNn5Y83RbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muBuTK7ZZ+aKGC4q35gqaSWF4o07eoHypLKiNn5Y83RbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

On Thu, 26 Sep 2013 12:22:49 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Windows clients seem to max out at 16MB chunk size when doing copy
> offload.   I would like to increase chunk size larger than that if
> network bandwidth (returned at mount time in SMB3 on the query network
> interfaces FSCTL) is large enough, and response time is not more than
> 100 (?) milliseconds.

Sounds good, though with Samba and Btrfs the request latency will be
heavily effected by whether the FSCTL_SRV_COPYCHUNK wire request byte
offsets and lengths align to the Btrfs sector-size (4K by default
IIRC).
If they do align, then each chunk in the request can be mapped to a
BTRFS_IOC_CLONE_RANGE ioctl. Otherwise, we need to fall back to a
server-side local read/write.

We should be able to provide underlying filesystem alignment
requirements to SMB clients via the new FileFSSectorSizeInformation
ioctl, but it's not currently supported by Samba.

Cheers, David
