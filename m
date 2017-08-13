From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [[PATCH v1] 08/37] [CIFS] SMBD: Define packet format for SMBD
 data transfer message
Date: Sun, 13 Aug 2017 03:15:10 -0700
Message-ID: <20170813101510.GC17287@infradead.org>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-9-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501704648-20159-9-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> +// SMBD data transfer packet with payload [MS-SMBD] 2.2.3
> +struct smbd_data_transfer {
> +	__le16 credits_requested;
> +	__le16 credits_granted;
> +	__le16 flags;
> +	__le16 reserved;
> +	__le32 remaining_data_length;
> +	__le32 data_offset;
> +	__le32 data_length;
> +	__le32 padding;
> +	char buffer[0];

Please use the actually standardized [] syntax for variable sized
arrays.  Also normally this would be a __u8 to fit with the other
types, but I haven't seen the usage yet.

> +} __packed;

The structure is natually packed already, no need to add the
attribute.
