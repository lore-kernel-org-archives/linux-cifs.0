From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Latest xfstest results
Date: Fri, 29 Aug 2014 10:20:14 -0700
Message-ID: <20140829172014.GA16006@infradead.org>
References: <CAH2r5msh2j2qPsfNPsO2gMb8a_=snKUD=VpuAKhdMO_qopOsLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msh2j2qPsfNPsO2gMb8a_=snKUD=VpuAKhdMO_qopOsLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Seems like most of your issues are time stamp updates, so you
should look into that area a lot more.  Some that I know off head what
the issues are:

On Fri, Aug 29, 2014 at 10:33:14AM -0500, Steve French wrote:
> For 192 delta1 time should be 40 (this seems to work intermittently)
> 
> QA output created by 192
> sleep for 40
> test
> delta1 - access time after sleep in-core: 0
> delta2 - access time after sleep on-disk: 40

atimes update not persisting an umount/remount.  Looks like cifs isn't
properly dirtying the inode for it.

> QA output created by 215
> 
> creating test file
> 4096+0 records in
> 4096+0 records out
> 
> writing via mmap
> FAIL: mtime not update after mapped write
> FAIL: ctime not update after mapped write

missing file_update_time call in cifs_page_mkwrite.

> QA output created by 313
> Silence is golden
> ctime not updated after truncate
> mtime not updated after truncate

missing update of c/mtime for truncate.  The VFS is nasty in it's
setattr calling conventions for this.  Check my 

"[PATCH] nfs: update time staps on truncate"

post on the nfs list for details.
