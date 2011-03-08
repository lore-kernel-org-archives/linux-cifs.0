From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] FC: cifs: Initialized an uninitialized variable
Date: Tue, 8 Mar 2011 04:26:02 +0000
Message-ID: <20110308042601.GX22723@ZenIV.linux.org.uk>
References: <1299556809-16194-1-git-send-email-vinaysawal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vinay Sawal <vinaysawal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1299556809-16194-1-git-send-email-vinaysawal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Mar 07, 2011 at 08:00:09PM -0800, Vinay Sawal wrote:
> Removed a compile time warning by initializing an uninitialized variable.

> -	int rc;
> +	int rc = -EFAULT;

Why is that the right thing to do?  Other than "it made the compiler to
STFU, therefore it is Good(tm)", please.
