From: Christian Ambach <ambi-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Interop Issue: SMB2+ async replies, and the kernel, Samba side
 fix enclosed.
Date: Tue, 1 Mar 2016 21:10:34 +0100
Message-ID: <56D5F73A.6020005@samba.org>
References: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
 <56CC591F.30205@samba.org> <1D07D524-6243-4DF5-BBEB-13EE3A2B62AE@samba.org>
 <CAAPGDwL-VsVmPzFFEM5nOAgFCz68a2KHWGAy9KH6ED5PD0vx_Q@mail.gmail.com>
 <20160224190408.GC16429@jra3> <20160301134039.GA21826@sernet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steven French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Ira Cooper <ira-mA6sH8tAw6XR7s880joybQ@public.gmane.org>,
	Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160301134039.GA21826-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Am 01.03.16 um 14:40 schrieb Volker Lendecke:
> On Wed, Feb 24, 2016 at 11:04:08AM -0800, Jeremy Allison wrote:
>> Hmmm. We can only test this by causing a Windows read to
>> take a long time. Any idea how to test this ? Does Win32
>> have named pipes in the fs we could use for that ? If not
>> we could test using a program that creates a \\pipe\named_pipe
>> and then responds slowly... But I don't know if the
>> timeout replies on np's are the same as in the filesystem.
>
> Just use a USB2 stick.
>
[MS-SMB2] gives some hints when Windows will send out interim replies:
<296> Section 3.3.5.12: Windows SMB2 servers send an interim response to 
the client and handle the read asynchronously if the read is not 
finished in 0.5 milliseconds.
<297> Section 3.3.5.12: Windows-based servers handle the following
commands asynchronously: SMB2 Create (section 2.2.13) when this create would
result in an oplock break, SMB2 IOCTL Request (section 2.2.31) for
FSCTL_PIPE_TRANSCEIVE if it blocks for more than 1 millisecond, SMB2 IOCTL
Request for FSCTL_SRV_COPYCHUNK or FSCTL_SRV_COPYCHUNK_WRITE (section 
2.2.31)
when oplock break happens, SMB2 Change_Notify Request (section 2.2.35) if
it blocks for more than 0.5 milliseconds, SMB2 Read request (section 2.2.19)
for named pipes if it blocks for more than 0.5 milliseconds,
SMB2 Write request (section 2.2.21) for named pipes if it blocks for more
than 0.5 milliseconds, SMB2 Write Request (section 2.2.21) for large 
file write,
SMB2 lock request (section 2.2.26) if the LOCKFLAG_FAIL_IMMEDIATELY flag 
is not set,
and SMB2 FLUSH Request (section 2.2.17) for named pipes.

Cheers,
Christian
