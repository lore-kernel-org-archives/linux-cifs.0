From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] CIFS: New write logic
Date: Tue, 26 Oct 2010 21:38:11 +0400
Message-ID: <AANLkTik88mGfjH-YZWaUJ6bKwa3-xJ5uEzNdjKCkYwyb@mail.gmail.com>
References: <AANLkTikD7Lw-+o6ky6P7NW05B1QYPick0PvZeaqF-_v2@mail.gmail.com>
	<20101026104856.11b69571@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101026104856.11b69571-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff, thanks for review. I will try to explain what this code is going to do.

So, as you can understand this patch affects four modes:
1) strict + cacheAll;
2) strict + not cacheAll;
3) no strict + cacheAll;
4) no strict + no cacheAll.

Let's describe every one.
1) strict + cacheAll.

The client goes to cifs_file_aio_write and returns with
generic_file_aio_write. Then it appears in cifs_write_end call and
goes to the section:

+       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
+               rc = copied;
+               pos += copied;
+
+               if (CIFS_I(inode)->clientCanCacheAll) {
+                       SetPageUptodate(page);
+                       set_page_dirty(page);
+               }
+
+               /* if we don't have an exclusive oplock the page data was
+                  previously written to the server in cifs_file_aio_write,
+                  so we don't need to do it again - goto exit */
+
+               goto exit;
+       }
+

Here it sets don't send anything to the server (because we can cache
the data) but sets page dirty and uptodate and exits - then this data
will be written to the server through writepages code.

2) strict + not cacheAll;

The client goes to cifs_file_aio_write call and appears in this section:

+       saved_pos = pos;
+       written = cifs_user_write(iocb->ki_filp, iov->iov_base,
+                                 iov->iov_len, &pos);
+
+       if (written > 0) {
+               cache_written = generic_file_aio_write(iocb, iov,
+                                                      nr_segs, saved_pos);
+               if (cache_written != written)
+                       cERROR(1, "Cache written and server written data "
+                              "lengths are different");
+       } else
+               iocb->ki_pos = pos;

So, it writes the data to the server in cifs_user_write and if it was
successful (written > 0), call generic_file_aio_write that stores the
data in the filesystem cache and calls cifs_write_end. In
cifs_write_end we again appear in the section

+       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
+               rc = copied;
+               pos += copied;
+
+               if (CIFS_I(inode)->clientCanCacheAll) {
+                       SetPageUptodate(page);
+                       set_page_dirty(page);
+               }
+
+               /* if we don't have an exclusive oplock the page data was
+                  previously written to the server in cifs_file_aio_write,
+                  so we don't need to do it again - goto exit */
+
+               goto exit;
+       }
+

but in this case we don't set any flags because the page isn't dirty
(we wrote it to the server and don't need to flush it again).

3) no strict + cacheAll.

The client goes to cifs_file_aio_write and returns with
generic_file_aio_write that stored the data in the filesystem cache
and call cifs_write_end. This scenario is the same as we have in the
upstream code now.

4) no strict + cacheAll.

The client goes to cifs_file_aio_write and appears in the secton:

+       if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) == 0) {
+               written = generic_file_aio_write(iocb, iov, nr_segs, pos);
+               filemap_write_and_wait(inode->i_mapping);
+               return written;
+       }

Then it call generic_file_aio_write that stores the data in the cache
and calls cifs_write_end. This scenario again is the same as we have
now. So, nothing changes.

So, this is the description of the strict cache mode. I will answer to
your questions in the next email.

-- 
Best regards,
Pavel Shilovsky.
