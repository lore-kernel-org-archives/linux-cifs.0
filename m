From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 0/6] Add strict cache mode (try #4)
Date: Mon, 29 Nov 2010 16:24:06 +0530
Message-ID: <4CF3864E.50901@suse.de>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290931972-2770-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/28/2010 01:42 PM, Pavel Shilovsky wrote:
> Re-posting the whole set of strict cache patches.

I try to explain here the "strict cache" semantics as I'm not sure
whether I understand it clearly. Please correct me if I'm wrong.

Strict cache semantics

  o provides stricter cache coherency among cifs clients that access
    the same files.
  o The clients will read data from the Server always, except when they
    hold read oplock or Level II oplock on the file.
  o The clients will write data to the Server always, except when they
    hold exclusive oplock on the file.
  o When we close the last filehandle of the inode, file should be
    marked for revalidation as it is possible for the client to access
    stale data from the cache when we open it again with a read
    oplock.
  o On fsync/mmap, invalidate inode if read oplock has not been set.


Is this the semantics being proposed? Did I miss anything?


Thanks,


> Pavel Shilovsky (6):
>   CIFS: Make cifsFileInfo_put work with strict cache mode (try #4)
>   CIFS: Make read call work with strict cache mode (try #2)
>   CIFS: Make write call work with strict cache mode (try #2)
>   CIFS: Make cifs_fsync work with strict cache mode (try #2)
>   CIFS: Make cifs_file_map work with strict cache mode (try #2)
>   CIFS: Add strictcache mount option (try #2)
> 
>  fs/cifs/README       |    5 +++
>  fs/cifs/cifs_fs_sb.h |    1 +
>  fs/cifs/cifsfs.c     |   71 +++++++++++++++++++++++++++++++++++++++++++++----
>  fs/cifs/connect.c    |    5 +++
>  fs/cifs/file.c       |   42 +++++++++++++++++++++--------
>  5 files changed, 106 insertions(+), 18 deletions(-)
> 


-- 
Suresh Jayaraman
