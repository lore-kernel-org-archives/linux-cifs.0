From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Date: Mon, 10 Dec 2012 11:41:16 -0500
Message-ID: <20121210164116.GC13327@fieldses.org>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
 <20121207161602.GA17710@infradead.org>
 <495d17310e0a687d446afc86def0f058@office.etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <495d17310e0a687d446afc86def0f058-Gr3b2bv8/haq3CaADJ+gRi8mxiWnj2XH@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Dec 08, 2012 at 12:43:14AM +0400, Pavel Shilovsky wrote:
> The problem is the possibility of denial-of-service attacks here. We
> can try to prevent them by:
> 1) specifying an extra security bit on the file that indicates that
> share flags are accepted (like we have for mandatory locks now) and
> setting it for neccessary files only, or
> 2) adding a special mount option (but it it probably makes sense if
> we decided to add this support for CIFS and NFS only).

In the case of knfsd and samba exporting a common filesystem, you'd also
want to be able to enforce it on the exported filesystem.

--b.
