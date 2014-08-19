From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Incorrect error returned on setting file
 compressed on SMB2
Date: Tue, 19 Aug 2014 11:34:38 +0200
Message-ID: <20140819113438.195e3ac9@plati.site>
References: <CAH2r5muLY2X17Gdg-VyMX=3X-Dg-xtQ_LozMDrsvWFqPYQ+jZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muLY2X17Gdg-VyMX=3X-Dg-xtQ_LozMDrsvWFqPYQ+jZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 18 Aug 2014 22:33:06 -0500, Steve French wrote:

> When the server (for an SMB2 or SMB3 mount) doesn't support
> an ioctl (such as setting the compressed flag
> on a file) we were incorrectly returning EIO instead
> of EOPNOTSUPP, this is confusing e.g. doing chattr +c to a file
> on a non-btrfs Samba partition, now the error returned is more
> intuitive to the user.
> 
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>

Looks like the cifs_hardlink() -EIO to -EOPNOTSUPP mapping logic could
potentially also be removed with this change.

Cheers, David
