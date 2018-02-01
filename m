From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: Work in progress SMB-Direct driver for the linux kernel
Date: Thu, 1 Feb 2018 10:52:47 -0700
Message-ID: <20180201175247.GT17053@ziepe.ca>
References: <959c3608-c508-17c4-bad6-fd9421a4a235@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Ralph =?utf-8?B?QsO2aG1l?= <slow-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <959c3608-c508-17c4-bad6-fd9421a4a235-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Feb 01, 2018 at 09:18:10AM +0100, Stefan Metzmacher wrote:

> The first goal is to provide a socket fd to userspace (or in kernel
> consumers)
> which provides semantics like a TCP socket which is used as transport
> for SMB3. Basically frames are submitted with a 4 byte length header.

Part of the point of RDMA is that we don't need to make protocol
specific kernel modules like this - is there a specific reason this
needs to be in the kernel like this?

Jason
