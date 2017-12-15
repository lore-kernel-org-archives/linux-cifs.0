From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix missing put_xid in cifs_file_strict_mmap
Date: Fri, 15 Dec 2017 13:10:19 -0800
Message-ID: <20171215211019.GB309@bombadil.infradead.org>
References: <20171215204832.12764-1-willy@infradead.org>
 <CAH2r5msFC7vzMfyMwCSf7Lq=trqcyofTBKnZ2t2F945YwwdeuQ@mail.gmail.com>
 <20171215205321.GA309@bombadil.infradead.org>
 <CAH2r5muhfRsUgfYPZbtgkx1sRXph+sa40y9UKU+M889PxnmwnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5muhfRsUgfYPZbtgkx1sRXph+sa40y9UKU+M889PxnmwnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Dec 15, 2017 at 02:54:54PM -0600, Steve French wrote:
> No - that is not serious - but ... trivial low risk patch ...
> 
> I would lean toward no ... unless a customer reported it

No customer report; code inspection on my part.
