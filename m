From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/3] CIFS: New read cache mechanism
Date: Tue, 28 Sep 2010 19:18:54 -0400
Message-ID: <20100928231854.GA16622@infradead.org>
References: <AANLkTi=U-4Go7jzMJWQ61j+2v1GXJoMFn5MLUNA4MZ-U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=U-4Go7jzMJWQ61j+2v1GXJoMFn5MLUNA4MZ-U-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Sep 27, 2010 at 10:31:54PM +0400, Pavel Shilovsky wrote:
> Add cifs_sync_read call to provide reading from the cache if we have at least
> Level II oplock and otherwise - reading from the server.

This still gives inconsistent results for aio or vectored reads.
