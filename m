From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] extending splice for copy offloading
Date: Thu, 26 Sep 2013 12:22:49 -0500
Message-ID: <CAH2r5muBuTK7ZZ+aKGC4q35gqaSWF4o07eoHypLKiNn5Y83RbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>>> I suppose, but can't the app achieve a nice middle ground by copying the
>>> file in smaller syscalls?  Avoid bulk data motion back to the client,
>>> but still get notification every, I dunno, few hundred meg?
>> Yes.  And if "cp"  could just be switched from a read+write syscall
>> pair to a single splice syscall using the same buffer size.
> Will the various magic fs-specific copy operations become inefficient
> when the range copied is too small?

Yes - it is much less efficient for the network file system cases when
copy size is small.   Reasonable minimum is probably at least 1MB.
Windows will use up to 16MB, but a saner approach to this would base
the copy chunk size on either response time or on network bandwidth
for the connection.

Copy offload has been done for a long time with CIFS/SMB2/SMB3
protocol (and obviously helps a lot more over the network for file
copies than locally), but only recently have we added support for this
in Samba through David Disseldorp's work.   i have kernel patches
almost ready to post for cifs.ko for the client side to do copy
offload (cp --reflink) via CopyChunk fsctl over SMB3 which is
supported by most all servers now.

Windows clients seem to max out at 16MB chunk size when doing copy
offload.   I would like to increase chunk size larger than that if
network bandwidth (returned at mount time in SMB3 on the query network
interfaces FSCTL) is large enough, and response time is not more than
100 (?) milliseconds.



-- 
Thanks,

Steve
