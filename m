From: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: handle large EA requests more gracefully in smb2+
Date: Wed, 27 Sep 2017 16:39:37 +1000
Message-ID: <CAN05THRRHui6kD3udjnNodKe92TDBN4u-ocG9Be=j2bOjZccog@mail.gmail.com>
References: <20170927062001.979-1-lsahlber@redhat.com> <20170927063221.GA11315@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170927063221.GA11315-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

My mistake.  I misremembered the limit for XFS.

Unless there are other issues in the reviews that will require a
re-spin, maybe Steve
can tweak the commit message.

regards
Ronnie Sahlberg

On Wed, Sep 27, 2017 at 4:32 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Wed, Sep 27, 2017 at 04:20:01PM +1000, Ronnie Sahlberg wrote:
>> The maximum is currently set to 64kb almost arbitrarily. 64kb is
>> the maximum size of all xattrs under XFS so at least for
>> samba + XFS (or EXT4) servers we will not be able to write so many
>> EAs that we no longer can list them any more.
>
> This description looks confusing.
>
> For XFS the limits is 64kb for each individual xattr, not for all attrs.
>
> But your patch seems to be about the listxattr path anyway if I read
> it correctly.  There the VFS exposes a limit of XATTR_LIST_MAX,
> which also happens to be 64kb for the buffer size that contains all
> the xattr _names_.  Note that XFS could support almost arbitrary large
> amounts of xatttrs names (and on IRIX does), but on Linux we limit it
> to this limit of the VFS listxattr interface.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
