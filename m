From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/6] CIFS: Make read call work with strict cache mode
 (try #2)
Date: Mon, 29 Nov 2010 02:35:55 -0500
Message-ID: <20101129073555.GA4573@infradead.org>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
 <1290931972-2770-3-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1290931972-2770-3-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Your patch arbitrarily shortens the read to the first vector.  While
short reads for regular files are fine with Posix, it will break a lot
of userspace applications.
