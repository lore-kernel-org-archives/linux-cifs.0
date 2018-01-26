From: =?iso-8859-1?Q?Andr=E9s?= Souto <kai670-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: add .splice_write
Date: Fri, 26 Jan 2018 19:13:20 +0100
Message-ID: <20180126181320.hc3sz4hyrfytj5d2@Dell-XPS-L322X>
References: <20171228132308.5709-1-kai670@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171228132308.5709-1-kai670-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I want to explain a bit what is the problem this patch solves.

Without it, I always obtain a transfer rate below 9MB/s when writing to a cifs share using splice syscall independently of the buffer size used. However, when reading from the cifs share, I obtain around 105 MB/s.

After applying the patch, the transfer rate I obtain writing to the cifs share depending on the buffer size is:

blocksize (kB)| transfer rate (MB/s)
--------------+----------------------
           64 | 51.52
          128 | 65.41
          256 | 76.64
          512 | 85.72
         1024 | 90.21
