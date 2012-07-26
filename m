From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH Backport for 3.4.x] cifs: when CONFIG_HIGHMEM is set,
 serialize the read/write kmaps
Date: Thu, 26 Jul 2012 14:11:20 -0700
Message-ID: <20120726211120.GA25452@kroah.com>
References: <1342793076-18280-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1342793076-18280-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jul 20, 2012 at 10:04:36AM -0400, Jeff Layton wrote:
> This is a backport of commit 3cf003c08be785af4bee9ac05891a15bcbff856a
> for 3.4-stable.

Thanks, now applied.

greg k-h
