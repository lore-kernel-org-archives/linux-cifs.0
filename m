From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH][SMB3] Cleanup sparse file support by creating worker
 function for it
Date: Fri, 15 Aug 2014 11:51:52 +0200
Message-ID: <20140815115152.6e20e542@f163.suse.de>
References: <CAH2r5msUgxmikvOmirUfceCubUek8+AaCv6RcJoU6mcrJ9j=sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msUgxmikvOmirUfceCubUek8+AaCv6RcJoU6mcrJ9j=sg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 14 Aug 2014 16:44:15 -0500, Steve French wrote:

> Simply move code to new function (for clarity).  The new function
> sets or clears the sparse file attribute flag.
> 
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/smb2ops.c | 82 ++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 51 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 7463436..04a86cc 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -731,6 +731,54 @@ smb2_sync_write(const unsigned int xid, struct
> cifsFileInfo *cfile,
>      return SMB2_write(xid, parms, written, iov, nr_segs);
>  }
> 
> +/* Set or clear the SPARSE_FILE attribute based on value passed in setsparse */
> +static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
> +        struct cifsFileInfo *cfile, struct inode *inode, __u8 setsparse)
> +{
> +    struct cifsInodeInfo *cifsi;
> +    int rc;
> +
> +    cifsi = CIFS_I(inode);
> +
> +    /* if file already sparse don't bother setting sparse again */
> +    if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) && setsparse)
> +        return true; /* already sparse */
> +
> +    if (!(cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) && !setsparse)
> +        return true; /* already not sparse */
> +
> +

Drop one of the empty lines above. Looks good otherwise.

Reviewed-by: David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Cheers, David
