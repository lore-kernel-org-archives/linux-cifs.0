From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Mon, 28 Nov 2011 15:32:07 -0500
Message-ID: <20111128153207.163adbfe@tlielax.poochiereds.net>
References: <4ED3017A.9030502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ED3017A.9030502-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 28 Nov 2011 03:35:22 +0000
jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:


--------------[snip]----------------
> [92841.247667] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS: in 
> cifs_get_tcon as Xid: 54 with uid: 0
> [92841.247673] /build/buildd/linux-3.0.0/fs/cifs/transport.c: For 
> smb_command 117
> [92841.247677] /build/buildd/linux-3.0.0/fs/cifs/transport.c: Sending 
> smb:  total_len 90
> [92841.248606] /build/buildd/linux-3.0.0/fs/cifs/connect.c: rfc1002 
> length 0x27
> [92841.248620] /build/buildd/linux-3.0.0/fs/cifs/transport.c: 
> cifs_sync_mid_result: cmd=117 mid=3 state=4
> [92841.248625] Status code returned 0xc0000022 NT_STATUS_ACCESS_DENIED
> [92841.248630] /build/buildd/linux-3.0.0/fs/cifs/netmisc.c: Mapping smb 
> error code 0xc0000022 to POSIX err -13
> [92841.248635] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS VFS: 
> leaving cifs_get_tcon (xid = 54) rc = -13
> [92841.248639] /build/buildd/linux-3.0.0/fs/cifs/connect.c: CIFS Tcon rc 
> = -13
--------------[snip]----------------

Looks like the tree connect is falling down. Does the user you're
connecting as have access to the exported share? You may want to check
the logs on the NAS and see why it's rejecting the tree connect request.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
