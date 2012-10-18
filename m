From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] cifs: simplify id_to_sid and sid_to_id mapping code
Date: Thu, 18 Oct 2012 16:42:06 -0400
Message-ID: <20121018164206.57b9bbac@tlielax.poochiereds.net>
References: <1350497343-7155-1-git-send-email-jlayton@redhat.com>
	<1350497343-7155-6-git-send-email-jlayton@redhat.com>
	<CADT32eLyF-FGKYxdYJibm8jOq0ofO_cNOMChG9qQ1zNxpZJhVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLyF-FGKYxdYJibm8jOq0ofO_cNOMChG9qQ1zNxpZJhVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 18 Oct 2012 14:51:03 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Oct 17, 2012 at 1:09 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 

[...]

> 
> All the patches look correct except this question, would not this key_put
> call end up purging the mapping from the cache.  In the current code
> this is OK since cifsacl has its own cache but once it gone, we are
> relying on keys API cache to provide mapping.
> 

No. The key (aka cache entry) will not garbage collected from the cache
(aka the keyring) until it has expired and all references are put.
Currently, I don't think we're setting any expiry on the key, which I
think means that it'll live in the cache indefinitely.

That does bring up a good point though. We should probably allow these
to eventually expire. That's fairly simple to implement though -- any
time we do a request key, we can just reset the timeout to some point
in the future. I'll plan to add that in.

Thanks for the review.
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
