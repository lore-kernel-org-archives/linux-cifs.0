From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #8)
Date: Tue, 8 Mar 2011 10:36:49 -0500
Message-ID: <20110308103649.37f17ac2@tlielax.poochiereds.net>
References: <1299559627-15554-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110308092717.71193aef@tlielax.poochiereds.net>
	<AANLkTikyLVRNnEwiMsZiNY42WmXwq02LyzX=tFVmRRXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikyLVRNnEwiMsZiNY42WmXwq02LyzX=tFVmRRXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 8 Mar 2011 09:23:34 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:


> I was trying to avoid 'taking spinlock and searching through the tree' twice.

You should only have to search the tree twice when there is no entry
present. The cost of searching the tree will be minimal vs. the cost of
allocating memory and performing an upcall.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
