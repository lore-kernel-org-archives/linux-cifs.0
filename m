From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: New read cache mechanism
Date: Sun, 19 Sep 2010 09:52:10 -0500
Message-ID: <AANLkTikdQTo8y-zJZ625MCgY15rpYmERGgJKtq=oJ0Wd@mail.gmail.com>
References: <AANLkTinA+YpcYFF6YE-df7sg-thCg87_7Bn5qjC+LxYH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinA+YpcYFF6YE-df7sg-thCg87_7Bn5qjC+LxYH-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Sep 18, 2010 at 1:32 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Add cifs_sync_read call to provide reading from the cache if we have at least
> Level II oplock and otherwise - reading from the server.

This is a stricter guarantee than NFS and will slow performance
dramatically.  If you are going to prevent all ability to reread a
page - this should probably be optional.   This affects cases even
when there are no 2nd clients opening the same file and cases where a
2nd client opened a file but never wrote to it.  Note that the common
case of multiply open files from the same client will break oplock too
even though there is no caching issue there (much as we would like to
change the protocol for that - we have to wait until SMB2 until we can
reaquire or upgrade oplocks).

Currently we write through all writes when we don't have oplock.   We
should also invalidate any cached pages when opening a non-cached file
that has changed since we last opened it - so we will reread these
pages although they will stay in the page cache.   We should
invalidate these cached pages whenever mtime changes (even if some
Windows server defer mtime updates - it will be correct file close or
sync - which is the only place we have guarantees that data is written
anyway).  We check mtime updates in revalidate (and this can be
configured in /proc/fs/cifs to always be sent - rather than every
second).


-- 
Thanks,

Steve
