From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Writes greater than 64k fails with -ENOSPC
Date: Tue, 29 Jan 2013 19:29:13 -0500
Message-ID: <20130129192913.4942c635@tlielax.poochiereds.net>
References: <5107BF75.704@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5107BF75.704-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 29 Jan 2013 17:54:21 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> Hi all,
> 
> I'm looking into a report on 3.0 based kernel (plus stable fixes)
> where writes greater than 64k to a NAS (Hitachi NAS) is failing
> (simple dd). The problem was not seen with a 2.6.32-ish kernel.
> Also, note that the problem is not seen with other Servers such
> as Windows 2003 or Windows 8 Servers.
> 
> The strace output shows the close() fall fails with -ENOSPC. 
> 
> The relevant cFYI snip
> 
> Jan 23 08:31:45 vsusix02 kernel: [1003552.227274] /usr/src/packages/BUILD/kernel-default-3.0.42/linux-3.0/fs/cifs/transport.c: For smb_command 47
> Jan 23 08:31:45 vsusix02 kernel: [1003552.227277] /usr/src/packages/BUILD/kernel-default-3.0.42/linux-3.0/fs/cifs/transport.c: Sending smb:  total_len 127044
> Jan 23 08:31:45 vsusix02 kernel: [1003552.345848] /usr/src/packages/BUILD/kernel-default-3.0.42/linux-3.0/fs/cifs/connect.c: rfc1002 length 0x33
> Jan 23 08:31:45 vsusix02 kernel: [1003552.393906] /usr/src/packages/BUILD/kernel-default-3.0.42/linux-3.0/fs/cifs/cifssmb.c: async write at 1015808 8192 bytes
> Jan 23 08:31:45 vsusix02 kernel: [1003552.393911] /usr/src/packages/BUILD/kernel-default-3.0.42/linux-3.0/fs/cifs/transport.c: For smb_command 47
> Jan 23 08:31:45 vsusix02 kernel: [1003552.393914] /usr/src/packages/BUILD/kernel-default-3.0.42/linux-3.0/fs/cifs/transport.c: Sending smb:  total_len 8260
> Jan 23 08:31:45 vsusix02 kernel: [1003552.479378] /usr/src/packages/BUILD/kernel-default-3.0.42/linux-3.0/fs/cifs/connect.c: rfc1002 length 0x33
> Jan 23 08:31:45 vsusix02 kernel: [1003552.481215] /usr/src/packages/BUILD/kernel-default-3.0.42/linux-3.0/fs/cifs/connect.c: rfc1002 length 0x33
> Jan 23 08:31:45 vsusix02 kernel: [1003552.481260] /usr/src/packages/BUILD/kernel-default-3.0.42/linux-3.0/fs/cifs/file.c: Flush inode ffff88004e1655c0 file ffff8800379d48c0 rc -28
> 
> 
> The problem seems to be that during close(), we try to flush the
> buffers by calling cifs_flush() which in turn will call
> filemap_write_and_wait() to wait on the pages under writeback to
> complete. do_writepages() will invoke cifs_writepages() which is 
> perhaps returning -ENOSPC and it is propagated back.
> 
> There are no quota restrictions or disk space problems. The
> tcpdump output doesn't show any errors during the write or close.
> 
> I'm not sure what could be causing the problem and would
> appreciate any clues or debugging suggestions.
> 
> Thanks
> 

I'd look for "short" write replies. We have this in
cifs_writev_callback:

                if (written < wdata->bytes)
                        wdata->result = -ENOSPC;

IIRC, this is spelled out in MS-CIFS in the section on WRITE_ANDX
responses, but I remember it not being 100% clear...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
