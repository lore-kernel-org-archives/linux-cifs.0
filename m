From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [linux-cifs-client] can someone please explain the performance
 difference between mount.cifs and smbclient?
Date: Thu, 27 Jan 2011 13:25:04 -0600
Message-ID: <AANLkTik29fUn=SXG-R8qpgVfjCsZ7BGB-S1n+UxGTmyJ@mail.gmail.com>
References: <20110127190719.72653d38@harpe.intellique.com>
	<20110127135410.6046a8cd@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Emmanuel Florac <eflorac-PuSHN2nxisHn0MxWRTiXmQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110127135410.6046a8cd-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jan 27, 2011 at 12:54 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 27 Jan 2011 19:07:19 +0100
> Emmanuel Florac <eflorac-PuSHN2nxisHn0MxWRTiXmQ@public.gmane.org> wrote:
>
>>
>> Using mount -t cifs //server/share /mnt/share between two big servers
>> connected with 10GigE, I've got : 115 MB/s reading, 132 MB/s writing.
>> Using smbclient, I've got 450 MB/s reading, 132 MB/s writing (NFS gives
>> ~ 260 MB/s write, 550 MB/s read on the same setup, with absolutely zero
>> optimisation).
>>
>> Why this huge difference? BTW, why such a discrepancy between read and
>> write speed?
>
> FWIW, linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org is deprecated.
>
> cc'ing linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org which is the new mailing list...
>
> Most likely you're seeing the result of a lack of parallelism in the
> Linux kernel cifs client. It does not do async writes (yet), which
> really hinders throughput.

The Linux cifs client does a good job of sending requests for
different files in parallel, and there are typically not "big kernel lock"
type problems - but for i/o to the same inode ... cifs_writepages and
cifs_readpages are serialized so you have "dead time" on the network
while the server (and later the client) is processing the request and
no request is in flight for part of the time.

The reason that cifs read performance is relatively worse - is that the
default cifs read size is only 4 pages (16K, one cifs buffer) where with
write we can sent 14 pages at a time (and more like zerocopy we
use iovecs so we don't have an extra copy operation).  We can still
only send one write or read to the same file at a time where nfs
frequently sends three or four reads (or writes) at one time gaining
more parallelism.   As you increase the number of processes
cifs gets better.   Also note that large file read for cifs can get better
in many cases when mounting with "forcedirectio."

To beat nfs performance for sequential read or write, with cifs
IIRC you typically need at least 4 processes
reading and/or writing from different files to beat nfs.

> I'm hoping to get to work on that in the next few months unless someone
> else beats me to it...

The similar async read/write feature in the SMB2 kernel client prototype
showed at least 30% improvement (SMB2 has some other performance
improvements that are not prototyped as well - but for dispatch of
reads/writes of
similar size to cifs the async dispatch helps keep the network more busy)


-- 
Thanks,

Steve
