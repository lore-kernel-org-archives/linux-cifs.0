From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs aio_write improvements
Date: Wed, 21 Mar 2012 16:37:17 -0400
Message-ID: <20120321163717.6b62c1a0@redhat.com>
References: <CAH2r5msS3P-FRPyg_+vNq07h=VusE-yAPAuw6pVBVicK2R95HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msS3P-FRPyg_+vNq07h=VusE-yAPAuw6pVBVicK2R95HQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 21 Mar 2012 12:43:34 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Do you have any test cases which we could use to measure performance
> improvement for this?
> 
> The user space calls for vectored async i/o in linux are confusing.
> 

Do you mean the cifs_iovec_write change?

Mount a share with strictcache and disable oplocks. Then measure the
streaming write throughput. I saw about a 20% improvement in my testing
back in late January/early February.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
