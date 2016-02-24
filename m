From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Interop Issue: SMB2+ async replies, and the kernel, Samba side
 fix enclosed.
Date: Wed, 24 Feb 2016 11:04:08 -0800
Message-ID: <20160224190408.GC16429@jra3>
References: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
 <56CC591F.30205@samba.org>
 <1D07D524-6243-4DF5-BBEB-13EE3A2B62AE@samba.org>
 <CAAPGDwL-VsVmPzFFEM5nOAgFCz68a2KHWGAy9KH6ED5PD0vx_Q@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steven French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Ira Cooper <ira-mA6sH8tAw6XR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAPGDwL-VsVmPzFFEM5nOAgFCz68a2KHWGAy9KH6ED5PD0vx_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Feb 23, 2016 at 11:41:34PM -0500, Ira Cooper wrote:
> You'll find it easy to reproduce if you:
> 
> Set  aio read size = 1 in smb.conf.
> 
> And modify line 101 in smb2_read.c or close by to be:
> 
>     return smbd_smb2_request_pending_queue(req, subreq, 1);
> 
> Writing a 1 GB file, umounting the share, and mounting the share again,
> then using dd to read it back with rsize and wsize set to 1MB, should do it.
> 
> We can reproduce it as is with Gluster, I suspect that may be enough to do
> it with XFS or other filesystems.
> 
> Does anyone know what the windows timeout for sending the interim reply
> is?  Barring this bug, sending it when we don't have to is wasteful.

Hmmm. We can only test this by causing a Windows read to
take a long time. Any idea how to test this ? Does Win32
have named pipes in the fs we could use for that ? If not
we could test using a program that creates a \\pipe\named_pipe
and then responds slowly... But I don't know if the
timeout replies on np's are the same as in the filesystem.
