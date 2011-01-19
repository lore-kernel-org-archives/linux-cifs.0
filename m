From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] cifs: use get/put_unaligned functions to access
 ByteCount
Date: Wed, 19 Jan 2011 10:40:47 -0500
Message-ID: <20110119104047.47e4f050@tlielax.poochiereds.net>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
	<1295382799-7902-2-git-send-email-jlayton@redhat.com>
	<AANLkTi=XsEtjps=hq897Rt+akT9F-Toe1bpRuT=aMqPO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=XsEtjps=hq897Rt+akT9F-Toe1bpRuT=aMqPO-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 19 Jan 2011 09:33:47 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 
> Should get_bcc* and put_bcc* functions be renamed to respective
> get_bcc16* and put_bcc16* respectively (or something like that)
> in case there is a need to have similar functions for four bytes fields?

get/put_bcc are for the ByteCount field specifically and that's always
2 bytes.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
