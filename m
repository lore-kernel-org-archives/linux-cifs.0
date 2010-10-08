From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 00/15] cifs: clean up management of open filehandle (try
 #2)
Date: Fri, 08 Oct 2010 15:10:18 +0530
Message-ID: <4CAEE702.8070500@suse.de>
References: <1286394857-32541-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286394857-32541-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/07/2010 01:24 AM, Jeff Layton wrote:
> This is the second attempt at the patchset to clean up the management
> of open filehandles in CIFS. The main changes are:
> 
> 1) elimination of some more unnecessary NULL pointer checks
> 
> 2) the cifs_file_list_lock (aka GlobalSMBSeslock) has been left as a
> rwlock_t, though it has been renamed as before
> 
> 3) the order of operations in cifs_oplock_break_put has been fixed --
> previously it put the sb reference before the cifsFileInfo reference
> which could have led to oopses.
> 
> 4) cifs_flush only waits for writeback to complete on filehandles that
> were opened with FMODE_WRITE set.
> 
> The patchset has passed several hours running the connectathon testsuite
> in a loop.
> 
> Suresh and Shaggy both sent acks for various parts of the patchset, but
> the last few patches had enough substantial changes that I didn't want
> to add them without their "re-acks".
> 

Except for the patches [10/15] and [13/15] for which it appears spinlock
is the way to go, rest of the patches look fine to me.


Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
