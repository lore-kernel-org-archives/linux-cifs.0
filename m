From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [[PATCH v1] 04/37] [CIFS] SMBD: Define per-channel SMBD
 transport parameters and default values
Date: Sun, 13 Aug 2017 03:11:56 -0700
Message-ID: <20170813101156.GB17287@infradead.org>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-5-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501704648-20159-5-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> +/*
> + * Per RDMA transport connection parameters
> + * as defined in [MS-SMBD] 3.1.1.1
> + */
> +static int receive_credit_max = 512;
> +static int send_credit_target = 512;
> +static int max_send_size = 8192;
> +static int max_fragmented_recv_size = 1024*1024;
> +static int max_receive_size = 8192;

Are these protocol constants?  If so please use either #defines
or enums with upper case names for them.

> +// maximum number of SGEs in a RDMA I/O

Please always use /* ... */ style comments in the kernel.
