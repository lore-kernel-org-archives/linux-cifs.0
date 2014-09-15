From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH][v2][CIFS] Fix setting time before epoch (negative time
 values)
Date: Mon, 15 Sep 2014 10:14:05 -0700
Message-ID: <20140915171405.GA21353@infradead.org>
References: <CAH2r5mscOTdr9WzazvhydC9DazgBs1MrEkdzQSzarF4XVmfjiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mscOTdr9WzazvhydC9DazgBs1MrEkdzQSzarF4XVmfjiA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>      /* Subtract the NTFS time offset, then convert to 1s intervals. */
> -    u64 t;
> +    s64 t = le64_to_cpu(ntutc) - NTFS_TIME_OFFSET;
> +
> +    /*

The patch looks whitespace damaged.
