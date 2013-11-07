From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 3.13 merge window
Date: Thu, 7 Nov 2013 11:12:47 -0500
Message-ID: <20131107111247.1fafdc28@tlielax.poochiereds.net>
References: <CAH2r5mt3sr2aj37bVmP0aQ6YW_w=9rvDzPrWXzppJk7NBpp_sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt3sr2aj37bVmP0aQ6YW_w=9rvDzPrWXzppJk7NBpp_sA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 7 Nov 2013 09:57:08 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Currently in cifs-2.6.git for-linus there are these 11 patches in
> 
> http://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-linus
> 
> Query network adapter info at mount time for debugging
> Fix unused variable warning when CIFS POSIX disabled
> Allow setting per-file compression via CIFS protocol
> Query File System Alignment
> Query device characteristics at mount time from server on SMB2/3 not just
> on cifs moun
> cifs: Send a logoff request before removing a smb session
> cifs: Make big endian multiplex ID sequences monotonic on the wire
> cifs: Remove redundant multiplex identifier check from check_smb_hdr()
> Query file system attributes from server on SMB2, not just cifs, mounts
> Allow setting per-file compression via SMB2/3
> Fix corrupt SMB2 ioctl requests
> 
> The copy offload patches are not quite ready but I would like them to clean
> them up in the next few days
> 
> We have Pavel's reparse point fix to merge - but I want to test against the
> Windows 8.1/Windows 2012 "dedup" reparse points (which a customer
> complained about)
> 
> I have requests to:
> 1) add support for opens with O_DIRECT flag (one of the spec benchmarks
> opens with O_DIRECT apparently)
> 2) up the maximum SMB2/SMB3 i/o sizes (should help performance, and
> especially perf testing)
> 2) add support for SMB3 per-share encryption
> 3) add the fsctl for share renegotiate
> 
> Jeff had mentioned added a /sys/fs/cifs for exposing some of the additional
> debug and share config information we now collect in SMB3
> 
> Am I missing anything?
> 
> 

The only one I have is this that I sent back in September. I don't
recall the outcome of the discussion though:

    cifs: don't spam the logs on unexpected lookup errors

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
