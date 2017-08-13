From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [[PATCH v1] 02/37] [CIFS] SMBD: Add structure for SMBD transport
Date: Sun, 13 Aug 2017 03:10:47 -0700
Message-ID: <20170813101047.GA17287@infradead.org>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-3-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501704648-20159-3-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 02, 2017 at 01:10:13PM -0700, Long Li wrote:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> 
> Define a new structure for SMBD transport. This stucture will have all the
> information on the transport, and it will be stored in the current SMB session.
> 
> Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/cifsrdma.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cifsrdma.h | 45 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 101 insertions(+)
>  create mode 100644 fs/cifs/cifsrdma.c
>  create mode 100644 fs/cifs/cifsrdma.h
> 
> diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
> new file mode 100644
> index 0000000..a2c0478
> --- /dev/null
> +++ b/fs/cifs/cifsrdma.c
> @@ -0,0 +1,56 @@
> +/*
> + *   Copyright (C) 2017, Microsoft Corporation.
> + *
> + *   Author(s): Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> + *
> + *   This program is free software;  you can redistribute it and/or modify
> + *   it under the terms of the GNU General Public License as published by
> + *   the Free Software Foundation; either version 2 of the License, or
> + *   (at your option) any later version.
> + *
> + *   This program is distributed in the hope that it will be useful,
> + *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
> + *   the GNU General Public License for more details.
> + *
> + *   You should have received a copy of the GNU General Public License
> + *   along with this program;  if not, write to the Free Software
> + *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +#include <linux/fs.h>
> +#include <linux/net.h>
> +#include <linux/string.h>
> +#include <linux/list.h>
> +#include <linux/wait.h>
> +#include <linux/slab.h>
> +#include <linux/pagemap.h>
> +#include <linux/ctype.h>
> +#include <linux/utsname.h>
> +#include <linux/mempool.h>
> +#include <linux/delay.h>
> +#include <linux/completion.h>
> +#include <linux/kthread.h>
> +#include <linux/pagevec.h>
> +#include <linux/freezer.h>
> +#include <linux/namei.h>
> +#include <asm/uaccess.h>
> +#include <asm/processor.h>
> +#include <linux/inet.h>
> +#include <linux/module.h>
> +#include <keys/user-type.h>
> +#include <net/ipv6.h>
> +#include <linux/parser.h>

Where do all these includes come from?  It seems like most of them
are not actually used in the code.
