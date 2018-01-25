From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [SMB3][PATCH] cleanup some minor endian warnings in smbdirect
 (SMB3 RDMA) code.
Date: Thu, 25 Jan 2018 07:04:37 -0800
Message-ID: <20180125150437.GA19612@infradead.org>
References: <CAH2r5mvZMPmEQYSnioXvo_cXfe+fxOE_kSsOi4HnEZm6bxBTEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mvZMPmEQYSnioXvo_cXfe+fxOE_kSsOi4HnEZm6bxBTEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jan 24, 2018 at 11:18:59PM -0600, Steve French wrote:
> Cleans up various minor warnings that sparse endian checking showed in
> the recent SMB3 RDMA patch series

Not really minor for big endian systems :)
