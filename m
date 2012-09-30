From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix possible freed pointer dereference in CIFS_SessSetup
Date: Sun, 30 Sep 2012 18:54:14 -0500
Message-ID: <CAH2r5mt6mfC8Y_bXbviMYXW-L3rSyiBK5zzdPcO7d38Um+NK0Q@mail.gmail.com>
References: <1348556409-10339-1-git-send-email-piastry@etersoft.ru>
	<1348556409-10339-2-git-send-email-piastry@etersoft.ru>
	<CAH2r5mtosT4Ws0ChJsmxjyoDikvFhoq8ANNg+=AAFDk+UnrRxA@mail.gmail.com>
	<CAKywueS=V4=rVGtersG=N34qHx=SXEvum9mRNGEzX+h+ZAE92g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueS=V4=rVGtersG=N34qHx=SXEvum9mRNGEzX+h+ZAE92g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Sep 27, 2012 at 3:17 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> 2012/9/27 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> merged into cifs-2.6.git (along with the other two in this
>
> What do you think about Cc'ing it to stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org as well?

I don't think it is necessary but if you think a problem is
reproducible let me know.  In the case where

           resp_buf_type == CIFS_NO_BUFFER

then we have iov pointing to the original request and therefore

    smb_buf->Status.CifsError ==
                        cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED

will never be true  Your code (adding the check for resp_buf_type)
makes it cleaner and better, but  I don't see how we can end up
oopsing or falling into this section of code accidentally with the
previous version.
-- 
Thanks,

Steve
