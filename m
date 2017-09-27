From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cifs: handle large EA requests more gracefully in smb2+
Date: Tue, 26 Sep 2017 23:32:21 -0700
Message-ID: <20170927063221.GA11315@infradead.org>
References: <20170927062001.979-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170927062001.979-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 27, 2017 at 04:20:01PM +1000, Ronnie Sahlberg wrote:
> The maximum is currently set to 64kb almost arbitrarily. 64kb is
> the maximum size of all xattrs under XFS so at least for
> samba + XFS (or EXT4) servers we will not be able to write so many
> EAs that we no longer can list them any more.

This description looks confusing.

For XFS the limits is 64kb for each individual xattr, not for all attrs.

But your patch seems to be about the listxattr path anyway if I read
it correctly.  There the VFS exposes a limit of XATTR_LIST_MAX,
which also happens to be 64kb for the buffer size that contains all
the xattr _names_.  Note that XFS could support almost arbitrary large
amounts of xatttrs names (and on IRIX does), but on Linux we limit it
to this limit of the VFS listxattr interface.
